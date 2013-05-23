Feature: Forgotten Password
  In order to recuperate a password when forgiven
  As a user
  I want to be able to retrieve it

  Background:
    Given I exist as a user
    And I am not logged in
    And I visit lost password page
    And I can see lost password title

  Scenario: Using a valid email
    When I use an existent email to retrieve a password
    Then I should be redirected to the landing page
    And I should see a message indicating further instructions

  Scenario: Using an invalid email
    When I use an non-existent email to retrieve a password
    Then I should see a prohibited saving message
    And I should see an email not found message