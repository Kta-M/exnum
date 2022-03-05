module ActiveRecord
  module Exnum

    def self.prepended(base)
      base.singleton_class.class_eval { self.prepend(ClassMethods) }
    end

    module ClassMethods
      def extended(base)
        base.class_attribute(:defined_params, instance_writer: false)
        base.defined_params = {}
        super(base)
      end
    end

    def inherited(base)
      base.defined_params = defined_params.deep_dup
      super
    end

    #--------------------------------------------------------------------------

    def exnum(definitions)
      enum_definitions = definitions.each_with_object({}) do |(name, values), ret|
        ret[name] = extract_enums(values)
      end
      enum(**enum_definitions)

      pram_definitions = definitions.each_with_object({}) do |(name, values), ret|
        next if %i[_prefix _suffix].include?(name)

        ret[name] = extract_params(values)
        self.send(name.to_s.pluralize).each do |k, v|
          ret[name][k.to_sym] ||= {}
          ret[name][k.to_sym][:val] = v
        end
      end

      enum_i18n(pram_definitions)
      enum_param(pram_definitions)
      enum_for_select(pram_definitions)
    end

    #++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    private
    def extract_enums(values)
      return values unless values.kind_of?(Hash)

      values.each_with_object({}) do |(field, value), ret|
        ret[field.to_sym] = (value.kind_of?(Hash) ? value[:val] : value)
      end
    end

    def extract_params(values)
      return {} unless values.kind_of?(Hash)

      target_values = values.select{|_field, value| value.kind_of?(Hash)}
      target_values.each_with_object({}) do |(field, value), ret|
        ret[field.to_sym] = value
      end
    end

    #--------------------------------------------------------------------------

    def enum_i18n(definitions)
      definitions.each do |name, values|
        enum_i18n_class_method(name, values)
        enum_i18n_instance_method(name)
      end
    end

    # define class method which returns i18n string of each satus
    def enum_i18n_class_method(name, values)
      klass = self
      method_name = "#{name.to_s.pluralize}_i18n"
      detect_enum_conflict!(name, method_name, true)
      klass.singleton_class.send(:define_method, method_name) do |&block|
        i18n_hash = ActiveSupport::HashWithIndifferentAccess.new
        values.each_with_object(i18n_hash) do |(enum_name, value), ret|
          next if block.present? && !block.call(value)
          ret[enum_name] = i18n_string(klass, name, enum_name)
        end
      end
    end

    # define instance method which returns current i18n string of the instance
    def enum_i18n_instance_method(name)
      klass = self
      method_name = "#{name}_i18n"
      detect_enum_conflict!(name, method_name, false)
      klass.send(:define_method, method_name) do
        status = self.send(name)
        status.nil? ? nil : klass.send(:i18n_string, klass, name, status)
      end
    end

    def i18n_string(klass, name, enum_name)
      I18n.t("#{klass.i18n_scope}.enum.#{klass.model_name.i18n_key}.#{name}.#{enum_name}")
    end

    #--------------------------------------------------------------------------

    def enum_param(definitions)
      klass = self
      klass.defined_params.merge!(definitions)

      definitions.each do |name, values|
        param_names = values.values.map(&:keys).flatten.uniq
        param_names.each do |param_name|
          enum_param_class_method(name, values, param_name)
          enum_param_instance_method(name, values, param_name)
        end
      end
    end

    # define class methods which returns the parameter's values of each status
    def enum_param_class_method(name, values, param_name)
      klass = self
      method_name = "#{name}_#{param_name.to_s.pluralize}"
      detect_enum_conflict!(name, method_name, true)
      klass.singleton_class.send(:define_method, method_name) do |&block|
        param_hash = ActiveSupport::HashWithIndifferentAccess.new
        values.each_with_object(param_hash) do |(enum_name, params), ret|
          next if block.present? && !block.call(params)
          ret[enum_name] = params[param_name]
        end
      end
    end

    # define instance methods which returns the parameter's current value of the instance
    def enum_param_instance_method(name, values, param_name)
      method_name = "#{name}_#{param_name}"
      detect_enum_conflict!(name, method_name, false)
      define_method(method_name) do
        status = self.send(name)
        return if status.nil?
        defined_params[name][status.to_sym][param_name]
      end
    end

    #--------------------------------------------------------------------------

    def enum_for_select(definitions)
      definitions.each do |name, values|
        param_names = values.values.map(&:keys).flatten.uniq
        param_names.each do |param_name|
          enum_for_select_class_method(name, values, param_name)
        end
      end
    end

    # define class methods which returns the array for select box
    def enum_for_select_class_method(name, values, param_name)
      klass = self
      method_name = "#{name.to_s.pluralize}_for_select"
      detect_enum_conflict!(name, method_name, true)
      klass.singleton_class.send(:define_method, method_name) do |&block|
        i18n_hash = klass.send("#{name.to_s.pluralize}_i18n", &block)
        i18n_hash.to_a.map(&:reverse)
      end
    end

  end
end

