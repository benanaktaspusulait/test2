package uk.gov.ho.dacc.fdp.service;


import lombok.extern.slf4j.Slf4j;
import org.apache.kafka.streams.KeyValue;
import org.apache.kafka.streams.kstream.Transformer;
import org.apache.kafka.streams.processor.ProcessorContext;
import uk.gov.ho.dacc.fdp.tracing.TraceSpanCreator;
import uk.gov.ho.dacc.rl.metadata.IdentityRecord;

import java.util.Map;

@Slf4j
public class TraceIdentityRecordTransformer<T> implements Transformer<IdentityRecord, T, KeyValue<IdentityRecord, T>> {

    private final TraceSpanCreator traceSpanCreator;
    private ProcessorContext context;

    public TraceIdentityRecordTransformer(TraceSpanCreator traceSpanCreator) {
        this.traceSpanCreator = traceSpanCreator;
    }

    @Override
    public void init(ProcessorContext context) {
        this.context = context;
    }

    @Override
    public KeyValue<IdentityRecord, T> transform(IdentityRecord key, T value) {
        traceSpanCreator.createSpan("add-identityRecord", Map.of("identityRecord", key.getId().toString()));
        return KeyValue.pair(key, value);
    }

    @Override
    public void close() {
        // not implementing
    }
}
