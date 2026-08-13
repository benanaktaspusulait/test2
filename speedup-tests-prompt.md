Repository:
/Users/benanaktas/project/home-office/test2

Task:
Implement the remaining CI optimisations for exactly two targets:

1. Trivy database/cache reuse
2. Extract Adaptor Information

This is an evidence-first implementation. Work on the targets in that order.
Do not create Markdown, TODO, benchmark, report, debug, or temporary repository files.
Do not commit or push.

======================================================================
CONFIRMED REPOSITORY EVIDENCE
======================================================================

Current HEAD:
2d312c0fa32e28afdec8989e614b8e532868279b

The worktree was clean at the beginning of the investigation.

Current stable full CI duration:
approximately 5:19–5:22

Observed target durations:
Trivy:                       approximately 40–49s
Extract Adaptor Information: approximately 15–21s

Relevant files:
.drone.star
bin/adaptor-info.sh
bin/generate-mr.sh
pom.xml

Both `.drone.star` and `bin/adaptor-info.sh` state that they are managed by
RepoSync. Make the requested local repository changes, but mention in the final
response that equivalent changes may need to be made in the canonical RepoSync
source. Do not attempt to modify another repository without authorization.

======================================================================
NON-NEGOTIABLE RULES
======================================================================

Do not:

- change test coverage
- change production behaviour
- weaken Trivy scanning
- add `--skip-db-update`
- add `--skip-java-db-update`
- restrict scanners to `vuln`
- disable secret scanning
- alter `--severity CRITICAL,HIGH`
- alter `--ignore-unfixed`
- alter the existing `--exit-code 0` policy
- vendor Trivy databases
- manually copy individual Trivy database files
- add a serial Trivy DB download step
- use a workspace directory as a fake persistent cache
- invent a Kubernetes PVC or host path
- hard-code Maven version values
- parse stale generated files
- remove the Extract Adaptor Information step
- make unrelated pipeline changes
- leave temporary timing instrumentation
- create documentation
- commit or push

Keep a change only when correctness is unchanged and the performance improvement
is supported by evidence.

======================================================================
PART 1 — TRIVY CACHE
======================================================================

Current Trivy image:

340268328991.dkr.ecr.eu-west-2.amazonaws.com/acp/trivy/client:latest

Current command:

trivy image \
--exit-code 0 \
--no-progress \
docker-compose-command-adaptor:latest \
--severity CRITICAL,HIGH \
--ignore-unfixed \
--db-repository acp-zot-helm.acp-zot.svc.cluster.local/ecr/aquasecurity/trivy-db \
--java-db-repository acp-zot-helm.acp-zot.svc.cluster.local/ecr/aquasecurity/trivy-java-db

Confirmed repository findings:

- `.drone.star` does not set `TRIVY_CACHE_DIR`.
- The Trivy command does not pass `--cache-dir`.
- `blank_pipeline()` defines no pipeline-level volumes.
- The Trivy step defines no volume mounts.
- No Drone cache plugin is configured.
- No Trivy cache/PVC/host-path convention exists in the repository or its
  available Git history.
- Moving the cache into `/drone/src`, `${PWD}`, or another workspace path would
  only share it inside one build. There is one Trivy scan per build, so that
  alone provides no cross-build benefit.
- Whether the Kubernetes Drone runner injects a persistent volume externally
  cannot be proven from this repository.
- The internal Trivy image is not available in the local Docker daemon.
- The internal DB hostname is cluster-local, so local reproduction of the exact
  CI scan is not currently possible.
- Local Trivy is version 0.61.0 and supports the global `--cache-dir` flag, but
  this does not prove the version or default directory of the internal CI image.

Required investigation before editing:

1. Determine the exact Trivy version used in CI.
2. Determine the container user and HOME.
3. Print or derive Trivy’s effective default cache directory.
4. Determine whether the rendered Drone pipeline or Kubernetes pod receives any
   runner-injected volume not visible in `.drone.star`.
5. Check the platform/RepoSync source for an approved cache PVC, host volume, or
   supported cache plugin.
6. Establish whether that mechanism persists across different Drone build pods
   and whether concurrent builds can use it safely.

Temporary CI diagnostics may include:

trivy --version
printf 'TRIVY_CACHE_DIR=%s\n' "${TRIVY_CACHE_DIR:-<unset>}"
trivy --help | grep -A1 -- '--cache-dir'
id
printf 'HOME=%s\n' "$HOME"
mount
df -h

Remove these diagnostics from the retained diff unless they are useful,
non-sensitive operational metadata already accepted by the project.

Implementation gate:

- If an existing, approved, cross-build persistent cache mechanism is found,
  use it.
- If none can be proven, do not create an arbitrary PVC or hostPath.
- In that case, leave Trivy unchanged and report the exact blocker:
  “A supported cross-build Drone/Kubernetes cache volume is required.”

