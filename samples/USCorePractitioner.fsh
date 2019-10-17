Profile:        USCorePractitioner
Parent:         Practitioner
Id:             us-core-practitioner
Title:          "US Core Practitioner"
Description:    "The practitioner(s) referenced in US Core profiles."
// publisher, contact, jurisdiction, other metadata here
* identifier 1..* MS
* identifier contains NPI 0..1 MS
* identifier[NPI].system MS
* identifier[NPI].system = "http://hl7.org/fhir/sid/us-npi"
* identifier[NPI].system ^short = "The namespace for the identifier value"
* name 1..* MS
* name.family 1..1 MS
