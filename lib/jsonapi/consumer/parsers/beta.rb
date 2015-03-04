module JSONAPI::Consumer::Parsers
  class Beta
    attr_reader :response, :klass

    def initialize(klass, response)
      @klass = klass
      @response = response
    end

    def attributes(item)
      item.except(:links, :self, :type)
    end

    def associations(item)
      associations = {}
      item.fetch(:links, {}).except(:self).each do |assoc_name, assoc_info|
        associations[assoc_name] = if assoc_info.is_a?(Hash)
                                     ids = assoc_info[:id]
                                     if ids.is_a?(Array)
                                       ids.collect {|id| find_linked(assoc_name, id) }
                                     elsif ids.is_a?(String)
                                       find_linked(assoc_name, ids)
                                     end
                                   end
      end
      associations
    end

    def fetch_resource
      raise NotImplementedError, 'this is not used in new JSONAPI'
      link_body = _body.fetch(:links, {})

      links = {}

      link_body.each do |key, url|
        links[key.split('.').last] = url
      end

      links
    end

    def fetch_linked(assoc_name, id)
      klass._association_class_name(assoc_name).find(id)
    end

    def find_linked(assoc_name, id)
      if found = linked.detect {|h| h.fetch(:id) == id and h.fetch(:type) == assoc_name.pluralize }
        klass._association_class_name(assoc_name).new(found.except(:type, :links))
      else
        raise JSONAPI::Consumer::Errors::ResponseError, "Could not find linked resource #{assoc_name.pluralize} matching identifier #{id}"
        # This means its a bad payload
        # fetch_linked(assoc_name, id)
      end
    end

    def linked
      _body.fetch(:linked, {})
    end

    def _body
      response.body.with_indifferent_access
    end

    def _status
      reponse.status
    end

    def extract
      _body.fetch(:data, []).collect do |attrs|
        attrs_hash = attributes(attrs).merge(associations(attrs))
        klass.new(attrs_hash)
      end
    end

    def build; self.extract; end

  end
end