When a supported persistent volume exists:

1. Mount it only into the Trivy step at a dedicated directory.
2. Set an explicit `TRIVY_CACHE_DIR`.
3. Pass the same directory explicitly with:

   --cache-dir "$TRIVY_CACHE_DIR"

4. Allow Trivy to own the directory layout and metadata.
5. Do not address DB files by their internal filenames.
6. Keep the current DB and Java DB repository options.
7. Do not add either skip-update option.
8. Confirm the cache is writable by the Trivy container user.
9. Confirm parallel builds do not corrupt or contend unsafely on the cache.
10. Do not place cache contents inside the Git workspace.

Required Trivy validation:

Run the full CI twice with only the Trivy cache change applied.

For each run capture from normal CI logs:

- Trivy version
- effective cache directory
- cache directory persistence evidence
- vulnerability DB download/update behaviour
- Java DB download/update behaviour
- scan duration
- complete command flags
- scan result

Expected semantics:

First cold run:
Trivy may download the vulnerability and Java databases.

Second warm run:
Trivy checks normal metadata/freshness and reuses valid databases.

A future stale cache:
Trivy must refresh it according to its normal freshness rules.

The absence of `--skip-db-update` and `--skip-java-db-update` is mandatory.

Keep the Trivy change only if:

- the second build demonstrably sees the first build’s cache
- security scanners and filtering flags are unchanged
- normal freshness checks remain enabled
- full CI remains green
- the saving is reproducible and larger than random 1–2 second noise

If restoring/uploading a cache through a cache plugin consumes approximately the
same time as downloading the databases, revert the change.

Do not add a separate DB warm-up step merely to move the same duration earlier.

======================================================================
PART 2 — EXTRACT ADAPTOR INFORMATION
======================================================================

Do not begin this implementation until the Trivy experiment has either been
kept, reverted, or explicitly blocked.

Confirmed current implementation:

`bin/adaptor-info.sh` runs four separate Maven commands:

1. aggregator-core.version
2. fdp-bom.version
3. cdlz-avro-schemas.version
4. fdp-commons.version

Each command invokes:

org.apache.maven.plugins:maven-help-plugin:3.2.0:evaluate

Therefore the current step starts four Maven JVMs and performs four Maven model
resolution sessions.

All four properties are defined directly in the root `pom.xml`:

aggregator-core.version       = root pom.xml property
fdp-bom.version               = root pom.xml property
cdlz-avro-schemas.version     = root pom.xml property
fdp-commons.version           = root pom.xml property

No repository Maven profile overrides these four properties.
No `.mvn/maven.config` or repository-level Maven CLI override was found.

However, direct grep/sed XML parsing is not the preferred implementation because
the current command reports effective Maven values and Maven/user property
resolution must remain consistent.

A safe repository precedent already exists in `bin/generate-mr.sh`:

POM_PROPERTIES=$(
echo '${project.version}:${aggregator-core.version}:${fdp-bom.version}:${cdlz-avro-schemas.version}:${fdp-commons.version}' |
mvn org.apache.maven.plugins:maven-help-plugin:3.2.0:evaluate \
-N \
-q \
-DforceStdout
)

That script evaluates multiple properties using one Maven invocation and avoids
building the reactor with `-N`.

Additional confirmed evidence:

- The CI Maven image is:
  quay.io/ukhomeofficedigital/ileap-java17-mvn:1.3
- Its `/root/.m2/settings.xml` obtains Artifactory credentials from:
  ARTIFACTORY_USERNAME
  ARTIFACTORY_PASSWORD
- Its configured local repository is the relative path:
  .m2
- In Extract Adaptor Information this resolves to workspace `/.m2`.
- The later Build and Test step explicitly uses:
  ${PWD}/.m2/repository
- The two steps therefore currently use different Maven repository paths.
- A local failure-path diagnostic showed approximately 3–4 seconds per Maven
  invocation, which is consistent with four Maven starts contributing most of
  the observed 15–21 seconds. It was not a successful functional benchmark
  because private artifact access was unavailable.

Required implementation:

1. Replace the four Maven evaluations with exactly one Maven invocation.
2. Follow the established `bin/generate-mr.sh` pattern.
3. Use `-N` so Maven resolves only the root project.
4. Evaluate all four properties in a deterministic delimiter-separated value.
5. Split that value into four variables without hard-coding any version.
6. Preserve the CDLZ fallback:
   `null object or invalid expression` must still become `N/A`.
7. Preserve the exact four output rows and ordering:

   | Aggregator Core | <value> |
   | FDP BOM | <value> |
   | CDLZ Avro Schemas | <value-or-N/A> |
   | FDP Commons | <value> |

