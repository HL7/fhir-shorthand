Alias:          USPS = https://usps.com
Alias:          BCP47 = urn:ietf:bcp:47
Alias:          RACE = urn:oid:2.16.840.1.113883.6.238
Alias:          NUL = http://terminology.hl7.org/CodeSystem/v3-NullFlavor
Alias:          GEN = http://terminology.hl7.org/CodeSystem/v3-AdministrativeGender
Alias:          COUNTRY = urn:iso:std:iso:3166


Profile:        USCorePatient
Parent:         Patient
Id:             us-core-patient
Title:          "US Core Patient Profile"
Description:    """ 
    Defines constraints and extensions on the patient resource for 
    the minimal set of data to query and retrieve patient demographic information."""
* ^version = "3.1.0"
* ^status = #active
* ^experimental = false
* ^publisher = "HL7 US Realm Steering Committee"
* ^contact.telecom.system = #url
* ^contact.telecom.value = "http://www.healthit.gov"
* ^jurisdiction.coding = COUNTRY#US "United States of America"
* ^fhirVersion = "4.0.0"
* extension contains 
    USCoreRaceExtension 0..1 MS and 
    USCoreEthnicityExtension 0..1 MS and 
    USCoreBirthsexExtension 0..1 MS
* identifier 1..* MS 
* identifier.system 1..1 MS
* identifier.value 1..1 MS
* identifier.value ^short = "The value that is unique within the system"
* name 1..* MS
* name obeys us-core-8
* name.family MS
* name.given MS
* telecom MS
* telecom.system 1..1 MS
* telecom.system from http://hl7.org/fhir/ValueSet/contact-point-system (required)
* telecom.value 1..1 MS
* telecom.use MS
* telecom.use from http://hl7.org/fhir/ValueSet/contact-point-use (required)
* gender 1..1 MS
* gender from http://hl7.org/fhir/ValueSet/administrative-gender // (required)
* birthDate MS
* address MS
* address.line MS
* address.city MS
* address.state MS 
* address.state from USPSTwoLetterAlphabeticCodes (extensible)
* address.postalCode MS
* address.postalCode ^short = "US Zip Codes"
* communication MS
* communication.language MS
* communication.language from LanguageCodesWithLanguageAndOptionallyARegionModifier (extensible)

Extension:      USCoreRaceExtension
Id:             us-core-race
Title:          "US Core Race Extension"
Description:    """
    Concepts classifying the person into a named category of humans sharing 
    common history, traits, geographical origin or nationality.  The race codes 
    used to represent these concepts are based upon the 
    [CDC Race and Ethnicity Code Set Version 1.0](http://www.cdc.gov/phin/resources/vocabulary/index.html) 
    which includes over 900 concepts for representing race and ethnicity of which 921 reference race.  
    The race concepts are grouped by and pre-mapped to the 5 OMB race categories: - 
    American Indian or Alaska Native - Asian - Black or African American - Native Hawaiian 
    or Other Pacific Islander - White."""
// publisher, contact, jurisdiction, other metadata here
* extension contains ombCategory 0..5 MS and detailed 0..* and text 1..1 MS
* extension[ombCategory] ^short = """
    American Indian or Alaska Native|Asian|Black or 
    African American|Native Hawaiian or Other Pacific Islander|White"""
// * extension[ombCategory].url = "ombCategory" - Can be inferred from slice names above
* extension[ombCategory].value[x] only Coding
* extension[ombCategory].valueCoding from OmbRaceCategories // (required)
* extension[detailed] ^short = "Extended race codes"
* extension[detailed].value[x] only Coding
* extension[detailed].valueCoding from DetailedRace // (required)
* extension[text] ^short = "Race Text"
* extension[text].value[x] only string

Extension:      USCoreEthnicityExtension
Id:             us-core-ethnicity
Title:          "US Core Ethnicity Extension"
Description:    """
    Concepts classifying the person into a named category of humans 
    sharing common history, traits, geographical origin or nationality.  
    The ethnicity codes used to represent these concepts are based upon the 
    [CDC ethnicity and Ethnicity Code Set Version 1.0](http://www.cdc.gov/phin/resources/vocabulary/index.html)
    which includes over 900 concepts for representing race and ethnicity of which 43 
    reference ethnicity.  The ethnicity concepts are grouped by and pre-mapped 
    to the 2 OMB ethnicity categories: - Hispanic or Latino - Not Hispanic or Latino."""
// publisher, contact, jurisdiction, other metadata here
* extension contains ombCategory 0..1 MS and detailed 0..* and text 1..1 MS
* extension[ombCategory] ^short = "Hispanic or Latino|Not Hispanic or Latino"
* extension[ombCategory].value[x] only Coding
* extension[ombCategory].valueCoding from OmbEthnicityCategories (required)
* extension[detailed] ^short = "Extended ethnicity codes"
* extension[detailed].value[x] only Coding
* extension[detailed].valueCoding from DetailedEthnicity (required)
* extension[text] ^short = "ethnicity Text"
* extension[text].value[x] only string

