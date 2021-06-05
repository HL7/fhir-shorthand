Profile: CapabilityStatementParent
Parent: CapabilityStatement
Id: fsh-capabilitystatement-parent
Title: "CapabilityStatement profile for easy specification"
Description: "CapabilityStatement profile that has all resources sliced for easy specification."
* rest ^slicing.discriminator.type = #value
* rest ^slicing.discriminator.path = "mode"
* rest contains client 1..1 MS and server 1..1 MS
* rest[client]
  * mode = #client
  * resource ^slicing.discriminator.type = #value
  * resource ^slicing.discriminator.path = "mode"
  * resource contains 
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
  * resource[account].type = #Account
  * resource[activitydefinition].type = #ActivityDefinition
  * resource[adverseevent].type = #AdverseEvent
  * resource[allergyintolerance].type = #AllergyIntolerance
  * resource[appointment].type = #Appointment
  * resource[appointmentresponse].type = #AppointmentResponse
  * resource[auditevent].type = #AuditEvent
  * resource[basic].type = #Basic
  * resource[binary].type = #Binary
  * resource[biologicallyderivedproduct].type = #BiologicallyDerivedProduct
  * resource[bodystructure].type = #BodyStructure
  * resource[bundle].type = #Bundle
  * resource[capabilitystatement].type = #CapabilityStatement
  * resource[careplan].type = #CarePlan
  * resource[careteam].type = #CareTeam
  * resource[catalogentry].type = #CatalogEntry
  * resource[chargeitem].type = #ChargeItem
  * resource[chargeitemdefinition].type = #ChargeItemDefinition
  * resource[claim].type = #Claim
  * resource[claimresponse].type = #ClaimResponse
  * resource[clinicalimpression].type = #ClinicalImpression
  * resource[codesystem].type = #CodeSystem
  * resource[communication].type = #Communication
  * resource[communicationrequest].type = #CommunicationRequest
  * resource[compartmentdefinition].type = #CompartmentDefinition
  * resource[composition].type = #Composition
  * resource[conceptmap].type = #ConceptMap
  * resource[condition].type = #Condition
  * resource[consent].type = #Consent
  * resource[contract].type = #Contract
  * resource[coverage].type = #Coverage
  * resource[coverageeligibilityrequest].type = #CoverageEligibilityRequest
  * resource[coverageeligibilityresponse].type = #CoverageEligibilityResponse
  * resource[detectedissue].type = #DetectedIssue
  * resource[device].type = #Device
  * resource[devicedefinition].type = #DeviceDefinition
  * resource[devicemetric].type = #DeviceMetric
  * resource[devicerequest].type = #DeviceRequest
  * resource[deviceusestatement].type = #DeviceUseStatement
  * resource[diagnosticreport].type = #DiagnosticReport
  * resource[documentmanifest].type = #DocumentManifest
  * resource[documentreference].type = #DocumentReference
  * resource[domainresource].type = #DomainResource
  * resource[effectevidencesynthesis].type = #EffectEvidenceSynthesis
  * resource[encounter].type = #Encounter
  * resource[endpoint].type = #Endpoint
  * resource[enrollmentrequest].type = #EnrollmentRequest
  * resource[enrollmentresponse].type = #EnrollmentResponse
  * resource[episodeofcare].type = #EpisodeOfCare
  * resource[eventdefinition].type = #EventDefinition
  * resource[evidence].type = #Evidence
  * resource[evidencevariable].type = #EvidenceVariable
  * resource[examplescenario].type = #ExampleScenario
  * resource[explanationofbenefit].type = #ExplanationOfBenefit
  * resource[familymemberhistory].type = #FamilyMemberHistory
  * resource[flag].type = #Flag
  * resource[goal].type = #Goal
  * resource[graphdefinition].type = #GraphDefinition
  * resource[group].type = #Group
  * resource[guidanceresponse].type = #GuidanceResponse
  * resource[healthcareservice].type = #HealthcareService
  * resource[imagingstudy].type = #ImagingStudy
  * resource[immunization].type = #Immunization
  * resource[immunizationevaluation].type = #ImmunizationEvaluation
  * resource[immunizationrecommendation].type = #ImmunizationRecommendation
  * resource[implementationguide].type = #ImplementationGuide
  * resource[insuranceplan].type = #InsurancePlan
  * resource[invoice].type = #Invoice
  * resource[library].type = #Library
  * resource[linkage].type = #Linkage
  * resource[list].type = #List
  * resource[location].type = #Location
  * resource[measure].type = #Measure
  * resource[measurereport].type = #MeasureReport
  * resource[media].type = #Media
  * resource[medication].type = #Medication
  * resource[medicationadministration].type = #MedicationAdministration
  * resource[medicationdispense].type = #MedicationDispense
  * resource[medicationknowledge].type = #MedicationKnowledge
  * resource[medicationrequest].type = #MedicationRequest
  * resource[medicationstatement].type = #MedicationStatement
  * resource[medicinalproduct].type = #MedicinalProduct
  * resource[medicinalproductauthorization].type = #MedicinalProductAuthorization
  * resource[medicinalproductcontraindication].type = #MedicinalProductContraindication
  * resource[medicinalproductindication].type = #MedicinalProductIndication
  * resource[medicinalproductingredient].type = #MedicinalProductIngredient
  * resource[medicinalproductinteraction].type = #MedicinalProductInteraction
  * resource[medicinalproductmanufactured].type = #MedicinalProductManufactured
  * resource[medicinalproductpackaged].type = #MedicinalProductPackaged
  * resource[medicinalproductpharmaceutical].type = #MedicinalProductPharmaceutical
  * resource[medicinalproductundesirableeffect].type = #MedicinalProductUndesirableEffect
  * resource[messagedefinition].type = #MessageDefinition
  * resource[messageheader].type = #MessageHeader
  * resource[molecularsequence].type = #MolecularSequence
  * resource[namingsystem].type = #NamingSystem
  * resource[nutritionorder].type = #NutritionOrder
  * resource[observation].type = #Observation
  * resource[observationdefinition].type = #ObservationDefinition
  * resource[operationdefinition].type = #OperationDefinition
  * resource[operationoutcome].type = #OperationOutcome
  * resource[organization].type = #Organization
  * resource[organizationaffiliation].type = #OrganizationAffiliation
  * resource[parameters].type = #Parameters
  * resource[patient].type = #Patient
  * resource[paymentnotice].type = #PaymentNotice
  * resource[paymentreconciliation].type = #PaymentReconciliation
  * resource[person].type = #Person
  * resource[plandefinition].type = #PlanDefinition
  * resource[practitioner].type = #Practitioner
  * resource[practitionerrole].type = #PractitionerRole
  * resource[procedure].type = #Procedure
  * resource[provenance].type = #Provenance
  * resource[questionnaire].type = #Questionnaire
  * resource[questionnaireresponse].type = #QuestionnaireResponse
  * resource[relatedperson].type = #RelatedPerson
  * resource[requestgroup].type = #RequestGroup
  * resource[researchdefinition].type = #ResearchDefinition
  * resource[researchelementdefinition].type = #ResearchElementDefinition
  * resource[researchstudy].type = #ResearchStudy
  * resource[researchsubject].type = #ResearchSubject
  * resource[resource].type = #Resource
  * resource[riskassessment].type = #RiskAssessment
  * resource[riskevidencesynthesis].type = #RiskEvidenceSynthesis
  * resource[schedule].type = #Schedule
  * resource[searchparameter].type = #SearchParameter
  * resource[servicerequest].type = #ServiceRequest
  * resource[slot].type = #Slot
  * resource[specimen].type = #Specimen
  * resource[specimendefinition].type = #SpecimenDefinition
  * resource[structuredefinition].type = #StructureDefinition
  * resource[structuremap].type = #StructureMap
  * resource[subscription].type = #Subscription
  * resource[substance].type = #Substance
  * resource[substancenucleicacid].type = #SubstanceNucleicAcid
  * resource[substancepolymer].type = #SubstancePolymer
  * resource[substanceprotein].type = #SubstanceProtein
  * resource[substancereferenceinformation].type = #SubstanceReferenceInformation
  * resource[substancesourcematerial].type = #SubstanceSourceMaterial
  * resource[substancespecification].type = #SubstanceSpecification
  * resource[supplydelivery].type = #SupplyDelivery
  * resource[supplyrequest].type = #SupplyRequest
  * resource[task].type = #Task
  * resource[terminologycapabilities].type = #TerminologyCapabilities
  * resource[testreport].type = #TestReport
  * resource[testscript].type = #TestScript
  * resource[value-set].type = #ValueSet
  * resource[verificationresult].type = #VerificationResult
  * resource[visionprescription].type = #VisionPrescription
