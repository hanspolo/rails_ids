#
class UsersController < ApplicationController
  ids_detect only: [:create], sensors: [RailsIds::Sensors::Login]

  def create
  end
end
