# fdp-cmd-adaptor-sns changelog

Changelog of fdp-cmd-adaptor-sns.

## 2.8.0 (2026-08-03)

### Other changes


- CST-2301 updates following code review ([d1010](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/d10107daaa11214) Allen Conquest *2026-08-03 13:45:06*)


- CST-2301 update following code review ([5efb2](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/5efb2240205db1a) Allen Conquest *2026-08-03 09:02:43*)


- CST-2301 update E2E tests ([ff52c](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/ff52cd9f609508d) Allen Conquest *2026-07-31 16:44:09*)


- CST-2301 extract container numbers ([0b59b](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/0b59b6611c73714) Allen Conquest *2026-07-31 15:49:02*)


- CST-2301 output warning message and metric when eori number not found in lookup ([03eb9](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/03eb911f4726e5c) Allen *2026-07-28 16:29:26*)


- CST-2301 updated log level to error ([c249e](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/c249ea7031184de) Allen Conquest *2026-07-28 09:48:58*)


- CST-2301 output warning message and metric when eori number not found in lookup ([e6fc2](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/e6fc25e6884990c) Allen Conquest *2026-07-28 08:34:33*)


- CST-2290 implement latest mapping of attributes for Matching ([e1256](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/e12567a8de84a98) Allen *2026-07-27 12:50:43*)


- CST-2158 - Add missing unit tests in SNS Command Adapter ([f6eb4](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/f6eb4b760e8e559) Mohammad Meraj *2026-07-21 10:47:07*)


## 2.7.0 (2026-07-10)

### Other changes


- [CST-2205] SNS-M-Carrier ([24a82](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/24a8215496c6e2c) Deepthy Valsakumaran *2026-07-10 11:26:01*)


## 2.6.0 (2026-07-10)

### Other changes


- feat. CST-2182 Fix party and location data sent to matching ([e65ad](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/e65ad2c861591cd) pastor.juradotraverso *2026-07-10 09:08:49*)


## 2.5.0 (2026-07-09)

### Other changes


- [CST-2191] PWB and SNS CA change - DACC-AVRO version update for Movement Matching ([a5609](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/a5609089dbf5e6f) Deepthy Valsakumaran *2026-07-09 10:54:25*)


## 2.4.1 (2026-07-03)

### Other changes


- CST-2114 Update SNS to use new mapping 1.2.14 ([05680](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/05680afe1fb578e) Allen *2026-07-03 11:44:27*)


- CST-2131; FIX: Added COMPOSE_PARALLEL_LIMIT to 'Kafka & Redis' in .drone.star to control concurrent docker pulls; step pulls in multiple containers which is being throttled by DockerHub ([b897b](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/b897b28f745bc2a) Phan, Michael *2026-07-01 10:44:31*)


## 2.4.0 (2026-06-26)

### Other changes


- CST-2115 remove mapping file ([49aaf](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/49aafba8a6054cb) Allen Conquest *2026-06-26 12:45:23*)


- CST-2115 update aggregators to 10.3.6 ([24ef8](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/24ef88071c279f7) Allen Conquest *2026-06-26 12:30:04*)


- CST-2105 new attribute added for Service Matching ([6e807](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/6e80788d12c1f88) Allen *2026-06-26 12:06:25*)


- CST-2106; FIX: make FDP_APP_MATCHING_SERVICE_ENABLED (matching_service_enabled) configurable, defaulting to false. ([be8cd](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/be8cd024e0e75d2) Phan, Michael *2026-06-25 13:41:02*)


- Normalize whitespace around '/' in registration parsing ([89ab4](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/89ab4c84fa8be7f) d-aktasb *2026-06-25 10:26:23*)


- CST-2072; Adding new consignment and movement matching delta/wash topics and updates to docker-compose.yaml ([4cb36](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/4cb36f078ee30cc) Phan, Michael *2026-06-24 14:34:41*)


- CST-2053 update with new mapping 1.2.9 ([eb042](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/eb042daa9b4a1dc) Allen *2026-06-24 14:23:09*)


- Fix handling of single '/' separator in registration parsing ([dcac5](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/dcac542658386d4) benan *2026-06-24 13:15:20*)


- CST-1972; adding new matching topics to integration tests ([201d2](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/201d2f01e7ef372) Phan, Michael *2026-06-22 13:01:02*)


## 2.3.1 (2026-05-26)

### Bug Fixes

-  CST-1802 improve defensive coding in custom functions ([cb293](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/cb293afd8267dcb) Allen)  

### Other changes


- CST-1802 upgrade pom ([70362](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/70362ba66082d90) Allen Conquest *2026-05-26 08:48:11*)


- Release 7.1.0: dynatrace support ([4fd80](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/4fd80e54ff1ec41) root *2026-02-02 15:37:08*)


## 2.3.0 (2026-02-27)

### Features

-  [CST-1621] S&S release new version of CA using updated mapping ([b2536](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/b25364fa0e8dbf7) Deepthy)  

### Other changes


- CST-1655 remove unused files ([c92c4](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/c92c49fb48ab38a) Allen Conquest *2026-02-26 12:27:51*)


## 2.2.1 (2026-01-16)

### Features

-  CST-1534 fix issues found during QAT testing ([f7f51](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/f7f514cc304c3d7) Allen)  
-  [CST-1521] SNS - update CA to use mapping 1.2.1 ([d817a](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/d817a79203e640f) Deepthy)  

### Other changes


- CST-1503 code clean up and externalisation of eori feed ([d5d22](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/d5d228a719cfaf7) Allen Conquest *2026-01-09 15:32:41*)


## 2.2.0 (2026-01-08)

### Features

-  CST-1450 EORI updates, including E2E tests for EORI and updated additional tests ([b80f7](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/b80f7af5acd7a55) Allen)  
-  CST-1224  getRegistration function and supporting tests updated to... ([af42f](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/af42fe372e89e5c) T Moore)  
-  CST-1350 updated RORO Event E2E Integration Test ([a9c7c](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/a9c7cadd4af6f1a) Terry Moore)  
-  CST-1337 updated Event E2E tests (exc RORO) ([58fc2](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/58fc2acbcd001eb) T Moore)  
-  CST-1345 update location e2e tests ([ebd35](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/ebd3587cafaf5bc) Allen)  
-  CST-1336 resolve issue with mapping enum input data ([ebee3](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/ebee33672876559) Allen)  
-  [CST-1309] SNS Mapping 2.1.4: update feature tests for PARTY pole type ([902e4](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/902e460e2fe6f6c) Deepthy)  
-  CST-1130 relationships feature test updated ([af54b](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/af54b96e549f605) T Moore)  
-  CST-1175 created new custom classes and unit tests ([eb420](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/eb42075f4b833ab) T Moore)  
-  [CST-1309] SNS Mapping 2.1.4: update feature tests for PARTY pole type : Fix ([82b31](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/82b31892bac7b45) Deepthy)  
-  Resolve CST-1309 "Feature/ partytests" ([387d9](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/387d9e43e88662f) Deepthy)  
-  CST-1317 update feature tests for Location entities ([9ead0](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/9ead0e18d45a757) T Moore)  
-  CST-1295 set eori to null in multiple events to work with updated coalesce and existing PV2 keys and values within tests ([dd9d1](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/dd9d1e3c5771402) T Moore)  

### Other changes


- update application.yml config files ([c4338](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/c433807a3ac3518) Allen Conquest *2026-01-08 10:00:28*)


- update sns schema property name to adhere to standard naming convention ([f6489](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/f6489b275db6d87) Allen Conquest *2026-01-08 09:20:38*)


