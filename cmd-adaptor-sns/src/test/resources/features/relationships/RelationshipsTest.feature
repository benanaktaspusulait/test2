@relationships
Feature: Test SNS Command Adaptor - Relationships

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
      | body.parties.declarant.name                                           | declarantName                                                    |
      | body.parties.declarant.address.streetAndNumber                        | 100                                                              |
      | body.parties.declarant.address.city                                   | Bath                                                             |
      | body.parties.declarant.address.postalCode                             | BA44 4TH                                                         |
      | body.parties.declarant.address.countryCode                            | 444                                                              |
      | body.parties.declarant.language                                       | parties.declarant.language                                       |
      | body.parties.declarant.eori                                           | null                                                             |
      | body.parties.representative.name                                      | representativeName                                               |
      | body.parties.representative.address.streetAndNumber                   | 33                                                               |
      | body.parties.representative.address.city                              | London                                                           |
      | body.parties.representative.address.postalCode                        | LN12 7ON                                                         |
      | body.parties.representative.address.countryCode                       | 45                                                               |
      | body.parties.representative.language                                  | parties.representative.language                                  |
      | body.parties.representative.eori                                      | null                                                             |
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
      | body.parties.consignor.address.countryCode                            | 50                                                               |
      | body.parties.consignor.language                                       | parties.consignor.language                                       |
      | body.parties.consignor.eori                                           | null                                                             |
      | body.parties.consignee.name                                           | partiesConsigneeName                                             |
      | body.parties.consignee.address.streetAndNumber                        | 23                                                               |
      | body.parties.consignee.address.city                                   | Paris                                                            |
      | body.parties.consignee.address.postalCode                             | PA12 IS                                                          |
      | body.parties.consignee.address.countryCode                            | PA55                                                             |
      | body.parties.consignee.language                                       | parties.consignee.language                                       |
      | body.parties.consignee.eori                                           | null                                                             |
      | body.parties.notifyParty.name                                         | partiesNotifyName                                                |
      | body.parties.notifyParty.address.streetAndNumber                      | 56                                                               |
      | body.parties.notifyParty.address.city                                 | Bristol                                                          |
      | body.parties.notifyParty.address.postalCode                           | BR00 6OL                                                         |
      | body.parties.notifyParty.address.countryCode                          | 111                                                              |
      | body.parties.notifyParty.language                                     | parties.notifyParty.language                                     |
      | body.parties.notifyParty.eori                                         | null                                                             |
      | body.goods.seals.0.identity                                           | goods.seals.0.identity                                           |
      | body.goods.seals.0.identityLanguage                                   | goods.seals.0.identityLanguage                                   |
      | body.goods.numberOfItems                                              | 10                                                               |
      | body.goods.numberOfPackages                                           | 1                                                                |
      | body.goods.grossMass                                                  | 11.1                                                             |
      | body.goods.goodsItems.0.itemNumber                                    | IN1234                                                           |
      | body.goods.goodsItems.0.description                                   | goods.goodsItems.0.description                                   |
      | body.goods.goodsItems.0.descriptionLanguage                           | goods.goodsItems.0.descriptionLanguage                           |
      | body.goods.goodsItems.0.grossMass                                     | 10.5                                                             |
      | body.goods.goodsItems.0.commercialReferenceNumber                     | goods.goodsItems.0.commercialReferenceNumber                     |
      | body.goods.goodsItems.0.unDangerousGoodsCode                          | goods.goodsItems.0.unDangerousGoodsCode                          |
      | body.goods.goodsItems.0.loading.placeOfLoading                        | goods.goodsItems.0.loading.placeOfLoading                        |
      | body.goods.goodsItems.0.loading.loadingLanguage                       | goods.goodsItems.0.loading.loadingLanguage                       |
      | body.goods.goodsItems.0.loading.placeOfUnloading                      | goods.goodsItems.0.loading.placeOfUnloading                      |
      | body.goods.goodsItems.0.loading.unloadingLanguage                     | goods.goodsItems.0.loading.unloadingLanguage                     |
      | body.goods.goodsItems.0.documents.0.type                              | goods.goodsItems.0.documents.0.type                              |
      | body.goods.goodsItems.0.documents.0.reference                         | goods.goodsItems.0.documents.0.reference                         |
      | body.goods.goodsItems.0.documents.0.language                          | goods.goodsItems.0.documents.0.language                          |
      | body.goods.goodsItems.0.specialMentions.0                             | goods.goodsItems.0.specialMentions                               |
      | body.goods.goodsItems.0.specialMentions.1                             | goods.goodsItems.0.specialMentions1                              |
      | body.goods.goodsItems.0.consignor.name                                | goodsConsignorName                                               |
      | body.goods.goodsItems.0.consignor.address.streetAndNumber             | 11                                                               |
      | body.goods.goodsItems.0.consignor.address.city                        | Birmingham                                                       |
      | body.goods.goodsItems.0.consignor.address.postalCode                  | BH1 2AM                                                          |
      | body.goods.goodsItems.0.consignor.address.countryCode                 | LON11                                                            |
      | body.goods.goodsItems.0.consignor.language                            | goods.goodsItems.0.consignor.language                            |
      | body.goods.goodsItems.0.consignor.eori                                | null                                                             |
      | body.goods.goodsItems.0.commodityCode                                 | goods.goodsItems.0.commodityCode                                 |
      | body.goods.goodsItems.0.consignee.name                                | goodsConsigneeName                                               |
      | body.goods.goodsItems.0.consignee.address.streetAndNumber             | 15                                                               |
      | body.goods.goodsItems.0.consignee.address.city                        | London                                                           |
      | body.goods.goodsItems.0.consignee.address.postalCode                  | LD12 3ON                                                         |
      | body.goods.goodsItems.0.consignee.address.countryCode                 | LON11                                                            |
      | body.goods.goodsItems.0.consignee.language                            | goods.goodsItems.0.consignee.language                            |
      | body.goods.goodsItems.0.consignee.eori                                | null                                                             |
      | body.goods.goodsItems.0.containers.0.containerNumber                  | goods.goodsItems.0.containers.0.containerNumber                  |
      | body.goods.goodsItems.0.identityOfMeansOfCrossingBorder.0.nationality | goods.goodsItems.0.identityOfMeansOfCrossingBorder.0.nationality |
      | body.goods.goodsItems.0.identityOfMeansOfCrossingBorder.0.identity    | goods.goodsItems.0.identityOfMeansOfCrossingBorder.0.identity    |
      | body.goods.goodsItems.0.identityOfMeansOfCrossingBorder.0.language    | goods.goodsItems.0.identityOfMeansOfCrossingBorder.0.language    |
      | body.goods.goodsItems.0.packages.0.kindOfPackages                     | goods.goodsItems.0.packages.0.kindOfPackages                     |
      | body.goods.goodsItems.0.packages.0.numberOfPackages                   | 1                                                                |
      | body.goods.goodsItems.0.packages.0.numberOfPieces                     | 1                                                                |
      | body.goods.goodsItems.0.packages.0.marks                              | goods.goodsItems.0.packages.0.marks                              |
      | body.goods.goodsItems.0.packages.0.marksLanguage                      | goods.goodsItems.0.packages.0.marksLanguage                      |
      | body.goods.goodsItems.0.notifyParty.name                              | notifyPartyName                                                  |
      | body.goods.goodsItems.0.notifyParty.address                           | 100                                                              |
      | body.goods.goodsItems.0.notifyParty.address.streetAndNumber           | 100                                                              |
      | body.goods.goodsItems.0.notifyParty.address.city                      | Reading                                                          |
      | body.goods.goodsItems.0.notifyParty.address.postalCode                | RG1 0NG                                                          |
      | body.goods.goodsItems.0.notifyParty.address.countryCode               | LON11                                                            |
      | body.goods.goodsItems.0.notifyParty.language                          | goods.goodsItems.0.notifyParty.language                          |
      | body.goods.goodsItems.0.notifyParty.eori                              | null                                                             |
      | body.goods.goodsItems.0.transportChargesMethodOfPayment               | Z                                                                |
      | body.itinerary.modeOfTransportAtBorder                                | 10                                                               |
      | body.itinerary.identityOfMeansOfCrossingBorder.nationality            | Nationality                                                      |
      | body.itinerary.identityOfMeansOfCrossingBorder.identity               | vehicle001#trailer001                                            |
      | body.itinerary.identityOfMeansOfCrossingBorder.language               | itinerary.identityOfMeansOfCrossingBorder.language               |
      | body.itinerary.transportChargesMethodOfPayment                        | Z                                                                |
      | body.itinerary.commercialReferenceNumber                              | itinerary.commercialReferenceNumber                              |
      | body.itinerary.conveyanceReference                                    | itinerary.conveyanceReference                                    |
      | body.itinerary.loading.placeOfLoading                                 | itinerary.loading.placeOfLoading                                 |
      | body.itinerary.loading.loadingLanguage                                | itinerary.loading.loadingLanguage                                |
      | body.itinerary.loading.placeOfUnloading                               | itinerary.loading.placeOfUnloading                               |
      | body.itinerary.loading.unloadingLanguage                              | itinerary.loading.unloadingLanguage                              |
      | body.itinerary.countriesOfRouting.0                                   | itinerary.countriesOfRouting                                     |
      | body.itinerary.officeOfFirstEntry.reference                           | itinerary.officeOfFirstEntry.reference                           |
      | body.itinerary.officeOfFirstEntry.expectedDateTimeOfArrival           | 2022-02-29T22:22:22.222                                          |
      | body.itinerary.officesOfSubsequentEntry.0                             | itinerary.officesOfSubsequentEntry                               |
      | body.specificCircumstancesIndicator                                   | A                                                                |

  Scenario Outline: Verify Goods Consignee Relationships
    When StreamIngestRecord source data is presented with attributes as per the template to the fdp-sns-input_0 input topic
    Then 10 Party Commands will be emitted
    And one Party record for "SNS-C-CONSIGNEE" with following poleV2Id
      | metadata.identityRecord.poleId.v2.id | SNSENS:P=<goodsConsigneePartyId>[SNS-C-CONSIGNEE] |
    Then 10 Location Commands will be emitted
    And one Location record for "SNS-C-CONS-ADD" with following poleV2Id
      | metadata.identityRecord.poleId.v2.id | SNSENS:P=<goodsConsigneePartyId>[SNS-C-CONSIGNEE],L={15LondonLD12 3ONLON11} |
      | party.poleId.v2.id                   | SNSENS:P=<goodsConsigneePartyId>[SNS-C-CONSIGNEE]                           |
    Then 19 Event Commands will be emitted
    And one Event record for "SNS-ASSOC-CCon2Cons" with following poleV2Id
      | metadata.identityRecord.poleId.v2.id | SNSENS:E={[SNSENS:P=<goodsConsigneePartyId>[SNS-C-CONSIGNEE]][SNSENS:S=<serviceId>][PTOSCSIGNE]} |
      | subject.poleId.v2.id                 | SNSENS:P=<goodsConsigneePartyId>[SNS-C-CONSIGNEE]                                                |
      | associationStart.target.poleId.v2.id | SNSENS:S=<serviceId>                                                                             |
    Then 3 Service Commands will be emitted
    And one Service record for "SNS-ITEM" with following poleV2Id
      | metadata.identityRecord.poleId.v2.id | SNSENS:S=<serviceId> |
    Examples:
      | goodsConsigneePartyId                     | serviceId                                                             |
      | {goodsConsigneeName15LondonLD12 3ONLON11} | {movementReferenceNumbergoods.goodsItems.0.commercialReferenceNumber} |

  Scenario Outline: Verify Goods Notify Relationships
    When StreamIngestRecord source data is presented with attributes as per the template to the fdp-sns-input_0 input topic
    Then 10 Party Commands will be emitted
    And one Party record for "SNS-C-NOTIFY" with following poleV2Id
      | metadata.identityRecord.poleId.v2.id | SNSENS:P=<goodsNotifyPartyId>[SNS-C-NOTIFY] |
    Then 10 Location Commands will be emitted
    And one Location record for "SNS-C-NOTIFY-ADD" with following poleV2Id
      | metadata.identityRecord.poleId.v2.id | SNSENS:P=<goodsNotifyPartyId>[SNS-C-NOTIFY],L={100ReadingRG1 0NGLON11} |
      | party.poleId.v2.id                   | SNSENS:P=<goodsNotifyPartyId>[SNS-C-NOTIFY]                            |
    Then 19 Event Commands will be emitted
    And one Event record for "SNS-ASSOC-CNot2Ite" with following poleV2Id
      | metadata.identityRecord.poleId.v2.id | SNSENS:E={[SNSENS:P=<goodsNotifyPartyId>[SNS-C-NOTIFY]][SNSENS:S=<serviceId>][PTOS]} |
      | subject.poleId.v2.id                 | SNSENS:P=<goodsNotifyPartyId>[SNS-C-NOTIFY]                                          |
      | associationStart.target.poleId.v2.id | SNSENS:S=<serviceId>                                                                 |
    Then 3 Service Commands will be emitted
    And one Service record for "SNS-ITEM" with following poleV2Id
      | metadata.identityRecord.poleId.v2.id | SNSENS:S=<serviceId> |
    Examples:
      | goodsNotifyPartyId                      | serviceId                                                             |
      | {notifyPartyName100ReadingRG1 0NGLON11} | {movementReferenceNumbergoods.goodsItems.0.commercialReferenceNumber} |

  Scenario Outline: Verify Goods Shipper Relationships
    When StreamIngestRecord source data is presented with attributes as per the template to the fdp-sns-input_0 input topic
    Then 10 Party Commands will be emitted
    And one Party record for "SNS-C-SHIPPER" with following poleV2Id
      | metadata.identityRecord.poleId.v2.id | SNSENS:P=<goodsShipperPartyId>[SNS-C-SHIPPER] |
    Then 10 Location Commands will be emitted
    And one Location record for "SNS-C-SHIP-ADD" with following poleV2Id
      | metadata.identityRecord.poleId.v2.id | SNSENS:P=<goodsShipperPartyId>[SNS-C-SHIPPER],L={11BirminghamBH1 2AMLON11} |
      | party.poleId.v2.id                   | SNSENS:P=<goodsShipperPartyId>[SNS-C-SHIPPER]                              |
    Then 19 Event Commands will be emitted
    And one Event record for "SNS-ASSOC-CShi2Ite" with following poleV2Id
      | metadata.identityRecord.poleId.v2.id | SNSENS:E={[SNSENS:P=<goodsShipperPartyId>[SNS-C-SHIPPER]][SNSENS:S=<serviceId>][PTOSSHIP]} |
      | subject.poleId.v2.id                 | SNSENS:P=<goodsShipperPartyId>[SNS-C-SHIPPER]                                              |
      | associationStart.target.poleId.v2.id | SNSENS:S=<serviceId>                                                                       |
    Then 3 Service Commands will be emitted
    And one Service record for "SNS-ITEM" with following poleV2Id
      | metadata.identityRecord.poleId.v2.id | SNSENS:S=<serviceId> |
    Examples:
      | goodsShipperPartyId                          | serviceId                                                             |
      | {goodsConsignorName11BirminghamBH1 2AMLON11} | {movementReferenceNumbergoods.goodsItems.0.commercialReferenceNumber} |

  Scenario Outline: Verify Parties Consignee Relationships
    When StreamIngestRecord source data is presented with attributes as per the template to the fdp-sns-input_0 input topic
    Then 10 Party Commands will be emitted
    And one Party record for "SNS-M-CONSIGNEE" with following poleV2Id
      | metadata.identityRecord.poleId.v2.id | SNSENS:P=<partiesConsigneePartyId>[SNS-M-CONSIGNEE] |
    Then 10 Location Commands will be emitted
    And one Location record for "SNS-M-CONS-ADD" with following poleV2Id
      | metadata.identityRecord.poleId.v2.id | SNSENS:P=<partiesConsigneePartyId>[SNS-M-CONSIGNEE],L={23ParisPA12 ISPA55} |
      | party.poleId.v2.id                   | SNSENS:P=<partiesConsigneePartyId>[SNS-M-CONSIGNEE]                        |
    Then 19 Event Commands will be emitted
    And one Event record for "SNS-ASSOC-MCon2Mov" with following poleV2Id
      | metadata.identityRecord.poleId.v2.id | SNSENS:E={[SNSENS:P=<partiesConsigneePartyId>[SNS-M-CONSIGNEE]][SNSENS:S=<serviceId>][PTOSCSIGNE]} |
      | subject.poleId.v2.id                 | SNSENS:P=<partiesConsigneePartyId>[SNS-M-CONSIGNEE]                                                |
      | associationStart.target.poleId.v2.id | SNSENS:S=<serviceId>                                                                               |
    Then 3 Service Commands will be emitted
    And one Service record for "SNS-ITEM" with following poleV2Id
      | metadata.identityRecord.poleId.v2.id | SNSENS:S=<serviceId> |
    Examples:
      | partiesConsigneePartyId                  | serviceId                                                             |
      | {partiesConsigneeName23ParisPA12 ISPA55} | {movementReferenceNumbergoods.goodsItems.0.commercialReferenceNumber} |

  Scenario Outline: Verify Parties Notify Relationships
    When StreamIngestRecord source data is presented with attributes as per the template to the fdp-sns-input_0 input topic
    Then 10 Party Commands will be emitted
    And one Party record for "SNS-M-NOTIFY" with following poleV2Id
      | metadata.identityRecord.poleId.v2.id | SNSENS:P=<partiesNotifyPartyId>[SNS-M-NOTIFY] |
    Then 10 Location Commands will be emitted
    And one Location record for "SNS-M-NOTIFY-ADD" with following poleV2Id
      | metadata.identityRecord.poleId.v2.id | SNSENS:P=<partiesNotifyPartyId>[SNS-M-NOTIFY],L={56BristolBR00 6OL111} |
      | party.poleId.v2.id                   | SNSENS:P=<partiesNotifyPartyId>[SNS-M-NOTIFY]                          |
    Then 19 Event Commands will be emitted
    And one Event record for "SNS-ASSOC-MNot2Mov" with following poleV2Id
      | metadata.identityRecord.poleId.v2.id | SNSENS:E={[SNSENS:P=<partiesNotifyPartyId>[SNS-M-NOTIFY]][SNSENS:S=<serviceId>][PTOS]} |
      | subject.poleId.v2.id                 | SNSENS:P=<partiesNotifyPartyId>[SNS-M-NOTIFY]                                          |
      | associationStart.target.poleId.v2.id | SNSENS:S=<serviceId>                                                                   |
    Then 3 Service Commands will be emitted
    And one Service record for "SNS-ITEM" with following poleV2Id
      | metadata.identityRecord.poleId.v2.id | SNSENS:S=<serviceId> |
    Examples:
      | partiesNotifyPartyId                    | serviceId                                                             |
      | {partiesNotifyName56BristolBR00 6OL111} | {movementReferenceNumbergoods.goodsItems.0.commercialReferenceNumber} |


  Scenario Outline: Verify Parties Shipper Relationships
    When StreamIngestRecord source data is presented with attributes as per the template to the fdp-sns-input_0 input topic
    Then 10 Party Commands will be emitted
    And one Party record for "SNS-M-SHIPPER" with following poleV2Id
      | metadata.identityRecord.poleId.v2.id | SNSENS:P=<partiesShipperPartyId>[SNS-M-SHIPPER] |
    Then 10 Location Commands will be emitted
    And one Location record for "SNS-M-SHIP-ADD" with following poleV2Id
      | metadata.identityRecord.poleId.v2.id | SNSENS:P=<partiesShipperPartyId>[SNS-M-SHIPPER],L={90CardiffCA34 7FF50} |
      | party.poleId.v2.id                   | SNSENS:P=<partiesShipperPartyId>[SNS-M-SHIPPER]                         |
    Then 19 Event Commands will be emitted
    And one Event record for "SNS-ASSOC-MShi2Mov" with following poleV2Id
      | metadata.identityRecord.poleId.v2.id | SNSENS:E={[SNSENS:P=<partiesShipperPartyId>[SNS-M-SHIPPER]][SNSENS:S=<serviceId>][PTOSSHIP]} |
      | subject.poleId.v2.id                 | SNSENS:P=<partiesShipperPartyId>[SNS-M-SHIPPER]                                              |
      | associationStart.target.poleId.v2.id | SNSENS:S=<serviceId>                                                                         |
    Then 3 Service Commands will be emitted
    And one Service record for "SNS-ITEM" with following poleV2Id
      | metadata.identityRecord.poleId.v2.id | SNSENS:S=<serviceId> |
    Examples:
      | partiesShipperPartyId                     | serviceId                                                             |
      | {partiesConsignorName90CardiffCA34 7FF50} | {movementReferenceNumbergoods.goodsItems.0.commercialReferenceNumber} |


  Scenario Outline: Verify Representative Relationships
    When StreamIngestRecord source data is presented with attributes as per the template to the fdp-sns-input_0 input topic
    Then 10 Party Commands will be emitted
    And one Party record for "SNS-REPRESENTATIVE" with following poleV2Id
      | metadata.identityRecord.poleId.v2.id | SNSENS:P=<representativePartyId>[SNS-REPRESENTATIVE] |
    Then 10 Location Commands will be emitted
    And one Location record for "SNS-REP-ADD" with following poleV2Id
      | metadata.identityRecord.poleId.v2.id | SNSENS:P=<representativePartyId>[SNS-REPRESENTATIVE],L={33LondonLN12 7ON45} |
      | party.poleId.v2.id                   | SNSENS:P=<representativePartyId>[SNS-REPRESENTATIVE]                        |
    Then 19 Event Commands will be emitted
    And one Event record for "SNS-ASSOC-Rep2Mov" with following poleV2Id
      | metadata.identityRecord.poleId.v2.id | SNSENS:E={[SNSENS:P=<representativePartyId>[SNS-REPRESENTATIVE]][SNSENS:S=<serviceId>][PTOS]} |
      | subject.poleId.v2.id                 | SNSENS:P=<representativePartyId>[SNS-REPRESENTATIVE]                                          |
      | associationStart.target.poleId.v2.id | SNSENS:S=<serviceId>                                                                          |
    Then 3 Service Commands will be emitted
    And one Service record for "SNS-MOVEMENT" with following poleV2Id
      | metadata.identityRecord.poleId.v2.id | SNSENS:S=<serviceId> |
    Examples:
      | representativePartyId                  | serviceId                                                             |
      | {representativeName33LondonLN12 7ON45} | {movementReferenceNumbergoods.goodsItems.0.commercialReferenceNumber} |

  Scenario Outline: Verify Declarant Relationships
    When StreamIngestRecord source data is presented with attributes as per the template to the fdp-sns-input_0 input topic
    Then 10 Party Commands will be emitted
    And one Party record for "SNS-DECLARANT" with following poleV2Id
      | metadata.identityRecord.poleId.v2.id | SNSENS:P=<declarantPartyId>[SNS-DECLARANT] |
    Then 10 Location Commands will be emitted
    And one Location record for "SNS-DECLARANT-ADD" with following poleV2Id
      | metadata.identityRecord.poleId.v2.id | SNSENS:P=<declarantPartyId>[SNS-DECLARANT],L={100BathBA44 4TH444} |
      | party.poleId.v2.id                   | SNSENS:P=<declarantPartyId>[SNS-DECLARANT]                        |
    Then 19 Event Commands will be emitted
    And one Event record for "SNS-ASSOC-Dec2Cons" with following poleV2Id
      | metadata.identityRecord.poleId.v2.id | SNSENS:E={[SNSENS:P=<declarantPartyId>[SNS-DECLARANT]][SNSENS:S=<serviceId>][PTOS]} |
      | subject.poleId.v2.id                 | SNSENS:P=<declarantPartyId>[SNS-DECLARANT]                                          |
      | associationStart.target.poleId.v2.id | SNSENS:S=<serviceId>                                                                |
    Then 1 Service Commands for SNS-MOVEMENT will be emitted
    And one Service record for "SNS-MOVEMENT" with following poleV2Id
      | metadata.identityRecord.poleId.v2.id | SNSENS:S={movementReferenceNumber} |
    Examples:
      | declarantPartyId                  | serviceId                                                             |
      | {declarantName100BathBA44 4TH444} | {movementReferenceNumbergoods.goodsItems.0.commercialReferenceNumber} |

  Scenario Outline: Verify Object- Vehicle and Trailer Relationships
    When StreamIngestRecord source data is presented with attributes as per the template to the fdp-sns-input_0 input topic
    Then 4 Object Commands will be emitted
    And one Object record for "SNS-C-VEHICLE" with following poleV2Id
      | metadata.identityRecord.poleId.v2.id | SNSENS:P=null[<vehicleId>],O=<vehicleId> |
      | party.poleId.v2.id                   | SNSENS:P=null[<vehicleId>]               |
    And one Object record for "SNS-C-TRAILER" with following poleV2Id
      | metadata.identityRecord.poleId.v2.id | SNSENS:P=null[<trailerId>],O=<trailerId> |
      | party.poleId.v2.id                   | SNSENS:P=null[<trailerId>]               |
    Then 19 Event Commands will be emitted
    And one Event record for "SNS-ASSOC-Veh2Cons" with following poleV2Id
      | metadata.identityRecord.poleId.v2.id | SNSENS:E={[SNSENS:P=null[<vehicleId>],O=<vehicleId>][SNSENS:S=<serviceId>][OTOSASSO]} |
      | subject.poleId.v2.id                 | SNSENS:P=null[<vehicleId>],O=<vehicleId>                                              |
      | associationStart.target.poleId.v2.id | SNSENS:S=<serviceId>                                                                  |
    And one Event record for "SNS-ASSOC-Tra2Cons" with following poleV2Id
      | metadata.identityRecord.poleId.v2.id | SNSENS:E={[SNSENS:P=null[<trailerId>],O=<trailerId>][SNSENS:S=<serviceId>][OTOSASSO]} |
      | subject.poleId.v2.id                 | SNSENS:P=null[<trailerId>],O=<trailerId>                                              |
      | associationStart.target.poleId.v2.id | SNSENS:S=<serviceId>                                                                  |
    And one Event record for "SNS-ASSOC-Veh2Tra" with following poleV2Id
      | metadata.identityRecord.poleId.v2.id | SNSENS:E={[SNSENS:P=null[<vehicleId>],O=<vehicleId>][SNSENS:P=null[<trailerId>],O=<trailerId>][OTOOLINK]} |
      | subject.poleId.v2.id                 | SNSENS:P=null[<vehicleId>],O=<vehicleId>                                                                  |
      | associationStart.target.poleId.v2.id | SNSENS:P=null[<trailerId>],O=<trailerId>                                                                  |
    Then 3 Service Commands will be emitted
    And one Service record for "SNS-MOVEMENT" with following poleV2Id
      | metadata.identityRecord.poleId.v2.id | SNSENS:S=<serviceId> |
    Examples:
      | vehicleId               | trailerId                                      | serviceId                                                             |
      | {Nationalityvehicle001} | {trailer001NationalitymovementReferenceNumber} | {movementReferenceNumbergoods.goodsItems.0.commercialReferenceNumber} |

  Scenario Outline: Verify Object-Container Relationships
    When the background template of Sns data is changed to
      | field                                                   | value    |
      | body.itinerary.identityOfMeansOfCrossingBorder.identity | identity |
      | body.itinerary.modeOfTransportAtBorder                  | 1        |
    And StreamIngestRecord source data is presented with attributes as per the template to the fdp-sns-input_0 input topic
    Then 2 Object Commands will be emitted
    And one Object record for "SNS-C-TRAILER(Container)" with following poleV2Id
      | metadata.identityRecord.poleId.v2.id | SNSENS:P=null[<containerId>],O=<containerId> |
      | party.poleId.v2.id                   | SNSENS:P=null[<containerId>]                 |
    Then 14 Event Commands will be emitted
    And one Event record for "SNS-ASSOC-Cont2Ite" with following poleV2Id
      | metadata.identityRecord.poleId.v2.id | SNSENS:E={[SNSENS:P=null[<containerId>],O=<containerId>][SNSENS:S=<serviceId>][OTOSASSO]} |
      | subject.poleId.v2.id                 | SNSENS:P=null[<containerId>],O=<containerId>                                              |
      | associationStart.target.poleId.v2.id | SNSENS:S=<serviceId>                                                                      |
    Then 3 Service Commands will be emitted
    And one Service record for "SNS-MOVEMENT" with following poleV2Id
      | metadata.identityRecord.poleId.v2.id | SNSENS:S=<serviceId> |
    And one Service record for "SNS-ITEM" with following poleV2Id
      | metadata.identityRecord.poleId.v2.id | SNSENS:S=<serviceId> |
    Examples:
      | containerId                                                              | serviceId                       |
      | {movementReferenceNumbergoods.goodsItems.0.containers.0.containerNumber} | {movementReferenceNumberIN1234} |

  Scenario Outline: Verify Event-SNS-ASSOC-Mov2Cons Relationships
    When StreamIngestRecord source data is presented with attributes as per the template to the fdp-sns-input_0 input topic
    Then 19 Event Commands will be emitted
    And one Event record for "SNS-ASSOC-Mov2Cons" with following poleV2Id
      | metadata.identityRecord.poleId.v2.id | SNSENS:E={[SNSENS:S=<movementServiceId>][SNSENS:S=<consignmentId>][STOS]} |
      | subject.poleId.v2.id                 | SNSENS:S=<movementServiceId>                                              |
      | associationStart.target.poleId.v2.id | SNSENS:S=<consignmentId>                                                  |
    Then 3 Service Commands will be emitted
    And one Service record for "SNS-MOVEMENT" with following poleV2Id
      | metadata.identityRecord.poleId.v2.id | SNSENS:S=<movementServiceId> |
    And one Service record for "SNS-CONSIGNMENT" with following poleV2Id
      | metadata.identityRecord.poleId.v2.id | SNSENS:S=<consignmentId> |
    Examples:
      | movementServiceId         | consignmentId                                                         |
      | {movementReferenceNumber} | {movementReferenceNumbergoods.goodsItems.0.commercialReferenceNumber} |

