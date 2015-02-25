module JSONAPI::Consumer::Association
  class HasMany < Base
    module ResourceMethods
      def self.attach(resource_class, association)

        define_method association.attribute_name do
          association.read(self)
        end

        define_method :"#{association.attribute_name.to_s.singularize}_ids" do
          if objs = association.read(self)
            objs.collect {|o| o.send(o.primary_key)}
          end
        end

        define_method :"#{association.attribute_name}=" do |val|
          val = [val].flatten unless val.nil?
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
