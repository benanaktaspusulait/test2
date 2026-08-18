# FDP CI/CD Optimisation — Concise Presenter Script

Companion script for `FDP_SNS_CICD_Optimisation_Reference_Implementation_v2.pptx`

Target delivery time: approximately 10–12 minutes, or 12–14 minutes with pauses and visual emphasis.

## Slide 1 — FDP CI/CD Optimisation

Suggested time: 40–50 seconds

### Script

Good morning. This presentation covers the FDP Command Adaptor SNS CI/CD optimisation pilot.

The successful-pipeline baseline averaged 13 minutes 35 seconds across ten successful runs. 

The two measured optimized runs completed in 4 minutes 57 seconds and 4 minutes 44 seconds. 

The best observed comparison is approximately 65 percent shorter and about 2.87 times faster.

The main result is not simply a faster pipeline. I identified systemic waste, redesigned the execution model, preserved the validation surface and produced an approach that can be evaluated for reuse elsewhere.

The 4-minute-44-second result is an observed run, not a guarantee for every future execution. I will first explain the problem and baseline, then the architecture, evidence and proposed next steps.

### Visual cue

Point to 13:35, then 4:44 and finally the ~65% card.

## Slide 2 — Why this was worth looking at

Suggested time: 50–60 seconds

### Script

The issue was broader than a slow build. A successful pipeline took more than thirteen minutes on average, delaying feedback for every code change.

Lifecycle ownership was distributed across CI stages, Compose and helper containers. Kafka, Redis, aggregates, the command adaptor and the tests had separate startup, readiness and failure paths. 
That made the pipeline harder to understand and troubleshoot.

Over time, the duration had become normalized rather than actively challenged. The optimization therefore had one non-negotiable constraint: make the pipeline faster without making it weaker. 
Business scenarios, exact-image validation, security scanning and useful diagnostics all had to remain.

The first step was to establish a reliable baseline rather than optimize by intuition.

### Visual cue

Move down the four issues on the left, then emphasise the core challenge on the right.

## Slide 3 — Baseline evidence

Suggested time: 65–75 seconds

### Script

The baseline contains ten successful CI runs. The average was 13 minutes 35 seconds, the median 13 minutes 31 seconds, and the range 13 minutes 20 seconds to 13 minutes 57 seconds. 
This narrow range shows that the long duration was repeatable rather than caused by one outlier.

The chart shows visible step averages. Command Adaptor averaged 11 minutes 1 second, Integration Tests 9 minutes 43 seconds, 
Kafka and Redis 2 minutes 18 seconds, Maven build 1 minute 24 seconds, Trivy 44 seconds, Aggregators 29 seconds and Pre-Integration 6 seconds.

These values must not be added together because several Drone steps overlapped. I used them to locate long-running work and understand the execution model. 
The end-to-end successful-pipeline duration remains the primary baseline.

That analysis led directly to the original lifecycle design.

### Visual cue

Cover the four statistics, indicate the two dominant bars, then point to “steps overlap — do not sum”.

## Slide 4 — Before: distributed lifecycle ownership

Suggested time: 55–65 seconds

### Script

This is a conceptual model, not an exact Drone dependency graph; some work overlapped in practice.

Infrastructure preparation, application startup and testing were split across several stages. Secrets and Docker readiness enabled Kafka, Redis and aggregate preparation. 
Maven built the application, another stage started the command adaptor container, pre-integration checked readiness, and a later stage ran integration tests before Trivy completed the final path.

This created orchestration overhead across CI and Compose, distributed failure evidence across multiple components, and kept work such as Trivy database preparation on the final critical path.

The main problem was therefore not one slow box. It was lifecycle ownership passing through too many boundaries. I addressed those boundaries as a coordinated redesign.

### Visual cue

Trace the main path, indicate the separate aggregator branch, then summarise the three consequence cards.

## Slide 5 — What changed

Suggested time: 75–85 seconds

### Script

The redesign covered six connected areas.

The Docker context was narrowed, and stable layers were placed before volatile application artifacts so unchanged work could be reused during warm rebuilds.

The integration environment moved to Testcontainers. Redis, Kafka, Schema Registry and aggregate services became part of the test-owned lifecycle, while the application under business testing ran in the test JVM.

I added minimum scenario counts, Docker-required hard failure and zero-test protection to prevent false-green results. The exact built Docker image continued to be started and checked separately.

Verified Maven outputs were reused instead of repeating preparation. Trivy database work moved earlier so it could overlap with other setup, while the final security scan remained.

The design rule was consistent throughout: keep validations, remove duplicate work, overlap independent preparation, and revert experiments that did not help.

### Visual cue

Move through Docker, test ownership, guardrails, runtime validation, Maven reuse and Trivy; finish on the design rule.

## Slide 6 — After: consolidated test-owned lifecycle

Suggested time: 65–75 seconds

### Script

After secrets are retrieved, three independent activities begin in parallel: waiting for Docker, extracting adaptor information and preparing the Trivy database.

Docker readiness and adaptor information feed the build-and-test stage. Testcontainers then owns Redis, Kafka, Schema Registry and aggregate-service lifecycles. 
The business scenarios run against the application in the test JVM, removing the need for a separately orchestrated application container during that suite.

