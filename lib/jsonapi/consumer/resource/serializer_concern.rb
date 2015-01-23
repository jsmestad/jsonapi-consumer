module JSONAPI::Consumer::Resource
  module SerializerConcern
    extend ActiveSupport::Concern

    def serializable_hash(options={})
      @hash = persisted? ? attributes : attributes.except(self.class.primary_key)

      self.each_association do |name, association, options|
        @hash[:links] ||= {}

        if association.respond_to?(:each)
          add_links(name, association, options)
        else
          add_link(name, association, options)
        end
        @hash.delete(:links) if @hash[:links].length == 0 && !persisted?
      end

      @hash
    end

    def add_links(name, association, options)
      @hash[:links][name] ||= []
      @hash[:links][name] += association.map do |obj|
        case obj.class
        when String, Integer
          obj
        else
          obj.to_param
        end
      end
    end

    def add_link(name, association, options)
      return if association.nil?

      @hash[:links][name] = case association.class
                            when String, Integer
                              association
                            else
                              association.to_param
                            end
    end

    def to_json(options={})
      serializable_hash(options).to_json
    end
  end
end
