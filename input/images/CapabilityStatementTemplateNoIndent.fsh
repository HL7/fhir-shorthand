Profile: CapabilityStatementParent
Parent: CapabilityStatement
Id: fsh-capabilitystatement-parent
Title: "CapabilityStatement profile for easy specification"
Description: "CapabilityStatement profile that has all resources sliced for easy specification."

* rest ^slicing.discriminator.type = #value
* rest ^slicing.discriminator.path = "mode"
* rest contains client 1..1 MS and server 1..1 MS
* rest[client].mode = #client
* rest[client].resource ^slicing.discriminator.type = #value
* rest[client].resource ^slicing.discriminator.path = "mode"
* rest[client].resource contains 
   account 0..1 and
   activitydefinition 0..1 and
   adverseevent 0..1 and
   allergyintolerance 0..1 and
   appointment 0..1 and
   appointmentresponse 0..1 and
   auditevent 0..1 and
   basic 0..1 and
   binary 0..1 and
   biologicallyderivedproduct 0..1 and
   bodystructure 0..1 and
   bundle 0..1 and
   capabilitystatement 0..1 and
   careplan 0..1 and
   careteam 0..1 and
   catalogentry 0..1 and
   chargeitem 0..1 and
   chargeitemdefinition 0..1 and
   claim 0..1 and
   claimresponse 0..1 and
   clinicalimpression 0..1 and
   codesystem 0..1 and
   communication 0..1 and
   communicationrequest 0..1 and
   compartmentdefinition 0..1 and
   composition 0..1 and
   conceptmap 0..1 and
   condition 0..1 and
   consent 0..1 and
   contract 0..1 and
   coverage 0..1 and
   coverageeligibilityrequest 0..1 and
   coverageeligibilityresponse 0..1 and
   detectedissue 0..1 and
   device 0..1 and
   devicedefinition 0..1 and
   devicemetric 0..1 and
   devicerequest 0..1 and
   deviceusestatement 0..1 and
   diagnosticreport 0..1 and
   documentmanifest 0..1 and
   documentreference 0..1 and
   domainresource 0..1 and
   effectevidencesynthesis 0..1 and
   encounter 0..1 and
   endpoint 0..1 and
   enrollmentrequest 0..1 and
   enrollmentresponse 0..1 and
   episodeofcare 0..1 and
   eventdefinition 0..1 and
   evidence 0..1 and
   evidencevariable 0..1 and
   examplescenario 0..1 and
   explanationofbenefit 0..1 and
   familymemberhistory 0..1 and
   flag 0..1 and
   goal 0..1 and
   graphdefinition 0..1 and
   group 0..1 and
   guidanceresponse 0..1 and
   healthcareservice 0..1 and
   imagingstudy 0..1 and
   immunization 0..1 and
   immunizationevaluation 0..1 and
   immunizationrecommendation 0..1 and
   implementationguide 0..1 and
   insuranceplan 0..1 and
   invoice 0..1 and
   library 0..1 and
   linkage 0..1 and
   list 0..1 and
   location 0..1 and
   measure 0..1 and
   measurereport 0..1 and
   media 0..1 and
   medication 0..1 and
   medicationadministration 0..1 and
   medicationdispense 0..1 and
   medicationknowledge 0..1 and
   medicationrequest 0..1 and
   medicationstatement 0..1 and
   medicinalproduct 0..1 and
   medicinalproductauthorization 0..1 and
   medicinalproductcontraindication 0..1 and
   medicinalproductindication 0..1 and
   medicinalproductingredient 0..1 and
   medicinalproductinteraction 0..1 and
   medicinalproductmanufactured 0..1 and
   medicinalproductpackaged 0..1 and
   medicinalproductpharmaceutical 0..1 and
   medicinalproductundesirableeffect 0..1 and
   messagedefinition 0..1 and
   messageheader 0..1 and
   molecularsequence 0..1 and
   namingsystem 0..1 and
   nutritionorder 0..1 and
   observation 0..1 and
   observationdefinition 0..1 and
   operationdefinition 0..1 and
   operationoutcome 0..1 and
   organization 0..1 and
   organizationaffiliation 0..1 and
   parameters 0..1 and
   patient 0..1 and
   paymentnotice 0..1 and
   paymentreconciliation 0..1 and
   person 0..1 and
   plandefinition 0..1 and
   practitioner 0..1 and
   practitionerrole 0..1 and
   procedure 0..1 and
   provenance 0..1 and
   questionnaire 0..1 and
   questionnaireresponse 0..1 and
   relatedperson 0..1 and
   requestgroup 0..1 and
   researchdefinition 0..1 and
   researchelementdefinition 0..1 and
   researchstudy 0..1 and
   researchsubject 0..1 and
   resource 0..1 and
   riskassessment 0..1 and
   riskevidencesynthesis 0..1 and
   schedule 0..1 and
   searchparameter 0..1 and
   servicerequest 0..1 and
   slot 0..1 and
   specimen 0..1 and
   specimendefinition 0..1 and
   structuredefinition 0..1 and
   structuremap 0..1 and
   subscription 0..1 and
   substance 0..1 and
   substancenucleicacid 0..1 and
   substancepolymer 0..1 and
   substanceprotein 0..1 and
   substancereferenceinformation 0..1 and
   substancesourcematerial 0..1 and
   substancespecification 0..1 and
   supplydelivery 0..1 and
   supplyrequest 0..1 and
   task 0..1 and
   terminologycapabilities 0..1 and
   testreport 0..1 and
   testscript 0..1 and
   value-set 0..1 and
   verificationresult 0..1 and
   visionprescription 0..1
