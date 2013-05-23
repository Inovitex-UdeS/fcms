Feature: Sign up
  In order to get access to protected section of the site
  A user
  I want to be able to sign up

  Background:
    Given I am a guest
    And I visit sign up page

  Scenario: Sign up with valid credentials
    When I sign up with valid credentials
    Then I should be signed in

  Scenario: Sign up with invalid email
    When I sign up with an invalid email
    Then I should see a prohibited saving message
    And I should see an invalid email message

  Scenario: Sign up with a password too short
    When I sign up with a short password
    Then I should see a prohibited saving message
    And I should see a password too short message

  Scenario: Sign up with invalid password confirmation
    When I sign up with an invalid password confirmation
    Then I should see a prohibited saving message
    And I should see an invalid password confirmation message