Feature: Change profile field
  In order to change the user infos
  A user
  Should be able to modify his infos

  Background:
    Given I exist as a user
    And I am on the sign in page
    And I fill in "user_email" with "test@inovitex.com"
    And I fill in "user_password" with "12test123"
    And I press "Se connecter"
    And I visit the profile page


  Scenario: Successful name and address change
    When I fill in "Adresse 1" with "666 Hellstreet"
    And I fill in "Nom de famille" with "Satan"
    And I fill in "Mot de passe" with "12test123"
    And I fill in "Confirmation du mot de passe" with "12test123"
    And I press "Sauvegarder"
    Then I should see "Bienvenue!"

