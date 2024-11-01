class MassEmail
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming


  attr_accessor :subject, :body, :reply_to

  validates_presence_of :subject
  validates_presence_of :body

  def initialize( attrs = {} )
    attrs.each { |k,v| send( "#{k}=", v ) }
  end

  def persisted?
    false
  end

end