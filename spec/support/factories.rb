Factory.class_eval do
  def attach( name, path )
    path_with_rails_root = "#{Rails.root}/#{path}"
    self.send( "#{name}", File.open( path_with_rails_root ) )
  end
end

Factory.define :user do |u|
  u.sequence(:login)  { |n| "user_#{n}" }
  u.sequence(:email)  { |n| "user_#{n}@emailtest#{n}.com" }
  
  u.first_name  { Faker::Name.first_name }
  u.last_name   { Faker::Name.last_name }
  u.phone       { Faker::PhoneNumber.phone_number }
  u.fax         { Faker::PhoneNumber.phone_number }
  u.address     { Factory.build(:address) }
  u.password              "password"
  u.password_confirmation "password"
end

Factory.define :territory_admin, :parent => :user do |u|
  u.after_create do |user|
    user.territories << Factory.create(:territory)
    user.user_territories.first.update_attribute(:local_admin, true)
  end
end

Factory.define :address do |a|
  a.address1 { Faker::Address.street_address }
  a.city     { Faker::Address.city }
  a.state    { Faker::Address.us_state }
  a.zip      { Faker::Address.zip_code }
  a.country  "US"
end

Factory.define :territory do |t|
  t.sequence(:name) { |n| "territory_name_#{n}" }
end

Factory.define :banner do |b|
  b.attach :banner, "public/test/test.jpg"
end

Factory.define :header do |b|
  b.attach :header, "public/test/test.jpg"
end

Factory.define :category do |c|
  c.name { Faker::Lorem.sentence }
end

Factory.define :business_listing do |b|
  b.name         { Faker::Company.name }
  b.expires      { Date.today + 10.years }
  b.address      { Factory.build :address }
  b.user_id      { Factory.create( :user ).id }
  b.phone        { Faker::PhoneNumber.phone_number }
  b.package_type { BusinessListing::VALID_PACKAGE_TYPES.rand }
  b.business_tier { BusinessListing::VALID_BUSINESS_TIERS.rand }

  def create_business_listing_category
    t = Territory.first
    t = Factory.create :territory if t.nil?
    BusinessListingCategory.new :category => Factory.create( :category, :territory => t )
  end

  b.business_listing_categories { |blc| [ create_business_listing_category ] }
end

Factory.define :comment do |c|
  c.comment { Faker::Lorem.sentence }
  c.rating  { ( 1..5 ).to_a.rand }
  c.state   { BusinessListing::PENDING }
  c.user    { Factory.create(:user) }
end

Factory.define :coupon do |c|
  c.expiration_date   { Date.today + 1.month }
  c.restrictions      { Faker::Lorem.sentence }
  c.title             { Faker::Lorem.sentence }
  c.featured          { false }
  c.attach :coupon_image, "public/test/test.jpg"
end

Factory.define :file_model do |fm|
  fm.attach :file_attachment, "public/test/test.jpg"
  fm.title { Faker::Lorem.sentence }
end

Factory.define :picture do |p|
  p.attach :picture, "public/test/test.jpg"
  p.caption { Faker::Lorem.sentence }
  p.state BusinessListing::PENDING
end