* rest[server]
  * mode = #server
  * resource contains 
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
  * resource[account].type = #Account
  * resource[activitydefinition].type = #ActivityDefinition
  * resource[adverseevent].type = #AdverseEvent
  * resource[allergyintolerance].type = #AllergyIntolerance
  * resource[appointment].type = #Appointment
  * resource[appointmentresponse].type = #AppointmentResponse
  * resource[auditevent].type = #AuditEvent
  * resource[basic].type = #Basic
  * resource[binary].type = #Binary
  * resource[biologicallyderivedproduct].type = #BiologicallyDerivedProduct
  * resource[bodystructure].type = #BodyStructure
  * resource[bundle].type = #Bundle
  * resource[capabilitystatement].type = #CapabilityStatement
  * resource[careplan].type = #CarePlan
  * resource[careteam].type = #CareTeam
  * resource[catalogentry].type = #CatalogEntry
  * resource[chargeitem].type = #ChargeItem
  * resource[chargeitemdefinition].type = #ChargeItemDefinition
  * resource[claim].type = #Claim
  * resource[claimresponse].type = #ClaimResponse
  * resource[clinicalimpression].type = #ClinicalImpression
  * resource[codesystem].type = #CodeSystem
  * resource[communication].type = #Communication
  * resource[communicationrequest].type = #CommunicationRequest
  * resource[compartmentdefinition].type = #CompartmentDefinition
  * resource[composition].type = #Composition
  * resource[conceptmap].type = #ConceptMap
  * resource[condition].type = #Condition
  * resource[consent].type = #Consent
  * resource[contract].type = #Contract
  * resource[coverage].type = #Coverage
  * resource[coverageeligibilityrequest].type = #CoverageEligibilityRequest
  * resource[coverageeligibilityresponse].type = #CoverageEligibilityResponse
  * resource[detectedissue].type = #DetectedIssue
  * resource[device].type = #Device
  * resource[devicedefinition].type = #DeviceDefinition
  * resource[devicemetric].type = #DeviceMetric
  * resource[devicerequest].type = #DeviceRequest
  * resource[deviceusestatement].type = #DeviceUseStatement
  * resource[diagnosticreport].type = #DiagnosticReport
  * resource[documentmanifest].type = #DocumentManifest
  * resource[documentreference].type = #DocumentReference
  * resource[domainresource].type = #DomainResource
  * resource[effectevidencesynthesis].type = #EffectEvidenceSynthesis
  * resource[encounter].type = #Encounter
  * resource[endpoint].type = #Endpoint
  * resource[enrollmentrequest].type = #EnrollmentRequest
  * resource[enrollmentresponse].type = #EnrollmentResponse
  * resource[episodeofcare].type = #EpisodeOfCare
  * resource[eventdefinition].type = #EventDefinition
  * resource[evidence].type = #Evidence
  * resource[evidencevariable].type = #EvidenceVariable
  * resource[examplescenario].type = #ExampleScenario
  * resource[explanationofbenefit].type = #ExplanationOfBenefit
  * resource[familymemberhistory].type = #FamilyMemberHistory
  * resource[flag].type = #Flag
  * resource[goal].type = #Goal
  * resource[graphdefinition].type = #GraphDefinition
  * resource[group].type = #Group
  * resource[guidanceresponse].type = #GuidanceResponse
  * resource[healthcareservice].type = #HealthcareService
  * resource[imagingstudy].type = #ImagingStudy
  * resource[immunization].type = #Immunization
  * resource[immunizationevaluation].type = #ImmunizationEvaluation
  * resource[immunizationrecommendation].type = #ImmunizationRecommendation
  * resource[implementationguide].type = #ImplementationGuide
  * resource[insuranceplan].type = #InsurancePlan
  * resource[invoice].type = #Invoice
  * resource[library].type = #Library
  * resource[linkage].type = #Linkage
  * resource[list].type = #List
  * resource[location].type = #Location
  * resource[measure].type = #Measure
  * resource[measurereport].type = #MeasureReport
  * resource[media].type = #Media
  * resource[medication].type = #Medication
  * resource[medicationadministration].type = #MedicationAdministration
  * resource[medicationdispense].type = #MedicationDispense
  * resource[medicationknowledge].type = #MedicationKnowledge
  * resource[medicationrequest].type = #MedicationRequest
  * resource[medicationstatement].type = #MedicationStatement
  * resource[medicinalproduct].type = #MedicinalProduct
  * resource[medicinalproductauthorization].type = #MedicinalProductAuthorization
  * resource[medicinalproductcontraindication].type = #MedicinalProductContraindication
  * resource[medicinalproductindication].type = #MedicinalProductIndication
  * resource[medicinalproductingredient].type = #MedicinalProductIngredient
  * resource[medicinalproductinteraction].type = #MedicinalProductInteraction
  * resource[medicinalproductmanufactured].type = #MedicinalProductManufactured
  * resource[medicinalproductpackaged].type = #MedicinalProductPackaged
  * resource[medicinalproductpharmaceutical].type = #MedicinalProductPharmaceutical
  * resource[medicinalproductundesirableeffect].type = #MedicinalProductUndesirableEffect
  * resource[messagedefinition].type = #MessageDefinition
  * resource[messageheader].type = #MessageHeader
  * resource[molecularsequence].type = #MolecularSequence
  * resource[namingsystem].type = #NamingSystem
  * resource[nutritionorder].type = #NutritionOrder
  * resource[observation].type = #Observation
  * resource[observationdefinition].type = #ObservationDefinition
  * resource[operationdefinition].type = #OperationDefinition
  * resource[operationoutcome].type = #OperationOutcome
  * resource[organization].type = #Organization
  * resource[organizationaffiliation].type = #OrganizationAffiliation
  * resource[parameters].type = #Parameters
  * resource[patient].type = #Patient
  * resource[paymentnotice].type = #PaymentNotice
  * resource[paymentreconciliation].type = #PaymentReconciliation
  * resource[person].type = #Person
  * resource[plandefinition].type = #PlanDefinition
  * resource[practitioner].type = #Practitioner
  * resource[practitionerrole].type = #PractitionerRole
  * resource[procedure].type = #Procedure
  * resource[provenance].type = #Provenance
  * resource[questionnaire].type = #Questionnaire
  * resource[questionnaireresponse].type = #QuestionnaireResponse
  * resource[relatedperson].type = #RelatedPerson
  * resource[requestgroup].type = #RequestGroup
  * resource[researchdefinition].type = #ResearchDefinition
  * resource[researchelementdefinition].type = #ResearchElementDefinition
  * resource[researchstudy].type = #ResearchStudy
  * resource[researchsubject].type = #ResearchSubject
  * resource[resource].type = #Resource
  * resource[riskassessment].type = #RiskAssessment
  * resource[riskevidencesynthesis].type = #RiskEvidenceSynthesis
  * resource[schedule].type = #Schedule
  * resource[searchparameter].type = #SearchParameter
  * resource[servicerequest].type = #ServiceRequest
  * resource[slot].type = #Slot
  * resource[specimen].type = #Specimen
  * resource[specimendefinition].type = #SpecimenDefinition
  * resource[structuredefinition].type = #StructureDefinition
  * resource[structuremap].type = #StructureMap
  * resource[subscription].type = #Subscription
  * resource[substance].type = #Substance
  * resource[substancenucleicacid].type = #SubstanceNucleicAcid
  * resource[substancepolymer].type = #SubstancePolymer
  * resource[substanceprotein].type = #SubstanceProtein
  * resource[substancereferenceinformation].type = #SubstanceReferenceInformation
  * resource[substancesourcematerial].type = #SubstanceSourceMaterial
  * resource[substancespecification].type = #SubstanceSpecification
  * resource[supplydelivery].type = #SupplyDelivery
  * resource[supplyrequest].type = #SupplyRequest
  * resource[task].type = #Task
  * resource[terminologycapabilities].type = #TerminologyCapabilities
  * resource[testreport].type = #TestReport
  * resource[testscript].type = #TestScript
  * resource[value-set].type = #ValueSet
  * resource[verificationresult].type = #VerificationResult
  * resource[visionprescription].type = #VisionPrescription


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
* rest.resource[0]
  * interaction[0]
    * code = #read
    * extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
    * extension[0].valueCode = #SHALL
  // SHALL support search on MeasureReport
  * interaction[1]
    * code = #search-type
    * extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
    * extension[0].valueCode = #SHALL
  * searchInclude = "*"
  // SHALL support search by _id
  * searchParam[0]
    * name = "_id"
    * definition = "http://hl7.org/fhir/SearchParameter/Resource-id"
    * type = #token
    * extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
    * extension[0].valueCode = #SHALL
  // SHALL support search by _lastUpdated
  * searchParam[+]
    * name = "_lastUpdated"
    * definition = "http://hl7.org/fhir/SearchParameter/Resource-lastUpdated"
    * type = #date
    * extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
    * extension[0].valueCode = #SHALL
  // SHALL support search by date
  * searchParam[+]
    * name = "date"
    * definition = "http://hl7.org/fhir/SearchParameter/MeasureReport-date"
    * type = #date
    * extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
    * extension[0].valueCode = #SHALL
  // SHALL support search by measure
  * searchParam[+]
    * name = "measure"
    * definition = "http://hl7.org/fhir/SearchParameter/MeasureReport-measure"
    * type = #reference
    * extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
    * extension[0].valueCode = #SHALL
  // SHALL support search by subject
  // TODO: a SearchParameter should be defined that constrains this to only Location references
  // TODO: a SearchParameter should be defined that only allows the :Identifier modifier.  Should this also be constrained only to LocatioN?
  * searchParam[+]
    * name = "subject"
    * definition = "http://hl7.org/fhir/SearchParameter/MeasureReport-subject"
    * type = #reference
    * extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
    * extension[0].valueCode = #SHALL
  // SHALL support search by period
  * searchParam[+]
    * name = "period"
    * definition = "http://hl7.org/fhir/SearchParameter/MeasureReport-period"
    * type = #date
    * extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
    * extension[0].valueCode = #SHALL
  // SHALL support search by reporter
  // TODO: a SearchParameter should be defined that allows the identifier modifier
  * searchParam[+]
    * name = "reporter"
    * definition = "http://hl7.org/fhir/SearchParameter/MeasureReport-reporter"
    * type = #reference
    * extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
    * extension[0].valueCode = #SHALL
  //SHALL support _include for any resource
  * searchInclude[0] = "*"
    * extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
    * extension[0].valueCode = #SHALL
  // SHOULD support search by code
  * searchParam[+]
    * name = "code"
    * definition = "http://hl7.org/fhir/us/saner/SearchParameter/SearchParameter-code"
    * type = #token
    * extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
    * extension[0].valueCode = #SHOULD
  // TODO: a SearchParameter for measure.title chained search as a SHOULD

  // Location requirements
