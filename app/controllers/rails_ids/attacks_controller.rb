require_dependency 'rails_ids/application_controller'

module RailsIds
  ##
  # Showing an overview of attacks, that result from events.
  # Get more information about a single attack.
  #
  class AttacksController < ApplicationController
    before_action :load_attack, only: [:show]

    def index
      @attacks = Attack.all
    end

    def show
    end

    private

    def load_attack
      @attack = Attack.find(params[:id])
    end
  end
end
