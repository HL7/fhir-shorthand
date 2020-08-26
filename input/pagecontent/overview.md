FHIR Shorthand (FSH) is a domain-specific language for defining the contents of FHIR Implementation Guides (IG). The language is specifically designed for this purpose, simple and compact, and allows the author to express their intent with fewer concerns about underlying FHIR mechanics. FSH can be created and updated using any text editor, and because it is text, it enables distributed, team-based development using source code control tools such as GitHub.

<img src="FHIR-Shorthand-Logo.png" alt="FHIR Shorthand Logo" width="300px" style="float:none; margin: 0px 0px 0px 0px;" />

#### Motivations for FHIR Shorthand

FSH was created in response to the need in the FHIR community for scalable, fast, user-friendly tools for IG creation and maintenance. Experience has shown that profiling projects can be difficult and slow, and the resulting IG quality inconsistent. Profiling projects often go through many iterations. As such, an agile approach to refactoring and revision is invaluable.

<img src="IG-Need-For-Agility.png" alt="IG Need for Agility" width="800px" style="float:none; margin: 0px 0px 0px 0px;" />

Experience across many domains has shown that complex software projects are best approached with textual languages. As a language designed for the job of profiling and IG creation, FSH is concise, understandable, and aligned to user intentions. Users may find that the FSH language representation is the best way to understand a set of profiles. Because it is text-based, FSH brings a degree of editing agility not found in graphical tools (cutting and pasting, global search and replace, spell checking, etc.) FSH is ideal for distributed development under source code control, providing meaningful version-to-version differentials, support for merging and conflict resolution, and nimble refactoring. These features allow FSH to scale in ways that other approaches cannot. Any text editor can be used to create or modify FSH, but advanced text editor plugins may also be used to further aid authoring.

### FHIR Shorthand Language

The complete FSH language is described in the [FHIR Shorthand Language Reference](reference.html). Here we present just enough to get a taste of FSH.

#### Basics

