module RailsIds
  ##
  #
  #
  class MachineLearningToken < ActiveRecord::Base
    validates :token, presence: true
  end
end
