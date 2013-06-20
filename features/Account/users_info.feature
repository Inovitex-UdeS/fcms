@ok
Feature: Change user sign info field
  In order to change the user infos
  A user
  Should be able to modify his email and password

  Background:
    Given I exist as a user
    And I am logged in
    And I am on the user sign info page

  Scenario: Verify if I'm on the user sign info page
    Then I should see "Courriel et mot de passe"

  Scenario: Successful email change
    When I fill in "Courriel" with "ikillmyself@me.com"
    And I fill in "Mot de passe présent" with "123test123"
    And I press "Enregistrer"
    Then I should see "Bienvenue"

  Scenario: Unsuccessful email change
    When I fill in "Courriel" with "ikillmyself@me.com"
    And I fill in "Mot de passe présent" with "123tttttest123"
    And I press "Enregistrer"
    Then I should not see "Bienvenue"

  Scenario: Successful password change
    When I fill in "Mot de passe présent" with "123test123"
    And I fill in "Nouveau mot de passe" with "testtest000"
    And I fill in "Confirmation du nouveau mot de passe" with "testtest000"
    And I press "Enregistrer"
    Then I should see "Bienvenue"
