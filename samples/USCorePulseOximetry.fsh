CodeSystem:     LOINC = http://loinc.org

Profile:        USCorePulseOximetry "US Core Pulse Oximetry Profile"
Parent:         http://hl7.org/fhir/StructureDefinition/oxygensat
Id:             us-core-pulse-oximetry
Title:          "US Core Pulse Oximetry Profile"
Description:    """
    Defines constraints and extensions on the Observation resource for use in 
    querying and retrieving inspired O2 by pulse oximetry observations."""
// publisher, contact, jurisdiction, other metadata here
* code MS
* code ^short = "Oxygen Saturation by Pulse Oximetry"
* code.coding MS
* code.coding contains PulseOx 1..1 MS
* code.coding[PulseOx].system MS
* code.coding[PulseOx].code MS
* code.coding[PulseOx] = LOINC#59408-5
* component contains FlowRate 0..1 MS and Concentration 0..1 MS
* component[FlowRate] ^short = "Inhaled oxygen flow rate"
* component[FlowRate].code = LOINC#3151-8
* component[FlowRate].value[x] only Quantity
* component[FlowRate].valueQuantity MS
* component[FlowRate].valueQuantity.value MS
* component[FlowRate].valueQuantity.unit MS
* component[FlowRate].valueQuantity.system 1..1 MS
* component[FlowRate].valueQuantity.system = "http://unitsofmeasure.org"
* component[FlowRate].valueQuantity.code 1..1 MS
* component[FlowRate].valueQuantity.code = "l/min"
* component[Concentration].code MS
* component[Concentration].code = LOINC#3150-0
* component[Concentration].value[x] only Quantity
* component[Concentration].valueQuantity MS
* component[Concentration].valueQuantity.value MS
* component[Concentration].valueQuantity.unit MS
* component[Concentration].valueQuantity.system 1..1 MS
* component[Concentration].valueQuantity.system = "http://unitsofmeasure.org"
* component[Concentration].valueQuantity.code 1..1 MS
* component[Concentration].valueQuantity.code = "%"