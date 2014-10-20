module JSONAPI::Consumer::Query
  class New < Base
    self.request_method = :get

    def initialize(klass, payload)
      super
      @path = [klass.path, 'new'].join('/')
    end

    # def build_params(args)
      # @params = {klass.json_key => args}
    # end
  end
end

