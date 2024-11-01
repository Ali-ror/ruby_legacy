def self.go
  puts ""
  puts "Migrating data..."

  @@link_types = {}
  [ "Website", "Twitter", "Facebook", "LinkedIn", "Flickr", "YouTube",
    "Blogger", "Google", "Picasa", "Vimeo"].each do |s|
    @@link_types[s.downcase.to_sym] = LinkType.find_by_name s
  end

  dbses = []

  if ARGV.length > 1
   for i in (1..ARGV.length-1) do 
     dbses << ARGV[i]
   end
  else
    dbses = get_dbses
  end

  dbses.each do |db| 
    do_transaction { one( db ) }
  end
end

def self.get_dbses
  puts ""
  puts "Getting the list of legacy databases..."
  bad_dbs = [ 'relyloca_dev_dev', 'relyloca_main', 'relyloca_new_london_county', 'relyloca_pbb01', 'relyloca_wrd01', 'relyloca_wrd02', 'relyloca_dev_demo' ]
  LegacyBase.connection.select_values('SHOW DATABASES LIKE "relyloca\_%"') - bad_dbs
end


def self.one( db )
  puts ""
  puts "Processing #{db}..."

  # relyloca_arizona_prescott
  # public_html/arizona/prescott/files/coupons/163_190.jpg

  ENV['legacy_db'] = db
  sub = db[9..db.length-1]
  split = sub.split( "_" )
  state = split.first
  rest = split - [ state ]
  @@territory = rest.join( " " ).titleize
  @@file_context = File.join( ARGV[0], state, rest.join( "-" ), "files" )
  
  # eww!!!!!!!
  @@file_context = File.join( ARGV[0], "michigan/rochester/files" ) if ( db == "relyloca_michigan_rochesterhills" )

  p @@file_context
  reload_legacy_models
  create_territory
end

def self.load_legacy_dummies
  @@default_address  = Address.find_by_address1_and_city( "4 Privet Drive", "Little Whinging" )
  @@default_user     = User.find_by_email( "mrlegacy@relylocal.com" )
  @@default_category = Category.find_by_name( "Default Legacy Category" )
end

def self.create_legacy_dummies
  puts "Creating Legacy Dummies..."

  @@default_address = Address.create! do |a|
      a.address1 = "4 Privet Drive"
      a.city = "Little Whinging"
      a.state = "UK"
      a.country = "UK"
      a.zip = "12345"
  end

  @@default_user = User.create! do |u|
    u.email = "mrlegacy@relylocal.com"
    u.first_name = "Anonymous"
    u.last_name = "User"
    u.address = @@default_address
    u.password = "harrypotter"
    u.password_confirmation = "harrypotter"
    u.confirmed_at = Time.now
  end

  @@default_category = Category.create! do |c|
    c.name = "Default Legacy Category"
  end
end

def self.create_territory
  puts "Creating the territory '#{@@territory}'..."

  LegacyWebsite.all.each do |site|
    t = Territory.new
    t.page_title       = site.web_title
    t.meta_tags        = site.web_keywords[0..254]
    t.meta_description = site.web_desc[0..254]
    t.tracking_code    = CGI.unescapeHTML( site.web_tracking )

    t.contact_us = LegacySetupPage.contact_us_content

    links = URI.extract site.web_leftcolumn
    links = links.reject { |i| i.include?( "'popup'" ) || i.include?( "padding-top:" ) }

    links.uniq.each do |i|
      clean_url = i.gsub( "\&quot;;", "" )
      lt = @@link_types.keys.find { |l| clean_url.include?( l.to_s ) }
      lt = :website if lt.nil?
      t.links << Link.new( :link_type => @@link_types[lt], :url => clean_url )
    end
    
    city_state = site.web_citystate.split( ", " )
    state = Carmen::state_name( city_state.last )
    t.cities = [
      City.new( :city  => city_state.first,
                :state => state.blank? ? "THE STATE OF FIX ME!" : state )
    ]

    t.name = city_state.first
    puts "Setting territory name: '#{t.name}'..."

#    [ :local_businesses, :local_coupons, :local_jobs, :can_rely_text, :discovery_text,
#      :save_text, :connect_text, :what_is_relylocal,
#      :list_your_businesses, :show_your_support ].each do |s|
#      eval "t.#{s.to_s} = t.#{s.to_s}.gsub( '(territory_name)', @@territory )"
#    end

    t.save!
    putc "."

    #p t
    #p t.links

    create_categories( t )
    create_users( t )
#    create_headers( t )
    create_listings( t )
  end
end

def self.reload_legacy_models
  puts "Reloading Legacy Models..."

  classes = [ :LegacyBase, :LegacyCategory, :LegacyRlCoupon, :LegacyListingComment, 
              :LegacyListing, :LegacyListingFile, :LegacyListingPhoto, :LegacyHeader,
              :LegacySetupPage ]

  Object.class_eval do
    classes.each do |clazz|
      remove_const clazz.to_s if const_defined? clazz.to_s
    end
  end

  classes.each do |clazz|
    load "#{clazz.to_s.underscore}.rb"
  end
