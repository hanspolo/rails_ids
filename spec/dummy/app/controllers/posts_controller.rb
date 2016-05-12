#
class PostsController < ApplicationController
  ids_detect only: [:index], sensors: [RailsIds::Sensors::BlacklistInputValidation,
                                       RailsIds::Sensors::SessionIpValidation]
  ids_detect except: [:index], sensors: [RailsIds::Sensors::DefaultInputValidation]

  def index
    @posts = Post.all
    ids_detect sensors: [RailsIds::Sensors::DefaultInputValidation,
                         RailsIds::Sensors::SessionIpValidation]
  end

  def show
    ids_detect sensors: [RailsIds::Sensors::BlacklistInputValidation]
    @post = Post.find_by(id: params[:id])
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      redirect_to @post, notice: 'Post was successfully created.'
    else
      render :new
    end
  end

  private

  # Only allow a trusted parameter "white list" through.
  def post_params
    params.require(:post).permit(:title)
  end
end
