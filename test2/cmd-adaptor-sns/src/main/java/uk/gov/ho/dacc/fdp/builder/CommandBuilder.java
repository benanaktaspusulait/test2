package uk.gov.ho.dacc.fdp.builder;

import lombok.extern.slf4j.Slf4j;
import org.apache.avro.specific.SpecificRecordBase;
import org.apache.commons.codec.binary.Base64;
import org.apache.kafka.streams.KeyValue;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import uk.gov.ho.dacc.fdp.avro.AvroMutator;
import uk.gov.ho.dacc.fdp.fdp_commons.util.DateParser;
import uk.gov.ho.dacc.fdp.transform.ITransform;
import uk.gov.ho.dacc.fdp.transform.TransformationException;
import uk.gov.ho.dacc.pole.identity.PoleV2IdRecord;

import java.time.Instant;
import java.time.format.DateTimeFormatter;

import static org.apache.commons.lang3.StringUtils.isEmpty;
import static org.apache.commons.lang3.StringUtils.isNotBlank;

@Slf4j
@Component
public abstract class CommandBuilder<T extends SpecificRecordBase, P extends SpecificRecordBase> {

    private static final String DATE_TIME_FORMAT = "yyyy-MM-dd'T'HH:mm:ss['Z']";
    public static final DateTimeFormatter formatter = DateTimeFormatter.ofPattern(DATE_TIME_FORMAT);

    @Autowired
    protected CommonBuilder commonBuilder;

    public abstract <S> KeyValue<PoleV2IdRecord, T> buildCommand(final S streamIngestRecord) throws TransformationException, NoSuchMethodException, ClassNotFoundException;

    protected abstract String getCommandBuilderNameForMetrics();

    protected Instant convertDateToInstant(CharSequence date) {
        try {
            if (isEmpty(date)) {
                return null;
            } else {
                Instant instant = DateParser.parseToInstant(date);
                log.debug("DateParser parsed date string - {} to instant - {}", date, instant);
                return instant;
            }
        } catch (Exception e) {
            log.error("Error parsing date {} with format {}", date, DATE_TIME_FORMAT, e);
            return null;
        }
    }

    protected CharSequence base64Encode(final CharSequence field) {
        if (isNotBlank(field)) {
            return Base64.encodeBase64String(field.toString().getBytes());
        }
        return null;
    }

    protected abstract <S> ITransform<S, AvroMutator<P>> getTransformer();
}
