@todo
Feature: Registration
  In order to get register for the festival
  A user
  Should be able to submit a registration form

  Background:
    Given I exist as a user
    And I am logged in
    And I visit registratrion page

  Scenario: Using valid credentials
    Given I select a valid teacher
    And I select a valid category
    And I select a valid composer
    And I select a valid title
    And I fill in a valid movement text
    And I use a valid duration
    And I respect the maximum amount of partner
    And I agree to submit the form
    When I press on send registration
    Then the registration form is sent correctly

  Scenario: Invalid teacher
    Given I select an invalid teacher
    When I press on submit
    Then an error message is displayed

  Scenario: Invalid category
    Given I select an invalid category
    When I press on send registration
    Then an error message is displayed

  Scenario: Invalid composer
    Given I select an invalid composer
    When I press on send registration
    Then an error message is displayed

  Scenario: Invalid title
    Given I select an invalid title
    When I press on send registration
    Then an error message is displayed

  Scenario: Invalid amount of partner
    Given I add in too much partner
    When I press on submit
    Then an error message is displayed

  Scenario: Invalid agreement
    Given I dont agree to submit the form
    When I press on send registration
    Then an error message is displayed

