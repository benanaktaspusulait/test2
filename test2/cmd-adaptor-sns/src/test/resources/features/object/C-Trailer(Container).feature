@objectCTrailerContainer
Feature: SNS Command Adaptor - Object - SNS-C-TRAILER(Container)

  Background:
    Given template StreamIngestRecord source data with the following attributes
      | header.recordHash                                                     | 0123456789                                         |
      | header.correlationId                                                  | 1                                                  |
      | header.ingestDateTime                                                 | 2022-02-22T22:22:22.222Z                           |
      | header.recordCreationTime                                             | 2022-02-22T22:22:22.222Z                           |
      | header.dataFormat                                                     | api parsed test                                    |
      | header.endpoint                                                       | endpoint                                           |
      | header.carrierInteractiveIndicator                                    | carrierInteractiveIndicator                        |
      | body.xCorrelationId                                                   | xCorrelationId                                     |
      | body.headerDate                                                       | 2022-02-22T22:22:22.222                            |
      | body.movementReferenceNumber                                          | movementReferenceNumber                            |
      | body.submissionId                                                     | submissionId                                       |
      | body.metadata.senderEORI                                              | metadata.senderEORI                                |
      | body.metadata.senderBranch                                            | metadata.senderBranch                              |
      | body.metadata.messageType                                             | IE313                                              |
      | body.metadata.messageIdentification                                   | metadata.messageIdentification                     |
      | body.metadata.preparationDateTime                                     | 2022-02-22T22:22:22.222                            |
      | body.metadata.receivedDateTime                                        | 2022-02-23T22:22:22.222                            |
      | body.metadata.acceptedDateTime                                        | 2022-02-24T22:22:22.222                            |
      | body.metadata.correlationId                                           | metadata.correlationId                             |
      | body.metadata.cnitDispatchDateTime                                    | 2022-02-25T22:22:22.222                            |
      | body.declaration.localReferenceNumber                                 | declaration.localReferenceNumber                   |
      | body.declaration.place                                                | declaration.place                                  |
      | body.declaration.language                                             | declaration.language                               |
      | body.declaration.dateTime                                             | 2022-02-25T22:22:22.222                            |
      | body.declaration.officeOfLodgement                                    | declaration.officeOfLodgement                      |
      | body.amendment.movementReferenceNumber                                | amendment.movementReferenceNumber                  |
      | body.amendment.place                                                  | amendment.place                                    |
      | body.amendment.language                                               | amendment.language                                 |
      | body.amendment.dateTime                                               | 2022-02-27T22:22:22.222                            |
      | body.goods.numberOfItems                                              | 10                                                 |
      | body.goods.numberOfPackages                                           | 1                                                  |
      | body.goods.grossMass                                                  | 11.1                                               |
      | body.parties.declarant.name                                           | declarantName                                      |
      | body.parties.declarant.address.streetAndNumber                        | 100                                                |
      | body.parties.declarant.address.city                                   | Bath                                               |
      | body.parties.declarant.address.postalCode                             | BA44 4TH                                           |
      | body.parties.declarant.address.countryCode                            | 100                                                |
      | body.parties.declarant.language                                       | parties.declarant.language                         |
      | body.parties.declarant.eori                                           | BA444                                              |
      | body.parties.representative.name                                      | representativeName                                 |
      | body.parties.representative.address.streetAndNumber                   | 33                                                 |
      | body.parties.representative.address.city                              | London                                             |
      | body.parties.representative.address.postalCode                        | LN12 7ON                                           |
      | body.parties.representative.address.countryCode                       | 100                                                |
      | body.parties.representative.language                                  | parties.representative.language                    |
      | body.parties.representative.eori                                      | E1234                                              |
      | body.parties.carrier.name                                             | parties.carrier.name                               |
      | body.parties.carrier.address.streetAndNumber                          | parties.carrier.address.streetAndNumber            |
      | body.parties.carrier.address.city                                     | parties.carrier.address.city                       |
      | body.parties.carrier.address.postalCode                               | parties.carrier.address.postalCode                 |
      | body.parties.carrier.address.countryCode                              | parties.carrier.address.countryCode                |
      | body.parties.carrier.language                                         | parties.carrier.language                           |
      | body.parties.carrier.eori                                             | parties.carrier.eori                               |
      | body.parties.consignor.name                                           | partiesConsignorName                               |
      | body.parties.consignor.address.streetAndNumber                        | 90                                                 |
      | body.parties.consignor.address.city                                   | Cardiff                                            |
      | body.parties.consignor.address.postalCode                             | CA34 7FF                                           |
      | body.parties.consignor.address.countryCode                            | 100                                                |
      | body.parties.consignor.language                                       | parties.consignor.language                         |
      | body.parties.consignor.eori                                           | CA900                                              |
      | body.parties.consignee.name                                           | partiesConsigneeName                               |
      | body.parties.consignee.address.streetAndNumber                        | 23                                                 |
      | body.parties.consignee.address.city                                   | Paris                                              |
      | body.parties.consignee.address.postalCode                             | PA12 IS                                            |
      | body.parties.consignee.address.countryCode                            | 200                                                |
      | body.parties.consignee.language                                       | parties.consignee.language                         |
      | body.parties.consignee.eori                                           | PE765                                              |
      | body.parties.notifyParty.name                                         | partiesNotifyName                                  |
      | body.parties.notifyParty.address.streetAndNumber                      | 56                                                 |
      | body.parties.notifyParty.address.city                                 | Bristol                                            |
      | body.parties.notifyParty.address.postalCode                           | BR00 6OL                                           |
      | body.parties.notifyParty.address.countryCode                          | 100                                                |
      | body.parties.notifyParty.language                                     | parties.notifyParty.language                       |
      | body.parties.notifyParty.eori                                         | BR987                                              |
      | body.goods.goodsItems.0.itemNumber                                    | IN1234                                             |
      | body.goods.goodsItems.0.description                                   | goods.goodsItems.0.description                     |
      | body.goods.goodsItems.0.descriptionLanguage                           | goods.goodsItems.0.descriptionLanguage             |
      | body.goods.goodsItems.0.grossMass                                     | 10.5                                               |
      | body.goods.goodsItems.0.consignor.name                                | goodsConsignorName                                 |
      | body.goods.goodsItems.0.consignor.address.streetAndNumber             | 11                                                 |
      | body.goods.goodsItems.0.consignor.address.city                        | Birmingham                                         |
      | body.goods.goodsItems.0.consignor.address.postalCode                  | BH1 2AM                                            |
      | body.goods.goodsItems.0.consignor.address.countryCode                 | 100                                                |
      | body.goods.goodsItems.0.consignor.language                            | goods.goodsItems.0.consignor.language              |
      | body.goods.goodsItems.0.consignor.eori                                | GB00000                                            |
      | body.goods.goodsItems.0.consignee.name                                | goodsConsigneeName                                 |
      | body.goods.goodsItems.0.consignee.address.streetAndNumber             | 15                                                 |
      | body.goods.goodsItems.0.consignee.address.city                        | London                                             |
      | body.goods.goodsItems.0.consignee.address.postalCode                  | LD12 3ON                                           |
      | body.goods.goodsItems.0.consignee.address.countryCode                 | 100                                                |
      | body.goods.goodsItems.0.consignee.language                            | goods.goodsItems.0.consignee.language              |
      | body.goods.goodsItems.0.consignee.eori                                | GB12345                                            |
      | body.goods.goodsItems.0.containers.0.containerNumber                  | 123                                                |
      | body.goods.goodsItems.0.identityOfMeansOfCrossingBorder.0.nationality | Nationality                                        |
      | body.goods.goodsItems.0.identityOfMeansOfCrossingBorder.0.identity    | Identity                                           |
      | body.goods.goodsItems.0.identityOfMeansOfCrossingBorder.0.language    | Language                                           |
      | body.goods.goodsItems.0.notifyParty.name                              | notifyPartyName                                    |
      | body.goods.goodsItems.0.notifyParty.address                           | 100                                                |
      | body.goods.goodsItems.0.notifyParty.address.streetAndNumber           | 100                                                |
      | body.goods.goodsItems.0.notifyParty.address.city                      | Reading                                            |
      | body.goods.goodsItems.0.notifyParty.address.postalCode                | RG1 0NG                                            |
      | body.goods.goodsItems.0.notifyParty.address.countryCode               | 100                                                |
      | body.goods.goodsItems.0.notifyParty.language                          | goods.goodsItems.0.notifyParty.language            |
      | body.goods.goodsItems.0.notifyParty.eori                              | GB99999                                            |
      | body.goods.goodsItems.0.documents.0.type                              | body.goods.goodsItems.0.documents.0.type           |
      | body.goods.goodsItems.0.documents.0.reference                         | body.goods.goodsItems.0.documents.0.reference      |
      | body.goods.goodsItems.0.documents.0.language                          | body.goods.goodsItems.0.documents.0.language       |
      | body.itinerary.modeOfTransportAtBorder                                | 10                                                 |
      | body.itinerary.identityOfMeansOfCrossingBorder.nationality            | Nationality                                        |
      | body.itinerary.identityOfMeansOfCrossingBorder.identity               | vehicle001#trailer001                              |
      | body.itinerary.identityOfMeansOfCrossingBorder.language               | itinerary.identityOfMeansOfCrossingBorder.language |
      | body.itinerary.officeOfFirstEntry.reference                           | itinerary.officeOfFirstEntry.reference             |
      | body.itinerary.officeOfFirstEntry.expectedDateTimeOfArrival           | 2022-02-29T22:22:22.222                            |
      | body.itinerary.officesOfSubsequentEntry.0                             | itinerary.officesOfSubsequentEntry                 |

  Scenario: ObjectRecord - SNS-C-TRAILER(Container)
    When StreamIngestRecord source data is presented with attributes as per the template to the fdp-sns-input_0 input topic
    When the background template of Sns data is changed to
      | field                                  | value                     |
      | body.itinerary.modeOfTransportAtBorder | <modeOfTransportAtBorder> |
    Then 1 Object Commands for SNS-C-TRAILER(CONTAINER) will be emitted
    And one Object record for "SNS-C-TRAILER(CONTAINER)" with following attributes
      | metadata.identityRecord.poleId.v2.id          | SNSENS:P=null[{movementReferenceNumber123}],O={movementReferenceNumber123} |
      | metadata.identityRecord.type                  | O                                                                          |
      | metadata.sourceRecord.name                    | SNSENS                                                                     |
      | metadata.sourceRecord.shortName               | SNS                                                                        |
      | metadata.sourceRecord.location                | submissionIdmetadata.messageIdentification                                 |
      | metadata.sourceRecord.id                      | {movementReferenceNumber123}                                               |
      | metadata.sourceRecord.audit.createdBy         | 0123456789                                                                 |
      | metadata.sourceRecord.audit.createdTimestamp  | 2022-02-22T22:22:22.222Z                                                   |
      | metadata.sourceRecord.audit.updatedBy         | null                                                                       |
      | metadata.sourceRecord.audit.updatedTimestamp  | null                                                                       |
      | metadata.sourceRecord.audit.deletedBy         | null                                                                       |
      | metadata.sourceRecord.audit.deletedTimestamp  | null                                                                       |
      | metadata.mappingRecord.name                   | SNS-C-TRAILER(CONTAINER)                                                   |
      | metadata.mappingRecord.version                | mappingVersion                                                             |
      | metadata.complianceRecord.visibility          | UNKNOWN                                                                    |
      | metadata.complianceRecord.gscMarker           | null                                                                       |
      | metadata.complianceRecord.retentionMarkerDays | -1                                                                         |
      | snapshotTrigger                               | null                                                                       |
      | startTimestamp                                | null                                                                       |
      | endTimestamp                                  | null                                                                       |
      | name                                          | null                                                                       |
      | description                                   | null                                                                       |
      | additionalInformation                         | null                                                                       |
      | url                                           | null                                                                       |
      | type                                          | VEHICLE                                                                    |
      | vehicle.type                                  | OBJVEHCTRL                                                                 |
      | vehicle.make                                  | null                                                                       |
      | vehicle.model                                 | null                                                                       |
      | vehicle.vin                                   | null                                                                       |
      | vehicle.registrationCountry                   | null                                                                       |
      | vehicle.registrationNumber                    | 123                                                                        |
      | vehicle.year                                  | null                                                                       |
      | vehicle.colour                                | null                                                                       |
      | vehicle.markings                              | null                                                                       |
      | party.poleId.v2.id                            | SNSENS:P=null[{movementReferenceNumber123}]                                |
      | party.type                                    | P                                                                          |
      | role                                          | PTOOLINK                                                                   |
      | attributes.attrs.header.ingestDateTime        | 2022-02-22T22:22:22.222Z                                                   |

  Scenario Outline: STOP: SNS-C-TRAILER(CONTAINER) not created if containerNumber is NONE or null
    When the background template of Sns data is changed to
      | field                                                | value   |
      | body.goods.goodsItems.0.containers.0.containerNumber | <value> |
    And StreamIngestRecord source data is presented with attributes as per the template to the fdp-sns-input_0 input topic
    Then 0 Object Commands for SNS-C-TRAILER(CONTAINER) will be emitted
    Examples:
      | value |
      | NONE  |
      | null  |
