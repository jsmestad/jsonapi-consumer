require "jsonapi/consumer/version"

require 'faraday'
require 'faraday_middleware'
require 'active_model'

require "active_support/concern"
require "active_support/core_ext"
require "active_support/inflector"

module JSONAPI
  module Consumer

  end
end

require "jsonapi/consumer/errors"

require "jsonapi/consumer/middleware"
require "jsonapi/consumer/middleware/parse_json"
require "jsonapi/consumer/middleware/raise_error"
require "jsonapi/consumer/middleware/request_headers"
require "jsonapi/consumer/middleware/request_timeout"

require "jsonapi/consumer/parser"

require "jsonapi/consumer/query"
require "jsonapi/consumer/query/base"
require "jsonapi/consumer/query/create"
require "jsonapi/consumer/query/delete"
require "jsonapi/consumer/query/find"
require "jsonapi/consumer/query/new"
require "jsonapi/consumer/query/update"

require "jsonapi/consumer/resource/association_concern"
require "jsonapi/consumer/resource/attributes_concern"
require "jsonapi/consumer/resource/connection_concern"
require "jsonapi/consumer/resource/finders_concern"
require "jsonapi/consumer/resource/object_build_concern"
require "jsonapi/consumer/resource/serializer_concern"
require "jsonapi/consumer/resource"
