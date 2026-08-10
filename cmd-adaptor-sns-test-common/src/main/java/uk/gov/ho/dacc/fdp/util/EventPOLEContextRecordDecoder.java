package uk.gov.ho.dacc.fdp.util;

import io.confluent.kafka.schemaregistry.client.CachedSchemaRegistryClient;
import io.confluent.kafka.schemaregistry.client.SchemaRegistryClient;
import io.confluent.kafka.schemaregistry.client.rest.exceptions.RestClientException;
import org.apache.avro.Schema;
import org.apache.avro.message.RawMessageDecoder;
import uk.gov.ho.dacc.fdp.log.EventPOLEContextRecord;
import uk.gov.ho.dacc.rl.entry.AvroPayloadRecord;

import java.io.IOException;


/**
 * This class is responsible for  decode payload (ByteArray ) to EventPOLEContextRecord
 */
public class EventPOLEContextRecordDecoder {

    /**
     * decode payload  to EventPOLEContextRecord
     * @param schemaRegistryUrl - for getting write schema
     * @param avroPayloadRecord -
     * @return
     * @throws IOException
     * @throws RestClientException
     */
    public static EventPOLEContextRecord decodeMessage(String schemaRegistryUrl, AvroPayloadRecord avroPayloadRecord) throws IOException, RestClientException {
        EventPOLEContextRecord eventPOLEContextRecord = EventPOLEContextRecord.newBuilder().build();
        Schema writeSchema = getWriteSchema(schemaRegistryUrl, avroPayloadRecord.getSchemaSubject().toString(), avroPayloadRecord.getSchemaVersion());
        RawMessageDecoder<EventPOLEContextRecord> rmd = new RawMessageDecoder(eventPOLEContextRecord.getSpecificData(), writeSchema, eventPOLEContextRecord.getSchema());
        return rmd.decode(avroPayloadRecord.getPayload());
    }

    /**
     * This method gets write schema (the one used by the Adaptor) for EventPOLEContextRecord from Schema Registry
     * @param schemaRegistryUrl
     * @param schemaSubject
     * @param version
     * @return
     * @throws RestClientException
     * @throws IOException
     */
    private static Schema getWriteSchema(String schemaRegistryUrl, String schemaSubject, int version) throws RestClientException, IOException {
        SchemaRegistryClient schemaRegistryClient = new CachedSchemaRegistryClient(schemaRegistryUrl, 5);
        return (Schema) schemaRegistryClient.getSchemaBySubjectAndId(schemaSubject, version).rawSchema();
    }

}