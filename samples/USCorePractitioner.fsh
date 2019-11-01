Profile:        USCorePractitioner
Parent:         Practitioner
Id:             us-core-practitioner
Title:          "US Core Practitioner"
Description:    "The practitioner(s) referenced in US Core profiles."
// publisher, contact, jurisdiction, other metadata here
// NOTE: MS can also be done in multiple lines:
// * identifier MS
// * name MS
// ...
* identifier, identifier[NPI].system, name, name.family MS
* identifier 1..*
* identifier contains NPI 0..1 MS
* identifier[NPI].system = "http://hl7.org/fhir/sid/us-npi"
* identifier[NPI].system ^short = "The namespace for the identifier value"
* name 1..*
* name.family 1..1
