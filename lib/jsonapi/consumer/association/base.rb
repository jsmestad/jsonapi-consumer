module JSONAPI::Consumer::Association
  class Base
    attr_accessor :attribute_name, :options, :resource

    def initialize(resource, options)
      self.resource = resource
      self.options = options
      self.attribute_name = options[:attribute_name]
    end

    def read
      @value
    end

    def write(val)
      @value = cast(val)
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
      self.resource.class._association_class(self.attribute_name)
    end

    module ResourceMethods
      def self.attach(resource_class, association_class, options)

        attribute_name = options[:attribute_name]
        define_method attribute_name do
          send("#{attribute_name}_association").read
        end

        define_method :"#{attribute_name.to_s.singularize}_id" do
          if obj = send("#{attribute_name}_association").read
            obj.send(obj.primary_key)
          end
        end

        define_method :"#{attribute_name}=" do |val|
          send("#{attribute_name}_association").write(val)
        end

        define_method :"#{attribute_name}_association" do
          @_associations ||= {}
          @_associations[attribute_name] ||= association_class.new(self, options)
        end

        resource_class.include self
      end
    end

  end
end