- CST-1379; updating app.py with landing topics for Eori ([0a7c1](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/0a7c12c6203d62a) Phan, Michael *2025-12-11 14:46:39*)


- CST-1400-updated expected entity counts in tests to reflect STOP node update from CST-1393 ([234f4](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/234f4c5208e572d) T Moore *2025-12-05 09:37:08*)


- [CST-1340] SNS Mapping 2.1.4: Add missing Scenarios for PARTY pole type ([d7f0c](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/d7f0cc95e82214a) Deepthy Valsakumaran *2025-11-19 13:04:57*)


- CST-1336 update service feature tests ([331b5](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/331b51e523ae294) Allen Conquest *2025-11-14 15:47:54*)


- CST-1268 updated to use new mapping and dummy lookup classes ([cb252](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/cb252874d288355) Allen *2025-11-13 09:28:03*)


## 2.1.2 (2025-11-11)

### Other changes


- CST-1312 de-duplicate runlog entries ([ac954](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/ac9549d7ebd6934) Allen *2025-11-11 16:08:02*)


## 2.1.1 (2025-10-22)

### Features

-  CST-1246 POM and tests updated to match CST-1243 PWB patch ([58e98](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/58e9806a9448aba) Terry Moore)  

## 2.1.0 (2025-10-16)

### Features

-  [CST-1179] Removed == and replaced string equals ([dba7a](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/dba7a06ebec1933) Deepthy)  
-  CST-1197 add tests for ite2cons ([c9d53](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/c9d53c2c069a99f) Allen)  
-  CST-1196 add tests for CVes2Ite Event ([318ba](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/318bae0888e2c25) Allen)  
-  CST-1206 new feature tests for event sns assoc send2cons ([343d4](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/343d49e765b3c35) T Moore)  
-  [CST-1209] Object SNS-C-TRAILER  tests ([c4148](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/c41480c7280dd3d) Deepthy)  
-  [CST-1205] Location SNS-SENDER-Add topology tests ([0f41d](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/0f41dc34bc462b2) Deepthy)  
-  [CST-1188] Party SNS-SENDER integration tests ([7106b](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/7106b8a3741588f) Deepthy)  
-  CST-1200 fix typo in second event E2E test for SNS-ASSOC-CTral2Ite ([77d54](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/77d54a06100eb91) Terry Moore)  
-  CST-1200 test created and int test updated - passes and builds without error ([a8c68](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/a8c68ab2187ed7e) Terry Moore)  
-  [CST-1188] Party SNS-SENDER feature tests ([4d748](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/4d748bb17f91a65) Deepthy)  
-  CST-1194 add tests for CVeh2Ite Event ([fa8e5](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/fa8e519426b4a2f) Allen Conquest)  
-  CST-1191 add tests for CVeh2Cont Event ([b0d4c](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/b0d4c0278e29f69) Allen)  
-  CST-1190 add tests for CTral2CVeh Event ([ba6ee](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/ba6eebd4001b09d) Allen)  
-  CST-1189 add new service tests for Cont2Ite ([c7303](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/c73037778f32d8c) Allen)  
-  CST-1180 create new service tests ([67882](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/67882be530f8588) Allen)  
-  CST-953 "Feature/ new feature tests object" ([fe544](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/fe54459e85d4004) Allen)  
-  CST-1126 updated E2E_Event - partially working (some tests commented-out).  E2E_Service also updated and working. ([d1dd0](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/d1dd031bdd2d3d2) Terry Moore)  
-  CST-1126 updated E2E_Event and identity value for vehicle/trailer in  sns-multiple.input to work with updated custom ([86b02](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/86b025f3a4d6700) Terry Moore)  
-  CST-1126 merge commit changes from CST-1133 fixes for trailer/vehicle split Feature Test dependencies ([fc90f](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/fc90f39a3a94bb9) Terry Moore)  
-  CST-1133 updated Vehicle.feature and RelationshipsTest.Feature to work with updated TrailerSplit and VehicleSplit logic - all topology tests passed ([56cc8](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/56cc88efdaad17b) Terry Moore)  
-  CST-1133 updated Trailer.feature inc comment-out of one sample registration test value which current logic does not handle - known issue by supplier pending later logic update ([49a35](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/49a3506cf7c9859) Terry Moore)  
-  CST-1133 updated Tra2Cons commenting out test with known error supplier is aware of i.e. spaces in output are blocked by final regex filter (alphanumeric only) ([758ca](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/758ca864fba23bd) Terry Moore)  
-  CST-1138 update runlog integration test ([d5ac8](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/d5ac856d6369b46) Allen)  
-  CST-1134 update party integration tests ([9bdb8](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/9bdb8f4428afab2) Allen)  
-  CST-1132 update location tests ([7cfbf](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/7cfbf62ab14d0ea) Allen)  
-  [CST-1117] Object feature test fixes ([b07b9](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/b07b9b03c51799e) Deepthy)  
-  CST-1133 pom updated with correct vehicle/trailer split custom reference ([c6705](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/c670577d6146913) Terry Moore)  
-  CST-1126 temp update MAX_RETRIES_GET_CONSUMER_RECORDS to 200 to fix FT error ([e7fe8](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/e7fe878e7b4f881) Terry Moore)  
-  CST-1116 updates location feature files ([d5943](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/d5943631ec6e6fe) Allen)  
-  CST-1118 updates to relationship feature file ([96910](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/969106441f84f0b) Allen)  
-  CST-952 Party, Service, Event feature tests all updated and passed ([efae4](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/efae426c0f56445) T Moore)  
-  CST-1061 code tidy: removed redundant imports #2 ([c5307](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/c53077ae4f9236a) Terry Moore)  
-  CST-1061 code tidy: removed redundant imports ([c0745](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/c07451eaccf7388) Terry Moore)  
-  CST-1061 complete customs for 2.1.3 mapping - TrailerSplit and VehicleSplit limited functionality inc handling of multiple spaces and slashes - this a known limitation which will be handled in later release.  Unit tests adapted accordingly. ([cfc1a](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/cfc1a77a23461bd) Terry Moore)  
-  CST-1003 updated code to handle multiple # rule 6 in Vehicle/Trailer split logic (code in Commons) ([4f876](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/4f8764ed1015531) Terry Moore)  
-  CST-1003 added VehicleSplit, TrailerSplit, Commons (code supporting both), and supporting unit tests ([eb40c](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/eb40c5c8f9b6e2f) Terry Moore)  
-  CST-1003 completed ConsignmentNumber custom and supporting unit tests ([7fc5c](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/7fc5c722ddcdba8) Terry Moore)  
-  CST-1003 draft VehicleSplit custom working for first rule with supporting tests ([470b1](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/470b1779af73f66) Terry Moore)  
-  CST-986 fixed typo: renamed countrieOfRouting > countriesOfRouting ([cec1d](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/cec1de2cb92b2ec) Terry Moore)  
-  CST-986 consollidated identityWhitespace2 and identityWhitespace to use same function in pom; removed obsolete documentValueConcat function and dependencies ([04a25](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/04a25f8634d5682) Terry Moore)  
-  CST-986 added 3 x customs + supporting unit tests: CountriesOfRoutingArray, CustomSpecialMentions, OfficeOfSubsequentEntryArray ([ba70a](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/ba70a8948014264) Terry Moore)  
-  CST-948 updated mapping.version to reference latest 1.0.12 release ([13ce2](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/13ce2b89a173a77) Terry Moore)  
-  CST-948 updated dependencies x3 in root pom ([c60e6](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/c60e6ffd6b9cb0e) Terry Moore)  
-  CST-948 fixed case typo on new custom stubs @Component attributes to match function name + small customs edit for IdentityWhitespace + ConsignmentNumber ([8a20a](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/8a20ad86bf84191) Terry Moore)  
-  CST-948 updated mapping.version to latest 1.2.2 schema ([17067](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/1706735309e8194) Terry Moore)  
-  CST-948 initial CA update inc new stub functions - build successful exc test phase i.e. mvn clean install -DskipTests=true ([88fa4](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/88fa4f71ef446f9) Terry Moore)  

