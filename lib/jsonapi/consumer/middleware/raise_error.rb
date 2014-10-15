module JSONAPI::Consumer
  class RaiseError < Faraday::Response::Middleware
    def on_complete(env)
      return if (status = env[:status]) < 400
      message = "#{env[:status]} #{env[:method].upcase} #{env[:url]} #{env[:body]}"
      raise JSONAPI::Consumer::Errors.class_for_error_code(status).new(message, response_values(env))
    end

    def response_values(env)
      {status: env[:status], headers: env[:response_headers], body: parse_body(env[:body])}
    end

    def parse_body(body)
      if body.nil?
        nil
      else
        JSON.parse(body) rescue nil
      end
    end
  end
end
