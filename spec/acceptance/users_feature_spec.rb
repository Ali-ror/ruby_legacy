require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Users Feature - ", %q{
  In order to make it more accessible for a members to be added to a territory
} do
  
  describe "as Global Admin" do
    background do
      @territory_user = create_territory_admin(:email => "territory_admin@admin.com")
      @territory      = @territory_user.territories.first
      
      @non_terr_user  = create_user :email => "non_terr_user@territory.com"
      @terr_user      = create_territory_user :email => "territory_user@user.com", :territory => @territory
      
      create_user :email => "mr_test@test.com", :global_admin => true
      
      visit admin_homepage        
      login_as "mr_test@test.com"
      
      visit "/admin/users"
    end
    
    scenario "I should view a list of ALL users" do
      page.has_content?("non_terr_user@territory.com").should == true
      page.has_content?("territory_user@user").should == true
    end
    
    scenario "I should be able to search users by email", :js => true do
      fill_in "keyword",  :with => "territory_user@user"
      sleep 1
      page.has_content?("territory_user@user").should == true
    end
    
    scenario "I should be able to filter users by global admin", :js => true do
      check "global_admins"
      sleep 1
      page.has_content?("mr_test@test.com").should == true
      page.has_content?("non_terr_user@territory.com").should == false
      page.has_content?("territory_user@user").should == false
    end
    
    scenario "I should be able to filter users by local admin", :js => true do
      check "local_admins"
      sleep 1
      page.has_content?("territory_admin@admin.com").should == true
      page.has_content?("mr_test@test.com").should == false
      page.has_content?("non_terr_user@territory.com").should == false
    end
    
    describe "in context of CREATION" do
      scenario "I should add a new user" do
        click_link "Add User"
    
        fill_in "First Name", :with => "Jason"
        fill_in "Last Name",  :with => "Wilson"
        fill_in "Email",      :with => "biz_member@test.com"
        fill_in "Password",   :with => "password"
        fill_in "Confirm Password", :with => "password"

        fill_in "Address1", :with => "50 Oakwood Drive"
        fill_in "City",     :with => "Phoenix"
        fill_in "State",    :with => "Arizona"
        fill_in "Zip",      :with => "50633"
        fill_in "Country",  :with => "US"
    
        click_button "Create"
        page.has_content?("biz_member@test.com").should == true
      end
    end

    describe "in context of UPDATING" do
      scenario "I should add a new USER" do
        visit "/admin/territories/#{@territory.id}/users/#{@terr_user.id}/edit"
        fill_in "Email", :with => "changed_global_user@changed.com"
        click_button "Update"

        page.has_content?("changed_global_user@changed.com").should == true
      end
    end
  end
  
  describe "as a Territory Admin" do
    background do
      @territory_user = create_territory_admin(:email => "territory_admin@admin.com")
      @territory      = @territory_user.territories.first
      
      @non_terr_user  = create_user :email => "non_terr_user@territory.com"
      @terr_user      = create_territory_user :email => "territory_user@user.com", :territory => @territory
      
      visit admin_homepage        
      login_as "territory_admin@admin.com"

      visit "/admin/territories/#{@territory.id}/users"
    end
    
    scenario "I should view a list of TERRITORY USERS" do
      page.has_content?("non_terr_user@territory.com").should == false
      page.has_content?("territory_user@user.com").should == true
    end
    
    describe "in context of CREATION" do
      scenario "I should add a new TERRITORY USER" do
        click_link "Add User"
    
        fill_in "First Name", :with => "Jason"
        fill_in "Last Name",  :with => "Wilson"
        fill_in "Email",      :with => "biz_member@test.com"
        fill_in "Password",   :with => "password"
        fill_in "Confirm Password", :with => "password"
      
        fill_in "Address1", :with => "50 Oakwood Drive"
        fill_in "City",     :with => "Phoenix"
        fill_in "State",    :with => "Arizona"
        fill_in "Zip",      :with => "50633"
        fill_in "Country",  :with => "US"
      
        click_button "Create"
    
        page.has_content?("biz_member@test.com").should == true
      end
    end

    describe "in context of UPDATING" do
      scenario "I should UPDTE a TERRITORY USER" do
        visit "/admin/territories/#{@territory.id}/users/#{@terr_user.id}/edit"
        fill_in "Email", :with => "changed_global_user@changed.com"
        click_button "Update"

        page.has_content?("changed_global_user@changed.com").should == true
      end
    end   
  end  
end