* rest.resource[+]
  * type = #Location
  * supportedProfile = "http://hl7.org/fhir/us/saner/StructureDefinition/saner-resource-location"
  // SHOULD support Location with the SANERResourceLocation Profile
  //   * extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
  //   * extension[0].valueCode = #SHALL
  // SHOULD support read on Location
  * interaction[0]
    * code = #read
    * extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
    * extension[0].valueCode = #SHALL
  // SHOULD support search on Location
  * interaction[1]
    * code = #search-type
    * extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
    * extension[0].valueCode = #SHALL
  // SHALL support search by _id
  * searchParam[0]
    * name = "_id"
    * definition = "http://hl7.org/fhir/SearchParameter/Resource-id"
    * type = #token
    * extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
    * extension[0].valueCode = #SHALL
  // SHALL support search by _lastUpdated
  * searchParam[+]
    * name = "_lastUpdated"
    * definition = "http://hl7.org/fhir/SearchParameter/Resource-lastUpdated"
    * type = #date
    * extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
    * extension[0].valueCode = #SHALL
  // SHALL support search by name
  * searchParam[+]
    * name = "name"
    * definition = "http://hl7.org/fhir/SearchParameter/Location-name"
    * type = #string
    * extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
    * extension[0].valueCode = #SHALL
  // SHALL support search by identifier
  * searchParam[+]
    * name = "identifier"
    * definition = "http://hl7.org/fhir/SearchParameter/Location-identifier"
    * type = #token
    * extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
    * extension[0].valueCode = #SHALL
  // SHALL support search by address
  * searchParam[+]
    * name = "address"
    * definition = "http://hl7.org/fhir/SearchParameter/Location-address"
    * type = #string
    * extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
    * extension[0].valueCode = #SHALL
  // SHALL support search by address-city
  * searchParam[+]
    * name = "address-city"
    * definition = "http://hl7.org/fhir/SearchParameter/Location-address-city"
    * type = #string
    * extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
    * extension[0].valueCode = #SHALL
  // SHALL support search by address-country
  * searchParam[+]
    * name = "address-country"
    * definition = "http://hl7.org/fhir/SearchParameter/Location-address-country"
    * type = #string
    * extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
    * extension[0].valueCode = #SHALL
  // SHALL support search by address-postalcode
  * searchParam[+]
    * name = "address-postalcode"
    * definition = "http://hl7.org/fhir/SearchParameter/Location-address-postalcode"
    * type = #string
    * extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
    * extension[0].valueCode = #SHALL
  // SHALL support search by address-state
  * searchParam[+]
    * name = "address-state"
    * definition = "http://hl7.org/fhir/SearchParameter/Location-address-state"
    * type = #string
    * extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
    * extension[0].valueCode = #SHALL
  // SHALL support search by address-use
  * searchParam[+]
    * name = "address-use"
    * definition = "http://hl7.org/fhir/SearchParameter/Location-address-use"
    * type = #token
    * extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
    * extension[0].valueCode = #SHALL

  // Organization requirements