* rest[client].resource[account].type = #Account
* rest[client].resource[activitydefinition].type = #ActivityDefinition
* rest[client].resource[adverseevent].type = #AdverseEvent
* rest[client].resource[allergyintolerance].type = #AllergyIntolerance
* rest[client].resource[appointment].type = #Appointment
* rest[client].resource[appointmentresponse].type = #AppointmentResponse
* rest[client].resource[auditevent].type = #AuditEvent
* rest[client].resource[basic].type = #Basic
* rest[client].resource[binary].type = #Binary
* rest[client].resource[biologicallyderivedproduct].type = #BiologicallyDerivedProduct
* rest[client].resource[bodystructure].type = #BodyStructure
* rest[client].resource[bundle].type = #Bundle
* rest[client].resource[capabilitystatement].type = #CapabilityStatement
* rest[client].resource[careplan].type = #CarePlan
* rest[client].resource[careteam].type = #CareTeam
* rest[client].resource[catalogentry].type = #CatalogEntry
* rest[client].resource[chargeitem].type = #ChargeItem
* rest[client].resource[chargeitemdefinition].type = #ChargeItemDefinition
* rest[client].resource[claim].type = #Claim
* rest[client].resource[claimresponse].type = #ClaimResponse
* rest[client].resource[clinicalimpression].type = #ClinicalImpression
* rest[client].resource[codesystem].type = #CodeSystem
* rest[client].resource[communication].type = #Communication
* rest[client].resource[communicationrequest].type = #CommunicationRequest
* rest[client].resource[compartmentdefinition].type = #CompartmentDefinition
* rest[client].resource[composition].type = #Composition
* rest[client].resource[conceptmap].type = #ConceptMap
* rest[client].resource[condition].type = #Condition
* rest[client].resource[consent].type = #Consent
* rest[client].resource[contract].type = #Contract
* rest[client].resource[coverage].type = #Coverage
* rest[client].resource[coverageeligibilityrequest].type = #CoverageEligibilityRequest
* rest[client].resource[coverageeligibilityresponse].type = #CoverageEligibilityResponse
* rest[client].resource[detectedissue].type = #DetectedIssue
* rest[client].resource[device].type = #Device
* rest[client].resource[devicedefinition].type = #DeviceDefinition
* rest[client].resource[devicemetric].type = #DeviceMetric
* rest[client].resource[devicerequest].type = #DeviceRequest
* rest[client].resource[deviceusestatement].type = #DeviceUseStatement
* rest[client].resource[diagnosticreport].type = #DiagnosticReport
* rest[client].resource[documentmanifest].type = #DocumentManifest
* rest[client].resource[documentreference].type = #DocumentReference
* rest[client].resource[domainresource].type = #DomainResource
* rest[client].resource[effectevidencesynthesis].type = #EffectEvidenceSynthesis
* rest[client].resource[encounter].type = #Encounter
* rest[client].resource[endpoint].type = #Endpoint
* rest[client].resource[enrollmentrequest].type = #EnrollmentRequest
* rest[client].resource[enrollmentresponse].type = #EnrollmentResponse
* rest[client].resource[episodeofcare].type = #EpisodeOfCare
* rest[client].resource[eventdefinition].type = #EventDefinition
* rest[client].resource[evidence].type = #Evidence
* rest[client].resource[evidencevariable].type = #EvidenceVariable
* rest[client].resource[examplescenario].type = #ExampleScenario
* rest[client].resource[explanationofbenefit].type = #ExplanationOfBenefit
* rest[client].resource[familymemberhistory].type = #FamilyMemberHistory
* rest[client].resource[flag].type = #Flag
* rest[client].resource[goal].type = #Goal
* rest[client].resource[graphdefinition].type = #GraphDefinition
* rest[client].resource[group].type = #Group
* rest[client].resource[guidanceresponse].type = #GuidanceResponse
* rest[client].resource[healthcareservice].type = #HealthcareService
* rest[client].resource[imagingstudy].type = #ImagingStudy
* rest[client].resource[immunization].type = #Immunization
* rest[client].resource[immunizationevaluation].type = #ImmunizationEvaluation
* rest[client].resource[immunizationrecommendation].type = #ImmunizationRecommendation
* rest[client].resource[implementationguide].type = #ImplementationGuide
* rest[client].resource[insuranceplan].type = #InsurancePlan
* rest[client].resource[invoice].type = #Invoice
* rest[client].resource[library].type = #Library
* rest[client].resource[linkage].type = #Linkage
* rest[client].resource[list].type = #List
* rest[client].resource[location].type = #Location
* rest[client].resource[measure].type = #Measure
* rest[client].resource[measurereport].type = #MeasureReport
* rest[client].resource[media].type = #Media
* rest[client].resource[medication].type = #Medication
* rest[client].resource[medicationadministration].type = #MedicationAdministration
* rest[client].resource[medicationdispense].type = #MedicationDispense
* rest[client].resource[medicationknowledge].type = #MedicationKnowledge
* rest[client].resource[medicationrequest].type = #MedicationRequest
* rest[client].resource[medicationstatement].type = #MedicationStatement
* rest[client].resource[medicinalproduct].type = #MedicinalProduct
* rest[client].resource[medicinalproductauthorization].type = #MedicinalProductAuthorization
* rest[client].resource[medicinalproductcontraindication].type = #MedicinalProductContraindication
* rest[client].resource[medicinalproductindication].type = #MedicinalProductIndication
* rest[client].resource[medicinalproductingredient].type = #MedicinalProductIngredient
* rest[client].resource[medicinalproductinteraction].type = #MedicinalProductInteraction
* rest[client].resource[medicinalproductmanufactured].type = #MedicinalProductManufactured
* rest[client].resource[medicinalproductpackaged].type = #MedicinalProductPackaged
* rest[client].resource[medicinalproductpharmaceutical].type = #MedicinalProductPharmaceutical
* rest[client].resource[medicinalproductundesirableeffect].type = #MedicinalProductUndesirableEffect
* rest[client].resource[messagedefinition].type = #MessageDefinition
* rest[client].resource[messageheader].type = #MessageHeader
* rest[client].resource[molecularsequence].type = #MolecularSequence
* rest[client].resource[namingsystem].type = #NamingSystem
* rest[client].resource[nutritionorder].type = #NutritionOrder
* rest[client].resource[observation].type = #Observation
* rest[client].resource[observationdefinition].type = #ObservationDefinition
* rest[client].resource[operationdefinition].type = #OperationDefinition
* rest[client].resource[operationoutcome].type = #OperationOutcome
* rest[client].resource[organization].type = #Organization
* rest[client].resource[organizationaffiliation].type = #OrganizationAffiliation
* rest[client].resource[parameters].type = #Parameters
* rest[client].resource[patient].type = #Patient
* rest[client].resource[paymentnotice].type = #PaymentNotice
* rest[client].resource[paymentreconciliation].type = #PaymentReconciliation
* rest[client].resource[person].type = #Person
* rest[client].resource[plandefinition].type = #PlanDefinition
* rest[client].resource[practitioner].type = #Practitioner
* rest[client].resource[practitionerrole].type = #PractitionerRole
* rest[client].resource[procedure].type = #Procedure
* rest[client].resource[provenance].type = #Provenance
* rest[client].resource[questionnaire].type = #Questionnaire
* rest[client].resource[questionnaireresponse].type = #QuestionnaireResponse
* rest[client].resource[relatedperson].type = #RelatedPerson
* rest[client].resource[requestgroup].type = #RequestGroup
* rest[client].resource[researchdefinition].type = #ResearchDefinition
* rest[client].resource[researchelementdefinition].type = #ResearchElementDefinition
* rest[client].resource[researchstudy].type = #ResearchStudy
* rest[client].resource[researchsubject].type = #ResearchSubject
* rest[client].resource[resource].type = #Resource
* rest[client].resource[riskassessment].type = #RiskAssessment
* rest[client].resource[riskevidencesynthesis].type = #RiskEvidenceSynthesis
* rest[client].resource[schedule].type = #Schedule
* rest[client].resource[searchparameter].type = #SearchParameter
* rest[client].resource[servicerequest].type = #ServiceRequest
* rest[client].resource[slot].type = #Slot
* rest[client].resource[specimen].type = #Specimen
* rest[client].resource[specimendefinition].type = #SpecimenDefinition
* rest[client].resource[structuredefinition].type = #StructureDefinition
* rest[client].resource[structuremap].type = #StructureMap
* rest[client].resource[subscription].type = #Subscription
* rest[client].resource[substance].type = #Substance
* rest[client].resource[substancenucleicacid].type = #SubstanceNucleicAcid
* rest[client].resource[substancepolymer].type = #SubstancePolymer
* rest[client].resource[substanceprotein].type = #SubstanceProtein
* rest[client].resource[substancereferenceinformation].type = #SubstanceReferenceInformation
* rest[client].resource[substancesourcematerial].type = #SubstanceSourceMaterial
* rest[client].resource[substancespecification].type = #SubstanceSpecification
* rest[client].resource[supplydelivery].type = #SupplyDelivery
* rest[client].resource[supplyrequest].type = #SupplyRequest
* rest[client].resource[task].type = #Task
* rest[client].resource[terminologycapabilities].type = #TerminologyCapabilities
* rest[client].resource[testreport].type = #TestReport
* rest[client].resource[testscript].type = #TestScript
* rest[client].resource[value-set].type = #ValueSet
* rest[client].resource[verificationresult].type = #VerificationResult
* rest[client].resource[visionprescription].type = #VisionPrescription
* rest[server].resource contains 
   account 0..1 and
   activitydefinition 0..1 and
   adverseevent 0..1 and
   allergyintolerance 0..1 and
   appointment 0..1 and
   appointmentresponse 0..1 and
   auditevent 0..1 and
   basic 0..1 and
   binary 0..1 and
   biologicallyderivedproduct 0..1 and
   bodystructure 0..1 and
   bundle 0..1 and
   capabilitystatement 0..1 and
   careplan 0..1 and
   careteam 0..1 and
   catalogentry 0..1 and
   chargeitem 0..1 and
   chargeitemdefinition 0..1 and
   claim 0..1 and
   claimresponse 0..1 and
   clinicalimpression 0..1 and
   codesystem 0..1 and
   communication 0..1 and
   communicationrequest 0..1 and
   compartmentdefinition 0..1 and
   composition 0..1 and
   conceptmap 0..1 and
   condition 0..1 and
   consent 0..1 and
   contract 0..1 and
   coverage 0..1 and
   coverageeligibilityrequest 0..1 and
   coverageeligibilityresponse 0..1 and
   detectedissue 0..1 and
   device 0..1 and
   devicedefinition 0..1 and
   devicemetric 0..1 and
   devicerequest 0..1 and
   deviceusestatement 0..1 and
   diagnosticreport 0..1 and
   documentmanifest 0..1 and
   documentreference 0..1 and
   domainresource 0..1 and
   effectevidencesynthesis 0..1 and
   encounter 0..1 and
   endpoint 0..1 and
   enrollmentrequest 0..1 and
   enrollmentresponse 0..1 and
   episodeofcare 0..1 and
   eventdefinition 0..1 and
   evidence 0..1 and
   evidencevariable 0..1 and
   examplescenario 0..1 and
   explanationofbenefit 0..1 and
   familymemberhistory 0..1 and
   flag 0..1 and
   goal 0..1 and
   graphdefinition 0..1 and
   group 0..1 and
   guidanceresponse 0..1 and
   healthcareservice 0..1 and
   imagingstudy 0..1 and
   immunization 0..1 and
   immunizationevaluation 0..1 and
   immunizationrecommendation 0..1 and
   implementationguide 0..1 and
   insuranceplan 0..1 and
   invoice 0..1 and
   library 0..1 and
   linkage 0..1 and
   list 0..1 and
   location 0..1 and
   measure 0..1 and
   measurereport 0..1 and
   media 0..1 and
   medication 0..1 and
   medicationadministration 0..1 and
   medicationdispense 0..1 and
   medicationknowledge 0..1 and
   medicationrequest 0..1 and
   medicationstatement 0..1 and
   medicinalproduct 0..1 and
   medicinalproductauthorization 0..1 and
   medicinalproductcontraindication 0..1 and
   medicinalproductindication 0..1 and
   medicinalproductingredient 0..1 and
   medicinalproductinteraction 0..1 and
   medicinalproductmanufactured 0..1 and
   medicinalproductpackaged 0..1 and
   medicinalproductpharmaceutical 0..1 and
   medicinalproductundesirableeffect 0..1 and
   messagedefinition 0..1 and
   messageheader 0..1 and
   molecularsequence 0..1 and
   namingsystem 0..1 and
   nutritionorder 0..1 and
   observation 0..1 and
   observationdefinition 0..1 and
   operationdefinition 0..1 and
   operationoutcome 0..1 and
   organization 0..1 and
   organizationaffiliation 0..1 and
   parameters 0..1 and
   patient 0..1 and
   paymentnotice 0..1 and
   paymentreconciliation 0..1 and
   person 0..1 and
   plandefinition 0..1 and
   practitioner 0..1 and
   practitionerrole 0..1 and
   procedure 0..1 and
   provenance 0..1 and
   questionnaire 0..1 and
   questionnaireresponse 0..1 and
   relatedperson 0..1 and
   requestgroup 0..1 and
   researchdefinition 0..1 and
   researchelementdefinition 0..1 and
   researchstudy 0..1 and
   researchsubject 0..1 and
   resource 0..1 and
   riskassessment 0..1 and
   riskevidencesynthesis 0..1 and
   schedule 0..1 and
   searchparameter 0..1 and
   servicerequest 0..1 and
   slot 0..1 and
   specimen 0..1 and
   specimendefinition 0..1 and
   structuredefinition 0..1 and
   structuremap 0..1 and
   subscription 0..1 and
   substance 0..1 and
   substancenucleicacid 0..1 and
   substancepolymer 0..1 and
   substanceprotein 0..1 and
   substancereferenceinformation 0..1 and
   substancesourcematerial 0..1 and
   substancespecification 0..1 and
   supplydelivery 0..1 and
   supplyrequest 0..1 and
   task 0..1 and
   terminologycapabilities 0..1 and
   testreport 0..1 and
   testscript 0..1 and
   value-set 0..1 and
   verificationresult 0..1 and
   visionprescription 0..1
