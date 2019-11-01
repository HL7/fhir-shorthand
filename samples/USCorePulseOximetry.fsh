CodeSystem:     LOINC = http://loinc.org

Profile:        USCorePulseOximetry "US Core Pulse Oximetry Profile"
Parent:         http://hl7.org/fhir/StructureDefinition/oxygensat
Id:             us-core-pulse-oximetry
Title:          "US Core Pulse Oximetry Profile"
Description:    """
    Defines constraints and extensions on the Observation resource for use in 
    querying and retrieving inspired O2 by pulse oximetry observations."""
// publisher, contact, jurisdiction, other metadata here
// NOTE: MS can also be done in multiple lines:
// * code MS
// * code.coding MS
// ...
* code, code.coding, code.coding[PulseOx].system, code.coding[PulseOx].code,
  component[FlowRate].valueQuantity, component[FlowRate].valueQuantity.value,
  component[FlowRate].valueQuantity.unit, component[FlowRate].valueQuantity.system
  component[FlowRate].valueQuantity.code, component[Concentration].code,
  component[Concentration].valueQuantity, component[Concentration].valueQuantity.value,
  component[Concentration].valueQuantity.unit, component[Concentration].valueQuantity.system,
  component[Concentration].valueQuantity.code MS
* code ^short = "Oxygen Saturation by Pulse Oximetry"
* code.coding contains PulseOx 1..1 MS
* code.coding[PulseOx] = LOINC#59408-5
* component contains FlowRate 0..1 MS and Concentration 0..1 MS
* component[FlowRate] ^short = "Inhaled oxygen flow rate"
* component[FlowRate].code = LOINC#3151-8
* component[FlowRate].value[x] only Quantity
* component[FlowRate].valueQuantity.system 1..1
* component[FlowRate].valueQuantity.system = "http://unitsofmeasure.org"
* component[FlowRate].valueQuantity.code 1..1
* component[FlowRate].valueQuantity.code = "l/min"
* component[Concentration].code = LOINC#3150-0
* component[Concentration].value[x] only Quantity
* component[Concentration].valueQuantity
* component[Concentration].valueQuantity.system 1..1
* component[Concentration].valueQuantity.system = "http://unitsofmeasure.org"
* component[Concentration].valueQuantity.code 1..1
* component[Concentration].valueQuantity.code = "%"