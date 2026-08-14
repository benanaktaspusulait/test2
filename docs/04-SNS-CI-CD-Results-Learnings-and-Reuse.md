# FDP Command Adaptor SNS — Results, Engineering Learnings & Reuse Guide

## Scope

This page records the measurement evidence, evidence boundaries, experiments not retained and reusable engineering patterns from the SNS CI/CD optimisation.

This page is the measurement source of truth. Update timings here first, then align the shorter summaries on the overview and implementation pages.

Related pages:

- [CI/CD optimisation overview](00-SNS-CI-CD-Optimisation-Implementation-Report.md)
- [Docker and CI pipeline optimisation](01-SNS-CI-CD-Docker-and-Pipeline-Optimisation.md)
- [Testcontainers migration and test reliability](02-SNS-Testcontainers-Migration-and-Test-Reliability.md)
- [Built-image validation and Maven optimisation](03-SNS-Built-Image-Validation-and-Maven-Optimisation.md)

## End-to-End Result

> **Measured:** The successful CI baseline averaged **13m35s** across ten runs. Two measured optimised runs completed in **4m57s** and **4m44s**.
>
> **Best observed comparison:** Comparing the baseline average with the fastest observed optimised run gives an **8m51s** reduction, approximately **65.2%**, or approximately **2.87x** faster.

| Evidence | Result |
| --- | ---: |
| Successful baseline sample | N=10 |
| Baseline average | 13:35 |
| Baseline median | 13:31 |
| Baseline fastest | 13:20 |
| Baseline slowest | 13:57 |
| Measured optimised run 1 | 4:57 |
| Measured optimised run 2 | 4:44 |
| Best observed saving | 8:51 / 531 seconds |
| Best observed reduction | ~65.2% |
| Best observed speed-up | ~2.87x |

The **4m44s** result is the fastest observed result, not a guaranteed duration. Runner state, registry/network performance and cache availability remain variable.

## Baseline Visible Step Averages

| Baseline step | Visible average |
| --- | ---: |
| Command Adaptor | 11:01 |
| Integration Tests | 09:43 |
| Kafka & Redis | 02:18 |
| Maven build | 01:24 |
| Aggregators | 00:29 |
| Pre-Integration | 00:06 |
| Trivy | 00:44 |

> These steps overlapped and must not be summed.

## Supporting Docker Measurements

| Measurement | Observed value | Evidence boundary |
| --- | ---: | --- |
| Runtime image size | Approximately 906 MB | Image-size observation; not reduced by the context optimisation |
| Cold image build | 1m17.855s | Controlled Docker measurement |
| Warm no-change build | 0m0.851s | Controlled same-daemon measurement |
| Prepared executable JAR | Approximately 166 MB | Prepared-file observation |
| JAR layer in Docker image history | Approximately 173 MB | Image-history observation; not the same representation as the prepared file |
| OpenTelemetry agent | Approximately 18 MB | Prepared artefact observation |
| System/yum layer | Approximately 249 MB | Docker image-history observation |
| Yum-related cold work | Approximately 75.1s | Controlled cold-build observation |

## Detailed Impact by Optimisation

| Optimisation | Before | After | Observed impact | Evidence |
| --- | ---: | ---: | --- | --- |
| Docker build context | Original measured context approximately 191.27 MB | Controlled BuildKit/content-store observation 189 B | Docker input substantially narrowed; this is not a universal CI transfer comparison, and no image-size or cold-build reduction is claimed | Direct controlled Docker measurement |
| Docker layer ordering | Approximately 75.82–77.90s | Approximately 4.62–5.08s | Approximately 15–16x faster for the controlled warm rebuild case | Direct controlled Docker measurement |
| BuildKit builder/cache strategy | Custom docker-container builder path | Default-builder path approximately 41–42s | Default-builder path approximately 18–20s faster; registry-cache benefit not isolated | Observed build-path effect |
| Testcontainers architecture | Multiple overlapping Compose/CI stages | Consolidated Build/Test approximately 3:10–3:16 | Major architectural contributor; old/new step values are not directly subtractable | Observed system effect |
| Kafka polling correction | Seconds semantics for a 500ms-named value | Millisecond semantics | Correct upper-bound semantics restored | Correctness improvement |
| Polling/consumer work | One-record batches and duplicate construction | Larger batches, early exit and one consumer per topic | Unnecessary processing removed | Structural improvement |
| Aggregate startup | Independent service starts/readiness serialised | Concurrent starts and parallel readiness | Serial critical-path work removed | Structural improvement |
| Kafka Streams shutdown | Build/Test around 3:53 with ~30s tail | Representative post-fix 3:09–3:10 | The approximately 30s known tail was no longer observed; the full step difference is not attributed | Strong observed system effect |
| Built-image Maven reuse | Runtime validation approximately 1:06 | Approximately 0:30–0:34 | Approximately 32–36s step reduction | Direct CI step measurement |
| Adaptor information | Approximately 15–21s | Approximately 11s | Approximately 4–10s visible-step improvement | Observed CI step effect |
| Trivy critical path | Final step approximately 40–49s | DB prep 28–31s in parallel; scan 14–15s | Approximately 25–35s removed from final critical-path contribution | Direct CI critical-path measurement |
| Full CI | Average 13:35 | 4:57 / 4:44 | Best observed 8:51 / 65.2% / 2.87x | Direct end-to-end measurement |

