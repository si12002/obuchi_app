class StaticPagesController < ApplicationController
  def home
  	if signed_in?
  		@document = current_user.documents.build
  		@feed_items = current_user.feed.paginate(page: params[:page])
  	end
  end

  def about
  end
end
