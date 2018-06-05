module JSONAPI::Consumer
  module Errors
    class ApiError < StandardError
      attr_reader :env
      def initialize(message, env=nil)
        super(message)
        @env = env
      end
    end

    class ClientError < ApiError; end
    class AccessDenied < ClientError; end
    class NotAuthorized < ClientError; end
    class ConnectionError < ApiError; end

    class ServerError < ApiError
      def initialize(message, env=nil)
        super("Internal server error", env)
      end
    end

    class Conflict < ServerError
      def initialize(message, env=nil)
        super("Resource already exists", env)
      end
    end

    class NotFound < ServerError
      attr_reader :uri

      def initialize(message, uri=nil)
        super("Couldn't find resource at: #{uri.to_s}")
        @uri = uri
      end
    end

    class UnexpectedStatus < ServerError
      attr_reader :code, :uri
      def initialize(code, uri)
        super("Unexpected response status: #{code} from: #{uri.to_s}")
        @code = code
        @uri = uri
      end
    end
  end
end
