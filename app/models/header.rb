# == Schema Information
#
# Table name: headers
#
#  id           :integer(4)      not null, primary key
#  territory_id :integer(4)
#  credit       :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  header       :string(255)
#  link         :string(255)
#

class Header < ActiveRecord::Base
  mount_uploader :header, HeaderUploader

  belongs_to :territory

  before_save :normalize_link

  def normalize_link
    unless link.blank?
      url = link.nil? ? self.link : link
      url = link.gsub(",","--")
      uri = URI.parse(url)
      uri = URI.parse("http://#{uri}") unless uri.scheme
      uri.scheme = uri.scheme.downcase  # URI should do this
      self.link = uri.normalize.to_s.gsub("--",",")
    end
  end

end
