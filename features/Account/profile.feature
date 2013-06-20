@ok
Feature: Change profile field
  In order to change the user infos
  A user
  Should be able to modify his infos

  Background:
    Given I exist as a user
    And I am logged in
    And I am on the profile page

  Scenario: Verify if I'm on the profile page
    Given I am on the profile page
    Then I should see "Page de profil"


  Scenario: Successful name and address change
    When I fill in "Nom de famille" with "Satan"
    And I fill in "Adresse, ligne 1" with "666 Hellstreet"
    And I press "Sauvegarder"
    Then I should see "Bienvenue"

  Scenario: unsuccessful birthday and name change
    When I fill in "Date de naissance" with "2013-99-28"
    And I fill in "Nom de famille" with "Satan"
    And I press "Sauvegarder"
    Then I should not see "Bienvenue"

  Scenario: Successful info change!
    When I fill in "Adresse, ligne 1" with "666 Hellstreet"
    And  I fill in "Adresse, ligne 2" with "777 Angelstreet"
    And I fill in "Nom de famille" with "Satan"
    And I fill in "Code postal" with "J1K1C6"
    And I fill in "Province" with "Ontario"
    And I click on "Féminin"
    And I press "Sauvegarder"
    Then I should see "Bienvenue"


