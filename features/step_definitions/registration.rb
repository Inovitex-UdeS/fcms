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

### WHEN ###

### THEN ###