require 'active_record'
require 'active_support/concern'

module ActiveRecord
  module AttributesWithDefaults
    extend ActiveSupport::Concern

    module ClassMethods

      # Set defaults. Examples:
      #   attr_default    :age, 12
      #   attr_default    :description, '(none)'
      #   attr_default    :age do |record|
      #     Time.zone.year - record.dob.year
      #   end
      #   attr_default    :description, '(none)', :if => :blank
      #   attr_default    :description, '(none)', :persisted => false
      #   attr_default    :description, :default => '(none)', :persisted => false
      def attr_default(sym, *args, &block)
        options = args.extract_options!
        default = options.delete(:default) || args.shift
        raise 'Default value or block required' unless !default.nil? || block

        evaluator = "__eval_attr_default_for_#{sym}".to_sym
        setter    = "__set_attr_default_for_#{sym}".to_sym
        block   ||= default.is_a?(Proc) ? default : proc { default }

        after_initialize setter.to_sym
        define_method(evaluator, &block)

        module_eval(<<-EVAL, __FILE__, __LINE__ + 1)
          def #{setter}
            #{'return if persisted?' if options[:persisted] == false}
            return unless self.#{sym}.send(:#{options[:if] || 'nil?'})
            value = #{evaluator}#{'(self)' unless block.arity.zero?}
            self.#{sym} = value.duplicable? ? value.dup : value
          rescue ActiveModel::MissingAttributeError
          end
        EVAL
        private evaluator, setter
      end

      # Default mass-assignment. Examples:
      #   attr_defaults   :description => '(none)', :age => 12
      #   attr_defaults   :description => '(none)', :age => lambda {|r| Time.zone.year - r.dob.year }
      #   attr_defaults   :description => '(none)', :age => { :default => 12, :persisted => false }
      def attr_defaults(pairs)
        pairs.each do |pair|
          attr_default *pair
        end
      end

    end
  end

  class Base
    include AttributesWithDefaults
  end

end
