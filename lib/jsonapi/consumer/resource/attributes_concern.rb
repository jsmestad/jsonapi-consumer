module JSONAPI::Consumer::Resource
  module AttributesConcern
    extend ActiveSupport::Concern

    include ActiveModel::AttributeMethods
    include ActiveModel::Dirty

    included do
      attr_reader :attributes
    end

    def attributes=(attrs={})
      @attributes ||= {}

      return @attributes unless attrs.present?
      attrs.each do |key, value|
        set_attribute(key, value)
      end
    end

    def update_attributes(attrs={})
      self.attributes = attrs
      # FIXME save
    end

    def persisted?
      # attributes.has_key?(primary_key)
      !self.to_param.blank?
    end

    def to_param
      attributes.fetch(primary_key, '').to_s
    end

    # def [](key)
      # read_attribute(key)
    # end

    # def []=(key, value)
      # set_attribute(key, value)
    # end

    alias :respond_to_without_attributes? :respond_to?
    def respond_to?(method, include_private_methods=false)
      if super
        true
      elsif !include_private_methods && super(method, true)
        # If we're here then we haven't found among non-private methods
        # but found among all methods. Which means that the given method is private.
        false
      else
        has_attribute?(method)
      end
    end

  private

    def read_attribute(name)
      attributes.fetch(name, nil)
    end

    def set_attribute(key, value)
      attributes[key.to_sym] = value
    end

    def has_attribute?(attr_name)
      attributes.has_key?(attr_name.to_sym)
    end

  end
end
