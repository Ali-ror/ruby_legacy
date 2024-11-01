require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Index/Listing Page Pagination Feature - ", %q{
  In order to limit the number of results on a page
} do
  
  describe "As a Global Admin" do
    background do
      @admin = create_user(:email => "admin@test.com", :global_admin => true)
            
      visit admin_homepage
      login_as @admin.email
    end
    
    it "TERRITORIES Listing should support pagination" do
      3.times { Factory.create(:territory) }
      visit "/admin/territories"
      page.has_content?("Next →").should == false
      
      visit "/admin/territories?limit=2"
      page.has_content?("Next →").should == true
    end
  end
  
  describe "As a Territory Admin" do
    background do
      @ter_admin = create_territory_admin
      @territory = @ter_admin.territories.first

      @user = create_territory_user(:territory => @territory)
            
      visit admin_homepage
      login_as @ter_admin.email
    end
    
    describe "with PAGINATION set to a 2 RECORD LIMIT" do
      it "USER MANAGER should support pagination" do
        3.times { create_territory_user(:territory => @territory) }
              
        visit "/admin/territories/#{@territory.id}/users"
        page.has_content?("Next →").should == false
        visit "/admin/territories/#{@territory.id}/users?limit=2"
        page.has_content?("Next →").should == true
      end
            
      it "BANNER ADS should support pagination" do
        3.times { Factory.create(:banner, :territory => @territory) }
        
        visit "/admin/territories/#{@territory.id}/banners"
        page.has_content?("Next →").should == false
        visit "/admin/territories/#{@territory.id}/banners?limit=2"
        page.has_content?("Next →").should == true
      end
      
      it "HEADER IMAGES should support pagination" do
        3.times { Factory.create(:header, :territory => @territory) }
        
        visit "/admin/territories/#{@territory.id}/headers"
        page.has_content?("Next →").should == false
        visit "/admin/territories/#{@territory.id}/headers?limit=2"
        page.has_content?("Next →").should == true
      end
      
      describe "BUSINESS LISTINGS" do
        background do
          @biz_listing = Factory.create(:business_listing, :territory => @territory)
          2.times { Factory.create(:business_listing, :territory => @territory) }
        end
        
        it "LISTING PAGE (index) should support pagination" do
          visit "/admin/territories/#{@territory.id}/business_listings"
          page.has_content?("Next →").should == false
          visit "/admin/territories/#{@territory.id}/business_listings?limit=2"
          page.has_content?("Next →").should == true
        end
        
        it "COUPONS should support pagination" do
          3.times { Factory.create(:coupon, :business_listing => @biz_listing) }
          visit "/admin/territories/#{@territory.id}/business_listings/#{@biz_listing.id}/coupons"
          page.has_content?("Next →").should == false
          visit "/admin/territories/#{@territory.id}/business_listings/#{@biz_listing.id}/coupons?limit=2"
          page.has_content?("Next →").should == true
        end
        
        it "COMMENTS should support pagination" do
          3.times { Factory.create(:comment, :user => Factory.create(:user), :business_listing => @biz_listing) }
          visit "/admin/territories/#{@territory.id}/business_listings/#{@biz_listing.id}/comments"
          page.has_content?("Next →").should == false
          visit "/admin/territories/#{@territory.id}/business_listings/#{@biz_listing.id}/comments?limit=2"
          page.has_content?("Next →").should == true
        end
        
        it "PICTURES should support pagination" do
          3.times { Factory.create(:picture, :business_listing => @biz_listing) }
          visit "/admin/territories/#{@territory.id}/business_listings/#{@biz_listing.id}/pictures"
          page.has_content?("Next →").should == false
          visit "/admin/territories/#{@territory.id}/business_listings/#{@biz_listing.id}/pictures?limit=2"
          page.has_content?("Next →").should == true
        end
        
        it "FILES should support pagination" do
          3.times { Factory.create(:file_model, :business_listing => @biz_listing) }
          visit "/admin/territories/#{@territory.id}/business_listings/#{@biz_listing.id}/file_models"
          page.has_content?("Next →").should == false
          visit "/admin/territories/#{@territory.id}/business_listings/#{@biz_listing.id}/file_models?limit=2"
          page.has_content?("Next →").should == true
        end
      end
    end
    
  end  
end