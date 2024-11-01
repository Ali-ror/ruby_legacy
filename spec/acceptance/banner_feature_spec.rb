require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "banner Feature - ", %q{
  In order to manage the banners
  As a local territory admin
  I want to add, see, and delete banners
} do

  describe "as a local territory admin" do

    #TODO: Add unhappy path tests

    background do
      u = create_territory_admin :email => "local_admin@territory.com"
      @territory = Factory.create :territory
      @territory.user_territory_local_admins.create :user => u

      visit admin_homepage
      login_as "local_admin@territory.com"
    end

    scenario "I should be able to CREATE a banner" do
      visit banners_page( @territory )
      click_link "Add Banner"
      attach_file "Banner", path_to_test_image
      check "Active"
      click_button "Create"

      page.should have_content "Add Banner"
      page.should have_content "Active"
      page.should have_content "Edit"
      page.should have_content "Delete"
      page.should have_image test_image_alt_name
    end

    scenario "I should be able to EDIT a banner" do
      h = Factory.create :banner, :active => true
      @territory.banners << h

      visit banners_page( @territory )

      page.should have_content "Active"
      page.should have_image test_image_alt_name

      click_link "Edit"
      has_checked_field?( "Active" ).should be_true
      uncheck( "Active" )

      attach_file "Banner", path_to_test_image2
      click_button "Update"

      page.should have_content "Add Banner"
      page.should_not have_content "Active"
      page.should have_content "Edit"
      page.should have_content "Delete"
      page.should have_image test_image_alt_name2

      page.should_not have_image test_image_alt_name
    end

    scenario "I should be able to REMOVE a banner" do
      h = Factory.create :banner
      @territory.banners << h

      visit banners_page( @territory )
      page.should have_image test_image_alt_name

      click_link "Delete"

      page.should_not have_image test_image_alt_name
    end

    scenario "I should be able to see the list of banners" do
      h1 = Factory.create :banner, :active => true
      h2 = Factory.create :banner, :active => false, :banner => File.open( path_to_test_image2 )
      @territory.banners << h1
      @territory.banners << h2

      visit banners_page( @territory )
      page.should have_image test_image_alt_name
      page.should have_image test_image_alt_name2

      page.should have_content "Active"
    end
  end
end