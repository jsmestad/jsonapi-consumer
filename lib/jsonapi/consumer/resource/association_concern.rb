module JSONAPI::Consumer::Resource
  class MisconfiguredAssociation < StandardError; end

  module AssociationConcern
    extend ActiveSupport::Concern

    module ClassMethods
      attr_writer :_association_options

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
      def _association_options
        @_associations ||= {}
      end

      # :nodoc:
      def _association_class(name)
        options = _association_options[name.to_sym]
        if options[:class_name]
          begin
            options[:class_name].constantize
          rescue NameError
            raise MisconfiguredAssociation,
                  "#{self}##{options[:type]} #{name} has a class_name specified that does not exist."
          end
        else
          raise MisconfiguredAssociation,
                "#{self}##{options[:type]} #{name} is missing an explicit `:class_name` value."
        end
      end

      # :nodoc:
      def associate(type, attrs)
        options = attrs.extract_options!.merge(type: type)

        self._association_options =  _association_options.dup

        attrs.each do |attr|
          association_class = (type == :has_many) ?
              ::JSONAPI::Consumer::Association::HasMany :
              ::JSONAPI::Consumer::Association::Base
          association_class::ResourceMethods.attach(self, association_class, options.merge(attribute_name: attr))
          self._association_options[attr] = options
        end

      end
    end

    # :nodoc:
    def each_association(&block)
      self.class._association_options.dup.each do |name, options|
        if block_given?
          block.call(name, self.send(name), options)
        end
      end
    end

    # Helper method that returns the names of defined associations.
    #
    # @return [Array<Symbol>] a list of association names
    def association_names
      self.class._association_options.keys
    end

  protected

    # Helper method that verifies a given association exists.
    #
    # @param attr_name [String, Symbol] the association name
    #
    # @return [true, false]
    def has_association?(attr_name)
      association_names.include? attr_name.to_sym
    end

  end
end
