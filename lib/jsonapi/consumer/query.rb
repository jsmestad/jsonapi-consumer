module JSONAPI::Consumer
  module Query
    autoload :Builder, 'jsonapi/consumer/query/builder'
    autoload :Requestor, 'jsonapi/consumer/query/requestor'
  end
end