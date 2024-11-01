require 'unicode'

class String
  def to_slug
    self.gsub(/[\W]/u, ' ').strip.gsub(/\s+/u, '-').gsub(/-\z/u, '').downcase.to_s
  end
end