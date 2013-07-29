@ok
Feature: Admin/Editions
  In order to manage editions
  An Admin
  Should be able to modify and add editions

  Background:
    Given I exist as a user
    And I am an Admin
    And the 1999 and 2099 editions are created
    And I am logged in
    And I am on the edition page

  Scenario: Verify if I'm on the admin edition page
    Then I should see "Gestion des éditions"

  @javascript
  Scenario: Add a new edition
    When I js click on "addItem"
    And I fill in "Année de l'édition" with "2055"
    And I js change the input "edition_start_date" value for "2100-01-01"
    And I js change the input "edition_end_date" value for "2100-12-31"
    And I js click on "formSave"
    Then I should see "2055"

  @javascript
  Scenario: Delete an Edition
    When I js click on the table row containing "2099"
    And I js click on "deleteItem"
    And I reload the page
    Then I should not see "2099"

  @javascript
  Scenario: Modify an Edition
    When I js double click on the table row containing "2099"
    And I js change the input "edition_end_date" value for "2100-12-31"
    And I js change the input "edition_start_date" value for "2100-01-01"
    And I js change the input "edition_year" value for "2100"
    And I js click on "formSave"
    Then I should not see "2099-01-01"