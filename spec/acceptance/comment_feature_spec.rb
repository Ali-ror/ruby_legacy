require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Comment Feature - ", %q{
  In order to list comments on the site
} do
  
  describe "as a Global or Territory Admin" do

    background do
      u = create_territory_admin :email => "local_admin@territory.com"
      @territory = u.territories.first

      @user = Factory.create :user, :first_name => "User", :last_name => "Surfer"
      @user.user_territories.create :territory => @territory

      @business_listing = Factory.create :business_listing,
                          :name => "My Business Listing",
                          :territory => @territory
            
      visit admin_homepage
      login_as "local_admin@territory.com"
    end

    scenario "I should be able to CREATE a comment", :js => true do
      visit business_listings_page( @territory )
      click_link "Comments"
      click_link "Add Comment"
      fill_in "Comment", :with => "My detailed comment"
      select "Pending", :from => "State"
      fill_in "User", :with => "User"
      autocomplete_choose "#{@user.to_label} (#{@user.email})", :fall_field => "#comment_user_id", :fall_value => @user.id   
      select "4", :from => "Rating"
      click_button "Create"
      
      page.should have_content "Add Comment"
      page.should have_content "My detailed comment"
      page.should have_content "Edit"
      page.should have_content "Delete"
      page.should have_content "User Surfer"
      page.should have_content "Pending"
      page.should have_content "4"
    end

    scenario "I should be able to EDIT a comment" do
      c = Factory.create :comment, :user => @user, :business_listing => @business_listing

      visit business_listings_page( @territory )
      click_link "Comments"

      page.should have_content c.comment
      page.should have_content c.state
      page.should have_content c.rating.to_s
      page.should have_content @user.to_label

      click_link "Edit"
      page.has_field?( "Comment", :with => c.comment ).should be_true
      fill_in "Comment", :with => "My comment's comment"
      select "2", :from => "Rating"
      click_button "Update"

      page.should have_content "Add Comment"
      page.should have_content "My comment's comment"
      page.should have_content "Edit"
      page.should have_content "Delete"
      page.should have_content "2"
    end

    scenario "I should be able to REMOVE a comment" do
      c = Factory.create :comment, :user => @user, :business_listing => @business_listing

      visit business_listings_page( @territory )
      click_link "Comments"
      page.should have_content c.comment
      click_link "Delete"

      page.should_not have_content c.comment
    end

    scenario "I should be able to see the list of comments" do
      c1 = Factory.create :comment, :user => @user, :business_listing => @business_listing
      c2 = Factory.create :comment, :user => @user, :business_listing => @business_listing

      visit business_listings_page( @territory )
      click_link "Comments"

      [
        c1.comment, c2.comment, c1.state, c2.state, c1.rating.to_s,
        c2.rating.to_s, c1.user.to_label, c2.user.to_label
      ].each do |c|
        page.should have_content c
      end
    end

    scenario "I should be able to view a list of comments for review" do
      @comment1 = Factory.create(:comment, :business_listing => @business_listing)
      @comment2 = Factory.create(:comment, :business_listing => @business_listing)
      @comment3 = Factory.create(:comment, :business_listing => @business_listing)
      
      visit "/admin/territories/#{@territory.id}/business_listings/#{@business_listing.id}/comments"
      
      page.should have_content @comment1.comment
      page.should have_content @comment2.comment
      page.should have_content @comment3.comment
    end
    
    scenario "I should be able to approve a comment"
    scenario "I should be able to reject a comment"
    scenario "I should be able to select a collection of comments and delete them"
    scenario "I should be able to select a collection of comments and then de-select them"
  end
  
  describe "as a Consumer" do
    describe "I should be able to submit a comment on a local business for review"
  end
end