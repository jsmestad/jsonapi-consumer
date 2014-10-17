module JSONAPI::Consumer::Resource
  module AssociationConcern
    extend ActiveSupport::Concern

    module ClassMethods
      attr_writer :_associations

      def has_many(*attrs)
        associate(:has_many, attrs)
      end

      def belongs_to(*attrs)
        associate(:belongs_to, attrs)
      end

      def has_one(*attrs)
        associate(:has_one, attrs)
      end

      def _associations
        @_associations ||= {}
      end

      def associate(type, attrs)
        options = attrs.extract_options!
        self._associations =  _associations.dup

        attrs.each do |attr|
          unless method_defined?(attr)
            define_method attr do
              read_association(attr)
            end
          end

          unless method_defined?(:"#{attr}=")
            define_method :"#{attr}=" do |val|
              if type == :has_many
                set_association(attr, val.nil? ? val : [val].flatten)
              else
                set_association(attr, val)
              end
            end
          end

          self._associations[attr] = {type: type, options: options}
        end
      end
    end

    def each_association(&block)
      self.class._associations.dup.each do |name, options|
        association = self.send(name)
        # TODO remove
        # serializer_class = ActiveModel::Serializer.serializer_for(association)
        # serializer = serializer_class.new(association)

        if block_given?
          block.call(name, association, options[:options])
        end
      end
    end

    def association_names
      self.class._associations.keys
    end

  protected


    def read_association(name)
      _associations.fetch(name, nil)
    end

    def set_association(key, value)
      _associations[key.to_sym] = value
    end

    def has_association?(attr_name)
      _associations.has_key?(attr_name.to_sym)
    end

  private

    def _associations
      @associations ||= {}
    end

  end
end
