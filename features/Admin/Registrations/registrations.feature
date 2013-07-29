@wip
Feature: Admin/Registrations
  In order to manage editions
  An Admin
  Should be able to modify and add editions

  Background:
    Given I exist as a user
    And I am an Admin
    And I am logged in
    And I am on the admin registration page

  Scenario: Verify if I'm on the admin registration page
    Then I should see "Gestion des inscriptions au festival"

  @javascript
  Scenario: Add a new registration
    When I wait for "10"
    #I select the option containing "Prof" in the autocomplete
    #And I select the option containing "Part" in the autocomplete
    #When I type in "Accom Pagnateur (accomp@iaccomp.com)" into autocomplete list "registration_user_accompanist_id" and I choose "Accom Pagnateur (accomp@iaccomp.com)"
    #I js select the first value of "registration_user_owner_id"
    #And I js change the input "registration_user_owner_id" value for "2100-01-01"
    And I js select the first value of "registration_user_owner_id"
    #And I js select the first value of "registration_user_owner_id"
    And I js select the first value of "registration_user_accompanist_id"
    And I wait for "30"
    Then I should see a message indicating further instructions


