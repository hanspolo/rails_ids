module RailsIds
  ##
  #
  #
  class MachineLearningExample < ActiveRecord::Base
    STATUS = %w(active inactive).freeze

    validates :status, inclusion: { in: STATUS, message: '%{value} is not a valid status' }
  end
end
