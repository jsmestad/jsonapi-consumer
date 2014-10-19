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
      def associate(type, attrs)
        options = attrs.extract_options!

        self._associations =  _associations.dup

        attrs.each do |attr|
          unless method_defined?(attr)
            define_method attr do
              read_association(attr)
            end
          end

          if type == :has_many
            unless method_defined?(:"#{attr.to_s.singularize}_ids")
              define_method :"#{attr.to_s.singularize}_ids" do
                if objs = read_association(attr)
                  objs.collect {|o| o.send(o.primary_key)}
                end
              end
            end
          else
            unless method_defined?(:"#{attr.to_s.singularize}_id")
              define_method :"#{attr.to_s.singularize}_id" do
                if obj = read_association(attr)
                  obj.send(obj.primary_key)
                end
              end
            end
          end
          unless method_defined?(:"#{attr}=")
            define_method :"#{attr}=" do |val|
              val = [val].flatten if type == :has_many && !val.nil?
              set_association(attr, val)
            end
          end

          self._associations[attr] = {type: type, options: options}
        end
      end
    end

    # :nodoc:
    def each_association(&block)
      self.class._associations.dup.each do |name, options|
        association = self.send(name)

        if block_given?
          block.call(name, association, options[:options])
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


    # Read the specified association.
    #
    # @param name [Symbol, String] the association name, `:users` or `:author`
    #
    # @return [Array, Object, nil] the value(s) of that association.
    def read_association(name)
      type = _association_type(name)
      _associations.fetch(name, nil)
    end

    # Set values for the key'd association.
    #
    # @param key [Symbol] the association name, `:users` or `:author`
    # @param value the value to set on the specified association
    def set_association(key, value)
      _associations[key.to_sym] = _cast_association(key, value)
    end


    # Helper method that verifies a given association exists.
    #
    # @param attr_name [String, Symbol] the association name
    #
    # @return [true, false]
    def has_association?(attr_name)
      _associations.has_key?(attr_name.to_sym)
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
      self.class._associations[name.to_sym]
    end

    # :nodoc:
    def _association_type(name)
      _association_for(name).fetch(:type)
    end

    # :nodoc:
    def _association_class_name(name)
      if opts = _association_for(name).fetch(:options)
        begin
          opts[:class_name].constantize
        rescue NameError
          raise MisconfiguredAssociation,
            "#{self.class}##{_association_type(name)} #{name} has a class_name specified that does not exist."
        end
      else
        raise MisconfiguredAssociation,
          "#{self.class}##{_association_type(name)} #{name} is missing an explicit `:class_name` value."
      end
    end

    # :nodoc:
    def _associations
      @associations ||= {}
    end

  end
end
