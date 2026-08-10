@E2EEvent-roro-unacc
Feature: Test SNS Command Adaptor -　Event RoRo Unaccompanied - end to end

  Scenario: EventRecord RoRo Unaccompanied
    Given template StreamIngestRecord with the base file "roro-unacc.input"
    And template EoriCdlzLandingRecord with the base file "eori.input"
    When Eori CDLZ data is presented as per the template to the landing topic landing-413
    When Readiness health check is completed
    And StreamIngestRecord source data is presented with attributes as per the template to the input topic with prefix fdp-sns-input
    Then 38 Event SNAPSHOTS will be emitted
    And one Event record for "SNS-ASSOC-CCon2Cons" with following attributes
      | metadata.identityRecord.poleId.v2.id          | SNSENS:E={[SNSENS:P={partyCConsignee0,Castlehill,EH1 2NG{testId},Edinburgh}[SNS-C-CONSIGNEE]][SNSENS:S={mrn{testId}789}][PTOSCSIGNE]} |
      | metadata.identityRecord.type                  | E                                                                                                                                     |
      | metadata.sourceRecord.name                    | SNSENS                                                                                                                                |
      | metadata.sourceRecord.shortName               | SNS                                                                                                                                   |
      | metadata.sourceRecord.location                | submissionIdmetadata.messageIdentification                                                                                            |
      | metadata.sourceRecord.id                      | {[SNSENS:P={partyCConsignee0,Castlehill,EH1 2NG{testId},Edinburgh}[SNS-C-CONSIGNEE]][SNSENS:S={mrn{testId}789}][PTOSCSIGNE]}          |
      | metadata.sourceRecord.audit.createdBy         | 0123456789                                                                                                                            |
      | metadata.sourceRecord.audit.createdTimestamp  | 2022-02-22T22:22:22.222Z                                                                                                              |
      | metadata.mappingRecord.name                   | SNS-ASSOC-CCon2Cons                                                                                                                   |
      | metadata.mappingRecord.version                | mappingVersion                                                                                                                        |
      | metadata.complianceRecord.visibility          | UNKNOWN                                                                                                                               |
      | metadata.complianceRecord.gscMarker           | null                                                                                                                                  |
      | metadata.complianceRecord.retentionMarkerDays | -1                                                                                                                                    |
      | snapshotTrigger                               | null                                                                                                                                  |
      | type                                          | ASSOCIATION_START                                                                                                                     |
      | subject.poleId.v2.id                          | SNSENS:P={partyCConsignee0,Castlehill,EH1 2NG{testId},Edinburgh}[SNS-C-CONSIGNEE]                                                     |
      | subject.type                                  | P                                                                                                                                     |
      | associationStart.type                         | PTOSCSIGNE                                                                                                                            |
      | associationStart.target.poleId.v2.id          | SNSENS:S={mrn{testId}789}                                                                                                             |
      | associationStart.target.type                  | S                                                                                                                                     |
      | associationStart.timestamp                    | 2022-02-22T22:22:22.222Z                                                                                                              |
      | attributes.attrs.header.ingestDateTime        | 2022-02-22T22:22:22.222Z                                                                                                              |
    And one Event record for "SNS-ASSOC-CCon2Cons" with following attributes
      | metadata.identityRecord.poleId.v2.id          | SNSENS:E={[SNSENS:P={partyCConsignee1,Woodstock,OX20 1PP{testId},Oxfordshire}[SNS-C-CONSIGNEE]][SNSENS:S={mrn{testId}789}][PTOSCSIGNE]} |
      | metadata.identityRecord.type                  | E                                                                                                                                       |
      | metadata.sourceRecord.name                    | SNSENS                                                                                                                                  |
      | metadata.sourceRecord.shortName               | SNS                                                                                                                                     |
      | metadata.sourceRecord.location                | submissionIdmetadata.messageIdentification                                                                                              |
      | metadata.sourceRecord.id                      | {[SNSENS:P={partyCConsignee1,Woodstock,OX20 1PP{testId},Oxfordshire}[SNS-C-CONSIGNEE]][SNSENS:S={mrn{testId}789}][PTOSCSIGNE]}          |
      | metadata.sourceRecord.audit.createdBy         | 0123456789                                                                                                                              |
      | metadata.sourceRecord.audit.createdTimestamp  | 2022-02-22T22:22:22.222Z                                                                                                                |
      | metadata.mappingRecord.name                   | SNS-ASSOC-CCon2Cons                                                                                                                     |
      | metadata.mappingRecord.version                | mappingVersion                                                                                                                          |
      | metadata.complianceRecord.visibility          | UNKNOWN                                                                                                                                 |
      | metadata.complianceRecord.gscMarker           | null                                                                                                                                    |
      | metadata.complianceRecord.retentionMarkerDays | -1                                                                                                                                      |
      | snapshotTrigger                               | null                                                                                                                                    |
      | type                                          | ASSOCIATION_START                                                                                                                       |
      | subject.poleId.v2.id                          | SNSENS:P={partyCConsignee1,Woodstock,OX20 1PP{testId},Oxfordshire}[SNS-C-CONSIGNEE]                                                     |
      | subject.type                                  | P                                                                                                                                       |
      | associationStart.type                         | PTOSCSIGNE                                                                                                                              |
      | associationStart.target.poleId.v2.id          | SNSENS:S={mrn{testId}789}                                                                                                               |
      | associationStart.target.type                  | S                                                                                                                                       |
      | associationStart.timestamp                    | 2022-02-22T22:22:22.222Z                                                                                                                |
      | attributes.attrs.header.ingestDateTime        | 2022-02-22T22:22:22.222Z                                                                                                                |
    And one Event record for "SNS-ASSOC-CNot2Cons" with following attributes
      | metadata.identityRecord.poleId.v2.id          | SNSENS:E={[SNSENS:P={partyCNotify0,Great Russell Street,WC1B 3DG{testId},London}[SNS-C-NOTIFY]][SNSENS:S={mrn{testId}789}][PTOS]} |
      | metadata.identityRecord.type                  | E                                                                                                                                 |
      | metadata.sourceRecord.name                    | SNSENS                                                                                                                            |
      | metadata.sourceRecord.shortName               | SNS                                                                                                                               |
      | metadata.sourceRecord.location                | submissionIdmetadata.messageIdentification                                                                                        |
      | metadata.sourceRecord.id                      | {[SNSENS:P={partyCNotify0,Great Russell Street,WC1B 3DG{testId},London}[SNS-C-NOTIFY]][SNSENS:S={mrn{testId}789}][PTOS]}          |
      | metadata.sourceRecord.audit.createdBy         | 0123456789                                                                                                                        |
      | metadata.sourceRecord.audit.createdTimestamp  | 2022-02-22T22:22:22.222Z                                                                                                          |
      | metadata.mappingRecord.name                   | SNS-ASSOC-CNot2Cons                                                                                                               |
      | metadata.mappingRecord.version                | mappingVersion                                                                                                                    |
      | metadata.complianceRecord.visibility          | UNKNOWN                                                                                                                           |
      | metadata.complianceRecord.gscMarker           | null                                                                                                                              |
      | metadata.complianceRecord.retentionMarkerDays | -1                                                                                                                                |
      | snapshotTrigger                               | null                                                                                                                              |
      | type                                          | ASSOCIATION_START                                                                                                                 |
      | subject.poleId.v2.id                          | SNSENS:P={partyCNotify0,Great Russell Street,WC1B 3DG{testId},London}[SNS-C-NOTIFY]                                               |
      | subject.type                                  | P                                                                                                                                 |
      | associationStart.type                         | PTOS                                                                                                                              |
      | associationStart.target.poleId.v2.id          | SNSENS:S={mrn{testId}789}                                                                                                         |
      | associationStart.target.type                  | S                                                                                                                                 |
      | associationStart.timestamp                    | 2022-02-22T22:22:22.222Z                                                                                                          |
      | attributes.attrs.header.ingestDateTime        | 2022-02-22T22:22:22.222Z                                                                                                          |
    And one Event record for "SNS-ASSOC-CNot2Cons" with following attributes
      | metadata.identityRecord.poleId.v2.id          | SNSENS:E={[SNSENS:P={partyCNotify1,St Katharine,EC3N 4AB{testId},London}[SNS-C-NOTIFY]][SNSENS:S={mrn{testId}789}][PTOS]} |
      | metadata.identityRecord.type                  | E                                                                                                                         |
      | metadata.sourceRecord.name                    | SNSENS                                                                                                                    |
      | metadata.sourceRecord.shortName               | SNS                                                                                                                       |
      | metadata.sourceRecord.location                | submissionIdmetadata.messageIdentification                                                                                |
      | metadata.sourceRecord.id                      | {[SNSENS:P={partyCNotify1,St Katharine,EC3N 4AB{testId},London}[SNS-C-NOTIFY]][SNSENS:S={mrn{testId}789}][PTOS]}          |
      | metadata.sourceRecord.audit.createdBy         | 0123456789                                                                                                                |
      | metadata.sourceRecord.audit.createdTimestamp  | 2022-02-22T22:22:22.222Z                                                                                                  |
      | metadata.mappingRecord.name                   | SNS-ASSOC-CNot2Cons                                                                                                       |
      | metadata.mappingRecord.version                | mappingVersion                                                                                                            |
      | metadata.complianceRecord.visibility          | UNKNOWN                                                                                                                   |
      | metadata.complianceRecord.gscMarker           | null                                                                                                                      |
      | metadata.complianceRecord.retentionMarkerDays | -1                                                                                                                        |
      | snapshotTrigger                               | null                                                                                                                      |
      | type                                          | ASSOCIATION_START                                                                                                         |
      | subject.poleId.v2.id                          | SNSENS:P={partyCNotify1,St Katharine,EC3N 4AB{testId},London}[SNS-C-NOTIFY]                                               |
      | subject.type                                  | P                                                                                                                         |
      | associationStart.type                         | PTOS                                                                                                                      |
      | associationStart.target.poleId.v2.id          | SNSENS:S={mrn{testId}789}                                                                                                 |
      | associationStart.target.type                  | S                                                                                                                         |
      | associationStart.timestamp                    | 2022-02-22T22:22:22.222Z                                                                                                  |
      | attributes.attrs.header.ingestDateTime        | 2022-02-22T22:22:22.222Z                                                                                                  |
    And one Event record for "SNS-ASSOC-CShi2Cons" with following attributes
      | metadata.identityRecord.poleId.v2.id          | SNSENS:E={[SNSENS:P={goodsConsignorName{testId}11BirminghamBH1 2AM100}[SNS-C-SHIPPER]][SNSENS:S={mrn{testId}789}][PTOSSHIP]} |
      | metadata.identityRecord.type                  | E                                                                                                                            |
      | metadata.sourceRecord.name                    | SNSENS                                                                                                                       |
      | metadata.sourceRecord.shortName               | SNS                                                                                                                          |
      | metadata.sourceRecord.location                | submissionIdmetadata.messageIdentification                                                                                   |
      | metadata.sourceRecord.id                      | {[SNSENS:P={goodsConsignorName{testId}11BirminghamBH1 2AM100}[SNS-C-SHIPPER]][SNSENS:S={mrn{testId}789}][PTOSSHIP]}          |
      | metadata.sourceRecord.audit.createdBy         | 0123456789                                                                                                                   |
      | metadata.sourceRecord.audit.createdTimestamp  | 2022-02-22T22:22:22.222Z                                                                                                     |
      | metadata.mappingRecord.name                   | SNS-ASSOC-CShi2Cons                                                                                                          |
      | metadata.mappingRecord.version                | mappingVersion                                                                                                               |
      | metadata.complianceRecord.visibility          | UNKNOWN                                                                                                                      |
      | metadata.complianceRecord.gscMarker           | null                                                                                                                         |
      | metadata.complianceRecord.retentionMarkerDays | -1                                                                                                                           |
      | snapshotTrigger                               | null                                                                                                                         |
      | type                                          | ASSOCIATION_START                                                                                                            |
      | subject.poleId.v2.id                          | SNSENS:P={goodsConsignorName{testId}11BirminghamBH1 2AM100}[SNS-C-SHIPPER]                                                   |
      | subject.type                                  | P                                                                                                                            |
      | associationStart.type                         | PTOSSHIP                                                                                                                     |
      | associationStart.target.poleId.v2.id          | SNSENS:S={mrn{testId}789}                                                                                                    |
      | associationStart.target.type                  | S                                                                                                                            |
      | associationStart.timestamp                    | 2022-02-22T22:22:22.222Z                                                                                                     |
      | attributes.attrs.header.ingestDateTime        | 2022-02-22T22:22:22.222Z                                                                                                     |
    And one Event record for "SNS-ASSOC-CShi2Cons" with following attributes
      | metadata.identityRecord.poleId.v2.id          | SNSENS:E={[SNSENS:P={goodsConsignor,12 Abbey Road,NW1 4AB{testId},London}[SNS-C-SHIPPER]][SNSENS:S={mrn{testId}789}][PTOSSHIP]} |
      | metadata.identityRecord.type                  | E                                                                                                                               |
      | metadata.sourceRecord.name                    | SNSENS                                                                                                                          |
      | metadata.sourceRecord.shortName               | SNS                                                                                                                             |
      | metadata.sourceRecord.location                | submissionIdmetadata.messageIdentification                                                                                      |
      | metadata.sourceRecord.id                      | {[SNSENS:P={goodsConsignor,12 Abbey Road,NW1 4AB{testId},London}[SNS-C-SHIPPER]][SNSENS:S={mrn{testId}789}][PTOSSHIP]}          |
      | metadata.sourceRecord.audit.createdBy         | 0123456789                                                                                                                      |
      | metadata.sourceRecord.audit.createdTimestamp  | 2022-02-22T22:22:22.222Z                                                                                                        |
      | metadata.mappingRecord.name                   | SNS-ASSOC-CShi2Cons                                                                                                             |
      | metadata.mappingRecord.version                | mappingVersion                                                                                                                  |
      | metadata.complianceRecord.visibility          | UNKNOWN                                                                                                                         |
      | metadata.complianceRecord.gscMarker           | null                                                                                                                            |
      | metadata.complianceRecord.retentionMarkerDays | -1                                                                                                                              |
      | snapshotTrigger                               | null                                                                                                                            |
      | type                                          | ASSOCIATION_START                                                                                                               |
      | subject.poleId.v2.id                          | SNSENS:P={goodsConsignor,12 Abbey Road,NW1 4AB{testId},London}[SNS-C-SHIPPER]                                                   |
      | subject.type                                  | P                                                                                                                               |
      | associationStart.type                         | PTOSSHIP                                                                                                                        |
      | associationStart.target.poleId.v2.id          | SNSENS:S={mrn{testId}789}                                                                                                       |
      | associationStart.target.type                  | S                                                                                                                               |
      | associationStart.timestamp                    | 2022-02-22T22:22:22.222Z                                                                                                        |
      | attributes.attrs.header.ingestDateTime        | 2022-02-22T22:22:22.222Z                                                                                                        |
    And one Event record for "SNS-ASSOC-Dec2Cons" with following attributes
      | metadata.identityRecord.poleId.v2.id          | SNSENS:E={[SNSENS:P={partyDeclarant,1 Savoy Hill,WC2R 0BP{testId},London}[SNS-DECLARANT]][SNSENS:S={mrn{testId}789}][PTOS]} |
      | metadata.identityRecord.type                  | E                                                                                                                           |
      | metadata.sourceRecord.name                    | SNSENS                                                                                                                      |
      | metadata.sourceRecord.shortName               | SNS                                                                                                                         |
      | metadata.sourceRecord.location                | submissionIdmetadata.messageIdentification                                                                                  |
      | metadata.sourceRecord.id                      | {[SNSENS:P={partyDeclarant,1 Savoy Hill,WC2R 0BP{testId},London}[SNS-DECLARANT]][SNSENS:S={mrn{testId}789}][PTOS]}          |
      | metadata.sourceRecord.audit.createdBy         | 0123456789                                                                                                                  |
      | metadata.sourceRecord.audit.createdTimestamp  | 2022-02-22T22:22:22.222Z                                                                                                    |
      | metadata.mappingRecord.name                   | SNS-ASSOC-Dec2Cons                                                                                                          |
      | metadata.mappingRecord.version                | mappingVersion                                                                                                              |
      | metadata.complianceRecord.visibility          | UNKNOWN                                                                                                                     |
      | metadata.complianceRecord.gscMarker           | null                                                                                                                        |
      | metadata.complianceRecord.retentionMarkerDays | -1                                                                                                                          |
      | snapshotTrigger                               | null                                                                                                                        |
      | type                                          | ASSOCIATION_START                                                                                                           |
      | subject.poleId.v2.id                          | SNSENS:P={partyDeclarant,1 Savoy Hill,WC2R 0BP{testId},London}[SNS-DECLARANT]                                               |
      | subject.type                                  | P                                                                                                                           |
      | associationStart.type                         | PTOS                                                                                                                        |
      | associationStart.target.poleId.v2.id          | SNSENS:S={mrn{testId}789}                                                                                                   |
      | associationStart.target.type                  | S                                                                                                                           |
      | associationStart.timestamp                    | 2022-02-22T22:22:22.222Z                                                                                                    |
      | attributes.attrs.header.ingestDateTime        | 2022-02-22T22:22:22.222Z                                                                                                    |
    And one Event record for "SNS-ASSOC-MCar2Cons" with following attributes
      | metadata.identityRecord.poleId.v2.id          | SNSENS:E={[SNSENS:P={Bob{testId}Farm closeLondonHa5 1hy100}[SNS-M-CARRIER]][SNSENS:S={mrn{testId}789}][PTOS]} |
      | metadata.identityRecord.type                  | E                                                                                                             |
      | metadata.sourceRecord.name                    | SNSENS                                                                                                        |
      | metadata.sourceRecord.shortName               | SNS                                                                                                           |
      | metadata.sourceRecord.location                | submissionIdmetadata.messageIdentification                                                                    |
      | metadata.sourceRecord.id                      | {[SNSENS:P={Bob{testId}Farm closeLondonHa5 1hy100}[SNS-M-CARRIER]][SNSENS:S={mrn{testId}789}][PTOS]}          |
      | metadata.sourceRecord.audit.createdBy         | 0123456789                                                                                                    |
      | metadata.sourceRecord.audit.createdTimestamp  | 2022-02-22T22:22:22.222Z                                                                                      |
      | metadata.mappingRecord.name                   | SNS-ASSOC-MCar2Cons                                                                                           |
      | metadata.mappingRecord.version                | mappingVersion                                                                                                |
      | metadata.complianceRecord.visibility          | UNKNOWN                                                                                                       |
      | metadata.complianceRecord.gscMarker           | null                                                                                                          |
      | metadata.complianceRecord.retentionMarkerDays | -1                                                                                                            |
      | snapshotTrigger                               | null                                                                                                          |
      | type                                          | ASSOCIATION_START                                                                                             |
      | subject.poleId.v2.id                          | SNSENS:P={Bob{testId}Farm closeLondonHa5 1hy100}[SNS-M-CARRIER]                                               |
      | subject.type                                  | P                                                                                                             |
      | associationStart.type                         | PTOS                                                                                                          |
      | associationStart.target.poleId.v2.id          | SNSENS:S={mrn{testId}789}                                                                                     |
      | associationStart.target.type                  | S                                                                                                             |
      | associationStart.timestamp                    | 2022-02-22T22:22:22.222Z                                                                                      |
      | attributes.attrs.header.ingestDateTime        | 2022-02-22T22:22:22.222Z                                                                                      |
    And one Event record for "SNS-ASSOC-MCon2Cons" with following attributes
      | metadata.identityRecord.poleId.v2.id          | SNSENS:E={[SNSENS:P={partyConsignee,221B Baker Street,NW1 6XE{testId},London}[SNS-M-CONSIGNEE]][SNSENS:S={mrn{testId}789}][PTOSCSIGNE]} |
      | metadata.identityRecord.type                  | E                                                                                                                                       |
      | metadata.sourceRecord.name                    | SNSENS                                                                                                                                  |
      | metadata.sourceRecord.shortName               | SNS                                                                                                                                     |
      | metadata.sourceRecord.location                | submissionIdmetadata.messageIdentification                                                                                              |
      | metadata.sourceRecord.id                      | {[SNSENS:P={partyConsignee,221B Baker Street,NW1 6XE{testId},London}[SNS-M-CONSIGNEE]][SNSENS:S={mrn{testId}789}][PTOSCSIGNE]}          |
      | metadata.sourceRecord.audit.createdBy         | 0123456789                                                                                                                              |
      | metadata.sourceRecord.audit.createdTimestamp  | 2022-02-22T22:22:22.222Z                                                                                                                |
      | metadata.mappingRecord.name                   | SNS-ASSOC-MCon2Cons                                                                                                                     |
      | metadata.mappingRecord.version                | mappingVersion                                                                                                                          |
      | metadata.complianceRecord.visibility          | UNKNOWN                                                                                                                                 |
      | metadata.complianceRecord.gscMarker           | null                                                                                                                                    |
      | metadata.complianceRecord.retentionMarkerDays | -1                                                                                                                                      |
      | snapshotTrigger                               | null                                                                                                                                    |
      | type                                          | ASSOCIATION_START                                                                                                                       |
      | subject.poleId.v2.id                          | SNSENS:P={partyConsignee,221B Baker Street,NW1 6XE{testId},London}[SNS-M-CONSIGNEE]                                                     |
      | subject.type                                  | P                                                                                                                                       |
      | associationStart.type                         | PTOSCSIGNE                                                                                                                              |
      | associationStart.target.poleId.v2.id          | SNSENS:S={mrn{testId}789}                                                                                                               |
      | associationStart.target.type                  | S                                                                                                                                       |
      | associationStart.timestamp                    | 2022-02-22T22:22:22.222Z                                                                                                                |
      | attributes.attrs.header.ingestDateTime        | 2022-02-22T22:22:22.222Z                                                                                                                |
    And one Event record for "SNS-ASSOC-MNot2Cons" with following attributes
      | metadata.identityRecord.poleId.v2.id          | SNSENS:E={[SNSENS:P={PartyNotify,10 Downing Street,W1 2EB{testId},London}[SNS-M-NOTIFY]][SNSENS:S={mrn{testId}789}][PTOS]} |
      | metadata.identityRecord.type                  | E                                                                                                                          |
      | metadata.sourceRecord.name                    | SNSENS                                                                                                                     |
      | metadata.sourceRecord.shortName               | SNS                                                                                                                        |
      | metadata.sourceRecord.location                | submissionIdmetadata.messageIdentification                                                                                 |
      | metadata.sourceRecord.id                      | {[SNSENS:P={PartyNotify,10 Downing Street,W1 2EB{testId},London}[SNS-M-NOTIFY]][SNSENS:S={mrn{testId}789}][PTOS]}          |
      | metadata.sourceRecord.audit.createdBy         | 0123456789                                                                                                                 |
      | metadata.sourceRecord.audit.createdTimestamp  | 2022-02-22T22:22:22.222Z                                                                                                   |
      | metadata.mappingRecord.name                   | SNS-ASSOC-MNot2Cons                                                                                                        |
      | metadata.mappingRecord.version                | mappingVersion                                                                                                             |
      | metadata.complianceRecord.visibility          | UNKNOWN                                                                                                                    |
      | metadata.complianceRecord.gscMarker           | null                                                                                                                       |
      | metadata.complianceRecord.retentionMarkerDays | -1                                                                                                                         |
      | snapshotTrigger                               | null                                                                                                                       |
      | type                                          | ASSOCIATION_START                                                                                                          |
      | subject.poleId.v2.id                          | SNSENS:P={PartyNotify,10 Downing Street,W1 2EB{testId},London}[SNS-M-NOTIFY]                                               |
      | subject.type                                  | P                                                                                                                          |
      | associationStart.type                         | PTOS                                                                                                                       |
      | associationStart.target.poleId.v2.id          | SNSENS:S={mrn{testId}789}                                                                                                  |
      | associationStart.target.type                  | S                                                                                                                          |
      | associationStart.timestamp                    | 2022-02-22T22:22:22.222Z                                                                                                   |
      | attributes.attrs.header.ingestDateTime        | 2022-02-22T22:22:22.222Z                                                                                                   |

    And one Event record for "SNS-ASSOC-Mov2Cons" with following attributes
      | metadata.identityRecord.poleId.v2.id          | SNSENS:E={[SNSENS:S={mrn{testId}}][SNSENS:S={mrn{testId}789}][STOS]} |
      | metadata.identityRecord.type                  | E                                                                    |
      | metadata.sourceRecord.name                    | SNSENS                                                               |
      | metadata.sourceRecord.shortName               | SNS                                                                  |
      | metadata.sourceRecord.location                | submissionIdmetadata.messageIdentification                           |
      | metadata.sourceRecord.id                      | {[SNSENS:S={mrn{testId}}][SNSENS:S={mrn{testId}789}][STOS]}          |
      | metadata.sourceRecord.audit.createdBy         | 0123456789                                                           |
      | metadata.sourceRecord.audit.createdTimestamp  | 2022-02-22T22:22:22.222Z                                             |
      | metadata.mappingRecord.name                   | SNS-ASSOC-Mov2Cons                                                   |
      | metadata.mappingRecord.version                | mappingVersion                                                       |
      | metadata.complianceRecord.visibility          | UNKNOWN                                                              |
      | metadata.complianceRecord.gscMarker           | null                                                                 |
      | metadata.complianceRecord.retentionMarkerDays | -1                                                                   |
      | snapshotTrigger                               | null                                                                 |
      | type                                          | ASSOCIATION_START                                                    |
      | subject.poleId.v2.id                          | SNSENS:S={mrn{testId}}                                               |
      | subject.type                                  | S                                                                    |
      | associationStart.type                         | STOS                                                                 |
      | associationStart.target.poleId.v2.id          | SNSENS:S={mrn{testId}789}                                            |
      | associationStart.target.type                  | S                                                                    |
      | associationStart.timestamp                    | 2022-02-22T22:22:22.222Z                                             |
      | attributes.attrs.header.ingestDateTime        | 2022-02-22T22:22:22.222Z                                             |
    And one Event record for "SNS-ASSOC-MShi2Cons" with following attributes
      | metadata.identityRecord.poleId.v2.id          | SNSENS:E={[SNSENS:P={PartyConsignor,12 Abbey Road,NW1 4AB{testId},London}[SNS-M-SHIPPER]][SNSENS:S={mrn{testId}789}][PTOSSHIP]} |
      | metadata.identityRecord.type                  | E                                                                                                                               |
      | metadata.sourceRecord.name                    | SNSENS                                                                                                                          |
      | metadata.sourceRecord.shortName               | SNS                                                                                                                             |
      | metadata.sourceRecord.location                | submissionIdmetadata.messageIdentification                                                                                      |
      | metadata.sourceRecord.id                      | {[SNSENS:P={PartyConsignor,12 Abbey Road,NW1 4AB{testId},London}[SNS-M-SHIPPER]][SNSENS:S={mrn{testId}789}][PTOSSHIP]}          |
      | metadata.sourceRecord.audit.createdBy         | 0123456789                                                                                                                      |
      | metadata.sourceRecord.audit.createdTimestamp  | 2022-02-22T22:22:22.222Z                                                                                                        |
      | metadata.mappingRecord.name                   | SNS-ASSOC-MShi2Cons                                                                                                             |
      | metadata.mappingRecord.version                | mappingVersion                                                                                                                  |
      | metadata.complianceRecord.visibility          | UNKNOWN                                                                                                                         |
      | metadata.complianceRecord.gscMarker           | null                                                                                                                            |
      | metadata.complianceRecord.retentionMarkerDays | -1                                                                                                                              |
      | snapshotTrigger                               | null                                                                                                                            |
      | type                                          | ASSOCIATION_START                                                                                                               |
      | subject.poleId.v2.id                          | SNSENS:P={PartyConsignor,12 Abbey Road,NW1 4AB{testId},London}[SNS-M-SHIPPER]                                                   |
      | subject.type                                  | P                                                                                                                               |
      | associationStart.type                         | PTOSSHIP                                                                                                                        |
      | associationStart.target.poleId.v2.id          | SNSENS:S={mrn{testId}789}                                                                                                       |
      | associationStart.target.type                  | S                                                                                                                               |
      | associationStart.timestamp                    | 2022-02-22T22:22:22.222Z                                                                                                        |
      | attributes.attrs.header.ingestDateTime        | 2022-02-22T22:22:22.222Z                                                                                                        |
    And one Event record for "SNS-ASSOC-Rep2Cons" with following attributes
      | metadata.identityRecord.poleId.v2.id          | SNSENS:E={[SNSENS:P={Acme Co,7 Somewhere Street,NW1 5EX{testId},London}[SNS-REPRESENTATIVE]][SNSENS:S={mrn{testId}789}][PTOS]} |
      | metadata.identityRecord.type                  | E                                                                                                                              |
      | metadata.sourceRecord.name                    | SNSENS                                                                                                                         |
      | metadata.sourceRecord.shortName               | SNS                                                                                                                            |
      | metadata.sourceRecord.location                | submissionIdmetadata.messageIdentification                                                                                     |
      | metadata.sourceRecord.id                      | {[SNSENS:P={Acme Co,7 Somewhere Street,NW1 5EX{testId},London}[SNS-REPRESENTATIVE]][SNSENS:S={mrn{testId}789}][PTOS]}          |
      | metadata.sourceRecord.audit.createdBy         | 0123456789                                                                                                                     |
      | metadata.sourceRecord.audit.createdTimestamp  | 2022-02-22T22:22:22.222Z                                                                                                       |
      | metadata.mappingRecord.name                   | SNS-ASSOC-Rep2Cons                                                                                                             |
      | metadata.mappingRecord.version                | mappingVersion                                                                                                                 |
      | metadata.complianceRecord.visibility          | UNKNOWN                                                                                                                        |
      | metadata.complianceRecord.gscMarker           | null                                                                                                                           |
      | metadata.complianceRecord.retentionMarkerDays | -1                                                                                                                             |
      | snapshotTrigger                               | null                                                                                                                           |
      | type                                          | ASSOCIATION_START                                                                                                              |
      | subject.poleId.v2.id                          | SNSENS:P={Acme Co,7 Somewhere Street,NW1 5EX{testId},London}[SNS-REPRESENTATIVE]                                               |
      | subject.type                                  | P                                                                                                                              |
      | associationStart.type                         | PTOS                                                                                                                           |
      | associationStart.target.poleId.v2.id          | SNSENS:S={mrn{testId}789}                                                                                                      |
      | associationStart.target.type                  | S                                                                                                                              |
      | associationStart.timestamp                    | 2022-02-22T22:22:22.222Z                                                                                                       |
      | attributes.attrs.header.ingestDateTime        | 2022-02-22T22:22:22.222Z                                                                                                       |
    And one Event record for "SNS-ASSOC-Tra2Cons" with following attributes
      | metadata.identityRecord.poleId.v2.id          | SNSENS:E={[SNSENS:P=null[{trailer101Nationality{testId}mrn{testId}}],O={trailer101Nationality{testId}mrn{testId}}][SNSENS:S={mrn{testId}789}][OTOSASSO]} |
      | metadata.identityRecord.type                  | E                                                                                                                                                        |
      | metadata.sourceRecord.name                    | SNSENS                                                                                                                                                   |
      | metadata.sourceRecord.shortName               | SNS                                                                                                                                                      |
      | metadata.sourceRecord.location                | submissionIdmetadata.messageIdentification                                                                                                               |
      | metadata.sourceRecord.id                      | {[SNSENS:P=null[{trailer101Nationality{testId}mrn{testId}}],O={trailer101Nationality{testId}mrn{testId}}][SNSENS:S={mrn{testId}789}][OTOSASSO]}          |
      | metadata.sourceRecord.audit.createdBy         | 0123456789                                                                                                                                               |
      | metadata.sourceRecord.audit.createdTimestamp  | 2022-02-22T22:22:22.222Z                                                                                                                                 |
      | metadata.mappingRecord.name                   | SNS-ASSOC-Tra2Cons                                                                                                                                       |
      | metadata.mappingRecord.version                | mappingVersion                                                                                                                                           |
      | metadata.complianceRecord.visibility          | UNKNOWN                                                                                                                                                  |
      | metadata.complianceRecord.gscMarker           | null                                                                                                                                                     |
      | metadata.complianceRecord.retentionMarkerDays | -1                                                                                                                                                       |
      | snapshotTrigger                               | null                                                                                                                                                     |
      | type                                          | ASSOCIATION_START                                                                                                                                        |
      | subject.poleId.v2.id                          | SNSENS:P=null[{trailer101Nationality{testId}mrn{testId}}],O={trailer101Nationality{testId}mrn{testId}}                                                   |
      | subject.type                                  | O                                                                                                                                                        |
      | associationStart.type                         | OTOSASSO                                                                                                                                                 |
      | associationStart.target.poleId.v2.id          | SNSENS:S={mrn{testId}789}                                                                                                                                |
      | associationStart.target.type                  | S                                                                                                                                                        |
      | associationStart.timestamp                    | 2022-02-22T22:22:22.222Z                                                                                                                                 |
      | attributes.attrs.header.ingestDateTime        | 2022-02-22T22:22:22.222Z                                                                                                                                 |

    And one Event record for "SNS-ASSOC-Veh2Cons" with following attributes
      | metadata.identityRecord.poleId.v2.id          | SNSENS:E={[SNSENS:P=null[{Nationality{testId}vehicle101}],O={Nationality{testId}vehicle101}][SNSENS:S={mrn{testId}789}][OTOSASSO]} |
      | metadata.identityRecord.type                  | E                                                                                                                                  |
      | metadata.sourceRecord.name                    | SNSENS                                                                                                                             |
      | metadata.sourceRecord.shortName               | SNS                                                                                                                                |
      | metadata.sourceRecord.location                | submissionIdmetadata.messageIdentification                                                                                         |
      | metadata.sourceRecord.id                      | {[SNSENS:P=null[{Nationality{testId}vehicle101}],O={Nationality{testId}vehicle101}][SNSENS:S={mrn{testId}789}][OTOSASSO]}          |
      | metadata.sourceRecord.audit.createdBy         | 0123456789                                                                                                                         |
      | metadata.sourceRecord.audit.createdTimestamp  | 2022-02-22T22:22:22.222Z                                                                                                           |
      | metadata.mappingRecord.name                   | SNS-ASSOC-Veh2Cons                                                                                                                 |
      | metadata.mappingRecord.version                | mappingVersion                                                                                                                     |
      | metadata.complianceRecord.visibility          | UNKNOWN                                                                                                                            |
      | metadata.complianceRecord.gscMarker           | null                                                                                                                               |
      | metadata.complianceRecord.retentionMarkerDays | -1                                                                                                                                 |
      | snapshotTrigger                               | null                                                                                                                               |
      | type                                          | ASSOCIATION_START                                                                                                                  |
      | subject.poleId.v2.id                          | SNSENS:P=null[{Nationality{testId}vehicle101}],O={Nationality{testId}vehicle101}                                                   |
      | subject.type                                  | O                                                                                                                                  |
      | associationStart.type                         | OTOSASSO                                                                                                                           |
      | associationStart.target.poleId.v2.id          | SNSENS:S={mrn{testId}789}                                                                                                          |
      | associationStart.target.type                  | S                                                                                                                                  |
      | associationStart.timestamp                    | 2022-02-22T22:22:22.222Z                                                                                                           |
      | attributes.attrs.header.ingestDateTime        | 2022-02-22T22:22:22.222Z                                                                                                           |
    And one Event record for "SNS-ASSOC-Cont2Ite" with following attributes
      | metadata.identityRecord.poleId.v2.id          | SNSENS:E={[SNSENS:P=null[{mrn{testId}111}],O={mrn{testId}111}][SNSENS:S={mrn{testId}ITE1234{testId}}][OTOSASSO]} |
      | metadata.identityRecord.type                  | E                                                                                                                |
      | metadata.sourceRecord.name                    | SNSENS                                                                                                           |
      | metadata.sourceRecord.shortName               | SNS                                                                                                              |
      | metadata.sourceRecord.location                | submissionIdmetadata.messageIdentification                                                                       |
      | metadata.sourceRecord.id                      | {[SNSENS:P=null[{mrn{testId}111}],O={mrn{testId}111}][SNSENS:S={mrn{testId}ITE1234{testId}}][OTOSASSO]}          |
      | metadata.sourceRecord.audit.createdBy         | 0123456789                                                                                                       |
      | metadata.sourceRecord.audit.createdTimestamp  | 2022-02-22T22:22:22.222Z                                                                                         |
      | metadata.mappingRecord.name                   | SNS-ASSOC-Cont2Ite                                                                                               |
      | metadata.mappingRecord.version                | mappingVersion                                                                                                   |
      | metadata.complianceRecord.visibility          | UNKNOWN                                                                                                          |
      | metadata.complianceRecord.gscMarker           | null                                                                                                             |
      | metadata.complianceRecord.retentionMarkerDays | -1                                                                                                               |
      | snapshotTrigger                               | null                                                                                                             |
      | type                                          | ASSOCIATION_START                                                                                                |
      | subject.poleId.v2.id                          | SNSENS:P=null[{mrn{testId}111}],O={mrn{testId}111}                                                               |
      | subject.type                                  | O                                                                                                                |
      | associationStart.type                         | OTOSASSO                                                                                                         |
      | associationStart.target.poleId.v2.id          | SNSENS:S={mrn{testId}ITE1234{testId}}                                                                            |
      | associationStart.target.type                  | S                                                                                                                |
      | associationStart.timestamp                    | 2022-02-22T22:22:22.222Z                                                                                         |
      | attributes.attrs.header.ingestDateTime        | 2022-02-22T22:22:22.222Z                                                                                         |
    And one Event record for "SNS-ASSOC-Cont2Ite" with following attributes
      | metadata.identityRecord.poleId.v2.id          | SNSENS:E={[SNSENS:P=null[{mrn{testId}567}],O={mrn{testId}567}][SNSENS:S={mrn{testId}ITE1234{testId}}][OTOSASSO]} |
      | metadata.identityRecord.type                  | E                                                                                                                |
      | metadata.sourceRecord.name                    | SNSENS                                                                                                           |
      | metadata.sourceRecord.shortName               | SNS                                                                                                              |
      | metadata.sourceRecord.location                | submissionIdmetadata.messageIdentification                                                                       |
      | metadata.sourceRecord.id                      | {[SNSENS:P=null[{mrn{testId}567}],O={mrn{testId}567}][SNSENS:S={mrn{testId}ITE1234{testId}}][OTOSASSO]}          |
      | metadata.sourceRecord.audit.createdBy         | 0123456789                                                                                                       |
      | metadata.sourceRecord.audit.createdTimestamp  | 2022-02-22T22:22:22.222Z                                                                                         |
      | metadata.mappingRecord.name                   | SNS-ASSOC-Cont2Ite                                                                                               |
      | metadata.mappingRecord.version                | mappingVersion                                                                                                   |
      | metadata.complianceRecord.visibility          | UNKNOWN                                                                                                          |
      | metadata.complianceRecord.gscMarker           | null                                                                                                             |
      | metadata.complianceRecord.retentionMarkerDays | -1                                                                                                               |
      | snapshotTrigger                               | null                                                                                                             |
      | type                                          | ASSOCIATION_START                                                                                                |
      | subject.poleId.v2.id                          | SNSENS:P=null[{mrn{testId}567}],O={mrn{testId}567}                                                               |
      | subject.type                                  | O                                                                                                                |
      | associationStart.type                         | OTOSASSO                                                                                                         |
      | associationStart.target.poleId.v2.id          | SNSENS:S={mrn{testId}ITE1234{testId}}                                                                            |
      | associationStart.target.type                  | S                                                                                                                |
      | associationStart.timestamp                    | 2022-02-22T22:22:22.222Z                                                                                         |
      | attributes.attrs.header.ingestDateTime        | 2022-02-22T22:22:22.222Z                                                                                         |
    And one Event record for "SNS-ASSOC-Cont2Ite" with following attributes
      | metadata.identityRecord.poleId.v2.id          | SNSENS:E={[SNSENS:P=null[{mrn{testId}456}],O={mrn{testId}456}][SNSENS:S={mrn{testId}IN9876{testId}}][OTOSASSO]} |
      | metadata.identityRecord.type                  | E                                                                                                               |
      | metadata.sourceRecord.name                    | SNSENS                                                                                                          |
      | metadata.sourceRecord.shortName               | SNS                                                                                                             |
      | metadata.sourceRecord.location                | submissionIdmetadata.messageIdentification                                                                      |
      | metadata.sourceRecord.id                      | {[SNSENS:P=null[{mrn{testId}456}],O={mrn{testId}456}][SNSENS:S={mrn{testId}IN9876{testId}}][OTOSASSO]}          |
      | metadata.sourceRecord.audit.createdBy         | 0123456789                                                                                                      |
      | metadata.sourceRecord.audit.createdTimestamp  | 2022-02-22T22:22:22.222Z                                                                                        |
      | metadata.mappingRecord.name                   | SNS-ASSOC-Cont2Ite                                                                                              |
      | metadata.mappingRecord.version                | mappingVersion                                                                                                  |
      | metadata.complianceRecord.visibility          | UNKNOWN                                                                                                         |
      | metadata.complianceRecord.gscMarker           | null                                                                                                            |
      | metadata.complianceRecord.retentionMarkerDays | -1                                                                                                              |
      | snapshotTrigger                               | null                                                                                                            |
      | type                                          | ASSOCIATION_START                                                                                               |
      | subject.poleId.v2.id                          | SNSENS:P=null[{mrn{testId}456}],O={mrn{testId}456}                                                              |
      | subject.type                                  | O                                                                                                               |
      | associationStart.type                         | OTOSASSO                                                                                                        |
      | associationStart.target.poleId.v2.id          | SNSENS:S={mrn{testId}IN9876{testId}}                                                                            |
      | associationStart.target.type                  | S                                                                                                               |
      | associationStart.timestamp                    | 2022-02-22T22:22:22.222Z                                                                                        |
      | attributes.attrs.header.ingestDateTime        | 2022-02-22T22:22:22.222Z                                                                                        |
    And one Event record for "SNS-ASSOC-CTral2CVeh" with following attributes
      | metadata.identityRecord.poleId.v2.id          | SNSENS:E={[SNSENS:P=null[{trailer102Nationality{testId}mrn{testId}}],O={trailer102Nationality{testId}mrn{testId}}][SNSENS:P=null[{Nationality{testId}vehicle102}],O={Nationality{testId}vehicle102}][OTOOLINK]} |
      | metadata.identityRecord.type                  | E                                                                                                                                                                                                               |
      | metadata.sourceRecord.name                    | SNSENS                                                                                                                                                                                                          |
      | metadata.sourceRecord.shortName               | SNS                                                                                                                                                                                                             |
      | metadata.sourceRecord.location                | submissionIdmetadata.messageIdentification                                                                                                                                                                      |
      | metadata.sourceRecord.id                      | {[SNSENS:P=null[{trailer102Nationality{testId}mrn{testId}}],O={trailer102Nationality{testId}mrn{testId}}][SNSENS:P=null[{Nationality{testId}vehicle102}],O={Nationality{testId}vehicle102}][OTOOLINK]}          |
      | metadata.sourceRecord.audit.createdBy         | 0123456789                                                                                                                                                                                                      |
      | metadata.sourceRecord.audit.createdTimestamp  | 2022-02-22T22:22:22.222Z                                                                                                                                                                                        |
      | metadata.mappingRecord.name                   | SNS-ASSOC-CTral2CVeh                                                                                                                                                                                            |
      | metadata.mappingRecord.version                | mappingVersion                                                                                                                                                                                                  |
      | metadata.complianceRecord.visibility          | UNKNOWN                                                                                                                                                                                                         |
      | metadata.complianceRecord.gscMarker           | null                                                                                                                                                                                                            |
      | metadata.complianceRecord.retentionMarkerDays | -1                                                                                                                                                                                                              |
      | snapshotTrigger                               | null                                                                                                                                                                                                            |
      | type                                          | ASSOCIATION_START                                                                                                                                                                                               |
      | subject.poleId.v2.id                          | SNSENS:P=null[{Nationality{testId}vehicle102}],O={Nationality{testId}vehicle102}                                                                                                                                |
      | subject.type                                  | O                                                                                                                                                                                                               |
      | associationStart.type                         | OTOOLINK                                                                                                                                                                                                        |
      | associationStart.target.poleId.v2.id          | SNSENS:P=null[{trailer102Nationality{testId}mrn{testId}}],O={trailer102Nationality{testId}mrn{testId}}                                                                                                          |
      | associationStart.target.type                  | O                                                                                                                                                                                                               |
      | associationStart.timestamp                    | 2022-02-22T22:22:22.222Z                                                                                                                                                                                        |
      | attributes.attrs.header.ingestDateTime        | 2022-02-22T22:22:22.222Z                                                                                                                                                                                        |
    And one Event record for "SNS-ASSOC-CTral2CVeh" with following attributes
      | metadata.identityRecord.poleId.v2.id          | SNSENS:E={[SNSENS:P=null[{trailer103Nationality{testId}mrn{testId}}],O={trailer103Nationality{testId}mrn{testId}}][SNSENS:P=null[{Nationality{testId}vehicle103}],O={Nationality{testId}vehicle103}][OTOOLINK]} |
      | metadata.identityRecord.type                  | E                                                                                                                                                                                                               |
      | metadata.sourceRecord.name                    | SNSENS                                                                                                                                                                                                          |
      | metadata.sourceRecord.shortName               | SNS                                                                                                                                                                                                             |
      | metadata.sourceRecord.location                | submissionIdmetadata.messageIdentification                                                                                                                                                                      |
      | metadata.sourceRecord.id                      | {[SNSENS:P=null[{trailer103Nationality{testId}mrn{testId}}],O={trailer103Nationality{testId}mrn{testId}}][SNSENS:P=null[{Nationality{testId}vehicle103}],O={Nationality{testId}vehicle103}][OTOOLINK]}          |
      | metadata.sourceRecord.audit.createdBy         | 0123456789                                                                                                                                                                                                      |
      | metadata.sourceRecord.audit.createdTimestamp  | 2022-02-22T22:22:22.222Z                                                                                                                                                                                        |
      | metadata.mappingRecord.name                   | SNS-ASSOC-CTral2CVeh                                                                                                                                                                                            |
      | metadata.mappingRecord.version                | mappingVersion                                                                                                                                                                                                  |
      | metadata.complianceRecord.visibility          | UNKNOWN                                                                                                                                                                                                         |
      | metadata.complianceRecord.gscMarker           | null                                                                                                                                                                                                            |
      | metadata.complianceRecord.retentionMarkerDays | -1                                                                                                                                                                                                              |
      | snapshotTrigger                               | null                                                                                                                                                                                                            |
      | type                                          | ASSOCIATION_START                                                                                                                                                                                               |
      | subject.poleId.v2.id                          | SNSENS:P=null[{Nationality{testId}vehicle103}],O={Nationality{testId}vehicle103}                                                                                                                                |
      | subject.type                                  | O                                                                                                                                                                                                               |
      | associationStart.type                         | OTOOLINK                                                                                                                                                                                                        |
      | associationStart.target.poleId.v2.id          | SNSENS:P=null[{trailer103Nationality{testId}mrn{testId}}],O={trailer103Nationality{testId}mrn{testId}}                                                                                                          |
      | associationStart.target.type                  | O                                                                                                                                                                                                               |
      | associationStart.timestamp                    | 2022-02-22T22:22:22.222Z                                                                                                                                                                                        |
      | attributes.attrs.header.ingestDateTime        | 2022-02-22T22:22:22.222Z                                                                                                                                                                                        |
    And one Event record for "SNS-ASSOC-CVeh2Cont" with following attributes
      | metadata.identityRecord.poleId.v2.id          | SNSENS:E={[SNSENS:P=null[{Nationality{testId}vehicle102}],O={Nationality{testId}vehicle102}][SNSENS:P=null[{mrn{testId}111}],O={mrn{testId}111}][OTOOLINK]} |
      | metadata.identityRecord.type                  | E                                                                                                                                                           |
      | metadata.sourceRecord.name                    | SNSENS                                                                                                                                                      |
      | metadata.sourceRecord.shortName               | SNS                                                                                                                                                         |
      | metadata.sourceRecord.location                | submissionIdmetadata.messageIdentification                                                                                                                  |
      | metadata.sourceRecord.id                      | {[SNSENS:P=null[{Nationality{testId}vehicle102}],O={Nationality{testId}vehicle102}][SNSENS:P=null[{mrn{testId}111}],O={mrn{testId}111}][OTOOLINK]}          |
      | metadata.sourceRecord.audit.createdBy         | 0123456789                                                                                                                                                  |
      | metadata.sourceRecord.audit.createdTimestamp  | 2022-02-22T22:22:22.222Z                                                                                                                                    |
      | metadata.mappingRecord.name                   | SNS-ASSOC-CVeh2Cont                                                                                                                                         |
      | metadata.mappingRecord.version                | mappingVersion                                                                                                                                              |
      | metadata.complianceRecord.visibility          | UNKNOWN                                                                                                                                                     |
      | metadata.complianceRecord.gscMarker           | null                                                                                                                                                        |
      | metadata.complianceRecord.retentionMarkerDays | -1                                                                                                                                                          |
      | snapshotTrigger                               | null                                                                                                                                                        |
      | type                                          | ASSOCIATION_START                                                                                                                                           |
      | subject.poleId.v2.id                          | SNSENS:P=null[{Nationality{testId}vehicle102}],O={Nationality{testId}vehicle102}                                                                            |
      | subject.type                                  | O                                                                                                                                                           |
      | associationStart.type                         | OTOOLINK                                                                                                                                                    |
      | associationStart.target.poleId.v2.id          | SNSENS:P=null[{mrn{testId}111}],O={mrn{testId}111}                                                                                                          |
      | associationStart.target.type                  | O                                                                                                                                                           |
      | associationStart.timestamp                    | 2022-02-22T22:22:22.222Z                                                                                                                                    |
      | attributes.attrs.header.ingestDateTime        | 2022-02-22T22:22:22.222Z                                                                                                                                    |
    And one Event record for "SNS-ASSOC-CVeh2Cont" with following attributes
      | metadata.identityRecord.poleId.v2.id          | SNSENS:E={[SNSENS:P=null[{Nationality{testId}vehicle102}],O={Nationality{testId}vehicle102}][SNSENS:P=null[{mrn{testId}567}],O={mrn{testId}567}][OTOOLINK]} |
      | metadata.identityRecord.type                  | E                                                                                                                                                           |
      | metadata.sourceRecord.name                    | SNSENS                                                                                                                                                      |
      | metadata.sourceRecord.shortName               | SNS                                                                                                                                                         |
      | metadata.sourceRecord.location                | submissionIdmetadata.messageIdentification                                                                                                                  |
      | metadata.sourceRecord.id                      | {[SNSENS:P=null[{Nationality{testId}vehicle102}],O={Nationality{testId}vehicle102}][SNSENS:P=null[{mrn{testId}567}],O={mrn{testId}567}][OTOOLINK]}          |
      | metadata.sourceRecord.audit.createdBy         | 0123456789                                                                                                                                                  |
      | metadata.sourceRecord.audit.createdTimestamp  | 2022-02-22T22:22:22.222Z                                                                                                                                    |
      | metadata.mappingRecord.name                   | SNS-ASSOC-CVeh2Cont                                                                                                                                         |
      | metadata.mappingRecord.version                | mappingVersion                                                                                                                                              |
      | metadata.complianceRecord.visibility          | UNKNOWN                                                                                                                                                     |
      | metadata.complianceRecord.gscMarker           | null                                                                                                                                                        |
      | metadata.complianceRecord.retentionMarkerDays | -1                                                                                                                                                          |
      | snapshotTrigger                               | null                                                                                                                                                        |
      | type                                          | ASSOCIATION_START                                                                                                                                           |
      | subject.poleId.v2.id                          | SNSENS:P=null[{Nationality{testId}vehicle102}],O={Nationality{testId}vehicle102}                                                                            |
      | subject.type                                  | O                                                                                                                                                           |
      | associationStart.type                         | OTOOLINK                                                                                                                                                    |
      | associationStart.target.poleId.v2.id          | SNSENS:P=null[{mrn{testId}567}],O={mrn{testId}567}                                                                                                          |
      | associationStart.target.type                  | O                                                                                                                                                           |
      | associationStart.timestamp                    | 2022-02-22T22:22:22.222Z                                                                                                                                    |
      | attributes.attrs.header.ingestDateTime        | 2022-02-22T22:22:22.222Z                                                                                                                                    |
    And one Event record for "SNS-ASSOC-CVeh2Cont" with following attributes
      | metadata.identityRecord.poleId.v2.id          | SNSENS:E={[SNSENS:P=null[{Nationality{testId}}],O={Nationality{testId}}][SNSENS:P=null[{mrn{testId}567}],O={mrn{testId}567}][OTOOLINK]} |
      | metadata.identityRecord.type                  | E                                                                                                                                       |
      | metadata.sourceRecord.name                    | SNSENS                                                                                                                                  |
      | metadata.sourceRecord.shortName               | SNS                                                                                                                                     |
      | metadata.sourceRecord.location                | submissionIdmetadata.messageIdentification                                                                                              |
      | metadata.sourceRecord.id                      | {[SNSENS:P=null[{Nationality{testId}}],O={Nationality{testId}}][SNSENS:P=null[{mrn{testId}567}],O={mrn{testId}567}][OTOOLINK]}          |
      | metadata.sourceRecord.audit.createdBy         | 0123456789                                                                                                                              |
      | metadata.sourceRecord.audit.createdTimestamp  | 2022-02-22T22:22:22.222Z                                                                                                                |
      | metadata.mappingRecord.name                   | SNS-ASSOC-CVeh2Cont                                                                                                                     |
      | metadata.mappingRecord.version                | mappingVersion                                                                                                                          |
      | metadata.complianceRecord.visibility          | UNKNOWN                                                                                                                                 |
      | metadata.complianceRecord.gscMarker           | null                                                                                                                                    |
      | metadata.complianceRecord.retentionMarkerDays | -1                                                                                                                                      |
      | snapshotTrigger                               | null                                                                                                                                    |
      | type                                          | ASSOCIATION_START                                                                                                                       |
      | subject.poleId.v2.id                          | SNSENS:P=null[{Nationality{testId}}],O={Nationality{testId}}                                                                            |
      | subject.type                                  | O                                                                                                                                       |
      | associationStart.type                         | OTOOLINK                                                                                                                                |
      | associationStart.target.poleId.v2.id          | SNSENS:P=null[{mrn{testId}567}],O={mrn{testId}567}                                                                                      |
      | associationStart.target.type                  | O                                                                                                                                       |
      | associationStart.timestamp                    | 2022-02-22T22:22:22.222Z                                                                                                                |
      | attributes.attrs.header.ingestDateTime        | 2022-02-22T22:22:22.222Z                                                                                                                |
    And one Event record for "SNS-ASSOC-CVeh2Cont" with following attributes
      | metadata.identityRecord.poleId.v2.id          | SNSENS:E={[SNSENS:P=null[{Nationality{testId}}],O={Nationality{testId}}][SNSENS:P=null[{mrn{testId}111}],O={mrn{testId}111}][OTOOLINK]} |
      | metadata.identityRecord.type                  | E                                                                                                                                       |
      | metadata.sourceRecord.name                    | SNSENS                                                                                                                                  |
      | metadata.sourceRecord.shortName               | SNS                                                                                                                                     |
      | metadata.sourceRecord.location                | submissionIdmetadata.messageIdentification                                                                                              |
      | metadata.sourceRecord.id                      | {[SNSENS:P=null[{Nationality{testId}}],O={Nationality{testId}}][SNSENS:P=null[{mrn{testId}111}],O={mrn{testId}111}][OTOOLINK]}          |
      | metadata.sourceRecord.audit.createdBy         | 0123456789                                                                                                                              |
      | metadata.sourceRecord.audit.createdTimestamp  | 2022-02-22T22:22:22.222Z                                                                                                                |
      | metadata.mappingRecord.name                   | SNS-ASSOC-CVeh2Cont                                                                                                                     |
      | metadata.mappingRecord.version                | mappingVersion                                                                                                                          |
      | metadata.complianceRecord.visibility          | UNKNOWN                                                                                                                                 |
      | metadata.complianceRecord.gscMarker           | null                                                                                                                                    |
      | metadata.complianceRecord.retentionMarkerDays | -1                                                                                                                                      |
      | snapshotTrigger                               | null                                                                                                                                    |
      | type                                          | ASSOCIATION_START                                                                                                                       |
      | subject.poleId.v2.id                          | SNSENS:P=null[{Nationality{testId}}],O={Nationality{testId}}                                                                            |
      | subject.type                                  | O                                                                                                                                       |
      | associationStart.type                         | OTOOLINK                                                                                                                                |
      | associationStart.target.poleId.v2.id          | SNSENS:P=null[{mrn{testId}111}],O={mrn{testId}111}                                                                                      |
      | associationStart.target.type                  | O                                                                                                                                       |
      | associationStart.timestamp                    | 2022-02-22T22:22:22.222Z                                                                                                                |
      | attributes.attrs.header.ingestDateTime        | 2022-02-22T22:22:22.222Z                                                                                                                |
    And one Event record for "SNS-ASSOC-CVeh2Cont" with following attributes
      | metadata.identityRecord.poleId.v2.id          | SNSENS:E={[SNSENS:P=null[{Nationality{testId}vehicle103}],O={Nationality{testId}vehicle103}][SNSENS:P=null[{mrn{testId}456}],O={mrn{testId}456}][OTOOLINK]} |
      | metadata.identityRecord.type                  | E                                                                                                                                                           |
      | metadata.sourceRecord.name                    | SNSENS                                                                                                                                                      |
      | metadata.sourceRecord.shortName               | SNS                                                                                                                                                         |
      | metadata.sourceRecord.location                | submissionIdmetadata.messageIdentification                                                                                                                  |
      | metadata.sourceRecord.id                      | {[SNSENS:P=null[{Nationality{testId}vehicle103}],O={Nationality{testId}vehicle103}][SNSENS:P=null[{mrn{testId}456}],O={mrn{testId}456}][OTOOLINK]}          |
      | metadata.sourceRecord.audit.createdBy         | 0123456789                                                                                                                                                  |
      | metadata.sourceRecord.audit.createdTimestamp  | 2022-02-22T22:22:22.222Z                                                                                                                                    |
      | metadata.mappingRecord.name                   | SNS-ASSOC-CVeh2Cont                                                                                                                                         |
      | metadata.mappingRecord.version                | mappingVersion                                                                                                                                              |
      | metadata.complianceRecord.visibility          | UNKNOWN                                                                                                                                                     |
      | metadata.complianceRecord.gscMarker           | null                                                                                                                                                        |
      | metadata.complianceRecord.retentionMarkerDays | -1                                                                                                                                                          |
      | snapshotTrigger                               | null                                                                                                                                                        |
      | type                                          | ASSOCIATION_START                                                                                                                                           |
      | subject.poleId.v2.id                          | SNSENS:P=null[{Nationality{testId}vehicle103}],O={Nationality{testId}vehicle103}                                                                            |
      | subject.type                                  | O                                                                                                                                                           |
      | associationStart.type                         | OTOOLINK                                                                                                                                                    |
      | associationStart.target.poleId.v2.id          | SNSENS:P=null[{mrn{testId}456}],O={mrn{testId}456}                                                                                                          |
      | associationStart.target.type                  | O                                                                                                                                                           |
      | associationStart.timestamp                    | 2022-02-22T22:22:22.222Z                                                                                                                                    |
      | attributes.attrs.header.ingestDateTime        | 2022-02-22T22:22:22.222Z                                                                                                                                    |
    And one Event record for "SNS-ASSOC-CVeh2Ite" with following attributes
      | metadata.identityRecord.poleId.v2.id          | SNSENS:E={[SNSENS:P=null[{Nationality{testId}vehicle102}],O={Nationality{testId}vehicle102}][SNSENS:S={mrn{testId}ITE1234{testId}}][OTOSASSO]} |
      | metadata.identityRecord.type                  | E                                                                                                                                              |
      | metadata.sourceRecord.name                    | SNSENS                                                                                                                                         |
      | metadata.sourceRecord.shortName               | SNS                                                                                                                                            |
      | metadata.sourceRecord.location                | submissionIdmetadata.messageIdentification                                                                                                     |
      | metadata.sourceRecord.id                      | {[SNSENS:P=null[{Nationality{testId}vehicle102}],O={Nationality{testId}vehicle102}][SNSENS:S={mrn{testId}ITE1234{testId}}][OTOSASSO]}          |
      | metadata.sourceRecord.audit.createdBy         | 0123456789                                                                                                                                     |
      | metadata.sourceRecord.audit.createdTimestamp  | 2022-02-22T22:22:22.222Z                                                                                                                       |
      | metadata.mappingRecord.name                   | SNS-ASSOC-CVeh2Ite                                                                                                                             |
      | metadata.mappingRecord.version                | mappingVersion                                                                                                                                 |
      | metadata.complianceRecord.visibility          | UNKNOWN                                                                                                                                        |
      | metadata.complianceRecord.gscMarker           | null                                                                                                                                           |
      | metadata.complianceRecord.retentionMarkerDays | -1                                                                                                                                             |
      | snapshotTrigger                               | null                                                                                                                                           |
      | type                                          | ASSOCIATION_START                                                                                                                              |
      | subject.poleId.v2.id                          | SNSENS:P=null[{Nationality{testId}vehicle102}],O={Nationality{testId}vehicle102}                                                               |
      | subject.type                                  | O                                                                                                                                              |
      | associationStart.type                         | OTOSASSO                                                                                                                                       |
      | associationStart.target.poleId.v2.id          | SNSENS:S={mrn{testId}ITE1234{testId}}                                                                                                          |
      | associationStart.target.type                  | S                                                                                                                                              |
      | associationStart.timestamp                    | 2022-02-22T22:22:22.222Z                                                                                                                       |
      | attributes.attrs.header.ingestDateTime        | 2022-02-22T22:22:22.222Z                                                                                                                       |
    And one Event record for "SNS-ASSOC-CVeh2Ite" with following attributes
      | metadata.identityRecord.poleId.v2.id          | SNSENS:E={[SNSENS:P=null[{Nationality{testId}}],O={Nationality{testId}}][SNSENS:S={mrn{testId}ITE1234{testId}}][OTOSASSO]} |
      | metadata.identityRecord.type                  | E                                                                                                                          |
      | metadata.sourceRecord.name                    | SNSENS                                                                                                                     |
      | metadata.sourceRecord.shortName               | SNS                                                                                                                        |
      | metadata.sourceRecord.location                | submissionIdmetadata.messageIdentification                                                                                 |
      | metadata.sourceRecord.id                      | {[SNSENS:P=null[{Nationality{testId}}],O={Nationality{testId}}][SNSENS:S={mrn{testId}ITE1234{testId}}][OTOSASSO]}          |
      | metadata.sourceRecord.audit.createdBy         | 0123456789                                                                                                                 |
      | metadata.sourceRecord.audit.createdTimestamp  | 2022-02-22T22:22:22.222Z                                                                                                   |
      | metadata.mappingRecord.name                   | SNS-ASSOC-CVeh2Ite                                                                                                         |
      | metadata.mappingRecord.version                | mappingVersion                                                                                                             |
      | metadata.complianceRecord.visibility          | UNKNOWN                                                                                                                    |
      | metadata.complianceRecord.gscMarker           | null                                                                                                                       |
      | metadata.complianceRecord.retentionMarkerDays | -1                                                                                                                         |
      | snapshotTrigger                               | null                                                                                                                       |
      | type                                          | ASSOCIATION_START                                                                                                          |
      | subject.poleId.v2.id                          | SNSENS:P=null[{Nationality{testId}}],O={Nationality{testId}}                                                               |
      | subject.type                                  | O                                                                                                                          |
      | associationStart.type                         | OTOSASSO                                                                                                                   |
      | associationStart.target.poleId.v2.id          | SNSENS:S={mrn{testId}ITE1234{testId}}                                                                                      |
      | associationStart.target.type                  | S                                                                                                                          |
      | associationStart.timestamp                    | 2022-02-22T22:22:22.222Z                                                                                                   |
      | attributes.attrs.header.ingestDateTime        | 2022-02-22T22:22:22.222Z                                                                                                   |
    And one Event record for "SNS-ASSOC-CVeh2Ite" with following attributes
      | metadata.identityRecord.poleId.v2.id          | SNSENS:E={[SNSENS:P=null[{Nationality{testId}vehicle103}],O={Nationality{testId}vehicle103}][SNSENS:S={mrn{testId}IN9876{testId}}][OTOSASSO]} |
      | metadata.identityRecord.type                  | E                                                                                                                                             |
      | metadata.sourceRecord.name                    | SNSENS                                                                                                                                        |
      | metadata.sourceRecord.shortName               | SNS                                                                                                                                           |
      | metadata.sourceRecord.location                | submissionIdmetadata.messageIdentification                                                                                                    |
      | metadata.sourceRecord.id                      | {[SNSENS:P=null[{Nationality{testId}vehicle103}],O={Nationality{testId}vehicle103}][SNSENS:S={mrn{testId}IN9876{testId}}][OTOSASSO]}          |
      | metadata.sourceRecord.audit.createdBy         | 0123456789                                                                                                                                    |
      | metadata.sourceRecord.audit.createdTimestamp  | 2022-02-22T22:22:22.222Z                                                                                                                      |
      | metadata.mappingRecord.name                   | SNS-ASSOC-CVeh2Ite                                                                                                                            |
      | metadata.mappingRecord.version                | mappingVersion                                                                                                                                |
      | metadata.complianceRecord.visibility          | UNKNOWN                                                                                                                                       |
      | metadata.complianceRecord.gscMarker           | null                                                                                                                                          |
      | metadata.complianceRecord.retentionMarkerDays | -1                                                                                                                                            |
      | snapshotTrigger                               | null                                                                                                                                          |
      | type                                          | ASSOCIATION_START                                                                                                                             |
      | subject.poleId.v2.id                          | SNSENS:P=null[{Nationality{testId}vehicle103}],O={Nationality{testId}vehicle103}                                                              |
      | subject.type                                  | O                                                                                                                                             |
      | associationStart.type                         | OTOSASSO                                                                                                                                      |
      | associationStart.target.poleId.v2.id          | SNSENS:S={mrn{testId}IN9876{testId}}                                                                                                          |
      | associationStart.target.type                  | S                                                                                                                                             |
      | associationStart.timestamp                    | 2022-02-22T22:22:22.222Z                                                                                                                      |
      | attributes.attrs.header.ingestDateTime        | 2022-02-22T22:22:22.222Z                                                                                                                      |
    And one Event record for "SNS-ASSOC-CVes2Ite" with following attributes
      | metadata.identityRecord.poleId.v2.id          | SNSENS:E={[SNSENS:P=null[{IMO1234567Nationality{testId}}],O={IMO1234567Nationality{testId}}][SNSENS:S={mrn{testId}ITE1234{testId}}][OTOSASSO]} |
      | metadata.identityRecord.type                  | E                                                                                                                                              |
      | metadata.sourceRecord.name                    | SNSENS                                                                                                                                         |
      | metadata.sourceRecord.shortName               | SNS                                                                                                                                            |
      | metadata.sourceRecord.location                | submissionIdmetadata.messageIdentification                                                                                                     |
      | metadata.sourceRecord.id                      | {[SNSENS:P=null[{IMO1234567Nationality{testId}}],O={IMO1234567Nationality{testId}}][SNSENS:S={mrn{testId}ITE1234{testId}}][OTOSASSO]}          |
      | metadata.sourceRecord.audit.createdBy         | 0123456789                                                                                                                                     |
      | metadata.sourceRecord.audit.createdTimestamp  | 2022-02-22T22:22:22.222Z                                                                                                                       |
      | metadata.mappingRecord.name                   | SNS-ASSOC-CVes2Ite                                                                                                                             |
      | metadata.mappingRecord.version                | mappingVersion                                                                                                                                 |
      | metadata.complianceRecord.visibility          | UNKNOWN                                                                                                                                        |
      | metadata.complianceRecord.gscMarker           | null                                                                                                                                           |
      | metadata.complianceRecord.retentionMarkerDays | -1                                                                                                                                             |
      | snapshotTrigger                               | null                                                                                                                                           |
      | type                                          | ASSOCIATION_START                                                                                                                              |
      | subject.poleId.v2.id                          | SNSENS:P=null[{IMO1234567Nationality{testId}}],O={IMO1234567Nationality{testId}}                                                               |
      | subject.type                                  | O                                                                                                                                              |
      | associationStart.type                         | OTOSASSO                                                                                                                                       |
      | associationStart.target.poleId.v2.id          | SNSENS:S={mrn{testId}ITE1234{testId}}                                                                                                          |
      | associationStart.target.type                  | S                                                                                                                                              |
      | associationStart.timestamp                    | 2022-02-22T22:22:22.222Z                                                                                                                       |
      | attributes.attrs.header.ingestDateTime        | 2022-02-22T22:22:22.222Z                                                                                                                       |
    And one Event record for "SNS-ASSOC-Ite2Cons" with following attributes
      | metadata.identityRecord.poleId.v2.id          | SNSENS:E={[SNSENS:S={mrn{testId}ITE1234{testId}}][SNSENS:S={mrn{testId}789}][STOS]} |
      | metadata.identityRecord.type                  | E                                                                                   |
      | metadata.sourceRecord.name                    | SNSENS                                                                              |
      | metadata.sourceRecord.shortName               | SNS                                                                                 |
      | metadata.sourceRecord.location                | submissionIdmetadata.messageIdentification                                          |
      | metadata.sourceRecord.id                      | {[SNSENS:S={mrn{testId}ITE1234{testId}}][SNSENS:S={mrn{testId}789}][STOS]}          |
      | metadata.sourceRecord.audit.createdBy         | 0123456789                                                                          |
      | metadata.sourceRecord.audit.createdTimestamp  | 2022-02-22T22:22:22.222Z                                                            |
      | metadata.mappingRecord.name                   | SNS-ASSOC-Ite2Cons                                                                  |
      | metadata.mappingRecord.version                | mappingVersion                                                                      |
      | metadata.complianceRecord.visibility          | UNKNOWN                                                                             |
      | metadata.complianceRecord.gscMarker           | null                                                                                |
      | metadata.complianceRecord.retentionMarkerDays | -1                                                                                  |
      | snapshotTrigger                               | null                                                                                |
      | type                                          | ASSOCIATION_START                                                                   |
      | subject.poleId.v2.id                          | SNSENS:S={mrn{testId}789}                                                           |
      | subject.type                                  | S                                                                                   |
      | associationStart.type                         | STOS                                                                                |
      | associationStart.target.poleId.v2.id          | SNSENS:S={mrn{testId}ITE1234{testId}}                                               |
      | associationStart.target.type                  | S                                                                                   |
      | associationStart.timestamp                    | 2022-02-22T22:22:22.222Z                                                            |
      | attributes.attrs.header.ingestDateTime        | 2022-02-22T22:22:22.222Z                                                            |
    And one Event record for "SNS-ASSOC-Ite2Cons" with following attributes
      | metadata.identityRecord.poleId.v2.id          | SNSENS:E={[SNSENS:S={mrn{testId}IN9876{testId}}][SNSENS:S={mrn{testId}789}][STOS]} |
      | metadata.identityRecord.type                  | E                                                                                  |
      | metadata.sourceRecord.name                    | SNSENS                                                                             |
      | metadata.sourceRecord.shortName               | SNS                                                                                |
      | metadata.sourceRecord.location                | submissionIdmetadata.messageIdentification                                         |
      | metadata.sourceRecord.id                      | {[SNSENS:S={mrn{testId}IN9876{testId}}][SNSENS:S={mrn{testId}789}][STOS]}          |
      | metadata.sourceRecord.audit.createdBy         | 0123456789                                                                         |
      | metadata.sourceRecord.audit.createdTimestamp  | 2022-02-22T22:22:22.222Z                                                           |
      | metadata.mappingRecord.name                   | SNS-ASSOC-Ite2Cons                                                                 |
      | metadata.mappingRecord.version                | mappingVersion                                                                     |
      | metadata.complianceRecord.visibility          | UNKNOWN                                                                            |
      | metadata.complianceRecord.gscMarker           | null                                                                               |
      | metadata.complianceRecord.retentionMarkerDays | -1                                                                                 |
      | snapshotTrigger                               | null                                                                               |
      | type                                          | ASSOCIATION_START                                                                  |
      | subject.poleId.v2.id                          | SNSENS:S={mrn{testId}789}                                                          |
      | subject.type                                  | S                                                                                  |
      | associationStart.type                         | STOS                                                                               |
      | associationStart.target.poleId.v2.id          | SNSENS:S={mrn{testId}IN9876{testId}}                                               |
      | associationStart.target.type                  | S                                                                                  |
      | associationStart.timestamp                    | 2022-02-22T22:22:22.222Z                                                           |
      | attributes.attrs.header.ingestDateTime        | 2022-02-22T22:22:22.222Z                                                           |
    And one Event record for "SNS-ASSOC-Send2Cons" with following attributes
      | metadata.identityRecord.poleId.v2.id          | SNSENS:E={[SNSENS:P={Testing,5 Test Street,TE5 1IN{testId},Testville}[SNS-SENDER]][mrn{testId}789][PTOS]} |
      | metadata.identityRecord.type                  | E                                                                                                         |
      | metadata.sourceRecord.name                    | SNSENS                                                                                                    |
      | metadata.sourceRecord.shortName               | SNS                                                                                                       |
      | metadata.sourceRecord.location                | submissionIdmetadata.messageIdentification                                                                |
      | metadata.sourceRecord.id                      | {[SNSENS:P={Testing,5 Test Street,TE5 1IN{testId},Testville}[SNS-SENDER]][mrn{testId}789][PTOS]}          |
      | metadata.sourceRecord.audit.createdBy         | 0123456789                                                                                                |
      | metadata.sourceRecord.audit.createdTimestamp  | 2022-02-22T22:22:22.222Z                                                                                  |
      | metadata.mappingRecord.name                   | SNS-ASSOC-Send2Cons                                                                                       |
      | metadata.mappingRecord.version                | mappingVersion                                                                                            |
      | metadata.complianceRecord.visibility          | UNKNOWN                                                                                                   |
      | metadata.complianceRecord.gscMarker           | null                                                                                                      |
      | metadata.complianceRecord.retentionMarkerDays | -1                                                                                                        |
      | snapshotTrigger                               | null                                                                                                      |
      | type                                          | ASSOCIATION_START                                                                                         |
      | subject.poleId.v2.id                          | SNSENS:P={Testing,5 Test Street,TE5 1IN{testId},Testville}[SNS-SENDER]                                    |
      | subject.type                                  | S                                                                                                         |
      | associationStart.type                         | PTOS                                                                                                      |
      | associationStart.target.poleId.v2.id          | SNSENS:S={mrn{testId}789}                                                                                 |
      | associationStart.target.type                  | S                                                                                                         |
      | associationStart.timestamp                    | 2022-02-22T22:22:22.222Z                                                                                  |
      | attributes.attrs.header.ingestDateTime        | 2022-02-22T22:22:22.222Z                                                                                  |
    And one Event record for "SNS-ASSOC-Doc2Ite" with following attributes
      | metadata.identityRecord.poleId.v2.id          | SNSENS:E={[SNSENS:P=null[{704ABC1234567Englishmrn{testId}}],O={704ABC1234567Englishmrn{testId}}][SNSENS:S={mrn{testId}ITE1234{testId}}][OTOSASSO]} |
      | metadata.identityRecord.type                  | E                                                                                                                                                  |
      | metadata.sourceRecord.name                    | SNSENS                                                                                                                                             |
      | metadata.sourceRecord.shortName               | SNS                                                                                                                                                |
      | metadata.sourceRecord.location                | submissionIdmetadata.messageIdentification                                                                                                         |
      | metadata.sourceRecord.id                      | {[SNSENS:P=null[{704ABC1234567Englishmrn{testId}}],O={704ABC1234567Englishmrn{testId}}][SNSENS:S={mrn{testId}ITE1234{testId}}][OTOSASSO]}          |
      | metadata.sourceRecord.audit.createdBy         | 0123456789                                                                                                                                         |
      | metadata.sourceRecord.audit.createdTimestamp  | 2022-02-22T22:22:22.222Z                                                                                                                           |
      | metadata.mappingRecord.name                   | SNS-ASSOC-Doc2Ite                                                                                                                                  |
      | metadata.mappingRecord.version                | mappingVersion                                                                                                                                     |
      | metadata.complianceRecord.visibility          | UNKNOWN                                                                                                                                            |
      | metadata.complianceRecord.gscMarker           | null                                                                                                                                               |
      | metadata.complianceRecord.retentionMarkerDays | -1                                                                                                                                                 |
      | snapshotTrigger                               | null                                                                                                                                               |
      | type                                          | ASSOCIATION_START                                                                                                                                  |
      | subject.poleId.v2.id                          | SNSENS:P=null[{704ABC1234567Englishmrn{testId}}],O={704ABC1234567Englishmrn{testId}}                                                               |
      | subject.type                                  | O                                                                                                                                                  |
      | associationStart.type                         | OTOSASSO                                                                                                                                           |
      | associationStart.target.poleId.v2.id          | SNSENS:S={mrn{testId}ITE1234{testId}}                                                                                                              |
      | associationStart.target.type                  | S                                                                                                                                                  |
      | associationStart.timestamp                    | 2022-02-22T22:22:22.222Z                                                                                                                           |
      | attributes.attrs.header.ingestDateTime        | 2022-02-22T22:22:22.222Z                                                                                                                           |
    And one Event record for "SNS-ASSOC-Doc2Ite" with following attributes
      | metadata.identityRecord.poleId.v2.id          | SNSENS:E={[SNSENS:P=null[{N704BH-123Germanmrn{testId}}],O={N704BH-123Germanmrn{testId}}][SNSENS:S={mrn{testId}IN9876{testId}}][OTOSASSO]} |
      | metadata.identityRecord.type                  | E                                                                                                                                         |
      | metadata.sourceRecord.name                    | SNSENS                                                                                                                                    |
      | metadata.sourceRecord.shortName               | SNS                                                                                                                                       |
      | metadata.sourceRecord.location                | submissionIdmetadata.messageIdentification                                                                                                |
      | metadata.sourceRecord.id                      | {[SNSENS:P=null[{N704BH-123Germanmrn{testId}}],O={N704BH-123Germanmrn{testId}}][SNSENS:S={mrn{testId}IN9876{testId}}][OTOSASSO]}          |
      | metadata.sourceRecord.audit.createdBy         | 0123456789                                                                                                                                |
      | metadata.sourceRecord.audit.createdTimestamp  | 2022-02-22T22:22:22.222Z                                                                                                                  |
      | metadata.mappingRecord.name                   | SNS-ASSOC-Doc2Ite                                                                                                                         |
      | metadata.mappingRecord.version                | mappingVersion                                                                                                                            |
      | metadata.complianceRecord.visibility          | UNKNOWN                                                                                                                                   |
      | metadata.complianceRecord.gscMarker           | null                                                                                                                                      |
      | metadata.complianceRecord.retentionMarkerDays | -1                                                                                                                                        |
      | snapshotTrigger                               | null                                                                                                                                      |
      | type                                          | ASSOCIATION_START                                                                                                                         |
      | subject.poleId.v2.id                          | SNSENS:P=null[{N704BH-123Germanmrn{testId}}],O={N704BH-123Germanmrn{testId}}                                                              |
      | subject.type                                  | O                                                                                                                                         |
      | associationStart.type                         | OTOSASSO                                                                                                                                  |
      | associationStart.target.poleId.v2.id          | SNSENS:S={mrn{testId}IN9876{testId}}                                                                                                      |
      | associationStart.target.type                  | S                                                                                                                                         |
      | associationStart.timestamp                    | 2022-02-22T22:22:22.222Z                                                                                                                  |
      | attributes.attrs.header.ingestDateTime        | 2022-02-22T22:22:22.222Z                                                                                                                  |
    And one Event record for "SNS-ASSOC-Doc2Ite" with following attributes
      | metadata.identityRecord.poleId.v2.id          | SNSENS:E={[SNSENS:P=null[{714HX-987Frenchmrn{testId}}],O={714HX-987Frenchmrn{testId}}][SNSENS:S={mrn{testId}IN9876{testId}}][OTOSASSO]} |
      | metadata.identityRecord.type                  | E                                                                                                                                       |
      | metadata.sourceRecord.name                    | SNSENS                                                                                                                                  |
      | metadata.sourceRecord.shortName               | SNS                                                                                                                                     |
      | metadata.sourceRecord.location                | submissionIdmetadata.messageIdentification                                                                                              |
      | metadata.sourceRecord.id                      | {[SNSENS:P=null[{714HX-987Frenchmrn{testId}}],O={714HX-987Frenchmrn{testId}}][SNSENS:S={mrn{testId}IN9876{testId}}][OTOSASSO]}          |
      | metadata.sourceRecord.audit.createdBy         | 0123456789                                                                                                                              |
      | metadata.sourceRecord.audit.createdTimestamp  | 2022-02-22T22:22:22.222Z                                                                                                                |
      | metadata.mappingRecord.name                   | SNS-ASSOC-Doc2Ite                                                                                                                       |
      | metadata.mappingRecord.version                | mappingVersion                                                                                                                          |
      | metadata.complianceRecord.visibility          | UNKNOWN                                                                                                                                 |
      | metadata.complianceRecord.gscMarker           | null                                                                                                                                    |
      | metadata.complianceRecord.retentionMarkerDays | -1                                                                                                                                      |
      | snapshotTrigger                               | null                                                                                                                                    |
      | type                                          | ASSOCIATION_START                                                                                                                       |
      | subject.poleId.v2.id                          | SNSENS:P=null[{714HX-987Frenchmrn{testId}}],O={714HX-987Frenchmrn{testId}}                                                              |
      | subject.type                                  | O                                                                                                                                       |
      | associationStart.type                         | OTOSASSO                                                                                                                                |
      | associationStart.target.poleId.v2.id          | SNSENS:S={mrn{testId}IN9876{testId}}                                                                                                    |
      | associationStart.target.type                  | S                                                                                                                                       |
      | associationStart.timestamp                    | 2022-02-22T22:22:22.222Z                                                                                                                |
      | attributes.attrs.header.ingestDateTime        | 2022-02-22T22:22:22.222Z                                                                                                                |
    And one Event record for "SNS-ASSOC-CTral2Ite" with following attributes
      | metadata.identityRecord.poleId.v2.id          | SNSENS:E={[SNSENS:P=null[{trailer102Nationality{testId}mrn{testId}}],O={trailer102Nationality{testId}mrn{testId}}][SNSENS:S={mrn{testId}ITE1234{testId}}][OTOSASSO]} |
      | metadata.identityRecord.type                  | E                                                                                                                                                                    |
      | metadata.sourceRecord.name                    | SNSENS                                                                                                                                                               |
      | metadata.sourceRecord.shortName               | SNS                                                                                                                                                                  |
      | metadata.sourceRecord.location                | submissionIdmetadata.messageIdentification                                                                                                                           |
      | metadata.sourceRecord.id                      | {[SNSENS:P=null[{trailer102Nationality{testId}mrn{testId}}],O={trailer102Nationality{testId}mrn{testId}}][SNSENS:S={mrn{testId}ITE1234{testId}}][OTOSASSO]}          |
      | metadata.sourceRecord.audit.createdBy         | 0123456789                                                                                                                                                           |
      | metadata.sourceRecord.audit.createdTimestamp  | 2022-02-22T22:22:22.222Z                                                                                                                                             |
      | metadata.mappingRecord.name                   | SNS-ASSOC-CTral2Ite                                                                                                                                                  |
      | metadata.mappingRecord.version                | mappingVersion                                                                                                                                                       |
      | metadata.complianceRecord.visibility          | UNKNOWN                                                                                                                                                              |
      | metadata.complianceRecord.gscMarker           | null                                                                                                                                                                 |
      | metadata.complianceRecord.retentionMarkerDays | -1                                                                                                                                                                   |
      | snapshotTrigger                               | null                                                                                                                                                                 |
      | type                                          | ASSOCIATION_START                                                                                                                                                    |
      | subject.poleId.v2.id                          | SNSENS:P=null[{trailer102Nationality{testId}mrn{testId}}],O={trailer102Nationality{testId}mrn{testId}}                                                               |
      | subject.type                                  | O                                                                                                                                                                    |
      | associationStart.type                         | OTOSASSO                                                                                                                                                             |
      | associationStart.target.poleId.v2.id          | SNSENS:S={mrn{testId}ITE1234{testId}}                                                                                                                                |
      | associationStart.target.type                  | S                                                                                                                                                                    |
      | associationStart.timestamp                    | 2022-02-22T22:22:22.222Z                                                                                                                                             |
      | attributes.attrs.header.ingestDateTime        | 2022-02-22T22:22:22.222Z                                                                                                                                             |
    And one Event record for "SNS-ASSOC-CTral2Ite" with following attributes
      | metadata.identityRecord.poleId.v2.id          | SNSENS:E={[SNSENS:P=null[{trailer103Nationality{testId}mrn{testId}}],O={trailer103Nationality{testId}mrn{testId}}][SNSENS:S={mrn{testId}IN9876{testId}}][OTOSASSO]} |
      | metadata.identityRecord.type                  | E                                                                                                                                                                   |
      | metadata.sourceRecord.name                    | SNSENS                                                                                                                                                              |
      | metadata.sourceRecord.shortName               | SNS                                                                                                                                                                 |
      | metadata.sourceRecord.location                | submissionIdmetadata.messageIdentification                                                                                                                          |
      | metadata.sourceRecord.id                      | {[SNSENS:P=null[{trailer103Nationality{testId}mrn{testId}}],O={trailer103Nationality{testId}mrn{testId}}][SNSENS:S={mrn{testId}IN9876{testId}}][OTOSASSO]}          |
      | metadata.sourceRecord.audit.createdBy         | 0123456789                                                                                                                                                          |
      | metadata.sourceRecord.audit.createdTimestamp  | 2022-02-22T22:22:22.222Z                                                                                                                                            |
      | metadata.mappingRecord.name                   | SNS-ASSOC-CTral2Ite                                                                                                                                                 |
      | metadata.mappingRecord.version                | mappingVersion                                                                                                                                                      |
      | metadata.complianceRecord.visibility          | UNKNOWN                                                                                                                                                             |
      | metadata.complianceRecord.gscMarker           | null                                                                                                                                                                |
      | metadata.complianceRecord.retentionMarkerDays | -1                                                                                                                                                                  |
      | snapshotTrigger                               | null                                                                                                                                                                |
      | type                                          | ASSOCIATION_START                                                                                                                                                   |
      | subject.poleId.v2.id                          | SNSENS:P=null[{trailer103Nationality{testId}mrn{testId}}],O={trailer103Nationality{testId}mrn{testId}}                                                              |
      | subject.type                                  | O                                                                                                                                                                   |
      | associationStart.type                         | OTOSASSO                                                                                                                                                            |
      | associationStart.target.poleId.v2.id          | SNSENS:S={mrn{testId}IN9876{testId}}                                                                                                                                |
      | associationStart.target.type                  | S                                                                                                                                                                   |
      | associationStart.timestamp                    | 2022-02-22T22:22:22.222Z                                                                                                                                            |
      | attributes.attrs.header.ingestDateTime        | 2022-02-22T22:22:22.222Z                                                                                                                                            |