Extension:      USCoreBirthSexExtension 
Id:             us-core-birthsex
Title:          "US Core Birth Sex Extension"
Description:     """
    A code classifying the person's sex assigned at birth as specified 
    by the [Office of the National Coordinator for Health IT (ONC)](https://www.healthit.gov/newsroom/about-onc). 
    This extension aligns with the C-CDA Birth Sex Observation (LOINC 76689-9)."""
// publisher, contact, jurisdiction, other metadata here
* value[x] only code
* valueCode from BirthSex (required)

ValueSet:       USPSTwoLetterAlphabeticCodes
Id:             us-core-usps-state
Title:          "USPS Two Letter Alphabetic Codes"
Description:    "This value set defines two letter USPS alphabetic codes"
* ^copyright = """
    On July 1, 1963, the Post Office Department implemented the five-digit 
    ZIP Code, which was placed after the state name in the last line of an 
    address. To provide room for the ZIP Code, the Department issued two-letter 
    abbreviations for all states and territories. Publication 59, Abbreviations 
    for Use with ZIP Code, issued by the Department in October 1963. Currently 
    there is no copyright restriction on this value set."""
// publisher, contact, jurisdiction, other metadata here
USPS#AK "Alaska"
USPS#AL "Alabama"
USPS#AR "Arkansas"
// ... More codes below

ValueSet:       LanguageCodesWithLanguageAndOptionallyARegionModifier
Id:             simple-language
Title:          "Language Codes With Language and Optionally a Region Modifier"
Description:     """
    This value set includes codes from BCP-47. This value set matches 
    the ONC 2015 Edition LanguageCommunication data element value set 
    within C-CDA to use a 2 character language code if one exists, and a 
    3 character code if a 2 character code does not exist. It points back 
    to RFC 5646, however only the language codes are required, all other 
    elements are optional."""
// publisher, contact, jurisdiction, other metadata here
* include BCP47 ext-lang    exists false
* include BCP47 script      exists false
* include BCP47 variant     exists false
* include BCP47 extension   exists false
* include BCP47 private-use exists false

ValueSet:       OmbRaceCategories
Id:             omb-race-category
Title:          "Omb Race Categories"
Description:     """
    The codes for the concepts 'Unknown' and  'Asked but no answer' 
    and the the codes for the five race categories - 'American Indian'
    or 'Alaska Native', 'Asian', 'Black or African American', 
    'Native Hawaiian or Other Pacific Islander', and 'White' - as defined by 
    the [OMB Standards for Maintaining, Collecting, and
    Presenting Federal Data on Race and Ethnicity, Statistical Policy Directive 
    No. 15, as revised, October 30, 1997](https://www.whitehouse.gov/omb/fedreg_1997standards). """
// publisher, contact, jurisdiction, other metadata here
RACE#1002-5 "American Indian or Alaska Native"
RACE#2028-9 "Asian"
RACE#2054-5 "Black or African American"
RACE#2076-8 "Native Hawaiian or Other Pacific Islander"
RACE#2106-3 "White"
NUL#UNK     "Unknown"
NUL#ASKU    "Asked but no answer"

ValueSet:       DetailedRace
Id:             detailed-race
Title:          "Detailed Race"
Description:     """
    The 900+ [CDC Race codes](http://www.cdc.gov/phin/resources/vocabulary/index.html) 
    that are grouped under one of the 5 OMB race category codes."""
// publisher, contact, jurisdiction, other metadata here
* include concept is-a RACE#1000-9
* exclude RACE#1002-5
* exclude RACE#2028-9
* exclude RACE#2054-5
* exclude RACE#2076-8
* exclude RACE#2106-3

ValueSet:       OmbEthnicityCategories
Id:             omb-ethnicity-category
Title:          "Omb Ethnicity Categories"
Description:    """
    The codes for the ethnicity categories - 'Hispanic or Latino' and 
    'Non Hispanic or Latino' - as defined by the [OMB Standards for Maintaining,
    Collecting, and Presenting Federal Data on Race and Ethnicity, Statistical
    Policy Directive No. 15, as revised, October 30, 1997](https://www.whitehouse.gov/omb/fedreg_1997standards)."""
// publisher, contact, jurisdiction, other metadata here
RACE#2135-2 "Hispanic or Latino"
RACE#2186-5 "Non Hispanic or Latino"

ValueSet:       DetailedEthnicity
Id:             detailed-ethnicity
Title:          "Detailed Ethnicity"
Description:     """
    The 41 [CDC ethnicity codes](http://www.cdc.gov/phin/resources/vocabulary/index.html) 
    that are grouped under one of the 2 OMB ethnicity category codes."""
// publisher, contact, jurisdiction, other metadata here
* include concept is-a RACE#2133-7
* exclude RACE#2135-2
* exclude RACE#2186-5

ValueSet:       BirthSex
Id:             birthsex
Title:          "Birth Sex"
Description:    """
    Codes for assigning sex at birth as specified by the 
    [Office of the National Coordinator for Health IT (ONC)](https://www.healthit.gov/newsroom/about-onc)"""
// publisher, contact, jurisdiction, other metadata here
GEN#F   "Female"
GEN#M   "Male"
NUL#UNK "Unknown"

Invariant:      us-core-8
Description:    "Patient.name.given  or Patient.name.family or both SHALL be present"
Expression:     "family.exists() or given.exists()"
XPath:          "f:given or f:family"
Severity:       #error
