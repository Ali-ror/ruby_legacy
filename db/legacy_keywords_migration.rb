def self.go
  puts ""
  puts "Migrating keywords..."

  @@all_dups = []
  @@all_not_found = []
  @@bl_count = 0

  dbses = []

  if ARGV.length > 0
   for i in (0..ARGV.length-1) do 
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
  bad_dbs = [ 'relyloca_dev_dev', 'relyloca_main', 'relyloca_new_london_county', 
    'relyloca_pbb01', 'relyloca_wrd01', 'relyloca_wrd02', 'relyloca_dev_demo' ]
  LegacyBase.connection.select_values('SHOW DATABASES LIKE "relyloca\_%"') - bad_dbs
end


def self.one( db )
  puts ""
  puts "Processing #{db}..."

  # relyloca_arizona_prescott

  @@dups = []
  @@not_found = []

  ENV['legacy_db'] = db
  sub = db[9..db.length-1]
  split = sub.split( "_" )
  state = split.first
  rest = split - [ state ]
  @@territory = rest.join( " " ).titleize
  reload_legacy_models
  do_territory

  @@all_dups += @@dups
  @@all_not_found += @@not_found
end

def self.do_territory
  puts "Updating territory '#{@@territory}'..."

  LegacyWebsite.all.each do |site|
    city_state = site.web_citystate.split( ", " )

    t = Territory.find_by_name( city_state.first )

    if t && !t.cities.empty?
      puts "Found territory name: '#{t.name}'..."
      putc "."
      update_listings( t )
    else
      puts "#### #{city_state} does not exist or has empty cities."
    end 
  end
end

def self.reload_legacy_models
  #puts "Reloading Legacy Models..."

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

def self.update_listings( t )
  puts ""
  puts "Updating Listings..."
  LegacyListing.all.each do |listing|
    #bls = BusinessListing.find_all_by_name_and_territory_id_and_phone listing.listing_title.strip, t.id, listing.listing_phone.strip
    bls = BusinessListing.find_all_by_name_and_territory_id listing.listing_title.strip, t.id
    #puts "#### Duplicate: #{listing.listing_title} in #{t.name} (#{t.id}) - #{bls.length}, (#{bls.collect(&:id)})" if bls.length > 1
    #puts "#### No listings found: #{listing.listing_title} in #{t.name} (#{t.id})" if bls.empty?
    @@dups += bls.collect(&:id) if bls.length > 1
    @@not_found += ["#{listing.listing_title} in #{t.name} (#{t.id})"] if bls.empty?
    @@bl_count += 1
    bls.each do |bl|
      if !listing.listing_keywords.blank?
        #puts "-0 #{bl.id}"
        #puts "-1 #{listing.listing_keywords}"
        #puts "-2 #{bl.tag_list.join(",")}"
        tags = listing.listing_keywords
        tags = ",#{tags}" if !bl.tag_list.empty?
        bl.tag_list = bl.tag_list.join(",") + tags
        bl.save!
        #puts "-3 #{bl.tag_list}"
        putc "."
      end
    end
  end
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
#    raise ActiveRecord::Rollback
  end
end

p Time.now

go

puts "Done!"

File.open("dups.txt", 'w') {|f| f.write(@@all_dups.uniq.join(", ")) }

File.open("not_found.txt", 'w') {|f| f.write(@@all_not_found.uniq.inspect) }

puts "Dups:"
p @@all_dups.length

puts "Not Found:"
p @@all_not_found.length

puts "bl count"
p @@bl_count

p Time.now

