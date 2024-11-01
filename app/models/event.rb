# == Schema Information
#
# Table name: events
#
#  id            :integer(4)      not null, primary key
#  name          :string(255)
#  description   :string(255)
#  when          :datetime
#  url           :string(255)
#  public_email  :string(255)
#  private_email :string(255)
#  state         :string(255)
#  user_id       :integer(4)
#  territory_id  :integer(4)
#  created_at    :datetime
#  updated_at    :datetime
#

class Event < ActiveRecord::Base
  # Add moderation and bind moderation methods to controller
  include Moderation
  moderate_controller Admin::EventsController

  belongs_to :user
  belongs_to :territory

  validates :name, :presence => true
  validates :when, :presence => true
  validates :private_email, :presence => true
  #validates :user_id, :presence => true
  validates :territory_id, :presence => true
  validates :description, :length => { :maximum => 255 }
  validates_numericality_of :duration, :only_integer => true

  scope :pending,   where( :state => BusinessListing::PENDING )
  scope :active,    where( :state => BusinessListing::APPROVED )
  scope :upcoming,  where("events.when >= ?", Time.now.beginning_of_day.utc)
  scope :admin_pending_or_active_upcoming, where( "(events.state = ?) OR (events.state = ? AND events.when >= ?)", BusinessListing::PENDING, BusinessListing::APPROVED, Time.now.beginning_of_month.utc )

  default_scope order( 'events.when DESC' )

  after_create  :send_email
  before_create :set_pending
  before_save   :normalize_url

  def end_time
    self.duration ? self.when + self.duration.to_i.minutes : nil
  end

  def as_json( options = {} )
    super( :except => [ :id, :private_email, :created_at, :updated_at, :user_id, :territory_id, :state ] )
  end

  protected

  def set_pending
    self.state = BusinessListing::PENDING
  end

  def send_email
    Postoffice.event_created( self ).deliver
  end
  
  def normalize_url
    begin
      unless url.blank?
        url = url.nil? ? self.url : url
        url = url.gsub(",","--")
        uri = URI.parse(url)
        uri = URI.parse("http://#{uri}") unless uri.scheme
        uri.scheme = uri.scheme.downcase  # URI should do this
        self.url = uri.normalize.to_s.gsub("--",",")
      end
    rescue => e
      Rails.logger.error("BADURI: Link for #{url} did not normalize! - #{e}") and return true
    end
  end

end
