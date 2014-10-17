module JSONAPI::Consumer::Resource
  module FindersConcern
    extend ActiveSupport::Concern

    module ClassMethods
      def all(options={})
        _run_request(JSONAPI::Consumer::Query::Find.new(self, options))
      end

      def find(options)
        _run_request(JSONAPI::Consumer::Query::Find.new(self, options))
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
