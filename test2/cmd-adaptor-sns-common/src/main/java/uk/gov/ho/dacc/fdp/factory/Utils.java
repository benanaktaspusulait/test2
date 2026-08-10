package uk.gov.ho.dacc.fdp.factory;

import java.util.ArrayList;
import java.util.List;

public class Utils {

    private Utils() {
        // private constructor to hide implicit public one
    }

    private static List<String> splitField(String field) {
        String fieldWithoutSpecialCharacters = field.trim().replaceAll("[^ #;:/a-zA-Z0-9]", "");
        String[] splitField = fieldWithoutSpecialCharacters.split("([ #;:/])");

        return List.of(checkedPlates(new ArrayList<>(List.of(splitField)), 0).split(" "));
    }

    public static String getVehiclePlate(String field) {
        return splitField(field).get(0);
    }

    public static String getTrailerPlate(String field) {
        List<String> trailerPlates = splitField(field);
        return trailerPlates.size() <= 1 ? null : trailerPlates.get(1);
    }

    public static List<String> getTrailerPlates(String field) {
        if (splitField(field).size() > 1) {
            return splitField(field).subList(1, splitField(field).size());
        } else {
            return new ArrayList<>();
        }
    }

    public static String checkedPlates(List<String> plates, int currentIdx) {
        if (currentIdx == plates.size())
            return String.join(" ", plates);
        else if (plates.get(currentIdx).length() > 4) {
            return checkedPlates(plates, currentIdx + 1);
        } else {
            boolean isLast = currentIdx == plates.size() - 1;
            String current = plates.get(currentIdx);
            String nextWord = !isLast ? plates.get(currentIdx + 1) : "";
            String newWord = current + nextWord;
            int newIdx = newWord.length() > 4 || isLast ? 1 : 0;
            plates.set(currentIdx, newWord);
            if (!isLast) plates.remove(currentIdx + 1);

            return checkedPlates(plates, currentIdx + newIdx);
        }
    }
}
