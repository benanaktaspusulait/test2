@runlog
Feature: Test SNS Command Adaptor - end to end - RunLog test for all pole entities
  This feature file is to verify whether a fully populated StreamIngestRecord input produce the runLog message contains all the commands and snapshots for each pole entity
  The following records are expected to be emitted for both Commands and Snapshots:
  16 Parties
  13　Object
  16 Locations
  56 Events
  6 Services

  Background:
    Given template StreamIngestRecord with the base file "sns-multiple.input"

  @cmd @smoke
  Scenario: Runlog Check all commands are produced for each pole entity
    Given template StreamIngestRecord with the base file "sns-multiple.input"
    And template EoriCdlzLandingRecord with the base file "eori.input"
    When Eori CDLZ data is presented as per the template to the landing topic landing-413
    When Readiness health check is completed
    And StreamIngestRecord source data is presented with attributes as per the template to the input topic with prefix fdp-sns-input
    Then 1 runlog messages will be emitted
    And runlog contains 16 Party
    And runlog contains 13 Object
    And runlog contains 16 Location
    And runlog contains 56 Event
    And runlog contains 6 Service