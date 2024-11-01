require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Consumer Account Feature - ", %q{
  In order to download coupons and post reviews
} do
  
  #TODO: Implement when doing public facing site, might have to ignore validations for regular users
  # scenario "I should be able to register an account to relylocal.com" do
  #   visit "/users/sign_up"
  #   
  #   fill_in "Email",                  :with => "myemail@test.com"
  #   fill_in "Password",               :with => "password"
  #   fill_in "Password confirmation",  :with => "password"
  #   
  #   click_button "Sign up"
  #   
  #   open_email("myemail@test.com")
  #   visit_in_email("Confirm my account")
  #   
  #   # TODO: Add another check to verify they login to homepage
  # end
end