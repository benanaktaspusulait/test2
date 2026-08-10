package uk.gov.ho.dacc.fdp.service;

import org.apache.kafka.streams.KeyValue;
import org.junit.Test;
import uk.gov.ho.dacc.fdp.tracing.TraceSpanCreator;
import uk.gov.ho.dacc.rl.metadata.IdentityRecord;

import java.util.Map;

import static org.junit.Assert.assertSame;
import static org.junit.Assert.assertThrows;
import static org.mockito.ArgumentMatchers.anyMap;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;

public class TraceIdentityRecordTransformerTest {

    @Test
    public void transform_shouldCreateSpanAndReturnSameKeyAndValue() {
        TraceSpanCreator traceSpanCreator = mock(TraceSpanCreator.class);
        TraceIdentityRecordTransformer<String> transformer = new TraceIdentityRecordTransformer<>(traceSpanCreator);
        IdentityRecord key = IdentityRecord.newBuilder().setId("identity-1").build();
        String value = "payload";

        KeyValue<IdentityRecord, String> result = transformer.transform(key, value);

        assertSame(key, result.key);
        assertSame(value, result.value);
        verify(traceSpanCreator).createSpan("add-identityRecord", Map.of("identityRecord", "identity-1"));
    }

    @Test
    public void transform_shouldThrowNullPointerExceptionWhenKeyIsNull() {
        TraceSpanCreator traceSpanCreator = mock(TraceSpanCreator.class);
        TraceIdentityRecordTransformer<String> transformer = new TraceIdentityRecordTransformer<>(traceSpanCreator);

        assertThrows(NullPointerException.class, () -> transformer.transform(null, "payload"));

        verify(traceSpanCreator, never()).createSpan(eq("add-identityRecord"), anyMap());
    }
}