### Bug Fixes

-  CST-1187 fix bugs in ConsignmentNumber ([6e5a9](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/6e5a9a35e5c429d) Allen Conquest)  

### Other changes


- fix formatting of feature files ([43c39](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/43c394d9c2a5f81) Allen Conquest *2025-10-16 13:36:29*)


- CST-1204; storing images to artifactory ([8373a](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/8373a1bdc23821d) Phan, Michael *2025-10-15 11:10:17*)


- CST-1176 update integration tests ([561fa](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/561fadceaf35129) Allen *2025-10-10 08:12:05*)


- [CST--1137] SNS Mapping 2.1.3: update integration tests for OBJECT pole type ([2ed1f](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/2ed1ff908a63c7d) Deepthy Valsakumaran *2025-10-09 10:15:01*)


- CST-1126 update event and runlog integration tests ([73d3d](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/73d3dbdc2932e29) Allen Conquest *2025-10-08 11:04:24*)


- Merge remote-tracking branch 'origin/develop' into feature/CST-1133-fix-incorrect-trailer-vehicle-split-reference ([2bc27](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/2bc2755e25ac0f1) Terry Moore *2025-10-03 15:34:35*)


- restore and comment out all event integration tests except first test until passed ([c3234](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/c323457e3a2d580) Terry Moore *2025-10-02 15:02:06*)


- initial commit inc ignore of other tests and temp set of MAX_RETRIES_GET_CONSUMER_RECORDS to 10 ([e6376](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/e63761bc5174dca) Terry Moore *2025-10-02 14:58:09*)


- PM-91941-Optimize-Docker-Compose-File ([1b594](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/1b594ef427aa803) eswar.mittal *2025-09-17 16:37:43*)


- [CST-1067] S&S - enhance monitoring by enabling Dynatrace metrics and spans ([e18d7](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/e18d7a273c2690a) Deepthy *2025-09-17 10:28:35*)


- [CST-1045] getIMONumber ([09757](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/097575fecafd9f5) Deepthy *2025-09-03 09:00:26*)


## 2.0.0 (2025-06-19)

### Features

-  CST-731 update POM to reference latest PWB release version 1.0.11 ([246ac](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/246aca0ec6d8284) Terry Moore)  
-  CST-731 update feature tests for SNS-C-SHIP-ADD to match PWB fix under same ticket ([65613](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/656133d4c6a066d) d-venkats1)  
-  CST-731 update feature tests for SNS-C-SHIP-ADD to match PWB fix under same ticket ([31b9c](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/31b9ce7e2a4180f) Terry Moore)  
-  CST-731 update feature tests for SNS-C-SHIP-ADD to match PWB fix under same ticket ([bb34b](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/bb34b2ca195e0ea) Terry Moore)  
-  CST-705 update topology tests because of changes to SNS-ITEM pole v2 id. ([5c029](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/5c0294e9660ef70) Allen Conquest)  
-  CST-617 update topology test feature files ([d8386](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/d838699511d0f1c) Shanthi)  
-  CST-628 'Optimize Imports' run to clean up imports ([39f8b](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/39f8bf3ce103961) D-Terry Moore)  
-  CST-628 removed redundant SealRecord import ([d4c29](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/d4c29836a0156ae) D-Terry Moore)  
-  CST-628 - updated POM to use latest PWB mapping release 1.0.7 ([e0cbd](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/e0cbd6c9eb7ebd0) Terry Moore)  
-  CST-628 update customs inc unit tests - initial ([36f87](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/36f87c83a0fc08f) Terry Moore)  
-  CST-635 updated POM to use mapping release 1.0.6 (latest in artifactory) ([aeed0](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/aeed0eb326e0023) Terry Moore)  
-  CST-635 Merge branch 'feature/CST-635-update-to-cst-470-mapping' into 'develop' ([245a1](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/245a18b36ad4bcd) T Moore)  
-  CST-635 updated POM to use  mapping release 1.0.7-SNAPSHOT ([76e73](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/76e738db30ff760) Terry Moore)  
-  CST-578 - closing - completed base CMA update inc connectivity to latest mapping and stub lookup functions... ([edb9d](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/edb9ddf1b67614e) T Moore)  
-  CST-578 Merge branch 'feature/CST-578-update-to-cst-470-mapping' into 'develop' ([d5c4a](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/d5c4a68b267cac9) T Moore)  
-  PM-80078 - Implement Changelog ([b78a5](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/b78a571e40a4f44) Milani Murali)  

### Bug Fixes

-  update gitflow configuration to point productionBranch to master (instead of main) ([e707d](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/e707db36b4f7543) Allen Conquest)  

### Other changes


- Merge remote-tracking branch 'origin/feature/CST-731-fix-postCode-mapping' into feature/CST-731-fix-postCode-mapping ([64cb4](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/64cb4686002c4e6) d-venkats1 *2025-06-17 10:37:00*)
-- * # Conflicts:
-- * #	cmd-adaptor-sns-integration-tests/src/test/resources/features/E2E_Location.feature


- Merge remote-tracking branch 'origin/feature/CST-731-fix-postCode-mapping' into feature/CST-731-fix-postCode-mapping ([23f59](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/23f59d913dd04ec) d-venkats1 *2025-06-17 10:36:46*)
-- * # Conflicts:
-- * #	cmd-adaptor-sns-integration-tests/src/test/resources/features/E2E_Location.feature
-- * #	cmd-adaptor-sns/src/test/resources/features/location/CShip-Add.feature


- Merge remote-tracking branch 'origin/feature/CST-731-fix-postCode-mapping' into feature/CST-731-fix-postCode-mapping ([0adc7](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/0adc7f6b1f38630) d-venkats1 *2025-06-17 07:51:42*)
-- * # Conflicts:
-- * #	cmd-adaptor-sns-integration-tests/src/test/resources/features/E2E_Location.feature
-- * #	cmd-adaptor-sns/src/test/resources/features/location/CShip-Add.feature


- CST-704 Added stop nodes and updated feature file name ([8fb40](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/8fb40ec9537e9af) d-venkats1 *2025-06-12 11:44:05*)


- CST-704 Added stop nodes for trailer and Updated SNS-M-CARRIER ([2703a](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/2703a072203be1a) d-venkats1 *2025-06-12 10:21:18*)


- CST-704 Added Updated SNS-M-CARRIER ([09e04](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/09e044a18290f98) d-venkats1 *2025-06-11 11:19:17*)


- CST-704 Added new party mapping ([90354](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/903548bccc4c094) d-venkats1 *2025-06-11 11:00:19*)


- CST-704 Reformatted ([dc2f0](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/dc2f08c6481b1bd) d-venkats1 *2025-06-10 17:21:26*)


- CST-704 Updated Event e2e test ([a39a7](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/a39a7b04ed58165) d-venkats1 *2025-06-10 17:20:42*)


- CST-704 Runlog and service e2e tests are added ([022ba](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/022ba61305de22d) d-venkats1 *2025-06-10 16:57:23*)


