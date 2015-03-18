module JSONAPI::Consumer::Resource
  module SerializerConcern
    extend ActiveSupport::Concern

    def serializable_hash(options={})
      @hash = self.to_param.blank? ? attributes.except(self.class.primary_key) : attributes

      @hash.merge!(type: self.class.json_key)

      self.each_association do |name, association, options|
        @hash[:links] ||= {}

        if association.respond_to?(:each) or _association_type(name) == :has_many
          add_links(name, association, options)
        else
          add_link(name, association, options)
        end
        @hash.delete(:links) if remove_links?
      end

      @hash
    end

    def add_links(name, association, options)
      @hash[:links][name] ||= []
      @hash[:links][name] += (association || []).map do |obj|
        case obj.class
        when String, Integer
          {id: obj, type: _association_class_name(name).json_key }
        else
          {id: obj.to_param, type: obj.class.json_key}
        end
      end
    end

    def add_link(name, association, options)
      return if association.nil?

      @hash[:links][name] = case association.class
                            when String, Integer
                              {id: association, type: _association_class_name(name).json_key }
                            else
                              {id: association.to_param, type: association.class.json_key }
                            end
    end

    def to_json(options={})
      serializable_hash(options).to_json
    end

  private

    def remove_links?
      if persisted?
        false
      else # not persisted, new object
        if @hash[:links].length == 0 or @hash[:links].values.flatten.empty?
          true
        else
          false
        end
      end
    end
  end
end
