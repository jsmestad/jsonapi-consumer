module JSONAPI::Consumer
  module Middleware
    autoload :JsonRequest, 'jsonapi/consumer/middleware/json_request'
    autoload :ParseJson, 'jsonapi/consumer/middleware/parse_json'
    autoload :Status, 'jsonapi/consumer/middleware/status'
  end
end