# The test below shows that the mapping is incorrect. The Object IDs don't match those created in the Object entities
    And one Event record for "SNS-ASSOC-Veh2Tra" with following attributes
      | metadata.identityRecord.poleId.v2.id          | SNSENS:E={[SNSENS:P=null[{Nationality{testId}vehicle101}],O={Nationality{testId}vehicle101}][SNSENS:P=null[{trailer101Nationality{testId}mrn{testId}}],O={trailer101Nationality{testId}mrn{testId}}][OTOOLINK]} |
      | metadata.identityRecord.type                  | E                                                                                                                                                                                                               |
      | metadata.sourceRecord.name                    | SNSENS                                                                                                                                                                                                          |
      | metadata.sourceRecord.shortName               | SNS                                                                                                                                                                                                             |
      | metadata.sourceRecord.location                | submissionIdmetadata.messageIdentification                                                                                                                                                                      |
      | metadata.sourceRecord.id                      | {[SNSENS:P=null[{Nationality{testId}vehicle101}],O={Nationality{testId}vehicle101}][SNSENS:P=null[{trailer101Nationality{testId}mrn{testId}}],O={trailer101Nationality{testId}mrn{testId}}][OTOOLINK]}          |
      | metadata.sourceRecord.audit.createdBy         | 0123456789                                                                                                                                                                                                      |
      | metadata.sourceRecord.audit.createdTimestamp  | 2022-02-22T22:22:22.222Z                                                                                                                                                                                        |
      | metadata.mappingRecord.name                   | SNS-ASSOC-Veh2Tra                                                                                                                                                                                               |
      | metadata.mappingRecord.version                | mappingVersion                                                                                                                                                                                                  |
      | metadata.complianceRecord.visibility          | UNKNOWN                                                                                                                                                                                                         |
      | metadata.complianceRecord.gscMarker           | null                                                                                                                                                                                                            |
      | metadata.complianceRecord.retentionMarkerDays | -1                                                                                                                                                                                                              |
      | snapshotTrigger                               | null                                                                                                                                                                                                            |
      | type                                          | ASSOCIATION_START                                                                                                                                                                                               |
      | subject.poleId.v2.id                          | SNSENS:P=null[{Nationality{testId}vehicle101}],O={Nationality{testId}vehicle101}                                                                                                                                |
      | subject.type                                  | O                                                                                                                                                                                                               |
      | associationStart.type                         | OTOOLINK                                                                                                                                                                                                        |
      | associationStart.target.poleId.v2.id          | SNSENS:P=null[{trailer101Nationality{testId}mrn{testId}}],O={trailer101Nationality{testId}mrn{testId}}                                                                                                          |
      | associationStart.target.type                  | O                                                                                                                                                                                                               |
      | associationStart.timestamp                    | 2022-02-22T22:22:22.222Z                                                                                                                                                                                        |
      | attributes.attrs.header.ingestDateTime        | 2022-02-22T22:22:22.222Z                                                                                                                                                                                        |
