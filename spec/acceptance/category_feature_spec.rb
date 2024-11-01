require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Category Feature - ", %q{ In order to manage categories } do
  
  describe "As a Global Admin" do
    background do
      create_user :login => "mr_test", :global_admin => true
      
      @d1_cat   = Factory.create(:category, :name => "Default Cat 1")
      @d2_cat   = Factory.create(:category, :name => "Default Cat 2")
      @terr_cat = Factory.create(:category, :name => "Terr Cat 1", :territory_id => 1)
      
      visit admin_homepage
      login_as "mr_test"
      
      visit "/admin/categories"
    end
        
    scenario "I should ONLY see a list of default categories" do
      page.has_content?("Default Cat 1").should == true
      page.has_content?("Default Cat 2").should == true
      page.has_content?("Terr Cat 1").should == false
    end
    
    scenario "I should be able to CREATE default categories" do
      click_link "Add Category"
      
      fill_in "Name", :with => "New Category"
      
      click_button "Create"
      page.has_content?("New Category").should == true
    end
    
    scenario "I should be able to EDIT default categories" do
      cat = Category.find_by_name("Default Cat 1")        
      
      visit "/admin/categories/#{cat.id}/edit"        
      
      fill_in "Name", :with => "Updated Category"
      
      click_button "Update"
      
      page.has_content?("Default Cat 1").should == false
      page.has_content?("Updated Category").should == true
    end
    
    scenario "I should be able to select a collection of categories and delete them"

    scenario "I should be able to select a collection of categories and then de-select them"
  end
  
  describe "As a Territory Admin" do
    background do
      @user = create_territory_admin :login => "mr_territory_test"
      @territory = @user.territories.first
      
      @d1_cat   = Factory.create(:category, :name => "Default Cat 1")
      @d2_cat   = Factory.create(:category, :name => "Default Cat 2")
      @terr_cat = Factory.create(:category, :name => "Terr Cat 1", :territory => @territory)

      visit admin_homepage
      login_as "mr_territory_test"
      
      visit "/admin/territories/#{@territory.id}/categories"
    end
    
    scenario "I should see a list of DEFAULT categories AND CUSTOM territory categories" do      
      page.has_content?("Default Cat 1").should == true
      page.has_content?("Default Cat 2").should == true
      page.has_content?("Terr Cat 1").should == true
    end
    
    scenario "I SHOULD NOT be able to CREATE DEFAULT categories" do
      click_link "Add Category"
      fill_in "Name", :with => "Foo Category"
      click_button "Create"
      
      page.has_content?("Foo Category").should == true
    end
      
    scenario "I SHOULD be able to UPDATE TERRITORY categories" do      
      visit "/admin/territories/#{@territory.id}/categories/#{@terr_cat.id}/edit"        
      
      fill_in "Name", :with => "Updated Territory Category"
      
      click_button "Update"
      
      page.has_content?("Terr Cat 1").should == false
      page.has_content?("Updated Territory Category").should == true
    end
    
    scenario "I should be able to select a collection of categories and delete them"

    scenario "I should be able to select a collection of categories and then de-select them"
  end
end