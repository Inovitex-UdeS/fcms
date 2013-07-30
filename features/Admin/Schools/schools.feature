@wip
Feature: Admin/Schools
  In order to manage schools
  An Admin
  Should be able to modify and add schools

  Background:
    Given I exist as a user
    And I am an Admin
    And I am logged in
    And I am on the admin schools page

#  Scenario: Verify if I'm on the composer page
#    Then I should see "Gestion des institutions scolaires"

  @javascript
  Scenario: Add a new composer
    When I js click on "addItem"
    And I fill in "school_name" with "Saint-Venu-De-Paquette"
    #And I js change the input "school_schoolboard_id" value for "1"
    #And I js do a tab
    And I wait for "100"
    And I js click on "formSave"
    And I js fill the datatables-search for "Saint-Venu-De-Paquette"
    Then I should see "Saint-Venu-De-Paquette"

#  @javascript
#  Scenario: Delete a composer
#    When I js click on the table row containing "SOR F."
#    And I js click on "deleteItem"
#    And I reload the page
#    Then I should not see "SOR F."
#
#  @javascript
#  Scenario: Modify a composer
#    When I js double click on the table row containing "SOR F."
#    And I js change the input "composer_name" value for "MOM Y."
#    And I js click on "formSave"
#    Then I should not see "SOR F."