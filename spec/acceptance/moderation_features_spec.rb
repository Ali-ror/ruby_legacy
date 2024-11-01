require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Monderation Features - ", %q{
  In order to moderate content in a territory
} do

  describe "As a Territory Admin" do
    background do
      u = create_territory_admin :email => "local_admin@territory.com"
      @territory = u.territories.first

      @business_listing = Factory.create :business_listing,
                                         :name => "My Business Listing",
                                         :territory => @territory
      
      @picture = Factory.create(:picture, :business_listing => @business_listing)
      @comment = Factory.create(:comment, :business_listing => @business_listing)
      
      visit admin_homepage
      login_as "local_admin@territory.com"
    end
    
    describe "moderating BUSINESS LISTINGS" do
      background do
        visit "/admin/territories/#{@territory.id}/business_listings"
      end

      it "should allow me to reject a listing" do        
        find("#business_listing_#{@business_listing.id}_state").has_content?("Pending").should == true
        click_link "Approve"
        find("#business_listing_#{@business_listing.id}_state").has_content?("Approved").should == true
      end

      it "should allow me to accept a listing" do
        find("#business_listing_#{@business_listing.id}_state").has_content?("Pending").should == true
        click_link "Reject"
        find("#business_listing_#{@business_listing.id}_state").has_content?("Rejected").should == true
      end
    end

    describe "moderating PICTURES" do
      background do
        visit "/admin/territories/#{@territory.id}/pictures"
      end

      it "should show me a list of pictures to moderate" do
        find("#picture_#{@picture.id}_state").blank? == false
      end
      
      it "should allow me to reject a picture" do
        find("#picture_#{@picture.id}_state").has_content?("Pending").should == true
        click_link "Approve"
        find("#picture_#{@picture.id}_state").has_content?("Approved").should == true
      end
      
      it "should allow me to accept a picture" do
        find("#picture_#{@picture.id}_state").has_content?("Pending").should == true
        click_link "Reject"
        find("#picture_#{@picture.id}_state").has_content?("Rejected").should == true
      end
    end

    describe "moderating COMMENTS" do
      background do
        visit "/admin/territories/#{@territory.id}/comments"
      end
      
      it "should show me a list of pictures to moderate" do
        find("#comment_#{@comment.id}_state").blank? == false
      end
      
      it "should allow me to reject a comment" do
        find("#comment_#{@comment.id}_state").has_content?("Pending").should == true
        click_link "Approve"
        find("#comment_#{@comment.id}_state").has_content?("Approved").should == true
      end
      
      it "should allow me to accept a comment" do
        find("#comment_#{@comment.id}_state").has_content?("Pending").should == true
        click_link "Reject"
        find("#comment_#{@comment.id}_state").has_content?("Rejected").should == true
      end
    end
    
  end  
end