- CST-704 Location e2e test is added ([5254a](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/5254a490aeba975) d-venkats1 *2025-06-10 11:08:59*)


- CST-704 Event e2e test is added ([131c3](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/131c3a5a29433da) d-venkats1 *2025-06-10 10:49:03*)


- CST-704 Event in　progress ([53d1e](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/53d1e0cf2a58eae) d-venkats1 *2025-06-09 21:41:12*)


- CST_704 e2e party and Object e2e tests are updated ([de146](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/de14671641cc795) DEV\d-venkats1 *2025-06-09 12:42:44*)


- CST_704 e2e party e2e test is updated ([80edd](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/80eddce122cb8ba) DEV\d-venkats1 *2025-06-09 11:26:27*)


- CST_704 e2e party e2e test is working fine locally ([8e3d2](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/8e3d2c03bfeff15) DEV\d-venkats1 *2025-06-09 05:59:33*)


- CST_704 e2e party tests updated ([8a141](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/8a141e73801f536) DEV\d-venkats1 *2025-06-06 15:25:10*)


- Integration tests are inprogress ([d62a3](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/d62a330c0d85e02) DEV\d-venkats1 *2025-06-06 14:53:38*)


- Integration tests are inprogress ([424d5](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/424d505945618ac) DEV\d-venkats1 *2025-06-06 13:48:17*)


- Integration tests are inprogress ([c6d81](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/c6d815b4fdaf00e) DEV\d-venkats1 *2025-06-06 09:17:20*)


- PM-76663 - OTEL - TracePoleV2IdRecordTransformer changes & Updated to latest dependencies ([f5c0d](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/f5c0ddd5a90ae64) Milani Murali *2024-10-11 07:51:42*)


- releasing next version of reposync including missing PCDP context switches and removal of duplicate topics. Also include Trivy image changes for a fix to applied to consistant CI failures. ([e6f8a](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/e6f8affd6406b61) mhavethan.arunthavalingam *2024-10-07 12:22:31*)


- PM-74532 Update dependencies ([d1afe](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/d1afe87af08824c) pastor.juradotraverso *2024-09-11 10:17:47*)


- PM-74532 Update dependencies ([563a4](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/563a489d154c454) pastor.juradotraverso *2024-09-11 09:14:27*)


- Updated mapping version ([fdcb8](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/fdcb86afaeeb6dd) Milani Murali *2024-05-24 12:21:04*)


- PM-66329 - Update Cmd Adaptor SNS ([be107](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/be1070d33a547ee) Milani Murali *2024-05-23 13:43:26*)


- Update to latest aggregator version ([3b65b](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/3b65bd3b70b1963) Allen *2024-05-08 12:03:05*)


- Enabled disk space and added 10MB threshold, added livenessstate and readinessstate and enabled them to true. added readiness and liveness includes in application.yml ([82bbd](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/82bbd1ec1ea0739) D-Miguel Camilleri *2024-04-03 10:17:09*)


- PM-57881: prefix all Sonarqube repos with "fdp/" ([f6e63](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/f6e6378f9563993) Chris Hilsdon *2024-01-25 16:45:57*)


- PM-53292 Update dependencies. Switch off tracing ([566da](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/566da22768fe501) Pastor *2023-10-27 09:48:00*)


- PM-51234 Update to use OTEL ([5bfe9](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/5bfe9d69a131d85) Pastor *2023-09-19 15:59:13*)


- Apply OTEL to SNS. ([f8882](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/f8882a6262ca035) “Maria *2023-09-19 13:53:23*)


## 1.1.1 (2023-06-16)

### Other changes


- Review changes for pom.xml ([6044c](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/6044c580677644f) Julian Taylor *2023-06-16 10:17:54*)


- PM-44762 Change mapping version to latest ([7ea6f](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/7ea6f6541b28600) Pastor *2023-06-15 14:00:10*)


- PM-44762 Remove input files in features in integration tests ([44461](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/44461007e2f91e8) Pastor *2023-06-13 10:15:49*)


- PM-44762 Remove unused imports ([0b436](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/0b436882762b414) Pastor *2023-06-12 11:48:21*)


- PM-44762 Update to use cloner architecture ([64e97](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/64e97c3c2b9c7bf) Pastor *2023-06-12 11:39:51*)


- PM-44762 Update to use cloner architecture ([e0a12](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/e0a1262e1762f8e) Pastor *2023-06-12 11:39:44*)


- Feature/pm 33452 update to use mapping generator ([19ce5](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/19ce5e1331c505c) Gowri *2023-04-03 17:03:09*)


- Modified feature files and removed the old hashing methods that are no more used ([c8d3f](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/c8d3f3b6f41bbcf) Kranthi Appari *2023-02-10 17:59:33*)


- Updated all the topology and E2E tests to use the HashGenerator for hashing poleV2Id ([3f8a9](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/3f8a935d1256649) Kranthi Appari *2023-02-09 18:37:08*)


- Deleted duplicate bom.version ([50f94](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/50f9499cf01ba81) Kranthi Appari *2023-02-07 10:42:52*)


- Added Relationships feature, modified Integration Steps, updated test-common dependency in pom files. ([3b5a3](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/3b5a31d15102f66) Kranthi Appari *2023-02-06 21:34:13*)


- Downgrade template-lib dependency to 1.2.5 ([da33b](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/da33b5b89f08051) Julian *2022-09-29 13:05:23*)


- PM-32388 - Updated to use RawMessageEncoder for Runlog ([aac12](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/aac12043980dce4) Gowri *2022-09-29 13:03:22*)


- Updated sonar-project.properties ([58489](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/584891895a60f5c) shanthi venkatesh *2022-08-04 09:23:35*)


## 1.1.0 (2022-08-03)

### Bug Fixes

-  Convert FDP_APP_MATCHING_AGGREGATE_TARGET from DELTA to BOTH. ([19c75](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/19c75b8edaf5648) Ben Dalling)  

### Other changes


- 4.7.4 ([609f2](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/609f2aa7c2f15f5) Shaqil Abdullah *2022-07-18 09:55:42*)


- Updated sonar-project.properties ([d6374](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/d63742affddd8ac) Shanthi *2022-07-15 11:22:33*)


- Fixed E2E tests in CD envs ([d1be5](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/d1be5284a5507e7) Julian Taylor *2022-06-24 11:20:08*)


- Feature/pm 23765 ([530b5](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/530b50af2827a09) Jose *2022-06-23 08:44:32*)


## 1.0.1 (2022-06-14)

### Other changes


- Increased number of results polled - events failure in CD ([d07cc](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/d07cc59802d1147) Julian Taylor *2022-06-13 13:56:22*)


- Feature/pm 23049 defect npe ([967d4](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/967d441830ad0a2) Jose *2022-06-09 10:12:07*)


## 1.0.0 (2022-05-30)

### Bug Fixes

-  Set missing env vars in kube env folders ([4658f](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/4658f3d9f45fc9b) Jamie Whittingham)  

### Other changes


- Resolve merge conflict on readme. ([84187](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/84187ff1a02a34a) Jamie Whittingham *2022-05-30 14:54:36*)


- PM-20477 Remove unused classes and snapshot from avro schema version in pom ([35a93](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/35a938d82261739) Pastor *2022-05-27 13:45:40*)


- Update to latest fdp-core 8.0.5-2807 ([21164](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/2116459c0c2cc59) Julian *2022-05-24 13:50:55*)


- Feature/pm 21858 sns update fdp bom ([035d0](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/035d0573178e6d7) Zayn *2022-05-23 16:36:31*)


