Profile:        FSHPatient
Parent:         Patient
Id:             fsh-patient
Title:          "FSH Patient"
Description:    """ 
    Defines constraints and extensions on the patient resource for 
    the minimal set of data to query and retrieve patient demographic information."""
// NOTE: MS can also be done in multiple lines:
// * identifier MS
// * identifier.system MS
// ...
* identifier, identifier.system, identifier.value, name, name.family, name.given,
  telecom, telecom.system, telecom.value, telecom.use, gender, birthDate, address,
  address.line, address.city, address.state, address.postalCode, communication,
  communication.language MS
* identifier 1..*
* identifier.system 1..1
* identifier.value 1..1
* name 1..*
* telecom.system 1..1
* telecom.system from http://hl7.org/fhir/ValueSet/contact-point-system (required)
* telecom.value 1..1
* telecom.use from http://hl7.org/fhir/ValueSet/contact-point-use (required)
* gender 1..1
* gender from http://hl7.org/fhir/ValueSet/administrative-gender  (required)