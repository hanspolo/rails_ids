require_dependency 'rails_ids/application_controller'

module RailsIds
  ##
  # Showing an overview of events, that are recognized by the detection module.
  # Read log and more information about a single event.
  #
  class EventsController < ApplicationController
    before_action :load_event, only: [:show, :verify, :deny]

    def index
      @events = Event.all
    end

    def show
    end

    def verify
      if @event.sensor == 'BlacklistInputValidation'
        MachineLearningExample.create!(text: @event.match, classifier: 0, status: 'active')
      end
      @event.update(verified: true)
      redirect_to :back
    end

    def deny
      if @event.sensor == 'BlacklistInputValidation'
        MachineLearningExample.create!(text: @event.match, classifier: 0, status: 'active')
      end
      @event.destroy!
      redirect_to :back
    end

    private

    def load_event
      @event = Event.find(params[:id])
    end
  end
end
