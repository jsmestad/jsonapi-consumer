require 'faraday_middleware/request/encode_json'

module JSONAPI::Consumer::Middleware
  # Request middleware that encodes the body as JSON (in JSONAPI format).
  #
  # Processes only requests with matching Content-type or those without a type.
  # If a request doesn't have a type but has a body, it sets the Content-type
  # to JSON MIME-type.
  #
  # Doesn't try to encode bodies that already are in string form.
  class EncodeJsonApi < FaradayMiddleware::EncodeJson
    silence_warnings do
      FaradayMiddleware::EncodeJson::CONTENT_TYPE = 'Content-Type'.freeze
      FaradayMiddleware::EncodeJson::MIME_TYPE    = 'application/vnd.api+json'.freeze
    end
  end
end

Faraday::Request.register_middleware json_api: JSONAPI::Consumer::Middleware::EncodeJsonApi
