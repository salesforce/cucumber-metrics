@smoke_test @two_bg_tests
Feature: Test the ability to save to the db with background steps

  Background:
    Given I have a background step
    And I have another bg step

  @first_bg_test
  Scenario: Verify the metrics can be saved with a background step
    Then The scenario should not fail

  @second_bg_test
  Scenario: Verify a second scenario with bg steps passes
    Then The scenario should not fail