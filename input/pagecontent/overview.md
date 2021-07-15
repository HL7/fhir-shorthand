<br/>
<span style="background-color: yellow; font-size:1.6em;">NOTE: Information on this page is [informative content](https://www.hl7.org/fhir/versions.html#std-process).</span>
<br/>

FHIR Shorthand (FSH) is a domain-specific language for defining the contents of FHIR Implementation Guides (IG). The language is specifically designed for this purpose, simple and compact, and allows the author to express their intent with fewer concerns about underlying FHIR mechanics. FSH can be created and updated using any text editor, and because it is text, it enables distributed, team-based development using source code control tools such as GitHub.

### FHIR Shorthand Language

The complete FSH language is formally described in the [FHIR Shorthand Language Reference](reference.html). Here we present just enough to get a taste of FSH.

#### Basics

* **Grammar**: [FSH has a formal grammar](reference.html#appendix-formal-grammar) defined in [ANTLR4](https://www.antlr.org/).
* **Data types**: The primitive and complex data types and value formats in FSH are identical to the [primitive types and value formats in FHIR R4](http://hl7.org/fhir/R4/datatypes.html#primitive), and also include <span style="background-color: #fff5e6;">{%include tu.html%} datatypes proposed for inclusion in FHIR R5 ([integer64](https://build.fhir.org/datatypes.html#primitive) and [CodeableReference](https://build.fhir.org/references.html#codeablereference))</span>.
* **Whitespace**: Repeated whitespace has meaning within FSH files only within string literals and when used for <span style="background-color: #fff5e6;">{%include tu.html%} [indenting rules](reference.html#indented-rules)</span>. In all other contexts, repeated whitespace is not meaningful.
* **Comments**: FSH uses `//` as leading delimiter for single-line comments, and the pair `/*`  `*/` to delimit multiple line comments.
* **Asterisk Character**: A leading asterisk is used to denote FSH rules. For example, here is a rule to set an element named `active` to `true`:

  ```
  * active = true
  ```

* **Escape Character**: FSH uses the backslash as the escape character in string literals. For example, use `\"` to embed a quotation mark in a string.
* **Caret Character**: FSH uses [caret syntax](reference.html#caret-paths) to directly reference the definitional structure associated with an item. When defining a profile, the caret character `^` (also called circumflex) allows you to refer to elements in the SD. For example, to set the element StructureDefinition.experimental:

  ```
  * ^experimental = false
  ```

* **Aliases**: To improve readability, FSH allows the user to define aliases for URLs and object identifiers (OIDs). Once defined anywhere in a FSH project, the alias can be used anywhere the URL or OID can be used. By convention, aliases often begin with $ character, for example:

  ```
  Alias: $SCT = http://snomed.info/sct
  ```

* **Coded Data Types**: A leading hash sign (#) (*aka* number sign, pound sign, or octothorp) is used in FSH to denote a code taken from a formal terminology. FSH provides special grammar for expressing FHIR's coded data types (code, Coding, and CodeableConcept) that combines the code system, code, and (optionally) a display text. Here is a SNOMED-CT code in this syntax, using the previously-defined alias:

  ```
  $SCT#363346000 "Malignant neoplastic disease (disorder)"
  ```

#### Defining Items in FSH

Keywords are used to make declarations that introduce new items. Here is an example using the `Profile` declaration, with keywords that define the parent profile, identifier, and other properties:

```
Profile:  CancerDiseaseStatus
Parent:   Observation
Id:       mcode-cancer-disease-status
Title:    "Cancer Disease Status"
Description: "A clinician's qualitative judgment on the current trend of the cancer, e.g., whether it is stable, worsening (progressing), or improving (responding)."
```

Keywords that declare new items (like the `Profile` keyword in the previous example) must occur first in any set of keywords. There are [eleven declarative keywords in FSH](reference.html#fsh-items):

* Alias
* CodeSystem
* Extension
* Instance
* Invariant
* <span style="background-color: #fff5e6;">{%include tu.html%} Logical</span>
* Mapping
* Profile
* <span style="background-color: #fff5e6;">{%include tu.html%} Resource</span>
* RuleSet
* ValueSet

Note that not every type of FSH item has a direct FHIR equivalent; Alias and RuleSet are strictly FSH constructs, while Mappings and Invariants appear only as elements within a SD. Each type of item has a different set of required and optional keywords, detailed in the [FSH Language Reference](reference.html#fsh-items).

These are not the only [conformance resources in FHIR](https://www.hl7.org/fhir/R4/conformance-module.html). Others include CapabilityStatement, OperationDefinition, SearchParameter, and CompartmentDefinition. Currently, you can create any of these types as instances; for example, using `InstanceOf: CapabilityStatement`. RuleSets can simplify definition of these items. For examples of rule sets, see [FSH Online](https://fshschool.org/FSHOnline).

#### Rules

The keyword section is followed by a number of rules. Rules are the mechanism for constraining a profile, defining an extension, creating slices, and more. All FSH rules begin with an asterisk. Here is a non-exhaustive summary of some of the more important rules in FSH:

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

  ```
  * valueQuantity = UCUM#mm "millimeters"
  ```

* **Binding rules** are used on elements with coded values to specify the set of enumerated values for that element. Binding rules include [one of FHIR R4's binding strengths](http://hl7.org/fhir/R4/valueset-binding-strength.html): example, preferred, extensible, or required. For example:

  ```
  * gender from http://hl7.org/fhir/ValueSet/administrative-gender (required)
  ```

  ```
  * address.state from USPSTwoLetterAlphabeticCodes (extensible)  // USPSTwoLetterAlphabeticCodes is a value set defined in US Core
  ```

* **Cardinality rules** constrain the number of occurrences of an element, either both upper and lower bounds, or just upper or lower bound. For example:

  ```
  * note 1..1
  ```

  ```
  * note 1..
  ```

  ```
  * note ..1
  ```

* **Contains rules** are used for slicing and extensions. Both cases involve specifying the type of elements that can appear in arrays.

  The following rule slices Observation.component into the two components of blood pressure:

  ```
  * component contains systolicBP 1..1 and diastolicBP 1..1
  ```

  The syntax for extensions is similar, except a modified syntax that assigns local name to the extension is typically must be used:

  ```
  // Adding standard FHIR extensions in an AllergyIntolerance profile:

  * extension contains
      allergyintolerance-certainty named substanceCertainty 0..1 and
      allergyintolerance-resolutionAge named resolutionAge 0..1
  ```

* **Flag rules** add bits of information about elements impacting how implementers should handle them. The flags are those [defined in FHIR](http://hl7.org/fhir/R4/formats.html#table), except FSH uses `MS` for must-support and `SU` for summary. For example:

  ```
  * communication MS SU
  ```

  ```
  * identifier and identifier.system and identifier.value MS
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

* **Value set rules** are used to populate value sets. These rules can be defined two ways:

  [Extensional](https://blog.healthlanguage.com/the-difference-between-intensional-and-extensional-value-sets) rules list individual codes to be included and/or excluded, for example:

  ```
  * include $SCT#54102005 "G1 grade (finding)"
  ```

  ```
  * exclude $SCT#12619005 "Tumor grade GX"
  ```

  [Intensional](https://blog.healthlanguage.com/the-difference-between-intensional-and-extensional-value-sets) rules define the value set contents indirectly, for example:

  ```
  * include codes from system http://www.nlm.nih.gov/research/umls/rxnorm
  ```

  ```
  * include codes from valueset ConditionStatusTrendVS
  ```

  ```
  * include codes from system $SCT where concept is-a #123037004 "BodyStructure"
  ```

  ```
  * exclude codes from valueset EndStageRenalDiseaseVS
  ```

### Line-by-Line Walkthrough

In this section, we will walk through a realistic example of FSH, line by line. This example does not show all the features of the FSH language.

```
1   Alias: $LNC = http://loinc.org
2   Alias: $SCT = http://snomed.info/sct
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
23  * code = $LNC#88040-1
24  * subject only Reference(CancerPatient)
25  * focus only Reference(CancerCondition)
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
41  * $SCT#260415000 "Not detected (qualifier)"
42  * $SCT#268910001 "Patient condition improved (finding)"
43  * $SCT#359746009 "Patient's condition stable (finding)"
44  * $SCT#271299001 "Patient's condition worsened (finding)"
45  * $SCT#709137006 "Patient condition undetermined (finding)"
46
47  ValueSet: CancerDiseaseStatusEvidenceTypeVS
48  Id: mcode-cancer-disease-status-evidence-type-vs
49  Title: "Cancer Disease Status Evidence Type Value Set"
50  Description:  "The type of evidence backing up the clinical determination of cancer progression."
51  * $SCT#363679005 "Imaging (procedure)"
52  * $SCT#252416005 "Histopathology test (procedure)"
53  * $SCT#711015009 "Assessment of symptom control (procedure)"
54  * $SCT#5880005   "Physical examination procedure (procedure)"
55  * $SCT#386344002 "Laboratory data interpretation (procedure)"
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
* Lines 24 to 25 reduce an inherited choice of resource references down to instances that conform specific profiles (which must be defined, but are external to this example)
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
* The example assumes the items are all in one file, but they could be in separate files. The allocation of items to files is the author's choice. Aliases defined in one file can be used in other files.
* Most of the rules refer to elements by their FHIR names, but when the rule refers to an element that is not at the top level, more complex paths are required. An example of a complex path occurs on line 10, `extension[evidenceType].valueCodeableConcept`. The Language Reference contains [further descriptions of paths](reference.html#fsh-paths).

### FSH in Practice

This section presents an overview of how the FSH language is put into practice using [SUSHI](https://fshschool.org). [SUSHI](https://fshschool.org/docs/sushi/) (an acronym for "**S**USHI **U**nshortens **SH**orthand **I**nputs") is a reference implementation of a FSH compiler that translates FSH into FHIR artifacts such as profiles, extensions, and value sets.

The discussion in this section refers to the numbers in the following figure:

<img src="Workflow.png" alt="Overall FSH Workflow" width="800px" style="float:none; margin: 0px 0px 0px 0px;" />

#### Install SUSHI

The process for installing SUSHI is described [here](https://fshschool.org/docs/sushi/installation/). A text editor is also needed. [Visual Studio Code](https://code.visualstudio.com/) has a useful [FSH plug-in](https://bit.ly/3fUsIk7) that knows FSH syntax and colorizes text accordingly.

#### Create a New Project

To set up a directory structure for your IG, run `sushi -i` at a command prompt. This will create the [specific project structure](https://fshschool.org/docs/sushi/project/) required by the IG Publisher. 

#### Author FSH Files

Content written in FSH is stored in plain text files (ASCII or UTF-8) with the `.fsh` extension (1). Any text editor can be used to create a FSH file. SUSHI lets the author decide how to allocate FSH definitions to **.fsh** files. Here are some possibilities:

* One file per item
* All profile definitions in one file, all value set definitions in another, all extensions in another, etc.
* Group related items in one file, e.g., a profile together with its value sets, extensions, and examples
* Create subdirectories for each type of item (profiles, extensions, value sets), with separate files for each item of the corresponding type inside those subdirectories.

#### Run SUSHI and/or HL7 IG Publisher

Before running SUSHI, you must have a [configuration file named **sushi-config.yaml**](https://fshschool.org/docs/sushi/configuration/) (2) containing some basic information about the project, such as its canonical URL.

When SUSHI runs (3), it gathers all FSH files from the given input directory's **input/fsh** subdirectory (1), and writes generated FHIR JSON artifacts to a given output directory (4). The input and output directories appear as SUSHI command line arguments. If unspecified, the input directory will default to the current directory, and outputs will be written to **./fsh-generated**.

SUSHI can be run from the command line or invoked as part of the [HL7 FHIR IG Publisher](https://confluence.hl7.org/display/FHIR/IG+Publisher+Documentation) (6). The latter requires some additional configuration information and other IG data (5). If there are no FSH files in the project's **[root]/input/fsh** folder(1), the IG Publisher will not run SUSHI. The generated SUSHI output is found in the **[root]/fsh-generated** directory (4), and the implementation guide itself (7) is located in **[root]/output/fsh**.

For more information on the use of SUSHI and the IG Publisher, see [the SUSHI Documentation](https://fshschool.org/docs/sushi/).


**[Continue to FSH Language Specification ->](reference.html)**
