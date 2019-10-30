Alias:          COUNTRY = urn:iso:std:iso:3166
Alias:          EXP = http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation

Instance:       USCoreServerCapabilityStatement
InstanceOf:     CapabilityStatement
Id:             us-core-server
Title:          "US Core Server CapabilityStatement"
Description:    """
    This Section describes the expected capabilities of the US Core Server 
    actor which is responsible for providing responses to the queries 
    submitted by the US Core Requestors. The complete list of FHIR profiles, 
    RESTful operations, and search parameters supported by US Core Servers 
    are defined. Systems implementing this capability statement should meet 
    the ONC 2015 Common Clinical Data Set (CCDS) access requirement for Patient 
    Selection 170.315(g)(7) and Application Access - Data Category Request 
    170.315(g)(8) and and the latest proposed ONC 
    [U.S. Core Data for Interoperability (USCDI)].  
    US Core Clients have the option of choosing from this list to access 
    necessary data based on their local use cases and other contextual requirements."""
* version = "3.1.0"
* status = #active
* experimental = false
* publisher = "HL7 International - US Realm Steering Comittee"
* contact.telecom.system = #url
* contact.telecom.value = "http://www.hl7.org/Special/committees/usrealm/index.cfm"
* jurisdiction.coding = COUNTRY#US "United States of America"
* fhirVersion = "4.0.0"
* kind = #requirements
* format[0] = "xml"
* format[1] = "json"
* patchFormat = "application/json-patch+json"
* implementationGuide = "http://hl7.org/fhir/us/core/ImplementationGuide/hl7.fhir.us.core-3.1.0"
* rest.mode = #server
* rest.documentation = """
    The US Core Server **SHALL**:\n\n1. Support the US Core Patient resource 
    profile.\n1. Support at least one additional resource profile from the 
    list of US Core Profiles.\n1. Implement the RESTful behavior according
    to the FHIR specification.\n1. Return the following response classes:\n   - 
    (Status 400): invalid parameter\n   - (Status 401/4xx): unauthorized request\n   - 
    (Status 403): insufficient scope\n   - (Status 404): unknown resource\n   - 
    (Status 410): deleted resource.\n1. Support json source formats for all US
    Core interactions.\n\nThe US Core Server **SHOULD**:\n\n1. Support xml source 
    formats for all US Core interactions.\n1. Identify the US Core profiles supported 
    as part of the FHIR `meta.profile` attribute for each instance.\n1. 
    Support xml resource formats for all Argonaut questionnaire interactions."""
* rest.security.description = """
    1. See the [General Security Considerations](security.html) section for 
    requirements and recommendations.\n1. A server **SHALL** reject any unauthorized 
    requests by returning an `HTTP 401` unauthorized response code."""
