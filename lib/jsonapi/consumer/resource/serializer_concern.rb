module JSONAPI::Consumer::Resource
  module SerializerConcern
    extend ActiveSupport::Concern

    def serializable_hash(options={})
      @hash = persisted? ? attributes : attributes.except(self.class.primary_key)

      self.each_association do |name, association, options|
        @hash[:links] ||= {}
        # unless options[:embed] == :ids
          # @hash[:linked] ||= {}
        # end

        if association.respond_to?(:each)
          add_links(name, association, options)
        else
          add_link(name, association, options)
        end
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

      # unless options[:embed] == :ids
        # @hash[:linked][name] ||= []
        # @hash[:linked][name] += association.map { |item| item.attributes(options) }
      # end
    end

    def add_link(name, association, options)
      return if association.nil?

      @hash[:links][name] = case association.class
                            when String, Integer
                              association
                            else
                              association.to_param
                            end

      # unless options[:embed] == :ids
        # plural_name = name.to_s.pluralize.to_sym

        # @hash[:linked][plural_name] ||= []
        # @hash[:linked][plural_name].push association.attributes(options)
      # end
    end

    def to_json(options={})
      serializable_hash(options).to_json
      # if json_key
        # { json_key => result }.to_json
      # else
        # result.to_json
      # end
    end

  private

    def json_key
      self.class.name.demodulize.underscore
    end
  end
end