- PM-20477 Add new separators to split function ([d701a](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/d701a0817beb015) Pastor *2022-05-19 10:34:11*)


- PM-20478 Fix integration test ([7db4d](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/7db4d611b6c9870) Pastor *2022-05-11 16:11:59*)


- PM-20478 Refactor custom function for shipment in service consignment ([386dc](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/386dcbbdf57d991) Pastor *2022-05-11 15:47:45*)


- PM-20477 Update plate splitting function ([2b426](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/2b426507b9a8b7a) Pastor *2022-05-11 09:53:01*)


- cmd-adaptor and topology diagram added into readme file ([9d126](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/9d1269c5799021c) Mohamed AL-Kaisi *2022-04-28 09:14:17*)


- made splitfield private again ([666d4](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/666d4a0abbaf685) Colm Ginty *2022-04-21 16:32:44*)


- added two more trailer extractors ([5f5f2](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/5f5f2af6d9e963a) Colm Ginty *2022-04-21 16:29:57*)


- Add Null checks in isValid methods ([e49b2](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/e49b25fb804ab1e) Pastor *2022-04-08 14:31:37*)


- tidied code better ([36d8a](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/36d8aa4bf324c36) Colm Ginty *2022-04-08 08:27:09*)


- tidied code ([3ac5f](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/3ac5f2aa6b40099) Colm Ginty *2022-04-08 07:57:42*)


- tidied code ([c14a8](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/c14a8205916cfa1) Colm Ginty *2022-04-08 07:56:50*)


- PM-19002 remove placeholder and refactor test ([26040](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/260405c1ed980ee) Pastor *2022-04-07 15:35:21*)


- PM-19002 Add runlog to E2E ([08b6b](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/08b6b894f7bdcd6) Pastor *2022-04-07 14:43:26*)


- fixed object E2E tests ([c5f3e](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/c5f3e7b29bdb2a2) Kranthi Appari *2022-04-06 16:07:23*)


- Modified Object feature files to assert on party.poleId ([f7a75](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/f7a7587c9da0bac) Kranthi Appari *2022-04-06 15:58:37*)


- reverted change to configuration file ([0b7a3](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/0b7a3512e40d05a) Colm Ginty *2022-04-06 15:33:51*)


- updated feature file ([cd8da](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/cd8da25b341b70f) Colm Ginty *2022-04-06 15:02:49*)


- updated value in input file ([c2c0d](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/c2c0d7c61b1d5ef) Colm Ginty *2022-04-06 14:15:52*)


- amedned steps step ([b60cd](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/b60cd2192554b4a) Colm Ginty *2022-04-06 14:02:11*)


- Added E2E Object tests ([4d1da](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/4d1da68b74b974d) Kranthi Appari *2022-04-06 13:19:16*)


- created feature file ([b4b01](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/b4b01869da5ba48) Colm Ginty *2022-04-06 13:15:22*)


- Added assertion in SnsSteps ([11213](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/112132949809035) Kranthi Appari *2022-04-06 11:25:48*)


- PM-19028 Comment out tags to run all tests ([76691](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/766911fec9367df) Pastor *2022-04-06 10:58:56*)


- PM-19028 Change test name ([9848e](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/9848e68c1cc20b9) Pastor *2022-04-06 10:58:34*)


- PM-19028 E2E Event tests ([ae08f](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/ae08f249947d4fd) Pastor *2022-04-06 10:43:23*)


- Added Location E2E feature file, added tag not @E2E in Integration Test ([69880](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/69880a1c125620f) Kranthi Appari *2022-04-06 09:35:12*)


- PM-19002 E2E tests ([7f270](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/7f2705cde4a8dea) Pastor *2022-04-05 18:17:00*)


- Add CI to sns project. ([9b7dc](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/9b7dcd42239ef6c) Shaqil Abdullah *2022-04-05 11:36:22*)


- Deleted the duplicated MainContainerExtractor() ([7805c](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/7805cc64f38807a) Kranthi Appari *2022-04-05 10:33:02*)


- PM-19054 Remove unused parameter ([6209d](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/6209df73d5ed605) Pastor *2022-04-05 10:22:09*)


- Added Main-Container feature file, and refactored Trailer, Vehicle for identity field ([4ba05](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/4ba05a95499d467) Kranthi Appari *2022-04-05 10:21:25*)


- PM-19054 Remove unused parameter ([6d465](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/6d46576222b2eec) Pastor *2022-04-05 10:20:37*)


- PM-19054 Veh2Tra integration tests ([cd3bc](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/cd3bc966f67ab74) Pastor *2022-04-05 10:15:45*)


- PM-19045 CNot2Con integration tests ([5e373](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/5e3734c6933d760) Pastor *2022-04-05 09:28:31*)


- PM-19050 Mov2Con integration tests ([620b8](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/620b89bb82acb65) Pastor *2022-04-05 08:51:49*)


- Modified extractor to add the identity condition, refactored the feature files ([825b7](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/825b7daebd509e6) Kranthi Appari *2022-04-05 08:44:38*)


- PM-19050 Dec2Mov integration tests ([fa7b9](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/fa7b9935da76daf) Pastor *2022-04-05 08:24:55*)


- PM-19052 Veh2Mov integration tests ([bea33](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/bea33de089a1632) Pastor *2022-04-04 16:28:10*)


- fixed order of params ([fc267](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/fc267e2f56fc68a) Colm Ginty *2022-04-04 16:23:35*)


- Refactor stop nodes and tests ([51b85](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/51b85f8c5d2acff) Pastor *2022-04-04 16:11:53*)


- Change constant name to be more explicit ([bcec3](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/bcec337f0c76787) Pastor *2022-04-04 15:58:25*)


- PM-19056 add stops and test for stop nodes ([e61b7](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/e61b7bfba64e762) Pastor *2022-04-04 15:50:47*)


- tidied code ([cae1d](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/cae1dfa4fe58152) Colm Ginty *2022-04-04 15:44:34*)


- tidid code ([9d4c0](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/9d4c0cb5b6e68a7) Colm Ginty *2022-04-04 15:38:39*)


- PM-19039 Assoc-MCon2Con event integration tests ([2d7dd](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/2d7dd2bef60cea9) Pastor *2022-04-04 15:31:32*)


- Modified SnsSteps in the integration tests module ([1004f](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/1004fdcf9c7b0ce) Kranthi Appari *2022-04-04 15:24:31*)


- fixed stop checks ([931fe](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/931fe823c80397b) Colm Ginty *2022-04-04 13:57:11*)


- fixed stop checks ([a94a3](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/a94a3c0e191d4ed) Colm Ginty *2022-04-04 13:56:07*)


- added attributes and stop conditions ([ca596](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/ca596c90ad91af4) Colm Ginty *2022-04-04 13:48:22*)


- created extractor ([08e45](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/08e455af6558c90) Colm Ginty *2022-04-04 13:02:03*)


- PM-19056 Assoc-Tra2Mov event integration tests. Waiting for stop nodes ([263ed](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/263ed4a1c92a964) Pastor *2022-04-04 12:59:40*)


- PM-19042 Assoc-MNot2Con event integration tests ([3cdbb](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/3cdbb9836a17237) Pastor *2022-04-04 11:11:19*)


- Added stopNode ([bce1c](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/bce1ce923308819) Kranthi Appari *2022-04-04 11:04:48*)


- ran sonarlint ([17bec](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/17bec3e8edb36b2) Colm Ginty *2022-04-04 10:57:13*)


