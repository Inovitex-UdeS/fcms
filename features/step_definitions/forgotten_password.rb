### Methods ###

### Given ###
Given /^I visit lost password page$/ do
  visit '/users/password/new'
end

Given /^I can see lost password title$/ do
  page.should have_content 'Mot de passe perdu?'
end

### When ###
When /^I use an existent email to retrieve a password$/ do
  fill_in 'user_email', :with => @visitor[:email]
  click_button "Envoyer les instructions"
end

When /^I use an non-existent email to retrieve a password$/ do
  fill_in 'user_email', :with => @visitor[:wrong_email]
  click_button "Envoyer les instructions"
end

### Then ###
Then /^I should be redirected to the landing page$/ do
  page.should have_content 'Connexion'
end

Then /^I should see a message indicating further instructions$/ do
  page.should have_content 'You will receive an email with instructions about how to reset your password in a few minutes.'
end

Then /^I should see an email not found message$/ do
  page.should have_content 'Email not found'
end