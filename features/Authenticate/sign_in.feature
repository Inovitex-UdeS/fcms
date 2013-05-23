Feature: Sign in
  In order to get access to protected section of the site
  A user
  Should be able to sign in

  Scenario: User enters wrong password
    Given I exist as a user
    And I am not logged in
    When I sign in with an invalid password
    Then I see an invalid login message
    And I should be signed out

  Scenario: User enters wrong email
    Given I exist as a user
    And I am not logged in
    When I sign in with an invalid email
    Then I see an invalid login message
    And I should be signed out
