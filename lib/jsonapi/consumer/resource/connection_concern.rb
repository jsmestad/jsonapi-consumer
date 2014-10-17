module JSONAPI::Consumer
  module ConnectionConcern
    extend ActiveSupport::Concern

    module ClassMethods
      def parse(response)
        if response.status && response.status == 204
          true
        else
          data = response.body
          result_data = data.fetch(json_key, [])
          result_data.map do |attrs|
            attrs = attrs.dup
            if attrs.has_key?(:links)
              attrs.merge!(attrs.delete(:links))
            end
            new(attrs)
          end
        end
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
      query = persisted? ?
        Query::Update.new(self.class, self.serializable_hash) :
        Query::Create.new(self.class, self.serializable_hash)

      results = run_request(query)
      self.attributes = results.first.attributes
      true
    end

    def destroy
      if run_request(Query::Delete.new(self.class, self.serializable_hash))
        self.attributes.clear
        true
      else
        false
      end
    end

  private

    # :nodoc:
    def run_request(*args)
      self.class._run_request(*args)
    end
  end
end
