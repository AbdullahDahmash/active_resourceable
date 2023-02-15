module ActiveResourceable::Governable
  extend ActiveSupport::Concern

  included do

    attr_accessor :access_object

#   scope :editable_for, ->(user) {
#     where(false)
#   }
#
#   scope :readable_for, ->(user) {
#     editable_for user
#   }
#
#   scope :deletable_for, ->(user) {
#     editable_for user
#   }

  end

  def accessable_fields
    raise NotImplementedError
  end

end
