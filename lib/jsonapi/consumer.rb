require "jsonapi/consumer/version"

require "faraday"
require "faraday_middleware"
require "addressable/uri"
require "active_support/core_ext/string"

module JSONAPI
  module Consumer
    autoload :Associations, 'jsonapi/consumer/associations'
    autoload :Attributes, 'jsonapi/consumer/attributes'
    autoload :Connection, 'jsonapi/consumer/connection'
    autoload :Errors, 'jsonapi/consumer/errors'
    autoload :ErrorCollector, 'jsonapi/consumer/error_collector'
    autoload :Formatter, 'jsonapi/consumer/formatter'
    autoload :Helpers, 'jsonapi/consumer/helpers'
    autoload :Implementation, 'jsonapi/consumer/implementation'
    autoload :IncludedData, 'jsonapi/consumer/included_data'
    autoload :Linking, 'jsonapi/consumer/linking'
    autoload :Relationships, 'jsonapi/consumer/relationships'
    autoload :LinkDefinition, 'jsonapi/consumer/link_definition'
    autoload :MetaData, 'jsonapi/consumer/meta_data'
    autoload :Middleware, 'jsonapi/consumer/middleware'
    autoload :Paginating, 'jsonapi/consumer/paginating'
    autoload :Parsers, 'jsonapi/consumer/parsers'
    autoload :Query, 'jsonapi/consumer/query'
    autoload :Resource, 'jsonapi/consumer/resource'
    autoload :ResultSet, 'jsonapi/consumer/result_set'
    autoload :Schema, 'jsonapi/consumer/schema'
    autoload :Utils, 'jsonapi/consumer/utils'
  end
end