Individual rows must not be added together. Steps overlap, multiple optimisations affect the same path, Docker measurements have a different scope from CI timings, measurements were taken at different stages, and infrastructure/network variance remains.

## Non-timed Structural and Correctness Impact

| Change | Impact type | Implementation effect | Timing boundary |
| --- | --- | --- | --- |
| CI Docker/Testcontainers compatibility | Correctness/reliability | Aligns Testcontainers 1.20.4, Docker API 1.41, DIND endpoint/host override, registry authentication and the DIND-specific Ryuk setting | No isolated timing measured |
| False-green protection | Correctness | Requires Docker in CI, fails on zero/missing tests, checks completed scenarios and protects minimum feature/scenario coverage | No performance claim |
| Cucumber output and HTTP reuse | Structural | Removes verbose `pretty` formatting, reuses the HTTP client and retains required summary/reporting | No isolated timing measured |
| Redundant Maven dependency preparation | Structural | Removes dependency pre-resolution already performed by the preceding Maven lifecycle | No isolated timing measured |
| Failure diagnostics | Operability/reliability | Captures container/application evidence on failure and retains root-scope cleanup | No performance claim |
| Exact built-image validation | Correctness coverage | Proves the packaged image, entry command, permissions and runtime readiness separately from in-JVM business tests | Coverage retained; the measured step reduction comes from Maven reuse |

## Evidence Classification

- **Direct measurement:** A comparable before/after timing exists for the specific change.
- **Observed system effect:** A step or system difference exists, but multiple factors may contribute.
- **Structural improvement:** Dependency or work reduction is clear from implementation, but no isolated timing was collected.
- **Correctness improvement:** Incorrect behaviour was fixed; performance is not presented as the primary measured result.

The strongest independently visible improvements were Maven reuse in runtime validation, Trivy preparation moved off the final path, Docker layer-order behaviour in the controlled test and the Kafka Streams shutdown tail no longer being observed in representative post-fix runs.

The largest architectural change was replacing Compose-heavy integration orchestration with the Testcontainers Build/Test model. No invented duration is assigned to that migration because the older steps overlapped and their scope was not equivalent to the consolidated step.

## Why the Complete Solution Worked

- Infrastructure lifecycle moved beside the tests that define and consume it.
- Several Compose/helper-container transitions became one Maven-owned test phase.
- Stable Docker work was separated from volatile application artefacts.
- The builder/cache strategy reuses stable layers across clean CI workers.
- Verified Maven outputs are reused by focused runtime validation.
- Docker readiness, metadata extraction and Trivy preparation overlap.
- The exact built image remains independently validated.
- Scenario-count, test-discovery, Docker and readiness failures are explicit.
- Trivy database work moved without disabling vulnerability or secret scanning.

The optimisation targets lifecycle ownership, duplicate work and the dependency graph. It does not rely on summing overlapping step durations or reducing validation.

## Experiments Not Retained

| Experiment | Observation | Decision |
| --- | --- | --- |
| Maven parallel build | No reproducible benefit | Not retained |
| Background image prefetch | Slower results and no consistent benefit | Not retained |
| Logging reduction for performance | No reproducible performance gain | Not retained |
| Readiness-result caching | Changed validation semantics | Not retained |

These results prevented speculative complexity from remaining in the final design.

## Reuse Guide

### Reusable patterns

1. Measure several successful runs and identify the real critical path.
2. Restrict Docker context to inputs consumed by the Dockerfile.
3. Place expensive stable layers before frequently changing artefacts.
4. Use shared registry cache with isolated writes for independent work.
5. Move suitable infrastructure lifecycle into Testcontainers.
6. Add mandatory Docker, zero-test, scenario-count and readiness protections.
7. Validate the exact packaged image separately from in-JVM business tests.
8. Reuse verified Maven outputs instead of rebuilding upstream modules.
9. Run independent preparation work concurrently.
10. Retain diagnostics and deterministic graceful shutdown.

### Reassess per system

The following SNS details must not be copied without assessment:

- topic catalogue and dynamic suffix properties;
- minimum seven feature files and 14 business scenarios;
- party/object/location/event/service aggregates;
- EORI input, lookup and landing topics;
- private image locations and component versions;
- health paths, ports and application properties.

Establish equivalent business coverage before changing orchestration, then measure the target pipeline and retain only reproducible improvements.

## Publication Review Items

- Add Jira/Epic links.
- Add the merge request link if required.
- Add before/after pipeline screenshots.
- Link the baseline sample and measured optimised pipeline runs.
- Confirm rollout and ownership for centrally managed CI/Docker configuration.
- Convert relative Markdown links to native Confluence page links during publication.
