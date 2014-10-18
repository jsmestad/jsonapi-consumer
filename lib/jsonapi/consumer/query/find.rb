module JSONAPI::Consumer::Query
  class Find < Base
    self.request_method = :get

    def initialize(klass, payload)
      super

      if payload.is_a?(String) || payload.is_a?(Integer)
        @path = [@path, payload].join('/')
      end

    end

    def build_params(args)
      @params = case args
      when Hash
        args
      when Array
        {klass.primary_key.to_s.pluralize.to_sym => args.join(",")}
      when String, Integer
        {}
      else
        {klass.primary_key => args}
      end
    end
  end
end
