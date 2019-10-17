Alias:          RACE = urn:oid:2.16.840.1.113883.6.238
Alias:          MR = http://terminology.hl7.org/CodeSystem/v2-0203

Instance:       PatientExample 
Title: "Patient Example"
InstanceOf:     USCorePatient
* id = "example"
* us-core-race.ombCategory[0].valueCoding = RACE#2160-3 "White"
* us-core-race.ombCategory[1].valueCoding = RACE#1002-5 "American Indian or Alaska Native"
* us-core-race.ombCategory[2].valueCoding = RACE#2028-9 "Asian"
* us-core-race.detailed[0].valueCoding = RACE#1586-7 "Shoshone"
* us-core-race.detailed[1].valueCoding = RACE#2036-2 "Filipino"
* us-core-race.text.valueString = "Mixed"
* us-core-ethnicity.ombCategory.valueCoding = RACE#2135-2 "Hispanic or Latino"
* us-core-ethnicity.detailed[0].valueCoding = RACE#2184-0 "Dominican"
* us-core-ethnicity.detailed[1].valueCoding = RACE#2148-5 "Mexican"
* us-core-ethnicity.text.valueString = "Hispanic or Latino"
* us-core-birthsex.valueCode = #F
* identifier.use = #usual
* identifier.type.coding = MR#MR "Medical Record Number"
* identifier.type.text = "Medical Record Number"
* identifier.system = "http://hospital.smarthealthit.org"
* identifier.value = "1032702"
* active = true
* name.family = "Shaw"
* name.given[0] = "Amy"
* name.given[1] = "V."
* telecom[0].system = #phone
* telecom[0].value = "555-555-5555"
* telecom[0].use = #home
* telecom[1].system = #email
* telecom[1].value = "amy.shaw@example.com"
* gender = #female
* birthDate = "2007-02-20"
* address.line = "49 Meadow St"
* address.city = "Mounds"
* address.state = "OK"
* address.postalCode = "74047"
* address.country = "US"
