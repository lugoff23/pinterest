class SocializationsController < ApplicationController
  
  def like
    @user = current_user
    @post = Post.find(params[:id])
    current_user.like()
    respond_to do |format|
      format.html { redirect_to @post }
    end
  end
  
end
