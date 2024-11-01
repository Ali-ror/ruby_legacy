require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Local Site (Territory) Feature - ", %q{
  In order manage RelyLocal Territories
} do
  
  describe "As a Global Admin" do
    background do
      u = create_user(:email => "global_admin@relylocal.com", :global_admin => true)
      visit admin_homepage
      login_as "global_admin@relylocal.com"
      
      @territory  = Factory.create(:territory, :name => "Territory 1")
      @territory2 = Factory.create(:territory, :name => "Territory 2")
      
      @user = create_user :email => "tom@tom.com"
      
      visit "/admin/territories"
    end
    
    scenario "I should be able to see the list of territories" do
      page.has_content?("Territory 1").should == true
      page.has_content?("Territory 2").should == true
    end
    
    scenario "I should be able to CREATE a territory", :js => true do
      click_link "Add Territory"
      fill_in "Name",              :with => "City Name"
      fill_in "City",              :with => "Phoenix"
      select  "Arizona",           :from => "State"
      
      autocomplete_choose "tom",   :fall_field => "#territory_user_territory_local_admins_attributes_0_user_id", :fall_value => @user.id
      click_button "Create"
      
      page.has_content?("City Name").should == true
    end
        
    scenario "I should get an error if I try and create a territory with invalid data" do
      click_link "Add Territory"
            
      autocomplete_choose "tom",   :fall_field => "#territory_user_territory_local_admins_attributes_0_user_id", :fall_value => @user.id
      click_button "Create"
      
      page.has_content?("prohibited this from being saved").should == true
    end
        
    scenario "I should be able to UPDATE a territory" do
      visit "/admin/territories/#{@territory.id}/edit"
      fill_in "Name", :with => "Updated Name"
      click_button "Update"
      
      page.has_content?("Updated Name").should == true
    end
    
    scenario "I should be able to REMOVE a territory" do      
      visit "/admin/territories"
      page.has_content?("Territory 1").should == true

      click_link "Delete"
      visit "/admin/territories"
      
      page.has_content?("Territory 1").should == false
    end
    
    scenario "I should be able to filter which territories appear in the listing manager by the first letter of the territory's city" do
      Factory.create(:territory, :name => "Zoolander Falls")
      visit "/admin/territories?starts_with=B"
      page.has_content?("Zoolander Falls").should == false
      
      visit "/admin/territories?starts_with=Z"
      page.has_content?("Zoolander Falls").should == true
    end
    
    scenario "I should be able to administer a specific territory from the territory manager" do
      visit "/admin/territories/#{@territory.id}"
      page.has_content?("Territory Statistics and Summary").should == true
    end
    
    scenario "I should be able to search for territories from the territory manager"
    scenario "I should be able to download territories from the territory manager"
    scenario "I should be able to select a collection of territories and delete them"
    scenario "I should be able to select a collection of territories and then de-select them"    
  end  
end