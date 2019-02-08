module ActiveRecord
  module Enum
    class EnumType < Type::Value
      def assert_valid_value(value)
        nil unless value.blank? || mapping.key?(value) || mapping.value?(value)
      end
    end
  end
end
