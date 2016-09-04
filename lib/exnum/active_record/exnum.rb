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
      divided_definitions = definitions.inject({enums: {}, params: {}}) do |ret, (name, values)|
        if !values.kind_of?(Hash)
          ret[:enums][name]  = values
        else
          ret[:enums][name]  = extract_enums(name, values)
          ret[:params][name] = extract_params(name, values)
        end
        ret
      end

      enum(divided_definitions[:enums])
      enum_i18n(divided_definitions[:enums])
      enum_param(divided_definitions[:params])
    end

    #--------------------------------------------------------------------------

    private
    def extract_enums(_name, values)
      values.inject({}) do |ret, (field, value)|
        ret[field.to_sym] = (value.kind_of?(Hash) ? value[:val] : value)
        ret
      end
    end

    def extract_params(_name, values)
      values.inject({}) do |ret, (field, value)|
        if value.kind_of?(Hash)
          ret[field.to_sym] = value.reject{|k, _| k == :val}
        end
        ret
      end
    end

    def enum_i18n(definitions)
      klass = self
      definitions.delete(:_prefix)
      definitions.delete(:_suffix)

      definitions.each do |name, values|

        # define class method which returns i18n string of each satus
        method_name = "#{name.to_s.pluralize}_i18n"
        detect_enum_conflict!(name, method_name, true)
        klass.singleton_class.send(:define_method, method_name) do
          i18n_hash = ActiveSupport::HashWithIndifferentAccess.new
          values.inject(i18n_hash) do |ret, (enum_name, _value)|
            ret[enum_name] = i18n_string(klass, name, enum_name)
            ret
          end
        end

        # define instance method which returns current i18n string of the instance
        method_name = "#{name}_i18n"
        detect_enum_conflict!(name, method_name, false)
        klass.send(:define_method, method_name) do
          status = self.send(name)
          status.nil? ? nil : klass.send(:i18n_string, klass, name, status)
        end
      end
    end

    def i18n_string(klass, name, enum_name)
      I18n.t("#{klass.i18n_scope}.enum.#{klass.model_name.i18n_key}.#{name}.#{enum_name}")
    end

    def enum_param(definitions)
      klass = self
      klass.defined_params = definitions

      definitions.each do |name, values|
        param_names = values.values.map(&:keys).flatten.uniq
        param_names.each do |param_name|

          # define class methods which returns the parameter's values of each status
          method_name = "#{name}_#{param_name.to_s.pluralize}"
          detect_enum_conflict!(name, method_name, true)
          klass.singleton_class.send(:define_method, method_name) do
            param_hash = ActiveSupport::HashWithIndifferentAccess.new
            values.inject(param_hash) do |ret, (enum_name, params)|
              ret[enum_name] = params[param_name]
              ret
            end
          end

          # define instance methods which returns the parameter's current value of the instance
          method_name = "#{name}_#{param_name}"
          detect_enum_conflict!(name, method_name, false)
          define_method(method_name) do
            status = self.send(name)
            return if status.nil?
            defined_params[name][status.to_sym][param_name]
          end
        end
      end
    end
  end
end