* **Grammar**: [FSH has a formal grammar](reference.html#appendix-formal-grammar) defined in [ANTLR4](https://www.antlr.org/).
* **Data types**: The primitive and complex data types and value formats in FSH are identical to the [primitive types and value formats in FHIR R4](http://hl7.org/fhir/R4/datatypes.html#primitive).
* **Whitespace**: Repeated whitespace characters are equivalent to one whitespace character within FSH files, unless they are part of string literals. New lines are considered whitespace.
* **Comments**: FSH uses `//` as leading delimiter for single-line comments, and the pair `/*`  `*/` to delimit multiple line comments.
* **Asterisk Character**: A leading asterisk is used to denote FSH rules. For example, here is a rule to set Organization.active to `true`:

  ```
  * active = true
  ```

* **Escape Character**: FSH uses the backslash as the escape character in string literals. For example, use `\"` to embed a quotation mark in a string.
* **Caret Character**: FSH uses [caret syntax](reference.html#caret-paths) to directly reference the definitional structure associated with an item. When defining a profile, the caret character `^` (also called circumflex) allows you to refer to elements in the SD. For example, to set the element StructureDefinition.experimental:

  ```
  * ^experimental = false
  ```

  Another use of caret syntax is to specify slicing logic (in this case, slicing Observation.component):

  ```
  * component ^slicing.discriminator.type = #pattern
  * component ^slicing.discriminator.path = "code"
  * component ^slicing.rules = #open
  * component ^slicing.description = "Slice based on the component.code pattern"
  ```


* **Aliases**: To improve readability, FSH allows the user to define aliases for URLs and oids. Once defined anywhere in a FSH project, the alias can be used anywhere the url or oid can be used. For example:

  ```
  Alias: SCT = http://snomed.info/sct
  ```

* **Coded Data Types**: A leading hash sign (#) (*aka* number sign, pound sign, or octothorp) is used in FSH to denote a code taken from a formal terminology. FSH provides special grammar for expressing FHIR's coded data types (code, Coding, CodeableConcept, and Quantity):

  <pre><code><i>{CodeSystem name|id|url}</i>#{code} <i>"{display string}"</i></code></pre>

  Only the `#{code}` portion is used to specify a code. For a Coding or CodeableConcept, the `CodeSystem` represents a reference to the controlled terminology that the code is taken from. The `"{display string}"` is optional.

  Here is SNOMED-CT code 363346000 in this syntax:

  ```
  http://snomed.info/sct#363346000 "Malignant neoplastic disease (disorder)"
  ```

  and here is the same code, using the alias `SCT` in place of http://snomed.info/sct:

  ```
  SCT#363346000 "Malignant neoplastic disease (disorder)"
  ```

  The code/Coding shorthand is frequently used in [assignment rules](reference.html#assignment-rules). FSH uses the `=` sign to express assignment. To set the bodySite in an instance of Condition:

  ```
  * bodySite = SCT#87878005 "Left cardiac ventricular structure"
  ```
 
  Another example is assigning the units of measure of a Quantity in a profile (using the alias UCUM for http://unitsofmeasure.org):

  ```
  * valueQuantity = UCUM#mm "millimeters"
  ```

#### Defining Items in FSH

Keywords are used to make declarations that introduce new items. A keyword statement follows the syntax:

```
{Keyword}: {value or expression}
```

Here's an example of using keywords to declare a profile:

```
Profile:  CancerDiseaseStatus
Parent:   Observation
Id:       mcode-cancer-disease-status
Title:    "Cancer Disease Status"
Description: "A clinician's qualitative judgment on the current trend of the cancer, e.g., whether it is stable, worsening (progressing), or improving (responding)."
```

Keywords that declare new items (like the `Profile` keyword in the previous example) must occur first in any set of keywords. There are nine declarative [keywords in FSH](reference.html#defining-items):

* Alias
* CodeSystem
* Extension
* Instance
* Invariant
* Mapping
* Profile
* RuleSet
* ValueSet

Note that not every type of FSH item has a direct FHIR equivalent. Alias and RuleSet are strictly FSH constructs, while Mappings and Invariants appear only as elements within a SD.

Each type of item has a different set of required and optional keywords, detailed in the [FSH Language Reference](reference.html#defining-items).

> **Note:** Keywords are case-sensitive.

#### Rules

The keyword section is followed by a number of rules. Rules are the mechanism for constraining a profile, defining an extension, creating slices, and more. All FSH rules begin with an asterisk:

```
* {rule statement}
```

The [formal syntax of rules](reference.html#rules-for-profiles-extensions-and-instances) are given in the [FSH Language reference](reference.html). Here is a summary of some of the more important rules in FSH:

* **Assignment rules** are used to set fixed values in instances and required patterns in profiles. For example:

  ```
  * bodySite.text = "Left ventricle"
  ```

  ```
  * onsetDateTime = "2019-04-02"
  ```

  ```
  * status = #arrived
  ```

* **Binding rules** are used on elements with coded values to specify the set of enumerated values for that element. Binding rules include [one of FHIR R4's binding strengths](http://hl7.org/fhir/R4/valueset-binding-strength.html) (example, preferred, extensible, or required). For example:

  ```
  * gender from http://hl7.org/fhir/ValueSet/administrative-gender (required)
  ```

  ```
  * address.state from USPSTwoLetterAlphabeticCodes (extensible)
  ```

* **Cardinality rules** constrain the number of occurrences of an element, either both upper and lower bounds, or just upper or lower bound. For example:

  ```
  * note 0..0
  ```

  ```
  * note 1..
  ```

  ```
  * note ..5
  ```

* **Contains rules** are used for slicing and extensions. Both cases involve specifying the type of elements that can appear in arrays.

  The following rule slices Observation.component into the two components of blood pressure:

  ```
  * component contains systolicBP 1..1 and diastolicBP 1..1
  ```
  Typically, after defining the slices, rules constraining the slices are required. In the blood pressure example, the slices have different codes and the same data type and units of measure:

  ```
  * component[systolicBP].code = http://loinc.org#8480-6 // Systolic blood pressure
  * component[systolicBP].value[x] only Quantity
  * component[systolicBP].valueQuantity = UCUM#mm[Hg]
  * component[diastolicBP].code = http://loinc.org#8462-4 // Diastolic blood pressure
  * component[diastolicBP].value[x] only Quantity
  * component[diastolicBP].valueQuantity = UCUM#mm[Hg]
  ```
    The syntax for extensions is very similar. Here are two examples:

  ```
  * bodySite.extension contains laterality 0..1
  ```

  ```
  * extension contains
      treatmentIntent 0..1 MS and
      terminationReason 0..* MS
  ```
  
   When incorporating an extension defined by FHIR, an external IG, or using FSH's `Extension` keyword, a modified syntax that assigns local name to the extension is used:

  ```
  // Adding standard FHIR extensions in an AllergyIntolerance profile:

  * extension contains
      allergyintolerance-certainty named substanceCertainty 0..1 MS and
      allergyintolerance-resolutionAge named resolutionAge 0..1 MS
  ```

* **Flag rules** add bits of information about elements impacting how implementers should handle them. The flags are those [defined in FHIR](http://hl7.org/fhir/R4/formats.html#table), except FSH uses `MS` for must-support and `SU` for summary. For example:

  ```
  * communication MS SU

  * identifier and identifier.system and identifier.value MS
  ```

* **Obeys rules** associate elements with constraints represented as XPath or FHIRPath expressions. For example:

  ```
  * obeys us-core-9  // invariant applies to entire profile

  * name obeys us-core-8  // invariant applies to the name element
  ```

* **Type rules** restrict the type of value that can be assigned to an element. For example:

  ```
  * value[x] only CodeableConcept
  ```

  ```
  * onset[x] only Period or Range
  ```

  ```
  * recorder only Reference(Practitioner)
  ```

  ```
  * recorder only Reference(Practitioner or PractitionerRole)
  ```


* **Value set rules** are used to include or exclude codes in value sets. These rules can be defined two ways:

  [Extensional](https://blog.healthlanguage.com/the-difference-between-intensional-and-extensional-value-sets) rules explicitly list the codes to be included and/or excluded, for example:

  ```
  * include SCT#54102005 "G1 grade (finding)"

  * exclude SCT#12619005 "Tumor grade GX"
  ```

  [Intensional](https://blog.healthlanguage.com/the-difference-between-intensional-and-extensional-value-sets) rules are used when code membership in the value set is defined algorithmically. For example, to include all codes from a code system:

  ```
  * include codes from system RXNORM
  ```

  Similar rules can include or exclude all codes from another value set:

  ```
  * include codes from valueset ConditionStatusTrendVS

  * exclude codes from valueset EndStageRenalDiseaseVS
  ```

  More complex intensional rules involving filters are also possible. These rules depend on relationships or properties defined in a specific code system. A rule for LOINC, for example, would not be applicable to SNOMED-CT. Here is an example of a SNOMED-CT intensional rule with a filter:

  ```
  * include codes from system SCT where concept is-a #123037004 "BodyStructure"
  ```

  > **Note:** Because including codes is much more common than excluding codes, for brevity, the word `include` is optional in all value set rules.

### FSH in Practice

This section presents an overview of how the FSH language is put into practice using [SUSHI](https://fshschool.org). The descriptions here are subject to change and represent the functionality in SUSHI as of the STU 1 publication date. The discussion in this section refers to the numbers in the following figure:

<img src="Workflow.png" alt="Overall FSH Workflow" width="800px" style="float:none; margin: 0px 0px 0px 0px;" />

#### FSH Projects and FSH Files

Content written in FSH is stored in plain text files (ASCII or UTF-8) with `.fsh` extensions (1). Profiles, extensions, value sets, code systems, examples, and other FHIR artifacts are defined in FSH files.

Any text editor can be used to create a FSH file. [Visual Studio Code](https://code.visualstudio.com/) has a useful [FSH plug-in](https://marketplace.visualstudio.com/search?term=fhir%20shorthand&target=VSCode&category=Programming%20Languages&sortBy=Relevance) that knows FSH syntax and colorizes text accordingly.

It is up to the author to decide how to divide FSH definitions between the FSH files. Here are some possibilities:

* Divide up according to the item type: profiles in one file, value sets in another, extensions in another, etc.
* Group things logically, for example, a profile together with its value sets, extensions, and examples.
* Use one file for each item, and potentially divide similar items into subdirectories.

A **FSH Tank** (2) refers to a directory structure, including subdirectories, that contains a single FSH project.  A FSH Tank represents a complete module that can be placed under source code control. FHIR artifacts defined elsewhere (such as profiles from another IG) are "external" and their IGs must be declared in dependencies.

#### SUSHI

[SUSHI](https://fshschool.org/docs/sushi/) (an acronym for "**S**USHI **U**nshortens **SH**orthand **I**nputs") (4) is a reference implementation of a FSH compiler that translates FSH into FHIR artifacts such as profiles, extensions, and value sets. SUSHI is installed on your own computer and runs locally from the command line. Installing SUSHI is described [here](https://fshschool.org/docs/sushi/installation/).

SUSHI can be used in two modes:

* A [standalone mode](#sushi-standalone-mode) where SUSHI produces FHIR artifacts only.
* A [IG mode](#sushi-ig-mode) where SUSHI works together with the [HL7 FHIR IG Publisher](https://confluence.hl7.org/display/FHIR/IG+Publisher+Documentation). The IG Publisher builds the human-readable web pages and bundles FHIR artifacts produced by SUSHI to produce an Implementation Guide.

#### SUSHI Standalone Mode

In the standalone mode, SUSHI runs independently of the IG Publisher. This is a good option to quickly check for errors when you are creating your FSH code, or if you are only interesting in creating FHIR artifacts without an IG. Creating FHIR artifacts with FSH and SUSHI in standalone mode involves the following steps:

1. Populate a FSH Tank (2) with FSH files (1) containing your FSH definitions.
2. Create a **[config.yaml](https://fshschool.org/docs/sushi/configuration/)** file (3).
3. Run SUSHI (4). After SUSHI runs, a new directory (named **/build** by default) appears in the FSH Tank. This directory contains FHIR artifacts (5) such as profiles, extensions, value sets, and instances.

#### SUSHI IG Mode

Creating an IG with FSH and SUSHI involves the following steps:

1. Create FSH definitions in FSH files (1) in a directory (FSH Tank) named **/fsh** (2).
2. Create a **[config.yaml](https://fshschool.org/docs/sushi/configuration/)** file (3).
3. Provide additional inputs for the IG, including static pages, images, navigation menu configurations (6).
4. Run the IG Publisher (7). The IG Publisher will detect the ./fsh directory (2) and run SUSHI (4) to produce FHIR Artifacts (5) before running the remaining IG publishing steps (8), to produce the IG (9).

For more information on both of these modes of using SUSHI, see [the SUSHI Documentation](https://fshschool.org/docs/sushi/).

### FSH Line-by-Line Walkthrough

In this section, we will walk through a realistic example of FSH, line by line.

```
1   Alias: LNC = http://loinc.org
2   Alias: SCT = http://snomed.info/sct
3
4   Profile:  CancerDiseaseStatus
5   Parent:   Observation
6   Id:       mcode-cancer-disease-status
7   Title:    "Cancer Disease Status"
8   Description: "A clinician's qualitative judgment on the current trend of the cancer, e.g., whether it is stable, worsening (progressing), or improving (responding)."
9   * ^status = #draft
10  * extension contains EvidenceType named evidenceType 0..*
11  * extension[evidenceType].valueCodeableConcept from CancerDiseaseStatusEvidenceTypeVS (required)
12  * status and code and subject and effective[x] and valueCodeableConcept MS
13  * bodySite 0..0
14  * specimen 0..0
15  * device 0..0
16  * referenceRange 0..0
17  * hasMember 0..0
18  * component 0..0
19  * interpretation 0..1
20  * subject 1..1
21  * basedOn only Reference(ServiceRequest or MedicationRequest)
22  * partOf only Reference(MedicationAdministration or MedicationStatement or Procedure)
23  * code = LNC#88040-1
24  * subject only Reference(CancerPatient)
25  * focus only Reference(CancerConditionParent)
26  * performer only Reference(http://hl7.org/fhir/us/core/StructureDefinition/us-core-practitioner)
27  * effective[x] only dateTime or Period
28  * value[x] only CodeableConcept
29  * valueCodeableConcept from ConditionStatusTrendVS (required)
30
31  Extension: EvidenceType
32  Id:  mcode-evidence-type
33  Title: "Evidence Type"
34  Description: "Categorization of the kind of evidence used as input to the clinical judgment."
35  * value[x] only CodeableConcept
36
37  ValueSet:   ConditionStatusTrendVS
38  Id: mcode-condition-status-trend-vs
39  Title: "Condition Status Trend Value Set"
40  Description:  "How patient's given disease, condition, or ability is trending."
41  * SCT#260415000 "Not detected (qualifier)"
42  * SCT#268910001 "Patient condition improved (finding)"
43  * SCT#359746009 "Patient's condition stable (finding)"
44  * SCT#271299001 "Patient's condition worsened (finding)"
45  * SCT#709137006 "Patient condition undetermined (finding)"
46
47  ValueSet: CancerDiseaseStatusEvidenceTypeVS
48  Id: mcode-cancer-disease-status-evidence-type-vs
49  Title: "Cancer Disease Status Evidence Type Value Set"
50  Description:  "The type of evidence backing up the clinical determination of cancer progression."
51  * SCT#363679005 "Imaging (procedure)"
52  * SCT#252416005 "Histopathology test (procedure)"
53  * SCT#711015009 "Assessment of symptom control (procedure)"
54  * SCT#5880005   "Physical examination procedure (procedure)"
55  * SCT#386344002 "Laboratory data interpretation (procedure)"
```

* Lines 1 and 2 define aliases for the LOINC and SNOMED-CT code systems.
* Line 4 declares the intent to create a profile with the name CancerDiseaseStatus. The name is typically title case and according to FHIR, should be "[usable by machine processing applications such as code generation](http://www.hl7.org/fhir/structuredefinition.html#resource)".
* Line 5 says that this profile will be based on Observation.
* Line 6 gives an id for this profile. The id is used to create the globally unique URL for the profile. The URL is composed of the IG’s canonical URL, the instance type (always `StructureDefinition` for profiles), and the profile’s id.
* Line 7 is a human-readable title for the profile.
* Line 8 is the description that will appear in the IG on the profile's page.
* Line 9 is the start of the rule section of the profile. It uses [caret syntax](reference.html#caret-paths) to set the status attribute in the SD produced for this profile.
* Line 10 adds an extension to the profile using the standalone extension, `EvidenceType`, gives it the local name `evidenceType`, and assigns the cardinality 0..*. _EvidenceType is defined on line 31._
* Line 11 binds the valueCodeableConcept of the evidenceType extension to a value set named CancerDiseaseStatusEvidenceTypeVS with a required binding strength. _CancerDiseaseStatusEvidenceTypeVS is defined on line 47._
* Line 12 designates a list of elements (inherited from Observation) as must-support.
* Lines 13 to 20 constrain the cardinality of some inherited elements. FSH does not support setting the cardinality of a multiple items at a time, so these must be separate statements.
* Lines 21 and 22 restrict the choice of resource types for two elements that refer to other resources.
* Line 23 fixes the value of the code attribute to a specific LOINC code, using an alias for the code system defined on line 1.
* Lines 24 to 25 reduce an inherited choice of resource references down to specific profiles.
* Line 26 is similar to lines 24 and 25, but the reference is to an external profile.
* Line 27 and 28 restrict the data type for elements that offer a choice of data types in the base resource.
* Line 29 binds the remaining allowed data type for value[x], valueCodeableConcept, to the value set ConditionStatusTrendVS with a required binding. _ConditionStatusTrendVS is defined on line 37._
* Line 31 declares an extension named EvidenceType.
* Line 32 assigns it an id.
* Line 33 gives the extension a human-readable title.
* Line 34 gives the extension a description that will appear on the extension's main page.
* Line 35 begins the rule section for the extension, and restricts the data type of the value[x] element of the extension to a CodeableConcept.
* Line 37 declares a value set named ConditionStatusTrendVS.
* Line 38 gives the value set an id.
* Line 39 provides a human readable title for the value set.
* Line 40 gives the value set a description that will appear on the value set's main page.
* Lines 41 to 45 define the codes that are members of the value set.
* Lines 47 to 55 create another value set, CancerDiseaseStatusEvidenceTypeVS, similar to the previous one.

A few things to note about this example:

* The order of the items (aliases, profile, value set, extension) doesn't matter. In FSH, you can refer to items defined before or after the current item. By convention, aliases appear at the beginning of a file.
* The example assumes the items are all in one file, but they could be in separate files. The allocation of items to files is the author's choice.
* Most of the rules refer to elements by their FHIR names, but when the rule refers to an element that is not at the top level, more complex paths are required. An example of a complex path occurs on line 10, `extension[evidenceType].valueCodeableConcept`. The Language Reference contains [further descriptions of paths](reference.html#fsh-paths).

### Future Considerations

In this introduction, we presented an overview of FSH. Not all features were covered. A complete accounting of the language is found in the [FSH Language Reference](reference.html).

While this version of FSH has been shown capable of producing complex IGs, future versions may introduce additional features. Feature suggestions are welcome, and can be made [in the HL7 Jira](https://jira.hl7.org/browse/FHIR-27321?jql=project%3D%22FHIR%22%20AND%20Specification%20%3D%20%22Shorthand%20(FHIR)%20%5BFHIR-shorthand%5D%22%20). 

> **Note:** When filing issues, use project="FHIR" AND Specification = "Shorthand (FHIR) [FHIR-shorthand]".

Some of the features for FSH under consideration include (in no particular order):

* **Slicing Support:** Currently, slicing requires the user to specify discriminator type, path, and slicing rules. It is anticipated that a future version of SUSHI will handle most slicing situations without explicit declarations by the user. To enable this, FSH can define logic that can be used to infer slicing discriminators based on the nature of the slices.

* **Multiple Language Support:** At present, FSH supports only one language at a time (it can be any language). In the future, FSH and SUSHI may introduce mechanisms for generating the same IG in multiple languages.

* **Capability Statements (and other conformance resources):** The FSH language supports creation of SDs, and tools like SUSHI address creation of ImplementationGuide resources. However, these are not the only [conformance resources in FHIR](https://www.hl7.org/fhir/R4/conformance-module.html). Others include CapabilityStatement, OperationDefinition, SearchParameter, and CompartmentDefinition. Currently, you can create any of these types as instances; for example, using `InstanceOf: CapabilityStatement`. To make this easier, we provide a [downloadable template](CapabilityStatementTemplate.fsh) for a CapabilityStatement. There may be [other approaches](https://chat.fhir.org/#narrow/stream/215610-shorthand/topic/CapabilityStatement) that could create a CapabilityStatement more directly from requirements. Purpose-specific syntax could also be employed for other conformance resources such as SearchParameter and OperationDefinition.

* **Nested Path Syntax:** While FSH is very good at expressing profiling rules, the current path grammar is cumbersome for populating resources with nested arrays. An example is populating the items in Questionnaires, where each item can contain sub-items. While not suggesting that FSH adopt YAML, it is worth noting that a syntax like YAML is much more concise in this type of situation. Additional syntax is under consideration.

* **Logical Models:** FSH may provide future support for defining data models not derived from a FHIR resource. Logical models are useful for capturing domain objects and relationships early in the development cycle, and can provide traceability from requirements to implementable FHIR artifacts.

* **Resource Definitions:** FSH may provide support for developing new FHIR resources and maintaining existing ones, to help HL7 Work Groups more effectively manage their contributions to FHIR core.

There are also opportunities for tooling related to FSH. This overview also touched on one of those tools, SUSHI. A complete description of SUSHI is found in the [SUSHI Users Guide](sushi.html). Some tooling ideas include:

* **Web-Based FSH:** A web-based deployment of a FSH interpreter would allow an interactive experience with FSH and SUSHI.

* **Importing SDs to FSH:** Currently there is no mature tool to translate existing FHIR artifacts such as SDs into FSH. It should be possible to round-trip between SDs in JSON or XML and FSH. There are two tools under development that convert SDs to FSH, [FSH Food](https://github.com/lantanagroup/fshfood) and GoFSH.


SUSHI issues and suggestions can be made [here](https://github.com/FHIR/sushi/issues). 