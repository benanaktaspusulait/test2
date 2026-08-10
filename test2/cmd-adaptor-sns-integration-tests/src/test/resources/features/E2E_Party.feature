@E2EParty
Feature: Test SNS Command Adaptor - Party

  Scenario: PartyRecord
    Given template StreamIngestRecord with the base file "sns-multiple.input"
    And template EoriCdlzLandingRecord with the base file "eori.input"
    When Eori CDLZ data is presented as per the template to the landing topic landing-413
    When Readiness health check is completed
    And StreamIngestRecord source data is presented with attributes as per the template to the input topic with prefix fdp-sns-input
    Then 16 Party SNAPSHOTS will be emitted
    And one Party record for "SNS-C-CONSIGNEE" with following attributes
      | metadata.identityRecord.poleId.v2.id                 | SNSENS:P={partyCConsignee0,Castlehill,EH1 2NG{testId},Edinburgh}[SNS-C-CONSIGNEE] |
      | metadata.identityRecord.type                         | P                                                                                 |
      | metadata.sourceRecord.name                           | SNSENS                                                                            |
      | metadata.sourceRecord.shortName                      | SNS                                                                               |
      | metadata.sourceRecord.location                       | submissionIdmetadata.messageIdentification                                        |
      | metadata.sourceRecord.id                             | {partyCConsignee0,Castlehill,EH1 2NG{testId},Edinburgh}                           |
      | metadata.sourceRecord.audit.createdBy                | 0123456789                                                                        |
      | metadata.sourceRecord.audit.createdTimestamp         | 2022-02-22T22:22:22.222Z                                                          |
      | metadata.mappingRecord.name                          | SNS-C-CONSIGNEE                                                                   |
      | metadata.mappingRecord.version                       | mappingVersion                                                                    |
      | metadata.complianceRecord.visibility                 | UNKNOWN                                                                           |
      | metadata.complianceRecord.gscMarker                  | null                                                                              |
      | metadata.complianceRecord.retentionMarkerDays        | -1                                                                                |
      | snapshotTrigger                                      | null                                                                              |
      | type                                                 | ORGANISATION                                                                      |
      | organisation.type                                    | ORGCSIGNEE                                                                        |
      | organisation.name                                    | goodsConsigneeName{testId}                                                        |
      | organisation.registrationNumber                      | null                                                                              |
      | organisation.vatNumber                               | VAT41                                                                             |
      | organisation.industrySector                          | null                                                                              |
      | organisation.numberOfEmployees                       | null                                                                              |
      | attributes.attrs.header.ingestDateTime               | 2022-02-22T22:22:22.222Z                                                          |
      | attributes.attrs.goods.goodsItems.consignee.language | goods.goodsItems.0.consignee.language                                             |
      | attributes.attrs.eoriExtractionType                  | Download                                                                          |
      | attributes.attrs.goods.goodsItems.consignee.eori     | partyCConsignee0Eori                                                              |
      | attributes.attrs.eoriPrincipalEconomicActivity       | Test Stuff                                                                        |
      | attributes.attrs.eoriVatRegistrationNumber           | VAT41                                                                             |
      | attributes.attrs.eoriSendingDateTime                 | 2022-01-21T21:21:21.221                                                           |
      | attributes.attrs.eoriTraderName                      | partyCConsignee0                                                                  |
      | attributes.attrs.eoriDateOfRegistration              | 2023-01-20                                                                        |
    And one Party record for "SNS-C-CONSIGNEE" with following attributes
      | metadata.identityRecord.poleId.v2.id                 | SNSENS:P={partyCConsignee1,Woodstock,OX20 1PP{testId},Oxfordshire}[SNS-C-CONSIGNEE] |
      | metadata.identityRecord.type                         | P                                                                                   |
      | metadata.sourceRecord.name                           | SNSENS                                                                              |
      | metadata.sourceRecord.shortName                      | SNS                                                                                 |
      | metadata.sourceRecord.location                       | submissionIdmetadata.messageIdentification                                          |
      | metadata.sourceRecord.id                             | {partyCConsignee1,Woodstock,OX20 1PP{testId},Oxfordshire}                           |
      | metadata.sourceRecord.audit.createdBy                | 0123456789                                                                          |
      | metadata.sourceRecord.audit.createdTimestamp         | 2022-02-22T22:22:22.222Z                                                            |
      | metadata.mappingRecord.name                          | SNS-C-CONSIGNEE                                                                     |
      | metadata.mappingRecord.version                       | mappingVersion                                                                      |
      | metadata.complianceRecord.visibility                 | UNKNOWN                                                                             |
      | metadata.complianceRecord.gscMarker                  | null                                                                                |
      | metadata.complianceRecord.retentionMarkerDays        | -1                                                                                  |
      | snapshotTrigger                                      | null                                                                                |
      | type                                                 | ORGANISATION                                                                        |
      | organisation.type                                    | ORGCSIGNEE                                                                          |
      | organisation.name                                    | goodsConsigneeName1{testId}                                                         |
      | organisation.registrationNumber                      | null                                                                                |
      | organisation.vatNumber                               | VAT42                                                                               |
      | organisation.industrySector                          | null                                                                                |
      | organisation.numberOfEmployees                       | null                                                                                |
      | attributes.attrs.header.ingestDateTime               | 2022-02-22T22:22:22.222Z                                                            |
      | attributes.attrs.goods.goodsItems.consignee.language | goods.goodsItems.1.consignee.language                                               |
      | attributes.attrs.eoriExtractionType                  | Download                                                                            |
      | attributes.attrs.goods.goodsItems.consignee.eori     | partyCConsignee1Eori                                                                |
      | attributes.attrs.eoriPrincipalEconomicActivity       | Test Stuff                                                                          |
      | attributes.attrs.eoriVatRegistrationNumber           | VAT42                                                                               |
      | attributes.attrs.eoriSendingDateTime                 | 2022-01-21T21:21:21.221                                                             |
      | attributes.attrs.eoriTraderName                      | partyCConsignee1                                                                    |
      | attributes.attrs.eoriDateOfRegistration              | 2023-01-20                                                                          |
    And one Party record for "SNS-C-CONSIGNEE" with following attributes
      | metadata.identityRecord.poleId.v2.id                 | SNSENS:P={locationCConsignee2,Woodstock,OX20 1PP{testId},Oxfordshire}[SNS-C-CONSIGNEE] |
      | metadata.identityRecord.type                         | P                                                                                      |
      | metadata.sourceRecord.name                           | SNSENS                                                                                 |
      | metadata.sourceRecord.shortName                      | SNS                                                                                    |
      | metadata.sourceRecord.location                       | submissionIdmetadata.messageIdentification                                             |
      | metadata.sourceRecord.id                             | {locationCConsignee2,Woodstock,OX20 1PP{testId},Oxfordshire}                           |
      | metadata.sourceRecord.audit.createdBy                | 0123456789                                                                             |
      | metadata.sourceRecord.audit.createdTimestamp         | 2022-02-22T22:22:22.222Z                                                               |
      | metadata.mappingRecord.name                          | SNS-C-CONSIGNEE                                                                        |
      | metadata.mappingRecord.version                       | mappingVersion                                                                         |
      | metadata.complianceRecord.visibility                 | UNKNOWN                                                                                |
      | metadata.complianceRecord.gscMarker                  | null                                                                                   |
      | metadata.complianceRecord.retentionMarkerDays        | -1                                                                                     |
      | snapshotTrigger                                      | null                                                                                   |
      | type                                                 | ORGANISATION                                                                           |
      | organisation.type                                    | ORGCSIGNEE                                                                             |
      | organisation.name                                    | goodsConsigneeName2{testId}                                                            |
      | organisation.registrationNumber                      | null                                                                                   |
      | organisation.vatNumber                               | VAT42                                                                                  |
      | organisation.industrySector                          | null                                                                                   |
      | organisation.numberOfEmployees                       | null                                                                                   |
      | attributes.attrs.header.ingestDateTime               | 2022-02-22T22:22:22.222Z                                                               |
      | attributes.attrs.goods.goodsItems.consignee.language | goods.goodsItems.2.consignee.language                                                  |
      | attributes.attrs.eoriExtractionType                  | Download                                                                               |
      | attributes.attrs.goods.goodsItems.consignee.eori     | locationCConsignee2Eori                                                                |
      | attributes.attrs.eoriPrincipalEconomicActivity       | Test Stuff                                                                             |
      | attributes.attrs.eoriVatRegistrationNumber           | VAT42                                                                                  |
      | attributes.attrs.eoriSendingDateTime                 | 2022-01-21T21:21:21.221                                                                |
      | attributes.attrs.eoriTraderName                      | locationCConsignee2                                                                    |
      | attributes.attrs.eoriDateOfRegistration              | 2023-01-20                                                                             |
    And one Party record for "SNS-C-NOTIFY" with following attributes
      | metadata.identityRecord.poleId.v2.id                   | SNSENS:P={partyCNotify0,Great Russell Street,WC1B 3DG{testId},London}[SNS-C-NOTIFY] |
      | metadata.identityRecord.type                           | P                                                                                   |
      | metadata.sourceRecord.name                             | SNSENS                                                                              |
      | metadata.sourceRecord.shortName                        | SNS                                                                                 |
      | metadata.sourceRecord.location                         | submissionIdmetadata.messageIdentification                                          |
      | metadata.sourceRecord.id                               | {partyCNotify0,Great Russell Street,WC1B 3DG{testId},London}                        |
      | metadata.sourceRecord.audit.createdBy                  | 0123456789                                                                          |
      | metadata.sourceRecord.audit.createdTimestamp           | 2022-02-22T22:22:22.222Z                                                            |
      | metadata.mappingRecord.name                            | SNS-C-NOTIFY                                                                        |
      | metadata.mappingRecord.version                         | mappingVersion                                                                      |
      | metadata.complianceRecord.visibility                   | UNKNOWN                                                                             |
      | metadata.complianceRecord.gscMarker                    | null                                                                                |
      | metadata.complianceRecord.retentionMarkerDays          | -1                                                                                  |
      | snapshotTrigger                                        | null                                                                                |
      | type                                                   | ORGANISATION                                                                        |
      | organisation.type                                      | ORGNOTIFY                                                                           |
      | organisation.name                                      | notifyPartyName{testId}                                                             |
      | organisation.registrationNumber                        | null                                                                                |
      | organisation.vatNumber                                 | VAT31                                                                               |
      | organisation.industrySector                            | null                                                                                |
      | organisation.numberOfEmployees                         | null                                                                                |
      | attributes.attrs.header.ingestDateTime                 | 2022-02-22T22:22:22.222Z                                                            |
      | attributes.attrs.goods.goodsItems.notifyParty.language | goods.goodsItems.0.notifyParty.language                                             |
      | attributes.attrs.eoriExtractionType                    | Download                                                                            |
      | attributes.attrs.goods.goodsItems.notifyParty.eori     | partyCNotify0Eori                                                                   |
      | attributes.attrs.eoriPrincipalEconomicActivity         | Test Stuff                                                                          |
      | attributes.attrs.eoriVatRegistrationNumber             | VAT31                                                                               |
      | attributes.attrs.eoriSendingDateTime                   | 2022-01-21T21:21:21.221                                                             |
      | attributes.attrs.eoriTraderName                        | partyCNotify0                                                                       |
      | attributes.attrs.eoriDateOfRegistration                | 2023-01-20                                                                          |
    And one Party record for "SNS-C-NOTIFY" with following attributes
      | metadata.identityRecord.poleId.v2.id                   | SNSENS:P={partyCNotify1,St Katharine,EC3N 4AB{testId},London}[SNS-C-NOTIFY] |
      | metadata.identityRecord.type                           | P                                                                           |
      | metadata.sourceRecord.name                             | SNSENS                                                                      |
      | metadata.sourceRecord.shortName                        | SNS                                                                         |
      | metadata.sourceRecord.location                         | submissionIdmetadata.messageIdentification                                  |
      | metadata.sourceRecord.id                               | {partyCNotify1,St Katharine,EC3N 4AB{testId},London}                        |
      | metadata.sourceRecord.audit.createdBy                  | 0123456789                                                                  |
      | metadata.sourceRecord.audit.createdTimestamp           | 2022-02-22T22:22:22.222Z                                                    |
      | metadata.mappingRecord.name                            | SNS-C-NOTIFY                                                                |
      | metadata.mappingRecord.version                         | mappingVersion                                                              |
      | metadata.complianceRecord.visibility                   | UNKNOWN                                                                     |
      | metadata.complianceRecord.gscMarker                    | null                                                                        |
      | metadata.complianceRecord.retentionMarkerDays          | -1                                                                          |
      | snapshotTrigger                                        | null                                                                        |
      | type                                                   | ORGANISATION                                                                |
      | organisation.type                                      | ORGNOTIFY                                                                   |
      | organisation.name                                      | notifyPartyName1{testId}                                                    |
      | organisation.registrationNumber                        | null                                                                        |
      | organisation.vatNumber                                 | VAT32                                                                       |
      | organisation.industrySector                            | null                                                                        |
      | organisation.numberOfEmployees                         | null                                                                        |
      | attributes.attrs.header.ingestDateTime                 | 2022-02-22T22:22:22.222Z                                                    |
      | attributes.attrs.goods.goodsItems.notifyParty.language | goods.goodsItems.1.notifyParty.language                                     |
      | attributes.attrs.eoriExtractionType                    | Download                                                                    |
      | attributes.attrs.goods.goodsItems.notifyParty.eori     | partyCNotify1Eori                                                           |
      | attributes.attrs.eoriPrincipalEconomicActivity         | Test Stuff                                                                  |
      | attributes.attrs.eoriVatRegistrationNumber             | VAT32                                                                       |
      | attributes.attrs.eoriSendingDateTime                   | 2022-01-21T21:21:21.221                                                     |
      | attributes.attrs.eoriTraderName                        | partyCNotify1                                                               |
      | attributes.attrs.eoriDateOfRegistration                | 2023-01-20                                                                  |
    And one Party record for "SNS-C-NOTIFY" with following attributes
      | metadata.identityRecord.poleId.v2.id                   | SNSENS:P={locationCNotify2,St Katharine,EC3N 4AB{testId},London}[SNS-C-NOTIFY] |
      | metadata.identityRecord.type                           | P                                                                              |
      | metadata.sourceRecord.name                             | SNSENS                                                                         |
      | metadata.sourceRecord.shortName                        | SNS                                                                            |
      | metadata.sourceRecord.location                         | submissionIdmetadata.messageIdentification                                     |
      | metadata.sourceRecord.id                               | {locationCNotify2,St Katharine,EC3N 4AB{testId},London}                        |
      | metadata.sourceRecord.audit.createdBy                  | 0123456789                                                                     |
      | metadata.sourceRecord.audit.createdTimestamp           | 2022-02-22T22:22:22.222Z                                                       |
      | metadata.mappingRecord.name                            | SNS-C-NOTIFY                                                                   |
      | metadata.mappingRecord.version                         | mappingVersion                                                                 |
      | metadata.complianceRecord.visibility                   | UNKNOWN                                                                        |
      | metadata.complianceRecord.gscMarker                    | null                                                                           |
      | metadata.complianceRecord.retentionMarkerDays          | -1                                                                             |
      | snapshotTrigger                                        | null                                                                           |
      | type                                                   | ORGANISATION                                                                   |
      | organisation.type                                      | ORGNOTIFY                                                                      |
      | organisation.name                                      | locationNotifyPartyName2{testId}                                               |
      | organisation.registrationNumber                        | null                                                                           |
      | organisation.vatNumber                                 | VAT32                                                                          |
      | organisation.industrySector                            | null                                                                           |
      | organisation.numberOfEmployees                         | null                                                                           |
      | attributes.attrs.header.ingestDateTime                 | 2022-02-22T22:22:22.222Z                                                       |
      | attributes.attrs.goods.goodsItems.notifyParty.language | goods.goodsItems.2.notifyParty.language                                        |
      | attributes.attrs.eoriExtractionType                    | Download                                                                       |
      | attributes.attrs.goods.goodsItems.notifyParty.eori     | locationCNotify2Eori                                                           |
      | attributes.attrs.eoriPrincipalEconomicActivity         | Test Stuff                                                                     |
      | attributes.attrs.eoriVatRegistrationNumber             | VAT32                                                                          |
      | attributes.attrs.eoriSendingDateTime                   | 2022-01-21T21:21:21.221                                                        |
      | attributes.attrs.eoriTraderName                        | locationCNotify2                                                               |
      | attributes.attrs.eoriDateOfRegistration                | 2023-01-20                                                                     |
    And one Party record for "SNS-DECLARANT" with following attributes
      | metadata.identityRecord.poleId.v2.id           | SNSENS:P={partyDeclarant,1 Savoy Hill,WC2R 0BP{testId},London}[SNS-DECLARANT] |
      | metadata.identityRecord.type                   | P                                                                             |
      | metadata.sourceRecord.name                     | SNSENS                                                                        |
      | metadata.sourceRecord.shortName                | SNS                                                                           |
      | metadata.sourceRecord.location                 | submissionIdmetadata.messageIdentification                                    |
      | metadata.sourceRecord.id                       | {partyDeclarant,1 Savoy Hill,WC2R 0BP{testId},London}                         |
      | metadata.sourceRecord.audit.createdBy          | 0123456789                                                                    |
      | metadata.sourceRecord.audit.createdTimestamp   | 2022-02-22T22:22:22.222Z                                                      |
      | metadata.mappingRecord.name                    | SNS-DECLARANT                                                                 |
      | metadata.mappingRecord.version                 | mappingVersion                                                                |
      | metadata.complianceRecord.visibility           | UNKNOWN                                                                       |
      | metadata.complianceRecord.gscMarker            | null                                                                          |
      | metadata.complianceRecord.retentionMarkerDays  | -1                                                                            |
      | snapshotTrigger                                | null                                                                          |
      | type                                           | ORGANISATION                                                                  |
      | organisation.type                              | ORGCOM                                                                        |
      | organisation.name                              | declarantName{testId}                                                         |
      | organisation.registrationNumber                | null                                                                          |
      | organisation.vatNumber                         | VAT22                                                                         |
      | organisation.industrySector                    | null                                                                          |
      | organisation.numberOfEmployees                 | null                                                                          |
      | attributes.attrs.header.ingestDateTime         | 2022-02-22T22:22:22.222Z                                                      |
      | attributes.attrs.parties.declarant.language    | parties.declarant.language                                                    |
      | attributes.attrs.eoriExtractionType            | Download                                                                      |
      | attributes.attrs.parties.declarant.eori        | partyDeclarantEori                                                            |
      | attributes.attrs.eoriPrincipalEconomicActivity | Test Stuff                                                                    |
      | attributes.attrs.eoriVatRegistrationNumber     | VAT22                                                                         |
      | attributes.attrs.eoriSendingDateTime           | 2022-01-21T21:21:21.221                                                       |
      | attributes.attrs.eoriTraderName                | partyDeclarant                                                                |
      | attributes.attrs.eoriDateOfRegistration        | 2023-01-20                                                                    |
    And one Party record for "SNS-M-CONSIGNEE" with following attributes
      | metadata.identityRecord.poleId.v2.id           | SNSENS:P={partyConsignee,221B Baker Street,NW1 6XE{testId},London}[SNS-M-CONSIGNEE] |
      | metadata.identityRecord.type                   | P                                                                                   |
      | metadata.sourceRecord.name                     | SNSENS                                                                              |
      | metadata.sourceRecord.shortName                | SNS                                                                                 |
      | metadata.sourceRecord.location                 | submissionIdmetadata.messageIdentification                                          |
      | metadata.sourceRecord.id                       | {partyConsignee,221B Baker Street,NW1 6XE{testId},London}                           |
      | metadata.sourceRecord.audit.createdBy          | 0123456789                                                                          |
      | metadata.sourceRecord.audit.createdTimestamp   | 2022-02-22T22:22:22.222Z                                                            |
      | metadata.mappingRecord.name                    | SNS-M-CONSIGNEE                                                                     |
      | metadata.mappingRecord.version                 | mappingVersion                                                                      |
      | metadata.complianceRecord.visibility           | UNKNOWN                                                                             |
      | metadata.complianceRecord.gscMarker            | null                                                                                |
      | metadata.complianceRecord.retentionMarkerDays  | -1                                                                                  |
      | snapshotTrigger                                | null                                                                                |
      | type                                           | ORGANISATION                                                                        |
      | organisation.type                              | ORGCSIGNEE                                                                          |
      | organisation.name                              | partiesConsigneeName{testId}                                                        |
      | organisation.registrationNumber                | null                                                                                |
      | organisation.vatNumber                         | VAT12                                                                               |
      | organisation.industrySector                    | null                                                                                |
      | organisation.numberOfEmployees                 | null                                                                                |
      | attributes.attrs.header.ingestDateTime         | 2022-02-22T22:22:22.222Z                                                            |
      | attributes.attrs.parties.consignee.language    | parties.consignee.language                                                          |
      | attributes.attrs.eoriExtractionType            | Download                                                                            |
      | attributes.attrs.parties.consignee.eori        | partyMConsigneeEori                                                                 |
      | attributes.attrs.eoriPrincipalEconomicActivity | Test Stuff                                                                          |
      | attributes.attrs.eoriVatRegistrationNumber     | VAT12                                                                               |
      | attributes.attrs.eoriSendingDateTime           | 2022-01-21T21:21:21.221                                                             |
      | attributes.attrs.eoriTraderName                | partyConsignee                                                                      |
      | attributes.attrs.eoriDateOfRegistration        | 2023-01-20                                                                          |
    And one Party record for "SNS-M-NOTIFY" with following attributes
      | metadata.identityRecord.poleId.v2.id           | SNSENS:P={PartyNotify,10 Downing Street,W1 2EB{testId},London}[SNS-M-NOTIFY] |
      | metadata.identityRecord.type                   | P                                                                            |
      | metadata.sourceRecord.name                     | SNSENS                                                                       |
      | metadata.sourceRecord.shortName                | SNS                                                                          |
      | metadata.sourceRecord.location                 | submissionIdmetadata.messageIdentification                                   |
      | metadata.sourceRecord.id                       | {PartyNotify,10 Downing Street,W1 2EB{testId},London}                        |
      | metadata.sourceRecord.audit.createdBy          | 0123456789                                                                   |
      | metadata.sourceRecord.audit.createdTimestamp   | 2022-02-22T22:22:22.222Z                                                     |
      | metadata.mappingRecord.name                    | SNS-M-NOTIFY                                                                 |
      | metadata.mappingRecord.version                 | mappingVersion                                                               |
      | metadata.complianceRecord.visibility           | UNKNOWN                                                                      |
      | metadata.complianceRecord.gscMarker            | null                                                                         |
      | metadata.complianceRecord.retentionMarkerDays  | -1                                                                           |
      | snapshotTrigger                                | null                                                                         |
      | type                                           | ORGANISATION                                                                 |
      | organisation.type                              | ORGNOTIFY                                                                    |
      | organisation.name                              | partiesNotifyName{testId}                                                    |
      | organisation.registrationNumber                | null                                                                         |
      | organisation.vatNumber                         | VAT02                                                                        |
      | organisation.industrySector                    | null                                                                         |
      | organisation.numberOfEmployees                 | null                                                                         |
      | attributes.attrs.header.ingestDateTime         | 2022-02-22T22:22:22.222Z                                                     |
      | attributes.attrs.parties.notifyParty.language  | parties.notifyParty.language                                                 |
      | attributes.attrs.eoriExtractionType            | Download                                                                     |
      | attributes.attrs.parties.notifyParty.eori      | partyNotifyEori                                                              |
      | attributes.attrs.eoriPrincipalEconomicActivity | Test Stuff                                                                   |
      | attributes.attrs.eoriVatRegistrationNumber     | VAT02                                                                        |
      | attributes.attrs.eoriSendingDateTime           | 2022-01-21T21:21:21.221                                                      |
      | attributes.attrs.eoriTraderName                | PartyNotify                                                                  |
      | attributes.attrs.eoriDateOfRegistration        | 2023-01-20                                                                   |
    And one Party record for "SNS-M-SHIPPER" with following attributes
      | metadata.identityRecord.poleId.v2.id           | SNSENS:P={PartyConsignor,12 Abbey Road,NW1 4AB{testId},London}[SNS-M-SHIPPER] |
      | metadata.identityRecord.type                   | P                                                                             |
      | metadata.sourceRecord.name                     | SNSENS                                                                        |
      | metadata.sourceRecord.shortName                | SNS                                                                           |
      | metadata.sourceRecord.location                 | submissionIdmetadata.messageIdentification                                    |
      | metadata.sourceRecord.id                       | {PartyConsignor,12 Abbey Road,NW1 4AB{testId},London}                         |
      | metadata.sourceRecord.audit.createdBy          | 0123456789                                                                    |
      | metadata.sourceRecord.audit.createdTimestamp   | 2022-02-22T22:22:22.222Z                                                      |
      | metadata.mappingRecord.name                    | SNS-M-SHIPPER                                                                 |
      | metadata.mappingRecord.version                 | mappingVersion                                                                |
      | metadata.complianceRecord.visibility           | UNKNOWN                                                                       |
      | metadata.complianceRecord.gscMarker            | null                                                                          |
      | metadata.complianceRecord.retentionMarkerDays  | -1                                                                            |
      | snapshotTrigger                                | null                                                                          |
      | type                                           | ORGANISATION                                                                  |
      | organisation.type                              | ORGSHIPPER                                                                    |
      | organisation.name                              | partiesConsignorName{testId}                                                  |
      | organisation.registrationNumber                | null                                                                          |
      | organisation.vatNumber                         | VAT01                                                                         |
      | organisation.industrySector                    | null                                                                          |
      | organisation.numberOfEmployees                 | null                                                                          |
      | attributes.attrs.header.ingestDateTime         | 2022-02-22T22:22:22.222Z                                                      |
      | attributes.attrs.parties.consignor.language    | parties.consignor.language                                                    |
      | attributes.attrs.eoriExtractionType            | Download                                                                      |
      | attributes.attrs.parties.consignor.eori        | partyConsignorEori                                                            |
      | attributes.attrs.eoriPrincipalEconomicActivity | Test Stuff                                                                    |
      | attributes.attrs.eoriVatRegistrationNumber     | VAT01                                                                         |
      | attributes.attrs.eoriSendingDateTime           | 2022-01-21T21:21:21.221                                                       |
      | attributes.attrs.eoriTraderName                | PartyConsignor                                                                |
      | attributes.attrs.eoriDateOfRegistration        | 2023-01-20                                                                    |
    And one Party record for "SNS-REPRESENTATIVE" with following attributes
      | metadata.identityRecord.poleId.v2.id             | SNSENS:P={Acme Co,7 Somewhere Street,NW1 5EX{testId},London}[SNS-REPRESENTATIVE] |
      | metadata.identityRecord.type                     | P                                                                                |
      | metadata.sourceRecord.name                       | SNSENS                                                                           |
      | metadata.sourceRecord.shortName                  | SNS                                                                              |
      | metadata.sourceRecord.location                   | submissionIdmetadata.messageIdentification                                       |
      | metadata.sourceRecord.id                         | {Acme Co,7 Somewhere Street,NW1 5EX{testId},London}                              |
      | metadata.sourceRecord.audit.createdBy            | 0123456789                                                                       |
      | metadata.sourceRecord.audit.createdTimestamp     | 2022-02-22T22:22:22.222Z                                                         |
      | metadata.mappingRecord.name                      | SNS-REPRESENTATIVE                                                               |
      | metadata.mappingRecord.version                   | mappingVersion                                                                   |
      | metadata.complianceRecord.visibility             | UNKNOWN                                                                          |
      | metadata.complianceRecord.gscMarker              | null                                                                             |
      | metadata.complianceRecord.retentionMarkerDays    | -1                                                                               |
      | snapshotTrigger                                  | null                                                                             |
      | type                                             | ORGANISATION                                                                     |
      | organisation.type                                | ORGREPS                                                                          |
      | organisation.name                                | representativeName{testId}                                                       |
      | organisation.registrationNumber                  | null                                                                             |
      | organisation.vatNumber                           | VAT01,VAT02                                                                      |
      | organisation.industrySector                      | null                                                                             |
      | organisation.numberOfEmployees                   | null                                                                             |
      | attributes.attrs.header.ingestDateTime           | 2022-02-22T22:22:22.222Z                                                         |
      | attributes.attrs.parties.representative.language | parties.representative.language                                                  |
      | attributes.attrs.eoriExtractionType              | Download                                                                         |
      | attributes.attrs.parties.representative.eori     | RepresentativeEori                                                               |
      | attributes.attrs.eoriPrincipalEconomicActivity   | Test Stuff                                                                       |
      | attributes.attrs.eoriVatRegistrationNumber       | VAT01,VAT02                                                                      |
      | attributes.attrs.eoriSendingDateTime             | 2022-01-21T21:21:21.221                                                          |
      | attributes.attrs.eoriTraderName                  | Acme Co                                                                          |
      | attributes.attrs.eoriDateOfRegistration          | 2023-01-20                                                                       |
    And one Party record for "SNS-M-CARRIER" with following attributes
      | metadata.identityRecord.poleId.v2.id           | SNSENS:P={partiesCarrier,62 Golden Street,MK1 3RW{testId},Milton Keynes}[SNS-M-CARRIER] |
      | metadata.identityRecord.type                   | P                                                                                       |
      | metadata.sourceRecord.name                     | SNSENS                                                                                  |
      | metadata.sourceRecord.shortName                | SNS                                                                                     |
      | metadata.sourceRecord.location                 | submissionIdmetadata.messageIdentification                                              |
      | metadata.sourceRecord.id                       | {partiesCarrier,62 Golden Street,MK1 3RW{testId},Milton Keynes}                         |
      | metadata.sourceRecord.audit.createdBy          | 0123456789                                                                              |
      | metadata.sourceRecord.audit.createdTimestamp   | 2022-02-22T22:22:22.222Z                                                                |
      | metadata.mappingRecord.name                    | SNS-M-CARRIER                                                                           |
      | metadata.mappingRecord.version                 | mappingVersion                                                                          |
      | metadata.complianceRecord.visibility           | UNKNOWN                                                                                 |
      | metadata.complianceRecord.gscMarker            | null                                                                                    |
      | metadata.complianceRecord.retentionMarkerDays  | -1                                                                                      |
      | snapshotTrigger                                | null                                                                                    |
      | type                                           | ORGANISATION                                                                            |
      | organisation.type                              | ORGCOM                                                                                  |
      | organisation.name                              | Bob{testId}                                                                             |
      | organisation.registrationNumber                | null                                                                                    |
      | organisation.vatNumber                         | VAT21,VAT22                                                                             |
      | organisation.industrySector                    | null                                                                                    |
      | organisation.numberOfEmployees                 | null                                                                                    |
      | attributes.attrs.header.ingestDateTime         | 2022-02-22T22:22:22.222Z                                                                |
      | attributes.attrs.parties.carrier.language      | parties.carrier.language                                                                |
      | attributes.attrs.parties.carrier.eori          | partiesCarrierEori                                                                      |
      | attributes.attrs.eoriExtractionType            | Download                                                                                |
      | attributes.attrs.eoriPrincipalEconomicActivity | Test Stuff                                                                              |
      | attributes.attrs.eoriVatRegistrationNumber     | VAT21,VAT22                                                                             |
      | attributes.attrs.eoriSendingDateTime           | 2022-01-21T21:21:21.221                                                                 |
      | attributes.attrs.eoriDateOfRegistration        | 2023-01-20                                                                              |
      | attributes.attrs.eoriTraderName                | partiesCarrier                                                                          |
    And one Party record for "SNS-SENDER" with following attributes
      | metadata.identityRecord.poleId.v2.id           | SNSENS:P={Testing,5 Test Street,TE5 1IN{testId},Testville}[SNS-SENDER] |
      | metadata.identityRecord.type                   | P                                                                      |
      | metadata.sourceRecord.name                     | SNSENS                                                                 |
      | metadata.sourceRecord.shortName                | SNS                                                                    |
      | metadata.sourceRecord.location                 | submissionIdmetadata.messageIdentification                             |
      | metadata.sourceRecord.id                       | {Testing,5 Test Street,TE5 1IN{testId},Testville}                      |
      | metadata.sourceRecord.audit.createdBy          | 0123456789                                                             |
      | metadata.sourceRecord.audit.createdTimestamp   | 2022-02-22T22:22:22.222Z                                               |
      | metadata.mappingRecord.name                    | SNS-SENDER                                                             |
      | metadata.mappingRecord.version                 | mappingVersion                                                         |
      | metadata.complianceRecord.visibility           | UNKNOWN                                                                |
      | metadata.complianceRecord.gscMarker            | null                                                                   |
      | metadata.complianceRecord.retentionMarkerDays  | -1                                                                     |
      | snapshotTrigger                                | null                                                                   |
      | type                                           | ORGANISATION                                                           |
      | organisation.type                              | ORGDECL                                                                |
      | organisation.name                              | Testing                                                                |
      | organisation.registrationNumber                | null                                                                   |
      | organisation.vatNumber                         | ABC,ZYX                                                                |
      | organisation.industrySector                    | null                                                                   |
      | organisation.numberOfEmployees                 | null                                                                   |
      | attributes.attrs.header.ingestDateTime         | 2022-02-22T22:22:22.222Z                                               |
      | attributes.attrs.eoriExtractionType            | Download                                                               |
      | attributes.attrs.eoriPrincipalEconomicActivity | Test Stuff                                                             |
      | attributes.attrs.eoriVatRegistrationNumber     | ABC,ZYX                                                                |
      | attributes.attrs.eoriSendingDateTime           | 2022-01-21T21:21:21.221                                                |
      | attributes.attrs.eoriDateOfRegistration        | 2022-01-20                                                             |
      | attributes.attrs.eoriTraderName                | Testing                                                                |
    And one Party record for "SNS-C-SHIPPER" with following attributes
      | metadata.identityRecord.poleId.v2.id                 | SNSENS:P={goodsConsignor,12 Abbey Road,NW1 4AB{testId},London}[SNS-C-SHIPPER] |
      | metadata.identityRecord.type                         | P                                                                             |
      | metadata.sourceRecord.name                           | SNSENS                                                                        |
      | metadata.sourceRecord.shortName                      | SNS                                                                           |
      | metadata.sourceRecord.location                       | submissionIdmetadata.messageIdentification                                    |
      | metadata.sourceRecord.id                             | {goodsConsignor,12 Abbey Road,NW1 4AB{testId},London}                         |
      | metadata.sourceRecord.audit.createdBy                | 0123456789                                                                    |
      | metadata.sourceRecord.audit.createdTimestamp         | 2022-02-22T22:22:22.222Z                                                      |
      | metadata.mappingRecord.name                          | SNS-C-SHIPPER                                                                 |
      | metadata.mappingRecord.version                       | mappingVersion                                                                |
      | metadata.complianceRecord.visibility                 | UNKNOWN                                                                       |
      | metadata.complianceRecord.gscMarker                  | null                                                                          |
      | metadata.complianceRecord.retentionMarkerDays        | -1                                                                            |
      | snapshotTrigger                                      | null                                                                          |
      | type                                                 | ORGANISATION                                                                  |
      | organisation.type                                    | ORGSHIPPER                                                                    |
      | organisation.name                                    | goodsConsignorName{testId}                                                    |
      | organisation.registrationNumber                      | null                                                                          |
      | organisation.vatNumber                               | VAT51                                                                         |
      | organisation.industrySector                          | null                                                                          |
      | organisation.numberOfEmployees                       | null                                                                          |
      | attributes.attrs.header.ingestDateTime               | 2022-02-22T22:22:22.222Z                                                      |
      | attributes.attrs.goods.goodsItems.consignor.eori     | goodsConsignorEori                                                            |
      | attributes.attrs.goods.goodsItems.consignor.language | goods.goodsItems.consignor.language                                           |
      | attributes.attrs.goods.goodsItems.commodityCode      | goods.goodsItems.commodityCode                                                |
      | attributes.attrs.eoriExtractionType                  | Download                                                                      |
      | attributes.attrs.eoriPrincipalEconomicActivity       | Test Stuff                                                                    |
      | attributes.attrs.eoriVatRegistrationNumber           | VAT51                                                                         |
      | attributes.attrs.eoriSendingDateTime                 | 2022-01-21T21:21:21.221                                                       |
      | attributes.attrs.eoriDateOfRegistration              | 2023-01-20                                                                    |
      | attributes.attrs.eoriTraderName                      | goodsConsignor                                                                |
    And one Party record for "SNS-C-SHIPPER" with following attributes
      | metadata.identityRecord.poleId.v2.id                 | SNSENS:P={Location CShip,8 Somewhere Street,NW1 5EX{testId},London}[SNS-C-SHIPPER] |
      | metadata.identityRecord.type                         | P                                                                                  |
      | metadata.sourceRecord.name                           | SNSENS                                                                             |
      | metadata.sourceRecord.shortName                      | SNS                                                                                |
      | metadata.sourceRecord.location                       | submissionIdmetadata.messageIdentification                                         |
      | metadata.sourceRecord.id                             | {Location CShip,8 Somewhere Street,NW1 5EX{testId},London}                         |
      | metadata.sourceRecord.audit.createdBy                | 0123456789                                                                         |
      | metadata.sourceRecord.audit.createdTimestamp         | 2022-02-22T22:22:22.222Z                                                           |
      | metadata.mappingRecord.name                          | SNS-C-SHIPPER                                                                      |
      | metadata.mappingRecord.version                       | mappingVersion                                                                     |
      | metadata.complianceRecord.visibility                 | UNKNOWN                                                                            |
      | metadata.complianceRecord.gscMarker                  | null                                                                               |
      | metadata.complianceRecord.retentionMarkerDays        | -1                                                                                 |
      | snapshotTrigger                                      | null                                                                               |
      | type                                                 | ORGANISATION                                                                       |
      | organisation.type                                    | ORGSHIPPER                                                                         |
      | organisation.name                                    | goodsConsignorName1{testId}                                                        |
      | organisation.registrationNumber                      | null                                                                               |
      | organisation.vatNumber                               | VAT01,VAT02                                                                        |
      | organisation.industrySector                          | null                                                                               |
      | organisation.numberOfEmployees                       | null                                                                               |
      | attributes.attrs.header.ingestDateTime               | 2022-02-22T22:22:22.222Z                                                           |
      | attributes.attrs.goods.goodsItems.consignor.eori     | goodsConsignor1Eori                                                                |
      | attributes.attrs.goods.goodsItems.consignor.language | language                                                                           |
      | attributes.attrs.goods.goodsItems.commodityCode      | commodityCode                                                                      |
      | attributes.attrs.eoriExtractionType                  | Download                                                                           |
      | attributes.attrs.eoriPrincipalEconomicActivity       | Test Stuff                                                                         |
      | attributes.attrs.eoriVatRegistrationNumber           | VAT01,VAT02                                                                        |
      | attributes.attrs.eoriSendingDateTime                 | 2022-01-21T21:21:21.221                                                            |
      | attributes.attrs.eoriDateOfRegistration              | 2023-01-20                                                                         |
      | attributes.attrs.eoriTraderName                      | Location CShip                                                                     |
    And one Party record for "SNS-C-SHIPPER" with following attributes
      | metadata.identityRecord.poleId.v2.id                 | SNSENS:P={goodsConsignorName2{testId}40LeedsLE12 0DS100}[SNS-C-SHIPPER] |
      | metadata.identityRecord.type                         | P                                                                       |
      | metadata.sourceRecord.name                           | SNSENS                                                                  |
      | metadata.sourceRecord.shortName                      | SNS                                                                     |
      | metadata.sourceRecord.location                       | submissionIdmetadata.messageIdentification                              |
      | metadata.sourceRecord.id                             | {goodsConsignorName2{testId}40LeedsLE12 0DS100}                         |
      | metadata.sourceRecord.audit.createdBy                | 0123456789                                                              |
      | metadata.sourceRecord.audit.createdTimestamp         | 2022-02-22T22:22:22.222Z                                                |
      | metadata.mappingRecord.name                          | SNS-C-SHIPPER                                                           |
      | metadata.mappingRecord.version                       | mappingVersion                                                          |
      | metadata.complianceRecord.visibility                 | UNKNOWN                                                                 |
      | metadata.complianceRecord.gscMarker                  | null                                                                    |
      | metadata.complianceRecord.retentionMarkerDays        | -1                                                                      |
      | snapshotTrigger                                      | null                                                                    |
      | type                                                 | ORGANISATION                                                            |
      | organisation.type                                    | ORGSHIPPER                                                              |
      | organisation.name                                    | goodsConsignorName2{testId}                                             |
      | organisation.registrationNumber                      | null                                                                    |
      | organisation.vatNumber                               | null                                                                    |
      | organisation.industrySector                          | null                                                                    |
      | organisation.numberOfEmployees                       | null                                                                    |
      | attributes.attrs.header.ingestDateTime               | 2022-02-22T22:22:22.222Z                                                |
      | attributes.attrs.goods.goodsItems.consignor.language | language                                                                |
      | attributes.attrs.goods.goodsItems.commodityCode      | commodityCode                                                           |
#
  Scenario: PartyRecords are emitted when EORI lookup key is present and name is null
    Given template StreamIngestRecord with the base file "sns-multiple-only-eori.input"
    And template EoriCdlzLandingRecord with the base file "eori.input"
    When Eori CDLZ data is presented as per the template to the landing topic landing-413
    When Readiness health check is completed
    And StreamIngestRecord source data is presented with attributes as per the template to the input topic with prefix fdp-sns-input
#   body.goods.goodsItems.2.consignor.eori is set to null
    Then 15 Party SNAPSHOTS will be emitted

  Scenario: PartyRecord is not emitted when EORI lookup key is missing and name is null
    Given template StreamIngestRecord with the base file "sns-multiple-missing-eori.input"
    And template EoriCdlzLandingRecord with the base file "eori.input"
    When Eori CDLZ data is presented as per the template to the landing topic landing-413
    When Readiness health check is completed
    And StreamIngestRecord source data is presented with attributes as per the template to the input topic with prefix fdp-sns-input
#  "SNS-SENDER" is always emitted because body.metadata.senderEORI cannot be null.
    Then 1 Party SNAPSHOTS will be emitted