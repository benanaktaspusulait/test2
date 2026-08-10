package uk.gov.ho.dacc.fdp.lookups;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.support.DefaultListableBeanFactory;

import static org.assertj.core.api.Assertions.assertThat;

class EoriNameLookupAliasConfigTest {

    @Test
    void shouldRegisterAliasForEoriNameLookup() {
        DefaultListableBeanFactory beanFactory = new DefaultListableBeanFactory();
        Object lookupBean = new Object();
        beanFactory.registerSingleton(EoriNameLookupAliasConfig.EORI_NAME_LOOKUP, lookupBean);

        new EoriNameLookupAliasConfig().postProcessBeanFactory(beanFactory);

        assertThat(beanFactory.isAlias(EoriNameLookupAliasConfig.EORI_DECLARANT_NAME_LOOKUP)).isTrue();
        assertThat(beanFactory.getAliases(EoriNameLookupAliasConfig.EORI_NAME_LOOKUP))
                .contains(EoriNameLookupAliasConfig.EORI_DECLARANT_NAME_LOOKUP);
        assertThat(beanFactory.getBean(EoriNameLookupAliasConfig.EORI_DECLARANT_NAME_LOOKUP))
                .isSameAs(beanFactory.getBean(EoriNameLookupAliasConfig.EORI_NAME_LOOKUP));
        assertThat(beanFactory.isAlias(EoriNameLookupAliasConfig.EORI_M_SHIPPER_NAME_LOOKUP)).isTrue();
        assertThat(beanFactory.getAliases(EoriNameLookupAliasConfig.EORI_NAME_LOOKUP))
                .contains(EoriNameLookupAliasConfig.EORI_M_SHIPPER_NAME_LOOKUP);
        assertThat(beanFactory.getBean(EoriNameLookupAliasConfig.EORI_M_SHIPPER_NAME_LOOKUP))
                .isSameAs(beanFactory.getBean(EoriNameLookupAliasConfig.EORI_NAME_LOOKUP));
        assertThat(beanFactory.isAlias(EoriNameLookupAliasConfig.EORI_C_SHIPPER_NAME_LOOKUP)).isTrue();
        assertThat(beanFactory.getAliases(EoriNameLookupAliasConfig.EORI_NAME_LOOKUP))
                .contains(EoriNameLookupAliasConfig.EORI_C_SHIPPER_NAME_LOOKUP);
        assertThat(beanFactory.getBean(EoriNameLookupAliasConfig.EORI_C_SHIPPER_NAME_LOOKUP))
                .isSameAs(beanFactory.getBean(EoriNameLookupAliasConfig.EORI_NAME_LOOKUP));
    }
}



