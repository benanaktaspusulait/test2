@serviceConsignment
Feature: SNS Command Adaptor - Service - SNS-ITEM

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
      | body.parties.declarant.address.countryCode                            | 100                                                              |
      | body.parties.declarant.language                                       | parties.declarant.language                                       |
      | body.parties.declarant.eori                                           |                                                                  |
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
      | body.parties.consignor.eori                                           |                                                                  |
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
      | body.goods.seals.0.identity                                           | goods.seals.0.identity                                           |
      | body.goods.seals.0.identityLanguage                                   | goods.seals.0.identityLanguage                                   |
      | body.goods.seals.1.identity                                           | goods.seals.1.identity                                           |
      | body.goods.seals.1.identityLanguage                                   | goods.seals.1.identityLanguage                                   |
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
      | body.goods.goodsItems.0.documents.0.type                              | 12345                                                            |
      | body.goods.goodsItems.0.documents.0.reference                         | N704                                                             |
      | body.goods.goodsItems.0.documents.0.language                          | English                                                          |
      | body.goods.goodsItems.0.specialMentions.0                             | goods.goodsItems.0.specialMentions                               |
      | body.goods.goodsItems.0.specialMentions.1                             | goods.goodsItems.0.specialMentions1                              |
      | body.goods.goodsItems.0.consignor.name                                | goodsConsignorName                                               |
      | body.goods.goodsItems.0.consignor.address.streetAndNumber             | 11                                                               |
      | body.goods.goodsItems.0.consignor.address.city                        | Birmingham                                                       |
      | body.goods.goodsItems.0.consignor.address.postalCode                  | BH1 2AM                                                          |
      | body.goods.goodsItems.0.consignor.address.countryCode                 | 100                                                              |
      | body.goods.goodsItems.0.consignor.language                            | goods.goodsItems.0.consignor.language                            |
      | body.goods.goodsItems.0.consignor.eori                                |                                                                  |
      | body.goods.goodsItems.0.commodityCode                                 | goods.goodsItems.0.commodityCode                                 |
      | body.goods.goodsItems.0.consignee.name                                | goodsConsigneeName                                               |
      | body.goods.goodsItems.0.consignee.address.streetAndNumber             | 15                                                               |
      | body.goods.goodsItems.0.consignee.address.city                        | London                                                           |
      | body.goods.goodsItems.0.consignee.address.postalCode                  | LD12 3ON                                                         |
      | body.goods.goodsItems.0.consignee.address.countryCode                 | 100                                                              |
      | body.goods.goodsItems.0.consignee.language                            | goods.goodsItems.0.consignee.language                            |
      | body.goods.goodsItems.0.consignee.eori                                | GB12345                                                          |
      | body.goods.goodsItems.0.containers.0.containerNumber                  | containerNumber1                                                 |
      | body.goods.goodsItems.0.containers.1.containerNumber                  | containerNumber2                                                 |
      | body.goods.goodsItems.0.identityOfMeansOfCrossingBorder.0.nationality | goods.goodsItems.0.identityOfMeansOfCrossingBorder.0.nationality |
      | body.goods.goodsItems.0.identityOfMeansOfCrossingBorder.0.identity    | cvehicle1;ctrailer1                                              |
      | body.goods.goodsItems.0.identityOfMeansOfCrossingBorder.0.language    | goods.goodsItems.0.identityOfMeansOfCrossingBorder.0.language    |
      | body.goods.goodsItems.0.identityOfMeansOfCrossingBorder.1.nationality | Irish{testId}                                                    |
      | body.goods.goodsItems.0.identityOfMeansOfCrossingBorder.1.identity    | IMO1234567                                                       |
      | body.goods.goodsItems.0.identityOfMeansOfCrossingBorder.1.language    | goods.goodsItems.0.identityOfMeansOfCrossingBorder.1.language    |
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
      | body.goods.goodsItems.0.notifyParty.address.countryCode               | 100                                                              |
      | body.goods.goodsItems.0.notifyParty.language                          | goods.goodsItems.0.notifyParty.language                          |
      | body.goods.goodsItems.0.notifyParty.eori                              | GB99999                                                          |
      | body.goods.goodsItems.0.transportChargesMethodOfPayment               | Z                                                                |
      | body.itinerary.modeOfTransportAtBorder                                | 2                                                                |
      | body.itinerary.identityOfMeansOfCrossingBorder.nationality            | Nationality                                                      |
      | body.itinerary.identityOfMeansOfCrossingBorder.identity               | vehicle1#trailer1                                                |
      | body.itinerary.identityOfMeansOfCrossingBorder.language               | itinerary.identityOfMeansOfCrossingBorder.language               |
      | body.itinerary.transportChargesMethodOfPayment                        | D                                                                |
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

  Scenario Outline: ServiceRecord - SNS-ITEM - check eori name lookup
    When the background template of Sns data is changed to
      | field                                  | value           |
      | body.parties.declarant.name            | <declarantName> |
      | body.parties.declarant.eori            | <declarantEori> |
      | body.parties.consignor.name            | <partiesName>   |
      | body.parties.consignor.eori            | <partiesEori>   |
      | body.goods.goodsItems.0.consignor.name | <itemsName0>    |
      | body.goods.goodsItems.0.consignor.eori | <itemsEori0>    |
    And StreamIngestRecord source data is presented with attributes as per the template to the fdp-sns-input_0 input topic
    Then 1 Service Commands for SNS-ITEM will be emitted
    And one Service record for "SNS-ITEM" with following attributes
      | metadata.identityRecord.poleId.v2.id                        | SNSENS:S={movementReferenceNumberIN1234}                                                                                             |
      | metadata.identityRecord.type                                | S                                                                                                                                    |
      | metadata.sourceRecord.name                                  | SNSENS                                                                                                                               |
      | metadata.sourceRecord.shortName                             | SNS                                                                                                                                  |
      | metadata.sourceRecord.location                              | submissionIdmetadata.messageIdentification                                                                                           |
      | metadata.sourceRecord.id                                    | {movementReferenceNumberIN1234}                                                                                                      |
      | metadata.sourceRecord.audit.createdBy                       | 0123456789                                                                                                                           |
      | metadata.sourceRecord.audit.createdTimestamp                | 2022-02-22T22:22:22.222Z                                                                                                             |
      | metadata.sourceRecord.audit.updatedBy                       | null                                                                                                                                 |
      | metadata.sourceRecord.audit.updatedTimestamp                | null                                                                                                                                 |
      | metadata.sourceRecord.audit.deletedBy                       | null                                                                                                                                 |
      | metadata.sourceRecord.audit.deletedTimestamp                | null                                                                                                                                 |
      | metadata.mappingRecord.name                                 | SNS-ITEM                                                                                                                             |
      | metadata.mappingRecord.version                              | mappingVersion                                                                                                                       |
      | metadata.complianceRecord.visibility                        | UNKNOWN                                                                                                                              |
      | metadata.complianceRecord.gscMarker                         | null                                                                                                                                 |
      | metadata.complianceRecord.retentionMarkerDays               | -1                                                                                                                                   |
      | snapshotTrigger                                             | null                                                                                                                                 |
      | type                                                        | CONSIGNMENT                                                                                                                          |
      | effectiveFromTimestamp                                      | null                                                                                                                                 |
      | effectiveToTimestamp                                        | null                                                                                                                                 |
      | dueTimestamp                                                | null                                                                                                                                 |
      | status                                                      | null                                                                                                                                 |
      | consignment.bagIDNumber                                     | null                                                                                                                                 |
      | consignment.commodityCode                                   | goods.goodsItems.0.commodityCode                                                                                                     |
      | consignment.declaredValue                                   | null                                                                                                                                 |
      | consignment.declaredValueCurrency                           | null                                                                                                                                 |
      | consignment.dimensionHeight                                 | null                                                                                                                                 |
      | consignment.dimensionLength                                 | null                                                                                                                                 |
      | consignment.dimensionUnit                                   | null                                                                                                                                 |
      | consignment.dimensionWidth                                  | null                                                                                                                                 |
      | consignment.exportDepotCode                                 | null                                                                                                                                 |
      | consignment.freightCharges                                  | null                                                                                                                                 |
      | consignment.freightCurrencyCode                             | null                                                                                                                                 |
      | consignment.handlingInstructions                            | null                                                                                                                                 |
      | consignment.mrnReference                                    | movementReferenceNumber                                                                                                              |
      | consignment.packingType                                     | null                                                                                                                                 |
      | consignment.parentShipmentReference                         | null                                                                                                                                 |
      | consignment.paymentType                                     | Z                                                                                                                                    |
      | consignment.shed                                            | null                                                                                                                                 |
      | consignment.shipment.arrivalCountry                         | null                                                                                                                                 |
      | consignment.shipment.arrivalLocation                        | goods.goodsItems.0.loading.placeOfUnloading                                                                                          |
      | consignment.shipment.departureCountry                       | null                                                                                                                                 |
      | consignment.shipment.departureLocation                      | goods.goodsItems.0.loading.placeOfLoading                                                                                            |
      | consignment.shipment.goodsDescription                       | [goods.goodsItems.0.description]                                                                                                     |
      | consignment.shipment.numberOfPieces                         | null                                                                                                                                 |
      | consignment.shipment.shipmentReference                      | null                                                                                                                                 |
      | consignment.shipment.weight                                 | 10.5                                                                                                                                 |
      | consignment.shipment.weightUnit                             | null                                                                                                                                 |
      | consignment.shipperNumber                                   | null                                                                                                                                 |
      | consignment.type                                            | ITEM                                                                                                                                 |
      | consignment.unitLoadingDevice                               | null                                                                                                                                 |
      | consignment.valueIndicator                                  | null                                                                                                                                 |
      | attributes.attrs.goods.goodsItems.unDangerousGoodsCode      | goods.goodsItems.0.unDangerousGoodsCode                                                                                              |
      | attributes.attrs.goods.goodsItems.commercialReferenceNumber | goods.goodsItems.0.commercialReferenceNumber                                                                                         |
      | attributes.attrs.itinerary.commercialReferenceNumber        | itinerary.commercialReferenceNumber                                                                                                  |
      | attributes.attrs.header.ingestDateTime                      | 2022-02-22T22:22:22.222Z                                                                                                             |
      | attributes.attrs.itinerary.loading.placeOfLoading           | itinerary.loading.placeOfLoading                                                                                                     |
      | attributes.attrs.itinerary.loading.placeOfUnloading         | itinerary.loading.placeOfUnloading                                                                                                   |
      | attributes.attrs.itineraryLoadingLanguage                   | itinerary.loading.loadingLanguage                                                                                                    |
      | attributes.attrs.itineraryUnloadingLanguage                 | itinerary.loading.unloadingLanguage                                                                                                  |
      | attributes.attrs.itinerary.transportChargesMethodOfPayment  | D                                                                                                                                    |
      | attributes.attrs.descriptionLanguage                        | goods.goodsItems.0.descriptionLanguage                                                                                               |
      | attributes.attrs.packages                                   | goods.goodsItems.0.packages.0.kindOfPackages\|1\|1\|goods.goodsItems.0.packages.0.marks\|goods.goodsItems.0.packages.0.marksLanguage |
      | attributes.attrs.specialMentions                            | goods.goodsItems.0.specialMentions;goods.goodsItems.0.specialMentions1                                                               |
      | attributes.attrs.goodsitemsLoadingLanguage                  | goods.goodsItems.0.loading.loadingLanguage                                                                                           |
      | attributes.attrs.goodsitemsUnloadingLanguage                | goods.goodsItems.0.loading.unloadingLanguage                                                                                         |
      | attributes.attrs.expectedDateTimeOfArrival                  | 2022-02-28T22:22:22.222Z                                                                                                             |
      | attributes.attrs.declarantName                              | <declarant>                                                                                                                          |
      | attributes.attrs.mShipperName                               | <partiesConsignor>                                                                                                                   |
      | attributes.attrs.cShipperName                               | <goodsConsignor0>                                                                                                                    |
      | attributes.attrs.documents                                  | \\{"type": "12345", "reference": "N704", "language": "English"\\}                                                                    |
      | attributes.attrs.mvrn                                       | vehicle1                                                                                                                             |
      | attributes.attrs.mtrn                                       | trailer1                                                                                                                             |
      | attributes.attrs.cvrn                                       | cvehicle1                                                                                                                            |
      | attributes.attrs.ctrn                                       | ctrailer1                                                                                                                            |
      | attributes.attrs.crn                                        | containerNumber1\|containerNumber2                                                                                                   |
    Examples:
      | declarantName | declarantEori | declarant     | partiesName          | partiesEori          | partiesConsignor     | itemsName0          | itemsEori0          | goodsConsignor0     |
      | declarantName | null          | declarantName | partiesConsignorName | null                 | partiesConsignorName | goodsConsignorName0 | null                | goodsConsignorName0 |
      | null          | declarantEori | declarantEori | null                 | partiesConsignorEori | partiesConsignorEori | null                | goodsConsignorEori0 | goodsConsignorEori0 |
      | declarantName | declarantEori | declarantEori | partiesConsignorName | partiesConsignorEori | partiesConsignorEori | goodsConsignorName0 | goodsConsignorEori0 | goodsConsignorEori0 |
