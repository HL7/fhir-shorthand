Alias:          RXNORM = http://www.nlm.nih.gov/research/umls/rxnorm

Profile:        USCoreMedicationRequest
Parent:         MedicationRequest
Id:             us-core-medicationrequest
Title:          "US Core Medication Request"
Description:    """
    Defines constraints and extensions on the MedicationRequest resource 
    for the minimal set of data to query and retrieve prescription information."""
// publisher, contact, jurisdiction, other metadata here
// NOTE: MS can also be done in multiple lines:
// * status MS
// * intent MS
// ...
* status, intent, reported[x], medication[x], subject, encounter, authoredOn,
  requester, dosageInstruction, dosageInstruction.text MS
* reported[x] only boolean or Reference(USCorePatient 
    | USCorePractitioner 
    | PractitionerRole 
    | USCoreOrganization 
    | RelatedPerson)
* medication[x] only CodeableConcept or Reference(USCoreMedication)
* medicationCodeableConcept from USCoreMedicationCodes (extensible)
* subject only Reference(USCorePatient)
* authoredOn 1..1
* requester 1..1
* requester only Reference(USCorePractitioner
    | PractitionerRole
    | USCoreOrganization
    | USCorePatient
    | USCoreImplantableDevice
    | RelatedPerson)

ValueSet:       USCoreMedicationCodes
Id:             us-core-medication-codes
Title:          "US Core Medication Codes (RxNorm)"
Description:    """
    All prescribable medication formulations represented using either a 'generic' or 
    'brand-specific' concept. This includes RxNorm codes whose Term Type is SCD 
    (semantic clinical drug), SBD (semantic brand drug), GPCK (generic pack), 
    BPCK (brand pack), SCDG (semantic clinical drug group), 
    SBDG (semantic brand drug group), SCDF (semantic clinical drug form), or 
    SBDF (semantic brand drug form)""" 
// publisher, contact, jurisdiction, other metadata here
* include RXNORM TTY in "SCD,SBD,GPCK,BPCK,SCDG,SBDG,SCDF,SBDF"


