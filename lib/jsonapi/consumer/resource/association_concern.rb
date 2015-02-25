module JSONAPI::Consumer::Resource
  class MisconfiguredAssociation < StandardError; end

  module AssociationConcern
    extend ActiveSupport::Concern

    module ClassMethods
      attr_writer :_associations

      # Defines a has many relationship.
      #
      # @example
      #   class User
      #     include JSONAPI::Consumer::Resource
      #     has_many :articles, class_name: 'Article'
      #   end
      def has_many(*attrs)
        associate(:has_many, attrs)
      end

      # @todo belongs to is not supported yet.
      #
      def belongs_to(*attrs)
        associate(:belongs_to, attrs)
      end

      # Defines a single relationship.
      #
      # @example
      #   class Article
      #     include JSONAPI::Consumer::Resource
      #     has_one :user, class_name: 'User'
      #   end
      def has_one(*attrs)
        associate(:has_one, attrs)
      end

      # :nodoc:
      def _associations
        @_associations ||= {}
      end

      # :nodoc:
      def _association_for(name)
        _associations[name.to_sym]
      end

      # :nodoc:
      def associate(type, attrs)
        options = attrs.extract_options!

        self._associations =  _associations.dup

        attrs.each do |attr|
          association_object = (type == :has_many) ?
              ::JSONAPI::Consumer::Association::HasMany.new(self, options.merge({type: type, attribute_name: attr})) :
              ::JSONAPI::Consumer::Association::Base.new(self, options.merge({type: type, attribute_name: attr}))
          self._associations[attr] = association_object
        end
      end
    end

    # :nodoc:
    def each_association(&block)
      self.class._associations.dup.each do |name, association|
        if block_given?
          block.call(name, association.read(self), association.options)
        end
      end
    end

    # Helper method that returns the names of defined associations.
    #
    # @return [Array<Symbol>] a list of association names
    def association_names
      self.class._associations.keys
    end

  protected

    # Helper method that verifies a given association exists.
    #
    # @param attr_name [String, Symbol] the association name
    #
    # @return [true, false]
    def has_association?(attr_name)
      self.class._associations.has_key?(attr_name.to_sym)
    end

  private

    # :nodoc:
    def _cast_association(name, value)
      return if value.is_a?(Array) && _association_type(name) != :has_many
      return value if value.nil?

      association_class = _association_class_name(name)

      case value
      when association_class
        value
      when Array
        value.collect {|i| _cast_association(name, i) }
      when Hash
        association_class.new(value)
      when NilClass
        nil
      else
        association_class.new({association_class.primary_key => value})
      end
    end

    # :nodoc:
    def _association_for(name)
      self.class._association_for(name)
    end

  end
end
