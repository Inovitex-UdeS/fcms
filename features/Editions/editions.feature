@ok
Feature: Editions
  In order to manage editions
  An Admin
  Should be able to modify and add editions

  Background:
    Given I exist as a user
    And I am an Admin
    And the 2099 edition is created
    And I am logged in
    And I am on the edition page

  Scenario: Verify if I'm on the profile page
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
    When I js click on the table row containing "2099"
    And I js click on "deleteItem"
    Then I should not see "2099"

  @javascript
  Scenario: Modify an Edition
    When I js click on the table row containing "2099"
    And I js change the input "edition_end_date" value for "2100-12-31"
    And I js change the input "edition_start_date" value for "2100-01-01"
    And I js change the input "edition_year" value for "2100"
    And I press "Enregistrer"
    # I should not see the old edition_start_date
    Then I should not see "2099-01-01"