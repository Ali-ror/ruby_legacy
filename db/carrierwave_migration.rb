
#CUTOFF = Date.parse( "July 6th 2011" )

def legacy_path( model, field )
  "uploads/#{model.send( field ).mounted_as.to_s.pluralize}/#{model.id}"
end

def new_path( model, field )
  middle_path = []
  if model.respond_to? :business_listing_id
    middle_path << model.business_listing_id
    middle_path << model.business_listing_id.to_s.first
    middle_path << model.business_listing.territory_id
  elsif model.respond_to? :territory_id
    if model.is_a? BusinessListing
      middle_path << model.id.to_s.first
    end
    middle_path << model.territory_id
  end

  middle_path.reverse!

  # the directory structure:
  # uploads/2.0/pictures/territory_id/listing_id's first character/listing_id/model_id'

  prefix = "uploads/2.0"

  "#{prefix}/#{field.to_s.pluralize}/#{middle_path.join('/')}"
end

[
  [ Banner, :banner ],
  [ Coupon, :coupon_image ],
  [ DailyDeal, :deal_image ],
  [ Header, :header ],
  [ LegacyCoupon, :legacy_coupon ],
  [ BusinessListing, :logo ],
  [ BusinessListing, :owner_photo ],
  [ BusinessListing, :mobile_logo ],
  [ Picture, :picture ],
  [ FileModel, :file_attachment ]
].each_with_index do |a, i|
  begin
    klass = a.first
    field = a.last

    klass.find_each do |model|
      begin
        unless klass.is_a?( FileModel ) && model.updated_at < CarrierWave::RelyLocal::Customization::CUTOFF
          lp = legacy_path( model, field )
          np = new_path( model, field )

          fnp = File.join( Rails.root, 'public', np )
          flp = File.join( Rails.root, 'public', lp )
          #p fnp
          #p flp
          if File.exists? flp
            puts "Working #{klass.name}'s #{field}, moving from '#{lp}' to '#{np}/#{model.id}'"
            FileUtils.mkdir_p( fnp )
            FileUtils.cp_r( flp, fnp )
          end
        end
      rescue => e
        puts e.inspect
        #puts e.backtrace
        p Time.now
      end
    end
    rescue => e
      puts e.inspect
      #puts e.backtrace
      p Time.now
    end

  #break if i == 0
end