* rest.resource[+]
  * type = #Organization
  // SHOULD support Organization
  //   * extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
  //   * extension[0].valueCode = #SHALL
  // SHOULD support create on Organization
  * interaction[0]
    * code = #read
    * extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
    * extension[0].valueCode = #SHALL
  // SHOULD support update on Organization
  * interaction[1]
    * code = #search-type
    * extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
    * extension[0].valueCode = #SHALL
  // SHALL support search by _id
    * name = "_id"
    * definition = "http://hl7.org/fhir/SearchParameter/Resource-id"
    * type = #token
    * extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
    * extension[0].valueCode = #SHALL
  // SHALL support search by _lastUpdated
  * searchParam[+]
    * name = "_lastUpdated"
    * definition = "http://hl7.org/fhir/SearchParameter/Resource-lastUpdated"
    * type = #date
    * extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
    * extension[0].valueCode = #SHALL
  // SHALL support search by name
  * searchParam[+]
    * name = "name"
    * definition = "http://hl7.org/fhir/SearchParameter/Location-name"
    * type = #string
    * extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
    * extension[0].valueCode = #SHALL
  // SHALL support search by identifier
  * searchParam[+]
    * name = "identifier"
    * definition = "http://hl7.org/fhir/SearchParameter/Location-identifier"
    * type = #token
    * extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
    * extension[0].valueCode = #SHALL

  // Measure requirements
