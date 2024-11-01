# == Schema Information
#
# Table name: links
#
#  id           :integer(4)      not null, primary key
#  url          :string(255)
#  link_type_id :integer(4)
#  model_id     :integer(4)
#  model_type   :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

class Link < ActiveRecord::Base 
  belongs_to :link_type

  belongs_to :model, :polymorphic => true
  
  before_save :normalize_link
  
  validates :url,           :presence => true
  validates :link_type_id,  :presence => true

  delegate :name, :to => :link_type, :prefix => :type
  
  def self.by_type(type)
    lt = LinkType.find_by_name( type )
    if lt
      return self.scoped.where("link_type_id = ?", lt.id ).limit(1).first
    else
      return nil
    end
  end
  
  def normalize_link
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

  def you_tube_image
    "http://i1.ytimg.com/vi/#{parse_you_tube_url}/default.jpg"
  end

  def you_tube_url
    "http://www.youtube.com/v/#{parse_you_tube_url}&hl=en&fs=1&"
  end

  private

  def parse_you_tube_url
    a = URI.parse( self.url )
    if a.query.nil?
      return a.path.sub( "/v/", "" )
    else
      return CGI.parse( a.query )["v"].first
    end
  end

end
