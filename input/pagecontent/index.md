This implementation guide includes the following chapters:

1. [FHIR Shorthand Overview](index.html) (this chapter) -- Introduction to FSH and SUSHI _(informative content)_.
1. [FHIR Shorthand Tutorial](tutorial.html) -- A step-by-step hands-on introduction to producing an Implementation Guide (IG) with FHIR Shorthand and SUSHI _(informative content)_.
1. [FHIR Shorthand Language Reference](reference.html) -- The syntax and usage of the FHIR Shorthand language _(normative content)_.
1. [SUSHI User Guide](sushi.html) -- A guide to producing an IG from FSH files using SUSHI compiler and the HL7 IG Publishing tool _(informative content)_.

In addition, the IG includes several downloads, including a [Quick Reference Sheet](FSHQuickReference.pdf) and [zip file](fsh-tutorial-master.zip) for the FSH Tutorial _(informative content)_.

This IG uses the following conventions:

| Style | Explanation | Example |
|:----------|:------|:---------|
| `Code` | Code fragments, such as commands, FSH statements, and syntax expressions  | `* status = #open` |
| {curly braces} | An item to be substituted in a syntax pattern | `{codesystem}#{code}` |
| **bold** | A directory path or file name | **example-1.fsh** |
{: .grid }


### Introduction

FHIR Shorthand (FSH) is a domain-specific language for defining the contents of FHIR Implementation Guides (IG). The language is specifically designed for this purpose, simple and compact, and allows the author to express their intent with fewer concerns about underlying FHIR mechanics. FSH can be created and updated using any text editor, and because it is text, it enables distributed, team-based development using source code control tools such as GitHub.

<img src="FHIR-Shorthand-Logo.png" alt="FHIR Shorthand Logo" width="300px" style="float:none; margin: 0px 0px 0px 0px;" />

#### Motivations for FHIR Shorthand

FSH was created in response to the need in the FHIR community for scalable, fast, user-friendly tools for IG creation and maintenance. Experience has shown that profiling projects can be difficult and slow, and the resulting IG quality inconsistent. Profiling projects often go through many iterations. As such, an agile approach to refactoring and revision is invaluable.

<img src="IG-Need-For-Agility.png" alt="IG Need for Agility" width="800px" style="float:none; margin: 0px 0px 0px 0px;" />

