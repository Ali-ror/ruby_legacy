class CommentsController < ApplicationController
  def create
    @business_listing = @territory.business_listings.find(params[:business_listing_id])
    @comment = @business_listing.comments.new(params[:comment])
    @comment.state, @comment.user = BusinessListing::PENDING, current_user
        
    if @comment.save
      flash[:success] = "Your comment has been submitted for review!"
    else
      flash[:error] = @comment.errors.full_messages.to_sentence
    end
    
    redirect_to "#{territory_business_listing_path(@business_listing.territory, @business_listing)}#reviews"
  end
end