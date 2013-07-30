@ok
Feature: Admin/Instruments
  In order to manage instruments
  An Admin
  Should be able to modify and add instruments

  Background:
    Given I exist as a user
    And I am an Admin
    And I am logged in
    And I am on the admin instruments page

  Scenario: Verify if I'm on the instruments page
    Then I should see " Gestion des instruments"

  @javascript
  Scenario: Add a new instrument
    When I js click on "addItem"
    And I fill in "instrument_name" with "Voix de Huard"
    And I js click on "formSave"
    And I js fill the datatables-search for "Voix de Huard"
    Then I should see "Voix de Huard"

  @javascript
  Scenario: Delete an insturment
    When I js click on the table row containing "Violon"
    And I js click on "deleteItem"
    And I reload the page
    Then I should not see "Violon"

  @javascript
  Scenario: Modify an instrument
    When I js double click on the table row containing "Trombonne"
    And I js change the input "instrument_name" value for "Voicez"
    And I js click on "formSave"
    Then I should not see "Trombonne"