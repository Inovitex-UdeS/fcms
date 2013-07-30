@ok
Feature: Admin/Schoolboards
  In order to manage schoolboards
  An Admin
  Should be able to modify and add schoolboards

  Background:
    Given I exist as a user
    And I am an Admin
    And I am logged in
    And I am on the admin schoolboards page

  Scenario: Verify if I'm on the schoolboard page
    Then I should see "Gestion des commissions scolaires"

  @javascript
  Scenario: Add a new schoolboard
    When I js click on "addItem"
    And I fill in "schoolboard_name" with "Saint-Venu-De-Paquette"
    And I js click on "formSave"
    And I js fill the datatables-search for "Saint-Venu-De-Paquette"
    Then I should see "Saint-Venu-De-Paquette"

  @javascript
  Scenario: Delete a schoolboard
    When I js click on the table row containing "Collège Notre-Dame-des-Servites"
    And I js click on "deleteItem"
    And I reload the page
    Then I should not see "Collège Notre-Dame-des-Servites"

  @javascript
  Scenario: Modify a schoolboard
    When I js double click on the table row containing "Collège Notre-Dame-des-Servites"
    And I js change the input "schoolboard_name" value for "JPASS"
    And I js click on "formSave"
    Then I should not see "Collège Notre-Dame-des-Servites"