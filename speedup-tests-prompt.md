+ trivy image --exit-code 0 --no-progress docker-compose-command-adaptor:latest --severity CRITICAL,HIGH --ignore-unfixed --db-repository  acp-zot-helm.acp-zot.svc.cluster.local/ecr/aquasecurity/trivy-db --java-db-repository acp-zot-helm.acp-zot.svc.cluster.local/ecr/aquasecurity/trivy-java-db
2026-08-13T20:58:55Z	INFO	Adding schema version to the DB repository for backward compatibility	repository="acp-zot-helm.acp-zot.svc.cluster.local/ecr/aquasecurity/trivy-db:2"
2026-08-13T20:58:55Z	INFO	Adding schema version to the DB repository for backward compatibility	repository="acp-zot-helm.acp-zot.svc.cluster.local/ecr/aquasecurity/trivy-java-db:1"
2026-08-13T20:58:55Z	INFO	[vulndb] Need to update DB
2026-08-13T20:58:55Z	INFO	[vulndb] Downloading vulnerability DB...
2026-08-13T20:58:55Z	INFO	[vulndb] Downloading artifact...	repo="acp-zot-helm.acp-zot.svc.cluster.local/ecr/aquasecurity/trivy-db:2"
2026-08-13T20:59:00Z	INFO	[vulndb] Artifact successfully downloaded	repo="acp-zot-helm.acp-zot.svc.cluster.local/ecr/aquasecurity/trivy-db:2"
2026-08-13T20:59:00Z	INFO	[vuln] Vulnerability scanning is enabled
2026-08-13T20:59:00Z	INFO	[secret] Secret scanning is enabled
2026-08-13T20:59:00Z	INFO	[secret] If your scanning is slow, please try '--scanners vuln' to disable secret scanning
2026-08-13T20:59:00Z	INFO	[secret] Please see https://trivy.dev/docs/v0.72/guide/scanner/secret#recommendation for faster secret detection
2026-08-13T20:59:08Z	INFO	[javadb] Downloading Java DB...
2026-08-13T20:59:08Z	INFO	[javadb] Downloading artifact...	repo="acp-zot-helm.acp-zot.svc.cluster.local/ecr/aquasecurity/trivy-java-db:1"
2026-08-13T20:59:09Z	INFO	[python] Licenses acquired from one or more METADATA files may be subject to additional terms. Use `--debug` flag to see all affected packages.
2026-08-13T20:59:27Z	INFO	[javadb] Artifact successfully downloaded	repo="acp-zot-helm.acp-zot.svc.cluster.local/ecr/aquasecurity/trivy-java-db:1"
2026-08-13T20:59:27Z	INFO	[javadb] Java DB is cached for 3 days. If you want to update the database more frequently, "trivy clean --java-db" command clears the DB cache.
2026-08-13T20:59:30Z	INFO	Detected OS	family="amazon" version="2023.12.20260727 (Amazon Linux)"
2026-08-13T20:59:30Z	INFO	[amazon] Detecting vulnerabilities...	os_version="2023" pkg_num=142
2026-08-13T20:59:30Z	INFO	Number of language-specific files	num=2
2026-08-13T20:59:30Z	INFO	[gobinary] Detecting vulnerabilities...
2026-08-13T20:59:30Z	INFO	[jar] Detecting vulnerabilities...
2026-08-13T20:59:30Z	WARN	Using severities from other vendors for some vulnerabilities. Read https://trivy.dev/docs/v0.72/guide/scanner/vulnerability#severity-selection for details.
2026-08-13T20:59:30Z	INFO	Table result includes only package filenames. Use '--format json' option to get the full path to the package file.
2026-08-13T20:59:30Z	INFO	Some vulnerabilities have been ignored/suppressed. Use the "--show-suppressed" flag to display them.

Report Summary

┌────────────────────────────────────────────────────────────────────────────────┬──────────┬─────────────────┬─────────┐
│                                     Target                                     │   Type   │ Vulnerabilities │ Secrets │
├────────────────────────────────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ docker-compose-command-adaptor:latest (amazon 2023.12.20260727 (Amazon Linux)) │  amazon  │       15        │    -    │
├────────────────────────────────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ local/cmd-adaptor-sns-exec.jar                                                 │   jar    │       31        │    -    │
├────────────────────────────────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ local/opentelemetry-javaagent.jar                                              │   jar    │        4        │    -    │
├────────────────────────────────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ usr/local/bin/envconsul                                                        │ gobinary │       56        │    -    │
└────────────────────────────────────────────────────────────────────────────────┴──────────┴─────────────────┴─────────┘
Legend:
- '-': Not scanned
- '0': Clean (no security findings detected)


For OSS Maintainers: VEX Notice
--------------------------------
If you're an OSS maintainer and Trivy has detected vulnerabilities in your project that you believe are not actually exploitable, consider issuing a VEX (Vulnerability Exploitability eXchange) statement.
VEX allows you to communicate the actual status of vulnerabilities in your project, improving security transparency and reducing false positives for your users.
Learn more and start using VEX: https://trivy.dev/docs/v0.72/guide/supply-chain/vex/repo#publishing-vex-documents

To disable this notice, set the TRIVY_DISABLE_VEX_NOTICE environment variable.


docker-compose-command-adaptor:latest (amazon 2023.12.20260727 (Amazon Linux))
==============================================================================
Total: 15 (HIGH: 15, CRITICAL: 0)

