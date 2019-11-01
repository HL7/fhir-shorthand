Alias:          LOINC = http://loinc.org

Profile:        USCorePediatricBMIForAge "US Core Pediatric BMI for Age Observation Profile"
Parent:         http://hl7.org/fhir/StructureDefinition/vitalsigns
Id:             pediatric-bmi-for-age
Title:          "US Core Pediatric BMI for Age Observation Profile"
Description:    """
    Defines constraints and extensions on the Observation resource for use 
    in querying and retrieving pediatric BMI observations."""
// publisher, contact, jurisdiction, other metadata here
// NOTE: MS can also be done in multiple lines:
// * valueQuantity.value MS
// * valueQuantity.unit MS
// ...
* valueQuantity.value, valueQuantity.unit, valueQuantity.system, valueQuantity.code MS
* code ^short = "BMI percentile per age and sex for youth 2-20"
* code.coding 1..*
* code.coding.system 1..1
* code.coding.code 1..1
* code.coding = LOINC#59576-9
* value[x] only valueQuantity
* valueQuantity 1..1
* valueQuantity.value 1..1
* valueQuantity.unit 1..1
* valueQuantity.system 1..1
* valueQuantity.system = "http://unitsofmeasure.org"
* valueQuantity.code 1..1
* valueQuantity.code = #%
* valueQuantity.code ^short = "Coded responses from the common UCUM units for vital signs value set."