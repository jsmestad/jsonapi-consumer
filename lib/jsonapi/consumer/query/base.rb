module JSONAPI::Consumer::Query
  class Base
    class << self
      attr_accessor :request_method
    end
    attr_reader :klass, :path, :headers, :params

    def initialize(klass, payload)
      @klass = klass
      build_params(payload) if payload.is_a?(Hash) && payload.keys != [klass.primary_key]

      @path = begin
                if payload.is_a?(Hash) && persisted? && payload.has_key?(klass.primary_key)
                  [klass.path, payload.fetch(klass.primary_key)].join('/')
                else
                  klass.path
                end
              end
    end

    def persisted?
      false
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
