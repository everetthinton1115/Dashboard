class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :role, :profile_image, :wallet_status, :wallet_address, :limit, :name
  def profile_image
    object.profile.url(:thumb)
  end

  def role
    object.roles.first.name rescue ""
  end

  def wallet_status
    object.wallet_status
  end

end