- tidied code ([f40d9](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/f40d9c13c14f137) Colm Ginty *2022-04-04 10:57:12*)


- replaced nulls with getconsignmentid ([f26b2](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/f26b2e526103bf7) Colm Ginty *2022-04-04 10:56:27*)


- fixed code that broke after rebase ([d0a49](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/d0a49c10e2d5266) Colm Ginty *2022-04-04 10:56:27*)


- deriving the consignee correctly ([cbff2](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/cbff2455f4a3aa7) Colm Ginty *2022-04-04 10:56:27*)


- added extractor ([972ee](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/972eeeb8dbd12fd) Colm Ginty *2022-04-04 10:56:27*)


- began building extractor ([0afa0](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/0afa0f73f99f20f) Colm Ginty *2022-04-04 10:56:27*)


- Added CNotify-Add multiple feature file, added stopNode in all the feature files ([652c0](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/652c09843f8067e) Kranthi Appari *2022-04-04 10:38:30*)


- Renamed CNotify Extractor, added feature file and added CNotify in LocationTupleCommandBuilder. ([7d9c0](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/7d9c01616349d6e) Kranthi Appari *2022-04-04 09:58:16*)


- PM-19023 PM-19024 Update methods after develop rebase ([7176c](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/7176c3d15300aa8) Pastor *2022-04-04 09:54:29*)


- PM-19023 PM-19024 Veh2Mov, Veh2Tra event builders ([e0bf1](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/e0bf1fa5b05aa31) Pastor *2022-04-04 09:54:26*)


- PM-19034 Assoc-CShi2Con event integration tests ([918ad](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/918adebbcc8e65a) Pastor *2022-04-04 09:53:37*)


- PM-19040 Assoc-Rep2Mov event integration tests ([f4215](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/f421580522f4bf2) Pastor *2022-04-04 09:14:17*)


- Merge remote-tracking branch 'origin/feature/PM-18974_create_location_c_notify_add_builder' into feature/PM-18997-Location_C-Notify-Add_integration_test ([d60cb](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/d60cb5c57835b5c) Kranthi Appari *2022-04-03 14:22:53*)
-- * # Conflicts:
-- * #	cmd-adaptor-sns/src/main/java/uk/gov/ho/dacc/fdp/builder/location/LocationTupleCommandBuilder.java


- Added DeclarantAdd feature file ([92e3a](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/92e3a5cb302a686) Kranthi Appari *2022-04-03 14:19:46*)


- Added MConsAddExtractor to LocationCommandBuilder. ([8050b](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/8050b2ac386608e) Kranthi Appari *2022-04-03 14:03:07*)


- PM-18971 Update methods after develop rebase. Update declarant in extractor ([46281](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/46281dbfca6c147) Pastor *2022-04-01 19:35:44*)


- PM-19020 PM-19021 Update methods after develop rebase ([9330a](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/9330a8130f8b287) Pastor *2022-04-01 19:12:57*)


- PM-19019 Update methods after develop rebase ([62cb1](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/62cb13f2951e5fe) Pastor *2022-04-01 19:06:28*)


- PM-19018 Update methods after develop rebase ([d6f89](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/d6f899e6e1f669f) Pastor *2022-04-01 19:02:25*)


- PM-19012 Update methods after develop rebase ([cd0f8](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/cd0f88de60ce9ef) Pastor *2022-04-01 18:49:41*)


- PM-19032 Update methods after develop rebase ([f180a](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/f180ad49b7410d7) Pastor *2022-04-01 18:44:29*)


- PM-18993 Add runlog. Update methods after develop rebase ([15bfd](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/15bfda910f84e0f) Pastor *2022-04-01 18:30:14*)


- Added CShip-Add feature file,s added in location assertions, refactored extractor ([f298a](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/f298a7ec56aec6b) Kranthi Appari *2022-04-01 17:56:18*)


- Update methods after develop rebase ([4e3a4](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/4e3a41038e91c48) Pastor *2022-04-01 17:40:31*)


- PM-19033 Add MShi2Con event integration tests ([adc1e](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/adc1ea275024791) Pastor *2022-04-01 17:32:54*)


- Added MCons-Add feature file, added in location assertions, refactored extractor ([06b8c](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/06b8c38bf94e125) Kranthi Appari *2022-04-01 17:22:00*)


- PM-18890 Update refactored methods ([c7d6e](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/c7d6e09897d994f) Pastor *2022-04-01 17:00:00*)


- Merge remote-tracking branch 'origin/feature/PM-18993_create_location_m_cons_add_builder' into feature/PM-19010-Location_M-Cons-Add_int_test ([3359b](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/3359b3ba5f49754) Kranthi Appari *2022-04-01 16:25:13*)
-- * # Conflicts:
-- * #	cmd-adaptor-sns/src/main/java/uk/gov/ho/dacc/fdp/builder/location/LocationCommandBuilder.java


- PM-19051 Event Cont2Mov integration tests ([dedaa](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/dedaa3a65027015) Pastor *2022-04-01 16:03:00*)


- Added MShip-Add feature file, added in location assertions, refactored extractor ([125b2](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/125b2a2908ea88d) Kranthi Appari *2022-04-01 15:40:09*)


- Merge remote-tracking branch 'origin/feature/PM-18989_create_location_m_ship_add_builder' into feature/PM-19000_Location_M-Ship-Add_Int_Test ([7b5d4](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/7b5d43a00611d2b) Kranthi Appari *2022-04-01 15:33:26*)


- Added MNotify in location assertions, refactored extractor ([4f265](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/4f26521000988cd) Kranthi Appari *2022-04-01 15:26:17*)


- built extractor ([0df03](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/0df03bc3e50891f) Colm Ginty *2022-04-01 15:19:37*)


- Merge remote-tracking branch 'origin/feature/PM-18986_create_location_m_notify_add_builder' into feature/PM-18998-Location_M-Notify_Test ([2c94a](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/2c94ae525b915ca) Kranthi Appari *2022-04-01 15:17:45*)
-- * # Conflicts:
-- * #	cmd-adaptor-sns-common/src/main/java/uk/gov/ho/dacc/fdp/factory/SnsConstants.java
-- * #	cmd-adaptor-sns-test-common/src/main/java/uk/gov/ho/dacc/fdp/assertions/ObjectAssertions.java


- Added MNotify feature file ([6a16b](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/6a16b5d1a7ca0fb) Kranthi Appari *2022-04-01 15:15:30*)


- created extractor ([2e995](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/2e9954db26ba188) Colm Ginty *2022-04-01 14:57:40*)


- PM-19036 Change pole type in test ([4afa7](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/4afa72d51452e19) Pastor *2022-04-01 14:50:23*)


- got tests passing ([8692c](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/8692cc1025146cd) Colm Ginty *2022-04-01 14:48:15*)


- Fixed stop conditions ([53e9b](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/53e9b3e8bc7aeed) Kranthi Appari *2022-04-01 14:42:01*)


- Fixed stop conditions ([0a5a8](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/0a5a8339f22175f) Kranthi Appari *2022-04-01 14:36:32*)


- PM-19036 CCon2Con Event integration tests ([b4a0c](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/b4a0ca9434640e3) Pastor *2022-04-01 14:17:35*)


- importing util methods ([19154](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/19154287002fb42) Colm Ginty *2022-04-01 13:45:19*)


- added constant ([16f6e](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/16f6e0bda33e353) Colm Ginty *2022-04-01 13:44:10*)


- updated movement extractor ([ad569](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/ad56904527f2ada) Colm Ginty *2022-04-01 13:43:17*)


