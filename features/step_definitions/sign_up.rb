### Methods ###


### Given ###
Given /^I visit sign up page$/ do
  visit '/users/sign_up'
end

### When ###
When /^I sign up with valid credentials$/ do
  fill_in 'user_email', :with => @visitor[:email]
  fill_in 'user_password', :with => @visitor[:password]
  fill_in 'user_password_confirmation', :with => @visitor[:confirm_password]
  click_button "S'enregistrer"
end

When /^I sign up with an invalid email$/ do
  fill_in 'user_email', :with => @visitor[:invalid_email]
  fill_in 'user_password', :with => @visitor[:password]
  fill_in 'user_password_confirmation', :with => @visitor[:confirm_password]
  click_button "S'enregistrer"
end

When /^I sign up with a short password$/ do
  fill_in 'user_email', :with => @visitor[:email]
  fill_in 'user_password', :with => @visitor[:password_too_short]
  fill_in 'user_password_confirmation', :with => @visitor[:confirm_password]
  click_button "S'enregistrer"
end

When /^I sign up with an invalid password confirmation$/ do
  fill_in 'user_email', :with => @visitor[:email]
  fill_in 'user_password', :with => @visitor[:password]
  fill_in 'user_password_confirmation', :with => @visitor[:wrong_confirm_password]
  click_button "S'enregistrer"
end

### Then ###
Then /^I should be signed in$/ do
  page.should have_content "Bienvenue!"
end

Then /^I should see a prohibited saving message$/ do
  page.should have_content "prohibited this user from being saved"
end

Then /^I should see an invalid email message$/ do
  page.should have_content "Email is invalid"
end

Then /^I should see a password too short message$/ do
  page.should have_content "Password is too short (minimum is 8 characters)"
end

Then /^I should see an invalid password confirmation message$/ do
  page.should have_content "Password doesn't match confirmation"
end
