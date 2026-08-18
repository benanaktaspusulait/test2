# FDP CI/CD Optimisation — Presenter Script

Companion script for `FDP_SNS_CICD_Optimisation_Reference_Implementation_v2.pptx`

Recommended delivery time: 12–15 minutes, followed by questions.

## Slide 1 — FDP CI/CD Optimisation

Suggested time: 45 seconds

### What to say

Good morning. Today I will walk through the FDP Command Adaptor SNS CI/CD optimisation pilot.

The headline result is a reduction from a baseline average of 13 minutes 35 seconds, measured across ten successful runs, to two successful optimised runs of 4 minutes 57 seconds and 4 minutes 44 seconds. The best observed comparison represents a reduction of approximately 65 per cent, or a speed-up of about 2.87 times.

However, the main point is not simply that one pipeline became faster. I identified systemic waste, redesigned the execution model, preserved the existing validation surface, and produced an approach that can be tested for reuse elsewhere.

One evidence boundary is important from the start: 4 minutes 44 seconds is an observed result, not a guarantee for every future run.

### Visual cue

Point first to the 13:35 baseline, then to 4:44, and finish on the “~65%” card. Do not remain on the headline numbers for too long; the following slides explain why they are credible.

### Transition

Before looking at the solution, I want to explain why this pipeline was worth examining as an engineering problem.

## Slide 2 — Why this was worth looking at

Suggested time: 60 seconds

### What to say

The problem was broader than a slow Maven build. A successful pipeline took more than thirteen minutes on average, which extended the feedback loop for every code change and delayed both development and confidence in the result.

Lifecycle ownership was also distributed. Kafka, Redis, the aggregates, the command adaptor and the tests were prepared or managed across separate CI stages, Compose orchestration and helper containers. This made it harder to see which component owned startup, readiness, failure handling and cleanup.

Over time, that complexity had become normalised. A long pipeline was treated as an unavoidable property of the system rather than something that could be measured and redesigned.

The central constraint was therefore clear: make the pipeline faster without making it weaker. Business scenarios, exact-image validation, security scanning and useful failure diagnostics all had to remain.

### Visual cue

Walk down the four problem statements on the left, then move to the “Core challenge” panel on the right. Emphasise the word “without”.

### Transition

To avoid optimising by intuition, I first established an evidence-based baseline.

## Slide 3 — Baseline evidence

Suggested time: 75 seconds

### What to say

The baseline used ten successful CI runs. The average was 13 minutes 35 seconds, the median was 13 minutes 31 seconds, and the observed range was from 13 minutes 20 seconds to 13 minutes 57 seconds. The relatively narrow range shows that the long duration was repeatable rather than the result of one isolated outlier.

The chart shows the average duration visible for individual Drone steps. The command adaptor step averaged 11 minutes 1 second, integration tests 9 minutes 43 seconds, Kafka and Redis 2 minutes 18 seconds, Maven build 1 minute 24 seconds, Trivy 44 seconds, aggregators 29 seconds and pre-integration 6 seconds.

These values must not be added together. Several steps overlapped, so their sum would not represent pipeline wall-clock time. I used them to locate long-running work and understand the execution model. The end-to-end successful pipeline duration remains the primary baseline.

### Visual cue

Read the four summary cards from left to right. Then point to the two dominant bars. Finish by pointing explicitly to the yellow warning: “steps overlap — do not sum”.

### Transition

The step data led me to examine how responsibility was distributed through the original execution model.

## Slide 4 — Before: distributed lifecycle ownership

Suggested time: 70 seconds

### What to say

This is a conceptual execution model, not a literal representation of every Drone dependency. Some work overlapped in the real pipeline.

The important point is that infrastructure preparation, application startup and integration testing were spread across several stages. Secrets and Docker readiness enabled separate Kafka, Redis and aggregate preparation. Maven built the application, another stage started the command adaptor container, pre-integration checked readiness, and a later stage ran the integration suite. Trivy then performed its final work at the end.

That distribution created three forms of cost. First, CI and Compose both participated in orchestration. Second, failure evidence could be spread across services, readiness checks and test logs. Third, work such as Trivy database preparation remained on the final critical path.

The issue was therefore not any single box. It was the number of boundaries across which lifecycle ownership had to pass.

### Visual cue

Trace the upper path from left to right, then indicate the separate aggregator branch. Finish with the three consequence cards at the bottom.

### Transition

I addressed those boundaries as a coordinated redesign rather than as a collection of isolated timing tweaks.

## Slide 5 — What changed

Suggested time: 90 seconds

### What to say

The redesign covered six connected areas.

