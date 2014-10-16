module JSONAPI::Consumer::Query
  class Base
    class << self
      attr_accessor :request_method
    end
    # attr_reader :klass, :headers, :path, :params
    attr_reader :klass, :headers, :path, :params

    def initialize(klass, payload)
      @klass = klass
      build_params(payload)
      # @headers = klass.default_headers.dup

      @path = klass.path
      # @path = begin
        # p = klass.path(@params)
        # if @params.has_key?(klass.primary_key) && !@params[klass.primary_key].is_a?(Array)
          # p = File.join(p, @params.delete(klass.primary_key).to_s)
        # end
        # p
      # end
    end

    def build_params(args)
      @params = args.dup
    end

    def request_method
      self.class.request_method
    end

    def inspect
      "#{self.class.name}: method: #{request_method}; path: #{path}; params: #{params}, headers: #{headers}"
    end

  end
end
