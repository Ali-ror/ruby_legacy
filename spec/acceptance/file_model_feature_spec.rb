require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "File Model Feature - ", %q{ In order to manage files for a business listing in a territory } do

  describe "As a Territory Admin" do

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

    scenario "I should be able to CREATE a file" do
      visit business_listings_page( @territory )
      click_link "Files"
      click_link "Add File"
      attach_file "File", path_to_test_image
      fill_in "Title", :with => "My File Title"
      click_button "Create"

      page.should have_content "Add File"
      page.should have_content "My File Title"
      page.should have_content "Edit"
      page.should have_content "Delete"
    end

    scenario "I should be able to EDIT a file" do
      fm = Factory.create :file_model, :title => "My other title"
      @business_listing.file_models << fm

      visit business_listings_page( @territory )
      click_link "Files"

      page.should have_content "My other title"

      click_link "Edit"
      page.has_field?( "Title", :with => "My other title" ).should be_true
      fill_in "Title", :with => "My File Title"

      attach_file "File", path_to_test_image2
      click_button "Update"

      page.should have_content "Add File"
      page.should have_content "My File Title"
      page.should have_content "Edit"
      page.should have_content "Delete"

      page.should_not have_content "My other title"
    end

    scenario "I should be able to REMOVE a file" do
      fm = Factory.create :file_model, :title => "My other title"
      @business_listing.file_models << fm

      visit business_listings_page( @territory )
      click_link "Files"

      click_link "Delete"

      page.should_not have_content "My other title"
    end

    scenario "I should be able to see the list of file" do
      fm = Factory.create :file_model, :title => "My first title"
      @business_listing.file_models << fm
      fm = Factory.create :file_model, :title => "My second title", :file_attachment => File.open( path_to_test_image2 )
      @business_listing.file_models << fm

      visit business_listings_page( @territory )
      click_link "Files"
      page.should have_content "My first title"
      page.should have_content "My second title"
    end

    scenario "I should be able to select a collection of files and delete them"
    scenario "I should be able to select a collection of files and then de-select them"
  end
end