module RailsIds
  ##
  #
  #
  class MachineLearningResult < ActiveRecord::Base
    STATUS = %w(old new active).freeze

    validates :status, inclusion: { in: STATUS, message: '%{value} is not a valid status' }
  end
end
