require "jsonapi/consumer/version"

require "faraday"
require "faraday_middleware"
require "addressable/uri"
require "active_support/core_ext/string"

module JSONAPI
  module Consumer

    module Associations
      autoload :BaseAssociation, 'jsonapi/consumer/associations/base_association'
      autoload :BelongsTo, 'jsonapi/consumer/associations/belongs_to'
      autoload :HasMany, 'jsonapi/consumer/associations/has_many'
      autoload :HasOne, 'jsonapi/consumer/associations/has_one'
    end

    module Helpers
      autoload :Callbacks, 'jsonapi/consumer/helpers/callbacks'
      autoload :Dirty, 'jsonapi/consumer/helpers/dirty'
      autoload :DynamicAttributes, 'jsonapi/consumer/helpers/dynamic_attributes'
      autoload :URI, 'jsonapi/consumer/helpers/uri'
    end

    module Linking
      autoload :Links, "jsonapi/consumer/linking/links"
      autoload :TopLevelLinks, "jsonapi/consumer/linking/top_level_links"
    end

    module Relationships
      autoload :Relations, "jsonapi/consumer/relationships/relations"
      autoload :TopLevelRelations, "jsonapi/consumer/relationships/top_level_relations"
    end

    module Middleware
      autoload :JsonRequest, 'jsonapi/consumer/middleware/json_request'
      autoload :ParseJson, 'jsonapi/consumer/middleware/parse_json'
      autoload :Status, 'jsonapi/consumer/middleware/status'
    end

    module Paginating
      autoload :Paginator, 'jsonapi/consumer/paginating/paginator'
    end

    module Parsers
      autoload :Parser, 'jsonapi/consumer/parsers/parser'
    end

    module Query
      autoload :Builder, 'jsonapi/consumer/query/builder'
      autoload :Requestor, 'jsonapi/consumer/query/requestor'
    end

    autoload :Connection, 'jsonapi/consumer/connection'
    autoload :Errors, 'jsonapi/consumer/errors'
    autoload :ErrorCollector, 'jsonapi/consumer/error_collector'
    autoload :Formatter, 'jsonapi/consumer/formatter'
    autoload :Implementation, 'jsonapi/consumer/implementation'
    autoload :IncludedData, 'jsonapi/consumer/included_data'
    autoload :MetaData, 'jsonapi/consumer/meta_data'
    autoload :Resource, 'jsonapi/consumer/resource'
    autoload :ResultSet, 'jsonapi/consumer/result_set'
    autoload :Schema, 'jsonapi/consumer/schema'
    autoload :Utils, 'jsonapi/consumer/utils'
  end
end