module JSONAPI::Consumer::Middleware
  class RequestTimeout < Faraday::Middleware
    def call(env)
      @app.call(env)
    rescue Faraday::TimeoutError
      raise JSONAPI::Consumer::Errors::ServerNotResponding
    end
  end
end
