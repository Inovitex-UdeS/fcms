@ok
Feature: Sign in
  In order to get access to protected section of the site
  A user
  Should be able to sign in

  Background:
    Given I exist as a user
    And I am not logged in
    And I am on the sign in page

  Scenario: User enters wrong email
    When I fill in "user_email" with "test@inovitex.com"
    And I fill in "user_password" with "12test123"
    And I press "Se connecter"
    Then I should see "L'adresse courriel n'a pas été trouvée."

  Scenario: User enters wrong password
    When I fill in "user_email" with "tests@inovitex.com"
    And I fill in "user_password" with "12test123"
    And I press "Se connecter"
    Then I should see "Adresse courriel ou mot de passe invalide."

  Scenario: User enters valid credentials
    When I fill in "user_email" with "tests@inovitex.com"
    And I fill in "user_password" with "123test123"
    And I press "Se connecter"
    Then I should see "Accueil"

