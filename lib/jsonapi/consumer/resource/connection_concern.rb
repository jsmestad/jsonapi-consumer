module JSONAPI::Consumer
  module ConnectionConcern
    def save
      # query = persisted? ?
        # Query::Update.new(self.class, attributes) :
        # Query::Create.new(self.class, attributes)
      query = Query::Create.new(self.class, self.serializable_hash)

      run_request(query)
    end

  private

    def run_request(query_object)
      connection.send(query_object.request_method, query_object.path, query_object.params, query_object.headers)
    end

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
