### Methods ###
def create_guest
  @visitor ||= {  :email => "test@cucumber.com", :password => "123test123", :confirm_password => "123test123",
                  :wrong_email => "tes@cucumber.com", :wrong_password => "12test123", :wrong_confirm_password => "12test123",
                  :invalid_email => "123", :password_too_short => "123" }
end

def create_user
  visit '/users/sign_up'

  fill_in 'user_email', :with => @visitor[:email]
  fill_in 'user_password', :with => @visitor[:password]
  fill_in 'user_password_confirmation', :with => @visitor[:confirm_password]
  click_button "S'enregistrer"
end

def sign_out
  page.driver.submit :delete, "/users/sign_out", {}
end

### Given ###
Given /^I am not logged in$/ do
  sign_out
end

Given /^I exist as a user$/ do
  create_guest
  create_user
end

Given /^I am a guest$/ do
  create_guest
end

### When ###
When /^I sign in with an invalid password$/ do
  create_user
  sign_out
  visit '/users/sign_in'

  fill_in 'user_email', :with => @visitor[:email]
  fill_in 'user_password', :with => @visitor[:wrong_password]
  click_button "Se connecter"
end

When /^I sign in with an invalid email$/ do
  create_user
  sign_out
  visit '/users/sign_in'

  fill_in 'user_email', :with => @visitor[:wrong_email]
  fill_in 'user_password', :with => @visitor[:password]
  click_button "Se connecter"
end

### Then ###
Then /^I see an invalid login message$/ do
  page.should have_content "Invalid email or password."
end

Then /^I should be signed out$/ do
  page.should have_content "Connexion"
end