class Ability
  include CanCan::Ability
  
  def initialize(user,territory=nil)
    if user      
      if user.is_global_admin?
        global_admin(user) 
      else
        site_member(user,territory)
      end 
    end
    can :create, User
  end
  
  def site_member(user,territory)
    if territory && user.is_territory_admin_for?(territory)
      define_territory_admin_authorizations( user, territory )
    elsif territory && user.is_listing_manager_in?( territory )
      define_listing_manager_authorizations( user, territory )
    elsif user.is_listing_manager?
      can :read, BusinessListing
    else
      can :create, Comment
      can :update, Comment do |c| 
        c.user == user
      end
    end
        
    # Territory Specifics (for territory admins)
    can [:index, :show], Territory if user.is_admin?    
  end
  
  def global_admin(current_user)
    can :manage, :all    
        
    cannot :destroy, Category do |category|
      !category.business_listings.empty?
    end

    cannot :destroy, User do |user_object|
      user_object == current_user
    end
  end

  def define_territory_admin_authorizations( user, territory )
    can :mass_email, Territory do |t|
      t == territory && user.is_territory_admin_for?( t )
    end

    can :docs_help, Territory do |t|
      t == territory && user.is_territory_admin_for?( t )
    end

    can :send_mass_email, Territory do |t|
      t == territory && user.is_territory_admin_for?( t )
    end

    # User can manage other users if that users is a member of a territory that they are a local admin for
    can [:read, :edit, :update, :destroy], User do |tgt_user|
      tgt_user.territories.map { |ter| user.is_territory_admin_for?(ter) }.include?(true) && !tgt_user.is_global_admin?
    end

    # Can create users as long as the user isn't set to be a global admin
    can [:create], User do |tgt_user|
      tgt_user.global_admin == false
    end

    # User can't delete theirself
    cannot :destroy, User do |tgt_user|
      tgt_user == user
    end

    can :read,    Category
    can :create,  Category
    can :update,  Category do |category|
      category.territory == territory
    end
    can :hide, Category
    can :destroy, Category do |category|
      category.business_listings.empty? && ( category.territory == territory )
    end

    can :update, Territory do |attempted_territory|
      territory == attempted_territory
    end

    can :manage, BusinessListing
    can :feature, BusinessListing
    can :manage, Picture
    can :manage, FileModel
    can :manage, Comment
    can :manage, Coupon
    can :manage, Banner
    can :manage, Header
    can :manage, SubPage
    can :manage, Event
    can :manage, Reward
    can :manage, DailyDeal
  end

  def define_listing_manager_authorizations( user, territory )
    can [ :update, :read ], BusinessListing do |bl|
      user.is_listing_manager_for?( bl )
    end
    can :manage, Coupon do |c|
      user.is_listing_manager_for?( c.business_listing )
    end
    can :manage, FileModel do |f|
      user.is_listing_manager_for?( f.business_listing )
    end
    can [ :read, :destroy, :create ], Picture do |p|
      user.is_listing_manager_for?( p.business_listing )
    end
    can [ :update ], Picture do |p|
      user.is_listing_manager_for?( p.business_listing ) && p.state != BusinessListing::APPROVED
    end
    can :read, Comment do |c|
      user.is_listing_manager_for?( c.business_listing )
    end
    can [ :read, :destroy, :create ], Reward do |m|
      user.is_listing_manager_for?( m.business_listing )
    end
  end

end