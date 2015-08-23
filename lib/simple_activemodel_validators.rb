require "simple_activemodel_validators/version"
require 'active_model'

# A collection of ActiveModel validators that don't pollute the global namespace.
module SimpleActiveModelValidators
  require 'simple_activemodel_validators/associated_bubbling_validator'
end
