
Feature: Admin dumps the database
  As an admin user
  I want to be able to dump the database
  So that I can refer it afterwards

  Scenario: Dump/Export database button
    Given the admin is logged in
    When the admin is on the Admin Landing page
    Then the admin should see the "Export Database" button

  # Rails is weird about how send_data works, flash messages can't be added
  Scenario: Admin dumps/exports the database successfully
    Given the admin is logged in
    When the admin is on the Admin Landing page
    And the admin clicks the "Export Database" button
    Then the admin should see "CREATE TABLE"
    # And the admin should be redirected to the Admin Landing page

