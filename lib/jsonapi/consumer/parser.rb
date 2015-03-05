module JSONAPI::Consumer
  class Parser
    attr_reader :response, :klass

    def initialize(klass, response)
      @klass = klass
      @response = response
    end

    def attributes(item)
      item.except(:links)
    end

    def associations(item)
      associations = {}
      item.fetch(:links, {}).each do |assoc_name, ids|
        associations[assoc_name] = if ids.is_a?(Array)
                                     ids.collect {|id| find_linked(assoc_name, id) }
                                   else
                                     find_linked(assoc_name, ids)
                                   end
      end
      associations
    end

    def fetch_resource
      link_body = _body.fetch(:links, {})

      links = {}

      link_body.each do |key, url|
        links[key.split('.').last] = url
      end

      links
    end

    def fetch_linked(assoc_name, id)
      klass._association_class(assoc_name).find(id)
    end

    def find_linked(assoc_name, id)
      if found = linked.fetch(assoc_name.pluralize, []).detect {|h| h.fetch(:id) == id }
        klass._association_class(assoc_name).new(attributes(found))
      else
        fetch_linked(assoc_name, id)
      end
    end

    def linked
      linked_body = _body.fetch(:linked, {})

      linked = {}
      linked_body.each do |key, obj_attrs|
        linked[key] = obj_attrs
      end
      linked
    end

    def build
      _body.fetch(klass.json_key, []).collect do |attrs|
        attrs_hash = attributes(attrs).merge(associations(attrs))
        klass.new(attrs_hash)
      end
    end

    def _body
      response.body.with_indifferent_access
    end

    def _status
      reponse.status
    end
  end
end
