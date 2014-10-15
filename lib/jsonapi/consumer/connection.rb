module JSONAPI::Consumer
  module Connection
    # Perform an HTTP DELETE request
    def delete(path, params={}, request_headers=nil)
      request(:delete, path, params, request_headers)
    end

    # Perform an HTTP GET request
    def get(path, params={}, request_headers=nil)
      request(:get, path, params, request_headers)
    end

    # Perform an HTTP POST request
    def post(path, params={}, request_headers=nil)
      request(:post, path, params, request_headers)
    end

    # Perform an HTTP PUT request
    def put(path, params={}, request_headers=nil)
      request(:put, path, params, request_headers)
    end

    def request(method, path, params={}, request_headers=nil)
      params ||= {}
      raise ArgumentError, 'params must be a hash' unless params.is_a?(Hash)

      if [:post, :put].include?(method.to_sym) && params.has_key?(:body)
        connection.send(method.to_sym, path, params.delete(:body), request_headers)
      else
        connection.send(method.to_sym, path, params, request_headers)
      end
    end

  private

    def connection
      @connection ||= begin
        Faraday.new(url: self.class.host, ssl: self.class.ssl) do |conn|
          conn.request :json

          conn.response :logger
          conn.response :json, content_type: /\bjson$/

          conn.use Middleware::RaiseError
          conn.adapter Faraday.default_adapter
        end
      end
    end
  end
end