* rest.resource[3]
  * type = #Measure
  * supportedProfile[0] = "http://hl7.org/fhir/us/saner/StructureDefinition/PublicHealthMeasure"
  * supportedProfile[1] = "http://hl7.org/fhir/us/saner/StructureDefinition/PublicHealthMeasureStratifier"
  // SHOULD support Measure with the PublicHealthMeasure and PublicHealthMeasureStratifier Profile
  //   * extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
  //   * extension[0].valueCode = #SHOULD
  // SHOULD support read on Measure
  * interaction[0]
    * code = #read
    * extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
    * extension[0].valueCode = #SHOULD
  // SHOULD support update on Measure
  * interaction[1]
    * code = #search-type
    * extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
    * extension[0].valueCode = #SHOULD
  * searchInclude = "*"
  // SHOULD support search by url
  * searchParam[0]
    * name = "url"
    * definition = "http://hl7.org/fhir/SearchParameter/Measure-url"
    * type = #uri
    * extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
    * extension[0].valueCode = #SHOULD
  // SHOULD support search by code
  * searchParam[+]
    * name = "code"
    * definition = "http://hl7.org/fhir/us/saner/SearchParameter/SearchParameter-code"
    * type = #token
    * extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
    * extension[0].valueCode = #SHOULD
  // SHOULD support search by definition-text
  * searchParam[+]
    * name = "definition-text"
    * definition = "http://hl7.org/fhir/us/saner/SearchParameter/SearchParameter-definition-text"
    * type = #string
    * extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
    * extension[0].valueCode = #SHOULD

  // QuestionnaireResponse requirements