* rest[server].resource[account].type = #Account
* rest[server].resource[activitydefinition].type = #ActivityDefinition
* rest[server].resource[adverseevent].type = #AdverseEvent
* rest[server].resource[allergyintolerance].type = #AllergyIntolerance
* rest[server].resource[appointment].type = #Appointment
* rest[server].resource[appointmentresponse].type = #AppointmentResponse
* rest[server].resource[auditevent].type = #AuditEvent
* rest[server].resource[basic].type = #Basic
* rest[server].resource[binary].type = #Binary
* rest[server].resource[biologicallyderivedproduct].type = #BiologicallyDerivedProduct
* rest[server].resource[bodystructure].type = #BodyStructure
* rest[server].resource[bundle].type = #Bundle
* rest[server].resource[capabilitystatement].type = #CapabilityStatement
* rest[server].resource[careplan].type = #CarePlan
* rest[server].resource[careteam].type = #CareTeam
* rest[server].resource[catalogentry].type = #CatalogEntry
* rest[server].resource[chargeitem].type = #ChargeItem
* rest[server].resource[chargeitemdefinition].type = #ChargeItemDefinition
* rest[server].resource[claim].type = #Claim
* rest[server].resource[claimresponse].type = #ClaimResponse
* rest[server].resource[clinicalimpression].type = #ClinicalImpression
* rest[server].resource[codesystem].type = #CodeSystem
* rest[server].resource[communication].type = #Communication
* rest[server].resource[communicationrequest].type = #CommunicationRequest
* rest[server].resource[compartmentdefinition].type = #CompartmentDefinition
* rest[server].resource[composition].type = #Composition
* rest[server].resource[conceptmap].type = #ConceptMap
* rest[server].resource[condition].type = #Condition
* rest[server].resource[consent].type = #Consent
* rest[server].resource[contract].type = #Contract
* rest[server].resource[coverage].type = #Coverage
* rest[server].resource[coverageeligibilityrequest].type = #CoverageEligibilityRequest
* rest[server].resource[coverageeligibilityresponse].type = #CoverageEligibilityResponse
* rest[server].resource[detectedissue].type = #DetectedIssue
* rest[server].resource[device].type = #Device
* rest[server].resource[devicedefinition].type = #DeviceDefinition
* rest[server].resource[devicemetric].type = #DeviceMetric
* rest[server].resource[devicerequest].type = #DeviceRequest
* rest[server].resource[deviceusestatement].type = #DeviceUseStatement
* rest[server].resource[diagnosticreport].type = #DiagnosticReport
* rest[server].resource[documentmanifest].type = #DocumentManifest
* rest[server].resource[documentreference].type = #DocumentReference
* rest[server].resource[domainresource].type = #DomainResource
* rest[server].resource[effectevidencesynthesis].type = #EffectEvidenceSynthesis
* rest[server].resource[encounter].type = #Encounter
* rest[server].resource[endpoint].type = #Endpoint
* rest[server].resource[enrollmentrequest].type = #EnrollmentRequest
* rest[server].resource[enrollmentresponse].type = #EnrollmentResponse
* rest[server].resource[episodeofcare].type = #EpisodeOfCare
* rest[server].resource[eventdefinition].type = #EventDefinition
* rest[server].resource[evidence].type = #Evidence
* rest[server].resource[evidencevariable].type = #EvidenceVariable
* rest[server].resource[examplescenario].type = #ExampleScenario
* rest[server].resource[explanationofbenefit].type = #ExplanationOfBenefit
* rest[server].resource[familymemberhistory].type = #FamilyMemberHistory
* rest[server].resource[flag].type = #Flag
* rest[server].resource[goal].type = #Goal
* rest[server].resource[graphdefinition].type = #GraphDefinition
* rest[server].resource[group].type = #Group
* rest[server].resource[guidanceresponse].type = #GuidanceResponse
* rest[server].resource[healthcareservice].type = #HealthcareService
* rest[server].resource[imagingstudy].type = #ImagingStudy
* rest[server].resource[immunization].type = #Immunization
* rest[server].resource[immunizationevaluation].type = #ImmunizationEvaluation
* rest[server].resource[immunizationrecommendation].type = #ImmunizationRecommendation
* rest[server].resource[implementationguide].type = #ImplementationGuide
* rest[server].resource[insuranceplan].type = #InsurancePlan
* rest[server].resource[invoice].type = #Invoice
* rest[server].resource[library].type = #Library
* rest[server].resource[linkage].type = #Linkage
* rest[server].resource[list].type = #List
* rest[server].resource[location].type = #Location
* rest[server].resource[measure].type = #Measure
* rest[server].resource[measurereport].type = #MeasureReport
* rest[server].resource[media].type = #Media
* rest[server].resource[medication].type = #Medication
* rest[server].resource[medicationadministration].type = #MedicationAdministration
* rest[server].resource[medicationdispense].type = #MedicationDispense
* rest[server].resource[medicationknowledge].type = #MedicationKnowledge
* rest[server].resource[medicationrequest].type = #MedicationRequest
* rest[server].resource[medicationstatement].type = #MedicationStatement
* rest[server].resource[medicinalproduct].type = #MedicinalProduct
* rest[server].resource[medicinalproductauthorization].type = #MedicinalProductAuthorization
* rest[server].resource[medicinalproductcontraindication].type = #MedicinalProductContraindication
* rest[server].resource[medicinalproductindication].type = #MedicinalProductIndication
* rest[server].resource[medicinalproductingredient].type = #MedicinalProductIngredient
* rest[server].resource[medicinalproductinteraction].type = #MedicinalProductInteraction
* rest[server].resource[medicinalproductmanufactured].type = #MedicinalProductManufactured
* rest[server].resource[medicinalproductpackaged].type = #MedicinalProductPackaged
* rest[server].resource[medicinalproductpharmaceutical].type = #MedicinalProductPharmaceutical
* rest[server].resource[medicinalproductundesirableeffect].type = #MedicinalProductUndesirableEffect
* rest[server].resource[messagedefinition].type = #MessageDefinition
* rest[server].resource[messageheader].type = #MessageHeader
* rest[server].resource[molecularsequence].type = #MolecularSequence
* rest[server].resource[namingsystem].type = #NamingSystem
* rest[server].resource[nutritionorder].type = #NutritionOrder
* rest[server].resource[observation].type = #Observation
* rest[server].resource[observationdefinition].type = #ObservationDefinition
* rest[server].resource[operationdefinition].type = #OperationDefinition
* rest[server].resource[operationoutcome].type = #OperationOutcome
* rest[server].resource[organization].type = #Organization
* rest[server].resource[organizationaffiliation].type = #OrganizationAffiliation
* rest[server].resource[parameters].type = #Parameters
* rest[server].resource[patient].type = #Patient
* rest[server].resource[paymentnotice].type = #PaymentNotice
* rest[server].resource[paymentreconciliation].type = #PaymentReconciliation
* rest[server].resource[person].type = #Person
* rest[server].resource[plandefinition].type = #PlanDefinition
* rest[server].resource[practitioner].type = #Practitioner
* rest[server].resource[practitionerrole].type = #PractitionerRole
* rest[server].resource[procedure].type = #Procedure
* rest[server].resource[provenance].type = #Provenance
* rest[server].resource[questionnaire].type = #Questionnaire
* rest[server].resource[questionnaireresponse].type = #QuestionnaireResponse
* rest[server].resource[relatedperson].type = #RelatedPerson
* rest[server].resource[requestgroup].type = #RequestGroup
* rest[server].resource[researchdefinition].type = #ResearchDefinition
* rest[server].resource[researchelementdefinition].type = #ResearchElementDefinition
* rest[server].resource[researchstudy].type = #ResearchStudy
* rest[server].resource[researchsubject].type = #ResearchSubject
* rest[server].resource[resource].type = #Resource
* rest[server].resource[riskassessment].type = #RiskAssessment
* rest[server].resource[riskevidencesynthesis].type = #RiskEvidenceSynthesis
* rest[server].resource[schedule].type = #Schedule
* rest[server].resource[searchparameter].type = #SearchParameter
* rest[server].resource[servicerequest].type = #ServiceRequest
* rest[server].resource[slot].type = #Slot
* rest[server].resource[specimen].type = #Specimen
* rest[server].resource[specimendefinition].type = #SpecimenDefinition
* rest[server].resource[structuredefinition].type = #StructureDefinition
* rest[server].resource[structuremap].type = #StructureMap
* rest[server].resource[subscription].type = #Subscription
* rest[server].resource[substance].type = #Substance
* rest[server].resource[substancenucleicacid].type = #SubstanceNucleicAcid
* rest[server].resource[substancepolymer].type = #SubstancePolymer
* rest[server].resource[substanceprotein].type = #SubstanceProtein
* rest[server].resource[substancereferenceinformation].type = #SubstanceReferenceInformation
* rest[server].resource[substancesourcematerial].type = #SubstanceSourceMaterial
* rest[server].resource[substancespecification].type = #SubstanceSpecification
* rest[server].resource[supplydelivery].type = #SupplyDelivery
* rest[server].resource[supplyrequest].type = #SupplyRequest
* rest[server].resource[task].type = #Task
* rest[server].resource[terminologycapabilities].type = #TerminologyCapabilities
* rest[server].resource[testreport].type = #TestReport
* rest[server].resource[testscript].type = #TestScript
* rest[server].resource[value-set].type = #ValueSet
* rest[server].resource[verificationresult].type = #VerificationResult
* rest[server].resource[visionprescription].type = #VisionPrescription


