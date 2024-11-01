class MobileApi::ReviewsController < MobileApi::BaseController

  before_filter :set_business_listing

  def index
    json = {
      :business_listing => @business_listing.long_json,
      :reviews          => @business_listing.comments.active.collect { |c|
        { :review => c.comment,
          :rating => c.rating,
          :user   => username( c.user ) }
      }
    }

    respond_with json
  end

  def create
    rating = params[:rating]
    review = params[:review]

    comment = @business_listing.comments.create :comment => review,
                                                :rating => rating,
                                                :user_id => @current_user.id,
                                                :state => BusinessListing::PENDING
    if comment.save
      render :json => { :success => true }
    else
      render :json => { :success => false,
                        :message => comment.errors.full_messages }
    end
  end

  protected

  def username( user )
    u = [ user.first_name ]
    if user.address && user.address.city
      u << user.address.city
    end
    u.join( " from " )
  end

end