Profile:        FSHMedicationRequest
Parent:         MedicationRequest
Id:             fsh-medicationrequest
Title:          "FSH Medication Request"
Description:    """
    Defines constraints and extensions on the
    MedicationRequest resource for the minimal set of data to query and retrieve
    prescription information."""
* status, intent, reported[x], medication[x], subject, encounter, authoredOn,
  requester, dosageInstruction, dosageInstruction.text MS
* reported[x] only boolean or Reference(Practitioner
    | PractitionerRole
    | Organization
    | RelatedPerson)
* medication[x] only CodeableConcept
* medicationCodeableConcept from http://hl7.org/fhir/us/core/ValueSet/us-core-medication-codes (extensible)
* subject only Reference(Patient)
* authoredOn 1..1
* requester 1..1
* requester only Reference(Practitioner
    | PractitionerRole
    | Organization
    | Device
    | RelatedPerson)

