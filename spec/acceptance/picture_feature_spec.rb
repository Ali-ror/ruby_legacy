require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Picture Feature - ", %q{ In order to manage pictures for a business listing in a territory } do

  describe "as a local territory admin" do

    #TODO: Add unhappy path tests

    background do
      u = create_territory_admin :email => "local_admin@territory.com"
      @territory = u.territories.first

      @business_listing = Factory.create :business_listing, 
        :name => "My Business Listing",
        :territory => @territory

      visit admin_homepage
      login_as "local_admin@territory.com"
    end

    scenario "I should be able to CREATE a picture" do
      visit business_listings_page( @territory )
      click_link "Pictures"
      click_link "Add Picture"
      attach_file "Picture", path_to_test_image
      fill_in "Caption", :with => "My Picture Caption"
      select "Pending"
      
      click_button "Create"
      
      page.should have_content "Add Picture"
      page.should have_content "My Picture Caption"
      page.should have_content "Edit"
      page.should have_content "Delete"
      page.should have_image test_image_alt_name
    end

    scenario "I should be able to EDIT a picture" do
      fm = Factory.create :picture, :caption => "My other Caption"
      @business_listing.pictures << fm

      visit business_listings_page( @territory )
      click_link "Pictures"

      page.should have_content "My other Caption"
      page.should have_image test_image_alt_name

      click_link "Edit"
      page.has_field?( "Caption", :with => "My other Caption" ).should be_true
      fill_in "Caption", :with => "My Picture caption"

      attach_file "Picture", path_to_test_image2
      click_button "Update"

      page.should have_content "Add Picture"
      page.should have_content "My Picture caption"
      page.should have_content "Edit"
      page.should have_content "Delete"
      page.should have_image test_image_alt_name2

      page.should_not have_image test_image_alt_name
      page.should_not have_content "My other Caption"
    end

    scenario "I should be able to REMOVE a picture" do
      fm = Factory.create :picture, :caption => "My other Caption"
      @business_listing.pictures << fm

      visit business_listings_page( @territory )
      click_link "Pictures"
      page.should have_image test_image_alt_name

      click_link "Delete"

      page.should_not have_image test_image_alt_name
    end

    scenario "I should be able to see the list of Picture" do
      fm = Factory.create :picture, :caption => "My first Caption"
      @business_listing.pictures << fm
      fm = Factory.create :picture, :caption => "My second Caption", :picture => File.open( path_to_test_image2 )
      @business_listing.pictures << fm

      visit business_listings_page( @territory )
      click_link "Pictures"
      page.should have_image test_image_alt_name
      page.should have_image test_image_alt_name2

      page.should have_content "My first Caption"
      page.should have_content "My second Caption"
    end

    scenario "I should be able to select a collection of pictures and delete them"
    scenario "I should be able to select a collection of pictures and then de-select them"
  end
end