Alias:     LOINC = http://loinc.org

Profile:        FSHRespRate
Parent:         vitalsigns
Id:             fsh-resprate
Title:          "FSH Respiratory Rate"
Description:    "Respiratory Rate Profile"
* code 1..1
* code = LOINC#9279-1
* value[x] only Quantity
* valueQuantity.value, valueQuantity.unit, valueQuantity.system, valueQuantity.code MS
* valueQuantity.system = "http://unitsofmeasure.org"
* valueQuantity.code = #/min