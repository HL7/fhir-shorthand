Extension:      FSHBirthSex
Id:             fsh-birthsex
Title:          "FSH Birth Sex Extension"
Description:     """
    A code classifying the person's sex assigned at birth as specified
    by the [Office of the National Coordinator for Health IT (ONC)](https://www.healthit.gov/newsroom/about-onc).
    This extension aligns with the C-CDA Birth Sex Observation (LOINC 76689-9)."""
* value[x] only code
* valueCode from http://hl7.org/fhir/us/core/ValueSet/birthsex (required)
