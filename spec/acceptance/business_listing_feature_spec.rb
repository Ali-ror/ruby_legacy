require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Business Listing Feature - ", %q{
  In order to show the listing of a business to the public
} do
  
  describe "as a Territory Admin" do
    background do
      @ter_admin = create_territory_admin
      @territory = @ter_admin.territories.first

      @user = create_territory_user(:territory => @territory)
      
      @category1 = Factory.create :category
      @category2 = Factory.create :category
      
      visit admin_homepage
      login_as @ter_admin.email
      visit business_listings_page @territory
    end
    
    scenario "I should be able to CREATE a business listing", :js => true do
      click_link "Add Business Listing"

      fill_in "Listing Member", :with => @user.last_name    
      autocomplete_choose "#{@user.to_label} (#{@user.email})"
      select BusinessListing::VALID_PACKAGE_TYPES[0], :from => "Package type"

      select @category2.name, :from => "Category"

      name = "Software Development Shop"
      phone = "123 456 7890"

      fill_in "Name", :with => name
      fill_in "Phone", :with => phone

      click_button "Create"
      
      [ "Add Business Listing", name, @user.to_label, "Pending", "Edit",
        "Delete", "Comments", "Coupons", "Files", "Pictures",
        "Feature", "View Live"
      ].each do |i|
        page.should have_content i
      end
    end
    
    scenario "I should be able to EDIT a business listing" do
      bl = Factory.build :business_listing, :user_id => @user.id
      bl.business_listing_categories.build :category => @category1
      bl.territory = @territory
      bl.save.should be_true

      visit business_listings_page @territory
      click_link "Edit"

      page.should have_content "Member Information"
      page.has_select?( "Package type", :selected => bl.package_type ).should be_true
      name = "Auto Shop"

      fill_in "Name", :with => name
      click_button "Update"

      [ "Add Business Listing", name, @user.to_label, "Pending", "Edit",
        "Delete", "Comments", "Coupons", "Files", "Pictures",
        "Feature", "View Live"
      ].each do |i|
        page.should have_content i
      end
    end

    scenario "I should be able to REMOVE a business listing" do
      bl = Factory.build :business_listing, :user_id => @user.id
      bl.business_listing_categories.build :category => @category1
      bl.territory = @territory
      bl.save.should be_true

      visit business_listings_page @territory
      click_link "Delete"
      [ bl.name, @user.to_label, "Pending", "Edit",
        "Comments", "Coupons", "Files", "Pictures",
        "Feature", "View Live"
      ].each do |i|
        page.should_not have_content i
      end
      page.should have_content "Add Business Listing"
    end

    scenario "I should be able to see the list of business listings" do
      bl1 = Factory.build :business_listing, :user_id => @user.id
      bl1.business_listing_categories.build :category => @category1
      bl1.territory = @territory
      bl1.save.should be_true

      bl2 = Factory.build :business_listing, :user_id => Factory.create( :user ).id
      bl2.business_listing_categories.build :category => @category2
      bl2.territory = @territory
      bl2.save.should be_true

      visit business_listings_page @territory

      [ bl1.name, bl2.name, @user.to_label, bl2.user.to_label, "Pending", "Edit",
        "Delete", "Comments", "Coupons", "Files", "Pictures",
        "Feature", "View Live"
      ].each do |i|
        page.should have_content i
      end
    end
    
    scenario "I should NOT be able to save a business listing without a category" do
      click_link "Add Business Listing"
      
      fill_in "Listing Member", :with => @user.last_name
      autocomplete_choose "#{@user.to_label} (#{@user.email})", :fall_field => "#business_listing_user_id", :fall_value => @user.id
      select BusinessListing::VALID_PACKAGE_TYPES[0], :from => "Package type"

      name = "Software Development Shop"
      phone = "123 456 7890"

      fill_in "Name", :with => name
      fill_in "Phone", :with => phone

      click_button "Create"
      
      page.has_content?("Please fill out the following form completely to add a new business listing").should == true
    end

    scenario "I should be able to approve a pending business listing"

    scenario "I should be able to set a business listing as featured"

    scenario "I should be able to filter which business listings appear in the listing manager by the first letter of the business name"

    scenario "I should be able to search business listings from the listing manager"

    scenario "I should be able to download business listings from the listing manager"

    scenario "I should be able to select a collection of business listings and delete them"

    scenario "I should be able to select a collection of business listings and then de-select them"
  end
    
  describe "as a Consumer" do
    scenario "to be able to search and find a local business listings"
  end  
end