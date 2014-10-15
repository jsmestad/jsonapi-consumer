module JSONAPI::Consumer::Resource
  module FindersConcern
    extend ActiveSupport::Concern

    module ClassMethods
      def find(id)
        raise Errors::NotFound if id.nil?
        response = http(:get, id, opts)
      end

      def primary_key
        @primary_key ||= :id
      end

      def primary_key=(val)
        @primary_key = val.to_sym
      end
    end

    def primary_key
      self.class.primary_key
    end
  end
end
