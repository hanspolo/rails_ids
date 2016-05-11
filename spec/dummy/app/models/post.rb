##
# Post model in the RailsIds-Testdummy.
#
class Post < ActiveRecord::Base
  # Validations
  validates :title, presence: true
end
