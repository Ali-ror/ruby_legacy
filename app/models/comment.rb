# == Schema Information
#
# Table name: comments
#
#  id                  :integer(4)      not null, primary key
#  comment             :text
#  state               :string(255)
#  rating              :integer(4)
#  business_listing_id :integer(4)
#  user_id             :integer(4)
#

class Comment < ActiveRecord::Base
  # Add moderation and bind moderation methods to controller
  include Moderation
  moderate_controller Admin::CommentsController
  
  belongs_to :business_listing
  belongs_to :user

  validates :comment,             :presence => true
  validates :state,               :presence => true
  validates :rating,              :presence => true
  validates :user_id,             :presence => true
  validates :business_listing_id, :presence => true

  scope :pending,   where( :state => BusinessListing::PENDING )
  scope :rejected,  where( :state => BusinessListing::REJECTED )
  scope :active,    where( :state => BusinessListing::APPROVED )
  
  attr_accessor :user_proxy

  def user_proxy
    user.nil? ? "" : "#{user.to_label} (#{user.email})"
  end
  
  def territory
    self.business_listing.territory
  end
end