There are already several existing methods for IG creation: hand editing, using [Excel spreadsheets](https://confluence.hl7.org/display/FHIR/FHIR+Spreadsheet+Profile+Authoring), [Simplifier/Forge](https://fire.ly/products/simplifier-net/), and [Trifolia-on-FHIR](https://trifolia-fhir.lantanagroup.com). Each of these methods have certain advantages as well as drawbacks:

1. Hand-editing StructureDefinitions (SDs) is unwieldy, but authors get full control over every aspect of the resulting profiles and extensions.
1. The spreadsheet method has existed since before FHIR 1.0 and has been used to produce sophisticated IGs such as [US Core](https://github.com/HL7/US-Core-R4). A significant downside is that version management is difficult; either the files are saved in binary form (.xslx) or as XML files, with the content mixed with thousands of lines of formatting directives.
1. Simplifier/Forge and Trifolia-on-FHIR provide graphical user interfaces that are very helpful guiding users through common tasks. However, making significant cross-cutting changes ([refactoring](https://resources.collab.net/agile-101/code-refactoring)) requires navigating through many screens. Currently these tools do not have advanced source code control features.

Experience across many domains has shown that complex software projects are best approached with textual languages. As a language designed for the job of profiling and IG creation, FSH is concise, understandable, and aligned to user intentions. Users may find that the FSH language representation is the best way to understand a set of profiles. Because it is text-based, FSH brings a degree of editing agility not found in graphical tools (cutting and pasting, global search and replace, spell checking, etc.) FSH is ideal for distributed development under source code control, providing meaningful version-to-version differentials, support for merging and conflict resolution, and nimble refactoring. These features allow FSH to scale in ways that other approaches cannot. Any text editor can be used to create or modify FSH, but advanced text editor plugins may also be used to further aid authoring.

### FHIR Shorthand Language Overview

The complete FSH language is described in the [FHIR Shorthand Language Reference](reference.html). Here we present just enough to get a taste of FSH.

#### Basics

* **Grammar**: [FSH has a formal grammar](reference.html#formal-grammar) defined in [ANTLR4](https://www.antlr.org/).
* **Data types**: The primitive and complex data types and value formats in FSH are identical to the [primitive types and value formats in FHIR](https://www.hl7.org/fhir/datatypes.html#primitive).
* **Whitespace**: Repeated whitespace characters are equivalent to one whitespace character within FSH files, unless they are part of string literals. New lines are considered whitespace.
* **Comments**: FSH uses `//` as leading delimiter for single-line comments, and the pair `/*`  `*/` to delimit multiple line comments.
* **Hash Sign**: A leading hash sign (#) (variously called the number sign, pound sign, or octothorp) is used in FSH to denote a code from a formal terminology.
* **Asterisk Character**: A leading asterisk is used to denote FSH rules. For example, here is a rule to set Organization.active to `true`:

  ```
  * active = true
  ```

* **Escape Character**: FSH uses the backslash as the escape character in string literals. For example, use `\"` to embed a quotation mark in a string.
* **Caret Character**: FSH uses the caret (also called circumflex) `^` to directly reference the definitional structure associated with an item. When defining a profile, caret syntax allows you to refer to elements in the StructureDefinition. For example, to set the element StructureDefinition.experimental from the FSH code that defines a profile:

  ```
  * ^experimental = false
  ```

* **Aliases**: To improve readability, FSH allows the user to define aliases for URLs and oids. Once defined anywhere in the FSH tank, the alias can be used anywhere the url or oid can be used. For example:

  ```
  Alias: SCT = http://snomed.info/sct
  ```

#### Coded Data Types

FSH provides special grammar for expressing coded data types. The shorthand for a Coding is:

```
{system}#{code} "{display text}"
```

For a FHIR `code` data type, the {system} is omitted. The display text is optional but helps with readability. The `{system}` represents the controlled terminology that the code is taken from. Here are a few examples:

* The code 363346000 from SNOMED-CT:

  ```
  http://snomed.info/sct#363346000 "Malignant neoplastic disease (disorder)"
  ```

* The same code, using the Snomed-CT alias defined above:

  ```
  SCT#363346000 "Malignant neoplastic disease (disorder)"
  ```

The coded value grammar can be used when assigning a value to an element whose data type is code, Coding, CodeableConcept, or Quantity. FSH uses the `=` sign to express assignment:

* To set the first Coding in a CodeableConcept:

  ```
  * bodySite = SCT#87878005 "Left cardiac ventricular structure"
  ```

* To set the text of a CodeableConcept:

  ```
  * bodySite.text = "Left ventricle"
  ```

Quantity is another case of a coded data type. The code is interpreted as the units of measure of the quantity:

```
Alias: UCUM = http://unitsofmeasure.org
...

* valueQuantity = UCUM#mm "millimeters"
```

#### Defining New Items

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

Keywords that declare new items (like the `Profile` keyword in the previous example) must occur first in any set of keywords. There are nine declarative keywords in FSH:

* Alias
* CodeSystem
* Extension
* Instance
* Invariant
* Mapping
* Profile
* RuleSet
* ValueSet

Note that not every type of FSH item has a direct FHIR equivalent. Alias and RuleSet are strictly FSH constructs, while Mappings and Invariants appear only as elements within a StructureDefinition.

Each type of item has a different set of required and optional keywords, detailed in the [FSH Language Reference](reference.html#defining-items).

> **Note:** Keywords are case-sensitive.

#### Rules

The keyword section is followed by a number of rules. Rules are the mechanism for constraining a profile, defining an extension, creating slices, and more. All FSH rules begin with an asterisk:

```
* {rule statement}
```

There are approximately a dozen types of rules in FSH. The [formal syntax of rules](reference.html#rules) are given in the [FSH Language reference](reference.html). Here is a summary:

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

* **Binding rules** are used on elements with coded values to specify the set of enumerated values for that element. Binding rules include [one of FHIR's binding strengths](http://hl7.org/fhir/valueset-binding-strength.html) (example, preferred, extensible, or required). For example:

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

* **Flag rules** add bits of information about elements impacting how implementers should handle them. The flags are as [defined FHIR](http://hl7.org/fhir/R4/formats.html#table), except FSH uses `MS` for must-support and `SU` for summary. For example:

  ```
  * communication MS SU
  ```

  ```
  * identifier and identifier.system and identifier.value and name and name.family MS
  ```

* **Type rules** restrict the type of value that can be used in an element. For example:

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

* **Contains rules, for extensions** specify elements populating extensions arrays. Extensions can either be defined inline or standalone. Inline extensions do not have a separate StructureDefinition, but standalone extensions do. Standalone extensions include those defined by other IGs or extensions defined in the same FSH tank, using the `Extension` keyword.

  Here are two examples of defining inline extensions, the first with a single extension, the second with multiple extensions.

  ```
  * bodySite.extension contains laterality 0..1
  ```

  ```
  * extension contains
      treatmentIntent 0..1 MS and
      terminationReason 0..* MS
  ```

  Typically, after defining an inline extension, rules constraining the extension are required. In the first example, we can restrict the data type of value[x] and bind a value set:

  ```
  * bodySite.extension[laterality].value[x] only CodeableConcept
  * bodySite.extension[laterality].valueCodeableConcept from LateralityVS (required)
  ```

  With standalone extensions, the main difference is that the grammar includes both the standalone name and the assigned local name. In this example, local names begin with a lower case letter, and standalone and external extension have capitalized (alias) names. This is a helpful convention, not part of the specification.

  ```
  // Aliases for convenience
  Alias: USCoreRace = http://hl7.org/fhir/us/core/StructureDefinition/us-core-race
  Alias: USCoreEthnicity = http://hl7.org/fhir/us/core/StructureDefinition/us-core-ethnicity
  Alias: USCoreBirthsex = http://hl7.org/fhir/us/core/StructureDefinition/us-core-birthsex

  // Within a profile definition, include the external extensions with local names
  * extension contains
      USCoreRace named race 0..1 MS and
      USCoreEthnicity named ethnicity 0..1 MS and
      USCoreBirthsex named birthsex 0..1 MS
  ```

* **Contains rules, for slicing** specify the types of elements an array element can contain. Slicing requires setting of at least three parameters before the slice can be defined: the discriminator type and path, and slicing rules. [Caret syntax](reference.html#structuredefinition-escape-paths) is used to set these parameters directly in the StructureDefinition. Here is a typical "slicing rubric" for slicing Observation.component:

  ```
  * component ^slicing.discriminator.type = #pattern
  * component ^slicing.discriminator.path = "code"
  * component ^slicing.rules = #open
  * component ^slicing.ordered = false   // can be omitted, since false is the default
  * component ^slicing.description = "Slice based on the component.code pattern"  // optional
  ```
  Once the slicing rules have been established, the slice is created using the similar syntax as with extensions:

  ```
  * component contains
      SystolicBP 1..1 and
      DiastolicBP 1..1
  ```
  The elements of each slice must be constrained such that they can be uniquely identified via the discriminator. Other constraints may also be applied. Using the example above, each `component.code` should be constrained to satisfy the discriminator, and the values may also be constrained to indicate the type of value that is expected:

  ```
  * component[SystolicBP].code = http://loinc.org#8480-6 // Systolic blood pressure
  * component[SystolicBP].value[x] only Quantity
  * component[SystolicBP].valueQuantity = UCUM#mm[Hg]
  * component[DiastolicBP].code = http://loinc.org#8462-4 // Diastolic blood pressure
  * component[DiastolicBP].value[x] only Quantity
  * component[DiastolicBP].valueQuantity = UCUM#mm[Hg]
  ```

* **Obeys rules** associate elements with XPath or FHIRPath constraints they must obey. For example:

  ```
  * obeys us-core-9  // invariant applies to entire profile
  ```  

  ```
  * name obeys us-core-8  // invariant applies to the name element
  ```

* **Value set rules** are used to include or exclude codes in value sets. These rules can be defined two ways:

  [Extensional](https://blog.healthlanguage.com/the-difference-between-intensional-and-extensional-value-sets) rules explicitly list the codes to be included and/or excluded, for example:

  ```
  * SCT#54102005 "G1 grade (finding)"
  ```

  ```
  * exclude SCT#12619005
  ```

  Because including codes is much more common than excluding codes, inclusion is implicit and exclusion is explicit in the rule grammar.

  [Intensional](https://blog.healthlanguage.com/the-difference-between-intensional-and-extensional-value-sets) rules are used when code membership in the value set is defined algorithmically, rather than listed explicitly. For example, to include all codes from a code system:

  ```
  * codes from system RXNORM
  ```

  Similar rules can include or exclude all codes from another value set:

  ```
  * codes from valueset ConditionStatusTrendVS
  ```

  ```
  * exclude codes from valueset ConditionStatusTrendVS
  ```

  More complex intensional rules involving filters are also possible. These rules depend on relationships or properties defined in a specific code system. A rule for LOINC, for example, would not be applicable to SNOMED-CT. Here is an example of a SNOMED-CT intensional rule with a filter:

  ```
  * codes from system SCT where concept is-a #123037004 "BodyStructure"
  ```

### FSH in Practice

This section presents an overview of how the FSH language is put into practice. The descriptions in this section refer to the numbers in the following figure:

<img src="Workflow.png" alt="Overall FSH Workflow" width="800px" style="float:none; margin: 0px 0px 0px 0px;" />

#### FSH Files and FSH Tanks

Content written in FSH is stored in plain text files (ASCII or UTF-8) with `.fsh` extensions (1). Profiles, extensions, value sets, code systems, examples, and other FHIR artifacts are defined in FSH files.

Any text editor can be used to create a FSH file. [Visual Studio Code](https://code.visualstudio.com/) has a useful [FSH plug-in](https://marketplace.visualstudio.com/items?itemName=kmahalingam.vscode-language-fsh) that knows FSH syntax and colorizes text accordingly.

It is up to the author to decide how to divide FSH definitions between the FSH files. Here are some possibilities:

* Divide up according to the item type: profiles in one file, value sets in another, extensions in another, etc.
* Group things logically, for example, a profile together with its value sets, extensions, and examples.
* Use one file for each item, and potentially divide similar items into subdirectories.

A **FSH Tank** (2) refers to a directory structure, including subdirectories, that contains FSH files.  A FSH Tank represents a complete module that can be placed under source code control. FHIR artifacts defined elsewhere (such as profiles from another IG) are "external" and their IGs must be declared in dependencies.

#### SUSHI

[SUSHI](sushi.html) (an acronym for "**S**USHI **U**nshortens **SH**orthand **I**nputs") (4) is a reference implementation of a FSH compiler that translates FSH into FHIR artifacts such as profiles, extensions, and value sets. SUSHI is installed on your own computer and runs locally from the command line. Installing SUSHI is described [here](sushi.html#installation).

SUSHI can be used in two modes:

* A [standalone mode](#sushi-standalone-mode) where SUSHI produces FHIR artifacts only.
* A [IG mode](#sushi-ig-mode) where SUSHI works together with the [HL7 FHIR IG Publisher](https://confluence.hl7.org/display/FHIR/IG+Publisher+Documentation). The IG Publisher builds the human-readable web pages and bundles FHIR artifacts produced by SUSHI to produce an Implementation Guide.

#### SUSHI standalone Mode

In the standalone mode, SUSHI runs independently of the IG Publisher. This is a good option to quickly check for errors when you are creating your FSH code, or if you are only interesting in creating FHIR artifacts without an IG. Creating FHIR artifacts with FSH and SUSHI in standalone mode involves the following steps:

1. Populate a FSH Tank (2) with FSH files (1) containing your FSH definitions.
2. Create a **[package.json](https://confluence.hl7.org/pages/viewpage.action?pageId=35718629#NPMPackageSpecification-Packagemanifest)** file (3).
3. Run SUSHI (4). After SUSHI runs, a new directory (named **/build** by default) appears in the FSH Tank. This directory contains FHIR artifacts (5) such as profiles, extensions, value sets, and instances.

#### SUSHI IG Mode

Creating an IG with FSH and SUSHI involves the following steps:

1. Create FSH definitions in FSH files (1) in a directory (FSH Tank) named **/fsh** (2).
2. Create configuration information (3) for SUSHI and the IG publisher (at minimum, **[package.json](https://confluence.hl7.org/pages/viewpage.action?pageId=35718629#NPMPackageSpecification-Packagemanifest)** file)
3. Provide additional inputs for the IG, including static pages, images, navigation menu configurations (6).
4. Run the IG Publisher (7). The IG Publisher will detect the ./fsh directory (2) and run SUSHI (4) to produce FHIR Artifacts (5) before running the remaining IG publishing steps (8), to produce the IG (9).

For more information on both of these modes of using SUSHI, see [the SUSHI Users Guide](sushi.html).

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

30  Extension: EvidenceType
31  Title: "Evidence Type"
32  Id:  mcode-evidence-type
33  Description: "Categorization of the kind of evidence used as input to the clinical judgment."
34  * value[x] only CodeableConcept

35  ValueSet:   ConditionStatusTrendVS
36  Id: mcode-condition-status-trend-vs
37  Title: "Condition Status Trend Value Set"
38  Description:  "How patient's given disease, condition, or ability is trending."
39  * SCT#260415000 "Not detected (qualifier)"
40  * SCT#268910001 "Patient condition improved (finding)"
41  * SCT#359746009 "Patient's condition stable (finding)"
42  * SCT#271299001 "Patient's condition worsened (finding)"
43  * SCT#709137006 "Patient condition undetermined (finding)"

44  ValueSet: CancerDiseaseStatusEvidenceTypeVS
45  Id: mcode-cancer-disease-status-evidence-type-vs
46  Title: "Cancer Disease Status Evidence Type Value Set"
47  Description:  "The type of evidence backing up the clinical determination of cancer progression."
48  * SCT#363679005 "Imaging (procedure)"
49  * SCT#252416005 "Histopathology test (procedure)"
50  * SCT#711015009 "Assessment of symptom control (procedure)"
51  * SCT#5880005   "Physical examination procedure (procedure)"
52  * SCT#386344002 "Laboratory data interpretation (procedure)"
```
* Lines 1 and 2 defines aliases for the LOINC and SNOMED-CT code systems.
* Line 4 declares the intent to create a profile with the name CancerDiseaseStatus. The name is typically title case and according to FHIR, should be "[usable by machine processing applications such as code generation](http://www.hl7.org/fhir/structuredefinition.html#resource)".
* Line 5 says that this profile will be based on Observation.
* Line 6 gives an id for this profile. The id is used to create the globally unique URL for the profile. The URL is composed of the IG’s canonical URL, the instance type (always `StructureDefinition` for profiles), and the profile’s id.
* Line 7 is a human-readable title for the profile.
* Line 8 is the description that will appear in the IG on the profile's page.
* Line 9 is the start of the rule section of the profile. It uses [caret syntax](reference.html#structuredefinition-escape-paths) to set the status attribute in the StructureDefinition produced for this profile.
* Line 10 adds an extension to the profile using the standalone extension, `EvidenceType`, gives it the local name `evidenceType`, and assigns the cardinality 0..*. _EvidenceType is defined on line 30._
* Line 11 binds the valueCodeableConcept of the evidenceType extension to a value set named CancerDiseaseStatusEvidenceTypeVS with a required binding strength. _CancerDiseaseStatusEvidenceTypeVS is defined on line 46._
* Line 12 designates a list of elements (inherited from Observation) as must-support.
* Lines 13 to 20 constrain the cardinality of some inherited elements. FSH does not support setting the cardinality of a multiple items at a time, so these must be separate statements.
* Lines 21 and 22 restrict the choice of resource types for two elements that refer to other resources.
* Line 23 fixes the value of the code attribute to a specific LOINC code, using an alias for the code system defined on line 1.
* Lines 24 to 26 reduce an inherited choice of resource references down to a single resource or profile type. Note that the references can be to external profiles (us-core-practitioner) or to profiles (not shown in the example) defined in the same FSH tank (CancerPatient, CancerConditionParent). Also note that an alias could have been used in place of the us-core-practitioner URL.
* Line 27 and 28 restrict the data type for elements that offer a choice of data types in the base resource.
* Line 29 binds the remaining allowed data type for value[x], valueCodeableConcept, to the value set ConditionStatusTrendVS with a required binding. _ConditionStatusTrendVS is defined on line 36._
* Line 30 declares an extension named EvidenceType.
* Line 31 gives the extension a human-readable title.
* Line 32 assigns it an id.
* Line 33 gives the extension a description that will appear on the extension's main page.
* Line 34 begins the rule section for the extension, and restricts the data type of the value[x] element of the extension to a CodeableConcept.
* Line 35 declares a value set named ConditionStatusTrendVS.
* Line 36 gives the value set an id.
* Line 37 provides a human readable title for the value set.
* Line 38 gives the value set a description that will appear on the value set's main page.
* Lines 39 to 43 define the codes that are members of the value set
* Lines 44 to 52 create another value set, CancerDiseaseStatusEvidenceTypeVS, similar to the previous one.

A few things to note about this example:

* The order of the items (aliases, profile, value set, extension) doesn't matter. In FSH, you can refer to items defined before or after the current item. By convention, aliases appear at the beginning of a file.
* The example assumes the items are all in one file, but they could be in separate files. The allocation of items to files is the author's choice.
* Most of the rules refer to elements by their FHIR names, but when the rule refers to an element that is not at the top level, more complex paths are required. An example of a complex path occurs on line 10, `extension[evidenceType].valueCodeableConcept`. The Language Reference contains [further descriptions of paths](reference.html#paths).

### Future Considerations

In this introduction, we presented an overview of FSH and SUSHI. Not all features were covered. A complete accounting of the language is found in the [FSH Language Reference](reference.html). A complete description of SUSHI is found in the [SUSHI Users Guide](sushi.html).

While this version of FSH and SUSHI are capable of producing sophisticated IGs, future versions may introduce additional features. Feature suggestions are welcome, and can be made [here](https://github.com/FHIR/sushi/issues).

Some of the features for FSH and SUSHI under consideration include (in no particular order):

* **Round-Tripping** Currently there is no mature tool to translate existing FHIR artifacts into FSH. There is also a tool under development, [FSH Food](https://github.com/lantanagroup/fshfood), that converts StructureDefinitions into FSH.

* **Web-Based SUSHI** The underlying architecture of SUSHI is compatible with future server-based deployment, potentially providing an interactive experience with FSH and SUSHI.

* **Slicing Support:** Currently, slicing requires the user to specify discriminator type, path, and slicing rules. It is anticipated that a future version of SUSHI will handle most slicing situations without explicit declarations by the user. To enable this, FSH will specify a set of algorithms that can be used to infer slicing discriminators based on the nature of the slices. We have nicknamed this “Ginsu Slicing” for the amazing 1980’s TV knife that slices through anything.

* **Multiple Language Support:** At present, FSH supports only one language at a time (it can be any language). In the future, FSH and SUSHI may introduce mechanisms for generating the same IG in multiple languages.

* **Capability Statements:** Currently, you can create a CapabilityStatement as an instance in FSH using `InstanceOf: CapabilityStatement`, but FSH does nothing to help populate that instance. There may be [other approaches](https://chat.fhir.org/#narrow/stream/215610-shorthand/topic/CapabilityStatement) that create CapabilityStatements more directly from requirements. Purpose-specific syntax could also be employed for other conformance resources such as SearchParameter and OperationDefinition.

* **Nested Path Syntax:** While FSH is very good at expressing profiling rules, the current path grammar is cumbersome for populating resources with nested arrays. An example is populating the items in Questionnaires, where each item can contain sub-items. While not suggesting that FSH adopt YAML, it is worth noting that a syntax like YAML is much more concise in this type of situation. Additional syntax is under consideration.

* **Logical Models:** FSH may provide future support for defining data models not derived from a FHIR resource. Logical models are useful for capturing domain objects and relationships early in the development cycle, and can provide traceability from requirements to implementable FHIR artifacts.

* **Resource Definitions:** FSH may provide support for developing new FHIR resources and maintaining existing ones, to help HL7 Work Groups more effectively manage their contributions to FHIR core.
