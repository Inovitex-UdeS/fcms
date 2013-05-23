Feature: Sign up
  In order to get access to protected section of the site
  A user
  I want to be able to sign up

  Background:
    Given I am a guest

  Scenario: Sign up with valid credentials
    Given I visit sign up page
    When I sign up with valid credentials
    Then I should be signed in

  Scenario: Sign up with invalid email
    Given I visit sign up page
    When I sign up with an invalid email
    Then I should see a prohibited saving message
    And I should see an invalid email message

  Scenario: Sign up with a password too short
    Given I visit sign up page
    When I sign up with a short password
    Then I should see a prohibited saving message
    And I should see a password too short message

  Scenario: Sign up with invalid password confirmation
    Given I visit sign up page
    When I sign up with an invalid password confirmation
    Then I should see a prohibited saving message
    And I should see an invalid password confirmation message