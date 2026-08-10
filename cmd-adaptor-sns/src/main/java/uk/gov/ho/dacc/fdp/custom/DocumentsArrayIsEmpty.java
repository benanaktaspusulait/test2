package uk.gov.ho.dacc.fdp.custom;

import org.springframework.stereotype.Component;
import uk.gov.ho.dacc.fdp.transform.ICustomMapping;

import java.util.List;

@Component("DocumentsArrayIsEmpty")
public class DocumentsArrayIsEmpty implements ICustomMapping {
    @Override
    public String apply(List<Object> list) {
        List documents = (List) list.get(0);
        return String.valueOf(documents.isEmpty());
    }
}
