module JSONAPI::Consumer
  module Middleware
    class Status < Faraday::Middleware
      def call(environment)
        @app.call(environment).on_complete do |env|
          handle_status(env[:status], env)

          # look for meta[:status]
          if env[:body].is_a?(Hash)
            code = env[:body].fetch("meta", {}).fetch("status", 200).to_i
            handle_status(code, env)
          end
        end
      rescue Faraday::ConnectionFailed, Faraday::TimeoutError
        raise Errors::ConnectionError.new(nil, environment)
      end

      protected

      def handle_status(code, env)
        case code
        when 200..399
        when 401
          raise Errors::NotAuthorized.new(nil, env)
        when 403
          raise Errors::AccessDenied.new(nil, env)
        when 404
          raise Errors::NotFound.new(nil, env[:url])
        when 409
          raise Errors::Conflict.new(nil, env)
        when 400..499
          # some other error
        when 500..599
          raise Errors::ServerError.new(nil, env)
        else
          raise Errors::UnexpectedStatus.new(code, env[:url])
        end
      end
    end
  end
end
