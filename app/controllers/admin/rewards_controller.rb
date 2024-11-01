class Admin::RewardsController < Admin::AdministrationController
  #before_filter :load_business_listing
  before_filter :collection, :only => [:index]

  belongs_to :business_listing

  load_and_authorize_resource

  def create
    create! do |success, failure|
      success.html { redirect_to admin_territory_business_listing_rewards_path( @territory, @business_listing ) }
    end
  end

  def update
    update! do |success, failure|
      success.html { redirect_to admin_territory_business_listing_rewards_path( @territory, @business_listing ) }
    end
  end

  def destroy
    destroy! do |success, failure|
      success.html { redirect_to admin_territory_business_listing_rewards_path( @territory, @business_listing ) }
    end
  end

  protected

#  def build_resource
#    @reward ||= @business_listing.rewards.new(params[:reward])
#  end
#
#  def resource
#    @reward = @business_listing.rewards.find(params[:id])
#  end

  def collection
    #@rewards = @business_listing.rewards
    @rewards = end_of_association_chain.paginate( :page => params[:page], :per_page => params[:limit] || RESULT_LIMT )
  end
end