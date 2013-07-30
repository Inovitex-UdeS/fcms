@ok
Feature: Admin/Schools
  In order to manage schools
  An Admin
  Should be able to modify and add schools

  Background:
    Given I exist as a user
    And I am an Admin
    And I am logged in
    And I am on the admin schools page

  Scenario: Verify if I'm on the composer page
    Then I should see "Gestion des institutions scolaires"

  @javascript
  Scenario: Add a new School
    When I js click on "addItem"
    And I fill in "school_name" with "Saint-Connu-De-Paquette"
    And I js change the typeahead "school_schooltype_id" value for "1"
    And I js change the typeahead "school_schoolboard_id" value for "1"
    And I js change the input "school_contactinfo_attributes_telephone" value for "819-993-4995"
    And I js change the input "school_contactinfo_attributes_address" value for "666 HellStreet"
    And I js change the input "school_contactinfo_attributes_address2" value for "APT. 4"
    And I js change the input "school_contactinfo_attributes_postal_code" value for "J0KH3H"
    And I js change the typeahead "school_contactinfo_attributes_city_id" value for "1"
    And I js change the input "school_contactinfo_attributes_province" value for "Hell"
    And I js click on "formSave"
    And I js fill the datatables-search for "Saint-Connu-De-Paquette"
    Then I should see "Saint-Connu-De-Paquette"

  @javascript
  Scenario: Delete a school
    When I js click on the table row containing "École de la Passerelle"
    And I js click on "deleteItem"
    And I reload the page
    Then I should not see "École de la Passerelle"

  @javascript
  Scenario: Modify a composer
    When I js double click on the table row containing "École de la Passerelle"
    And I js change the input "school_name" value for "École de la rue"
    And I js click on "formSave"
    Then I should not see "École de la Passerelle"