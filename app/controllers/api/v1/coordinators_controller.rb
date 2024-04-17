class Api::V1::CoordinatorsController < ApplicationController
  def coordinators_list
    @user_roles = UserRole.where(role_id: 10)
    @coordinators_list = []
    @user_roles.each do |role|
      @user = role.user
      @coordinators_list << @user
    end
    render json: { data: @coordinators_list }, status: 200 
  end

  def countries
    @countries = Country.all
    # render json: {
    #   data: CS.countries.sort_by{|k, v| v}
    # }
  end
end