- tidied code ([252f1](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/252f1fbfc11bfaf) Colm Ginty *2022-04-01 13:39:02*)


- tidied code ([b5db0](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/b5db0aa2ff63f4c) Colm Ginty *2022-04-01 13:21:50*)


- Fixed CCons-add single and multiple tests ([279dd](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/279dd0828bb3242) Kranthi Appari *2022-04-01 12:25:55*)


- Added Stop scenarios, added createHash in extractor. ([a2e31](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/a2e31a4743d2ef0) Kranthi Appari *2022-04-01 11:50:55*)


- Fix constant in EventTransformer ([2f2c1](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/2f2c1b23c8a5247) Pastor *2022-04-01 11:04:23*)


- Refactor assertions ([ef2bb](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/ef2bba51d808684) Pastor *2022-04-01 08:53:21*)


- updated role code ([d2547](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/d254775a28f5ca7) Colm Ginty *2022-04-01 08:14:25*)


- PM-19020 PM-19021 Dec2Mov, Mov2Con event builders ([a0d28](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/a0d28a5ebb662fc) Pastor *2022-03-31 18:22:26*)


- PM-19019 CNot2Con event builder ([d98c9](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/d98c9f8db826219) Pastor *2022-03-31 17:10:29*)


- Modified LocationAssertions ([4624c](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/4624c41857bb8d3) Kranthi Appari *2022-03-31 16:02:16*)


- created builder ([30a3c](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/30a3ca94a183b4e) Colm Ginty *2022-03-31 14:38:58*)


- Added CCons-Add-Multiple feature file ([df208](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/df208b5b56ef652) Kranthi Appari *2022-03-31 14:31:26*)


- refactored method to return hashes ([0a00f](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/0a00fb148e6cb37) Colm Ginty *2022-03-31 13:46:42*)


- Added CConsAdd location feature file and assertions. Modified extractor to get the partyHash. ([a10b3](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/a10b3cc0eda3851) Kranthi Appari *2022-03-31 13:34:13*)


- removed value. from attribute constant ([87f3d](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/87f3db1ad90a931) Colm Ginty *2022-03-31 12:24:21*)


- removed value. from attribute constant ([f6351](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/f6351cf8e11dafb) Colm Ginty *2022-03-31 12:22:20*)


- Modified attribute key in feature ([9c6ee](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/9c6ee376ab8353d) Kranthi Appari *2022-03-31 11:14:09*)


- fixed misuse of delimiters ([06338](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/06338c72a518f44) Colm Ginty *2022-03-31 10:42:07*)


- Added delimiter parameter for fullAddress in builder ([5a8c9](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/5a8c9efbbce13ae) Kranthi Appari *2022-03-31 10:31:34*)


- setting representative to consignor ([22965](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/22965c2fcfa9a52) Colm Ginty *2022-03-31 09:43:17*)


- Added event, location and object assertions ([7a5c7](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/7a5c7bcd271bc3a) Kranthi Appari *2022-03-31 09:39:49*)


- tidied code ([ba021](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/ba02159ed5bdb1e) Colm Ginty *2022-03-31 09:38:09*)


- Tidied ObjectAssertions ([d91bd](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/d91bd2df5ebc5b3) Kranthi Appari *2022-03-30 21:30:15*)


- Added Object-Trailer feature file ([bafc3](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/bafc3efecfd2894) Kranthi Appari *2022-03-30 20:55:24*)


- Tidied Location assertions ([8fae7](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/8fae7557fe1a281) Kranthi Appari *2022-03-30 15:52:18*)


- no longer using a generic parameter for service extractor interface ([7f2c2](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/7f2c2566cdad0ae) Colm Ginty *2022-03-30 15:34:36*)


- improved movement extractor ([7a6c1](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/7a6c126e5df5f5c) Colm Ginty *2022-03-30 15:27:49*)


- Added Location-Rep-Add feature file and LocationAssertions ([4a8a8](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/4a8a8dd2db02336) Kranthi Appari *2022-03-30 14:42:27*)


- using consignee instead of representative ([6f9fd](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/6f9fd8fe4f56aaa) Colm Ginty *2022-03-30 14:01:54*)


- built extractor ([93699](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/936994a7ad7b8f8) Colm Ginty *2022-03-30 13:59:39*)


- built extractor ([2e24a](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/2e24a0a2fcfe1df) Colm Ginty *2022-03-30 13:09:49*)


- further building our of extractor ([a3024](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/a30249584438ef4) Colm Ginty *2022-03-30 13:07:38*)


- began creating extractor ([e7f0a](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/e7f0abd76db4a77) Colm Ginty *2022-03-30 12:51:25*)


- removed rogue extractor ([9b1b3](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/9b1b31cb2513562) Colm Ginty *2022-03-30 11:30:45*)


- getting the consignee correctly ([604a4](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/604a43bf1ed9e03) Colm Ginty *2022-03-30 11:21:47*)


- created extractor ([d2436](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/d24365c2b418f49) Colm Ginty *2022-03-30 11:02:46*)


- Changed MOVEMENT_TYPE to get the value from uk.gov.ho.dacc.pole.reference.service.PRE_LOAD ([b113e](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/b113e54b7e9c700) Kranthi Appari *2022-03-30 10:47:08*)


- Changed modeOfTransport in sns.input file from 1 to 2 ([25415](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/25415e3e648011e) Kranthi Appari *2022-03-30 10:30:35*)


- Added Consignment and Movement feature files ([de5c9](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/de5c923b257686d) Kranthi Appari *2022-03-30 10:02:15*)


- created extractor class ([3700b](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/3700b7bfff30779) Colm Ginty *2022-03-30 08:59:14*)


- built extractor ([ac134](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/ac1342b0f8bf143) Colm Ginty *2022-03-29 16:00:27*)


- built extractor ([e4a7f](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/e4a7f2858b62c97) Colm Ginty *2022-03-29 13:55:20*)


- finished extractor ([d6c4a](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/d6c4a8a9a2dcd66) Colm Ginty *2022-03-29 09:38:56*)


- started creating extractor ([93fc3](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/93fc3452a61c81e) Colm Ginty *2022-03-29 08:47:48*)


- updated splitfield tests ([614ac](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/614ac1d0530d1ab) Colm Ginty *2022-03-28 16:28:52*)


- added isValid method ([58404](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/58404014fe43840) Colm Ginty *2022-03-28 15:48:12*)


- built builder ([b2c76](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/b2c76459ed39713) Colm Ginty *2022-03-28 15:44:54*)


- tidied code ([d9714](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/d97148af7f7c086) Colm Ginty *2022-03-28 14:11:34*)


- tidied code ([0697e](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/0697eef426b95ae) Colm Ginty *2022-03-28 14:07:52*)


- created extractor ([581ab](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/581ab88802ed828) Colm Ginty *2022-03-28 13:58:37*)


- tidied code ([a571a](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/a571a8bf879a729) Colm Ginty *2022-03-28 12:58:51*)


- tidied code ([d51fb](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/d51fba2b4922a5e) Colm Ginty *2022-03-28 12:51:49*)


- tidied code ([36a3e](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/36a3e39a11e9537) Colm Ginty *2022-03-28 12:42:28*)


- Added custom scenario in feature file, added splitField in ObjectAssertions ([2f980](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/2f980d06f441fe7) Kranthi Appari *2022-03-24 18:01:49*)


- Added SNS-Vehicle feature file and Object Assertions. ([85067](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/850678ebb3ff918) Kranthi Appari *2022-03-24 16:21:29*)


