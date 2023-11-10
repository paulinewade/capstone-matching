Feature: Admin manages student form availability

  Scenario: Admin navigates to the open and close student form page
    Given the admin is logged in
    When the admin is on the Admin Landing page
    Then the admin should see the "Configuration" link
    When the admin clicks the "Configuration" link
    Then the admin should be on the "Open/Close Student Form" page
    Then the admin should see "Open and Close Student Form" title