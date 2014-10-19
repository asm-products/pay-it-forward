module ActiveRecordExtension
  extend ActiveSupport::Concern

  def valid_attribute?(attribute_name)
    self.valid? || errors[attribute_name].blank?
  end
end

ActiveRecord::Base.send(:include, ActiveRecordExtension)