- Change location conditions to or ([632b5](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/632b5af15600e31) Pastor *2022-03-24 11:38:35*)


- Feature/pm 18992 c cons add location builder ([3b98f](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/3b98fd56b430150) Pastor *2022-03-24 10:16:44*)


- Pm 19011 assoc m shi2 con event builder ([30f5b](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/30f5b3c86f3a734) Pastor *2022-03-24 10:13:45*)


- PM-18977 PM-18987 PM-18984 PM-19044 PM-18979 PM-19037 PM-18981 PM-19038 PM-18978 PM-18988 PM-18982 PM-19041 Create Parties and add integration tests for Declarant, M-Consignee, M-Notify, M-Shipper, C-Notify and C-Shipper ([f979a](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/f979a0a02c1bca8) Pastor *2022-03-24 10:07:09*)


- Update builder to use a common constant ([4f469](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/4f469957a7b3d35) Pastor *2022-03-24 09:52:39*)


- tidied code ([5e84b](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/5e84b91445c9bfc) Colm Ginty *2022-03-24 09:36:25*)


- fixed points from MR ([1447b](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/1447b269a388bbc) Colm Ginty *2022-03-24 09:33:50*)


- PM-19022 ASSOC-Cont2Mov Event builder ([141ce](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/141cead8849fb29) Pastor *2022-03-23 14:55:44*)


- tidied code ([68e4d](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/68e4d2ed9b79805) Colm Ginty *2022-03-23 14:41:16*)


- fixed code ([ef26e](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/ef26e0cf84479ff) Colm Ginty *2022-03-23 13:51:18*)


- plugged object transformer into adaptor service ([f6580](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/f6580b75d4b5c77) Colm Ginty *2022-03-23 13:50:12*)


- created object transformer ([5a88d](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/5a88dac422f29e5) Colm Ginty *2022-03-23 13:47:34*)


- adding final mappings ([32923](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/329235d0eecde78) Colm Ginty *2022-03-23 13:45:20*)


- passing list to custom function ([cc362](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/cc362933e8f4148) Colm Ginty *2022-03-23 13:44:47*)


- added tests for util function ([9be4d](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/9be4d55e4c96ed6) Colm Ginty *2022-03-23 13:44:47*)


- created ObjectCommandBuilder ([98c93](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/98c93f36c248f9f) Colm Ginty *2022-03-23 13:44:47*)


- beginning to build out the vehicle extractor ([7d1bf](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/7d1bfffcf5efbc9) Colm Ginty *2022-03-23 13:44:47*)


- PM-19011 ASSOC-MShi2Con Event builder ([ee611](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/ee611ecd7dd6f75) Pastor *2022-03-23 11:03:55*)


- Pm 18967 rep add location builder ([72a4f](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/72a4fa86fba0ecc) Pastor *2022-03-22 18:09:50*)


- PM-18892 create location C-Cons-Add builder ([b7795](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/b7795fab1e9ea6c) Pastor *2022-03-22 18:00:59*)


- PM-18976 Refactor constant value ([0c476](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/0c476482199e0a2) Pastor *2022-03-22 17:14:21*)


- PM-18976 Remove unused transformer ([3595a](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/3595a2986de0f09) Pastor *2022-03-22 17:11:47*)


- PM-18976 Location Rep-Add builder ([790e1](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/790e1e9f106acac) Pastor *2022-03-22 17:08:28*)


- Pm 18976 create party representative ([a6284](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/a6284ff09ece68d) Pastor *2022-03-22 16:12:15*)


- PM-18976 Location Rep-Add builder ([8be17](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/8be171197c3b10c) Pastor *2022-03-22 16:06:34*)


- Pull service changes ([f342f](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/f342f24c205ea7b) Pastor *2022-03-22 13:09:10*)


- Change service tests ([01971](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/01971f471c8b139) Pastor *2022-03-22 11:06:42*)


- Add multiple array test ([fcd3e](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/fcd3e2de00298f8) Pastor *2022-03-22 09:34:07*)


- Fixed poleV2Id and SourceRecordId assertions. ([5872d](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/5872d3ad81dc164) Kranthi Appari *2022-03-21 19:01:27*)


- First tests passing ([21928](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/2192859d47dca8d) Pastor *2022-03-21 17:47:16*)


- Refactor getShipmentReference to return reference ([51746](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/51746060a7a022a) Pastor *2022-03-21 17:02:24*)


- PM-18976 PM-18983 Representative and C-Consignee builders. Add some basic testing ([6edbb](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/6edbb5a6d7c4882) Pastor *2022-03-21 16:57:05*)


- Added Service Assertions and constants ([52ff5](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/52ff54b122b60e8) Kranthi Appari *2022-03-21 16:49:52*)


- Bug solved in topology ([15916](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/15916a01b68f65a) Pastor *2022-03-21 11:36:55*)


- using service serdes ([be7cf](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/be7cf0206d0f2fd) Colm Ginty *2022-03-21 11:03:52*)


- PM-19060 Add types to AvroObjectBuilder ([8bf31](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/8bf3129e46f2687) Pastor *2022-03-18 10:46:45*)


- updated value of attribute key ([8f88a](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/8f88a200dbb5e18) Colm Ginty *2022-03-17 16:56:35*)


- tidied code ([62f4c](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/62f4c75b484fb3e) Colm Ginty *2022-03-17 16:51:45*)


- extracting seals records from cdlz record and forwarding to topic ([adc90](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/adc90bc2c52c0dc) Colm Ginty *2022-03-17 16:20:43*)


- first pass at movementextractor ([b17e0](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/b17e0730b8a82b5) Colm Ginty *2022-03-17 16:14:52*)


- PM-18976 Create Party Representative & CConsignee builders. First approach ([f70c6](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/f70c68dc57f85bf) Pastor *2022-03-17 15:27:56*)


- Modified SnsConstants and consignment feature file ([ad04a](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/ad04a9e628bc8a5) Kranthi Appari *2022-03-17 14:11:56*)


- Added input file and Consignment feature file. ([74b3c](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/74b3c570f807b50) Kranthi Appari *2022-03-17 13:33:10*)


- PM-19058 Refactor getPoleV2Id and change variable name in isValid ([f35e9](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/f35e9e562da7e0f) Pastor *2022-03-17 10:39:46*)


- PM-19058 Correct raw use of parameterized class linting errors ([19fcb](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/19fcba54e7c9dd5) Pastor *2022-03-17 08:58:54*)


- PM-19058 Create valuemapper and tuples for adaptor. Add runlog. Create service consignment builder ([e75ee](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/e75ee18ed739b00) Pastor *2022-03-16 18:03:42*)


- using cerberus property versions ([0b098](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/0b098bba822edd3) Colm Ginty *2022-03-16 16:50:26*)


- updated maven plugin config ([d9733](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/d97336c21ce3383) Colm Ginty *2022-03-16 15:57:43*)


- removed schema mappings directory ([1b219](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/1b219396684e582) Colm Ginty *2022-03-16 15:56:05*)


- updating dependency versions in root pom ([8c234](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/8c2346a59a8c990) Colm Ginty *2022-03-16 15:54:44*)


- added gitignore ([95bab](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/95babfe1598dfca) Colm Ginty *2022-03-15 11:44:25*)


- git initial build passing ([5f28b](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/5f28bff47d11e83) Colm Ginty *2022-03-15 11:38:12*)


- Initial commit ([8a673](https://gitlab.digital.homeoffice.gov.uk/dacc-aws/fdp-cmd-adaptor-sns/commit/8a6730ede0f0814) Shaqil *2021-12-06 15:28:28*)


