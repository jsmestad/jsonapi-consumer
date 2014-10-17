module JSONAPI::Consumer::Query
  class Update < Base
    self.request_method = :put

    def build_params(args)
      args = args.dup
      @params = {klass.json_key => args.except(klass.primary_key)}
    end
  end
end