First, the Docker build context was narrowed and stable image layers were placed before volatile application artefacts. This allowed unchanged dependency work to remain reusable during warm rebuilds.

Second, the integration environment moved to Testcontainers. Redis, Kafka, Schema Registry and the aggregate services became part of the test-owned lifecycle, while the application under business testing ran in the test JVM.

Third, I added reliability protections: minimum scenario counts, hard failure when Docker is required but unavailable, and protection against a test phase succeeding with zero tests.

Fourth, validation of the exact built Docker image remained as a separate runtime gate.

Fifth, verified Maven outputs were reused instead of preparing or resolving the same work again.

Finally, Trivy database preparation was moved earlier so it could overlap with other setup. The final security scan was retained.

The design rule at the bottom summarises the approach: keep validations, remove duplicate work, overlap independent preparation, and revert experiments that do not help.

### Visual cue

Move through the tiles by theme rather than reading every sentence: Docker, test ownership, guardrails, exact-image validation, reuse and Trivy. End on the design rule.

### Transition

Those changes produce a much simpler ownership model, which is shown on the next slide.

## Slide 6 — After: consolidated test-owned lifecycle

Suggested time: 80 seconds

### What to say

After secrets are retrieved, three independent preparation activities can begin in parallel: waiting for Docker, extracting adaptor information and preparing the Trivy database.

Docker readiness and adaptor information feed the build-and-test stage. In that stage, Testcontainers owns the lifecycle of Redis, Kafka, Schema Registry and the aggregate services. The business scenario suite runs against the application in the test JVM, which removes the need for a separately orchestrated application container during that suite.

The pipeline then builds the real Docker image, starts and validates that exact image, and finally performs the Trivy scan. These correctness gates remain sequential because each validates the output of the previous stage.

The Trivy database preparation path joins the final scan only when it is needed. Security scanning was not removed and Trivy itself was not claimed to have become faster; its preparation work was moved off the final critical path.

### Visual cue

Show the three-way split after “Retrieve secrets”. Follow the central path through Testcontainers, image build and runtime validation. Then trace the red Trivy preparation line to the final scan.

### Transition

With that execution model in place, I measured the complete pipeline again.

## Slide 7 — Measured result

Suggested time: 75 seconds

### What to say

The baseline average was 13 minutes 35 seconds, or 815 seconds. The two measured successful optimised runs completed in 4 minutes 57 seconds and 4 minutes 44 seconds.

Using the best observed run for the headline comparison, 815 seconds reduced to 284 seconds. That is a saving of 531 seconds, or 8 minutes 51 seconds. It represents an approximately 65.2 per cent reduction and a speed-up of about 2.87 times.

This is an end-to-end result. It is not calculated by adding the individual optimisation measurements shown later.

The optimised sample currently contains two successful runs, so it should not be presented as a permanent service-level guarantee. What it demonstrates is that the redesigned execution model can deliver a substantially shorter feedback loop while retaining the required gates.

### Visual cue

Compare the height of the baseline bar with both optimised bars. Then point to the three calculated metrics on the right and finish with the yellow evidence warning.

### Transition

The end-to-end result is the main outcome; the next slide shows the supporting component-level evidence and its limitations.

## Slide 8 — Component-level comparison

Suggested time: 120 seconds

### What to say

This slide compares timed areas for which I have meaningful before-and-after evidence, but the rows have different measurement boundaries and must not be added together.

For Docker layer ordering, a controlled warm rebuild reduced from approximately 75.82 to 77.90 seconds before the change to approximately 4.62 to 5.08 seconds afterwards. This is a same-environment warm-rebuild observation, not a claim that every CI run saves that full amount.

Runtime validation of the built image reduced from about 1 minute 6 seconds to between 30 and 34 seconds. Exact-image validation remained; the reduction came from reusing Maven artefacts and avoiding duplicate preparation.

Adaptor information reduced from an observed range of roughly 15 to 21 seconds to around 11 seconds.

The final Trivy path reduced from roughly 40 to 49 seconds to around 14 to 15 seconds. The scanner was retained. The change came from preparing its database earlier and outside the final critical path, not from making the Trivy scan engine faster.

Finally, an approximately 30-second Kafka Streams shutdown tail was no longer observed in representative post-fix runs. That is deliberately phrased as an observation rather than a guarantee that no future shutdown variance can occur.

Testcontainers migration, concurrent aggregate startup and false-green protections were also important, but I do not assign them isolated savings because no defensible like-for-like timing exists.

### Visual cue

Compare each orange bar with its teal counterpart. Pause at the “How to read this” card before discussing the rows. Finish on the green “Structural changes” card.

### Transition

Performance evidence matters only if the optimised path still validates the same product behaviour and release artefact.

