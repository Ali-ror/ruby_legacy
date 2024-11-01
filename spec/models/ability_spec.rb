require 'spec_helper'

describe Ability do
  describe "Guest or NO USER" do
    before(:each) do
      @guest_ability  = Ability.new(nil)
    end
    
    it "should be able to create an account" do
      @guest_ability.can?(:create, User).should == true
    end
  end
  
  describe "in context of GLOBAL AND TERRITORY ADMIN" do
    before(:each) do
      @territory = Factory.create(:territory)
      @global_admin = Factory.create(:user, :login => "global_admin", :global_admin => true)
      @terr_admin   = Factory.create(:user, :login => "terr_admin")
      
      @territory.local_admins <<  @terr_admin
    end
    
    it "SHOULD be able to access Territories Index" do
      Ability.new(@global_admin).can?(:index, Territory).should == true
      Ability.new(@terr_admin,@territory).can?(:index, Territory).should == true
    end    
  end
  
  describe "in context of GLOBAL ADMIN" do
    before(:each) do
      @global_admin = Factory.create(:user, :login => "global_admin", :global_admin => true)
      @ability = Ability.new(@global_admin)
    end
    
    it "SHOULD be able to MANAGE everything" do
      @ability.can?(:manage, :all).should == true
    end
    
    it "SHOULD NOT be able to destroy themselves" do
      @ability.can?(:destroy, @global_admin).should == false
    end
    
    it "SHOULD be able to destroy other global admins" do
      @global_admin2 = Factory.create(:user, :login => "global_admin2", :global_admin => true)
      @ability.can?(:destroy, @global_admin2).should == true
    end
  end
  
  describe "in context of a TERRITORY ADMIN" do
    before(:each) do
      @territory  = Factory.create(:territory)
      @user       = Factory.create(:user, :login => "territory_admin")
      @ability    = Ability.new(@user, @territory)
    end
        
    it "SHOULD NOT be able to UPDATE TERRITORY" do
      @ability.can?(:update, @territory).should == false
    end
    
    it "SHOULD NOT be able to CREATE GLOBAL ADMIN" do
      @global_admin = Factory.create(:user, :login => "global_admin", :global_admin => true)
      @ability.can?(:update, @global_admin).should == false
    end
    
    it "SHOULD NOT be able to UPDATE GLOBAL ADMIN" do
      @fake_global_admin = Factory.create(:user, :login => "global_admin", :global_admin => true)
      @ability.can?(:update, @global_admin).should == false
    end
    
    describe "WHO IS ADMIN OF A TERRITORY" do
      before(:each) do
        # This makes the user actually admin over the created territory
        @user.territories << @territory
        @user.user_territories.first.update_attribute(:local_admin, true)
        @ability = Ability.new(@user, @territory)
      end
      
      it "SHOULD BE able to MANAGE CATEGORIES" do
        @category = Factory.create(:category, :territory => @territory)
        @ability.can?(:manage, @category).should == true
      end
      
      it "SHOULD BE able to EDIT, UPDATE, DESTROY USERS" do
        @ter_user = Factory.create(:user, :login => "ter_user")
        @ter_user.territories << @territory
        @ability.can?(:read, @ter_user).should == true
        @ability.can?(:edit, @ter_user).should == true
        @ability.can?(:update, @ter_user).should == true
        @ability.can?(:destroy, @ter_user).should == true
      end
      
      it "SHOULD BE able to MANAGE BUSINESS LISTINGS" do
        @biz_listing = Factory.create(:business_listing, :territory => @territory)
        @ability.can?(:manage, @biz_listing).should == true
      end

      it "SHOULD BE able to MANAGE BUSINESS LISTING PICTURES" do
        @biz_listing = Factory.create(:business_listing, :territory => @territory)
        @biz_listing.pictures << Factory.create(:picture)
        @biz_listing.save
        @picture = @biz_listing.pictures.first
        @ability.can?(:manage, @picture).should == true
      end

      it "SHOULD BE able to MANAGE BUSINESS LISTING FILES" do
        @biz_listing = Factory.create(:business_listing, :territory => @territory)
        @biz_listing.file_models << Factory.create(:file_model)
        @biz_listing.save
        @file = @biz_listing.file_models.first
        @ability.can?(:manage, @file).should == true
      end
      
      it "SHOULD BE able to MANAGE BUSINESS LISTING COMMENTS" do
        @biz_listing = Factory.create(:business_listing, :territory => @territory)
        @biz_listing.save

        @comment = Factory.create :comment, :user => @user, :business_listing => @biz_listing

        @ability.can?(:manage, @comment).should == true
      end

      it "SHOULD BE able to MANAGE BUSINESS LISTING COUPONS" do
        @biz_listing = Factory.create(:business_listing, :territory => @territory)
        @biz_listing.coupons << Factory.create(:coupon)
        @biz_listing.save
        @coupon = @biz_listing.coupons.first
        @ability.can?(:manage, @coupon).should == true
      end

      it "SHOULD BE able to MANAGE BANNER ADS" do
        @banner = Factory.create(:banner, :territory => @territory)
        @ability.can?(:manage, @banner).should == true
      end
      
      it "SHOULD BE able to MANAGE HEADERS" do
        @header = Factory.create(:header, :territory => @territory)
        @ability.can?(:manage, @header).should == true
      end
      
      it "SHOULD BE able to SHOW TERRITORY" do
        @ability.can?(:show, @territory).should == true
      end
      
    end#END "WHO IS ADMIN OF A TERRITORY"
    
    describe "WHO IS NOT ADMIN OF A TERRITORY" do
      before(:each) do
        # Get rid of previously created territory for a territory controlled by factory user
        @territory = Factory.create(:territory)
      end
      
      it "SHOULD BE able to MANAGE CATEGORIES" do
        @category = Factory.create(:category, :territory => @territory)
        @ability.can?(:manage, @category).should == false
      end
      
      it "SHOULD BE able to MANAGE USERS" do
        @ter_user = Factory.create(:user, :login => "ter_user")
        @ter_user.territories << @territory
        @ability.can?(:manage, @ter_user).should == false
      end
      
      it "SHOULD BE able to MANAGE BUSINESS LISTINGS" do
        @biz_listing = Factory.create(:business_listing, :territory => @territory)
        @ability.can?(:manage, @biz_listing).should == false
      end
      
      it "SHOULD BE able to MANAGE BUSINESS LISTING PICTURES" do
        @biz_listing = Factory.create(:business_listing, :territory => @territory)
        @biz_listing.pictures << Factory.create(:picture)
        @biz_listing.save
        @picture = @biz_listing.pictures.first
        @ability.can?(:manage, @picture).should == false
      end

      it "SHOULD BE able to MANAGE BUSINESS LISTING FILES" do
        @biz_listing = Factory.create(:business_listing, :territory => @territory)
        @biz_listing.file_models << Factory.create(:file_model)
        @biz_listing.save
        @file = @biz_listing.file_models.first
        @ability.can?(:manage, @file).should == false
      end
      
      it "SHOULD BE able to MANAGE BANNER ADS" do
        @banner = Factory.create(:banner, :territory => @territory)
        @ability.can?(:manage, @banner).should == false
      end
      
      it "SHOULD BE able to MANAGE HEADERS" do
        @header = Factory.create(:header, :territory => @territory)
        @ability.can?(:manage, @header).should == false
      end
    end#END "WHO IS NOT ADMIN OF A TERRITORY"
  end
  
  describe "in context of REGISTERED USER" do
    before(:each) do
      @user = Factory.create(:user, :login => "regular_user")
      @ability = Ability.new(@user)
    end
    
    describe "COMMENTS" do
      before(:each) do
        @comment = Factory.create(:comment, :user => @user, :business_listing => Factory.create( :business_listing ) )
      end
      
      it "SHOULD be able to CREATE" do
        @ability.can?(:create, @comment).should == true
      end
      
      it "SHOULD be able to UPDATE" do
        @ability.can?(:update, @comment).should == true
      end
      
      it "SHOULD NOT be able to UPDATE someone elses" do
        @comment = Factory.create(:comment, :user => Factory.create( :user ), :business_listing => Factory.create( :business_listing, :territory => Factory.create( :territory ) ) )
        @ability.can?(:update, @comment).should == false
      end
    end
  end
end