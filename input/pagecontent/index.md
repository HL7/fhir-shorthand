### Introduction

FHIR Shorthand (FSH) is a domain-specific language (DSL) for defining the content of FHIR Implementation Guides (IG). It is simple and compact, with tools to produce [Health Level Seven (HL7®) Fast Healthcare Interoperability Resources (FHIR®)](https://www.hl7.org/fhir/overview.html) profiles, extensions and implementation guides (IG). Because it is written in text statements, FHIR Shorthand encourages distributed, team-based development using conventional source code control tools such as Github.

> **Note:** HL7® and FHIR® are registered trademarks owned by Health Level Seven International.

#### Motivations for FHIR Shorthand

1. The FHIR community needs scalable, fast, and user-friendly tools for IG creation and maintenance. Profiling projects can be difficult and slow, and the resulting IG quality can be inconsistent.
1. Editing StructureDefinitions (SDs) by hand is complex and unwieldy.
1. Available tools such as [Simplifier/Forge](https://fire.ly/products/simplifier-net/), [Trifolia-on-FHIR](https://trifolia-fhir.lantanagroup.com), and [Excel spreadsheet authoring](https://confluence.hl7.org/display/FHIR/FHIR+Spreadsheet+Profile+Authoring) improve this situation, but still have drawbacks:
   * Although the tools provide a friendlier interface, the user must still understand many SD details.
   * The tools are not particularly agile when it comes to [refactoring](https://resources.collab.net/agile-101/code-refactoring).
   * Source code control (SCC) features are not well supported.
1. Especially for non-FHIR experts, it can be difficult to make sense of the contents of an IG. Some users might find that the FSH representation is more understandable.
1. Experience has shown that complex software projects are best approached with textual languages. As a DSL designed for the job of profiling and IG creation, FSH is concise, understandable, and aligned to user intentions.
1. FSH is ideal for SCC, with meaningful version-to-version differentials, support for merging and conflict resolution, and refactoring through global search/replace operations. These features allow FSH to scale in ways that other approaches cannot.

#### Benefits of FHIR Shorthand

* Agile -- rapid refactoring and revision cycles
* Readable and easy to understand
* Makes the author’s intent clear
* Reduces implementation errors
* Increases consistency by compiling FSH into StructureDefinitions using consistent patterns
* Provides meaningful differentials in SCC
* Enables merging at the statement/line-level in SCC
* Supports distributed development under SCC
* Any text editor can be used to modify an FSH file

### About this IG

This implementation guide includes the following sections:

* FHIR Shorthand Language Reference (this page) -- Describes the syntax and usage of the FHIR Shorthand language.
* [FHIR Shorthand Tutorial](tutorial.html) -- A step-by-step hands-on introduction to producing an IG with FHIR Shorthand.
* [SUSHI User Guide](sushi.html) -- How to produce an IG from FSH files using SUSHI compiler and the IG Publisher.

#### Document Conventions

| Style | Explanation | Example |
|:----------|:------|:---------|
| `Code` | Code fragments, such as commands and FSH statements  | `* status = #open` |
| _italics_ | File names | _example-1.fsh_ |
| {curly braces} | An item to be substituted | `{codesystem}#{code}` |
| **bold** | Emphasis |  Do **not** ignore this. |
| 🚫 | Indicates a planned feature, not yet implemented in FSH or SUSHI | |
| 🚧 | Indicates a feature implemented in FSH but not yet implemented in SUSHI | |
| 👶 | Indicates a feature supported in FSH in SUSHI, but not fully tested | |
{: .grid }

#### Versioning

The FSH specification, like other IGs, follows the [semantic versioning](https://semver.org) convention (MAJOR.MINOR.PATCH):

* MAJOR: A major release has significant new functionality and potentially, grammar changes or other non-backward-compatible changes.
* MINOR: Contains new or modified features, while maintaining backwards compatibility within the major version.
* PATCH: Contains minor updates and bug fixes, while maintaining backwards compatibility within the major version.

There are some language elements documented here that are not yet implemented in SUSHI. See the [SUSHI Release Notes](https://github.com/FHIR/sushi/releases) for futher details.

### Language Elements

This section describes various parts of the FSH language.

#### FSH Tanks and FSH Files

A **FSH Tank** is a folder that contains FSH files. A FSH Tank corresponds one-to-one to an IG and represents a complete module that can be placed under SCC. The FHIR artifacts included in the IG (profiles, extensions, value sets, examples, etc.) are defined in the FSH Tank. Anything else is "external" and must be declared in dependencies.

Information in FSH is stored in plain text files with _.fsh_ extension. How information is divided between files is up to the user. Here are some possibilities:

* Divide up different type of items: profiles in one file, value sets in another, extensions in another, etc.
* Group things logically, for example, a profile together with its value sets, extensions, and examples.
* Create one file for each item.

#### Formal Grammar

[FSH has a formal grammar](https://github.com/FHIR/sushi/tree/master/antlr/src/main/antlr) defined in [ANTLR4](https://www.antlr.org/).

#### Reserved Words

FSH has a number of Keywords and reserved words (e.g., `Alias`, `Profile`, `Extension`, `and`, `or`, `from`, `contains`, `obeys`). For a complete list of reserved words, refer to the keywords section in [FSH's formal ANTLR4 grammar](https://github.com/FHIR/sushi/tree/master/antlr/src/main/antlr).

#### Primitives

The primitive data types and value formats in FSH are identical to the [primitive types and value formats in FHIR](https://www.hl7.org/fhir/datatypes.html#primitive).

For convenience, FSH also supports multi-line strings, demarcated with triple quotation marks `"""`. The line breaks are for visual convenience only, and multi-line strings are translated to conventional FHIR strings.

#### Whitespace

Repeated whitespace is not meaningful within FSH files. This:

```
Profile:  SecondaryCancerCondition
Parent:   CancerCondition
* focus only PrimaryCancerCondition
```

is equivalent to:
```
             Profile:  
SecondaryCancerCondition            Parent: CancerCondition

         * focus only    
PrimaryCancerCondition
```

#### Comments

FSH follows [JavaScript syntax](https://www.w3schools.com/js/js_comments.asp) for code comments:

```
// Use a double-slash for comments on a single line

/*
Use slash-asterisk and asterisk-slash for larger block comments.
These comments can take up multiple lines.
*/
```

#### Coded Data Types

The four "coded" types in FHIR are code, Coding, CodeableConcept, and Quantity. These data types can be bound to a value set or assigned a fixed code.  FSH provides special grammar for expressing codes and setting fixed coded values.

##### code

Codes are denoted with `#` sign. The shorthand is:

`#{code}`

>**Note:** In this document, curly braces are used to indicate a term that should be substituted.

**Examples:**

* The code 'confirmed' (a value in [Condition Clinical Status Codes](http://hl7.org/fhir/R4/valueset-condition-clinical.html)):

  `#confirmed`

* Assign the code 'confirmed' to the verificationStatus of a Condition (a code type):

  `* verificationStatus = #confirmed`

##### Coding

The shorthand for a Coding value is:

`{system}#{code} "{display text}"`

For code systems that encode the version separately from the URL, the version can be specified as follows:

`{system}|{version}#{code} "{display text}"`

An alternative is to set the `version` element of Coding (see examples).

While `{system}` and `{code}` are required, `|{version}` and `"{display text}"` are optional. The `{system}` represents the controlled terminology that the code is taken from. It can be a URL, OID, or alias for a URL or OID (see [defining aliases](#defining-aliases)). The bar syntax for code system version is the same approach used in the `canonical` data type in FHIR.

To set the less-common properties of a Coding, use a [fixed value rule](#fixed-value-rules) on that element.

**Examples:**

* The code 363346000 from SNOMED-CT:

  `http://snomed.info/sct#363346000 "Malignant neoplastic disease (disorder)"`

* The same code, assuming SCT has been defined as an alias for http://snomed.info/sct:

  `SCT#363346000 "Malignant neoplastic disease (disorder)"`

* A code from ICD10-CM (assuming a code system alias has been defined):

  `ICD10CM#C004  "Malignant neoplasm of lower lip, inner aspect"`

* A code with an explicit version set specified with bar syntax:

  `http://hl7.org/fhir/CodeSystem/example-supplement|201801103#chol-mmol`

* As an alternative to the bar syntax, set the version of a Coding directly:

  `* myCoding.version = "201801103"`

* Set the 'type' element of a Signature:

  `* type = urn:iso-astm:E1762-95:2013#1.2.840.10065.1.12.1.2 "Coauthor's Signature"`

* Set one of the lesser-used attributes of a Coding:

  `* myCoding.userSelected = true`

##### CodeableConcept

A CodeableConcept consists of an array of Codings, plus a text. Codings are expressed using the shorthand explained [directly above](#coding). The shorthand for setting the first Coding in a CodeableConcept is:

`* {CodeableConcept type} = {system}#{code} "{display text}"`

To set additional values, array indices are used. Indices are denoted by bracketed integers. The shorthand is:

`* {CodeableConcept type}.coding[{i}] = {system}#{code} "{display text}"`

FSH arrays are zero-based. If no array index is given, the index [0] is assumed (see [Array Property Paths](#array-property-paths) for more information).

To set the top-level text of a CodeableConcept, the shorthand expression is:

`* {CodeableConcept type}.text = {string}`

**Examples:**

* To set the first Coding in Condition.code (a CodeableConcept):

  `* code = SCT#363346000 "Malignant neoplastic disease (disorder)"`

* An equivalent representation, using explicit array index on the coding array:

  `* code.coding[0] = SCT#363346000 "Malignant neoplastic disease (disorder)"`

* Another equivalent representation, using the shorthand that allows dropping the [0] index:

  `* code.coding = SCT#363346000 "Malignant neoplastic disease (disorder)"`

* Adding a second value to the array of Codings:

  `* code.coding[1] = ICD10#C80.1 "Malignant (primary) neoplasm, unspecified"`

* Set the top-level text of Condition.code:

  `* code.text = "Diagnosis of malignant neoplasm left breast."`

##### Quantity

In addition to having a quantitative value, a FHIR Quantity has a coded value that is interpreted as the units of measure of that Quantity. An element that is a Quantity can be bound to a value set or assigned a coded value. The shorthand is:

`* {Quantity type} = {system}#{code} "{display text}"`

Although this appears the quantity is being set to a coded value, it is legal. 

🚧 To make this a bit more intuitive, FSH allows you to use the word `units`, as follows:

`* {Quantity type} units = {system}#{code} "{display text}"`

🚧 and for [binding](#value-set-binding-rules):

`* {Quantity type} units from {value set} ({strength})`

>**Note:** Use of the word `units` is suggested for clarity, but is optional.



**Examples:**

* Set the units of the valueQuantity of an Observation to millimeters (assuming UCUM has been defined as an alias for http://unitsofmeasure.org):

  `* valueQuantity = UCUM#mm "millimeters"`

* 🚧 Alternate syntax for the same operation (addition of 'units'):

  `* valueQuantity units = UCUM#mm "millimeters"`

* 🚧 Bind a value set to the units of a Quantity (using alternate syntax):

  `* valueQuantity units from http://hl7.org/fhir/ValueSet/distance-units`

#### Paths

FSH path grammar allows you to refer to any element of a profile, extension, or profile, regardless of nesting. Paths also provide a grammar for addressing elements of a SD directly. Here are a few examples of how paths are used in FSH:

* To refer to a nested element, such as method.text in Observation
* To address a particular item in a list or array
* To refer to individual elements inside choice elements (e.g., onsetAge in onset[x])
* To pick out an individual item within a multiple choice reference, such as Observation in Reference(Observation | Condition)
* To refer to an individual slice within a sliced array, such as the SystolicBP component within a blood pressure
* To set metadata elements in SD, like StructureDefinition.active
* To address elements of ElementDefinitions associated with a SD, such as maxLength property of string elements

##### Nested Element Paths

To refer to nested elements, the path lists the properties in order, separated by a dot (.)

> **Note:** It is not permissible to cross reference boundaries in paths. This means that when a path gets to a Reference, that path cannot be extended further. For example, if Procedure has a subject, Reference(Patient), and Patient has a gender, then `Procedure.subject` is a valid path, but `Procedure.subject.gender` is not, because it crosses into the Patient reference.

**Example:**

* Observation has an element named method, and method has a text property (note that inside a FSH definition, the resource is inferred from the context and not a formal part of the path):

  `* method.text = "Laparoscopy"`

##### Array Property Paths

If an element allows more than one value (e.g., `0..*`), then it must be possible to address each individual value. FSH denotes this with square brackets (`[` `]`) containing the **0-based** index of the item (e.g., first item is `[0]`, second item is `[1]`, etc.).

If the index is omitted, the first element of the array (`[0]`) is assumed. 

**Examples:** 

* Set a Patient's first name's second given name to "Marie":

  `* name[0].given[1] = "Marie"`

* Equivalent expression, since the zero index is assumed when omitted:

  `* name.given[1] = "Marie"`

##### Reference Paths

Frequently in FHIR, an element has a Reference that has multiple targets. To address a specific target, follow the path with square brackets (`[` `]`) containing the target type (or the profile's `name`, `id`, or `url`).

**Example:** 

* Restrict a performer element (type Reference(Organization | Pracititioner) to PrimaryCareProvider in a profile, assuming PrimaryCareProvider is a profile on Practitioner:

  `* performer[Practitioner] only PrimaryCareProvider`

##### Data Type Choice [x] Paths

Addressing a type from a choice of types replaces the `[x]` in the property name with the type name (while also capitalizing the first letter). This follows the approach used in FHIR JSON and XML serialization.

**Example:** 

* Fix value[x] string value to "Hello World":

  `* valueString = "Hello World"`

* Fix the value[x] Reference (permitted in extensions) to a instance of Patient resource:

  `* valueReference = Reference(EveAnyperson)`

##### Profiled Type Choice Paths

In some cases, a type may be constrained to a set of possible profiles. To address a specific profile on that type, follow the path with square brackets (`[` `]`) containing the profile's `name`, `id`, or `url`.

**Example:**

* After constraining an address element to either a USAddress or a CanadianAddress, bind the address.state properties to a value set of US states and Canadian provences:

  ```
  * address only USAddress or CanadianAddress
  * address[USAddress].state from USStateValueSet (required)
  * address[CanadianAddress].state from CanadianProvenceValueSet (required)
  ```

##### 👶 Sliced Array Paths

FHIR allows lists to be compartmentalized into sublists called "slices".  To address a specific slice, follow the path with square brackets (`[` `]`) containing the slice name. Since slices are most often unordered, slice names rather than array indices should be used.

To access a slice of a slice (i.e., _reslicing_), follow the first pair of brackets with a second pair containing the resliced slice name.

**Examples:**

* In an Observation profile representing Apgar score, with slices for RespiratoryScore, AppearanceScore, and others, fix the RespirationScore:

  `* component[RespiratoryScore].code = SCT#24388001 "Apgar score 5 (finding)"`

* If the Apgar RespiratoryScore is resliced to represent the one and five minute Apgar scores, set the OneMinuteScore and FiveMinuteScore sub-slices:

  `* component[RespiratoryScore][OneMinuteScore].code = SCT#24388001 "Apgar score 5 (finding)"`

  `* component[RespiratoryScore][FiveMinuteScore].code = SCT#13323003 "Apgar score 7 (finding)"`

##### Extension Paths

Extensions are arrays populated by slicing. They may be addressed using the slice path syntax presented above. However, extensions being very common in FHIR, FSH supports a compact syntax for paths that involve extensions. The compact syntax drops `extension[ ]` or `modifierExtension[ ]` (similar to the way the `[0]` index can be dropped). The only time this is not allowed is when dropping these terms creates a naming conflict.

**Examples:** 

* Set the value of the birthsex extension in US Core Patient (assume USCoreBirthsex has been defined as an alias for the birthsex extension):

   Full syntax:

  `* extension[USCoreBirthsex].valueCode = #F`

  🚧 Abbreviated syntax:

  `* USCoreBirthsex.valueCode = #F`

* Set the nested ombCategory extension, under the ethnicity extension in US Core:

  Full syntax:

  `* extension[USCoreEthnicity].extension[ombCategory].valueCoding = RACE#2135-2 "Hispanic or Latino"`

  🚧 Abbreviated syntax:

  `* USCoreEthnicity.ombCategory.valueCoding = RACE#2135-2 "Hispanic or Latino"`

* Set two values in the multiply-valued nested extension, detailed, under USCoreEthnicity extension:

  Full syntax:
```
  * extension[USCoreEthnicity].extension[detailed][0].valueCoding = RACE#2184-0 "Dominican"
  * extension[USCoreEthnicity].extension[detailed][1].valueCoding = RACE#2148-5 "Mexican"
```

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;🚧 Abbreviated syntax:

```
  * USCoreEthnicity.detailed[0].valueCoding = RACE#2184-0 "Dominican"
  * USCoreEthnicity.detailed[1].valueCoding = RACE#2148-5 "Mexican"
```

##### Structure Definition Escape Paths

FSH uses the caret (^) syntax to provide direct access to attributes of a StructureDefinition. The caret syntax is used to set the metadata attributes in SD, other than those set through [FSH Keywords](#keywords) (name, id, title, and description) or specified in the [package-list.json file](sushi.md#configuration-file) used to create the IG. Examples of metadata elements in SDs can be set with caret syntax include experimental, useContext, and abstract.

The caret syntax can also be combined with element paths to set values in the ElementDefinitions that populate the SD.

**Examples:**

* Set the status 'experimental' attribute of a StructureDefinition from inside a profile:

  `* ^experimental = false`

* For element communication.language, set the description attribute of the binding in the ElementDefinition:

  `* communication.language ^binding.description = "This binding is dictated by US FDA regulations."`


***
### Rules

Rules are the mechanism for constraining a profile, defining an extension, creating slices, and more. All rules begin with an asterisk:

`* {rule statement}`

We have already sneakily introduced a few types of rules: the fixed value rule (assignment using `=`), the binding rule (using `from`), and the data type restriction rule (using `only`).

Here is a summary of the rules supported in FSH:

| Rule Type | Syntax |
| --- | --- |
| Fixed value |`* {path} = {value}`  | 
| Value set binding |`* {path} from {valueSet} ({strength})`| 
| Narrowing cardinality | `* {path} {min}..{max}` |
| Data type restriction | `* {path} only {type1} or {type2} or {type3}` |
| Reference type restriction | `* {path} only Reference({type1} | {type2} | {type3})` |
| Flag assignment | `* {path} {flag1} {flag2}` <br/> `* {path1}, {path2}, {path3}... {flag}` |
| 🚫 Invariants | `* obeys {invariant}` <br/> `* {path} obeys {invariant}` <br/> `* {path1}, {path2}, ... obeys {invariant}` |
| Slicing | `* {array element path} contains {sliceName1} {card1} {flags1} and {sliceName2} {card2} {flags2}...` |
| Extensions | `* {extension element path} contains {extensionName1} {card1} and {extensionName2} {card2} ...` |
| 🚫 Mapping | `* {path} -> {string}` |
{: .grid }

#### Fixed Value Rules

Fixed value assignments follow this syntax:

`* {path} = {value}`

To assign a reference to another resource, use:

`* {path} = Reference({resource instance})`

The left side of the expression follows the [FSH path grammar](#paths). The right side's data type must aligned with the data type of the final element in the path.

**Examples:**

* Assignment of a code data type:

  `* status = #arrived`

* Assignment of a Coding or the first Coding element in a CodeableConcept:

  `* code = SCT#363346000 "Malignant neoplastic disease (disorder)"`

* Assignment of a boolean:

  `* active = true`

* Assignment of a date:

  `* onsetDateTime = "2019-04-02"`

* 🚧 Assignment of a quantity with single quotes indicating UCUM units:

  `* valueQuantity = 36.5 'C'`

* 👶 Assignment of a reference type to another resource:

  `* subject = Reference(EveAnyperson)`


#### Value Set Binding Rules

Binding is the process of associating a coded element with a set of possible values. The syntax to bind a value set, or alter an inherited binding, uses the reserved word `from`:

`* {path} from {valueSet} ({strength})`

The value set can be the name of a value set defined in the same FSH tank, or the defining URL of an external value set that is part of the core FHIR spec, or an IG that has been declared a dependency in the _package.json_ file.

The strengths are the same as the [binding strengths defined in FHIR](https://www.hl7.org/fhir/valueset-binding-strength.html), namely: example, preferred, extensible, and required.

The following rules apply to binding in FSH:

* If no binding strength is specified, the binding is assumed to be required.
* When further constraining an existing binding, the binding strength can stay the same or be made tighter (e.g., replacing a preferred binding with extensible or required), but never loosened.
* Constraining may leave the binding strength the same and change the value set instead. However, certain changes permitted in FSH may violate [FHIR profiling principles](http://hl7.org/fhir/R4/profiling.html#binding-strength). In particular, FHIR will permit a required value set to be replaced by another required value set only if the codes in the new value set are a subset of the codes in the original value set. For extensible bindings, the new value set can contain codes not in the existing value set, but additional codes **should not** have the same meaning as existing codes in the base value set.

**Examples:**

* Bind to an externally-defined value set using its canonical URL:

  `* telecom.system from http://hl7.org/fhir/ValueSet/contact-point-system (required)`

* Bind to an externally-defined value set with required binding by default:

  `* gender from http://hl7.org/fhir/ValueSet/administrative-gender`

* Bind to a value set using an alias name:

  `* address.state from USPSTwoLetterAlphabeticCodes (extensible)`

#### Narrowing Cardinality Rules

Cardinality rules constrain the number of repetitions of an element. Every element has a cardinality inherited from its parent resource or profile. If the inheriting profile does not alter the cardinality, no cardinality rule is required.

To change the cardinality, the grammar is:

`* {path} {min}..{max}`

As in FHIR, min and max are non-negative integers, and max can also be *, representing unbounded.

Cardinalities must follow [rules of FHIR profiling](https://www.hl7.org/fhir/conformance-rules.html#cardinality), namely that the min and max cardinalities must stay within the constraints of the parent.

**Examples:**

* Set the cardinality of the subject element to 1..1 (required, non-repeating):

  `* subject 1..1`

* Set the cardinality of a sub-element to 0..0 (not permitted):

  `* component.referenceRange 0..0`

#### Data Type Restriction Rules

FSH rules can be used to restrict the data type of an element. The shorthand syntax to restrict the type is:

 `* {path} only {type}`

 `* {path} only {type1} or {type2} or {type3}...`

where the latter offers a choice of data type. The data type choices must always be more restrictive than the original data type. For example, if the parent data type is Quantity, it can be replaced in an `only` rule by SimpleQuantity, since SimpleQuantity is a profile on Quantity (hence more restrictive than Quantity itself).

Certain elements in FHIR offer a choice of data types using the [x] syntax. Choices can be restricted in two ways: reducing the number or choices, or substituting a more restrictive data type or profile for one of the original choices.  

**Examples:**

* Restrict a Quantity type to SimpleQuantity:

  `* valueQuantity only SimpleQuantity`

* Condition.onset[x] is a choice of dateTime, Age, Period, Range or string. To restrict onset[x] to dateTime:

  `* onset[x] only dateTime`

* Restrict onset[x] to either Period or Range:

  `* onset[x] only Period or Range`

* Restrict onset[x] to Age, AgeRange, or DateRange, assuming AgeRange and DateRange are profiles of FHIR's Range datatype (thus permissible restrictions on Range):

  `* onset[x] only Age or AgeRange or DateRange`

#### Reference Type Restriction Rules

Elements that refer to other resources often offer a choice of target resource types. For example, Condition.recorder has reference type choice Reference(Practitioner | PractitionerRole | Patient | RelatedPerson). A reference type restriction rule can narrow these choices, using the following grammar:

`{path} only Reference({type1} | {type2} | {type3} ...)`

> **Note:** The vertical bar within references represents logical 'or'.

It is important to note that a reference can only be restricted to a compatible type. For example, the subject of [US Core Condition](http://hl7.org/fhir/us/core/StructureDefinition-us-core-condition.html), with type Reference(US Core Patient), cannot be restricted to Reference(Patient), because Patient is not a profile of US Core Patient.

**Examples:**

* Restrict recorder to a reference to any Practitioner:

  `* recorder only Reference(Practitioner)`

* Restrict recorder to either a Practitioner or a PractitionerRole:

  `* recorder only Reference(Practitioner | PractitionerRole)`

* Restrict recorder to `PrimaryCarePhysician` or `EmergencyRoomPhysician`, assuming these are both profiles on `Practitioner`:

  `* recorder only Reference(PrimaryCarePhysician | EmergencyRoomPhysician)`

#### Flag Assignment Rules

Flags are a set of information about the element that impacts how implementers handle them. The [flags defined in FHIR](http://hl7.org/fhir/R4/formats.html#table), and the symbols used to describe them, as as follows:

| FHIR Flag | FSH Flag | Meaning |
|------|-----|----|
| S | MS  | Must Support |
| &#931;  | SU  | Include in summary |
| ?! | ?! | Modifier |
{: .grid }

The flags I, NE, TU, N, and D are currently not supported by FSH.

The following syntax can be used to assigning flags:

`* {path} {flag1} {flag2} ...`

`* {path1}, {path2}, {path3}... {flag}`

**Examples:**

* Declare communication to be MustSupport and Modifier:

  `* communication MS ?!`

* Declare a list of elements and nested elements to MustSupport:

  `* identifier, identifier.system, identifier.value, name, name.family MS`

#### 🚧 Invariant Rules

[Invariants](https://www.hl7.org/fhir/conformance-rules.html#constraints) are constraints that apply to one or more values in instances, expressed as [FHIRPath expressions](https://www.hl7.org/fhir/fhirpath.html). An invariant can apply to an instance as a whole, a single element, or multiple elements. The FSH grammars for applying invariants in profiles are as follows:

`* obeys {invariant}`

`* {path} obeys {invariant}`

`* {path1}, {path2}, ... obeys {invariant}`

The first case is where the invariant applies to the profile as a whole. The second is where the invariant applies to a single element, and the third is where the invariant applies to multiple elements.

The referenced invariant and its properties must be declared somewhere within the same FSH tank, using the `Invariant` keyword. See [Defining Invariants](#defining-invariants).

**Examples:**

* Assign invariant to US Core Implantable Device (invariant applies to profile as a whole):

  `* obeys us-core-9`

* Assign invariant to Patient.name in US Core:

  `* name obeys us-core-8`


#### Slicing Rules

The subject of slicing is addressed three steps: (1) specifying the slices, (2) defining slice contents, and (3) providing the slicing logic.

##### Step 1. Specifying Slices

Slices are specified using the `contains` keyword. The following syntax is used to create new slices:

```
* {array element path} contains
       {sliceName1} {card1} {flags1} and
       {sliceName2} {card2} {flags2} and
       {sliceName3} {card3} {flags2} ...
```
In this pattern, the `{array element path}` is a path to an element with multiple cardinality that is to be sliced, `{card}` is required, and `{flags}` are optional.

**Examples:**

* Slice the Observation.component array for blood pressure:

  `* component contains SystolicBP 1..1 MS and DiastolicBP 1..1 MS`

* Because FSH is white-space invariant, the previous example can be rewritten so the slices appear one-per-line for readability:

```
   * component contains
       SystolicBP 1..1 and
       DiastolicBP 1..1
```
###### 👶 Reslicing

Reslicing (slicing an existing slice) uses a similar syntax, but the left-hand side uses [slice path syntax](#sliced-array-paths) to refer to the slice that is being resliced:
```
* {array element path}[{sliceName}] contains {resliceName1} {card1} and {resliceName2} {card2} and ...
```

**Example:**

* Reslice the Apgar Respiration score for one-minute and five-minute scores:

```
   * component[RespiratoryScore] contains
         OneMinuteScore 0..1 and
         FiveMinuteScore 0..1
```

##### Step 2. Defining Slice Contents

There are two approaches to defining the slices themselves:

1. 👶 Define the slice details inline in the profile. This approach is applicable when the structure of the slice already exists, in particular, when slicing a backbone element such as Observation.component.
2.  🚧 Define the slice as a separate item. This approach is required when the structure of the slice needs to be defined, and when slicing an array that involves a reference, such as Observation.hasMember.

The syntax for inline definition of slices is the same as constraining any other path in a profile, but uses the [slice path syntax](#sliced-array-paths) in the path:

```
* {path to slice}.{subpath} {constraint}
```

**Example:** 

* 👶 Defining SystolicBP and DiastolicBP slices inline:

```
* component contains 
     SystolicBP 1..1 and 
     DiastolicBP 1..1
* component[SystolicBP].code = LNC#8480-6 "Systolic blood pressure"
* component[SystolicBP].value[x] only Quantity
* component[SystolicBP].valueQuantity units = UCUM#mm[Hg] "mmHg"
* component[DiastolicBP].code = LNC#8462-4 "Diastolic blood pressure"
* component[DiastolicBP].value[x] only Quantity
* component[DiastolicBP].valueQuantity units = UCUM#mm[Hg] "mmHg"
```

##### Step 3. Providing the Slicing Logic

Slicing in FHIR requires the user to specify a [discriminator path, type, and rules](http://www.hl7.org/fhiR/profiling.html#discriminator). Optionally, you can also declare the slice ordered (unordered is the default).

One way to specify these parameters is to use [structure definition escape (caret) syntax](#structure-definition-escape-paths). The author identifies the sliced element, and then traverses the structure definition at that point.

**Example:**
```
* component[0] ^slicing.discriminator.type = #pattern
* component[0] ^slicing.discriminator.path = "code"
* component[0] ^slicing.rules = #open
* component[0] ^slicing.ordered = false   // can be omitted, since false is the default
* component[0] ^slicing.description = "Slice based on the component.code pattern"
```

 🚧 The second approach, nicknamed "Ginsu Slicing" for the [amazing 1980's TV knife that slices through anything](https://www.youtube.com/watch?v=6wzULnlHr8w), is provided by SUSHI and requires no action by the user. SUSHI infers slicing discriminators based the nature of the slices, based on a set of explicit algorithms. For more information, see the[SUSHI documentation](sushi.html).

#### Extension Rules

Extensions are created by slicing the extension array that is present at the root level of every resource, in each element, and recursively in each extension. Since extensions are essentially a special case of slicing, the slicing syntax can be reused. However, it is **not** necessary to specify the discriminator, since the discriminator is always the `url` (identifying URL of the extension), and the type is always `value`.

Extensions are created by slicing the `extension` (or `modifierExtension`) array. Slicing an extension element below the root level is achieved by giving the full path to the extension array to be sliced.

**Examples:**

* Create extensions in US Core Patient at the top level:

```
  * extension contains
      USCoreRaceExtension 0..1 MS and
      USCoreEthnicityExtension 0..1 MS and
      USCoreBirthsexExtension 0..1 MS
```

* Add laterality extension to bodySite attribute (second level extension):

  `* bodySite.extension contains Laterality 0..1`


#### 🚫 Mapping Rules

[Mappings](https://www.hl7.org/fhir/mappings.html) are an optional part of SDs that can be provided to help implementers understand the content and use resources correctly. These mappings are informative and are not to be confused with the computable mappings provided by [FHIR Mapping Language](https://www.hl7.org/fhir/mapping-language.html) and the [StructureMap resource](https://www.hl7.org/fhir/structuremap.html).

Mapping rules use the symbol `->` with the following grammar:

`* {path} -> {string}`

**Examples:**

* Map the entire profile to another item:

  `* -> Patient`

* Map the identifier.value element:

  `* identifier.value -> "identifier.value"`


>**Note:** Unlike setting the mapping directly in the SD, mapping rules within a Mapping do not include the name of the resource.

***

### Defining Items in FHIR Shorthand

This section shows how to define various items in FSH:

* [Aliases](#defining-aliases)
* [Profiles](#defining-profiles)
* 🚧 [Slices](#defining-slices)
* [Extensions](#defining-extensions)
* 🚫 [Mappings](#defining-mappings)
* 🚫 [Mixins](#defining-mixins)
* 🚫 [Invariants](#defining-invariants)
* 👶 [Instances](#defining-instances)
* 🚧 [Code Systems](#defining-code-systems)
* 🚧 [Value Sets](#defining-value-sets)

#### Keywords

Keywords are used to make declarations that introduce new items, such as profiles and instances. For each item defined in FSH, a keyword section is first followed by a number of rules. The keyword statements themselves follow the syntax:

`{Keyword}: {value}`

For example:

`Profile: SecondaryCancerCondition`

`Description: "The intent of the treatment."`

For some keywords, values are **FSH names**. A name is any sequence of non-whitespace characters, used to refer to the item within the same [FSH tank](#file-types-and-fsh-tanks). By convention, names should use [PascalCase (also known as UpperCamelCase)](https://wiki.c2.com/?UpperCamelCase).

The use of individual keywords is explained in greater detail in the following sections. Here is a summary of keywords in FSH:

| Keyword | Purpose | Data Type |
|----------|---------|---------|
| `Alias`| Defines an alias for a URL or OID | uri, url, or oid  |
| 🚧 `CodeSystem` | Declares a new code system | name |
| `Description` | Provides a human-readable description | string, markdown |
| 🚧 `Expression` | The FHIR path expression in an invariant | string |
| `Extension` | Declares a new extension | name |
| `Id` | Set a unique identifier of an item | name |
| 👶 `Instance` | Declare a new instance | name |
| 👶 `InstanceOf` | The profile or resource an instance instantiates | name |
| 🚧 `Invariant` | Declares a new invariant | name |
| 🚧 `Mapping` | Introduces a new mapping | name |
| 🚫 `Mixin` | Introduces a class to be used as a mixin | name |
| 🚫 `Mixins` | Declares mix-in constraints in a profile | name or names (comma separated) |
| 🚫 `Language` | Declares the language of texts in a localization file | language ISO code |
| `Parent` | Specifies the base class for a profile or extension | name |
| `Profile` | Introduces a new profile | name |
| 🚧 `Severity` | error, warning, or guideline in invariant | code |
| 🚧 `Slice` | Introduces a new slice | name, string |
| 🚫 `Source` | Profile or path a mapping applies to | path |
| 🚫 `Target` | The standard that the mapping maps to | string |
| `Title` | Short human-readable name | string |
| 🚧 `ValueSet` | Declares a new value set | name |
| 🚫 `XPath` | the xpath in invariant | string |
{: .grid }


#### Defining Aliases

Aliases are a convenience measure that allows the user to replace a lengthy url or oid with a short string. By convention, an alias name is written in all capitals. A typical use of an alias is to represent a code system.

Defining an alias is a one-line declaration, as follows:

`Alias: {NAME} = {url or oid}`

**Examples:**

`Alias: SCT = http://snomed.info/sct`

`Alias: RACE = urn:oid:2.16.840.1.113883.6.238`

#### Defining Profiles

To define a profile, the keywords `Profile`, `Parent` are required, and `Id`, `Title`, and `Description` should be used. The keyword `Mixins` is optional.

**Example:**

* Define a profile for USCorePatient:

```
  Profile:        USCorePatient
  Parent:         Patient
  Id:             us-core-patient
  Title:          "US Core Patient Profile"
  Description:    "Defines constraints and extensions on the patient resource for the minimal set of data to query and retrieve patient demographic information."
```
Any rules defined for the profiles would follow immediately after the keyword section.

##### 🚫 Mixins
Mixins have the ability to take rules defined in one class and apply them to a compatible class. The rules are copied from the source class at compile time. Although there can only be one `Parent` class, there can be multiple `Mixins`.

Each mixin class must be compatible parent class, in the sense that all the extensions and constraints defined in the mixin class apply to elements actually present in the Parent class. The legality of a mixin is checked at compile time, with an error signaled if the mixin class is not compatible with the parent class. For example, an error would signalled if there was an attempt to mix a Condition into an Observation.

At present, mixin classes must be defined in FSH. The capability for mixing in externally-defined classes is under development.

**Example:** 

* Defining two national IGs, both based on the same BreastRadiologyProfile:

```
  Profile: USCoreBreastRadiologyProfile
  Parent: BreastRadiologyProfile
  Mixins:  USCoreObservation

  Profile: FranceBreastRadiologyProfile
  Parent: BreastRadiologyProfile
  Mixins: FranceCoreObservation
```

> **IMPORTANT**: To be a valid mixin, the mixin cannot inherit from a different resource.

#### 🚧 Defining Slices

We saw earlier how to use `contains` rules and constraints to [define inline slices](#step-2-defining-slice-contents). Alternatively, it might be clearer to define each slice as an independent, modular entity. Defining slices outside a particular profile also allows the slices to be reused in multiple contexts.

The syntax for defining a slice is the same as for FSH profiles, except that the initial keyword is `Slice` and the SD escape (^) cannot be used, since slices do not have separate SDs.

**Example** 

* Define the slices for a BloodPressure profile:

```
  Slice:     SystolicBP
  Parent:    Observation.component
  Description: "The blood pressure during left ventricle contraction"
  * code = LNC#8480-6 "Systolic blood pressure"
  * value[x] only Quantity
  * valueQuantity units = UCUM#mm[Hg] "mmHg"

  Slice:    DiastolicBP
  Parent:   Observation.component
  Description: "The blood pressure when the heart rests between beats"
  * code = LNC#8462-4 "Diastolic blood pressure"
  * value[x] only Quantity
  * valueQuantity units = UCUM#mm[Hg] "mmHg"
```

Note that since Observation.component is a BackboneElement, the example above must use the path `Observation.component` for the `Parent` value. It is also possible to specify a FHIR complex data type as the value for `Parent`.  This would allow the slice to be used wherever there is an array of that type.  For example:

```
Slice:    NPI
Parent:   Identifier
Description: "The U.S. National Provider Identifier (NPI)"
* system = http://hl7.org/fhir/sid/us-npi
```

#### Defining Extensions

Defining extensions is similar to defining a profile, except that the parent of extension is not required. Extensions can also inherit from other extensions, but if the `Parent` keyword is omitted, the parent is assumed to be FHIR's [Extension element](https://www.hl7.org/fhir/extensibility.html#extension). 

> **Note:** All extensions have the same structure, but extensions can either have a value (i.e. a value[x] element) or sub-extensions, but not both. To create a complex extension, the extension array of the extension must be sliced (see example, below).

**Example:** 

* Define a simple (non-nested) extension for BirthSex, whose data type is `code`:

```
Extension: USCoreBirthSexExtension
Id:   us-core-birthsex
Title:  "US Core Birth Sex Extension"
Description: "A code classifying the person's sex assigned at birth"
// publisher, contact, and other metadata here using caret (^) syntax (omitted)
* value[x] only code
* valueCode from BirthSexValueSet (required)
```

* Define a complex extension (extension with nested extensions) for US Core Ethnicity:

```
  Extension:      USCoreEthnicityExtension
  Id:             us-core-ethnicity
  Title:          "US Core Ethnicity Extension"
  Description:    "Concepts classifying the person into a named category of humans sharing common history, traits, geographical origin or nationality. "
  * extension contains
      ombCategory 0..1 MS and
      detailed 0..* and
      text 1..1 MS
  // inline definition of sub-extensions
  * extension[ombCategory] ^short = "Hispanic or Latino|Not Hispanic or Latino"
  * extension[ombCategory].value[x] only Coding
  * extension[ombCategory].valueCoding from OmbEthnicityCategories (required)
  * extension[detailed] ^short = "Extended ethnicity codes"
  * extension[detailed].value[x] only Coding
  * extension[detailed].valueCoding from DetailedEthnicity (required)
  * extension[text] ^short = "Ethnicity text"
  * extension[text].value[x] only string
```

* Define an extension with an explicit parent, specializing the US Core Birth Sex extension:

```
  Extension:      BinaryBirthSexExtension
  Parent:         USCoreBirthSexExtension
  Id:             binary-birthsex
  Title:          "Binary Birth Sex Extension"
  Description:     "As of 2019, certain US states only allow M or F on birth certificates."
  * valueCode from BinaryBirthSex (required)
```

#### 🚫 Defining Mappings

[Mappings to other standards](https://www.hl7.org/fhir/mappings.html) are an optional part of a SD. These mappings are informative and are provided to help implementers understand the content of the SD and use the profile or resource correctly. While it is possible for profile authors to include mappings using escape syntax, FSH provides a more modular approach.

> **Note:** The informational mappings in SDs should not be confused with functional mappings provided by [FHIR Mapping Language](https://www.hl7.org/fhir/mapping-language.html) and the [StructureMap resource](https://www.hl7.org/fhir/structuremap.html).

To create a mapping, the keywords `Mapping`, `Source`, `Target` and `Id` are used. Any number of [mapping rules](#mapping-rules) then follow.

**Example:** 
```
  Mapping:  USCorePatientToArgonaut
  Source:   USCorePatient
  Target:   "http://unknown.org/Argonaut-DQ-DSTU2"
  Id:       argonaut-dq-dstu2
  * -> Patient
  * extension[USCoreRaceExtension] -> "extension[http://fhir.org/guides/argonaut/StructureDefinition/argo-race]"
  * extension[USCoreEthnicityExtension] -> "extension[http://fhir.org/guides/argonaut/StructureDefinition/argo-ethnicity]"
  * extension[USCoreBirthSexExtension] -> "extension[http://fhir.org/guides/argonaut/StructureDefinition/argo-birthsex]"
  * identifier -> "identifier"
  * identifier.system -> "identifier.system"
  * identifier.value -> "identifier.value"
```

#### 🚫 Defining Mixins

Mixins are defined by using the keywords `Mixin`, `Parent`, and `Description`.

**Example:** 

* Defining a mixin for metadata shared in all US Core profiles:

```
  Mixin: USCoreMetadata
  Parent: DomainResource
  * ^version = "3.1.0"
  * ^status = #active
  * ^experimental = false
  * ^publisher = "HL7 US Realm Steering Committee"
  * ^contact.telecom.system = #url
  * ^contact.telecom.value = "http://www.healthit.gov"
  * ^jurisdiction.coding = COUNTRY#US "United States of America"
```

#### 🚧 Defining Invariants

Invariants are defined using the keywords `Invariant`, `Id`, `Description`, `Expression`, `Severity`, and `XPath`. An invariant definition does not have any rules.

**Example:**
```
Invariant:  USCoreNameInvariant
Id:         us-core-8
Definition: "Patient.name.given  or Patient.name.family or both SHALL be present"
Expression: "family.exists() or given.exists()"
Severity:   "error"
XPath:      "f:given or f:family"
```

> **Note:** The Invariant is incorporated into a profile via `obeys` rules explained [above](#invariant-rules).

#### 👶 Defining Instances

Instances are defined using the keywords `Instance`, `InstanceOf`, `Description`, and `Title`. The `InstanceOf` is required, and plays a role analogous to the `Parent` in profiles. The value of `InstanceOf` can be the name of a profile defined in FSH, or a canonical URL if defined externally.

Instances inherit structures and values from their StructureDefinition (i.e. fixed codes, extensions). Fixed value rules are used to set additional values.

**Examples:** 
```
Instance:   EveAnyperson
InstanceOf: http://hl7.org/fhir/us/core/StructureDefinition/us-core-patient
Title:      "Eve Anyperson"
Description: "Example of US Core Patient"
* name.given = "Eve"
* name.given[1] = "Steve"
* name.family = "Anyperson"
* birthDate = 1960-04-25
* us-core-race.ombCategory.valueCoding = RACE#2106-3 "White"
* us-core-ethnicity.ombCategory.valueCoding = RACE#21865 "Non Hispanic or Latino"
```

```
Instance:   DrDavidAnydoc
InstanceOf: http://hl7.org/fhir/us/core/StructureDefinition/us-core-practitioner
Title:      "Dr. David Anydoc"
Description: "Example of US Core Practitioner"
* name[0].family = Anydoc
* name[0].given[0] = David
* name[0].suffix[0] = MD
* identifier[NPI].value = 8274017284
```

```
Instance:   PrimaryCancerDiagnosis
InstanceOf: http://hl7.org/fhir/us/mcode/StructureDefinition/onco-core-PrimaryCancerCondition
Title:      "Primary Cancer Diagnosis"
* subject = EveAnyperson
* clinicalStatus = #active
* verificationStatus = #confirmed
* category = CCAT#problem-list-item
* asserter = DrDavidAnydoc
* condition-assertedDate.valueDateTime = 2019-09-13T12:30:00.0Z
* onco-core-HistologyMorphologyBehavior-extension.valueCodeableConcept = SCT#35917007 "Adenocarcinoma, no subtype"
* code = SCT#93864006 "Primary malignant neoplasm of lower lobe of left lung"
```

#### 👶 Defining Value Sets

A value set is a group of coded values, usually representing the acceptable values in a FHIR element whose data type is code, Coding, or CodeableConcept.

Value sets are defined using the keywords `ValueSet`, `Title` and `Description`.

Codes must be taken from one or more terminology systems (also called code systems or vocabularies), and cannot be defined inside a value set. If necessary, [you can define your own code system](#defining-code-systems).

The contents of a value set are defined by a set of rules. There are four types of rules to populate a value set:

| To include... | Syntax | Example |
|-------|---------|----------|
| A single code | `* {Coding}` | `* SCT#961000205106 "Wearing street clothes, no shoes"` |
| All codes from a value set | `* codes from valueset {Id}` | `* codes from valueset http://hl7.org/fhir/ValueSet/data-absent-reason` |
| All codes from a code system | `* codes from system {Id}` | `* codes from system http://snomed.info/sct` |
| Selected codes from a code system | `* codes from system {Id} where {filter} and {filter} and ...` | `* codes from system SCT where code descendent-of SCT#254837009` |
{: .grid }

See [below](#filters) for discussion of filters. 

> **Note:** `Id` can be a FSH name, alias or URL.

Analogous rules can be used to leave out certain codes, with the addition of the word `exclude`:

| To exclude... | Syntax | Example |
|-------|---------|----------|
| A single code | `* exclude {Coding}` | `* exclude SCT#961000205106 "Wearing street clothes, no shoes"` |
| All codes from a value set | `* exclude codes from valueset {Id}` | `* exclude codes from valueset http://hl7.org/fhir/ValueSet/data-absent-reason` |
| All codes from a code system | `* exclude codes from system {Id}` | `* exclude codes from system http://snomed.info/sct` |
| Selected codes from a code system | `* exclude codes from system {Id} where {filter}` | `* codes from system SCT where code descendent-of SCT#254837009` |
{: .grid }

##### Filters

A filter is a logical statement in the form {property} {operator} {value}, where operator is chosen from [a value set](http://hl7.org/fhir/ValueSet/filter-operator) containing the values:

`is-a | descendent-of | is-not-a | regex | in | not-in | generalizes | exists`

Not all operators are valid for any code system. The `property` and `value` are dependent on the code system. For choices for the most common code systems, see the [FHIR documentation on filters]( http://hl7.org/fhir/valueset.html#csnote).


**Examples** 

* Explicit ([extensional](https://www.hl7.org/fhir/valueset.html#int-ext)) value set:

```
  ValueSet:    BodyWeightPreconditionVS
  Title: "Body weight preconditions."
  Description:  "Circumstances for body weight measurement."
  * SCT#971000205103 "Wearing street clothes with shoes"
  * SCT#961000205106 "Wearing street clothes, no shoes"
  * SCT#951000205108 "Wearing underwear or less"
```

* Algorithmically-defined ([intensional](https://www.hl7.org/fhir/valueset.html#int-ext))  value set

```
  ValueSet:       PrimaryCancerDisorderVS
  Title: "Primary Cancer Disorder Value Set"
  Description:    "Types of primary malignant neoplastic disease."
  SCT#363346000  "Malignant neoplastic disease (disorder)"
  * codes from system SCT where code descendent-of SCT#363346000 "Malignant neoplastic disease (disorder)"
  * exclude codes from system SCT where code descendent-of SCT#128462008 "Secondary malignant neoplastic disease"
```


#### 👶 Defining Code Systems

It is usually unnecessary to define code systems (also called terminologies or vocabularies) in FSH. However, FSH does allow definition of local codes inside an IG that are not drawn from an external code system. Defining codes inside an IG is not recommended, since those codes will not be part of any recognized terminology system. However, when existing vocabularies do not contain necessary codes, it may be necessary to define them -- and when defining new local codes, you must define them in the context of a code system.

Creating a code system uses the keywords `CodeSystem`, `Title` and `Description`. Codes are added, one per rule, using the almost same syntax as in value sets, except that the code system is not included before the hash sign `#`. Additional properties of a code can be added using the escape (caret) syntax.

**Example:**:

```
CodeSystem:  YogaCodeSystem
Title: "Yoga Code System."
Description:  "A vocabulary of yoga-related terms."
* #Sirsasana "Headstand"
* #Sarvangasana "Shoulder stand"
* #Halasana "Plough Pose"
* #Matsyasana "Fish Pose"
* #Pachimotanasa "Sitting Forward Bend"
* #Bhujangasana "Cobra Pose"
* #Salabhasana "Locust Pose"
* #Dhanurasana "Bow Pose"

* concept[Sirsasana] ^definition "An inverted asana, also called mudra in classical hatha yoga."

```
> **Note:** FSH does not support definition of relationships between local codes, such as parent-child (is-a) relationships.
