module JSONAPI::Consumer::Query
  class Create < Base
    self.request_method = :post

    def build_params(args)
      @params = {klass.json_key => args}
    end
  end
end
