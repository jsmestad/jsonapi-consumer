require "jsonapi/consumer/version"

require 'faraday'
require 'active_model'

require "active_support/concern"
require "active_support/core_ext"
require "active_support/inflector"

module JSONAPI
  module Consumer

  end
end

require "jsonapi/consumer/connection"
require "jsonapi/consumer/errors"
require "jsonapi/consumer/middleware/raise_error"

require "jsonapi/consumer/resource/association_concern"
require "jsonapi/consumer/resource/attributes_concern"
require "jsonapi/consumer/resource/finders_concern"
require "jsonapi/consumer/resource/serializer_concern"
require "jsonapi/consumer/resource"
