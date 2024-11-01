require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Coupon Feature - ", %q{ In order to manage coupons for a business listing in a territory } do

  describe "As a Global or Territory Admin" do
    background do
      u = create_territory_admin :email => "local_admin@territory.com"
      @territory = u.territories.first

      @business_listing = Factory.create :business_listing,
        :name => "My Business Listing",
        :territory => @territory

      visit admin_homepage
      login_as "local_admin@territory.com"
    end

    scenario "I should be able to CREATE a coupon" do
      visit business_listings_page( @territory )
      click_link "Coupons"
      click_link "Add Coupon"
      attach_file "Coupon image", path_to_test_image
      fill_in "Title", :with => "My Coupon Title"
      click_button "Create"

      page.should have_content "Add Coupon"
      page.should have_content "My Coupon Title"
      page.should have_content "Edit"
      page.should have_content "Delete"
      page.should have_image test_image_alt_name
    end

    scenario "I should be able to EDIT a coupon" do
      c = Factory.create :coupon, :title => "My other Title"
      @business_listing.coupons << c

      visit business_listings_page( @territory )
      click_link "Coupons"

      page.should have_content "My other Title"
      page.should have_image test_image_alt_name

      click_link "Edit"
      page.has_field?( "Title", :with => "My other Title" ).should be_true
      fill_in "Title", :with => "My Coupon title"

      attach_file "Coupon image", path_to_test_image2
      click_button "Update"

      page.should have_content "Add Coupon"
      page.should have_content "My Coupon title"
      page.should have_content "Edit"
      page.should have_content "Delete"
      page.should have_image test_image_alt_name2

      page.should_not have_image test_image_alt_name
      page.should_not have_content "My other Title"
    end

    scenario "I should be able to REMOVE a coupon" do
      c = Factory.create :coupon, :title => "My other Title"
      @business_listing.coupons << c

      visit business_listings_page( @territory )
      click_link "Coupons"
      page.should have_image test_image_alt_name

      click_link "Delete"

      page.should_not have_image test_image_alt_name
    end

    scenario "I should be able to see the list of Coupons" do
      c = Factory.create :coupon, :title => "My first Title"
      @business_listing.coupons << c
      c = Factory.create :coupon, :title => "My second Title", :coupon_image => File.open( path_to_test_image2 )
      @business_listing.coupons << c

      visit business_listings_page( @territory )
      click_link "Coupons"
      page.should have_image test_image_alt_name
      page.should have_image test_image_alt_name2

      page.should have_content "My first Title"
      page.should have_content "My second Title"
    end
    
    scenario "I should be able to select a collection of coupons and delete them"
    scenario "I should be able to select a collection of coupons and then de-select them"
    scenario "I should be able to mark an existing coupon as featured"
  end  
  
  describe "as a Consumer" do
    scenario "I should be able to Download a coupon"
    scenario "I should be able to Print a coupon"
    scenario "I should be able to Share a coupon"
    scenario "I should receive a reminder to review a business from a previously accessed coupon after X days"
  end
end