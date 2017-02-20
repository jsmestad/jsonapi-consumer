module JSONAPI::Consumer::Query
  class Find < Base
    self.request_method = :get

    def build_params(args)
      @params = case args
                when Hash
                  args
                when Array
                  {klass.primary_key.to_s.pluralize.to_sym => args.join(",")}
                else
                  {klass.primary_key => args}
                end
    end

    def persisted?
      true
    end
  end
end
