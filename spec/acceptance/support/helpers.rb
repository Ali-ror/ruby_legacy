module HelperMethods
  def create_user(options={}) 
    u = Factory.create(:user, options)
    u.confirm!
    u
  end
  
  def create_territory_admin(options={})
    u = Factory.create(:territory_admin, options)
    u.confirm!
    u
  end
  
  def create_territory_user(options={})
    t = options.delete(:territory)
    u = Factory.create(:user, options)
    u.confirm!
    u.territories << t
    u
  end

  def login_as(username_or_email)
    if username_or_email.respond_to?("email")
      u = User.find_by_login(username_or_email) || User.find_by_email(username_or_email)
    else
      u = User.find_by_email(username_or_email) || User.find_by_login(username_or_email)
    end

    fill_in "Email",    :with => u.email
    fill_in "Password", :with => "password"
    click_button "user_submit"
  end
  
  # Image Paths
  def path_to_test_image
    File.join( Rails.root, "public", "test", "test.jpg" )
  end

  def path_to_test_image2
    File.join( Rails.root, "public", "test", "50x50.png" )
  end

  def test_image_alt_name
    "Test"
  end
  
  def test_image_alt_name2
    "50x50"
  end  

  def have_image( alt_text )
    have_xpath "//img[@alt='#{alt_text}']"
  end 
  
  # JS Helpers
  # This will execute autocomplete checking, there is also an optional fallback in case you don't want to use js
  def autocomplete_choose(text,options={})
    if (example.metadata[:js])
      page.execute_script %Q{ $('input.ui-autocomplete-input').trigger("focus") }
      page.execute_script %Q{ $('input.ui-autocomplete-input').trigger("keydown") }
      sleep 1
      page.execute_script %Q{ $('.ui-menu-item a:contains("#{text}")').trigger("mouseenter").trigger("click"); }
    else
      page.find(options[:fall_field]).set(options[:fall_value])
    end
  end
end

RSpec.configuration.include HelperMethods, :type => :acceptance