┌────────────────┬────────────────┬──────────┬────────┬──────────────────────────┬──────────────────────────┬────────────────────────────────────────────────────────────┐
│    Library     │ Vulnerability  │ Severity │ Status │    Installed Version     │      Fixed Version       │                           Title                            │
├────────────────┼────────────────┼──────────┼────────┼──────────────────────────┼──────────────────────────┼────────────────────────────────────────────────────────────┤
│ gawk           │ CVE-2026-40467 │ HIGH     │ fixed  │ 5.1.0-3.amzn2023.0.3     │ 5.1.0-3.amzn2023.0.4     │ gawk: gawk: Denial of Service due to Use After Free        │
│                │                │          │        │                          │                          │ vulnerability in...                                        │
│                │                │          │        │                          │                          │ https://avd.aquasec.com/nvd/cve-2026-40467                 │
│                ├────────────────┤          │        │                          │                          ├────────────────────────────────────────────────────────────┤
│                │ CVE-2026-40468 │          │        │                          │                          │ gawk: gawk: Memory corruption via integer overflow         │
│                │                │          │        │                          │                          │ https://avd.aquasec.com/nvd/cve-2026-40468                 │
│                ├────────────────┤          │        │                          │                          ├────────────────────────────────────────────────────────────┤
│                │ CVE-2026-40553 │          │        │                          │                          │ gawk: Gawk: Buffer overflow in ftype() routine may lead to │
│                │                │          │        │                          │                          │ code execution...                                          │
│                │                │          │        │                          │                          │ https://avd.aquasec.com/nvd/cve-2026-40553                 │
├────────────────┼────────────────┤          │        ├──────────────────────────┼──────────────────────────┼────────────────────────────────────────────────────────────┤
│ glib2          │ CVE-2026-16118 │          │        │ 2.82.2-770.amzn2023      │ 2.82.2-771.amzn2023      │ xdgmime: heap-based buffer overflow in                     │
│                │                │          │        │                          │                          │ _xdg_mime_magic_parse_magic_line() in xdgmimemagic.c       │
│                │                │          │        │                          │                          │ https://avd.aquasec.com/nvd/cve-2026-16118                 │
├────────────────┼────────────────┤          │        ├──────────────────────────┼──────────────────────────┼────────────────────────────────────────────────────────────┤
│ python3        │ CVE-2026-15308 │          │        │ 3.9.25-1.amzn2023.0.8    │ 3.9.25-1.amzn2023.0.9    │ python: Python: CPU Denial of Service in HTML parser via   │
│                │                │          │        │                          │                          │ repeated unterminated...                                   │
│                │                │          │        │                          │                          │ https://avd.aquasec.com/nvd/cve-2026-15308                 │
│                ├────────────────┤          │        │                          │                          ├────────────────────────────────────────────────────────────┤
│                │ CVE-2026-4360  │          │        │                          │                          │ python: Python Tarfile: Unexpected file ownership when     │
│                │                │          │        │                          │                          │ extracting hardlinks                                       │
│                │                │          │        │                          │                          │ https://avd.aquasec.com/nvd/cve-2026-4360                  │
│                ├────────────────┤          │        │                          │                          ├────────────────────────────────────────────────────────────┤
│                │ CVE-2026-7774  │          │        │                          │                          │ python: CPython: Python tarfile: Arbitrary file write via  │
│                │                │          │        │                          │                          │ crafted link entries                                       │
│                │                │          │        │                          │                          │ https://avd.aquasec.com/nvd/cve-2026-7774                  │
├────────────────┼────────────────┤          │        │                          │                          ├────────────────────────────────────────────────────────────┤
│ python3-libs   │ CVE-2026-15308 │          │        │                          │                          │ python: Python: CPU Denial of Service in HTML parser via   │
│                │                │          │        │                          │                          │ repeated unterminated...                                   │
│                │                │          │        │                          │                          │ https://avd.aquasec.com/nvd/cve-2026-15308                 │
│                ├────────────────┤          │        │                          │                          ├────────────────────────────────────────────────────────────┤
│                │ CVE-2026-4360  │          │        │                          │                          │ python: Python Tarfile: Unexpected file ownership when     │
│                │                │          │        │                          │                          │ extracting hardlinks                                       │
│                │                │          │        │                          │                          │ https://avd.aquasec.com/nvd/cve-2026-4360                  │
│                ├────────────────┤          │        │                          │                          ├────────────────────────────────────────────────────────────┤
│                │ CVE-2026-7774  │          │        │                          │                          │ python: CPython: Python tarfile: Arbitrary file write via  │
│                │                │          │        │                          │                          │ crafted link entries                                       │
│                │                │          │        │                          │                          │ https://avd.aquasec.com/nvd/cve-2026-7774                  │
├────────────────┼────────────────┤          │        ├──────────────────────────┼──────────────────────────┼────────────────────────────────────────────────────────────┤
│ python3-rpm    │ CVE-2026-44605 │          │        │ 4.16.1.3-29.amzn2023.0.6 │ 4.16.1.3-29.amzn2023.0.7 │ rpm: heap buffer overflow in NDB slot table parsing        │
│                │                │          │        │                          │                          │ https://avd.aquasec.com/nvd/cve-2026-44605                 │
├────────────────┤                │          │        │                          │                          │                                                            │
│ rpm            │                │          │        │                          │                          │                                                            │
│                │                │          │        │                          │                          │                                                            │
├────────────────┤                │          │        │                          │                          │                                                            │
│ rpm-build-libs │                │          │        │                          │                          │                                                            │
│                │                │          │        │                          │                          │                                                            │
├────────────────┤                │          │        │                          │                          │                                                            │
│ rpm-libs       │                │          │        │                          │                          │                                                            │
│                │                │          │        │                          │                          │                                                            │
├────────────────┤                │          │        │                          │                          │                                                            │
│ rpm-sign-libs  │                │          │        │                          │                          │                                                            │
│                │                │          │        │                          │                          │                                                            │
└────────────────┴────────────────┴──────────┴────────┴──────────────────────────┴──────────────────────────┴────────────────────────────────────────────────────────────┘

Java (jar)
==========
Total: 35 (HIGH: 30, CRITICAL: 5)

