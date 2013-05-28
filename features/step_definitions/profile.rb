### METHODS ###

### GIVEN ###
Given /^I visit the profile page/ do
  userId = @u[:id]
  visit "/users/#{userId}/edit"
end

### When ###

### Then ###