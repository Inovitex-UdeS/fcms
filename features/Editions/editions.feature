@wip
Feature: Editions
  In order to manage editions
  An Admin
  Should be able to modify and add editions

  Background:
    Given I exist as a user
    And I am an Admin
    And I am logged in
    And the 2099 edition is created
    And I visit the editions page

  Scenario: Verify if I'm on the profile page
    Given I visit the editions page
    Then I should see "Gestion des éditions"

  Scenario: Add a new edition
    When I fill in "Année de l'édition" with "2014"
    And I fill in "Date de début" with "2014-01-01"
    And I fill in "Date de fin" with "2014-01-01"
    And I fill in "Date limite d'inscription" with "2014-08-01"
    And I press "Enregistrer"
    Then I should see "2014"

  @javascript
  Scenario: Delete an Edition
    When I click on the table field "2099"
    And I press "Supprimer"
    Then I should not see "2099"