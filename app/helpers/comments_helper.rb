module CommentsHelper
  def commentor_says( user )
    result = user.first_name.blank? ? 'A user' : user.first_name

    if user.address && user.address.city
      result += " from #{user.address.city}"
    end
    
    result += " says:"
    result
  end
end