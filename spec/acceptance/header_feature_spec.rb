require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Header Feature - ", %q{ In order to manage the headers } do
  
  describe "as a Territory Admin" do

    #TODO: Add unhappy path tests

    background do
      u = create_territory_admin :email => "local_admin@territory.com"
      @territory = Factory.create :territory
      @territory.user_territory_local_admins.create :user => u

      visit admin_homepage
      login_as "local_admin@territory.com"
    end

    scenario "I should be able to CREATE a header" do
      visit headers_page( @territory )
      click_link "Add Header"
      attach_file "Header", path_to_test_image
      fill_in "Credit", :with => "Mr. Tests's happy image factory"
      click_button "Create"

      page.should have_content "Add Header"
      page.should have_content "Mr. Tests's happy image factory"
      page.should have_content "Edit"
      page.should have_content "Delete"
      page.should have_image test_image_alt_name
    end
    
    scenario "I should be able to EDIT a header" do
      h = Factory.create :header, :credit => "Mr. Tests's happy image factory"
      @territory.headers << h

      visit headers_page( @territory )

      click_link "Edit"
      f = find_field( "Credit" )
      f.value.should eql "Mr. Tests's happy image factory"
      f.set( "Another Message for editing" )
      
      page.should have_image test_image_alt_name
      attach_file "Header", path_to_test_image2
      click_button "Update"

      page.should have_content "Add Header"
      page.should have_content "Another Message for editing"
      page.should have_content "Edit"
      page.should have_content "Delete"
      page.should have_image test_image_alt_name2

      page.should_not have_content "Mr. Tests's happy image factory"
      page.should_not have_image test_image_alt_name
    end

    scenario "I should be able to REMOVE a header" do
      h = Factory.create :header, :credit => "Mr. Tests's happy image factory"
      @territory.headers << h

      visit headers_page( @territory )
      page.should have_content "Mr. Tests's happy image factory"
      page.should have_image test_image_alt_name

      click_link "Delete"
      
      page.should_not have_content "Mr. Tests's happy image factory"
      page.should_not have_image test_image_alt_name
    end
    
    scenario "I should be able to see the list of headers" do
      h1 = Factory.create :header, :credit => "Credit 1"
      h2 = Factory.create :header, :credit => "Credit 2"
      h3 = Factory.create :header, :credit => "Credit 3", :header => File.open( path_to_test_image2 )
      @territory.headers << h1
      @territory.headers << h2
      @territory.headers << h3

      visit headers_page( @territory )
      page.should have_content "Credit 1"
      page.should have_image test_image_alt_name
      page.should have_content "Credit 2"
      page.should have_content "Credit 3"
      page.should have_image test_image_alt_name2

      all( :xpath, "//img[@alt='#{test_image_alt_name}']" ).should have( 2 ).items
    end
  end  
end