┌──────────────────────────────────────────────────────────────┬─────────────────────┬──────────┬────────┬───────────────────┬───────────────────────────┬──────────────────────────────────────────────────────────────┐
│                           Library                            │    Vulnerability    │ Severity │ Status │ Installed Version │       Fixed Version       │                            Title                             │
├──────────────────────────────────────────────────────────────┼─────────────────────┼──────────┼────────┼───────────────────┼───────────────────────────┼──────────────────────────────────────────────────────────────┤
│ com.fasterxml.jackson.core:jackson-core                      │ GHSA-r7wm-3cxj-wff9 │ HIGH     │ fixed  │ 2.15.2            │ 2.18.8, 2.21.4            │ jackson-core: Async parser maxNumberLength bypass via        │
│ (cmd-adaptor-sns-exec.jar)                                   │                     │          │        │                   │                           │ chunked digit accumulation (incomplete fix for...            │
│                                                              │                     │          │        │                   │                           │ https://github.com/advisories/GHSA-r7wm-3cxj-wff9            │
├──────────────────────────────────────────────────────────────┤                     │          │        │                   │                           │                                                              │
│ com.fasterxml.jackson.core:jackson-core                      │                     │          │        │                   │                           │                                                              │
│ (opentelemetry-javaagent.jar)                                │                     │          │        │                   │                           │                                                              │
│                                                              │                     │          │        │                   │                           │                                                              │
├──────────────────────────────────────────────────────────────┤                     │          │        ├───────────────────┤                           │                                                              │
│ com.fasterxml.jackson.core:jackson-core                      │                     │          │        │ 2.19.0            │                           │                                                              │
│ (cmd-adaptor-sns-exec.jar)                                   │                     │          │        │                   │                           │                                                              │
│                                                              │                     │          │        │                   │                           │                                                              │
├──────────────────────────────────────────────────────────────┼─────────────────────┤          │        ├───────────────────┼───────────────────────────┼──────────────────────────────────────────────────────────────┤
│ com.fasterxml.jackson.core:jackson-databind                  │ CVE-2026-54512      │          │        │ 2.15.2            │ 2.18.8, 3.1.4, 2.21.4     │ jackson-databind: jackson-databind: Arbitrary code execution │
│ (cmd-adaptor-sns-exec.jar)                                   │                     │          │        │                   │                           │ via PolymorphicTypeValidator bypass                          │
│                                                              │                     │          │        │                   │                           │ https://avd.aquasec.com/nvd/cve-2026-54512                   │
├──────────────────────────────────────────────────────────────┤                     │          │        │                   │                           │                                                              │
│ com.fasterxml.jackson.core:jackson-databind                  │                     │          │        │                   │                           │                                                              │
│ (opentelemetry-javaagent.jar)                                │                     │          │        │                   │                           │                                                              │
│                                                              │                     │          │        │                   │                           │                                                              │
├──────────────────────────────────────────────────────────────┼─────────────────────┤          │        │                   ├───────────────────────────┼──────────────────────────────────────────────────────────────┤
│ com.fasterxml.jackson.core:jackson-databind                  │ CVE-2026-54513      │          │        │                   │ 2.18.8, 2.21.4, 3.1.4     │ jackson-databind: Jackson-databind: Security bypass allows   │
│ (cmd-adaptor-sns-exec.jar)                                   │                     │          │        │                   │                           │ arbitrary code execution                                     │
│                                                              │                     │          │        │                   │                           │ https://avd.aquasec.com/nvd/cve-2026-54513                   │
├──────────────────────────────────────────────────────────────┤                     │          │        │                   │                           │                                                              │
│ com.fasterxml.jackson.core:jackson-databind                  │                     │          │        │                   │                           │                                                              │
│ (opentelemetry-javaagent.jar)                                │                     │          │        │                   │                           │                                                              │
│                                                              │                     │          │        │                   │                           │                                                              │
├──────────────────────────────────────────────────────────────┼─────────────────────┤          │        ├───────────────────┼───────────────────────────┼──────────────────────────────────────────────────────────────┤
│ com.fasterxml.jackson.core:jackson-databind                  │ CVE-2026-54512      │          │        │ 2.19.0            │ 2.18.8, 3.1.4, 2.21.4     │ jackson-databind: jackson-databind: Arbitrary code execution │
│ (cmd-adaptor-sns-exec.jar)                                   │                     │          │        │                   │                           │ via PolymorphicTypeValidator bypass                          │
│                                                              │                     │          │        │                   │                           │ https://avd.aquasec.com/nvd/cve-2026-54512                   │
│                                                              ├─────────────────────┤          │        │                   ├───────────────────────────┼──────────────────────────────────────────────────────────────┤
│                                                              │ CVE-2026-54513      │          │        │                   │ 2.18.8, 2.21.4, 3.1.4     │ jackson-databind: Jackson-databind: Security bypass allows   │
│                                                              │                     │          │        │                   │                           │ arbitrary code execution                                     │
│                                                              │                     │          │        │                   │                           │ https://avd.aquasec.com/nvd/cve-2026-54513                   │
├──────────────────────────────────────────────────────────────┼─────────────────────┤          │        ├───────────────────┼───────────────────────────┼──────────────────────────────────────────────────────────────┤
│ io.micrometer:micrometer-core (cmd-adaptor-sns-exec.jar)     │ CVE-2026-40984      │          │        │ 1.13.15           │ 1.16.6, 1.15.12           │ micrometer-core: micrometer-jetty11: micrometer-jetty12:     │
│                                                              │                     │          │        │                   │                           │ Micrometer: Denial of Service via specially crafted HTTP     │
│                                                              │                     │          │        │                   │                           │ requests...                                                  │
│                                                              │                     │          │        │                   │                           │ https://avd.aquasec.com/nvd/cve-2026-40984                   │
├──────────────────────────────────────────────────────────────┼─────────────────────┼──────────┤        ├───────────────────┼───────────────────────────┼──────────────────────────────────────────────────────────────┤
│ io.opentelemetry.javaagent:opentelemetry-javaagent           │ CVE-2026-33701      │ CRITICAL │        │ 1.30.0            │ 2.26.1                    │ io.opentelemetry.javaagent/opentelemetry-javaagent:          │
│ (cmd-adaptor-sns-exec.jar)                                   │                     │          │        │                   │                           │ OpenTelemetry Java Instrumentation: Remote code execution    │
│                                                              │                     │          │        │                   │                           │ via deserialization vulnerability in RMI...                  │
│                                                              │                     │          │        │                   │                           │ https://avd.aquasec.com/nvd/cve-2026-33701                   │
├──────────────────────────────────────────────────────────────┤                     │          │        │                   │                           │                                                              │
│ io.opentelemetry.javaagent:opentelemetry-javaagent           │                     │          │        │                   │                           │                                                              │
│ (opentelemetry-javaagent.jar)                                │                     │          │        │                   │                           │                                                              │
│                                                              │                     │          │        │                   │                           │                                                              │
│                                                              │                     │          │        │                   │                           │                                                              │
├──────────────────────────────────────────────────────────────┼─────────────────────┼──────────┤        ├───────────────────┼───────────────────────────┼──────────────────────────────────────────────────────────────┤
│ org.apache.kafka:kafka-clients (cmd-adaptor-sns-exec.jar)    │ CVE-2026-35554      │ HIGH     │        │ 3.7.2             │ 3.9.2, 4.0.2, 4.1.2       │ Apache Kafka Clients: Apache Kafka Clients: Information      │
│                                                              │                     │          │        │                   │                           │ disclosure and data corruption due...                        │
│                                                              │                     │          │        │                   │                           │ https://avd.aquasec.com/nvd/cve-2026-35554                   │
├──────────────────────────────────────────────────────────────┼─────────────────────┼──────────┤        ├───────────────────┼───────────────────────────┼──────────────────────────────────────────────────────────────┤
│ org.apache.tomcat.embed:tomcat-embed-core                    │ CVE-2026-41293      │ CRITICAL │        │ 10.1.42           │ 9.0.118, 10.1.55, 11.0.22 │ tomcat-coyote: Apache Tomcat: HTTP/2 request headers not     │
│ (cmd-adaptor-sns-exec.jar)                                   │                     │          │        │                   │                           │ validated                                                    │
│                                                              │                     │          │        │                   │                           │ https://avd.aquasec.com/nvd/cve-2026-41293                   │
│                                                              ├─────────────────────┤          │        │                   │                           ├──────────────────────────────────────────────────────────────┤
│                                                              │ CVE-2026-43512      │          │        │                   │                           │ tomcat-coyote: Apache Tomcat: Authentication bypass via      │
│                                                              │                     │          │        │                   │                           │ digest authentication                                        │
│                                                              │                     │          │        │                   │                           │ https://avd.aquasec.com/nvd/cve-2026-43512                   │
│                                                              ├─────────────────────┤          │        │                   │                           ├──────────────────────────────────────────────────────────────┤
│                                                              │ CVE-2026-43515      │          │        │                   │                           │ tomcat-coyote: tomcat: Improper Authorization allows         │
│                                                              │                     │          │        │                   │                           │ security bypass                                              │
│                                                              │                     │          │        │                   │                           │ https://avd.aquasec.com/nvd/cve-2026-43515                   │
│                                                              ├─────────────────────┼──────────┤        │                   ├───────────────────────────┼──────────────────────────────────────────────────────────────┤
│                                                              │ CVE-2025-48989      │ HIGH     │        │                   │ 11.0.10, 10.1.44, 9.0.108 │ tomcat: http/2 "MadeYouReset" DoS attack through HTTP/2      │
│                                                              │                     │          │        │                   │                           │ control frames                                               │
│                                                              │                     │          │        │                   │                           │ https://avd.aquasec.com/nvd/cve-2025-48989                   │
│                                                              ├─────────────────────┤          │        │                   ├───────────────────────────┼──────────────────────────────────────────────────────────────┤
│                                                              │ CVE-2025-52520      │          │        │                   │ 11.0.9, 10.1.43, 9.0.107  │ tomcat: Apache Tomcat denial of service                      │
│                                                              │                     │          │        │                   │                           │ https://avd.aquasec.com/nvd/cve-2025-52520                   │
│                                                              ├─────────────────────┤          │        │                   ├───────────────────────────┼──────────────────────────────────────────────────────────────┤
│                                                              │ CVE-2025-53506      │          │        │                   │ 9.0.107, 10.1.43, 11.0.9  │ tomcat: Apache Tomcat denial of service                      │
│                                                              │                     │          │        │                   │                           │ https://avd.aquasec.com/nvd/cve-2025-53506                   │
│                                                              ├─────────────────────┤          │        │                   ├───────────────────────────┼──────────────────────────────────────────────────────────────┤
│                                                              │ CVE-2025-55752      │          │        │                   │ 11.0.11, 10.1.45, 9.0.109 │ tomcat: org.apache.tomcat/tomcat-catalina: Apache Tomcat:    │
│                                                              │                     │          │        │                   │                           │ Directory traversal via rewrite with possible RCE            │
│                                                              │                     │          │        │                   │                           │ https://avd.aquasec.com/nvd/cve-2025-55752                   │
│                                                              ├─────────────────────┤          │        │                   ├───────────────────────────┼──────────────────────────────────────────────────────────────┤
│                                                              │ CVE-2026-24734      │          │        │                   │ 11.0.18, 10.1.52, 9.0.115 │ tomcat: Apache Tomcat: Certificate revocation bypass due to  │
│                                                              │                     │          │        │                   │                           │ improper OCSP response validation...                         │
│                                                              │                     │          │        │                   │                           │ https://avd.aquasec.com/nvd/cve-2026-24734                   │
│                                                              ├─────────────────────┤          │        │                   ├───────────────────────────┼──────────────────────────────────────────────────────────────┤
│                                                              │ CVE-2026-24880      │          │        │                   │ 9.0.116, 10.1.52, 11.0.20 │ Apache Tomcat: Apache Tomcat: HTTP Request/Response          │
│                                                              │                     │          │        │                   │                           │ Smuggling via invalid chunk extension                        │
│                                                              │                     │          │        │                   │                           │ https://avd.aquasec.com/nvd/cve-2026-24880                   │
│                                                              ├─────────────────────┤          │        │                   ├───────────────────────────┼──────────────────────────────────────────────────────────────┤
│                                                              │ CVE-2026-34483      │          │        │                   │ 9.0.116, 10.1.54, 11.0.21 │ Apache Tomcat: Apache Tomcat: Information disclosure due to  │
│                                                              │                     │          │        │                   │                           │ improper encoding in JsonAccessLogValve...                   │
│                                                              │                     │          │        │                   │                           │ https://avd.aquasec.com/nvd/cve-2026-34483                   │
│                                                              ├─────────────────────┤          │        │                   ├───────────────────────────┼──────────────────────────────────────────────────────────────┤
│                                                              │ CVE-2026-34487      │          │        │                   │ 9.0.117, 10.1.54, 11.0.21 │ Apache Tomcat: Apache Tomcat: Information disclosure via     │
│                                                              │                     │          │        │                   │                           │ sensitive data in log files...                               │
│                                                              │                     │          │        │                   │                           │ https://avd.aquasec.com/nvd/cve-2026-34487                   │
│                                                              ├─────────────────────┤          │        │                   ├───────────────────────────┼──────────────────────────────────────────────────────────────┤
│                                                              │ CVE-2026-41284      │          │        │                   │ 9.0.118, 10.1.55, 11.0.22 │ tomcat: Apache Tomcat: Denial of Service due to uncontrolled │
│                                                              │                     │          │        │                   │                           │ resource allocation                                          │
│                                                              │                     │          │        │                   │                           │ https://avd.aquasec.com/nvd/cve-2026-41284                   │
│                                                              ├─────────────────────┤          │        │                   │                           ├──────────────────────────────────────────────────────────────┤
│                                                              │ CVE-2026-42498      │          │        │                   │                           │ tomcat-coyote: Apache Tomcat: Information disclosure due to  │
│                                                              │                     │          │        │                   │                           │ HTTP Authentication Header exposure during...                │
│                                                              │                     │          │        │                   │                           │ https://avd.aquasec.com/nvd/cve-2026-42498                   │
│                                                              ├─────────────────────┤          │        │                   │                           ├──────────────────────────────────────────────────────────────┤
│                                                              │ CVE-2026-43513      │          │        │                   │                           │ tomcat-catalina: Apache Tomcat: Improper Handling of Case    │
│                                                              │                     │          │        │                   │                           │ Sensitivity in LockOutRealm                                  │
│                                                              │                     │          │        │                   │                           │ https://avd.aquasec.com/nvd/cve-2026-43513                   │
├──────────────────────────────────────────────────────────────┼─────────────────────┤          │        ├───────────────────┼───────────────────────────┼──────────────────────────────────────────────────────────────┤
│ org.codehaus.plexus:plexus-utils (cmd-adaptor-sns-exec.jar)  │ CVE-2025-67030      │          │        │ 3.6.0             │ 4.0.3, 3.6.1              │ org.codehaus.plexus:plexus-utils: Plexus-utils: Directory    │
│                                                              │                     │          │        │                   │                           │ Traversal in extractFile method                              │
│                                                              │                     │          │        │                   │                           │ https://avd.aquasec.com/nvd/cve-2025-67030                   │
├──────────────────────────────────────────────────────────────┼─────────────────────┤          │        ├───────────────────┼───────────────────────────┼──────────────────────────────────────────────────────────────┤
│ org.lz4:lz4-java (cmd-adaptor-sns-exec.jar)                  │ CVE-2025-12183      │          │        │ 1.8.0             │ 1.8.1                     │ lz4-java: lz4-java: Out-of-bounds memory operations lead to  │
│                                                              │                     │          │        │                   │                           │ denial of service and information...                         │
│                                                              │                     │          │        │                   │                           │ https://avd.aquasec.com/nvd/cve-2025-12183                   │
├──────────────────────────────────────────────────────────────┼─────────────────────┤          │        ├───────────────────┼───────────────────────────┼──────────────────────────────────────────────────────────────┤
│ org.springframework.boot:spring-boot                         │ CVE-2026-40973      │          │        │ 3.3.13            │ 4.0.6, 3.5.14             │ Spring Boot: Spring Boot: Arbitrary Code Execution and       │
│ (cmd-adaptor-sns-exec.jar)                                   │                     │          │        │                   │                           │ Session Hijacking via predictable...                         │
│                                                              │                     │          │        │                   │                           │ https://avd.aquasec.com/nvd/cve-2026-40973                   │
├──────────────────────────────────────────────────────────────┼─────────────────────┤          │        ├───────────────────┼───────────────────────────┼──────────────────────────────────────────────────────────────┤
│ org.springframework.kafka:spring-kafka                       │ CVE-2026-41731      │          │        │ 3.2.10            │ 4.0.6, 3.3.16             │ spring-kafka: Spring for Apache Kafka: Arbitrary code        │
│ (cmd-adaptor-sns-exec.jar)                                   │                     │          │        │                   │                           │ execution via insecure deserialization of...                 │
│                                                              │                     │          │        │                   │                           │ https://avd.aquasec.com/nvd/cve-2026-41731                   │
├──────────────────────────────────────────────────────────────┼─────────────────────┤          │        ├───────────────────┼───────────────────────────┼──────────────────────────────────────────────────────────────┤
│ org.springframework:spring-core (cmd-adaptor-sns-exec.jar)   │ CVE-2025-41249      │          │        │ 6.1.21            │ 6.2.11                    │ org.springframework/spring-core: Spring Framework Annotation │
│                                                              │                     │          │        │                   │                           │ Detection Vulnerability                                      │
│                                                              │                     │          │        │                   │                           │ https://avd.aquasec.com/nvd/cve-2025-41249                   │
├──────────────────────────────────────────────────────────────┼─────────────────────┤          │        │                   ├───────────────────────────┼──────────────────────────────────────────────────────────────┤
│ org.springframework:spring-expression                        │ CVE-2026-41850      │          │        │                   │ 7.0.8, 6.2.19             │ spring-framework: Spring Framework: Denial of Service via    │
│ (cmd-adaptor-sns-exec.jar)                                   │                     │          │        │                   │                           │ specially crafted SpEL expressions                           │
│                                                              │                     │          │        │                   │                           │ https://avd.aquasec.com/nvd/cve-2026-41850                   │
├──────────────────────────────────────────────────────────────┼─────────────────────┤          │        │                   │                           ├──────────────────────────────────────────────────────────────┤
│ org.springframework:spring-webmvc (cmd-adaptor-sns-exec.jar) │ CVE-2026-41842      │          │        │                   │                           │ spring-framework: Spring Framework: Denial of Service when   │
│                                                              │                     │          │        │                   │                           │ resolving static resources                                   │
│                                                              │                     │          │        │                   │                           │ https://avd.aquasec.com/nvd/cve-2026-41842                   │
│                                                              ├─────────────────────┤          │        │                   │                           ├──────────────────────────────────────────────────────────────┤
│                                                              │ CVE-2026-41845      │          │        │                   │                           │ org.springframework: Spring Framework: Cross-site scripting  │
│                                                              │                     │          │        │                   │                           │ (XSS) via incorrect JavaScript escaping                      │
│                                                              │                     │          │        │                   │                           │ https://avd.aquasec.com/nvd/cve-2026-41845                   │
└──────────────────────────────────────────────────────────────┴─────────────────────┴──────────┴────────┴───────────────────┴───────────────────────────┴──────────────────────────────────────────────────────────────┘

usr/local/bin/envconsul (gobinary)
==================================
Total: 56 (HIGH: 54, CRITICAL: 2)

┌────────────────────────┬─────────────────────┬──────────┬────────┬────────────────────────────────────┬─────────────────────────────────────┬──────────────────────────────────────────────────────────────┐
│        Library         │    Vulnerability    │ Severity │ Status │         Installed Version          │            Fixed Version            │                            Title                             │
├────────────────────────┼─────────────────────┼──────────┼────────┼────────────────────────────────────┼─────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│ golang.org/x/crypto    │ CVE-2024-45337      │ HIGH     │ fixed  │ v0.0.0-20220622213112-05595931fe9d │ 0.31.0                              │ golang.org/x/crypto/ssh: Misuse of                           │
│                        │                     │          │        │                                    │                                     │ ServerConfig.PublicKeyCallback may cause authorization       │
│                        │                     │          │        │                                    │                                     │ bypass in golang.org/x/crypto                                │
│                        │                     │          │        │                                    │                                     │ https://avd.aquasec.com/nvd/cve-2024-45337                   │
│                        ├─────────────────────┤          │        │                                    ├─────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│                        │ CVE-2025-22869      │          │        │                                    │ 0.35.0                              │ golang.org/x/crypto/ssh: Denial of Service in the Key        │
│                        │                     │          │        │                                    │                                     │ Exchange of golang.org/x/crypto/ssh                          │
│                        │                     │          │        │                                    │                                     │ https://avd.aquasec.com/nvd/cve-2025-22869                   │
│                        ├─────────────────────┤          │        │                                    ├─────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│                        │ CVE-2025-47913      │          │        │                                    │ 0.43.0                              │ golang.org/x/crypto/ssh/agent:                               │
│                        │                     │          │        │                                    │                                     │ golang.org/x/crypto/ssh/agent: SSH client panic due to       │
│                        │                     │          │        │                                    │                                     │ unexpected SSH_AGENT_SUCCESS                                 │
│                        │                     │          │        │                                    │                                     │ https://avd.aquasec.com/nvd/cve-2025-47913                   │
│                        ├─────────────────────┤          │        │                                    ├─────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│                        │ CVE-2026-39828      │          │        │                                    │ 0.52.0                              │ golang.org/x/crypto/ssh: golang.org/x/crypto/ssh:            │
│                        │                     │          │        │                                    │                                     │ Unauthorized command execution via discarded SSH permissions │
│                        │                     │          │        │                                    │                                     │ https://avd.aquasec.com/nvd/cve-2026-39828                   │
│                        ├─────────────────────┤          │        │                                    │                                     ├──────────────────────────────────────────────────────────────┤
│                        │ CVE-2026-39829      │          │        │                                    │                                     │ golang.org/x/crypto/ssh: golang.org/x/crypto/ssh: Denial of  │
│                        │                     │          │        │                                    │                                     │ Service via crafted public key with excessive parameters...  │
│                        │                     │          │        │                                    │                                     │ https://avd.aquasec.com/nvd/cve-2026-39829                   │
│                        ├─────────────────────┤          │        │                                    │                                     ├──────────────────────────────────────────────────────────────┤
│                        │ CVE-2026-39830      │          │        │                                    │                                     │ golang.org/x/crypto/ssh: golang.org/x/crypto/ssh: Denial of  │
│                        │                     │          │        │                                    │                                     │ Service via resource leak from unsolicited SSH responses...  │
│                        │                     │          │        │                                    │                                     │ https://avd.aquasec.com/nvd/cve-2026-39830                   │
│                        ├─────────────────────┤          │        │                                    │                                     ├──────────────────────────────────────────────────────────────┤
│                        │ CVE-2026-39831      │          │        │                                    │                                     │ golang.org/x/crypto/ssh: golang.org/x/crypto/ssh: Security   │
│                        │                     │          │        │                                    │                                     │ key bypass due to missing user presence check                │
│                        │                     │          │        │                                    │                                     │ https://avd.aquasec.com/nvd/cve-2026-39831                   │
│                        ├─────────────────────┤          │        │                                    │                                     ├──────────────────────────────────────────────────────────────┤
│                        │ CVE-2026-39832      │          │        │                                    │                                     │ golang.org/x/crypto/ssh/agent:                               │
│                        │                     │          │        │                                    │                                     │ golang.org/x/crypto/ssh/agent: Security bypass due to        │
│                        │                     │          │        │                                    │                                     │ improper handling of key restrictions                        │
│                        │                     │          │        │                                    │                                     │ https://avd.aquasec.com/nvd/cve-2026-39832                   │
│                        ├─────────────────────┤          │        │                                    │                                     ├──────────────────────────────────────────────────────────────┤
│                        │ CVE-2026-39835      │          │        │                                    │                                     │ golang.org/x/crypto/ssh: golang: golang.org/x/crypto/ssh:    │
│                        │                     │          │        │                                    │                                     │ Denial of Service via crafted SSH certificate                │
│                        │                     │          │        │                                    │                                     │ https://avd.aquasec.com/nvd/cve-2026-39835                   │
│                        ├─────────────────────┤          │        │                                    │                                     ├──────────────────────────────────────────────────────────────┤
│                        │ CVE-2026-42508      │          │        │                                    │                                     │ golang.org/x/crypto/ssh/knownhosts: golang:                  │
│                        │                     │          │        │                                    │                                     │ golang.org/x/crypto/ssh/knownhosts: Revocation bypass via    │
│                        │                     │          │        │                                    │                                     │ unchecked SignatureKey                                       │
│                        │                     │          │        │                                    │                                     │ https://avd.aquasec.com/nvd/cve-2026-42508                   │
│                        ├─────────────────────┤          │        │                                    │                                     ├──────────────────────────────────────────────────────────────┤
│                        │ CVE-2026-46595      │          │        │                                    │                                     │ golang.org/x/crypto/ssh: golang.org/x/crypto/ssh:            │
│                        │                     │          │        │                                    │                                     │ Authorization bypass due to skipped source-address           │
│                        │                     │          │        │                                    │                                     │ validation                                                   │
│                        │                     │          │        │                                    │                                     │ https://avd.aquasec.com/nvd/cve-2026-46595                   │
│                        ├─────────────────────┤          │        │                                    │                                     ├──────────────────────────────────────────────────────────────┤
│                        │ CVE-2026-46597      │          │        │                                    │                                     │ golang.org/x/crypto/ssh: golang.org/x/crypto/ssh: Denial of  │
│                        │                     │          │        │                                    │                                     │ Service via crafted AES-GCM packet decoder inputs            │
│                        │                     │          │        │                                    │                                     │ https://avd.aquasec.com/nvd/cve-2026-46597                   │
├────────────────────────┼─────────────────────┤          │        ├────────────────────────────────────┼─────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│ golang.org/x/net       │ CVE-2022-41721      │          │        │ v0.0.0-20220906165146-f3363e06e74c │ 0.1.1-0.20221104162952-702349b0e862 │ x/net/http2/h2c: request smuggling                           │
│                        │                     │          │        │                                    │                                     │ https://avd.aquasec.com/nvd/cve-2022-41721                   │
│                        ├─────────────────────┤          │        │                                    ├─────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│                        │ CVE-2022-41723      │          │        │                                    │ 0.7.0                               │ golang.org/x/net/http2: avoid quadratic complexity in HPACK  │
│                        │                     │          │        │                                    │                                     │ decoding                                                     │
│                        │                     │          │        │                                    │                                     │ https://avd.aquasec.com/nvd/cve-2022-41723                   │
│                        ├─────────────────────┤          │        │                                    ├─────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│                        │ CVE-2024-45338      │          │        │                                    │ 0.33.0                              │ golang.org/x/net/html: Non-linear parsing of                 │
│                        │                     │          │        │                                    │                                     │ case-insensitive content in golang.org/x/net/html            │
│                        │                     │          │        │                                    │                                     │ https://avd.aquasec.com/nvd/cve-2024-45338                   │
│                        ├─────────────────────┤          │        │                                    ├─────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│                        │ CVE-2026-25681      │          │        │                                    │ 0.55.0                              │ golang.org/x/net/html: golang.org/x/net/html: Arbitrary code │
│                        │                     │          │        │                                    │                                     │ execution via Cross-Site Scripting                           │
│                        │                     │          │        │                                    │                                     │ https://avd.aquasec.com/nvd/cve-2026-25681                   │
│                        ├─────────────────────┤          │        │                                    │                                     ├──────────────────────────────────────────────────────────────┤
│                        │ CVE-2026-27136      │          │        │                                    │                                     │ golang.org/x/net/html: golang: golang.org/x/net/html:        │
│                        │                     │          │        │                                    │                                     │ Cross-Site Scripting via HTML parsing bypass                 │
│                        │                     │          │        │                                    │                                     │ https://avd.aquasec.com/nvd/cve-2026-27136                   │
│                        ├─────────────────────┤          │        │                                    ├─────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│                        │ CVE-2026-33814      │          │        │                                    │ 0.53.0                              │ net/http/internal/http2: golang: golang.org/x/net: Go        │
│                        │                     │          │        │                                    │                                     │ HTTP/2: Denial of Service via malformed                      │
│                        │                     │          │        │                                    │                                     │ SETTINGS_MAX_FRAME_SIZE frame...                             │
│                        │                     │          │        │                                    │                                     │ https://avd.aquasec.com/nvd/cve-2026-33814                   │
│                        ├─────────────────────┤          │        │                                    ├─────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│                        │ CVE-2026-39821      │          │        │                                    │ 0.55.0                              │ golang.org/x/net/idna: golang: net/http:                     │
│                        │                     │          │        │                                    │                                     │ golang.org/x/net/idna: Privilege escalation via incorrect    │
│                        │                     │          │        │                                    │                                     │ Punycode label processing                                    │
│                        │                     │          │        │                                    │                                     │ https://avd.aquasec.com/nvd/cve-2026-39821                   │
│                        ├─────────────────────┤          │        │                                    ├─────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│                        │ CVE-2026-46600      │          │        │                                    │ 0.56.0                              │ golang.org/x/net/dns/dnsmessage:                             │
│                        │                     │          │        │                                    │                                     │ golang.org/x/net/dns/dnsmessage: Denial of Service via       │
│                        │                     │          │        │                                    │                                     │ invalid DNS record parsing                                   │
│                        │                     │          │        │                                    │                                     │ https://avd.aquasec.com/nvd/cve-2026-46600                   │
├────────────────────────┼─────────────────────┤          │        ├────────────────────────────────────┼─────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│ golang.org/x/text      │ CVE-2022-32149      │          │        │ v0.3.7                             │ 0.3.8                               │ golang: golang.org/x/text/language: ParseAcceptLanguage      │
│                        │                     │          │        │                                    │                                     │ takes a long time to parse complex tags                      │
│                        │                     │          │        │                                    │                                     │ https://avd.aquasec.com/nvd/cve-2022-32149                   │
│                        ├─────────────────────┤          │        │                                    ├─────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│                        │ CVE-2026-56852      │          │        │                                    │ 0.39.0                              │ golang.org/x/text: golang.org/x/text: Denial of Service via  │
│                        │                     │          │        │                                    │                                     │ invalid UTF-8 input                                          │
│                        │                     │          │        │                                    │                                     │ https://avd.aquasec.com/nvd/cve-2026-56852                   │
├────────────────────────┼─────────────────────┼──────────┤        ├────────────────────────────────────┼─────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│ google.golang.org/grpc │ CVE-2026-33186      │ CRITICAL │        │ v1.48.0                            │ 1.79.3                              │ google.golang.org/grpc/grpc-go:                              │
│                        │                     │          │        │                                    │                                     │ google.golang.org/grpc/authz: gRPC-Go: Authorization bypass  │
│                        │                     │          │        │                                    │                                     │ due to improper HTTP/2 path validation                       │
│                        │                     │          │        │                                    │                                     │ https://avd.aquasec.com/nvd/cve-2026-33186                   │
│                        ├─────────────────────┼──────────┤        │                                    ├─────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│                        │ GHSA-hrxh-6v49-42gf │ HIGH     │        │                                    │ 1.82.1                              │ gRPC-Go: xDS RBAC and HTTP/2 Vulnerabilities                 │
│                        │                     │          │        │                                    │                                     │ https://github.com/advisories/GHSA-hrxh-6v49-42gf            │
│                        ├─────────────────────┤          │        │                                    ├─────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│                        │ GHSA-m425-mq94-257g │          │        │                                    │ 1.56.3, 1.57.1, 1.58.3              │ gRPC-Go HTTP/2 Rapid Reset vulnerability                     │
│                        │                     │          │        │                                    │                                     │ https://github.com/advisories/GHSA-m425-mq94-257g            │
├────────────────────────┼─────────────────────┼──────────┤        ├────────────────────────────────────┼─────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│ stdlib                 │ CVE-2025-68121      │ CRITICAL │        │ v1.18.6                            │ 1.24.13, 1.25.7, 1.26.0-rc.3        │ crypto/tls: crypto/tls: Incorrect certificate validation     │
│                        │                     │          │        │                                    │                                     │ during TLS session resumption                                │
│                        │                     │          │        │                                    │                                     │ https://avd.aquasec.com/nvd/cve-2025-68121                   │
│                        ├─────────────────────┼──────────┤        │                                    ├─────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│                        │ CVE-2022-2879       │ HIGH     │        │                                    │ 1.18.7, 1.19.2                      │ golang: archive/tar: github.com/vbatts/tar-split: unbounded  │
│                        │                     │          │        │                                    │                                     │ memory consumption when reading headers                      │
│                        │                     │          │        │                                    │                                     │ https://avd.aquasec.com/nvd/cve-2022-2879                    │
│                        ├─────────────────────┤          │        │                                    │                                     ├──────────────────────────────────────────────────────────────┤
│                        │ CVE-2022-2880       │          │        │                                    │                                     │ golang: net/http/httputil: ReverseProxy should not forward   │

📣 [34mNotices:[0m
  - Version 0.73.0 of Trivy is now available, current version is 0.72.0

To suppress version checks, run Trivy scans with the --skip-version-check flag

│                        │                     │          │        │                                    │                                     │ unparseable query parameters                                 │
│                        │                     │          │        │                                    │                                     │ https://avd.aquasec.com/nvd/cve-2022-2880                    │
│                        ├─────────────────────┤          │        │                                    │                                     ├──────────────────────────────────────────────────────────────┤
│                        │ CVE-2022-41715      │          │        │                                    │                                     │ golang: regexp/syntax: limit memory used by parsing regexps  │
│                        │                     │          │        │                                    │                                     │ https://avd.aquasec.com/nvd/cve-2022-41715                   │
│                        ├─────────────────────┤          │        │                                    ├─────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│                        │ CVE-2022-41716      │          │        │                                    │ 1.18.8, 1.19.3                      │ Due to unsanitized NUL values, attackers may be able to      │
│                        │                     │          │        │                                    │                                     │ maliciously se...                                            │
│                        │                     │          │        │                                    │                                     │ https://avd.aquasec.com/nvd/cve-2022-41716                   │
│                        ├─────────────────────┤          │        │                                    ├─────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│                        │ CVE-2022-41720      │          │        │                                    │ 1.18.9, 1.19.4                      │ golang: os, net/http: avoid escapes from os.DirFS and        │
│                        │                     │          │        │                                    │                                     │ http.Dir on Windows                                          │
│                        │                     │          │        │                                    │                                     │ https://avd.aquasec.com/nvd/cve-2022-41720                   │
│                        ├─────────────────────┤          │        │                                    ├─────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│                        │ CVE-2022-41722      │          │        │                                    │ 1.19.6, 1.20.1                      │ golang: path/filepath: path-filepath filepath.Clean path     │
│                        │                     │          │        │                                    │                                     │ traversal                                                    │
│                        │                     │          │        │                                    │                                     │ https://avd.aquasec.com/nvd/cve-2022-41722                   │
│                        ├─────────────────────┤          │        │                                    │                                     ├──────────────────────────────────────────────────────────────┤
│                        │ CVE-2022-41723      │          │        │                                    │                                     │ golang.org/x/net/http2: avoid quadratic complexity in HPACK  │
│                        │                     │          │        │                                    │                                     │ decoding                                                     │
│                        │                     │          │        │                                    │                                     │ https://avd.aquasec.com/nvd/cve-2022-41723                   │
│                        ├─────────────────────┤          │        │                                    │                                     ├──────────────────────────────────────────────────────────────┤
│                        │ CVE-2022-41724      │          │        │                                    │                                     │ golang: crypto/tls: large handshake records may cause panics │
│                        │                     │          │        │                                    │                                     │ https://avd.aquasec.com/nvd/cve-2022-41724                   │
│                        ├─────────────────────┤          │        │                                    │                                     ├──────────────────────────────────────────────────────────────┤
│                        │ CVE-2022-41725      │          │        │                                    │                                     │ golang: net/http, mime/multipart: denial of service from     │
│                        │                     │          │        │                                    │                                     │ excessive resource consumption                               │
│                        │                     │          │        │                                    │                                     │ https://avd.aquasec.com/nvd/cve-2022-41725                   │
│                        ├─────────────────────┤          │        │                                    ├─────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│                        │ CVE-2023-24534      │          │        │                                    │ 1.19.8, 1.20.3                      │ golang: net/http, net/textproto: denial of service from      │
│                        │                     │          │        │                                    │                                     │ excessive memory allocation                                  │
│                        │                     │          │        │                                    │                                     │ https://avd.aquasec.com/nvd/cve-2023-24534                   │
│                        ├─────────────────────┤          │        │                                    │                                     ├──────────────────────────────────────────────────────────────┤
│                        │ CVE-2023-24536      │          │        │                                    │                                     │ golang: net/http, net/textproto, mime/multipart: denial of   │
│                        │                     │          │        │                                    │                                     │ service from excessive resource consumption                  │
│                        │                     │          │        │                                    │                                     │ https://avd.aquasec.com/nvd/cve-2023-24536                   │
│                        ├─────────────────────┤          │        │                                    │                                     ├──────────────────────────────────────────────────────────────┤
│                        │ CVE-2023-24537      │          │        │                                    │                                     │ golang: go/parser: Infinite loop in parsing                  │
│                        │                     │          │        │                                    │                                     │ https://avd.aquasec.com/nvd/cve-2023-24537                   │
│                        ├─────────────────────┤          │        │                                    ├─────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│                        │ CVE-2023-24539      │          │        │                                    │ 1.19.9, 1.20.4                      │ golang: html/template: improper sanitization of CSS values   │
│                        │                     │          │        │                                    │                                     │ https://avd.aquasec.com/nvd/cve-2023-24539                   │
│                        ├─────────────────────┤          │        │                                    │                                     ├──────────────────────────────────────────────────────────────┤
│                        │ CVE-2023-29400      │          │        │                                    │                                     │ golang: html/template: improper handling of empty HTML       │
│                        │                     │          │        │                                    │                                     │ attributes                                                   │
│                        │                     │          │        │                                    │                                     │ https://avd.aquasec.com/nvd/cve-2023-29400                   │
│                        ├─────────────────────┤          │        │                                    ├─────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│                        │ CVE-2023-45287      │          │        │                                    │ 1.20.0                              │ golang: crypto/tls: Timing Side Channel attack in RSA based  │
│                        │                     │          │        │                                    │                                     │ TLS key exchanges....                                        │
│                        │                     │          │        │                                    │                                     │ https://avd.aquasec.com/nvd/cve-2023-45287                   │
│                        ├─────────────────────┤          │        │                                    ├─────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│                        │ CVE-2024-34156      │          │        │                                    │ 1.22.7, 1.23.1                      │ encoding/gob: golang: Calling Decoder.Decode on a message    │
│                        │                     │          │        │                                    │                                     │ which contains deeply nested structures...                   │
│                        │                     │          │        │                                    │                                     │ https://avd.aquasec.com/nvd/cve-2024-34156                   │
│                        ├─────────────────────┤          │        │                                    ├─────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│                        │ CVE-2025-61726      │          │        │                                    │ 1.24.12, 1.25.6                     │ golang: net/url: Memory exhaustion in query parameter        │
│                        │                     │          │        │                                    │                                     │ parsing in net/url                                           │
│                        │                     │          │        │                                    │                                     │ https://avd.aquasec.com/nvd/cve-2025-61726                   │
│                        ├─────────────────────┤          │        │                                    ├─────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│                        │ CVE-2025-61729      │          │        │                                    │ 1.24.11, 1.25.5                     │ crypto/x509: golang: Denial of Service due to excessive      │
│                        │                     │          │        │                                    │                                     │ resource consumption via crafted...                          │
│                        │                     │          │        │                                    │                                     │ https://avd.aquasec.com/nvd/cve-2025-61729                   │
│                        ├─────────────────────┤          │        │                                    ├─────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│                        │ CVE-2026-25679      │          │        │                                    │ 1.25.8, 1.26.1                      │ net/url: Incorrect parsing of IPv6 host literals in net/url  │
│                        │                     │          │        │                                    │                                     │ https://avd.aquasec.com/nvd/cve-2026-25679                   │
│                        ├─────────────────────┤          │        │                                    ├─────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│                        │ CVE-2026-27145      │          │        │                                    │ 1.25.11, 1.26.4                     │ crypto/x509: golang: golang crypto/x509: Denial of Service   │
│                        │                     │          │        │                                    │                                     │ via excessive processing of DNS...                           │
│                        │                     │          │        │                                    │                                     │ https://avd.aquasec.com/nvd/cve-2026-27145                   │
│                        ├─────────────────────┤          │        │                                    ├─────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│                        │ CVE-2026-32280      │          │        │                                    │ 1.25.9, 1.26.2                      │ crypto/x509: crypto/tls: golang: Go: Denial of Service       │
│                        │                     │          │        │                                    │                                     │ vulnerability in certificate chain building...               │
│                        │                     │          │        │                                    │                                     │ https://avd.aquasec.com/nvd/cve-2026-32280                   │
│                        ├─────────────────────┤          │        │                                    │                                     ├──────────────────────────────────────────────────────────────┤
│                        │ CVE-2026-32281      │          │        │                                    │                                     │ crypto/x509: golang: Go crypto/x509: Denial of Service via   │
│                        │                     │          │        │                                    │                                     │ inefficient certificate chain validation...                  │
│                        │                     │          │        │                                    │                                     │ https://avd.aquasec.com/nvd/cve-2026-32281                   │
│                        ├─────────────────────┤          │        │                                    │                                     ├──────────────────────────────────────────────────────────────┤
│                        │ CVE-2026-32283      │          │        │                                    │                                     │ crypto/tls: golang: Go crypto/tls: Denial of Service via     │
│                        │                     │          │        │                                    │                                     │ multiple TLS 1.3 key...                                      │
│                        │                     │          │        │                                    │                                     │ https://avd.aquasec.com/nvd/cve-2026-32283                   │
│                        ├─────────────────────┤          │        │                                    ├─────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│                        │ CVE-2026-33811      │          │        │                                    │ 1.25.10, 1.26.3                     │ net: golang: Go net package: Denial of Service via long      │
│                        │                     │          │        │                                    │                                     │ CNAME response...                                            │
│                        │                     │          │        │                                    │                                     │ https://avd.aquasec.com/nvd/cve-2026-33811                   │
│                        ├─────────────────────┤          │        │                                    │                                     ├──────────────────────────────────────────────────────────────┤
│                        │ CVE-2026-33814      │          │        │                                    │                                     │ net/http/internal/http2: golang: golang.org/x/net: Go        │
│                        │                     │          │        │                                    │                                     │ HTTP/2: Denial of Service via malformed                      │
│                        │                     │          │        │                                    │                                     │ SETTINGS_MAX_FRAME_SIZE frame...                             │
│                        │                     │          │        │                                    │                                     │ https://avd.aquasec.com/nvd/cve-2026-33814                   │
│                        ├─────────────────────┤          │        │                                    │                                     ├──────────────────────────────────────────────────────────────┤
│                        │ CVE-2026-39820      │          │        │                                    │                                     │ net/mail: golang: Go net/mail: Denial of Service via crafted │
│                        │                     │          │        │                                    │                                     │ email inputs                                                 │
│                        │                     │          │        │                                    │                                     │ https://avd.aquasec.com/nvd/cve-2026-39820                   │
│                        ├─────────────────────┤          │        │                                    ├─────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│                        │ CVE-2026-39822      │          │        │                                    │ 1.25.12, 1.26.5, 1.27.0-rc.2        │ golang: Go os.Root: Symlink following vulnerability allows   │
│                        │                     │          │        │                                    │                                     │ directory traversal                                          │
│                        │                     │          │        │                                    │                                     │ https://avd.aquasec.com/nvd/cve-2026-39822                   │
│                        ├─────────────────────┤          │        │                                    ├─────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│                        │ CVE-2026-39836      │          │        │                                    │ 1.25.10, 1.26.3                     │ net: golang: Go net package: Denial of Service via NUL byte  │
│                        │                     │          │        │                                    │                                     │ in...                                                        │
│                        │                     │          │        │                                    │                                     │ https://avd.aquasec.com/nvd/cve-2026-39836                   │
│                        ├─────────────────────┤          │        │                                    │                                     ├──────────────────────────────────────────────────────────────┤
│                        │ CVE-2026-42499      │          │        │                                    │                                     │ net/mail: golang: net/mail: Denial of Service via            │
│                        │                     │          │        │                                    │                                     │ pathological email address parsing                           │
│                        │                     │          │        │                                    │                                     │ https://avd.aquasec.com/nvd/cve-2026-42499                   │
│                        ├─────────────────────┤          │        │                                    ├─────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│                        │ CVE-2026-42504      │          │        │                                    │ 1.25.11, 1.26.4                     │ mime: golang: Golang MIME: Denial of Service via             │
│                        │                     │          │        │                                    │                                     │ maliciously-crafted MIME header                              │
│                        │                     │          │        │                                    │                                     │ https://avd.aquasec.com/nvd/cve-2026-42504                   │
└────────────────────────┴─────────────────────┴──────────┴────────┴────────────────────────────────────┴─────────────────────────────────────┴──────────────────────────────────────────────────────────────┘

Extract Adaptor Information : 

+ . ./set_drone_secrets.sh
+ ./bin/adaptor-info.sh
| Aggregator Core | 10.3.11 |
| FDP BOM | 3.2.11 |
| CDLZ Avro Schemas | 1.2.2 |
| FDP Commons | 5.2.9 |



