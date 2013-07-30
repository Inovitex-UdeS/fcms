@ok
Feature: Admin/Pieces
  In order to manage pieces
  An Admin
  Should be able to modify and add pieces

  Background:
    Given I exist as a user
    And I am an Admin
    And I am logged in
    And I am on the admin pieces page

  Scenario: Verify if I'm on the piece page
    Then I should see "Gestion des oeuvres"

  @javascript
  Scenario: Add a new piece
    When I js click on "addItem"
    And I fill in "piece_title" with "La mère à Huard"
    And I js set the select2 "s2id_piece_composer_id" value for "sor"
    And I js click on "formSave"
    And I js fill the datatables-search for "La mère à Huard"
    Then I should see "La mère à Huard"

  @javascript
  Scenario: Delete a piece
    When I js click on the table row containing "Canarios"
    And I js click on "deleteItem"
    And I reload the page
    Then I should not see "Canarios"

  @javascript
  Scenario: Modify a piece
    When I js double click on the table row containing "Canarios"
    And I js change the input "piece_title" value for "LOLLLL"
    And I js set the select2 "s2id_piece_composer_id" value for "san"
    And I js click on "formSave"
    Then I should not see "Canarios"