The pipeline then builds the real Docker image, validates that exact image at runtime and performs the final Trivy scan. These gates remain sequential because each validates the output of the previous stage.

Security scanning was not removed, and Trivy itself was not claimed to be faster. Its database preparation simply moved away from the final critical path.

### Visual cue

Show the three-way parallel split, follow the central validation path, then trace the red Trivy line to the final scan.

## Slide 7 — Measured result

Suggested time: 60–70 seconds

### Script

The baseline average was 13 minutes 35 seconds, or 815 seconds. The two successful optimized runs completed in 4 minutes 57 seconds and 4 minutes 44 seconds.

Using the best observed run for the headline comparison, the duration reduced from 815 to 284 seconds. That is a saving of 531 seconds, or 8 minutes 51 seconds, 
representing approximately 65.2 percent and a speed-up of about 2.87 times.

This is an end-to-end observation, not a total created by adding individual optimization measurements. The optimized sample currently contains two successful runs, so 4 minutes 44 seconds must not be presented as a permanent guarantee.

The evidence nevertheless demonstrates that the redesigned model can deliver a substantially shorter feedback loop while retaining the required gates.

### Visual cue

Compare the three bars, then point to the saving, percentage and speed-up cards before highlighting the warning.

## Slide 8 — Component-level comparison

Suggested time: 90–105 seconds

### Script

These rows provide supporting before-and-after evidence, but their measurement boundaries differ and the values are not additive.

A controlled Docker warm rebuild reduced from approximately 76 to 78 seconds to approximately 5 seconds. This is not a universal CI-saving claim.

Built-image runtime validation reduced from about 66 seconds to 30–34 seconds because Maven artifacts were reused; the exact-image check remained. Adaptor information reduced from an observed 15–21 seconds to around 11 seconds.

The final Trivy path reduced from approximately 40–49 seconds to 14–15 seconds because database preparation moved earlier. The scanner was retained; Trivy itself was not claimed to run faster.

An approximately 30-second Kafka Streams shutdown tail was no longer observed in representative post-fix runs. This remains an observation, not a universal guarantee.

Testcontainers migration, concurrent aggregate startup and false-green protection were also important, but I do not assign isolated savings where no defensible like-for-like timing exists.

### Visual cue

Pause on “How to read this”, compare the orange and teal bars, then finish with the structural-changes panel.

## Slide 9 — What was deliberately preserved

Suggested time: 60–70 seconds

### Script

All 14 business scenarios were retained. Minimum feature and scenario guardrails prevent an accidental reduction in the suite from silently creating a faster green result.

Docker is required in CI, so the integration path fails if it is unavailable rather than skipping container-backed tests. 
Maven Failsafe also protects against a successful integration phase with zero tests, and the separate JUnit coverage guard remains distinct from the business scenarios.

The exact Docker image produced by the pipeline is still started and validated after the business suite. This proves that the packaged runtime artifact can start correctly, independently of in-JVM business testing.

Trivy vulnerability and secret scanning, the existing reporting policy and failure diagnostics also remain.

The central principle is that faster CI is not an improvement if fewer validations execute or failures become less visible.

### Visual cue

Move down the retained-validation list, then pause on the large green guardrail statement.

## Slide 10 — What I chose not to keep

Suggested time: 55–65 seconds

### Script

Not every plausible optimization improved the result.

Maven parallelism produced no reproducible end-to-end benefit, so I did not retain the additional tuning. 
Background image prefetching was slower in some observations and produced no consistent gain, so that extra coordination path was removed.

Reducing logging also produced no reproducible performance improvement, so useful diagnostics remained. 
Readiness-result caching could have removed repeated checks, but it changed validation semantics by allowing an earlier result to replace a current readiness check. I rejected that trade-off.

These experiments were still valuable. Measuring and reverting them prevented unsupported assumptions from becoming permanent complexity and kept the final implementation focused on evidence and correctness.

### Visual cue

Read each table row as experiment, observation and decision; finish on the green learning statement.

## Slide 11 — Result and next step

Suggested time: 65–75 seconds

### Script

The final comparison is a successful-pipeline baseline average of 13 minutes 35 seconds against observed optimized runs of 4 minutes 57 seconds and 4 minutes 44 seconds. 
The best observed result is approximately 65.2 percent shorter and about 2.87 times faster.

The next step is controlled validation rather than immediate estate-wide copying. SNS should first be confirmed as the reference case and its applicability conditions documented.

The pattern should then be applied to two or three representative repositories with different build and test characteristics. That will distinguish reusable standards from service-specific choices.

Standard patterns and guardrails can then be defined for Docker caching, Testcontainers ownership, exact-image validation, false-green protection and security scanning. 
A technical enablement session can share the evidence and adoption checklist before wider rollout is considered.

The repeatable model is: measure, redesign, protect correctness, validate and standardize. Thank you for listening

### Visual cue

Start with the timing comparison, follow the four roadmap points from left to right, and end on the closing message.

## Presenter guardrails

- Describe 4:44 as the best observed successful run, not a guaranteed duration.
- Do not add overlapping Drone step durations or component-level savings.
- Do not say security scanning was removed or that Trivy itself became faster.
- State that all 14 business scenarios and the separate runtime and security gates were retained.
- Describe Docker warm-rebuild timings as controlled observations rather than universal CI savings.
