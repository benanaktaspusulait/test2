# Optimise FDP Command Adaptor PNR CI/CD Pipeline

## Description

Analyse and optimise the `fdp-cmd-adaptor-pnr` CI/CD pipeline using the SNS implementation as a reference pattern.

The work should identify the current pipeline's critical path, duplicated work and unnecessary orchestration. Applicable improvements may include Docker build optimisation, Testcontainers-based integration testing, Maven artefact reuse, parallel preparation steps and security-scan cache preparation.

SNS-specific configuration must not be copied without validating its suitability for PNR.

## Key Requirements

- Measure the current successful pipeline duration.
- Preserve the existing business-test coverage.
- Prevent false-green results, including skipped or zero-test executions.
- Preserve validation of the exact Docker image produced by CI.
- Preserve Trivy vulnerability and secret scanning.
- Retain useful failure diagnostics.
- Implement only improvements applicable to the PNR repository.
- Avoid unrelated refactoring or additional documentation.

## Acceptance Criteria

- Current pipeline architecture and baseline duration are recorded.
- Applicable optimisations are implemented and verified.
- Existing business scenarios and correctness gates continue to run.
- Docker-required CI tests fail if Docker is unavailable.
- The exact built image is validated before security scanning.
- Security scanning behaviour and policy remain unchanged.
- At least two successful optimised pipeline runs are measured where possible.
- Results and evidence limitations are included in the Jira task or merge request.
- The final change contains no unrelated files or generated artefacts.
