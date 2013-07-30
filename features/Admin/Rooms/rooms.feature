@ok
Feature: Admin/Rooms
  In order to manage rooms
  An Admin
  Should be able to modify and add rooms

  Background:
    Given I exist as a user
    And I am an Admin
    And I am logged in
    And I am on the admin rooms page

  Scenario: Verify if I'm on the rooms page
    Then I should see "Gestion des locaux"

  @javascript
  Scenario: Add a new room
    When I js click on "addItem"
    And I js change the input "room_capacity" value for "9000"
    And I js change the input "room_name" value for "Its Over"
    And I js change the input "room_location" value for "Univ"
    And I js change the input "room_description" value for "READ THE DAMN SIGN!"
    And I js click on "formSave"
    And I js fill the datatables-search for "Its Over"
    Then I should see "Its Over"

  @javascript
  Scenario: Delete a room
    When I js click on the table row containing "Bandeen"
    And I js click on "deleteItem"
    And I reload the page
    Then I should not see "Bandeen"

  @javascript
  Scenario: Modify a room
    When I js double click on the table row containing "Bandeen"
    And I js change the input "room_name" value for "Bangarang"
    And I js click on "formSave"
    Then I should not see "Bandeen"