Instance: MeasureConsumerPull
InstanceOf: CapabilityStatementParent
Title: "Measure Consumer - Pull Option (Client)"
Usage: #definition
* name = "MeasureConsumerPull"
* description = "These are the requirements of a Measure Consumer actor implementing the pull option"
* rest.mode = #client
* rest.documentation = """
    The Measure Consumer provides access to aggregated or fine-grained data gathered from one or more Measure Sources.
    The Measure Consumer provides the ability to report on data from one or more Measure Sources.
    A Measure Consumer implementing the Pull Option periodically queries a Measure Source using the Query Measure transaction to enable collection of the current status.
"""
* status = #draft
* experimental = true
* date = "2020-05-07"
* publisher = "Audacious Inquiry, Inc."
* contact.name = "Keith W. Boone"
* contact.telecom.system = #email
* contact.telecom.value = "kboone@ainq.com"
* kind = #requirements
* fhirVersion = #4.0.1
* format[0] = #json
* format[1] = #xml
* implementationGuide = "http://hl7.org/fhir/us/saner/ImplementationGuide/hl7.fhir.us.saner"
 // MeasureReport requirements
* rest.resource[measurerport].supportedProfile = "http://hl7.org/fhir/us/saner/StructureDefinition/PublicHealthMeasureReport"
  // SHALL support read on MeasureReport
