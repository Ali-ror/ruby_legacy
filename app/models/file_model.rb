# == Schema Information
#
# Table name: file_models
#
#  id                  :integer(4)      not null, primary key
#  title               :string(255)
#  business_listing_id :integer(4)
#  created_at          :datetime
#  updated_at          :datetime
#  file_attachment     :string(255)
#

class FileModel < ActiveRecord::Base
  mount_uploader :file_attachment, GenericUploader

  belongs_to :business_listing
end