end

def self.create_users( t )
  puts ""
  puts "Creating Users..."

  LegacyUser.all.each do |user|
    u = User.find_or_initialize_by_email(user.user_email)
    u.first_name = user.user_firstname.blank? ? "RL-Legacy" : user.user_firstname
    u.last_name  = user.user_lastname.blank? ? "RL-Legacy" : user.user_lastname
    u.password   = user.user_password
    u.confirmed_at = Time.now
    u.local_admins << t
    u.address = @@default_address
    u.save!
    putc "."
  end

  LegacyMember.all.each do |user|
    u = User.find_or_initialize_by_email(user.member_email)
    u.first_name = user.member_firstname.blank? ? "RL-Legacy" : user.member_firstname
    u.last_name  = user.member_lastname.blank? ? "RL-Legacy" : user.member_lastname
    u.password   = user.member_password
    u.phone      = user.member_phone
    u.fax        = user.member_fax
    u.confirmed_at = Time.now

    if user.member_address.blank?
      u.address = @@default_address
    else
      u.build_address
      u.address.address1 = user.member_address unless user.member_address.blank?
      u.address.city = user.member_city unless user.member_city.blank?
      u.address.state = user.member_state unless user.member_state.blank?
      u.address.zip = user.member_zip unless user.member_zip.blank?
      u.address.country = 'US'
    end
    u.save!
    putc "."
  end
end

def self.create_categories( t )
  puts ""
  puts "Creating Categories..."

  lcs = LegacyCategory.roots

  lcs.each do |root|
    root.each_depth_first do |lc|
      l_name = lc.category_name.strip
      l_path = lc.self_and_ancestors
      nodes = Category.default_and_territory( t.id ).where( :name => l_name )
      node = nodes.detect { |n| n.self_and_ancestors.collect(&:name) == l_path }
      if node.nil?
        node = Category.new :name => l_name
        node.territory = t
        node.save!
        putc "."
        if lc.parent
          l_parent_name = lc.parent.category_name.strip
          l_parent_path = lc.parent.self_and_ancestors
          parents = Category.default_and_territory( t.id ).where( :name => l_parent_name ).all
          parent = parents.detect { |p| p.self_and_ancestors.collect(&:name) == l_parent_path }
          p "-------- parent not in place: #{l_parent_path.inspect}" if parent.nil?
          p "-------- parent territory does not match cat territory: #{node.inspect}, #{parent.inspect}" if ( !parent.territory_id.nil? && parent.territory_id != t.id )
          node.move_to_child_of( parent )
        end
      end
    end
  end
  #validate_categories
end

def validate_categories
  LegacyCategory.all.each do |lc|
    l_name = lc.category_name.strip
    l_path = lc.self_and_ancestors
    nodes = Category.find_all_by_name( l_name )
    p l_path
    p nodes.collect { |n| n.self_and_ancestors.collect(&:name) }

    if nodes.none? { |n| n.self_and_ancestors.collect(&:name) == l_path }
      p lc
      p l_path
      p nodes
      p nodes.collect { |n| n.self_and_ancestors.collect(&:name) }
      raise Exception.new
    end 
  end
end

#def self.create_headers( t )
#  LegacyHeader.all.each do |lh|
#    file = File.join( @@file_context, "header", lh.filename )
#    if File.exists?( file )
#      h = Header.new :territory => t
#      h.credit = lh.credit
#      h.header = File.open( file )
#      h.save!
#      putc "."
#    else
#      puts "-->Header #{file} not found"
#    end
#
#  end
#end

def self.create_listings( t )
  puts ""
  puts "Creating Listings..."
  LegacyListing.all.each do |listing|
    bl = BusinessListing.new :territory => t
    bl.attributes = listing.migrate_mapping
    bl.phone = "(123) 555-1234" if bl.phone.blank?
    bl.package_type = 1 if bl.package_type.blank?
    bl.links = listing.add_links

    if !listing.listing_logo.blank?
      file = File.join( @@file_context, "logo", listing.listing_logo )
      if File.exists?( file )
        bl.logo = File.open( file )
      else
        puts "-->Logo #{file} not found"
      end
    end

    if listing.member.blank? || listing.listing_member <= 0 || listing.member.member_email.blank?
      bl.user = @@default_user
    else
      u = User.find_by_email( listing.member.member_email )
      u.territories << t unless u.territories.include?( t )
      bl.user = u
    end

    bl.build_address

    if !listing.listing_address.blank?
      bl.address = Address.new(
        :address1 => CGI.unescapeHTML( listing.listing_address.strip ),
        :city => listing.listing_city.strip,
        :state => listing.listing_state.strip,
        :zip => listing.listing_zip.strip,
        :country => 'US'
      )
    end
    bl.address.skip_validations = true

    # migrate listing categories
    if listing.listing_category != "-"
      listing.categories.each do |category|
        newcats = Category.default_and_territory(t.id).where( :name => category.category_name.strip )
        new_cat = newcats.detect { |n| n.self_and_ancestors.collect(&:name) == category.self_and_ancestors }

        if !new_cat.territory.nil? && new_cat.territory_id != t.id
          puts "----> Category is being assigned to the wrong place!"
          puts "cat to be assigned:"
          p new_cat
          p new_cat.self_and_ancestors.collect(&:name)
          puts "territory:"
          p t
          puts "legacy cat:"
          p category
          p category.self_and_ancestors
        end

        if new_cat.nil?
          #p "bl cat is nil"
          #p category.self_and_ancestors
          #p newcats.each { |n| p n.self_and_ancestors.collect(&:name) }

          #raise Exception.new
        else
          bl.categories << new_cat
          putc "."
        end
      end
    end
