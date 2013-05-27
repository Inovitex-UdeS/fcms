### Methods ###

def sign_out
  page.driver.submit :delete, "/users/sign_out", {}
end

Given /^I am not logged in$/ do
  sign_out
end

Given /^I exist as a user$/ do
  @u = User.create!({:email=>"tests@inovitex.com", :last_name=>"Cucumber", :first_name=>"Tests", :telephone=>"8195555555", :birthday=>"2011-03-01",
                :password=>"123test123", :password_confirmation=>"123test123",
                :confirmed_at => DateTime.now})
end