// AllergyIntolerance
* rest.resource[0].type = "AllergyIntolerance"
* rest.resource[0].extension[capabilitystatement-expectation].valueCode = #SHALL
* rest.resource[0].extension[capabilitystatement-search-parameter-combination].extension[capabilitystatement-expectation].valueCode = #SHALL
* rest.resource[0].extension[capabilitystatement-search-parameter-combination].extension[required][0].valueString = "patient"
* rest.resource[0].extension[capabilitystatement-search-parameter-combination].extension[required][1].valueString = "clinical-status"
* rest.resource[0].supportedProfile = "http://hl7.org/fhir/us/core/StructureDefinition/us-core-allergyintolerance"
* rest.resource[0].interaction[0]
* rest.resource[0].interaction[0].extension[capabilitystatement-expectation].valueCode = #MAY
* rest.resource[0].interaction[0].code = #create
* rest.resource[0].interaction[1].extension[capabilitystatement-expectation].valueCode = #SHALL
* rest.resource[0].interaction[1].code = #search-type
* rest.resource[0].interaction[2].extension[capabilitystatement-expectation].valueCode = #SHALL
* rest.resource[0].interaction[2].code = #read
* rest.resource[0].interaction[3].extension[capabilitystatement-expectation].valueCode = #SHOULD
* rest.resource[0].interaction[3].code = #vread
* rest.resource[0].interaction[4].extension[capabilitystatement-expectation].valueCode = #MAY
* rest.resource[0].interaction[4].code = #update
* rest.resource[0].interaction[5].extension[capabilitystatement-expectation].valueCode = #MAY
* rest.resource[0].interaction[5].code = #patch
* rest.resource[0].interaction[6].extension[capabilitystatement-expectation].valueCode = #MAY
* rest.resource[0].interaction[6].code = #delete
* rest.resource[0].interaction[7].extension[capabilitystatement-expectation].valueCode = #SHOULD
* rest.resource[0].interaction[7].code = #history-instance
* rest.resource[0].interaction[7].extension[capabilitystatement-expectation].valueCode = #MAY
* rest.resource[0].interaction[7].code = #history-type
* rest.resource[0].referencePolicy = "resolves"
* rest.resource[0].searchRevInclude = "Provenance:target"
* rest.resource[0].searchParam[0].extension[capabilitystatement-expectation].valueCode = #MAY
* rest.resource[0].searchParam[0].name = "clinical-status"
* rest.resource[0].searchParam[0].definition = "http://hl7.org/fhir/us/core/SearchParameter/us-core-allergyintolerance-clinical-status"
* rest.resource[0].searchParam[0].type = #token
* rest.resource[0].searchParam[1].extension[capabilitystatement-expectation].valueCode = #SHALL
* rest.resource[0].searchParam[1].name = "patient"
* rest.resource[0].searchParam[1].definition = "http://hl7.org/fhir/us/core/SearchParameter/us-core-allergyintolerance-patient"
* rest.resource[0].searchParam[1].type = #reference
// CarePlan
* rest.resource[1].type = "CarePlan"
* rest.resource[1].extension[capabilitystatement-expectation].valueCode = SHALL
* rest.resource[1].extension[capabilitystatement-search-parameter-combination][0].extension[capabilitystatement-expectation].valueCode = #SHOULD
* rest.resource[1].extension[capabilitystatement-search-parameter-combination][0].extension[required][0].valueString = "patient"
* rest.resource[1].extension[capabilitystatement-search-parameter-combination][0].extension[required][1].valueString = "category"
* rest.resource[1].extension[capabilitystatement-search-parameter-combination][0].extension[required][2].valueString = "date"
* rest.resource[1].extension[capabilitystatement-search-parameter-combination][1].extension[capabilitystatement-expectation].valueCode = #SHOULD
* rest.resource[1].extension[capabilitystatement-search-parameter-combination][1].extension[required][0].valueString = "patient"
* rest.resource[1].extension[capabilitystatement-search-parameter-combination][1].extension[required][1].valueString = "category"
* rest.resource[1].extension[capabilitystatement-search-parameter-combination][1].extension[required][2].valueString = "status"
* rest.resource[1].extension[capabilitystatement-search-parameter-combination][1].extension[required][3].valueString = "date"
* rest.resource[1].extension[capabilitystatement-search-parameter-combination][2].extension[capabilitystatement-expectation].valueCode = #SHOULD
* rest.resource[1].extension[capabilitystatement-search-parameter-combination][2].extension[required][0].valueString = "patient"
* rest.resource[1].extension[capabilitystatement-search-parameter-combination][2].extension[required][1].valueString = "category"
* rest.resource[1].extension[capabilitystatement-search-parameter-combination][2].extension[required][2].valueString = "status"
* rest.resource[1].extension[capabilitystatement-search-parameter-combination][3].extension[capabilitystatement-expectation].valueCode = #SHALL
* rest.resource[1].extension[capabilitystatement-search-parameter-combination][3].extension[required][0].valueString = "patient"
* rest.resource[1].extension[capabilitystatement-search-parameter-combination][3].extension[required][1].valueString = "category"
* rest.resource[1].supportedProfile = "http://hl7.org/fhir/us/core/StructureDefinition/us-core-careplan"
* rest.resource[1].interaction[0].extension[capabilitystatement-expectation].valueCode = #MAY
* rest.resource[1].interaction[0].code = #create
* rest.resource[1].interaction[1].extension[capabilitystatement-expectation].valueCode = #SHALL
* rest.resource[1].interaction[1].code = #search-type
* rest.resource[1].interaction[2].extension[capabilitystatement-expectation].valueCode = #SHALL
* rest.resource[1].interaction[2].code = #read
* rest.resource[1].interaction[3].extension[capabilitystatement-expectation].valueCode = #SHOULD
* rest.resource[1].interaction[3].code = #vread
* rest.resource[1].interaction[4].extension[capabilitystatement-expectation].valueCode = #MAY
* rest.resource[1].interaction[4].code = #update
* rest.resource[1].interaction[5].extension[capabilitystatement-expectation].valueCode = #MAY
* rest.resource[1].interaction[5].code = #patch
* rest.resource[1].interaction[6].extension[capabilitystatement-expectation].valueCode = #MAY
* rest.resource[1].interaction[6].code = #delete
* rest.resource[1].interaction[7].extension[capabilitystatement-expectation].valueCode = #SHOULD
* rest.resource[1].interaction[7].code = #history-instance
* rest.resource[1].interaction[7].extension[capabilitystatement-expectation].valueCode = #MAY
* rest.resource[1].interaction[7].code = #history-type
* rest.resource[1].referencePolicy = #resolves
* rest.resource[1].searchRevInclude = "Provenance:target"
* rest.resource[1].searchParam[0].extension[capabilitystatement-expectation].valueCode = #MAY
* rest.resource[1].searchParam[0].name = "category"
* rest.resource[1].searchParam[0].definition = "http://hl7.org/fhir/us/core/SearchParameter/us-core-careplan-category"
* rest.resource[1].searchParam[0].type = #token
* rest.resource[1].searchParam[1].extension[capabilitystatement-expectation].valueCode = #MAY
* rest.resource[1].searchParam[1].name = "date"
* rest.resource[1].searchParam[1].definition = "http://hl7.org/fhir/us/core/SearchParameter/us-core-careplan-date"
* rest.resource[1].searchParam[1].type = #date
* rest.resource[1].searchParam[2].extension[capabilitystatement-expectation].valueCode = #MAY
* rest.resource[1].searchParam[2].name = "patient"
* rest.resource[1].searchParam[2].definition = "http://hl7.org/fhir/us/core/SearchParameter/us-core-careplan-patient"
* rest.resource[1].searchParam[2].type = #reference
* rest.resource[1].searchParam[3].extension[capabilitystatement-expectation].valueCode = #MAY
* rest.resource[1].searchParam[3].name = "status"
* rest.resource[1].searchParam[3].definition = "http://hl7.org/fhir/us/core/SearchParameter/us-core-careplan-status"
* rest.resource[1].searchParam[3].type = #token
// ... Many more resources here