# == Schema Information
#
# Table name: pictures
#
#  id                  :integer(4)      not null, primary key
#  caption             :string(255)
#  business_listing_id :integer(4)
#  created_at          :datetime
#  updated_at          :datetime
#  picture             :string(255)
#  state               :string(255)
#

class Picture < ActiveRecord::Base
  # Add moderatoin and bind moderation methods to controller
  include Moderation
  moderate_controller Admin::PicturesController
  
  mount_uploader :picture, PictureUploader
    
  belongs_to :business_listing
  
  validates :state,   :presence => true
  validates :picture, :presence => true

  after_initialize :set_approved
  
  scope :pending,   where( :state => BusinessListing::PENDING )
  scope :rejected,  where( :state => BusinessListing::REJECTED )
  scope :active,    where( :state => BusinessListing::APPROVED )
  
  
  def territory
    self.business_listing.territory
  end
  
  protected

  def set_approved
    self.state = BusinessListing::APPROVED
  end
end