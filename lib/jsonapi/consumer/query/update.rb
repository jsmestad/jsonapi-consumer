module JSONAPI::Consumer::Query
  class Update < Base
    self.request_method = :put

    def build_params(args)
      @params = {klass.json_key => args}
    end
  end
end

