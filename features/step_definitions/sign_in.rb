### Methods ###

def sign_out
  page.driver.submit :delete, "/users/sign_out", {}
end

Given /^I am not logged in$/ do
  sign_out
end

Given /^I exist as a user$/ do

  @city = City.create!({:name => "TestCity", :created_at => DateTime.now, :updated_at => DateTime.now})

  @co = Contactinfo.create!({:telephone => "819-993-4995", :address => "666 Hellstreet", :postal_code => "J1K1C5", :province => "Quebec",
                          :created_at => DateTime.now, :updated_at => DateTime.now, :city_id => @city.id})

  @u = User.create!({:email=>"tests@inovitex.com", :last_name=>"Cucumber", :first_name=>"Tests", :birthday=>"2011-03-01",
                :password=>"123test123", :password_confirmation=>"123test123",
                :confirmed_at => DateTime.now, :contactinfo_id => @co.id})

  @u.contactinfo = @co
  @co.city = @city

end