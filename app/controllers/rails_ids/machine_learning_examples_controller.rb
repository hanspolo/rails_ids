require_dependency 'rails_ids/application_controller'

module RailsIds
  ##
  # Showing an overview of events, that are recognized by the detection module.
  # Read log and more information about a single event.
  #
  class MachineLearningExamplesController < ApplicationController
    before_action :load_example, only: [:edit, :update]

    def index
      @examples = MachineLearningExample.all
    end

    def new
      @example = MachineLearningExample.new
    end

    def create
      @example = MachineLearningExample.new(example_params)
      if @example.save
        flash[:notice] = t('.success')
        redirect_to machine_learning_examples_path
      else
        flash[:notice] = t('.failure')
        render :new
      end
    end

    def edit
    end

    def update
      if @example.update(example_params)
        flash[:notice] = t('.success')
        redirect_to machine_learning_examples_path
      else
        flash[:notice] = t('.failure')
        render :edit
      end
    end

    def new_import
    end

    def import
      require 'csv'
      csv = CSV.parse(params[:import], headers: false)
      csv.each do |row|
        row = row.to_a
        MachineLearningExample.create!(classifier: row[0], text: row[1], status: 'active')
      end
      redirect_to machine_learning_examples_path
    end

    private

    def load_example
      @example = MachineLearningExample.find(params[:id])
    end

    def example_params
      params.require(:machine_learning_example).permit(:text, :classifier, :status)
    end
  end
end
