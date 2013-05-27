Feature: Sign up
  In order to get access to protected section of the site
  A user
  I want to be able to sign up

  Background:
    Given I am not logged in
    And I am on the sign up page

  Scenario: Sign up with valid credentials
    When I fill in "user_first_name" with "Tests"
    And I fill in "user_last_name" with "Nom"
    And I fill in "user_telephone" with "8195555555"
    And I fill in "user_birthday" with "2001-01-01"
    And I fill in "user_email" with "tests@inovitex.com"
    And I fill in "user_password" with "123test123"
    And I fill in "user_password_confirmation" with "123test123"
    And I press "S'enregistrer"
    Then "tests@inovitex.com" should receive an email
    When I open the email
    Then I should see "Confirm my account" in the email body
    When I follow "Confirm my account" in the email
    Then I should see "Bienvenue!"

  Scenario: Invalid password
    When I fill in "user_first_name" with "Tests"
    And I fill in "user_last_name" with "Nom"
    And I fill in "user_telephone" with "8195555555"
    And I fill in "user_birthday" with "2001-01-01"
    And I fill in "user_email" with "tests@inovitex.com"
    And I press "S'enregistrer"
    Then I should see "Password can't be blank"
    When I fill in "user_first_name" with "Tests"
    And I fill in "user_last_name" with "Nom"
    And I fill in "user_password" with "123"
    And I fill in "user_password_confirmation" with "123"
    And I press "S'enregistrer"
    Then I should see "Password is too short (minimum is 8 characters)"

  Scenario: Invalid password confirmation
    When I fill in "user_first_name" with "Tests"
    And I fill in "user_last_name" with "Nom"
    And I fill in "user_telephone" with "8195555555"
    And I fill in "user_birthday" with "2001-01-01"
    And I fill in "user_email" with "tests@inovitex.com"
    And I fill in "user_password" with "123test123"
    And I fill in "user_password_confirmation" with "12test123"
    And I press "S'enregistrer"
    Then I should see "Password doesn't match confirmation"

  Scenario: Unique email address
    Given I exist as a user
    When I fill in "user_first_name" with "Tests"
    And I fill in "user_last_name" with "Nom"
    And I fill in "user_telephone" with "8195555555"
    And I fill in "user_birthday" with "2001-01-01"
    And I fill in "user_email" with "tests@inovitex.com"
    And I fill in "user_password" with "123test123"
    And I fill in "user_password_confirmation" with "123test123"
    And I press "S'enregistrer"
    Then I should see "Email has already been taken"



