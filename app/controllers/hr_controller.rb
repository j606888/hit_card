class HrController < ApplicationController
  def sign_in
    puts(params[:email])
    puts(params[:password])
    redirect_to home_index_path
  end
end