module JSONAPI::Consumer::Resource
  class MisconfiguredAssociation < StandardError; end

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

    def each_association(&block)
      self.class._associations.dup.each do |name, options|
        association = self.send(name)

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
      type = _association_type(name)
      _associations.fetch(name, nil)
    end

    def set_association(key, value)
      _associations[key.to_sym] = _cast_association(key, value)
    end

    def has_association?(attr_name)
      _associations.has_key?(attr_name.to_sym)
    end

  private

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

    def _association_for(name)
      self.class._associations[name.to_sym]
    end

    def _association_type(name)
      _association_for(name).fetch(:type)
    end

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

    def _associations
      @associations ||= {}
    end

  end
end