8. Keep the script compatible with its `#!/bin/sh` shebang.
9. Prefer POSIX `[ ... ]` over `[[ ... ]]` when touching the fallback logic.
10. Do not add Python, Java, xmlstarlet, jq, curl, or a new dependency.

Align Maven repository use:

- Allow `adaptor-info.sh` to use `MAVEN_REPO_LOCAL` when provided.
- Preserve the current `.m2` behaviour as the local fallback.
- In `.drone.star`, set Extract Adaptor Information to use:

  ${PWD}/.m2/repository

- Pass it to Maven with `-Dmaven.repo.local=...`.
- This must match Build and Test with Testcontainers exactly.
- Do not delete or clean that repository between the two steps.
- This allows any root POM, BOM, or plugin resolution performed by Extract to
  be reused by the subsequent Maven build.

Optimise the dependency graph safely:

Current serial graph:

Retrieve Artifactory Secrets
-> Wait for Docker
-> Extract Adaptor Information
-> Build and Test with Testcontainers

`adaptor-info.sh` does not use Docker. It only requires the sourced Artifactory
credentials because Maven resolves through the Artifactory mirror.

Change the graph to:

Retrieve Artifactory Secrets
-> Wait for Docker

Retrieve Artifactory Secrets
-> Extract Adaptor Information

Wait for Docker + Extract Adaptor Information
-> Build and Test with Testcontainers

Concretely:

- Extract Adaptor Information must depend on Retrieve Artifactory Secrets.
- Build and Test with Testcontainers must depend on both:
  Wait for Docker
  Extract Adaptor Information

This preserves Docker readiness while allowing version extraction and Docker
startup to overlap.

Do not accidentally allow Build and Test to start before Docker is ready.

Required adaptor-info validation:

1. Capture current output from an environment with Artifactory access.
2. Time the four-command version.
3. Apply only the single-Maven-invocation change.
4. Capture the new output.
5. Compare all four lines byte-for-byte, ignoring only timing output.
6. Run twice to distinguish cold and warm Maven repository behaviour.
7. Confirm the new script launches exactly one Maven process.
8. Confirm the effective values are:
   Aggregator Core:   10.3.11
   FDP BOM:           3.2.11
   CDLZ Avro Schemas: 1.2.2
   FDP Commons:       5.2.9
9. Confirm no value is hard-coded in `adaptor-info.sh`.
10. Render the Drone feature and develop pipelines.
11. Confirm every dependency points to an existing step.
12. Confirm there is no dependency cycle.
13. Run shell syntax validation on all changed command blocks.

If access to private Artifactory dependencies is unavailable locally, do not
claim a successful functional Maven test. Perform static validation and use an
actual CI run for the output comparison.

======================================================================
MEASUREMENT ORDER
======================================================================

Do not measure the two changes together initially.

Experiment 1:
Trivy cache only
Full CI run 1
Full CI run 2
Keep, revert, or report platform blocker

Experiment 2:
adaptor-info single Maven invocation and safe dependency parallelism
Full CI run 1
Full CI run 2
Keep or revert

Only after both isolated experiments are accepted should their combined overall
pipeline duration be compared with the 5:19–5:22 baseline.

Do not claim the target of less than five minutes unless full CI evidence shows
it.

======================================================================
FINAL VALIDATION
======================================================================

Run:

git diff --check
git status --short
git diff -- .drone.star bin/adaptor-info.sh
sh -n bin/adaptor-info.sh

Validate `.drone.star` syntax and render applicable pipeline contexts.

Confirm:

- no Markdown files changed
- no TODO files changed
- no cache files are tracked
- no timing/debug files remain
- no security flag changed
- no test configuration changed
- no unrelated file changed
- `set_drone_secrets.sh` behaviour is unchanged
- Slack functions are unchanged
- no commit or push was made

Expected changed files:

.drone.star
bin/adaptor-info.sh

If no supported Trivy persistence exists, expected changed files may be only:

.drone.star
bin/adaptor-info.sh

where `.drone.star` changes are limited to the Maven repository alignment and
dependency graph. Do not retain a non-functional Trivy cache path.

======================================================================
FINAL RESPONSE
======================================================================

Reply in chat only, maximum 18 lines.

Include:

TRIVY:
- effective cache directory
- persistence across builds: YES/NO/UNPROVEN
- mechanism used or exact blocker
- DB refresh semantics preserved: YES/NO
- security coverage changed: YES/NO
- baseline, run 1, run 2
- change kept/reverted/not implemented

ADAPTOR INFO:
- root cause
- Maven process count before/after
- repository resolution sessions before/after
- baseline, run 1, run 2
- output unchanged: YES/NO
- dependency overlap implemented: YES/NO

Also include:
- files changed
- overall CI baseline/after
- validation result
- blocker, if any
- explicit statement that no commit or push was made