* rest.resource[4]
  * type = #QuestionnaireResponse
  // SHALL support QuestionnaireResponse
  //   * extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
  //   * extension[0].valueCode = #SHALL
  // SHALL support read
  * interaction[0]
    * code = #read
    * extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
    * extension[0].valueCode = #SHALL
  // SHALL support search
  * interaction[1]
    * code = #search-type
    * extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
    * extension[0].valueCode = #SHALL
  * searchInclude = "*"
  // SHALL support search by _id
  * searchParam[0]
    * name = "_id"
    * definition = "http://hl7.org/fhir/SearchParameter/Resource-id"
    * type = #token
    * extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
    * extension[0].valueCode = #SHALL
  // SHALL support search by _lastUpdated
  * searchParam[+]
    * name = "_lastUpdated"
    * definition = "http://hl7.org/fhir/SearchParameter/Resource-lastUpdated"
    * type = #date
    * extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
    * extension[0].valueCode = #SHALL
  // SHALL support search by subject
  // TODO: a SearchParameter should be defined that constrains this to only Location references
  // TODO: a SearchParameter should be defined that only allows the :Identifier modifier.  Should this also be constrained only to LocatioN?
  * searchParam[+]
    * name = "subject"
    * definition = "http://hl7.org/fhir/SearchParameter/MeasureReport-subject"
    * type = #reference
    * extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
    * extension[0].valueCode = #SHALL
  // SHOULD support search by code
  * searchParam[+]
    * name = "code"
    * definition = "http://hl7.org/fhir/us/saner/SearchParameter/SearchParameter-code"
    * type = #token
    * extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
    * extension[0].valueCode = #SHOULD
  //SHALL support _include for any resource
  * searchInclude[0] = "*"
    * extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
    * extension[0].valueCode = #SHALL

  // Questionnaire requirements