* rest.resource[0].interaction[0].code = #read
* rest.resource[0].interaction[0].extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest.resource[0].interaction[0].extension[0].valueCode = #SHALL
  // SHALL support search on MeasureReport
* rest.resource[0].interaction[1].code = #search-type
* rest.resource[0].interaction[1].extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest.resource[0].interaction[1].extension[0].valueCode = #SHALL
* rest.resource[0].searchInclude = "*"
  // SHALL support search by _id
* rest.resource[0].searchParam[0].name = "_id"
* rest.resource[0].searchParam[0].definition = "http://hl7.org/fhir/SearchParameter/Resource-id"
* rest.resource[0].searchParam[0].type = #token
* rest.resource[0].searchParam[0].extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest.resource[0].searchParam[0].extension[0].valueCode = #SHALL
  // SHALL support search by _lastUpdated
* rest.resource[0].searchParam[1].name = "_lastUpdated"
* rest.resource[0].searchParam[1].definition = "http://hl7.org/fhir/SearchParameter/Resource-lastUpdated"
* rest.resource[0].searchParam[1].type = #date
* rest.resource[0].searchParam[1].extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest.resource[0].searchParam[1].extension[0].valueCode = #SHALL
  // SHALL support search by date
* rest.resource[0].searchParam[2].name = "date"
* rest.resource[0].searchParam[2].definition = "http://hl7.org/fhir/SearchParameter/MeasureReport-date"
* rest.resource[0].searchParam[2].type = #date
* rest.resource[0].searchParam[2].extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest.resource[0].searchParam[2].extension[0].valueCode = #SHALL
  // SHALL support search by measure
