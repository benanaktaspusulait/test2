@E2ELocation
Feature: Test SNS Command Adaptor - Location

  Scenario: LocationRecord
    Given template StreamIngestRecord with the base file "sns-multiple.input"
    And template EoriCdlzLandingRecord with the base file "eori.input"
    When Eori CDLZ data is presented as per the template to the landing topic landing-413
    When Readiness health check is completed
    And StreamIngestRecord source data is presented with attributes as per the template to the input topic with prefix fdp-sns-input
    Then 16 Location SNAPSHOTS will be emitted
    And one Location record for "SNS-C-CONS-ADD" with following attributes
      | metadata.identityRecord.poleId.v2.id             | SNSENS:P={locationCConsignee2,Woodstock,OX20 1PP{testId},Oxfordshire}[SNS-C-CONSIGNEE],L={22BristolBR11 1OL100} |
      | metadata.identityRecord.type                     | L                                                                                                               |
      | metadata.sourceRecord.name                       | SNSENS                                                                                                          |
      | metadata.sourceRecord.shortName                  | SNS                                                                                                             |
      | metadata.sourceRecord.location                   | submissionIdmetadata.messageIdentification                                                                      |
      | metadata.sourceRecord.id                         | {22BristolBR11 1OL100}                                                                                          |
      | metadata.sourceRecord.audit.createdBy            | 0123456789                                                                                                      |
      | metadata.sourceRecord.audit.createdTimestamp     | 2022-02-22T22:22:22.222Z                                                                                        |
      | metadata.sourceRecord.audit.updatedBy            | null                                                                                                            |
      | metadata.sourceRecord.audit.updatedTimestamp     | null                                                                                                            |
      | metadata.sourceRecord.audit.deletedBy            | null                                                                                                            |
      | metadata.sourceRecord.audit.deletedTimestamp     | null                                                                                                            |
      | metadata.mappingRecord.name                      | SNS-C-CONS-ADD                                                                                                  |
      | metadata.mappingRecord.version                   | mappingVersion                                                                                                  |
      | metadata.complianceRecord.visibility             | UNKNOWN                                                                                                         |
      | metadata.complianceRecord.gscMarker              | null                                                                                                            |
      | metadata.complianceRecord.retentionMarkerDays    | -1                                                                                                              |
      | snapshotTrigger                                  | null                                                                                                            |
      | startTimestamp                                   | null                                                                                                            |
      | endTimestamp                                     | null                                                                                                            |
      | type                                             | ADDRESS                                                                                                         |
      | party.poleId.v2.id                               | SNSENS:P={locationCConsignee2,Woodstock,OX20 1PP{testId},Oxfordshire}[SNS-C-CONSIGNEE]                          |
      | party.type                                       | P                                                                                                               |
      | role                                             | PTOLCSIGNE                                                                                                      |
      | address.type                                     | LOCADDR                                                                                                         |
      | address.postCode                                 | BR11 1OL                                                                                                        |
      | address.poBox                                    | null                                                                                                            |
      | address.fullAddress                              | goodsConsigneeName2{testId} 22 Bristol BR11 1OL 100                                                             |
      | address.name                                     | goodsConsigneeName2{testId}                                                                                     |
      | address.siteLocation                             | null                                                                                                            |
      | address.number                                   | null                                                                                                            |
      | address.street                                   | 22                                                                                                              |
      | address.town                                     | Bristol                                                                                                         |
      | address.area                                     | null                                                                                                            |
      | address.district                                 | null                                                                                                            |
      | address.county                                   | null                                                                                                            |
      | address.country                                  | 100                                                                                                             |
      | address.uniquePropertyReferenceNumber            | null                                                                                                            |
      | address.latitude                                 | null                                                                                                            |
      | address.longitude                                | null                                                                                                            |
      | attributes.attrs.goods.goodsItems.consignee.eori | locationCConsignee2Eori                                                                                         |
      | attributes.attrs.header.ingestDateTime           | 2022-02-22T22:22:22.222Z                                                                                        |
    And one Location record for "SNS-C-CONS-ADD" with following attributes
      | metadata.identityRecord.poleId.v2.id             | SNSENS:P={partyCConsignee1,Woodstock,OX20 1PP{testId},Oxfordshire}[SNS-C-CONSIGNEE],L={22BristolBR11 1OL100} |
      | metadata.identityRecord.type                     | L                                                                                                            |
      | metadata.sourceRecord.name                       | SNSENS                                                                                                       |
      | metadata.sourceRecord.shortName                  | SNS                                                                                                          |
      | metadata.sourceRecord.location                   | submissionIdmetadata.messageIdentification                                                                   |
      | metadata.sourceRecord.id                         | {22BristolBR11 1OL100}                                                                                       |
      | metadata.sourceRecord.audit.createdBy            | 0123456789                                                                                                   |
      | metadata.sourceRecord.audit.createdTimestamp     | 2022-02-22T22:22:22.222Z                                                                                     |
      | metadata.sourceRecord.audit.updatedBy            | null                                                                                                         |
      | metadata.sourceRecord.audit.updatedTimestamp     | null                                                                                                         |
      | metadata.sourceRecord.audit.deletedBy            | null                                                                                                         |
      | metadata.sourceRecord.audit.deletedTimestamp     | null                                                                                                         |
      | metadata.mappingRecord.name                      | SNS-C-CONS-ADD                                                                                               |
      | metadata.mappingRecord.version                   | mappingVersion                                                                                               |
      | metadata.complianceRecord.visibility             | UNKNOWN                                                                                                      |
      | metadata.complianceRecord.gscMarker              | null                                                                                                         |
      | metadata.complianceRecord.retentionMarkerDays    | -1                                                                                                           |
      | snapshotTrigger                                  | null                                                                                                         |
      | startTimestamp                                   | null                                                                                                         |
      | endTimestamp                                     | null                                                                                                         |
      | type                                             | ADDRESS                                                                                                      |
      | party.poleId.v2.id                               | SNSENS:P={partyCConsignee1,Woodstock,OX20 1PP{testId},Oxfordshire}[SNS-C-CONSIGNEE]                          |
      | party.type                                       | P                                                                                                            |
      | role                                             | PTOLCSIGNE                                                                                                   |
      | address.type                                     | LOCADDR                                                                                                      |
      | address.postCode                                 | BR11 1OL                                                                                                     |
      | address.poBox                                    | null                                                                                                         |
      | address.fullAddress                              | goodsConsigneeName1{testId} 22 Bristol BR11 1OL 100                                                          |
      | address.name                                     | goodsConsigneeName1{testId}                                                                                  |
      | address.siteLocation                             | null                                                                                                         |
      | address.number                                   | null                                                                                                         |
      | address.street                                   | 22                                                                                                           |
      | address.town                                     | Bristol                                                                                                      |
      | address.area                                     | null                                                                                                         |
      | address.district                                 | null                                                                                                         |
      | address.county                                   | null                                                                                                         |
      | address.country                                  | 100                                                                                                          |
      | address.uniquePropertyReferenceNumber            | null                                                                                                         |
      | address.latitude                                 | null                                                                                                         |
      | address.longitude                                | null                                                                                                         |
      | attributes.attrs.goods.goodsItems.consignee.eori | partyCConsignee1Eori                                                                                         |
      | attributes.attrs.header.ingestDateTime           | 2022-02-22T22:22:22.222Z                                                                                     |
    And one Location record for "SNS-C-CONS-ADD" with following attributes
      | metadata.identityRecord.poleId.v2.id             | SNSENS:P={partyCConsignee0,Castlehill,EH1 2NG{testId},Edinburgh}[SNS-C-CONSIGNEE],L={15LondonLD12 3ON100} |
      | metadata.identityRecord.type                     | L                                                                                                         |
      | metadata.sourceRecord.name                       | SNSENS                                                                                                    |
      | metadata.sourceRecord.shortName                  | SNS                                                                                                       |
      | metadata.sourceRecord.location                   | submissionIdmetadata.messageIdentification                                                                |
      | metadata.sourceRecord.id                         | {15LondonLD12 3ON100}                                                                                     |
      | metadata.sourceRecord.audit.createdBy            | 0123456789                                                                                                |
      | metadata.sourceRecord.audit.createdTimestamp     | 2022-02-22T22:22:22.222Z                                                                                  |
      | metadata.sourceRecord.audit.updatedBy            | null                                                                                                      |
      | metadata.sourceRecord.audit.updatedTimestamp     | null                                                                                                      |
      | metadata.sourceRecord.audit.deletedBy            | null                                                                                                      |
      | metadata.sourceRecord.audit.deletedTimestamp     | null                                                                                                      |
      | metadata.mappingRecord.name                      | SNS-C-CONS-ADD                                                                                            |
      | metadata.mappingRecord.version                   | mappingVersion                                                                                            |
      | metadata.complianceRecord.visibility             | UNKNOWN                                                                                                   |
      | metadata.complianceRecord.gscMarker              | null                                                                                                      |
      | metadata.complianceRecord.retentionMarkerDays    | -1                                                                                                        |
      | snapshotTrigger                                  | null                                                                                                      |
      | startTimestamp                                   | null                                                                                                      |
      | endTimestamp                                     | null                                                                                                      |
      | type                                             | ADDRESS                                                                                                   |
      | party.poleId.v2.id                               | SNSENS:P={partyCConsignee0,Castlehill,EH1 2NG{testId},Edinburgh}[SNS-C-CONSIGNEE]                         |
      | party.type                                       | P                                                                                                         |
      | role                                             | PTOLCSIGNE                                                                                                |
      | address.type                                     | LOCADDR                                                                                                   |
      | address.postCode                                 | LD12 3ON                                                                                                  |
      | address.poBox                                    | null                                                                                                      |
      | address.fullAddress                              | goodsConsigneeName{testId} 15 London LD12 3ON 100                                                         |
      | address.name                                     | goodsConsigneeName{testId}                                                                                |
      | address.siteLocation                             | null                                                                                                      |
      | address.number                                   | null                                                                                                      |
      | address.street                                   | 15                                                                                                        |
      | address.town                                     | London                                                                                                    |
      | address.area                                     | null                                                                                                      |
      | address.district                                 | null                                                                                                      |
      | address.county                                   | null                                                                                                      |
      | address.country                                  | 100                                                                                                       |
      | address.uniquePropertyReferenceNumber            | null                                                                                                      |
      | address.latitude                                 | null                                                                                                      |
      | address.longitude                                | null                                                                                                      |
      | attributes.attrs.goods.goodsItems.consignee.eori | partyCConsignee0Eori                                                                                      |
      | attributes.attrs.header.ingestDateTime           | 2022-02-22T22:22:22.222Z                                                                                  |
    And one Location record for "SNS-C-NOTIFY-ADD" with following attributes
      | metadata.identityRecord.poleId.v2.id          | SNSENS:P={locationCNotify2,St Katharine,EC3N 4AB{testId},London}[SNS-C-NOTIFY],L={66LiverpoolLI90 POL100} |
      | metadata.identityRecord.type                  | L                                                                                                         |
      | metadata.sourceRecord.name                    | SNSENS                                                                                                    |
      | metadata.sourceRecord.shortName               | SNS                                                                                                       |
      | metadata.sourceRecord.location                | submissionIdmetadata.messageIdentification                                                                |
      | metadata.sourceRecord.id                      | {66LiverpoolLI90 POL100}                                                                                  |
      | metadata.sourceRecord.audit.createdBy         | 0123456789                                                                                                |
      | metadata.sourceRecord.audit.createdTimestamp  | 2022-02-22T22:22:22.222Z                                                                                  |
      | metadata.sourceRecord.audit.updatedBy         | null                                                                                                      |
      | metadata.sourceRecord.audit.updatedTimestamp  | null                                                                                                      |
      | metadata.sourceRecord.audit.deletedBy         | null                                                                                                      |
      | metadata.sourceRecord.audit.deletedTimestamp  | null                                                                                                      |
      | metadata.mappingRecord.name                   | SNS-C-NOTIFY-ADD                                                                                          |
      | metadata.mappingRecord.version                | mappingVersion                                                                                            |
      | metadata.complianceRecord.visibility          | UNKNOWN                                                                                                   |
      | metadata.complianceRecord.gscMarker           | null                                                                                                      |
      | metadata.complianceRecord.retentionMarkerDays | -1                                                                                                        |
      | snapshotTrigger                               | null                                                                                                      |
      | startTimestamp                                | null                                                                                                      |
      | endTimestamp                                  | null                                                                                                      |
      | type                                          | ADDRESS                                                                                                   |
      | party.poleId.v2.id                            | SNSENS:P={locationCNotify2,St Katharine,EC3N 4AB{testId},London}[SNS-C-NOTIFY]                            |
      | party.type                                    | P                                                                                                         |
      | role                                          | PTOLASSO                                                                                                  |
      | address.type                                  | LOCADDR                                                                                                   |
      | address.postCode                              | LI90 POL                                                                                                  |
      | address.poBox                                 | null                                                                                                      |
      | address.fullAddress                           | locationNotifyPartyName2{testId} 66 Liverpool LI90 POL 100                                                |
      | address.name                                  | locationNotifyPartyName2{testId}                                                                          |
      | address.siteLocation                          | null                                                                                                      |
      | address.number                                | null                                                                                                      |
      | address.street                                | 66                                                                                                        |
      | address.town                                  | Liverpool                                                                                                 |
      | address.area                                  | null                                                                                                      |
      | address.district                              | null                                                                                                      |
      | address.county                                | null                                                                                                      |
      | address.country                               | 100                                                                                                       |
      | address.uniquePropertyReferenceNumber         | null                                                                                                      |
      | address.latitude                              | null                                                                                                      |
      | address.longitude                             | null                                                                                                      |
      | attributes.attrs.header.ingestDateTime        | 2022-02-22T22:22:22.222Z                                                                                  |
    And one Location record for "SNS-C-NOTIFY-ADD" with following attributes
      | metadata.identityRecord.poleId.v2.id          | SNSENS:P={partyCNotify1,St Katharine,EC3N 4AB{testId},London}[SNS-C-NOTIFY],L={66LiverpoolLI90 POL100} |
      | metadata.identityRecord.type                  | L                                                                                                      |
      | metadata.sourceRecord.name                    | SNSENS                                                                                                 |
      | metadata.sourceRecord.shortName               | SNS                                                                                                    |
      | metadata.sourceRecord.location                | submissionIdmetadata.messageIdentification                                                             |
      | metadata.sourceRecord.id                      | {66LiverpoolLI90 POL100}                                                                               |
      | metadata.sourceRecord.audit.createdBy         | 0123456789                                                                                             |
      | metadata.sourceRecord.audit.createdTimestamp  | 2022-02-22T22:22:22.222Z                                                                               |
      | metadata.sourceRecord.audit.updatedBy         | null                                                                                                   |
      | metadata.sourceRecord.audit.updatedTimestamp  | null                                                                                                   |
      | metadata.sourceRecord.audit.deletedBy         | null                                                                                                   |
      | metadata.sourceRecord.audit.deletedTimestamp  | null                                                                                                   |
      | metadata.mappingRecord.name                   | SNS-C-NOTIFY-ADD                                                                                       |
      | metadata.mappingRecord.version                | mappingVersion                                                                                         |
      | metadata.complianceRecord.visibility          | UNKNOWN                                                                                                |
      | metadata.complianceRecord.gscMarker           | null                                                                                                   |
      | metadata.complianceRecord.retentionMarkerDays | -1                                                                                                     |
      | snapshotTrigger                               | null                                                                                                   |
      | startTimestamp                                | null                                                                                                   |
      | endTimestamp                                  | null                                                                                                   |
      | type                                          | ADDRESS                                                                                                |
      | party.poleId.v2.id                            | SNSENS:P={partyCNotify1,St Katharine,EC3N 4AB{testId},London}[SNS-C-NOTIFY]                            |
      | party.type                                    | P                                                                                                      |
      | role                                          | PTOLASSO                                                                                               |
      | address.type                                  | LOCADDR                                                                                                |
      | address.postCode                              | LI90 POL                                                                                               |
      | address.poBox                                 | null                                                                                                   |
      | address.fullAddress                           | notifyPartyName1{testId} 66 Liverpool LI90 POL 100                                                     |
      | address.name                                  | notifyPartyName1{testId}                                                                               |
      | address.siteLocation                          | null                                                                                                   |
      | address.number                                | null                                                                                                   |
      | address.street                                | 66                                                                                                     |
      | address.town                                  | Liverpool                                                                                              |
      | address.area                                  | null                                                                                                   |
      | address.district                              | null                                                                                                   |
      | address.county                                | null                                                                                                   |
      | address.country                               | 100                                                                                                    |
      | address.uniquePropertyReferenceNumber         | null                                                                                                   |
      | address.latitude                              | null                                                                                                   |
      | address.longitude                             | null                                                                                                   |
      | attributes.attrs.header.ingestDateTime        | 2022-02-22T22:22:22.222Z                                                                               |
    And one Location record for "SNS-C-NOTIFY-ADD" with following attributes
      | metadata.identityRecord.poleId.v2.id          | SNSENS:P={partyCNotify0,Great Russell Street,WC1B 3DG{testId},London}[SNS-C-NOTIFY],L={100ReadingRG1 0NG100} |
      | metadata.identityRecord.type                  | L                                                                                                            |
      | metadata.sourceRecord.name                    | SNSENS                                                                                                       |
      | metadata.sourceRecord.shortName               | SNS                                                                                                          |
      | metadata.sourceRecord.location                | submissionIdmetadata.messageIdentification                                                                   |
      | metadata.sourceRecord.id                      | {100ReadingRG1 0NG100}                                                                                       |
      | metadata.sourceRecord.audit.createdBy         | 0123456789                                                                                                   |
      | metadata.sourceRecord.audit.createdTimestamp  | 2022-02-22T22:22:22.222Z                                                                                     |
      | metadata.sourceRecord.audit.updatedBy         | null                                                                                                         |
      | metadata.sourceRecord.audit.updatedTimestamp  | null                                                                                                         |
      | metadata.sourceRecord.audit.deletedBy         | null                                                                                                         |
      | metadata.sourceRecord.audit.deletedTimestamp  | null                                                                                                         |
      | metadata.mappingRecord.name                   | SNS-C-NOTIFY-ADD                                                                                             |
      | metadata.mappingRecord.version                | mappingVersion                                                                                               |
      | metadata.complianceRecord.visibility          | UNKNOWN                                                                                                      |
      | metadata.complianceRecord.gscMarker           | null                                                                                                         |
      | metadata.complianceRecord.retentionMarkerDays | -1                                                                                                           |
      | snapshotTrigger                               | null                                                                                                         |
      | startTimestamp                                | null                                                                                                         |
      | endTimestamp                                  | null                                                                                                         |
      | type                                          | ADDRESS                                                                                                      |
      | party.poleId.v2.id                            | SNSENS:P={partyCNotify0,Great Russell Street,WC1B 3DG{testId},London}[SNS-C-NOTIFY]                          |
      | party.type                                    | P                                                                                                            |
      | role                                          | PTOLASSO                                                                                                     |
      | address.type                                  | LOCADDR                                                                                                      |
      | address.postCode                              | RG1 0NG                                                                                                      |
      | address.poBox                                 | null                                                                                                         |
      | address.fullAddress                           | notifyPartyName{testId} 100 Reading RG1 0NG 100                                                              |
      | address.name                                  | notifyPartyName{testId}                                                                                      |
      | address.siteLocation                          | null                                                                                                         |
      | address.number                                | null                                                                                                         |
      | address.street                                | 100                                                                                                          |
      | address.town                                  | Reading                                                                                                      |
      | address.area                                  | null                                                                                                         |
      | address.district                              | null                                                                                                         |
      | address.county                                | null                                                                                                         |
      | address.country                               | 100                                                                                                          |
      | address.uniquePropertyReferenceNumber         | null                                                                                                         |
      | address.latitude                              | null                                                                                                         |
      | address.longitude                             | null                                                                                                         |
      | attributes.attrs.header.ingestDateTime        | 2022-02-22T22:22:22.222Z                                                                                     |
    And one Location record for "SNS-C-SHIP-ADD" with following attributes
      | metadata.identityRecord.poleId.v2.id          | SNSENS:P={Location CShip,8 Somewhere Street,NW1 5EX{testId},London}[SNS-C-SHIPPER],L={40LeedsLE12 0DS100} |
      | metadata.identityRecord.type                  | L                                                                                                         |
      | metadata.sourceRecord.name                    | SNSENS                                                                                                    |
      | metadata.sourceRecord.shortName               | SNS                                                                                                       |
      | metadata.sourceRecord.location                | submissionIdmetadata.messageIdentification                                                                |
      | metadata.sourceRecord.id                      | {40LeedsLE12 0DS100}                                                                                      |
      | metadata.sourceRecord.audit.createdBy         | 0123456789                                                                                                |
      | metadata.sourceRecord.audit.createdTimestamp  | 2022-02-22T22:22:22.222Z                                                                                  |
      | metadata.sourceRecord.audit.updatedBy         | null                                                                                                      |
      | metadata.sourceRecord.audit.updatedTimestamp  | null                                                                                                      |
      | metadata.sourceRecord.audit.deletedBy         | null                                                                                                      |
      | metadata.sourceRecord.audit.deletedTimestamp  | null                                                                                                      |
      | metadata.mappingRecord.name                   | SNS-C-SHIP-ADD                                                                                            |
      | metadata.mappingRecord.version                | mappingVersion                                                                                            |
      | metadata.complianceRecord.visibility          | UNKNOWN                                                                                                   |
      | metadata.complianceRecord.gscMarker           | null                                                                                                      |
      | metadata.complianceRecord.retentionMarkerDays | -1                                                                                                        |
      | snapshotTrigger                               | null                                                                                                      |
      | startTimestamp                                | null                                                                                                      |
      | endTimestamp                                  | null                                                                                                      |
      | type                                          | ADDRESS                                                                                                   |
      | party.poleId.v2.id                            | SNSENS:P={Location CShip,8 Somewhere Street,NW1 5EX{testId},London}[SNS-C-SHIPPER]                        |
      | party.type                                    | P                                                                                                         |
      | role                                          | PTOLSHIP                                                                                                  |
      | address.type                                  | LOCADDR                                                                                                   |
      | address.postCode                              | LE12 0DS                                                                                                  |
      | address.poBox                                 | null                                                                                                      |
      | address.fullAddress                           | goodsConsignorName1{testId} 40 Leeds LE12 0DS 100                                                         |
      | address.name                                  | goodsConsignorName1{testId}                                                                               |
      | address.siteLocation                          | null                                                                                                      |
      | address.number                                | null                                                                                                      |
      | address.street                                | 40                                                                                                        |
      | address.town                                  | Leeds                                                                                                     |
      | address.area                                  | null                                                                                                      |
      | address.district                              | null                                                                                                      |
      | address.county                                | null                                                                                                      |
      | address.country                               | 100                                                                                                       |
      | address.uniquePropertyReferenceNumber         | null                                                                                                      |
      | address.latitude                              | null                                                                                                      |
      | address.longitude                             | null                                                                                                      |
      | attributes.attrs.header.ingestDateTime        | 2022-02-22T22:22:22.222Z                                                                                  |
    And one Location record for "SNS-C-SHIP-ADD" with following attributes
      | metadata.identityRecord.poleId.v2.id          | SNSENS:P={goodsConsignorName2{testId}40LeedsLE12 0DS100}[SNS-C-SHIPPER],L={40LeedsLE12 0DS100} |
      | metadata.identityRecord.type                  | L                                                                                              |
      | metadata.sourceRecord.name                    | SNSENS                                                                                         |
      | metadata.sourceRecord.shortName               | SNS                                                                                            |
      | metadata.sourceRecord.location                | submissionIdmetadata.messageIdentification                                                     |
      | metadata.sourceRecord.id                      | {40LeedsLE12 0DS100}                                                                           |
      | metadata.sourceRecord.audit.createdBy         | 0123456789                                                                                     |
      | metadata.sourceRecord.audit.createdTimestamp  | 2022-02-22T22:22:22.222Z                                                                       |
      | metadata.sourceRecord.audit.updatedBy         | null                                                                                           |
      | metadata.sourceRecord.audit.updatedTimestamp  | null                                                                                           |
      | metadata.sourceRecord.audit.deletedBy         | null                                                                                           |
      | metadata.sourceRecord.audit.deletedTimestamp  | null                                                                                           |
      | metadata.mappingRecord.name                   | SNS-C-SHIP-ADD                                                                                 |
      | metadata.mappingRecord.version                | mappingVersion                                                                                 |
      | metadata.complianceRecord.visibility          | UNKNOWN                                                                                        |
      | metadata.complianceRecord.gscMarker           | null                                                                                           |
      | metadata.complianceRecord.retentionMarkerDays | -1                                                                                             |
      | snapshotTrigger                               | null                                                                                           |
      | startTimestamp                                | null                                                                                           |
      | endTimestamp                                  | null                                                                                           |
      | type                                          | ADDRESS                                                                                        |
      | party.poleId.v2.id                            | SNSENS:P={goodsConsignorName2{testId}40LeedsLE12 0DS100}[SNS-C-SHIPPER]                        |
      | party.type                                    | P                                                                                              |
      | role                                          | PTOLSHIP                                                                                       |
      | address.type                                  | LOCADDR                                                                                        |
      | address.postCode                              | LE12 0DS                                                                                       |
      | address.poBox                                 | null                                                                                           |
      | address.fullAddress                           | goodsConsignorName2{testId} 40 Leeds LE12 0DS 100                                              |
      | address.name                                  | goodsConsignorName2{testId}                                                                    |
      | address.siteLocation                          | null                                                                                           |
      | address.number                                | null                                                                                           |
      | address.street                                | 40                                                                                             |
      | address.town                                  | Leeds                                                                                          |
      | address.area                                  | null                                                                                           |
      | address.district                              | null                                                                                           |
      | address.county                                | null                                                                                           |
      | address.country                               | 100                                                                                            |
      | address.uniquePropertyReferenceNumber         | null                                                                                           |
      | address.latitude                              | null                                                                                           |
      | address.longitude                             | null                                                                                           |
      | attributes.attrs.header.ingestDateTime        | 2022-02-22T22:22:22.222Z                                                                       |
    And one Location record for "SNS-C-SHIP-ADD" with following attributes
      | metadata.identityRecord.poleId.v2.id          | SNSENS:P={goodsConsignor,12 Abbey Road,NW1 4AB{testId},London}[SNS-C-SHIPPER],L={11BirminghamBH1 2AM100} |
      | metadata.identityRecord.type                  | L                                                                                                        |
      | metadata.sourceRecord.name                    | SNSENS                                                                                                   |
      | metadata.sourceRecord.shortName               | SNS                                                                                                      |
      | metadata.sourceRecord.location                | submissionIdmetadata.messageIdentification                                                               |
      | metadata.sourceRecord.id                      | {11BirminghamBH1 2AM100}                                                                                 |
      | metadata.sourceRecord.audit.createdBy         | 0123456789                                                                                               |
      | metadata.sourceRecord.audit.createdTimestamp  | 2022-02-22T22:22:22.222Z                                                                                 |
      | metadata.sourceRecord.audit.updatedBy         | null                                                                                                     |
      | metadata.sourceRecord.audit.updatedTimestamp  | null                                                                                                     |
      | metadata.sourceRecord.audit.deletedBy         | null                                                                                                     |
      | metadata.sourceRecord.audit.deletedTimestamp  | null                                                                                                     |
      | metadata.mappingRecord.name                   | SNS-C-SHIP-ADD                                                                                           |
      | metadata.mappingRecord.version                | mappingVersion                                                                                           |
      | metadata.complianceRecord.visibility          | UNKNOWN                                                                                                  |
      | metadata.complianceRecord.gscMarker           | null                                                                                                     |
      | metadata.complianceRecord.retentionMarkerDays | -1                                                                                                       |
      | snapshotTrigger                               | null                                                                                                     |
      | startTimestamp                                | null                                                                                                     |
      | endTimestamp                                  | null                                                                                                     |
      | type                                          | ADDRESS                                                                                                  |
      | party.poleId.v2.id                            | SNSENS:P={goodsConsignor,12 Abbey Road,NW1 4AB{testId},London}[SNS-C-SHIPPER]                            |
      | party.type                                    | P                                                                                                        |
      | role                                          | PTOLSHIP                                                                                                 |
      | address.type                                  | LOCADDR                                                                                                  |
      | address.postCode                              | BH1 2AM                                                                                                  |
      | address.poBox                                 | null                                                                                                     |
      | address.fullAddress                           | goodsConsignorName{testId} 11 Birmingham BH1 2AM 100                                                     |
      | address.name                                  | goodsConsignorName{testId}                                                                               |
      | address.siteLocation                          | null                                                                                                     |
      | address.number                                | null                                                                                                     |
      | address.street                                | 11                                                                                                       |
      | address.town                                  | Birmingham                                                                                               |
      | address.area                                  | null                                                                                                     |
      | address.district                              | null                                                                                                     |
      | address.county                                | null                                                                                                     |
      | address.country                               | 100                                                                                                      |
      | address.uniquePropertyReferenceNumber         | null                                                                                                     |
      | address.latitude                              | null                                                                                                     |
      | address.longitude                             | null                                                                                                     |
      | attributes.attrs.header.ingestDateTime        | 2022-02-22T22:22:22.222Z                                                                                 |
    And one Location record for "SNS-DECLARANT-ADD" with following attributes
      | metadata.identityRecord.poleId.v2.id          | SNSENS:P={partyDeclarant,1 Savoy Hill,WC2R 0BP{testId},London}[SNS-DECLARANT],L={100BathBA44 4TH100} |
      | metadata.identityRecord.type                  | L                                                                                                    |
      | metadata.sourceRecord.name                    | SNSENS                                                                                               |
      | metadata.sourceRecord.shortName               | SNS                                                                                                  |
      | metadata.sourceRecord.location                | submissionIdmetadata.messageIdentification                                                           |
      | metadata.sourceRecord.id                      | {100BathBA44 4TH100}                                                                                 |
      | metadata.sourceRecord.audit.createdBy         | 0123456789                                                                                           |
      | metadata.sourceRecord.audit.createdTimestamp  | 2022-02-22T22:22:22.222Z                                                                             |
      | metadata.sourceRecord.audit.updatedBy         | null                                                                                                 |
      | metadata.sourceRecord.audit.updatedTimestamp  | null                                                                                                 |
      | metadata.sourceRecord.audit.deletedBy         | null                                                                                                 |
      | metadata.sourceRecord.audit.deletedTimestamp  | null                                                                                                 |
      | metadata.mappingRecord.name                   | SNS-DECLARANT-ADD                                                                                    |
      | metadata.mappingRecord.version                | mappingVersion                                                                                       |
      | metadata.complianceRecord.visibility          | UNKNOWN                                                                                              |
      | metadata.complianceRecord.gscMarker           | null                                                                                                 |
      | metadata.complianceRecord.retentionMarkerDays | -1                                                                                                   |
      | snapshotTrigger                               | null                                                                                                 |
      | startTimestamp                                | null                                                                                                 |
      | endTimestamp                                  | null                                                                                                 |
      | type                                          | ADDRESS                                                                                              |
      | party.poleId.v2.id                            | SNSENS:P={partyDeclarant,1 Savoy Hill,WC2R 0BP{testId},London}[SNS-DECLARANT]                        |
      | party.type                                    | P                                                                                                    |
      | role                                          | PTOLASSO                                                                                             |
      | address.type                                  | LOCADDR                                                                                              |
      | address.postCode                              | BA44 4TH                                                                                             |
      | address.poBox                                 | null                                                                                                 |
      | address.fullAddress                           | declarantName{testId} 100 Bath BA44 4TH 100                                                          |
      | address.name                                  | declarantName{testId}                                                                                |
      | address.siteLocation                          | null                                                                                                 |
      | address.number                                | null                                                                                                 |
      | address.street                                | 100                                                                                                  |
      | address.town                                  | Bath                                                                                                 |
      | address.area                                  | null                                                                                                 |
      | address.district                              | null                                                                                                 |
      | address.county                                | null                                                                                                 |
      | address.country                               | 100                                                                                                  |
      | address.uniquePropertyReferenceNumber         | null                                                                                                 |
      | address.latitude                              | null                                                                                                 |
      | address.longitude                             | null                                                                                                 |
      | attributes.attrs.header.ingestDateTime        | 2022-02-22T22:22:22.222Z                                                                             |
    And one Location record for "SNS-M-CONS-ADD" with following attributes
      | metadata.identityRecord.poleId.v2.id          | SNSENS:P={partyConsignee,221B Baker Street,NW1 6XE{testId},London}[SNS-M-CONSIGNEE],L={23ParisPA12 IS200} |
      | metadata.identityRecord.type                  | L                                                                                                         |
      | metadata.sourceRecord.name                    | SNSENS                                                                                                    |
      | metadata.sourceRecord.shortName               | SNS                                                                                                       |
      | metadata.sourceRecord.location                | submissionIdmetadata.messageIdentification                                                                |
      | metadata.sourceRecord.id                      | {23ParisPA12 IS200}                                                                                       |
      | metadata.sourceRecord.audit.createdBy         | 0123456789                                                                                                |
      | metadata.sourceRecord.audit.createdTimestamp  | 2022-02-22T22:22:22.222Z                                                                                  |
      | metadata.sourceRecord.audit.updatedBy         | null                                                                                                      |
      | metadata.sourceRecord.audit.updatedTimestamp  | null                                                                                                      |
      | metadata.sourceRecord.audit.deletedBy         | null                                                                                                      |
      | metadata.sourceRecord.audit.deletedTimestamp  | null                                                                                                      |
      | metadata.mappingRecord.name                   | SNS-M-CONS-ADD                                                                                            |
      | metadata.mappingRecord.version                | mappingVersion                                                                                            |
      | metadata.complianceRecord.visibility          | UNKNOWN                                                                                                   |
      | metadata.complianceRecord.gscMarker           | null                                                                                                      |
      | metadata.complianceRecord.retentionMarkerDays | -1                                                                                                        |
      | snapshotTrigger                               | null                                                                                                      |
      | startTimestamp                                | null                                                                                                      |
      | endTimestamp                                  | null                                                                                                      |
      | type                                          | ADDRESS                                                                                                   |
      | party.poleId.v2.id                            | SNSENS:P={partyConsignee,221B Baker Street,NW1 6XE{testId},London}[SNS-M-CONSIGNEE]                       |
      | party.type                                    | P                                                                                                         |
      | role                                          | PTOLCSIGNE                                                                                                |
      | address.type                                  | LOCADDR                                                                                                   |
      | address.postCode                              | PA12 IS                                                                                                   |
      | address.poBox                                 | null                                                                                                      |
      | address.fullAddress                           | partiesConsigneeName{testId} 23 Paris PA12 IS 200                                                         |
      | address.name                                  | partiesConsigneeName{testId}                                                                              |
      | address.siteLocation                          | null                                                                                                      |
      | address.number                                | null                                                                                                      |
      | address.street                                | 23                                                                                                        |
      | address.town                                  | Paris                                                                                                     |
      | address.area                                  | null                                                                                                      |
      | address.district                              | null                                                                                                      |
      | address.county                                | null                                                                                                      |
      | address.country                               | 200                                                                                                       |
      | address.uniquePropertyReferenceNumber         | null                                                                                                      |
      | address.latitude                              | null                                                                                                      |
      | address.longitude                             | null                                                                                                      |
      | attributes.attrs.header.ingestDateTime        | 2022-02-22T22:22:22.222Z                                                                                  |
    And one Location record for "SNS-M-NOTIFY-ADD" with following attributes
      | metadata.identityRecord.poleId.v2.id          | SNSENS:P={PartyNotify,10 Downing Street,W1 2EB{testId},London}[SNS-M-NOTIFY],L={56BristolBR00 6OL100} |
      | metadata.identityRecord.type                  | L                                                                                                     |
      | metadata.sourceRecord.name                    | SNSENS                                                                                                |
      | metadata.sourceRecord.shortName               | SNS                                                                                                   |
      | metadata.sourceRecord.location                | submissionIdmetadata.messageIdentification                                                            |
      | metadata.sourceRecord.id                      | {56BristolBR00 6OL100}                                                                                |
      | metadata.sourceRecord.audit.createdBy         | 0123456789                                                                                            |
      | metadata.sourceRecord.audit.createdTimestamp  | 2022-02-22T22:22:22.222Z                                                                              |
      | metadata.sourceRecord.audit.updatedBy         | null                                                                                                  |
      | metadata.sourceRecord.audit.updatedTimestamp  | null                                                                                                  |
      | metadata.sourceRecord.audit.deletedBy         | null                                                                                                  |
      | metadata.sourceRecord.audit.deletedTimestamp  | null                                                                                                  |
      | metadata.mappingRecord.name                   | SNS-M-NOTIFY-ADD                                                                                      |
      | metadata.mappingRecord.version                | mappingVersion                                                                                        |
      | metadata.complianceRecord.gscMarker           | null                                                                                                  |
      | metadata.complianceRecord.retentionMarkerDays | -1                                                                                                    |
      | snapshotTrigger                               | null                                                                                                  |
      | type                                          | ADDRESS                                                                                               |
      | startTimestamp                                | null                                                                                                  |
      | endTimestamp                                  | null                                                                                                  |
      | metadata.complianceRecord.visibility          | UNKNOWN                                                                                               |
      | party.poleId.v2.id                            | SNSENS:P={PartyNotify,10 Downing Street,W1 2EB{testId},London}[SNS-M-NOTIFY]                          |
      | party.type                                    | P                                                                                                     |
      | role                                          | PTOLASSO                                                                                              |
      | address.type                                  | LOCADDR                                                                                               |
      | address.postCode                              | BR00 6OL                                                                                              |
      | address.poBox                                 | null                                                                                                  |
      | address.fullAddress                           | partiesNotifyName{testId} 56 Bristol BR00 6OL 100                                                     |
      | address.name                                  | partiesNotifyName{testId}                                                                             |
      | address.siteLocation                          | null                                                                                                  |
      | address.number                                | null                                                                                                  |
      | address.street                                | 56                                                                                                    |
      | address.town                                  | Bristol                                                                                               |
      | address.area                                  | null                                                                                                  |
      | address.district                              | null                                                                                                  |
      | address.county                                | null                                                                                                  |
      | address.country                               | 100                                                                                                   |
      | address.uniquePropertyReferenceNumber         | null                                                                                                  |
      | address.latitude                              | null                                                                                                  |
      | address.longitude                             | null                                                                                                  |
      | attributes.attrs.header.ingestDateTime        | 2022-02-22T22:22:22.222Z                                                                              |
    And one Location record for "SNS-M-SHIP-ADD" with following attributes
      | metadata.identityRecord.poleId.v2.id          | SNSENS:P={PartyConsignor,12 Abbey Road,NW1 4AB{testId},London}[SNS-M-SHIPPER],L={90CardiffCA34 7FF100} |
      | metadata.identityRecord.type                  | L                                                                                                      |
      | metadata.sourceRecord.name                    | SNSENS                                                                                                 |
      | metadata.sourceRecord.shortName               | SNS                                                                                                    |
      | metadata.sourceRecord.location                | submissionIdmetadata.messageIdentification                                                             |
      | metadata.sourceRecord.id                      | {90CardiffCA34 7FF100}                                                                                 |
      | metadata.sourceRecord.audit.createdBy         | 0123456789                                                                                             |
      | metadata.sourceRecord.audit.createdTimestamp  | 2022-02-22T22:22:22.222Z                                                                               |
      | metadata.sourceRecord.audit.updatedBy         | null                                                                                                   |
      | metadata.sourceRecord.audit.updatedTimestamp  | null                                                                                                   |
      | metadata.sourceRecord.audit.deletedBy         | null                                                                                                   |
      | metadata.sourceRecord.audit.deletedTimestamp  | null                                                                                                   |
      | metadata.mappingRecord.name                   | SNS-M-SHIP-ADD                                                                                         |
      | metadata.mappingRecord.version                | mappingVersion                                                                                         |
      | metadata.complianceRecord.gscMarker           | null                                                                                                   |
      | metadata.complianceRecord.retentionMarkerDays | -1                                                                                                     |
      | snapshotTrigger                               | null                                                                                                   |
      | startTimestamp                                | null                                                                                                   |
      | endTimestamp                                  | null                                                                                                   |
      | metadata.complianceRecord.visibility          | UNKNOWN                                                                                                |
      | type                                          | ADDRESS                                                                                                |
      | party.poleId.v2.id                            | SNSENS:P={PartyConsignor,12 Abbey Road,NW1 4AB{testId},London}[SNS-M-SHIPPER]                          |
      | party.type                                    | P                                                                                                      |
      | role                                          | PTOLSHIP                                                                                               |
      | address.type                                  | LOCADDR                                                                                                |
      | address.postCode                              | CA34 7FF                                                                                               |
      | address.poBox                                 | null                                                                                                   |
      | address.fullAddress                           | partiesConsignorName{testId} 90 Cardiff CA34 7FF 100                                                   |
      | address.name                                  | partiesConsignorName{testId}                                                                           |
      | address.siteLocation                          | null                                                                                                   |
      | address.number                                | null                                                                                                   |
      | address.street                                | 90                                                                                                     |
      | address.town                                  | Cardiff                                                                                                |
      | address.area                                  | null                                                                                                   |
      | address.district                              | null                                                                                                   |
      | address.county                                | null                                                                                                   |
      | address.country                               | 100                                                                                                    |
      | address.uniquePropertyReferenceNumber         | null                                                                                                   |
      | address.latitude                              | null                                                                                                   |
      | address.longitude                             | null                                                                                                   |
      | attributes.attrs.header.ingestDateTime        | 2022-02-22T22:22:22.222Z                                                                               |
    And one Location record for "SNS-REP-ADD" with following attributes
      | metadata.identityRecord.poleId.v2.id          | SNSENS:P={Acme Co,7 Somewhere Street,NW1 5EX{testId},London}[SNS-REPRESENTATIVE],L={33LondonLN12 7ON100} |
      | metadata.identityRecord.type                  | L                                                                                                        |
      | metadata.sourceRecord.name                    | SNSENS                                                                                                   |
      | metadata.sourceRecord.shortName               | SNS                                                                                                      |
      | metadata.sourceRecord.location                | submissionIdmetadata.messageIdentification                                                               |
      | metadata.sourceRecord.id                      | {33LondonLN12 7ON100}                                                                                    |
      | metadata.sourceRecord.audit.createdBy         | 0123456789                                                                                               |
      | metadata.sourceRecord.audit.createdTimestamp  | 2022-02-22T22:22:22.222Z                                                                                 |
      | metadata.sourceRecord.audit.updatedBy         | null                                                                                                     |
      | metadata.sourceRecord.audit.updatedTimestamp  | null                                                                                                     |
      | metadata.sourceRecord.audit.deletedBy         | null                                                                                                     |
      | metadata.sourceRecord.audit.deletedTimestamp  | null                                                                                                     |
      | metadata.mappingRecord.name                   | SNS-REP-ADD                                                                                              |
      | metadata.mappingRecord.version                | mappingVersion                                                                                           |
      | metadata.complianceRecord.visibility          | UNKNOWN                                                                                                  |
      | metadata.complianceRecord.gscMarker           | null                                                                                                     |
      | metadata.complianceRecord.retentionMarkerDays | -1                                                                                                       |
      | snapshotTrigger                               | null                                                                                                     |
      | startTimestamp                                | null                                                                                                     |
      | endTimestamp                                  | null                                                                                                     |
      | type                                          | ADDRESS                                                                                                  |
      | party.poleId.v2.id                            | SNSENS:P={Acme Co,7 Somewhere Street,NW1 5EX{testId},London}[SNS-REPRESENTATIVE]                         |
      | party.type                                    | P                                                                                                        |
      | role                                          | PTOLASSO                                                                                                 |
      | address.type                                  | LOCADDR                                                                                                  |
      | address.postCode                              | LN12 7ON                                                                                                 |
      | address.poBox                                 | null                                                                                                     |
      | address.fullAddress                           | representativeName{testId} 33 London LN12 7ON 100                                                        |
      | address.name                                  | representativeName{testId}                                                                               |
      | address.siteLocation                          | null                                                                                                     |
      | address.number                                | null                                                                                                     |
      | address.street                                | 33                                                                                                       |
      | address.town                                  | London                                                                                                   |
      | address.area                                  | null                                                                                                     |
      | address.district                              | null                                                                                                     |
      | address.county                                | null                                                                                                     |
      | address.country                               | 100                                                                                                      |
      | address.uniquePropertyReferenceNumber         | null                                                                                                     |
      | address.latitude                              | null                                                                                                     |
      | address.longitude                             | null                                                                                                     |
      | attributes.attrs.header.ingestDateTime        | 2022-02-22T22:22:22.222Z                                                                                 |
    And one Location record for "SNS-SENDER-ADD" with following attributes
      | metadata.identityRecord.poleId.v2.id          | SNSENS:P={Testing,5 Test Street,TE5 1IN{testId},Testville}[SNS-SENDER],L={5 Test Street-TE5 1IN{testId}-Testville} |
      | metadata.identityRecord.type                  | L                                                                                                                  |
      | metadata.sourceRecord.name                    | SNSENS                                                                                                             |
      | metadata.sourceRecord.shortName               | SNS                                                                                                                |
      | metadata.sourceRecord.location                | submissionIdmetadata.messageIdentification                                                                         |
      | metadata.sourceRecord.id                      | {5 Test Street-TE5 1IN{testId}-Testville}                                                                          |
      | metadata.sourceRecord.audit.createdBy         | 0123456789                                                                                                         |
      | metadata.sourceRecord.audit.createdTimestamp  | 2022-02-22T22:22:22.222Z                                                                                           |
      | metadata.mappingRecord.name                   | SNS-SENDER-ADD                                                                                                     |
      | metadata.mappingRecord.version                | mappingVersion                                                                                                     |
      | metadata.complianceRecord.visibility          | UNKNOWN                                                                                                            |
      | metadata.complianceRecord.gscMarker           | null                                                                                                               |
      | metadata.complianceRecord.retentionMarkerDays | -1                                                                                                                 |
      | snapshotTrigger                               | null                                                                                                               |
      | type                                          | ADDRESS                                                                                                            |
      | party.poleId.v2.id                            | SNSENS:P={Testing,5 Test Street,TE5 1IN{testId},Testville}[SNS-SENDER]                                             |
      | party.type                                    | P                                                                                                                  |
      | role                                          | PTOLASSO                                                                                                           |
      | startTimestamp                                | null                                                                                                               |
      | endTimestamp                                  | null                                                                                                               |
      | address.type                                  | LOCADDR                                                                                                            |
      | address.postCode                              | TE5 1IN{testId}                                                                                                    |
      | address.poBox                                 | null                                                                                                               |
      | address.fullAddress                           | 5 Test Street-TE5 1IN{testId}-Testville                                                                            |
      | address.name                                  | Testing                                                                                                            |
      | address.siteLocation                          | null                                                                                                               |
      | address.number                                | null                                                                                                               |
      | address.street                                | 5 Test Street                                                                                                      |
      | address.town                                  | Testville                                                                                                          |
      | address.area                                  | null                                                                                                               |
      | address.district                              | null                                                                                                               |
      | address.country                               | null                                                                                                               |
      | address.county                                | null                                                                                                               |
      | address.uniquePropertyReferenceNumber         | null                                                                                                               |
      | address.latitude                              | null                                                                                                               |
      | address.longitude                             | null                                                                                                               |
      | attributes.attrs.header.ingestDateTime        | 2022-02-22T22:22:22.222Z                                                                                           |
    And one Location record for "SNS-M-CARRIER-ADD" with following attributes
      | metadata.identityRecord.poleId.v2.id          | SNSENS:P={partiesCarrier,62 Golden Street,MK1 3RW{testId},Milton Keynes}[SNS-M-CARRIER],L={Farm closeLondonHa5 1hy100} |
      | metadata.identityRecord.type                  | L                                                                                                                      |
      | metadata.sourceRecord.name                    | SNSENS                                                                                                                 |
      | metadata.sourceRecord.shortName               | SNS                                                                                                                    |
      | metadata.sourceRecord.location                | submissionIdmetadata.messageIdentification                                                                             |
      | metadata.sourceRecord.id                      | {Farm closeLondonHa5 1hy100}                                                                                           |
      | metadata.sourceRecord.audit.createdBy         | 0123456789                                                                                                             |
      | metadata.sourceRecord.audit.createdTimestamp  | 2022-02-22T22:22:22.222Z                                                                                               |
      | metadata.mappingRecord.name                   | SNS-M-CARRIER-ADD                                                                                                      |
      | metadata.mappingRecord.version                | mappingVersion                                                                                                         |
      | metadata.complianceRecord.visibility          | UNKNOWN                                                                                                                |
      | metadata.complianceRecord.gscMarker           | null                                                                                                                   |
      | metadata.complianceRecord.retentionMarkerDays | -1                                                                                                                     |
      | snapshotTrigger                               | null                                                                                                                   |
      | type                                          | ADDRESS                                                                                                                |
      | party.poleId.v2.id                            | SNSENS:P={partiesCarrier,62 Golden Street,MK1 3RW{testId},Milton Keynes}[SNS-M-CARRIER]                                |
      | party.type                                    | P                                                                                                                      |
      | role                                          | PTOLASSO                                                                                                               |
      | startTimestamp                                | null                                                                                                                   |
      | endTimestamp                                  | null                                                                                                                   |
      | address.type                                  | LOCADDR                                                                                                                |
      | address.postCode                              | Ha5 1hy                                                                                                                |
      | address.poBox                                 | null                                                                                                                   |
      | address.fullAddress                           | Bob{testId} Farm close London Ha5 1hy 100                                                                              |
      | address.name                                  | Bob{testId}                                                                                                            |
      | address.siteLocation                          | null                                                                                                                   |
      | address.number                                | null                                                                                                                   |
      | address.street                                | Farm close                                                                                                             |
      | address.town                                  | London                                                                                                                 |
      | address.area                                  | null                                                                                                                   |
      | address.district                              | null                                                                                                                   |
      | address.country                               | 100                                                                                                                    |
      | address.county                                | null                                                                                                                   |
      | address.uniquePropertyReferenceNumber         | null                                                                                                                   |
      | address.latitude                              | null                                                                                                                   |
      | address.longitude                             | null                                                                                                                   |
      | attributes.attrs.header.ingestDateTime        | 2022-02-22T22:22:22.222Z                                                                                               |

  Scenario: LocationRecords are emitted when EORI lookup key is present and name is null
    Given template StreamIngestRecord with the base file "sns-multiple-only-eori.input"
    And template EoriCdlzLandingRecord with the base file "eori.input"
    When Eori CDLZ data is presented as per the template to the landing topic landing-413
    When Readiness health check is completed
    And StreamIngestRecord source data is presented with attributes as per the template to the input topic with prefix fdp-sns-input
#   body.goods.goodsItems.2.consignor.eori is set to null
    Then 15 Location SNAPSHOTS will be emitted

  Scenario: LocationRecord is not emitted when EORI lookup key is missing and name is null
    Given template StreamIngestRecord with the base file "sns-multiple-missing-eori.input"
    And template EoriCdlzLandingRecord with the base file "eori.input"
    When Eori CDLZ data is presented as per the template to the landing topic landing-413
    When Readiness health check is completed
    And StreamIngestRecord source data is presented with attributes as per the template to the input topic with prefix fdp-sns-input
#  "SNS-SENDER" is always emitted because body.metadata.senderEORI cannot be null.
    Then 1 Location SNAPSHOTS will be emitted