* rest.resource[5]
  * type = #Questionnaire
  // SHOULD support Measure with the PublicHealthMeasure and PublicHealthMeasureStratifier Profile
  //   * extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
  //   * extension[0].valueCode = #SHOULD
  // SHOULD support read
  * interaction[0]
    * code = #read
    * extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
    * extension[0].valueCode = #SHOULD
  // SHOULD support update
  * interaction[1]
    * code = #search-type
    * extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
    * extension[0].valueCode = #SHOULD
  * searchInclude = "*"
  // SHOULD support search by url
  * searchParam[0]
    * name = "url"
    * definition = "http://hl7.org/fhir/SearchParameter/Measure-url"
    * type = #uri
    * extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
    * extension[0].valueCode = #SHOULD
  // SHOULD support search by code
  * searchParam[+]
    * name = "code"
    * definition = "http://hl7.org/fhir/us/saner/SearchParameter/SearchParameter-code"
    * type = #token
    * extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
    * extension[0].valueCode = #SHOULD
  // SHOULD support search by definition-text
  * searchParam[+]
    * name = "definition-text"
    * definition = "http://hl7.org/fhir/us/saner/SearchParameter/SearchParameter-definition-text"
    * type = #string
    * extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
    * extension[0].valueCode = #SHOULD