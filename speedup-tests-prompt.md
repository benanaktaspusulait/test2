Daha kısa ve Jira’ya direkt yapıştırılabilir hali:

**Title:**
**Optimise SNS Test Execution and CI Performance**

**Description:**
Improve SNS test execution and CI feedback time without reducing test coverage, reliability or existing validation.

Focus on:

* Kafka polling and wait-time optimisation
* Reducing unnecessary test logging/setup
* Testcontainers startup and readiness optimisation
* Parallel startup of independent containers/services
* Maven parallel build optimisation
* Removing redundant CI/test work where safe

**Acceptance Criteria:**

* All existing business scenarios continue to execute successfully.
* Test coverage and existing quality/false-green protections remain unchanged.
* Testcontainers and aggregate services start/readiness-check efficiently, using safe concurrency where applicable.
* Kafka polling and timing behaviour is optimised without weakening correlation/assertions.
* Maven/CI parallelism is used only where stable.
* Built-image runtime validation and Trivy remain active.
* Final CI execution shows a measurable improvement with no reliability regression.

**Out of Scope:**
Business logic changes, removal of tests/validation, or changes that reduce test confidence.
