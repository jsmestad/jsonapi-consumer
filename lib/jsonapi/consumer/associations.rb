module JSONAPI::Consumer
  module Associations
    autoload :BaseAssociation, 'jsonapi/consumer/associations/base_association'
    autoload :BelongsTo, 'jsonapi/consumer/associations/belongs_to'
    autoload :HasMany, 'jsonapi/consumer/associations/has_many'
    autoload :HasOne, 'jsonapi/consumer/associations/has_one'
  end
end