module JSONAPI::Consumer::Association
  class Base
    attr_accessor :attribute_name, :options, :resource_class

    def initialize(resource_class, options)
      self.resource_class = resource_class
      self.options = options
      self.attribute_name = options[:attribute_name]
      self.class::ResourceMethods.attach(resource_class, self)
    end

    def read(resource_instance)
      resource_instance._association_data[attribute_name]
    end

    def write(resource_instance, val)
      resource_instance._association_data[attribute_name] = cast(val)
    end

    def cast(value)
      return if value.is_a?(Array) && @options[:type] != :has_many
      return value if value.nil?

      association_class = _association_class

      case value
        when association_class
          value
        when Array
          value.collect {|i| cast(i) }
        when Hash
          association_class.new(value)
        when NilClass
          nil
        else
          association_class.new({association_class.primary_key => value})
      end
    end

    def _association_class
      if @options[:class_name]
        begin
          @options[:class_name].constantize
        rescue NameError
          raise MisconfiguredAssociation,
                "#{self}##{self.options[:type]} #{attribute_name} has a class_name specified that does not exist."
        end
      else
        raise MisconfiguredAssociation,
              "#{self}##{self.options[:type]} #{attribute_name} is missing an explicit `:class_name` value."
      end
    end

    module ResourceMethods
      def self.attach(resource_class, association)

        define_method association.attribute_name do
          association.read(self)
        end

        define_method :"#{association.attribute_name.to_s.singularize}_id" do
          if obj = association.read(self)
            obj.send(obj.primary_key)
          end
        end

        define_method :"#{association.attribute_name}=" do |val|
          association.write(self, val)
        end

         define_method :_association_data do
          @_association_data ||= {}
        end

        resource_class.include self
      end
    end

  end
end
