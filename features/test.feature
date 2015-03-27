@smoke_test @two_normal_tests
Feature: Test the ability of the gem to save to the db

  @first_normal_test
  Scenario: Verify a test can run
    Given I run the test
    Then The test should not fail

  @second_normal_test
  Scenario: Verify a second test can run
    Given I run the test
    Then The test should not fail