## Slide 9 — What was deliberately preserved

Suggested time: 80 seconds

### What to say

The optimisation retained all 14 business scenarios. Minimum feature and scenario guardrails ensure that an accidental reduction in the suite cannot silently produce a faster green build.

In CI, Docker is a required dependency. If it is unavailable, the integration path fails rather than quietly skipping container-backed tests. The Maven Failsafe configuration also protects against a successful phase with zero integration tests, and the separate JUnit coverage guard remains distinct from the 14 business scenarios.

The exact Docker image produced by the pipeline is still started and validated independently after the business test suite. This preserves the distinction between testing application behaviour in the JVM and proving that the packaged runtime artefact can start correctly.

Trivy vulnerability and secret scanning, its existing reporting policy, and failure diagnostics also remain in place.

The principle is simple: faster CI is not an improvement if fewer validations execute or if failures become less visible.

### Visual cue

Move down the retained-validation list, then pause on the large green guardrail statement. This is the slide to use when addressing concerns about reduced coverage.

### Transition

The same evidence-led approach also showed which experiments should not become part of the final solution.

## Slide 10 — What I chose not to keep

Suggested time: 75 seconds

### What to say

Not every plausible optimisation improved the outcome.

Maven parallelism did not produce a reproducible end-to-end benefit for this workload, so I did not retain the additional tuning.

Background image prefetching was slower in some observations and produced no consistent improvement, so it was removed rather than adding another coordination path.

Reducing logging did not show a reproducible performance gain. Useful diagnostics were therefore preserved.

Caching readiness results could have reduced repeated checks, but it changed the meaning of the validation by allowing a previous result to stand in for a current readiness check. I rejected that trade-off.

These experiments were still valuable. Measuring them prevented unsupported assumptions from becoming permanent complexity and kept the final design focused on changes with evidence or a clear correctness benefit.

### Visual cue

Read the table by row: experiment, observation, decision. Finish on the green learning statement rather than on the red “Not retained” labels.

### Transition

That leaves a measured reference implementation and a controlled path for deciding whether it should be reused elsewhere.

## Slide 11 — Result and next step

Suggested time: 75 seconds

### What to say

The result is a successful-pipeline baseline average of 13 minutes 35 seconds compared with observed optimised runs of 4 minutes 57 seconds and 4 minutes 44 seconds. The best observed comparison is approximately 65.2 per cent shorter and about 2.87 times faster.

The next step is not to copy every implementation detail across the estate immediately. First, SNS should be confirmed as the reference case and the conditions that make the approach applicable should be documented.

Second, the pattern should be applied to two or three representative repositories with different build and test characteristics. That will show which elements are reusable standards and which are service-specific choices.

Third, standard patterns and guardrails should be defined for Docker caching, Testcontainers lifecycle ownership, exact-image validation, false-green protection and security scanning.

Finally, a technical enablement session can share the evidence, implementation pattern and adoption checklist before wider rollout is considered.

This pilot demonstrates a repeatable engineering model: measure, redesign, protect correctness, validate and standardise.

### Visual cue

Start with the 13:35-to-4:57/4:44 comparison. Then walk through the four roadmap points from left to right. End on the closing message at the bottom.

### Final transition

I will stop there and take questions on the measurements, the architecture or the criteria for applying this pattern to another repository.

## Short opening script

Good morning. This presentation covers the FDP Command Adaptor SNS CI/CD optimisation pilot. The result was a substantial reduction in successful pipeline duration, but the more important outcome was the method: I measured the existing system, redesigned lifecycle ownership, preserved validation and rejected changes that did not produce defensible value. I will cover the original problem, the evidence, the before-and-after execution models, the measured impact and the proposed path to reuse.

## Short closing script

To conclude, the SNS pipeline moved from a 13-minute-35-second successful-run average to observed runs below five minutes, without removing business scenarios, exact-image validation or security scanning. The pilot should now be treated as a reference implementation, validated against two or three representative repositories, and converted into standards only where the evidence supports reuse. The repeatable pattern is: measure, redesign, protect correctness, validate and standardise.

## Delivery guardrails

- Describe 4:44 as the best observed successful run, never as a guaranteed future duration.
- Treat 13:35 as the average of ten successful baseline runs.
- Do not add visible Drone step durations; several steps overlapped.
- Do not add component-level savings to derive the end-to-end saving.
- Say that Trivy database preparation moved off the final critical path; do not say that security scanning was removed or that Trivy itself became faster.
- Say that all 14 business scenarios and the separate runtime and security gates were retained.
- Describe Docker warm-rebuild timings as controlled observations, not as universal CI savings.
