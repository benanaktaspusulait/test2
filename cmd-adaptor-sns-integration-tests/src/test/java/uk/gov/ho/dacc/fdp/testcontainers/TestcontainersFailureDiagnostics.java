package uk.gov.ho.dacc.fdp.testcontainers;

import org.junit.jupiter.api.extension.BeforeAllCallback;
import org.junit.jupiter.api.extension.ExtensionContext;
import org.junit.jupiter.api.extension.TestWatcher;

public final class TestcontainersFailureDiagnostics implements BeforeAllCallback, TestWatcher {
    private static final ExtensionContext.Namespace NAMESPACE =
            ExtensionContext.Namespace.create(TestcontainersFailureDiagnostics.class);
    private static final String SUITE_RESOURCE = "sns-testcontainers-suite";

    @Override
    public void beforeAll(ExtensionContext context) {
        context.getRoot()
                .getStore(NAMESPACE)
                .getOrComputeIfAbsent(SUITE_RESOURCE, key -> new SuiteResource(), SuiteResource.class);
    }

    @Override
    public void testFailed(ExtensionContext context, Throwable cause) {
        SnsTestcontainersEnvironment.dumpContainerLogs(
                "JUnit test failed: " + context.getDisplayName() + " — " + cause.getMessage());
    }

    private static final class SuiteResource implements ExtensionContext.Store.CloseableResource {
        @Override
        public void close() {
            SnsTestcontainersEnvironment.shutdown();
        }
    }
}
