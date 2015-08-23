module SimpleActiveModelValidators
  class AssociatedBubblingValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, values)
      # values can be an array or a scalar
      [values].flatten.reject(&:valid?).each do |value|
        record.errors.add(attribute, value.errors.messages)
      end
    end
  end
end
