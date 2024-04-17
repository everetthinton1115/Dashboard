class Api::V1::NftFilesController < ActionController::Base


  def show
    file = NftFile.find(params[:id].to_i)
    render json: file.link
  end

end