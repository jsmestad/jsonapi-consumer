module JSONAPI::Consumer
  module ConnectionConcern
    extend ActiveSupport::Concern

    module ClassMethods
      def parse(response)
        data = response.body
        result_data = data.fetch(json_key, [])
        result_data.map {|attrs| new(attrs)}
      end

      # :nodoc:
      def _run_request(query_object)
        parse(_connection.send(query_object.request_method, query_object.path, query_object.params, query_object.headers))
      end

      # :nodoc:
      def _connection
        @connection ||= begin
          Faraday.new(url: self.host, ssl: self.ssl) do |conn|
            conn.request :json

            conn.response :logger
            conn.use Middleware::ParseJson

            conn.use Middleware::RaiseError
            conn.adapter Faraday.default_adapter
          end
        end
      end
    end

    def save
      # query = persisted? ?
        # Query::Update.new(self.class, attributes) :
        # Query::Create.new(self.class, attributes)
      query = Query::Create.new(self.class, self.serializable_hash)

      results = run_request(query)
      self.attributes = results.first.attributes
      true
    end

  private

    # :nodoc:
    def run_request(*args)
      self.class._run_request(*args)
    end
  end
end
