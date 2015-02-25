module JSONAPI::Consumer::Association
  class HasMany < Base

    def read
      @value ||= []
    end

    module ResourceMethods
      def self.attach(resource_class, association_class, options)

        attribute_name = options[:attribute_name]
        define_method attribute_name do
          send("#{attribute_name}_association").read
        end

        define_method :"#{attribute_name.to_s.singularize}_ids" do
          if objs = send("#{attribute_name}_association").read
            objs.collect {|o| o.send(o.primary_key)}
          end
        end

        define_method :"#{attribute_name}=" do |val|
          val = [val].flatten unless val.nil?
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
