@locationCNotifyAddMultiple
Feature: SNS Command Adaptor - Location - SNS-C-NOTIFY-ADD Multiple

  Background:
    Given template StreamIngestRecord source data with the following attributes
      | header.recordHash                                                     | 0123456789                                                       |
      | header.correlationId                                                  | 1                                                                |
      | header.ingestDateTime                                                 | 2022-02-22T22:22:22.222Z                                         |
      | header.recordCreationTime                                             | 2022-02-22T22:22:22.222Z                                         |
      | header.dataFormat                                                     | api parsed test                                                  |
      | header.endpoint                                                       | endpoint                                                         |
      | header.carrierInteractiveIndicator                                    | carrierInteractiveIndicator                                      |
      | body.xCorrelationId                                                   | xCorrelationId                                                   |
      | body.headerDate                                                       | 2022-02-22T22:22:22.222                                          |
      | body.movementReferenceNumber                                          | movementReferenceNumber                                          |
      | body.submissionId                                                     | submissionId                                                     |
      | body.metadata.senderEORI                                              | metadata.senderEORI                                              |
      | body.metadata.senderBranch                                            | metadata.senderBranch                                            |
      | body.metadata.messageType                                             | IE313                                                            |
      | body.metadata.messageIdentification                                   | metadata.messageIdentification                                   |
      | body.metadata.preparationDateTime                                     | 2022-02-22T22:22:22.222                                          |
      | body.metadata.receivedDateTime                                        | 2022-02-23T22:22:22.222                                          |
      | body.metadata.acceptedDateTime                                        | 2022-02-24T22:22:22.222                                          |
      | body.metadata.correlationId                                           | metadata.correlationId                                           |
      | body.metadata.cnitDispatchDateTime                                    | 2022-02-25T22:22:22.222                                          |
      | body.declaration.localReferenceNumber                                 | declaration.localReferenceNumber                                 |
      | body.declaration.place                                                | declaration.place                                                |
      | body.declaration.language                                             | declaration.language                                             |
      | body.declaration.dateTime                                             | 2022-02-25T22:22:22.222                                          |
      | body.declaration.officeOfLodgement                                    | declaration.officeOfLodgement                                    |
      | body.amendment.movementReferenceNumber                                | amendment.movementReferenceNumber                                |
      | body.amendment.place                                                  | amendment.place                                                  |
      | body.amendment.language                                               | amendment.language                                               |
      | body.amendment.dateTime                                               | 2022-02-27T22:22:22.222                                          |
      | body.goods.numberOfItems                                              | 10                                                               |
      | body.goods.numberOfPackages                                           | 1                                                                |
      | body.goods.grossMass                                                  | 11.1                                                             |
      | body.parties.declarant.name                                           | declarantName                                                    |
      | body.parties.declarant.address.streetAndNumber                        | 100                                                              |
      | body.parties.declarant.address.city                                   | Bath                                                             |
      | body.parties.declarant.address.postalCode                             | BA44 4TH                                                         |
      | body.parties.declarant.address.countryCode                            | 100                                                              |
      | body.parties.declarant.language                                       | parties.declarant.language                                       |
      | body.parties.declarant.eori                                           | BA444                                                            |
      | body.parties.representative.name                                      | representativeName                                               |
      | body.parties.representative.address.streetAndNumber                   | 33                                                               |
      | body.parties.representative.address.city                              | London                                                           |
      | body.parties.representative.address.postalCode                        | LN12 7ON                                                         |
      | body.parties.representative.address.countryCode                       | 100                                                              |
      | body.parties.representative.language                                  | parties.representative.language                                  |
      | body.parties.representative.eori                                      | E1234                                                            |
      | body.parties.carrier.name                                             | parties.carrier.name                                             |
      | body.parties.carrier.address.streetAndNumber                          | parties.carrier.address.streetAndNumber                          |
      | body.parties.carrier.address.city                                     | parties.carrier.address.city                                     |
      | body.parties.carrier.address.postalCode                               | parties.carrier.address.postalCode                               |
      | body.parties.carrier.address.countryCode                              | parties.carrier.address.countryCode                              |
      | body.parties.carrier.language                                         | parties.carrier.language                                         |
      | body.parties.carrier.eori                                             | parties.carrier.eori                                             |
      | body.parties.consignor.name                                           | partiesConsignorName                                             |
      | body.parties.consignor.address.streetAndNumber                        | 90                                                               |
      | body.parties.consignor.address.city                                   | Cardiff                                                          |
      | body.parties.consignor.address.postalCode                             | CA34 7FF                                                         |
      | body.parties.consignor.address.countryCode                            | 100                                                              |
      | body.parties.consignor.language                                       | parties.consignor.language                                       |
      | body.parties.consignor.eori                                           | CA900                                                            |
      | body.parties.consignee.name                                           | partiesConsigneeName                                             |
      | body.parties.consignee.address.streetAndNumber                        | 23                                                               |
      | body.parties.consignee.address.city                                   | Paris                                                            |
      | body.parties.consignee.address.postalCode                             | PA12 IS                                                          |
      | body.parties.consignee.address.countryCode                            | 200                                                              |
      | body.parties.consignee.language                                       | parties.consignee.language                                       |
      | body.parties.consignee.eori                                           | PE765                                                            |
      | body.parties.notifyParty.name                                         | partiesNotifyName                                                |
      | body.parties.notifyParty.address.streetAndNumber                      | 56                                                               |
      | body.parties.notifyParty.address.city                                 | Bristol                                                          |
      | body.parties.notifyParty.address.postalCode                           | BR00 6OL                                                         |
      | body.parties.notifyParty.address.countryCode                          | 100                                                              |
      | body.parties.notifyParty.language                                     | parties.notifyParty.language                                     |
      | body.parties.notifyParty.eori                                         | BR987                                                            |
      | body.goods.goodsItems.0.itemNumber                                    | IN1234                                                           |
      | body.goods.goodsItems.0.description                                   | goods.goodsItems.0.description                                   |
      | body.goods.goodsItems.0.descriptionLanguage                           | goods.goodsItems.0.descriptionLanguage                           |
      | body.goods.goodsItems.0.grossMass                                     | 10.5                                                             |
      | body.goods.goodsItems.0.consignor.name                                | goodsConsignorName                                               |
      | body.goods.goodsItems.0.consignor.address.streetAndNumber             | 11                                                               |
      | body.goods.goodsItems.0.consignor.address.city                        | Birmingham                                                       |
      | body.goods.goodsItems.0.consignor.address.postalCode                  | BH1 2AM                                                          |
      | body.goods.goodsItems.0.consignor.address.countryCode                 | 100                                                              |
      | body.goods.goodsItems.0.consignor.language                            | goods.goodsItems.0.consignor.language                            |
      | body.goods.goodsItems.0.consignor.eori                                | GB00000                                                          |
      | body.goods.goodsItems.0.consignee.name                                | goodsConsigneeName                                               |
      | body.goods.goodsItems.0.consignee.address.streetAndNumber             | 15                                                               |
      | body.goods.goodsItems.0.consignee.address.city                        | London                                                           |
      | body.goods.goodsItems.0.consignee.address.postalCode                  | LD12 3ON                                                         |
      | body.goods.goodsItems.0.consignee.address.countryCode                 | 100                                                              |
      | body.goods.goodsItems.0.consignee.language                            | goods.goodsItems.0.consignee.language                            |
      | body.goods.goodsItems.0.consignee.eori                                | GB12345                                                          |
      | body.goods.goodsItems.0.identityOfMeansOfCrossingBorder.0.nationality | goods.goodsItems.0.identityOfMeansOfCrossingBorder.0.nationality |
      | body.goods.goodsItems.0.identityOfMeansOfCrossingBorder.0.identity    | goods.goodsItems.0.identityOfMeansOfCrossingBorder.0.identity    |
      | body.goods.goodsItems.0.identityOfMeansOfCrossingBorder.0.language    | goods.goodsItems.0.identityOfMeansOfCrossingBorder.0.language    |
      | body.goods.goodsItems.0.notifyParty.name                              | notifyPartyName                                                  |
      | body.goods.goodsItems.0.notifyParty.address                           | 100                                                              |
      | body.goods.goodsItems.0.notifyParty.address.streetAndNumber           | 100                                                              |
      | body.goods.goodsItems.0.notifyParty.address.city                      | Reading                                                          |
      | body.goods.goodsItems.0.notifyParty.address.postalCode                | RG1 0NG                                                          |
      | body.goods.goodsItems.0.notifyParty.address.countryCode               | 100                                                              |
      | body.goods.goodsItems.0.notifyParty.language                          | goods.goodsItems.0.notifyParty.language                          |
      | body.goods.goodsItems.0.notifyParty.eori                              | null                                                             |
      | body.goods.goodsItems.1.itemNumber                                    | IN9876                                                           |
      | body.goods.goodsItems.1.description                                   | goods.goodsItems.1.description                                   |
      | body.goods.goodsItems.1.descriptionLanguage                           | goods.goodsItems.1.descriptionLanguage                           |
      | body.goods.goodsItems.1.grossMass                                     | 16.63                                                            |
      | body.goods.goodsItems.1.consignor.name                                | goodsConsignorName1                                              |
      | body.goods.goodsItems.1.consignor.address.streetAndNumber             | 40                                                               |
      | body.goods.goodsItems.1.consignor.address.city                        | Leeds                                                            |
      | body.goods.goodsItems.1.consignor.address.postalCode                  | LE12 0DS                                                         |
      | body.goods.goodsItems.1.consignor.address.countryCode                 | 100                                                              |
      | body.goods.goodsItems.1.consignor.language                            | goods.goodsItems.0.consignor.language                            |
      | body.goods.goodsItems.1.consignor.eori                                | LD909                                                            |
      | body.goods.goodsItems.1.consignee.name                                | goodsConsigneeName1                                              |
      | body.goods.goodsItems.1.consignee.address.streetAndNumber             | 22                                                               |
      | body.goods.goodsItems.1.consignee.address.city                        | Bristol                                                          |
      | body.goods.goodsItems.1.consignee.address.postalCode                  | BR11 1OL                                                         |
      | body.goods.goodsItems.1.consignee.address.countryCode                 | 100                                                              |
      | body.goods.goodsItems.1.consignee.language                            | goods.goodsItems.1.consignee.language                            |
      | body.goods.goodsItems.1.consignee.eori                                | BR900                                                            |
      | body.goods.goodsItems.1.identityOfMeansOfCrossingBorder.0.nationality | goods.goodsItems.1.identityOfMeansOfCrossingBorder.0.nationality |
      | body.goods.goodsItems.1.identityOfMeansOfCrossingBorder.0.identity    | goods.goodsItems.1.identityOfMeansOfCrossingBorder.0.identity    |
      | body.goods.goodsItems.1.identityOfMeansOfCrossingBorder.0.language    | goods.goodsItems.1.identityOfMeansOfCrossingBorder.0.language    |
      | body.goods.goodsItems.1.notifyParty.name                              | notifyPartyName1                                                 |
      | body.goods.goodsItems.1.notifyParty.address                           | goods.goodsItems.1.notifyParty.address                           |
      | body.goods.goodsItems.1.notifyParty.address.streetAndNumber           | 66                                                               |
      | body.goods.goodsItems.1.notifyParty.address.city                      | Liverpool                                                        |
      | body.goods.goodsItems.1.notifyParty.address.postalCode                | LI90 POL                                                         |
      | body.goods.goodsItems.1.notifyParty.address.countryCode               | 100                                                              |
      | body.goods.goodsItems.1.notifyParty.language                          | goods.goodsItems.1.notifyParty.language                          |
      | body.goods.goodsItems.1.notifyParty.eori                              | null                                                             |
      | body.itinerary.modeOfTransportAtBorder                                | 2                                                                |
      | body.itinerary.identityOfMeansOfCrossingBorder.nationality            | Nationality                                                      |
      | body.itinerary.identityOfMeansOfCrossingBorder.identity               | vehicle#trailer                                                  |
      | body.itinerary.identityOfMeansOfCrossingBorder.language               | itinerary.identityOfMeansOfCrossingBorder.language               |
      | body.itinerary.officeOfFirstEntry.reference                           | itinerary.officeOfFirstEntry.reference                           |
      | body.itinerary.officeOfFirstEntry.expectedDateTimeOfArrival           | 2022-02-29T22:22:22.222                                          |
      | body.itinerary.officesOfSubsequentEntry.0                             | itinerary.officesOfSubsequentEntry                               |
      | body.goods.goodsItems.0.documents.0.type                              | test                                                             |
      | body.goods.goodsItems.0.documents.0.reference                         | 12345                                                            |
      | body.goods.goodsItems.0.documents.0.language                          | English                                                          |
      | body.goods.goodsItems.1.documents.0.type                              | test                                                             |
      | body.goods.goodsItems.1.documents.0.reference                         | 12345                                                            |
      | body.goods.goodsItems.1.documents.0.language                          | English                                                          |

  Scenario: LocationRecord - SNS-C-NOTIFY-ADD Multiple
    When StreamIngestRecord source data is presented with attributes as per the template to the fdp-sns-input_0 input topic
    Then 2 Location Commands for SNS-C-NOTIFY-ADD will be emitted
    And one Location record for "SNS-C-NOTIFY-ADD" with following attributes
      | metadata.identityRecord.poleId.v2.id          | SNSENS:P={notifyPartyName100ReadingRG1 0NG100}[SNS-C-NOTIFY],L={100ReadingRG1 0NG100} |
      | metadata.identityRecord.type                  | L                                                                                     |
      | metadata.sourceRecord.name                    | SNSENS                                                                                |
      | metadata.sourceRecord.shortName               | SNS                                                                                   |
      | metadata.sourceRecord.location                | submissionIdmetadata.messageIdentification                                            |
      | metadata.sourceRecord.id                      | {100ReadingRG1 0NG100}                                                                |
      | metadata.sourceRecord.audit.createdBy         | 0123456789                                                                            |
      | metadata.sourceRecord.audit.createdTimestamp  | 2022-02-22T22:22:22.222Z                                                              |
      | metadata.sourceRecord.audit.updatedBy         | null                                                                                  |
      | metadata.sourceRecord.audit.updatedTimestamp  | null                                                                                  |
      | metadata.sourceRecord.audit.deletedBy         | null                                                                                  |
      | metadata.sourceRecord.audit.deletedTimestamp  | null                                                                                  |
      | metadata.mappingRecord.name                   | SNS-C-NOTIFY-ADD                                                                      |
      | metadata.mappingRecord.version                | mappingVersion                                                                        |
      | metadata.complianceRecord.visibility          | UNKNOWN                                                                               |
      | metadata.complianceRecord.gscMarker           | null                                                                                  |
      | metadata.complianceRecord.retentionMarkerDays | -1                                                                                    |
      | snapshotTrigger                               | null                                                                                  |
      | startTimestamp                                | null                                                                                  |
      | endTimestamp                                  | null                                                                                  |
      | type                                          | ADDRESS                                                                               |
      | party.poleId.v2.id                            | SNSENS:P={notifyPartyName100ReadingRG1 0NG100}[SNS-C-NOTIFY]                          |
      | party.type                                    | P                                                                                     |
      | role                                          | PTOLASSO                                                                              |
      | address.type                                  | LOCADDR                                                                               |
      | address.postCode                              | RG1 0NG                                                                               |
      | address.poBox                                 | null                                                                                  |
      | address.fullAddress                           | notifyPartyName 100 Reading RG1 0NG 100                                               |
      | address.name                                  | notifyPartyName                                                                       |
      | address.siteLocation                          | null                                                                                  |
      | address.number                                | null                                                                                  |
      | address.street                                | 100                                                                                   |
      | address.town                                  | Reading                                                                               |
      | address.area                                  | null                                                                                  |
      | address.district                              | null                                                                                  |
      | address.county                                | null                                                                                  |
      | address.country                               | 100                                                                                   |
      | address.uniquePropertyReferenceNumber         | null                                                                                  |
      | address.latitude                              | null                                                                                  |
      | address.longitude                             | null                                                                                  |
      | attributes.attrs.header.ingestDateTime        | 2022-02-22T22:22:22.222Z                                                              |
    And one Location record for "SNS-C-NOTIFY-ADD" with following attributes
      | metadata.identityRecord.poleId.v2.id          | SNSENS:P={notifyPartyName166LiverpoolLI90 POL100}[SNS-C-NOTIFY],L={66LiverpoolLI90 POL100} |
      | metadata.identityRecord.type                  | L                                                                                          |
      | metadata.sourceRecord.name                    | SNSENS                                                                                     |
      | metadata.sourceRecord.shortName               | SNS                                                                                        |
      | metadata.sourceRecord.location                | submissionIdmetadata.messageIdentification                                                 |
      | metadata.sourceRecord.id                      | {66LiverpoolLI90 POL100}                                                                   |
      | metadata.sourceRecord.audit.createdBy         | 0123456789                                                                                 |
      | metadata.sourceRecord.audit.createdTimestamp  | 2022-02-22T22:22:22.222Z                                                                   |
      | metadata.sourceRecord.audit.updatedBy         | null                                                                                       |
      | metadata.sourceRecord.audit.updatedTimestamp  | null                                                                                       |
      | metadata.sourceRecord.audit.deletedBy         | null                                                                                       |
      | metadata.sourceRecord.audit.deletedTimestamp  | null                                                                                       |
      | metadata.mappingRecord.name                   | SNS-C-NOTIFY-ADD                                                                           |
      | metadata.mappingRecord.version                | mappingVersion                                                                             |
      | startTimestamp                                | null                                                                                       |
      | endTimestamp                                  | null                                                                                       |
      | metadata.complianceRecord.visibility          | UNKNOWN                                                                                    |
      | metadata.complianceRecord.gscMarker           | null                                                                                       |
      | metadata.complianceRecord.retentionMarkerDays | -1                                                                                         |
      | snapshotTrigger                               | null                                                                                       |
      | type                                          | ADDRESS                                                                                    |
      | party.poleId.v2.id                            | SNSENS:P={notifyPartyName166LiverpoolLI90 POL100}[SNS-C-NOTIFY]                            |
      | party.type                                    | P                                                                                          |
      | role                                          | PTOLASSO                                                                                   |
      | address.type                                  | LOCADDR                                                                                    |
      | address.postCode                              | LI90 POL                                                                                   |
      | address.poBox                                 | null                                                                                       |
      | address.fullAddress                           | notifyPartyName1 66 Liverpool LI90 POL 100                                                 |
      | address.name                                  | notifyPartyName1                                                                           |
      | address.siteLocation                          | null                                                                                       |
      | address.number                                | null                                                                                       |
      | address.street                                | 66                                                                                         |
      | address.town                                  | Liverpool                                                                                  |
      | address.area                                  | null                                                                                       |
      | address.district                              | null                                                                                       |
      | address.county                                | null                                                                                       |
      | address.country                               | 100                                                                                        |
      | address.uniquePropertyReferenceNumber         | null                                                                                       |
      | address.latitude                              | null                                                                                       |
      | address.longitude                             | null                                                                                       |
      | attributes.attrs.header.ingestDateTime        | 2022-02-22T22:22:22.222Z                                                                   |

  Scenario: STOP: SNS-C-NOTIFY-ADD not created if name and eori are null
    When the background template of Sns data is changed to
      | field                                    | value |
      | body.goods.goodsItems.0.notifyParty.name | null  |
      | body.goods.goodsItems.0.notifyParty.eori | null  |
    And StreamIngestRecord source data is presented with attributes as per the template to the fdp-sns-input_0 input topic
    Then 1 Location Commands for SNS-C-NOTIFY-ADD will be emitted

