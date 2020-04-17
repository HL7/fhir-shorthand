This implementation guide includes the following chapters:

1. [FHIR Shorthand Overview](index.html) (this chapter) -- Introduction to FSH and SUSHI _(informative content)_.
1. [FHIR Shorthand Tutorial](tutorial.html) -- A step-by-step hands-on introduction to producing an IG with FHIR Shorthand and SUSHI _(informative content)_.
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

FHIR Shorthand (FSH) is a domain-specific language (DSL) for defining the contents of FHIR Implementation Guides (IG). The language is specifically designed for this purpose, simple and compact, and allows the author to express their intent with fewer concerns about underlying FHIR mechanics. FSH can be created and updated using any text editor, and because it is text, it enables distributed, team-based development using source code control tools such as Github.

<img src="FHIR-Shorthand-Logo.png" alt="FHIR Shorthand Logo" width="300px" style="float:none; margin: 0px 0px 0px 0px;" />

#### Motivations for FHIR Shorthand

FHIR Shorthand was created in response to the need in the FHIR community for scalable, fast, user-friendly tools for IG creation and maintenance. Experience has shown that profiling projects can be difficult and slow, and the resulting IG quality can be inconsistent. Profiling projects often go through many iterations, and as such, an agile approach to refactoring and revision is invaluable.

<img src="IG-Need-For-Agility.png" alt="IG Need for Agility" width="800px" style="float:none; margin: 0px 0px 0px 0px;" />

