module JSONAPI::Consumer::Resource
  module ObjectBuildConcern
    extend ActiveSupport::Concern

    included do
      class_attribute :request_new_object_on_build
    end

    module ClassMethods

      # If class attribute `request_new_object_on_build`:
      #
      # True:
      #   will send a request to `{path}/new` to get an attributes list
      #
      # False:
      #   acts as an alias for `new`
      #
      def build
        if !!self.request_new_object_on_build
          _run_request(JSONAPI::Consumer::Query::New.new(self, {})).first
        else
          new
        end
      end
    end
  end
end
