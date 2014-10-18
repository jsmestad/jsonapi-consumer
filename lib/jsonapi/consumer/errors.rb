# JSONAPI::Consumer::Errors is responsible for wrapping API errors into a consistent
# form. Handling or Rescuing from these errors is left up to the client, but
# a possible way to do this is detailed below.
#
#  # lib/errors/rescue_error.rb
#  module Errors
#    module RescueError
#
#      def self.included(base)
#        base.rescue_from Errors::ResponseError do |e|
#          render "public/#{e.code}", :status => e.code
#        end
#      end
#
#    end
#  end
#
module JSONAPI::Consumer
  module Errors
    class ConnectionNotConfigured < StandardError; end
    class RecordNotSaved < StandardError; end

    class ServerNotResponding < StandardError
      def message
        'Server did not respond in a timely fashion. Is it running?'
      end
    end

    # Error constants
    BAD_REQUEST                     = 400
    NOT_AUTHORIZED                  = 401
    FORBIDDEN                       = 403
    NOT_FOUND                       = 404
    METHOD_NOT_ALLOWED              = 405
    BAD_FORMAT                      = 406
    REQUESTED_RANGE_NOT_SATISFIABLE = 416
    UNPROCESSABLE_ENTITY            = 422
    INTERNAL_SERVER_ERROR           = 500

    # Base subclass for all response errors
    class ResponseError < StandardError
      attr_accessor :response

      def initialize(message=nil, response=nil)
        super(message)
        self.response = response
      end

      def errors
        response[:body].fetch('errors', [])
      end

      def response_body
        response[:body]
      end
    end

    class << self

      # Returns a hash of error names to response codes.
      def error_constants
        constants.each_with_object({}) do |name, hash|
          # Ignore any class constants
          next if (code = Errors.const_get(name)).is_a?(Class)
          hash[name] = code
        end
      end

      # Returns a class name from a constant name.
      def class_name_for_error_name(name)
        name.to_s.titleize.gsub(' ', '')
      end

      # Returns the error class for a given constant name.
      # Default to InternalServerError.
      def class_for_error_name(name)
        class_name = class_name_for_error_name(name)
        const_defined?(class_name) ? Errors.const_get(class_name) : Errors::InternalServerError
      end

      # Returns the error class for a given error code.
      # Default to InternalServerError.
      def class_for_error_code(code)
        name = error_constants.select { |k, v| v == code }.keys.first
        name.present? ? class_for_error_name(name) : Errors::InternalServerError
      end
    end
  end

  # Dynamically creates a subclass of ResponseError for each error constant.
  # Adds a code method to return the correct response code.
  # Adds the new class to the constants in the Errors module.
  Errors.error_constants.each do |name, code|
    klass = Class.new(Errors::ResponseError)
    klass.send(:define_method, :code) { code }
    Errors.const_set(Errors.class_name_for_error_name(name), klass)
  end
end
