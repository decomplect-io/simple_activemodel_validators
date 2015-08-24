module SimpleActiveModelValidators
  # Bubbles up associated validation errors on to the main model.
  # For example
  # ```ruby
  # class User < ActiveRecord::Base
  #   validates :name, presence: true
  #   has_many :comments
  #   validates_with SimpleActiveModelValidators::AssociatedBubblingValidator, attributes: [:comments]
  # end
  #
  # class Comment < ActiveRecord::Base
  #   belongs_to :user
  #   validates :body, presence: true
  # end
  #
  # user = User.new(name: 'Joe', comments: [Comment.new(body: '')])
  # user.valid?
  # user.errors.messages == { comments: ["is invalid", { body: ["can't be blank"] }] }
  # ```
  #
  # Similar to [validates_associated](1) with the extra error bubbling feature.
  # [1]: http://api.rubyonrails.org/classes/ActiveRecord/Validations/ClassMethods.html#method-i-validates_associated
  class AssociatedBubblingValidator < ActiveModel::EachValidator
    # Implements the contract of `ActiveModel::EachValidator`
    # @param record The record being validated
    # @param attribute The name of the attribute being validated
    # @param values The value of the attribute
    # @return nil
    def validate_each(record, attribute, values)
      # values can be an array or a scalar
      [values].flatten.compact.reject(&:valid?).each do |value|
        record.errors.add(attribute, value.errors.messages)
      end
    end
  end
end