* rest.resource[0].searchParam[3].name = "measure"
* rest.resource[0].searchParam[3].definition = "http://hl7.org/fhir/SearchParameter/MeasureReport-measure"
* rest.resource[0].searchParam[3].type = #reference
* rest.resource[0].searchParam[3].extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest.resource[0].searchParam[3].extension[0].valueCode = #SHALL
  // SHALL support search by subject
  // TODO: a SearchParameter should be defined that constrains this to only Location references
  // TODO: a SearchParameter should be defined that only allows the :Identifier modifier.  Should this also be constrained only to LocatioN?
* rest.resource[0].searchParam[4].name = "subject"
* rest.resource[0].searchParam[4].definition = "http://hl7.org/fhir/SearchParameter/MeasureReport-subject"
* rest.resource[0].searchParam[4].type = #reference
* rest.resource[0].searchParam[4].extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest.resource[0].searchParam[4].extension[0].valueCode = #SHALL
  // SHALL support search by period
* rest.resource[0].searchParam[5].name = "period"
* rest.resource[0].searchParam[5].definition = "http://hl7.org/fhir/SearchParameter/MeasureReport-period"
* rest.resource[0].searchParam[5].type = #date
* rest.resource[0].searchParam[5].extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest.resource[0].searchParam[5].extension[0].valueCode = #SHALL
  // SHALL support search by reporter
  // TODO: a SearchParameter should be defined that allows the identifier modifier
* rest.resource[0].searchParam[6].name = "reporter"
* rest.resource[0].searchParam[6].definition = "http://hl7.org/fhir/SearchParameter/MeasureReport-reporter"
* rest.resource[0].searchParam[6].type = #reference
* rest.resource[0].searchParam[6].extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest.resource[0].searchParam[6].extension[0].valueCode = #SHALL
  //SHALL support _include for any resource
* rest.resource[0].searchInclude[0] = "*"
* rest.resource[0].searchInclude[0].extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest.resource[0].searchInclude[0].extension[0].valueCode = #SHALL
  // SHOULD support search by code
* rest.resource[0].searchParam[1].name = "code"
* rest.resource[0].searchParam[1].definition = "http://hl7.org/fhir/us/saner/SearchParameter/SearchParameter-code"
* rest.resource[0].searchParam[1].type = #token
* rest.resource[0].searchParam[1].extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest.resource[0].searchParam[1].extension[0].valueCode = #SHOULD
  // TODO: a SearchParameter for measure.title chained search as a SHOULD

  // Location requirements
* rest.resource[1].type = #Location
* rest.resource[1].supportedProfile = "http://hl7.org/fhir/us/saner/StructureDefinition/saner-resource-location"
  // SHOULD support Location with the SANERResourceLocation Profile
  //* rest.resource[1].extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
  //* rest.resource[1].extension[0].valueCode = #SHALL
  // SHOULD support read on Location
* rest.resource[1].interaction[0].code = #read
* rest.resource[1].interaction[0].extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest.resource[1].interaction[0].extension[0].valueCode = #SHALL
  // SHOULD support search on Location
* rest.resource[1].interaction[1].code = #search-type
* rest.resource[1].interaction[1].extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest.resource[1].interaction[1].extension[0].valueCode = #SHALL
  // SHALL support search by _id
* rest.resource[1].searchParam[0].name = "_id"
* rest.resource[1].searchParam[0].definition = "http://hl7.org/fhir/SearchParameter/Resource-id"
* rest.resource[1].searchParam[0].type = #token
* rest.resource[1].searchParam[0].extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest.resource[1].searchParam[0].extension[0].valueCode = #SHALL
  // SHALL support search by _lastUpdated
* rest.resource[1].searchParam[1].name = "_lastUpdated"
* rest.resource[1].searchParam[1].definition = "http://hl7.org/fhir/SearchParameter/Resource-lastUpdated"
* rest.resource[1].searchParam[1].type = #date
* rest.resource[1].searchParam[1].extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest.resource[1].searchParam[1].extension[0].valueCode = #SHALL
  // SHALL support search by name
