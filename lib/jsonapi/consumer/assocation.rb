module JSONAPI::Consumer::Association
  class HasMany
    attr_reader :attr_name, :klass, :options

    def initialize(attr_name, klass, options)
      @attr_name = attr_name
      @klass = klass
      @options = options
    end

    def associated_class
      @associated_class ||= options.fetch(:class_name).to_s.classify
    end

    def all

    end

    def to_s

    end
  end
end
