require_dependency 'rails_ids/application_controller'

module RailsIds
  ##
  # Dashboard that displays an information summary
  #
  class DashboardController < ApplicationController
    def show
      @attacks = Attack.all
      @events  = Event.all
    end
  end
end
