module JSONAPI::Consumer
  module Resource
    extend ActiveSupport::Concern

    included do
      extend ActiveModel::Naming

      attr_reader :errors
      class_attribute :host
    end

    include ObjectBuildConcern
    include AttributesConcern
    include AssociationConcern
    include FindersConcern
    include SerializerConcern
    include ConnectionConcern

    module ClassMethods
      def json_key
        self.name.demodulize.pluralize.underscore
      end

      def host
        @host || raise(NotImplementedError, 'host was not set')
      end

      def path
        json_key
      end

      def ssl
        {}
      end

    private

      def human_attribute_name(attr, options = {})
        attr
      end

      def lookup_ancestors
        [self]
      end
    end

    def initialize(params={})
      params.slice(*association_names).each do |key, value|
        send(:"#{key}=", value)
      end

      self.attributes = params.except(*association_names) if params
      @errors = ActiveModel::Errors.new(self)
      super()
    end

    # Returns an Enumerable of all key attributes if any is set, regardless
    # if the object is persisted or not.
    # Returns nil if there are no key attributes.
    #
    # (see ActiveModel::Conversion#to_key)
    def to_key
      to_param ? [to_param] : nil
    end

  private

    def read_attribute_for_validation(attr)
      read_attribute(attr)
    end

    def method_missing(method, *args, &block)
      if respond_to_without_attributes?(method, true)
        super
      else
        if method.to_s =~ /^(.*)=$/
          set_attribute($1, args.first)
        elsif has_attribute?(method)
          read_attribute(method)
        elsif has_association?(method)
          read_assocation(method)
        else
          super
        end
      end
    end
  end
end
