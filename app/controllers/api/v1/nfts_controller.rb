class Api::V1::NftsController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :authenticate_user, only: %i[index create show update]

  def index
    if params[:id]
      nft = Nft.where(id: params[:id].to_i).first
      if nft
        nft.update(update_params)
        render json: { success: true, message: 'Nft created successfully.' }
      else
        render json: { success: false, message: 'NFT not found' }
      end
    else
      # @nft = Nft.all.where(nft_status: ['Created', 'Purchased'])
      # @nft = current_user.nfts.where(nft_status: ['Created', 'Purchased', 'Approved', 'approved']).order(created_at: :desc)
      @nft = current_user.nfts.not_pending.order(created_at: :desc)
    end
  end

  def create
    if params[:tx_id]
      nft = Nft.where(id: params[:id]).first
      if nft
        nft.update(user_id: current_user.id)
        nft.update(update_params)
        render json: { success: true, message: "Nft updated created" }
      else
        render json: { success: false, message: "Nft not found" }
      end
      
    else
      if params[:save_to_db]
        nft = current_user.nfts.build(nft_params)
        nft.image = open(params[:image][:uri])
        if nft.save
          if params[:images]
            params[:images].each do |image|
              nft.images.create(image: image)
            end
          end
          hash = {
              name: params[:title],
              description: params[:description],
              symbol: params[:campaign_id],
              seller_fee_basis_points: params[:price],
              external_url: "",
              edition: "",
              background_color: "000000",
              image: nft.image.url,
              attributes: [
                {
                  trait_type: "project_ID",
                  value: params[:campaign_id]
                },
                {
                  trait_type: "reward"
                  # value: params[:reward_title]
                },
                {
                  trait_type: "reward-limit",
                  value: params[:redeem_limit]
                }
              ]
            }
          nft_file = NftFile.create(link: hash)
          render json: { success: true, message: request.base_url + "/api/v1/nft_files/" + nft_file.id.to_s, id: nft.id  }
        else
          render json: { success: false, message: nft.errors.full_messages.to_sentence }
        end
      else
        url = URI("https://api-eu1.tatum.io/v3/ipfs")
        https = Net::HTTP.new(url.host, url.port)
        https.use_ssl = true
        request = Net::HTTP::Post.new(url)
        request["x-api-key"] = "04835903-f93d-44ab-bcd3-dc2aa7c270b8"
        form_data = [['file', params[:image]]]
        request.set_form form_data, 'multipart/form-data'
        response = https.request(request)
        if JSON(response.body)["ipfsHash"]
          File.open("public/" + (Nft.last.id + 1).to_s + "data.json", "w") do |f|
            hash = {
              name: params[:title],
              description: params[:description],
              symbol: params[:campaign_id],
              seller_fee_basis_points: params[:price],
              external_url: "",
              edition: "",
              background_color: "000000",
              image: "https://ipfs.io/ipfs/" + JSON(response.body)["ipfsHash"],
              attributes: [
                {
                  trait_type: "project_ID",
                  value: params[:campaign_id]
                },
                {
                  trait_type: "reward"
                  # value: params[:reward_title]
                },
                {
                  trait_type: "reward-limit",
                  value: params[:redeem_limit]
                }
              ]
            }
            f.write(hash.to_json)
          end
          url2 = URI("https://api-eu1.tatum.io/v3/ipfs")
          https = Net::HTTP.new(url2.host, url2.port)
          https.use_ssl = true
          request2 = Net::HTTP::Post.new(url2)
          request2["x-api-key"] = "04835903-f93d-44ab-bcd3-dc2aa7c270b8"
          form_data = [['file', File.open("public/" + (Nft.last.id + 1).to_s + "data.json")]]
          request2.set_form form_data, 'multipart/form-data'
          response2 = https.request(request2)
          current_user.nfts.create!(nft_params.merge({ nft_hash: JSON.parse(response2.body)['ipfsHash'] }))
          render json: { success: true, data: JSON.parse(response2.body)['ipfsHash'] }

        else
          Rails.logger.info "JSON.parse(response.body)['data'] : #{JSON.parse(response.body)['data']}"
          puts "JSON.parse(response.body)['data']  : #{JSON.parse(response.body)['data']}"
          render json: { success: false, message: JSON.parse(response.body)['data'] }
        end
      end
    end
  rescue => e
    render json: { success: false, message: e.message }
  end

  def show
    begin
      nft = Nft.exists?(id: params[:id]) ? Nft.find(params[:id]) : Nft.find_by!(token: params[:id])
      if params[:redeem] == true || params[:redeem] == 'true'
        if nft.remaining_limit >= 1
          nft.update!(redeem: true, remaining_limit: (nft.remaining_limit - 1))
          render json: { success: true, message: 'NFT Redeem Successfully.' }
        else
          render json: { success: false, message: 'NFT already redeemed.' }
        end

      else
        render json: { success: true, nft_id: nft.id, token: nft.token }
      end

    rescue => e
      render json: { success: false, message: e.message }
    end
  end

  def fetch_nfts
    if params[:project_id]
      # @nft = Campaign.find(params[:project_id]).nfts.where(nft_status: ['approved', 'Created']).order(created_at: :desc)
      @nft = Campaign.find(params[:project_id]).nfts.not_pending.not_purchased.order(created_at: :desc)
      render 'api/v1/nfts/index'
    else
        # @nft = current_user.nfts.where(nft_status: 'Created').order(created_at: :desc)
        @nft = current_user.nfts.not_pending.order(created_at: :desc)
        render 'api/v1/nfts/index'
    end

  end

  def update
    nft = current_user.nfts.where(id: params[:id]).first
    if nft
      nft.update(update_params)
      render json: { success: true, message: 'Nft created successfully.' }
    else
      render json: { success: false, message: 'NFT not found' }
    end
  end

  private

  def update_params
    params.permit(:mint_id, :nft_status, :tx_id)
  end

  def nft_params
    params.permit(:title, :price, :campaign_id, :created_by, :redeem_limit, :tx_id, :description)
  end
end