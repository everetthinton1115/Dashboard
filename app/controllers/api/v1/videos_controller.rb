class Api::V1::VideosController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :authenticate_user, only: %w[create]
  before_action :set_video, only: %w[update remove_video]

  def index
    @videos = Video.all
  end
  def create
    @video = current_user.videos.new(video_params)
    if @video.save
      render json: { success: true, message: "Video added successfully" }
    else
      render json: { success: false, message: @video.errors.full_messages.to_sentence }
    end
  end

  def update
    if @video.update(status: 1)
      render json: { success: true, message: "Video updated successfully" }
    else
      render json: { success: false, message: @video.errors.full_messages.to_sentence }
    end
  end

  def remove_video
    if @video.destroy
      render json: { success: true, message: "Video deleted successfully" }
    else
      render json: { success: false, message: @video.errors.full_messages.to_sentence }
    end
  end

  def upload_image
    begin
      image = UploadImage.create!(image: params[:image])
      render json: { success: true, message: image.image.url }
    rescue => e
      render json: { success: false, message: e.message }
    end
  end


  private

  def video_params
    params.permit(:title, :description, :video, :campaign_id)
  end

  def set_video
    begin
      @video = Video.find(params[:id])
    rescue => e
      render json: { success: false, message: e.message }
    end
  end
end