* rest.resource[1].searchParam[2].name = "name"
* rest.resource[1].searchParam[2].definition = "http://hl7.org/fhir/SearchParameter/Location-name"
* rest.resource[1].searchParam[2].type = #string
* rest.resource[1].searchParam[2].extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest.resource[1].searchParam[2].extension[0].valueCode = #SHALL
  // SHALL support search by identifier
* rest.resource[1].searchParam[3].name = "identifier"
* rest.resource[1].searchParam[3].definition = "http://hl7.org/fhir/SearchParameter/Location-identifier"
* rest.resource[1].searchParam[3].type = #token
* rest.resource[1].searchParam[3].extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest.resource[1].searchParam[3].extension[0].valueCode = #SHALL
  // SHALL support search by address
* rest.resource[1].searchParam[4].name = "address"
* rest.resource[1].searchParam[4].definition = "http://hl7.org/fhir/SearchParameter/Location-address"
* rest.resource[1].searchParam[4].type = #string
* rest.resource[1].searchParam[4].extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest.resource[1].searchParam[4].extension[0].valueCode = #SHALL
  // SHALL support search by address-city
* rest.resource[1].searchParam[5].name = "address-city"
* rest.resource[1].searchParam[5].definition = "http://hl7.org/fhir/SearchParameter/Location-address-city"
* rest.resource[1].searchParam[5].type = #string
* rest.resource[1].searchParam[5].extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest.resource[1].searchParam[5].extension[0].valueCode = #SHALL
  // SHALL support search by address-country
* rest.resource[1].searchParam[6].name = "address-country"
* rest.resource[1].searchParam[6].definition = "http://hl7.org/fhir/SearchParameter/Location-address-country"
* rest.resource[1].searchParam[6].type = #string
* rest.resource[1].searchParam[6].extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest.resource[1].searchParam[6].extension[0].valueCode = #SHALL
  // SHALL support search by address-postalcode
* rest.resource[1].searchParam[7].name = "address-postalcode"
* rest.resource[1].searchParam[7].definition = "http://hl7.org/fhir/SearchParameter/Location-address-postalcode"
* rest.resource[1].searchParam[7].type = #string
* rest.resource[1].searchParam[7].extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest.resource[1].searchParam[7].extension[0].valueCode = #SHALL
  // SHALL support search by address-state
* rest.resource[1].searchParam[8].name = "address-state"
* rest.resource[1].searchParam[8].definition = "http://hl7.org/fhir/SearchParameter/Location-address-state"
* rest.resource[1].searchParam[8].type = #string
* rest.resource[1].searchParam[8].extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest.resource[1].searchParam[8].extension[0].valueCode = #SHALL
  // SHALL support search by address-use
* rest.resource[1].searchParam[9].name = "address-use"
* rest.resource[1].searchParam[9].definition = "http://hl7.org/fhir/SearchParameter/Location-address-use"
* rest.resource[1].searchParam[9].type = #token
* rest.resource[1].searchParam[9].extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest.resource[1].searchParam[9].extension[0].valueCode = #SHALL

  // Organization requirements
* rest.resource[2].type = #Organization
  // SHOULD support Organization
  //* rest.resource[2].extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
  //* rest.resource[2].extension[0].valueCode = #SHALL
  // SHOULD support create on Organization
* rest.resource[2].interaction[0].code = #read
* rest.resource[2].interaction[0].extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest.resource[2].interaction[0].extension[0].valueCode = #SHALL
  // SHOULD support update on Organization
* rest.resource[2].interaction[1].code = #search-type
* rest.resource[2].interaction[1].extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest.resource[2].interaction[1].extension[0].valueCode = #SHALL

  // SHALL support search by _id
* rest.resource[2].searchParam[0].name = "_id"
* rest.resource[2].searchParam[0].definition = "http://hl7.org/fhir/SearchParameter/Resource-id"
* rest.resource[2].searchParam[0].type = #token
* rest.resource[2].searchParam[0].extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest.resource[2].searchParam[0].extension[0].valueCode = #SHALL
  // SHALL support search by _lastUpdated
* rest.resource[2].searchParam[1].name = "_lastUpdated"
* rest.resource[2].searchParam[1].definition = "http://hl7.org/fhir/SearchParameter/Resource-lastUpdated"
* rest.resource[2].searchParam[1].type = #date
* rest.resource[2].searchParam[1].extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest.resource[2].searchParam[1].extension[0].valueCode = #SHALL
  // SHALL support search by name
* rest.resource[2].searchParam[2].name = "name"
* rest.resource[2].searchParam[2].definition = "http://hl7.org/fhir/SearchParameter/Location-name"
* rest.resource[2].searchParam[2].type = #string
* rest.resource[2].searchParam[2].extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest.resource[2].searchParam[2].extension[0].valueCode = #SHALL
  // SHALL support search by identifier
* rest.resource[2].searchParam[3].name = "identifier"
* rest.resource[2].searchParam[3].definition = "http://hl7.org/fhir/SearchParameter/Location-identifier"
* rest.resource[2].searchParam[3].type = #token
* rest.resource[2].searchParam[3].extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest.resource[2].searchParam[3].extension[0].valueCode = #SHALL

  // Measure requirements
* rest.resource[3].type = #Measure
* rest.resource[3].supportedProfile[0] = "http://hl7.org/fhir/us/saner/StructureDefinition/PublicHealthMeasure"
* rest.resource[3].supportedProfile[1] = "http://hl7.org/fhir/us/saner/StructureDefinition/PublicHealthMeasureStratifier"
  // SHOULD support Measure with the PublicHealthMeasure and PublicHealthMeasureStratifier Profile
  //* rest.resource[3].extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
  //* rest.resource[3].extension[0].valueCode = #SHOULD
  // SHOULD support read on Measure
* rest.resource[3].interaction[0].code = #read
* rest.resource[3].interaction[0].extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest.resource[3].interaction[0].extension[0].valueCode = #SHOULD
  // SHOULD support update on Measure
