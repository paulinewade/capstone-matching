Feature: Admin manages Configuration
    As an admin
    I want to manage the Configuration
    So that I can configure the application

  Scenario: Admin navigates to the Configuration page
    Given the admin is logged in
    When the admin is on the Admin Landing page
    Then the admin should see the "Configuration" link
    When the admin clicks the "Configuration" link
    Then the admin should be on the "Configuration" page
    Then the admin should see "Configuration" title

  Scenario: Successful configuration update
    Given I am on the configuration page
    When I update the configuration
    Then I should see a success message