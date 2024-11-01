# Initial Application Data

unless User.global_admins.count >= 1
  puts "Creating Default User ...."
  u = User.new(:login => "global_user", :email => "global_user@agathongroup.com") do |u|
    u.first_name   = "Global"
    u.last_name    = "User"
    u.global_admin = true
    u.password     = "password"
  end
  u.global_admin = true
  u.build_address
  u.address.skip_validations = true
  u.save!
  u.confirm! unless u.active?

  puts "\n=================================="
  puts "Email: global_user@agathongroup.com"
  puts "Password: password"
  puts "====================================\n"
end

puts ""
puts "Creating Link Types ...."
["Website","Twitter","Facebook","LinkedIn","Flickr","YouTube","Blogger","Google","Picasa","Vimeo"].each do |lt|
  LinkType.find_or_create_by_name(lt)
end
