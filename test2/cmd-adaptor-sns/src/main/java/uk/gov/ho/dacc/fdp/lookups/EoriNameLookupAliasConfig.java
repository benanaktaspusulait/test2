package uk.gov.ho.dacc.fdp.lookups;

import org.springframework.beans.BeansException;
import org.springframework.beans.factory.config.ConfigurableListableBeanFactory;
import org.springframework.beans.factory.config.BeanFactoryPostProcessor;
import org.springframework.stereotype.Component;

@Component
public class EoriNameLookupAliasConfig implements BeanFactoryPostProcessor {

    public static final String EORI_NAME_LOOKUP = "eoriNameLookup";
    public static final String EORI_DECLARANT_NAME_LOOKUP = "eoriDeclarantNameLookup";
    public static final String EORI_M_SHIPPER_NAME_LOOKUP = "eoriMShipperNameLookup";
    public static final String EORI_C_SHIPPER_NAME_LOOKUP= "eoriCShipperNameLookup";

    @Override
    public void postProcessBeanFactory(ConfigurableListableBeanFactory beanFactory) throws BeansException {
        beanFactory.registerAlias(EORI_NAME_LOOKUP, EORI_DECLARANT_NAME_LOOKUP);
        beanFactory.registerAlias(EORI_NAME_LOOKUP, EORI_M_SHIPPER_NAME_LOOKUP);
        beanFactory.registerAlias(EORI_NAME_LOOKUP, EORI_C_SHIPPER_NAME_LOOKUP);
    }
}




