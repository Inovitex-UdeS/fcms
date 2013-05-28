### METHODS ###
def create_credentials
  @credentials ||= {  :validTeacherId => 1,   :invalidTeacherId => 479,
                      :validCategoryId => 1,  :invalidCategoryId => 479,
                      :validComposerId => 1,  :invalidComposerId => 479,
                      :validTitleId => 1,     :invalidTitleId => 479 }
end

### GIVEN ###
Given /^I visit registration page$/ do
  visit '/registration/new'
end

Given /^I am logged in$/ do
  visit '/users/sign_in'
  fill_in("user_email", :with => "test@inovitex.com")
  fill_in("user_password", :with => "12test123")
  click_button("Se connecter")
end

### WHEN ###

### THEN ###