#if bl.categories.empty?
#  p "--------- listing cats"
#  p listing.categories.collect { |c| c.self_and_ancestors }
#  p "--------- bl cats"
#  p bl.categories.collect { |c| c.self_and_ancestors.collect(&:name) }
#end
    bl.categories.push @@default_category if bl.categories.empty?
    bl.save!
    putc "."

    bl.state = listing.status_to_state "listing_status"
    bl.save!

    create_legacy_coupons( listing, bl )
    create_pictures( listing, bl )
    create_files( listing, bl )
    create_comments( listing, bl )
  end
end

def self.create_legacy_coupons( listing, bl )
  listing.coupons.each do |c|
    file = File.join( @@file_context, "coupons", c.filename )
    if File.exists?( file )
      lc = LegacyCoupon.create! :legacy_coupon => File.open( file ), :business_listing => bl
      putc "."
    else 
      puts "-->Coupon #{file} not found..."
    end
  end
end

def self.create_pictures( listing, bl )
  listing.photos.each do |legacy_photos|
    file = File.join( @@file_context, "photo", legacy_photos.photo_id.to_s + ".jpg" )
    if File.exists?( file )
      pe = Picture.new :business_listing => bl
      pe.caption = legacy_photos.photo_caption
      pe.picture = File.open( file )
      pe.state   = legacy_photos.status_to_state( "photo_status" )
      success = pe.save
      puts "-->Picture #{file} was not saved." unless success
      putc "."
    else
      puts "-->Picture #{file} not found"
    end
  end
end

def self.create_files( listing, bl )
  listing.files.each do |legacy_file|
    file = File.join( @@file_context, "files", legacy_file.filename )
    if File.exists?( file )
      f = FileModel.new :business_listing => bl
      f.title = legacy_file.title
      f.file_attachment = File.open( file )
      f.save!
      putc "."
    else
      puts "-->File #{file} not found"
    end
  end
end

def self.create_comments( listing, bl )
  listing.comments.each do |legacy_comment|
    c = Comment.new :business_listing => bl
    c.user    = legacy_comment.best_guess_user( @@default_user )
    c.rating  = legacy_comment.comment_rating
    c.comment = legacy_comment.comment_title + " " + legacy_comment.comment_detail
    c.state   = legacy_comment.status_to_state( "comment_status" )
    c.save!
    putc "."
  end
end

def self.create_global_categories
  ENV['legacy_db'] = 'relyloca_dev_demo'
  reload_legacy_models
  puts "Creating Global Categories..."

  lcs = LegacyCategory.roots

  lcs.each do |root|
    root.each_depth_first do |lc|
      l_name = lc.category_name.strip
      l_path = lc.self_and_ancestors
      nodes = Category.find_all_by_name( l_name )
      node = nodes.detect { |n| n.self_and_ancestors.collect(&:name) == l_path }
      if node.nil?
        node = Category.new :name => l_name
        node.save!
        putc "."
        if lc.parent
          l_parent_name = lc.parent.category_name.strip
          l_parent_path = lc.parent.self_and_ancestors
          parents = Category.find_all_by_name l_parent_name
          parent = parents.detect { |p| p.self_and_ancestors.collect(&:name) == l_parent_path }
          p "-------- parent not in place: #{l_parent_path.inspect}" if parent.nil?
          node.move_to_child_of( parent )
       	end
      end
    end
  end

#  validate_categories
end


def do_transaction
  ActiveRecord::Base.transaction do
    begin
      yield
    rescue => e
      puts e.inspect
      puts e.backtrace
      p Time.now
      raise ActiveRecord::Rollback
    end
  end
end

p Time.now

if ARGV.length == 1
  do_transaction { create_legacy_dummies }
  do_transaction { create_global_categories }
else
  load_legacy_dummies
end

go

puts "Success!"

p Time.now

u = User.find_by_email "steve@relylocal.com"
u.password = "123456"
u.password_confirmation = "123456"
u.global_admin = true
u.save


# NOTES!!!
# File permissions are messed up on the files in the legacy public_html directory.
# Ruby does not recognize they exist. In some cases, the file are owned by the
# relylocal user; In others, the apache user.

