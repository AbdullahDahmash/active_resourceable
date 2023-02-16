module ActiveResourceable::Governable
  extend ActiveSupport::Concern

  included do

    attr_accessor :access_object

  end

  class_methods do

    def set_resourceable_default_scope
      scope :editable_for, ->(user) {
        where(false)
      }
   
      scope :readable_for, ->(user) {
        editable_for user
      }
   
      scope :deletable_for, ->(user) {
        editable_for user
      }
      scope :unpaginate, ->() {
        offset(nil).limit(nil)
      }
    end

  end

  def accessable_fields
    raise NotImplementedError
  end

end
