module JSONAPI::Consumer::Query
  class Delete < Base
    self.request_method = :delete

    def params
      nil
    end

    def persisted?
      true
    end
  end
end

