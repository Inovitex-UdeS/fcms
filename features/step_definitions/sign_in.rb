### Methods ###

def sign_out
  page.driver.submit :delete, "/users/sign_out", {}
end

Given /^I am not logged in$/ do
  sign_out
end

Given /^I exist as a user$/ do

  DatabaseCleaner.clean
  load "#{Rails.root}/db/seeds.rb"

  @city = City.create(name: "TestCity")

  @co = Contactinfo.create(telephone: "819-993-4995", address: "666 Hellstreet", postal_code: "J1K1C5", province:  "Quebec", city_id: @city.id)

  @u = User.create(id: 200, last_name: 'Cucumber', first_name: 'Tests', gender: true, birthday: '2011-03-01',
                   email: 'tests@inovitex.com', password: '123test123', confirmed_at: '2013-05-28 02:01:11.70392', contactinfo_id: @co.id)

  @role = Role.find_or_create_by_name(name: 'Participant')
  @u.roles << @role

end