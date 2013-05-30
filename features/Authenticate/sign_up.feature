@ok
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
    And I fill in "user_birthday" with "2001-01-01"
    And I fill in "user_email" with "tests@inovitex.com"
    And I fill in "user_password" with "123test123"
    And I fill in "user_password_confirmation" with "123test123"
    And I press "S'enregistrer"
    Then "tests@inovitex.com" should receive an email
    When I open the email
    Then I should see "Confimer mon compte" in the email body
    When I follow "Confimer mon compte" in the email
    Then I should see "Accueil"

  Scenario: Invalid password
    When I fill in "user_first_name" with "Tests"
    And I fill in "user_last_name" with "Nom"
    And I fill in "user_birthday" with "2001-01-01"
    And I fill in "user_email" with "tests@inovitex.com"
    And I press "S'enregistrer"
    Then I should see "Le mot de passe doit être rempli"
    When I fill in "user_first_name" with "Tests"
    And I fill in "user_last_name" with "Nom"
    And I fill in "user_password" with "123"
    And I fill in "user_password_confirmation" with "123"
    And I press "S'enregistrer"
    Then I should see "Le mot de passe est trop court"

  Scenario: Invalid password confirmation
    When I fill in "user_first_name" with "Tests"
    And I fill in "user_last_name" with "Nom"
    And I fill in "user_birthday" with "2001-01-01"
    And I fill in "user_email" with "tests@inovitex.com"
    And I fill in "user_password" with "123test123"
    And I fill in "user_password_confirmation" with "12test123"
    And I press "S'enregistrer"
    Then I should see "Le mot de passe ne concorde pas avec la confirmation"

  Scenario: Unique email address
    Given I exist as a user
    When I fill in "user_first_name" with "Tests"
    And I fill in "user_last_name" with "Nom"
    And I fill in "user_birthday" with "2001-01-01"
    And I fill in "user_email" with "tests@inovitex.com"
    And I fill in "user_password" with "123test123"
    And I fill in "user_password_confirmation" with "123test123"
    And I press "S'enregistrer"
    Then I should see "L'adresse courriel n'est pas disponible"



