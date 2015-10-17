require_dependency 'rails_ids/application_controller'

module RailsIds
  ##
  # Showing an overview of events, that are recognized by the detection module.
  # Read log and more information about a single event.
  #
  class EventsController < ApplicationController
    before_action :load_event, only: [:show]

    def index
      @events = Event.all
    end

    def show
    end

    private

    def load_event
      @event = Event.find(params[:id])
    end
  end
end
