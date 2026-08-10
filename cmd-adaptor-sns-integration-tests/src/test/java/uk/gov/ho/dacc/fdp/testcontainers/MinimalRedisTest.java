package uk.gov.ho.dacc.fdp.testcontainers;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Tag;
import org.junit.jupiter.api.Test;
import org.testcontainers.containers.GenericContainer;
import org.testcontainers.junit.jupiter.Testcontainers;
import redis.clients.jedis.Jedis;

import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;

@Tag("testcontainers")
@Testcontainers(disabledWithoutDocker = true)
class MinimalRedisTest {

    static final GenericContainer<?> REDIS =
            SnsTestcontainersEnvironment.redisContainer();

    private Jedis client;

    private Jedis createClient() {
        return new Jedis(
                REDIS.getHost(),
                REDIS.getMappedPort(6379)
        );
    }

    @AfterEach
    void tearDown() {
        if (client != null) {
            client.close();
        }
    }

    @Test
    void pingReturnsPong() {
        client = createClient();

        assertEquals(
                "PONG",
                client.ping(),
                "Redis PING should return PONG"
        );
    }

    @Test
    void setAndGetUniqueKey() {
        client = createClient();

        String key = "minimal-redis-" + UUID.randomUUID();
        String value = "test-value-" + UUID.randomUUID();

        String setResult = client.set(key, value);

        assertEquals("OK", setResult);

        String retrieved = client.get(key);

        assertNotNull(retrieved);
        assertEquals(value, retrieved);

        Long deleted = client.del(key);

        assertEquals(1L, deleted);
        assertNull(client.get(key));
    }
}