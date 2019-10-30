Instance:       USCorePatientBirthdate
InstanceOf:     SearchParameter
Id:             us-core-patient-birthdate
Description:    """
    The patient's date of birth<br />\n<em>NOTE</em>: 
    This US Core SearchParameter definition extends the usage context of\n
    <a href=\"http://hl7.org/fhir/R4/extension-capabilitystatement-expectation.html\">
    capabilitystatement-expectation</a>\n extension to formally express implementer 
    expectations for these elements:<br />\n - multipleAnd<br />\n - multipleOr<br />\n
     - modifier<br />\n - comparator<br />\n - chain<br />\n """
// version, status, experimental, date, publisher, contact, jurisdiction
* derivedFrom = "http://hl7.org/fhir/SearchParameter/individual-birthdate"
* code = #birthdate
* base = #Patient
* type = #date
* expression = "Patient.birthDate"
* xpath = "f:Patient/f:birthDate"
* xpathUsage = #normal
* multipleOr = true
* multipleAnd = true
* comparator[0] = #eq
* comparator[1] = #ne
* comparator[2] = #ge
* comparator[3] = #lt
* comparator[4] = #le
* comparator[5] = #sa
* comparator[6] = #eb
* comparator[7] = #ap
* modifier = #missing