There are already several existing methods for IG creation: hand editing, using [Excel spreadsheets](https://confluence.hl7.org/display/FHIR/FHIR+Spreadsheet+Profile+Authoring), [Simplifier/Forge](https://fire.ly/products/simplifier-net/), and [Trifolia-on-FHIR](https://trifolia-fhir.lantanagroup.com). Each of these methods have certain advantages as well as drawbacks:

1. Hand-editing StructureDefinitions (SDs) is unwieldy, but authors get full control over every aspect of the resulting profiles and extensions.
1. The spreadsheet method has existed since before FHIR 1.0 and has been used to produce sophisticated IGs such as [US Core](https://github.com/HL7/US-Core-R4). A significant downside is that version management is extremely difficult; either the files are saved in binary form (.xslx) or as XML files, with the content lost in thousands of lines of formatting.
1. Simplifier/Forge and Trifolia-on-FHIR provide graphical user interfaces that are very helpful guiding users through common tasks. However, making significant cross-cutting changes ([refactoring](https://resources.collab.net/agile-101/code-refactoring)) requires navigating through many screens. Currently these tools do not have advanced source code control (SCC) features.

Experience across many domains has shown that complex software projects are best approached with textual languages. As a DSL designed for the job of profiling and IG creation, FSH is concise, understandable, and aligned to user intentions. Users may find that the FSH language representation is the best way to understand a set of profiles. Because it is text-based, FHIR Shorthand brings a degree of editing agility not found in graphical tools (cutting and pasting, global search and replace, spell checking, etc.) FSH is ideal for distributed development under source code control, providing meaningful version-to-version differentials, support for merging and conflict resolution, and nimble refactoring. These features allow FSH to scale in ways that other approaches cannot. Any text editor can be used to create or modify FSH, but advanced text editor plugins may also be used to further aid authoring.

#### Related Tools

Accompanying the FSH language is a reference implementation, [SUSHI](sushi.html) (an acronym for for "**S**USHI **U**nshortens **SH**orthand **I**nputs"), that translates FSH into FHIR artifacts and enables production of FHIR IGs. There is also a tool, [FSH Food](https://github.com/lantanagroup/fshfood), that converts profiles and extensions (StructureDefinitions) into FSH. Together with the [HL7 IG Publisher](https://confluence.hl7.org/display/FHIR/IG+Publisher+Documentation), these tools present a complete solution for creating and maintaining a FHIR IG.

_NOTE: SUSHI and FSH Food are in active development. SUSHI is expected to support all proposed FHIR Shorthand features at the time of ballot, but FSH Food is not guaranteed to do so. In addition, these tools are expected to continue to evolve and change during and after the ballot._

### Creating an IG with FSH and SUSHI

As illustrated below, creating an IG with FSH and SUSHI consists of three steps:

1. Populating a FSH Tank (a directory) with FSH files containing definitions of FHIR artifacts, and additional content for your IG.
2. Compiling those files using the SUSHI compiler.
3. Creating the IG using the HL7 FHIR IG Publishing Tool.

<img src="Workflow.png" alt="Overall FSH Workflow" width="800px" style="float:none; margin: 0px 0px 0px 0px;" />

> Note: The IG Publisher has recently (late March 2020) integrated SUSHI, so steps 2 and 3 can be combined. For details, see [SUSHI](sushi.html) documentation. 

#### FSH Tanks

A **FSH Tank** refers to a directory structure that contains FSH files for an IG. A FSH Tank corresponds one-to-one to an IG and represents a complete module that can be placed under SCC. The FHIR artifacts (profiles, extensions, value sets, code systems, examples, etc.) are defined by FSH files in the FSH Tank. FHIR artifacts defined elsewhere (such as profiles from another IG) are "external" and their IGs must be declared in dependencies.

Information is stored in plain text files with `.fsh` extensions. Each file can contain multiple items. It is up to the author to decide how to divide information between the between FSH files as well as subdirectories. Here are some possibilities:

* Divide up according to the type of item: profiles in one file, value sets in another, extensions in another, etc.
* Group things logically, for example, a profile together with its value sets, extensions, and examples.
* Use one file for each item (and potentially put similar items in different subdirectories).

Additional IG content such as narrative page content, images, and customized menus are also part of the FSH Tank (the rice and seaweed in the illustration). This is discussed in the [SUSHI Users Guide](sushi.html#ig-creation).

#### Running SUSHI

SUSHI is a translator that converts FSH to FHIR. Currently, SUSHI is installed and runs locally on your own computer from the command line. Installing SUSHI is described [here](sushi.html#installation). The language (Typescript) and the underlying architecture of SUSHI is compatible with future server-based deployment.

After SUSHI runs, a new directory appears in the FSH Tank. This directory (named **/build** by default) contains all the files necessary to run the IG Publisher. FHIR artifacts, such as profiles, extensions, value sets, and instances can be found in the **/build/input** directory after running SUSHI.

#### Running the IG Publisher

After running SUSHI, the IG Publisher can be run from the build directory, populating the **/build/output** directory. The home page for the IG is **/build/output/index.html**. It can be opened in any browser.

If HL7 is publishing your IG, you need to move the build files (excluding **/build/output**, **/build/temp**, and **/build/template**) to your IG's repository on http://hl7.github.com. If your HL7 repository is configured to use the [Auto-Builder](https://github.com/FHIR/auto-ig-builder), then when you push the build files to it, the IG Publisher will run automatically and your IG will appear on the continuous integration site, https://build.fhir.org.

### Shorthand Language Overview

The complete grammar of FSH is described in the [FHIR Shorthand Language Reference](reference.html). Here we present just enough to get a taste of FSH.

#### Basics

* **Formal grammar**: [FSH has a formal grammar](https://github.com/FHIR/sushi/tree/master/antlr/src/main/antlr) defined in [ANTLR4](https://www.antlr.org/).
* **Reserved words**: FSH has a number of special words that are considered part of the language, and cannot be used as item names. Refer to the keywords section in [FSH's formal ANTLR4 grammar](https://github.com/FHIR/sushi/tree/master/antlr/src/main/antlr) for a complete list of these words.
* **Data types**: The primitive and complex data types and value formats in FSH are identical to the [primitive types and value formats in FHIR](https://www.hl7.org/fhir/datatypes.html#primitive).
* **Whitespace**: Repeated whitespace is not meaningful within FSH files, except within string delimiters.
* **Comments**: FSH follows [JavaScript syntax](https://www.w3schools.com/js/js_comments.asp) for code comments, with `//` denoting single-line comments, and the pair `/*`  `*/` delimiting multiple line comments.
* **Asterisk Character**: A leading asterisk is used to denote FSH rules. For example, here is a rule to set Organization.active to `true`:

  ```
  * active = true
  ```

* **Escape Character**: FSH uses the backslash as the escape character in string literals. For example, use `\"` to embed a quotation mark in a string.
* **Circumflex Character ("Caret Syntax")**: FSH uses the circumflex (also called caret) `^` to directly reference the definitional structure associated with an item. For example, when defining a profile, caret syntax allows you to refer to elements in the StructureDefinition. For example, to set the element StructureDefinition.experimental from the FSH code that defines a profile:

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

This grammar can be used when assigning a coded value to an element whose data type is code, Coding, or CodeableConcept. FSH uses the `=` sign to express assignment. Assignment statements (and other [FSH rules](#rules)) always begin with an asterisk.

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

#### Keywords

Keywords are used to make declarations that introduce new items. A keyword statement follows the syntax:

```
{Keyword}: {value or expression}
```

Here's an example of keywords declaring a profile:

```
Profile:  CancerDiseaseStatus
Parent:   Observation
Id:       mcode-cancer-disease-status
Title:    "Cancer Disease Status"
Description: "A clinician's qualitative judgment on the current trend of the cancer, e.g., whether it is stable, worsening (progressing), or improving (responding)."
```

Keywords that declare new items (the `Profile` keyword in the previous example) must occur first in any set of keywords. There are nine primary keywords in FSH:

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

Keywords common to several types of items include:

* Description _(CodeSystem, Extension, Instance, Invariant, Profile, ValueSet)_
* Id _(CodeSystem, Extension, Profile, ValueSet)_
* Title _(CodeSystem, Extension, Profile, ValueSet)_
* Mixins _(Extension, Instance, Profile)_
* Parent _(Extension, Profile)_

Specialized keywords, used only with one type of item include:

* InstanceOf _(Instance)_
* Usage _(Instance)_
* Source _(Mapping)_
* Target _(Mapping)_
* Severity _(Invariant)_
* XPath _(Invariant)_
* Expression _(Invariant)_

Each type of item has a different set of required and optional keywords. For example, to define a profile, the keywords `Profile` and `Parent` are required, and `Id`, `Title`, and `Description` are recommended. The keyword `Mixins` is optional. The [FSH Language Reference](reference.html) contains a [complete list of keywords and their usage](reference.html#keywords).

#### Rules

The keyword section is followed by a number of rules. Rules are the mechanism for constraining a profile, defining an extension, creating slices, and more. All rules begin with an asterisk:

```
* {rule statement}
```

There are approximately a dozen types of rules in FSH. The [formal syntax of rules](reference.html#rules) are given in the [FSH Language reference](reference.html). Here is a summary:

* **Fixed value (assignment) rules** are used to set constant values in profiles and instances. For example:

  ```
  * bodySite.text = "Left ventricle"
  ```

  ```
  * onsetDateTime = "2019-04-02"
  ```

  ```
  * status = #arrived
  ```

* **Value set binding rules** are used on elements with coded values to specify the set of enumerated values for that element. Binding rules include one of FHIR's binding strengths (example, preferred, extensible, or required). For example:

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

* **Data type rules** restrict the type of value that can be used in an element. For example:

  ```
  * value[x] only CodeableConcept
  ```

  ```
  * onset[x] only Period or Range
  ```

* **Reference type rules** restrict the type of resource that a Reference can refer to. For example:

  ```
  * recorder only Reference(Practitioner)
  ```

  ```
  * recorder only Reference(Practitioner | PractitionerRole)
  ```

* **Flag rules** add bits of information about elements impacting how implementers should handle them. For example:

  ```
  * communication MS ?!
  ```

  ```
  * identifier, identifier.system, identifier.value, name, name.family MS
  ```

* **Extension rules** specify elements populating extensions arrays. Extensions can either be defined inline or standalone. Inline extensions do not have a separate StructureDefinition, but standalone extensions do. Standalone extensions include those defined by other IGs or extensions defined in the same FSH tank, using the `Extension` keyword. 

  Here are two examples of defining inline extensions:

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

  With standalone extensions, the main difference is that the grammar includes both the standalone name and the assigned local name:

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

* **Slicing rules** specify the types of elements an array element can contain. Slicing requires setting of at least three parameters before the slice can be defined: the discriminator type and path, and slicing rules. [Caret syntax](reference.html#structure-definition-escape-paths) is used to set these parameters directly in the StructureDefinition. Here is a typical "slicing rubric" for slicing Observation.component:

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
  * component[SystolicBP].valueQuality = UCUM#mm[Hg]
  * component[DiastolicBP].code = http://loinc.org#8462-4 // Diastolic blood pressure
  * component[DiastolicBP].value[x] only Quantity
  * component[DiastolicBP].valueQuality = UCUM#mm[Hg]
  ```

* **Invariant rules** associate elements with XPath or FHIRPath constraints they must obey. For example:


  ```
  * obeys us-core-9  // invariant applies to entire profile
  ```  

  ```
  * name obeys us-core-8  // invariant applies to the name element
  ```

* **Extensional (explicit) code rules** are used to include or exclude specific codes in value sets and code systems. For example:

  ```
  * SCT#54102005 "G1 grade (finding)"
  ```

  ```
  * exclude SCT#12619005
  ```

  When defining a new code system, the code system (SCT, in the examples) is omitted and an optional definition can be appended as a separate string.

* **Intensional (implicit) code rules** are used to include or exclude sets of values in value sets. For example, to include all codes from a code system:

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

### FSH Line-by-Line Walkthrough

In this section, we'll walk through a realistic example line by line.

```
1   Alias: LNC = http://loinc.org
2   Alias: SCT = http://snomed.info/sct
3
4   Profile:  CancerDiseaseStatus
5   Parent:   Observation
6   Id:       mcode-cancer-disease-status
7   Title:    "Cancer Disease Status"
8   Description: "A clinician's qualitative judgment on the current trend of the cancer, e.g., whether it is stable, worsening (progressing), or improving (responding)."
9   * extension contains EvidenceType named evidenceType 0..*
10  * extension[evidenceType].valueCodeableConcept from CancerDiseaseStatusEvidenceTypeVS (required)
11  * status, code, subject, effective[x], valueCodeableConcept MS
12  * bodySite 0..0
13  * specimen 0..0
14  * device 0..0
15  * referenceRange 0..0
16  * hasMember 0..0
17  * component 0..0
18  * interpretation 0..1
19  * subject 1..1
20  * basedOn only Reference(ServiceRequest | MedicationRequest)
21  * partOf only Reference(MedicationAdministration | MedicationStatement | Procedure)
22  * code = LNC#88040-1 // Response to cancer treatment
23  * subject only Reference(CancerPatient)
24  * focus only Reference(CancerConditionParent)
25  * performer only Reference(http://hl7.org/fhir/us/core/StructureDefinition/us-core-practitioner)
26  * effective[x] only dateTime or Period
27  * value[x] only CodeableConcept
28  * valueCodeableConcept from ConditionStatusTrendVS (required)
29 
30  Extension: EvidenceType
31  Title: "Evidence Type"
32  Id:  mcode-evidence-type
33  Description: "Categorization of the kind of evidence used as input to the clinical judgment. This corresponds to both the S and O in SOAP."
34  * value[x] only CodeableConcept
35
36  ValueSet:   ConditionStatusTrendVS
37  Id: mcode-condition-status-trend-vs
38  Title: "Condition Status Trend Value Set"
39  Description:  "How patient's given disease, condition, or ability is trending."
40  * SCT#260415000 "Not detected (qualifier)"
41  * SCT#268910001 "Patient condition improved (finding)"
42  * SCT#359746009 "Patient's condition stable (finding)"
43  * SCT#271299001 "Patient's condition worsened (finding)"
44  * SCT#709137006 "Patient condition undetermined (finding)"
45  
46  ValueSet: CancerDiseaseStatusEvidenceTypeVS
47  Id: mcode-cancer-disease-status-evidence-type-vs
48  Title: "Cancer Disease Status Evidence Type Value Set"
49  Description:  "The type of evidence backing up the clinical determination of cancer progression. The code '* SCT#252416005 Histopathology test (procedure)' is intended to be used when there is a biopsy that contributes evidence of the cancer disease status."
50  * SCT#363679005 "Imaging (procedure)"
51  * SCT#252416005 "Histopathology test (procedure)"
52  * SCT#711015009 "Assessment of symptom control (procedure)"
53  * SCT#5880005   "Physical examination procedure (procedure)"
54  * SCT#386344002 "Laboratory data interpretation (procedure)"

```
* Lines 1 and 2 defines aliases for the LOINC and SNOMED-CT code systems.
* Line 4 declares the intent to create a profile with the name CancerDiseaseStatus. The name is typically title case and should be "computer-ready" (i.e., suitable for code generation).
* Line 5 says that this profile will be based on Observation. Specifying the parent is required.
* Line 6 gives an id for this profile. The id is often not the same as a the profile name, and typically follows the convention of putting the IG short name first, followed by hyphenated version of the profile name. If the id is not specified, the name of the profile will be used for the id.
* Line 7 is a human-readable title for the profile.
* Line 8 is the description that will appear in the IG on the profile's page.
* Line 9 is the start of the rule section of the profile. The first rule creates an extension using the standalone extension, `EvidenceType`, gives it the local name `evidenceType`, and assigns the cardinality 0..*. _EvidenceType is defined on line 30._
* Line 10 binds the valueCodeableConcept of the evidenceType extension to a value set named CancerDiseaseStatusEvidenceTypeVS with a required binding strength. _CancerDiseaseStatusEvidenceTypeVS is defined on line 46._
* Line 11 designates a list of elements (inherited from Observation) as must-support.
* Lines 12 to 19 constrain the cardinality of some inherited elements. FSH does not support setting the cardinality of a multiple items at a time, so these must be separate statements.
* Lines 20 and 21 restrict the choice of resource types for two elements that refer to other resources. The vertical bar denotes "or".
* Line 22 fixes the value of the code attribute to a specific LOINC code, using an alias for the code system defined on line 1. Note that the display name is presented in a comment, since setting the display name would require all instances to send the display name exact as specified.
* Lines 23 to 25 each restrict the choice of resource types to a reference to a single resource type. Note that the references can be to external profiles (us-core-practitioner) or to profiles (not shown in the example) defined in the same FSH tank (CancerPatient, CancerConditionParent). Also note that an alias could have been used in place of the us-core-practitioner URL.
* Line 26 and 27 restrict the data type for elements that offer a choice of data types in the base resource.
* Line 28 binds the remaining allowed data type for value[x], valueCodeableConcept, to the value set ConditionStatusTrendVS with a required binding. _ConditionStatusTrendVS is defined on line 36._
* Line 30 declares a standalone extension named EvidenceType.
* Line 31 gives the extension a human-readable title.
* Line 32 assigns it an id.
* Line 33 gives the extension a description that will appear on the extension's main page.
* Line 34 begins the rule section for the extension, and restricts the data type of the value[x] element of the extension to a CodeableConcept. Since extensions in FHIR only allow value[x] _or_ extension elements, the extension element will automatically have its cardinality set to 0..0.
* Line 36 declares a value set named ConditionStatusTrendVS.
* Line 37 gives the value set an id.
* Line 38 provides a human readable title for the value set.
* Line 39 gives the value set a description that will appear on the value set's main page.
* Lines 40 to 44 define the codes that are members of the value set
* Lines 46 to 54 create another value set, CancerDiseaseStatusEvidenceTypeVS, similar to the previous one.

A few things to note about this example:

* The order of items doesn't matter. In FSH, you can refer to items defined before or after the current item.
* The example assumes the items are all in one file, but they could be in separate files. The allocation of items to files is the author's choice.
* Most of the rules refer to elements by their FHIR names, but when the rule refers to an element that is not at the top level, more complex paths are required. An example of a complex path occurs on line 10, `extension[evidenceType].valueCodeableConcept`. The Language Reference contains [further descriptions of paths](reference.html#paths).

### Future Considerations

In this introduction, we presented an overview of FSH and SUSHI. Not all features were covered. A complete accounting of the language is found in the [FSH Language Reference](reference.html). A complete description of SUSHI is found in the [SUSHI Users Guide](sushi.html).

Version 1.0 of FSH and SUSHI are capable of producing sophisticated IGs and offer more than a "minimum viable product". Future versions may introduce additional features. Feature suggestions are welcome, and can be made [here](https://github.com/FHIR/sushi/issues).

Some of the features already under consideration include (in no order):

* **Slicing Support:** Currently, slicing requires the user to specify discriminator type, path, and slicing rules. It is anticipated that a future version of SUSHI will handle most slicing situations without explicit declarations by the user. To enable this, FHIR Shorthand will specify a set of algorithms that can be used to infer slicing discriminators based on the nature of the slices. We have nicknamed this “Ginsu Slicing” for the amazing 1980’s TV knife that slices through anything.

* **Multiple Language Support:** At present, FSH supports only one language. In the future, FSH and SUSHI may introduce mechanisms for generating IGs in multiple languages.

* **Capability Statements:** Currently, you can create a CapabilityStatement as an instance (using `InstanceOf: CapabilityStatement`) but FSH does nothing to help populate that instance. There may be more [interesting approaches](https://chat.fhir.org/#narrow/stream/215610-shorthand/topic/CapabilityStatement) that create CapabilityStatements more directly from requirements. Creative approaches and purpose-specific syntax could also be employed for other conformance resources such as SearchParameter.

* **Nested Path Syntax:** While FSH is very good at expressing profiling rules, the current path grammar is cumbersome for populating resources with nested arrays. An example is populating the items in Questionnaires, where each item can contain yet more items. A syntax like YAML is much more concise in this type of situation. Additional syntax is under consideration.

* **Logical Models:** FSH may provide future support for defining data models not derived from a FHIR resource. Logical models are useful for capturing domain objects and relationships early in the development cycle, and can provide traceability from requirements to implementable FHIR artifacts.

* **Resource Definitions:** FSH may provide support for developing new FHIR resources and maintaining existing ones, to help HL7 Work Groups more effectively manage their contributions to FHIR core.
