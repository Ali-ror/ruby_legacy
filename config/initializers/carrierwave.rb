module CarrierWave
  module RelyLocal
    module Customization
      extend ActiveSupport::Concern
      include CarrierWave::MiniMagick

      CUTOFF = Date.parse( "July 6th 2011" )

      # Override the directory where uploaded files will be stored.
      # This is a sensible default for uploaders that are meant to be mounted:
      def store_dir
        if self.model.is_a?( FileModel ) && self.model.updated_at < CUTOFF
          "uploads"
        else
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
          prefix = "testuploads" if Rails.env.test?

          "#{prefix}/#{mounted_as.to_s.pluralize}/#{middle_path.join('/')}/#{model.id}"
        end
      end

      included do
        # Setup default thumbnail support
        version :thumb do
          process :resize_to_fill => [75, 75]
        end
      end

    end
  end
end


CarrierWave.configure do |config|
  config.delete_tmp_file_after_storage = true
  config.ensure_multipart_form = false
end
