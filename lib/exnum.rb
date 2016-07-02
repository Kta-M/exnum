require 'active_record' unless defined? ActiveRecord
require "exnum/version"
require "exnum/active_record/exnum"

ActiveRecord::Enum.prepend(ActiveRecord::Exnum)