* rest.resource[3].interaction[1].code = #search-type
* rest.resource[3].interaction[1].extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest.resource[3].interaction[1].extension[0].valueCode = #SHOULD
* rest.resource[3].searchInclude = "*"
  // SHOULD support search by url
* rest.resource[3].searchParam[0].name = "url"
* rest.resource[3].searchParam[0].definition = "http://hl7.org/fhir/SearchParameter/Measure-url"
* rest.resource[3].searchParam[0].type = #uri
* rest.resource[3].searchParam[0].extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest.resource[3].searchParam[0].extension[0].valueCode = #SHOULD
  // SHOULD support search by code
* rest.resource[3].searchParam[1].name = "code"
* rest.resource[3].searchParam[1].definition = "http://hl7.org/fhir/us/saner/SearchParameter/SearchParameter-code"
* rest.resource[3].searchParam[1].type = #token
* rest.resource[3].searchParam[1].extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest.resource[3].searchParam[1].extension[0].valueCode = #SHOULD
  // SHOULD support search by definition-text
* rest.resource[3].searchParam[2].name = "definition-text"
* rest.resource[3].searchParam[2].definition = "http://hl7.org/fhir/us/saner/SearchParameter/SearchParameter-definition-text"
* rest.resource[3].searchParam[2].type = #string
* rest.resource[3].searchParam[2].extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest.resource[3].searchParam[2].extension[0].valueCode = #SHOULD

  // QuestionnaireResponse requirements
* rest.resource[4].type = #QuestionnaireResponse
  // SHALL support QuestionnaireResponse
  //* rest.resource[4].extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
  //* rest.resource[4].extension[0].valueCode = #SHALL
  // SHALL support read
* rest.resource[4].interaction[0].code = #read
* rest.resource[4].interaction[0].extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest.resource[4].interaction[0].extension[0].valueCode = #SHALL
  // SHALL support search
* rest.resource[4].interaction[1].code = #search-type
* rest.resource[4].interaction[1].extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest.resource[4].interaction[1].extension[0].valueCode = #SHALL
* rest.resource[4].searchInclude = "*"
  // SHALL support search by _id
* rest.resource[4].searchParam[0].name = "_id"
* rest.resource[4].searchParam[0].definition = "http://hl7.org/fhir/SearchParameter/Resource-id"
* rest.resource[4].searchParam[0].type = #token
* rest.resource[4].searchParam[0].extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest.resource[4].searchParam[0].extension[0].valueCode = #SHALL
  // SHALL support search by _lastUpdated
* rest.resource[4].searchParam[1].name = "_lastUpdated"
* rest.resource[4].searchParam[1].definition = "http://hl7.org/fhir/SearchParameter/Resource-lastUpdated"
* rest.resource[4].searchParam[1].type = #date
* rest.resource[4].searchParam[1].extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest.resource[4].searchParam[1].extension[0].valueCode = #SHALL
  // SHALL support search by subject
  // TODO: a SearchParameter should be defined that constrains this to only Location references
  // TODO: a SearchParameter should be defined that only allows the :Identifier modifier.  Should this also be constrained only to LocatioN?
* rest.resource[4].searchParam[2].name = "subject"
* rest.resource[4].searchParam[2].definition = "http://hl7.org/fhir/SearchParameter/MeasureReport-subject"
* rest.resource[4].searchParam[2].type = #reference
* rest.resource[4].searchParam[2].extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest.resource[4].searchParam[2].extension[0].valueCode = #SHALL
  // SHOULD support search by code
* rest.resource[4].searchParam[3].name = "code"
* rest.resource[4].searchParam[3].definition = "http://hl7.org/fhir/us/saner/SearchParameter/SearchParameter-code"
* rest.resource[4].searchParam[3].type = #token
* rest.resource[4].searchParam[3].extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest.resource[4].searchParam[3].extension[0].valueCode = #SHOULD
  //SHALL support _include for any resource
* rest.resource[4].searchInclude[0] = "*"
* rest.resource[4].searchInclude[0].extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest.resource[4].searchInclude[0].extension[0].valueCode = #SHALL

  // Questionnaire requirements
* rest.resource[5].type = #Questionnaire
  // SHOULD support Measure with the PublicHealthMeasure and PublicHealthMeasureStratifier Profile
  //* rest.resource[5].extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
  //* rest.resource[5].extension[0].valueCode = #SHOULD
  // SHOULD support read
* rest.resource[5].interaction[0].code = #read
* rest.resource[5].interaction[0].extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest.resource[5].interaction[0].extension[0].valueCode = #SHOULD
  // SHOULD support update
* rest.resource[5].interaction[1].code = #search-type
* rest.resource[5].interaction[1].extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest.resource[5].interaction[1].extension[0].valueCode = #SHOULD
* rest.resource[5].searchInclude = "*"
  // SHOULD support search by url
* rest.resource[5].searchParam[0].name = "url"
* rest.resource[5].searchParam[0].definition = "http://hl7.org/fhir/SearchParameter/Measure-url"
* rest.resource[5].searchParam[0].type = #uri
* rest.resource[5].searchParam[0].extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest.resource[5].searchParam[0].extension[0].valueCode = #SHOULD
  // SHOULD support search by code
* rest.resource[5].searchParam[1].name = "code"
* rest.resource[5].searchParam[1].definition = "http://hl7.org/fhir/us/saner/SearchParameter/SearchParameter-code"
* rest.resource[5].searchParam[1].type = #token
* rest.resource[5].searchParam[1].extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest.resource[5].searchParam[1].extension[0].valueCode = #SHOULD
  // SHOULD support search by definition-text
* rest.resource[5].searchParam[2].name = "definition-text"
* rest.resource[5].searchParam[2].definition = "http://hl7.org/fhir/us/saner/SearchParameter/SearchParameter-definition-text"
* rest.resource[5].searchParam[2].type = #string
* rest.resource[5].searchParam[2].extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest.resource[5].searchParam[2].extension[0].valueCode = #SHOULD