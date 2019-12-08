# FHIR Shorthand Reference Manual

## Table of Contents

[TOC]

***

## About this Document

### Purpose

This Implementation Guide describes the syntax of FHIR Shorthand. FSH is formally defined by an ANTLR4 grammar (_#missing link_). A reference implementation of a FSH interpreter/compiler, called SUSHI, is available.

### Intended Audience

The reference manual is targeted to people doing IG development using FSH. Familiarity with FHIR is helpful as the manual references various FHIR concepts (profiles, extensions, value sets, etc.)

### Prerequisite

This guide assumes you have:

* A text editor to create your FSH files (preferably VSCode with the _vscode-language-fsh_ extension, but not required).
* Reviewed the [FHIR Shorthand Tutorial](tutorial.md).

### Document Conventions

| Style | Explanation | Example |
|:----------|:------|:---------|
| `Code` | Code fragments, such as commands and FSH statements  | `* status = #open` |
| _italics_ | File names | _example-1.fsh_ |
| {curly braces} | An item to be substituted | `{codesystem}#{code}` |
| **bold** | Emphasis |  Do **not** fold, spindle or mutilate. |

## Introduction

FHIR Shorthand (FSH) is a domain-specific language (DSL) for defining the content of FHIR Implementation Guides (IG). It is simple and compact, with tools to produce [Health Level Seven (HL7®) Fast Healthcare Interoperability Resources (FHIR®)](https://www.hl7.org/fhir/overview.html) profiles, extensions and implementation guides (IG). Because it is written in text statements, FHIR Shorthand encourages distributed, team-based development using conventional source code control tools such as Github.

> **NOTE**: HL7® and FHIR® are registered trademarks owned by Health Level Seven International, and are registered with the United States Patent and Trademark Office.

### Motivations for FHIR Shorthand

1)	The FHIR community needs scalable, fast, and user-friendly tools for IG creation and maintenance. Profiling projects are difficult and slow, and the resulting IG quality is inconsistent.
1)	As a user-facing format, StructureDefinitions (SDs) are complex and unwieldy.
1)	Available tools (Forge, Trifolia-on-FHIR, Excel spreadsheets) improve this situation, but still have drawbacks:
    1) Although the tools provide a friendlier interface, the user must still understand many SD details.
    1) The tools are not particularly agile when it comes to refactoring.
    1) Source code control (SCC) system features such as version-to-version differences and merging changes are not well supported.
1) It can be difficult make sense of the Profile pages in IGs ([see this example from the September 2019 ballot](http://hl7.org/fhir/us/breast-radiology/2019Sep/StructureDefinition-breastrad-BreastRadiologyDocument.html)). FSH compiles to SD, but FSH itself is clearer and more compact and could represent the snapshot and differential.
1) Experience has proven that creating and maintaining complex software projects is best approached with textual languages. As a DSL designed for the job of profiling and IG creation, FSH is concise, understandable, and aligned to user intentions.
1) FSH is ideal for SCC, with meaningful version-to-version differentials, support for merging and conflict resolution, and refactoring through global search/replace operations. These features allow FSH to scale in ways that other approaches cannot.

### Benefits of FHIR Shorthand

* Agile -- rapid refactoring and revision cycles
* Readable and easy to understand
* Makes the author’s intent clear
* Reduces implementation errors
* Enforces consistency in SDs (compiling FSH into SD using consistent patterns)
* Provides meaningful differentials in SCC
* Enables merging at the statement/line-level in SCC
* Supports distributed development under SCC
* Any text editor can be used to modify an FSH file, but editing environments such as VS Code and Notepad++ can provide text colorization, look-ahead syntax, go-to-definition, etc.

### Versioning

The FSH specification, like other IGs, follows the [semantic versioning](https://semver.org) convention (MAJOR.MINOR.PATCH):

* MAJOR: A major release has significant new functionality and potentially, grammar changes or other non-backward-compatible changes.
* MINOR: Contains new or modified features, while maintaining backwards compatibility within the major version.
* PATCH: Contains minor updates and bug fixes, while maintaining backwards compatibility within the major version.

For a full change log, see the [FHIR Shorthand Release Notes](_#missing link_).

### File Types and FSH Tanks

Information in FSH is stored in plain text files with _.fsh_ extension. How information is divided between files is up to the user. One approach is to put value sets in one file, profiles into another, extensions in another, etc. Another approach is to put all items related to a single topic in a single file, grouping related profiles, extensions, invariants, and examples. Either approach, or one of your own making, will work.

A **FSH Tank** is a folder that contains FSH files. A FSH Tank corresponds one-to-one to an IG and represents a complete module that can be placed under SCC. The contents of the IG (the profiles, extensions, value sets, examples, search parameters, and operations to be included) are determined by the contents of the directory/folder that contains the Configuration file. Anything else is "external" and must be declared in dependencies.



## Language Elements

### Formal Grammar

FSH is defined formally in an ANTLR4 grammar.  [ANTLR4 grammar](#missing link).

### Reserved Words

FSH has a number of reserved words and phrases that are part of FSH's grammar (e.g., `boolean`, `or`, `from`, `contains`, `obeys`). For a complete list of reserved words, refer to the [ANTLR4 grammar](_#missing link_).

### Primitives

The primitive data types and associated value formats in FSH are identical to the [primitive types and value formats in FHIR](https://www.hl7.org/fhir/datatypes.html#primitive).

FSH introduces one additional type, name, used in declaring new items and referring to them within the context of FSH. A name is an unquoted text that begins with an upper case letter, and does not contain special characters other than - and _.  _Is this correct_?

### Whitespace

Repeated whitespace is not meaningful within FSH files. This:

```
Profile:  SecondaryCancerCondition
Parent:   CancerCondition
* focus only PrimaryCancerCondition
```

is equivalent to:

```
Profile:  
    SecondaryCancerCondition
    Parent:   CancerCondition

    * focus only    PrimaryCancerCondition
```

### Comments

FSH follows [JavaScript syntax](https://www.w3schools.com/js/js_comments.asp) for code comments:

```
// Use a double-slash for comments on a single line

/*
Use slash-asterisk and asterisk-slash for larger block comments.
These comments can take up multiple lines.
*/
```


### Coded Data Types

FSH provides special grammar for expressing coded types. FHIR coded types include code, Coding, CodeableConcept, and Quantity (units).

#### code

Codes are denoted with # sign. The shorthand is:

`#{code}`

**Example:**

  `* verificationStatus = #confirmed`

#### Coding

The shorthand for Coding is:

`{system}#{code} "{display text}"`

The code system `{system}` can be a URL, OID, or alias for a canonical URI that represents a code system. Aliases must be declared in the file header using the `Alias` keyword.

**Examples:**

  `SCT#363346000 "Malignant neoplastic disease (disorder)"`

  `http://snomed.info/sct#363346000 "Malignant neoplastic disease (disorder)"`

  `ICD10CM#C004  "Malignant neoplasm of lower lip, inner aspect"`

To set the less-common properties of a Coding:

  `myCoding.userSelected = true`

For code systems that encode the version separately from the URL, the version can be specified either using the `version` element of Coding, or using the vertical bar syntax (the same approach used in the `canonical` data type in FHIR):

`myCoding.version = "1.0.2"`

`ANYSYSTEM|1.0.2#C1234 "A version-specific code"`

#### CodeableConcept

The Shorthand for a CodeableConcept is similar to that for Coding. For example, to set `Condition.code`:

`* code = SCT#363346000 "Malignant neoplastic disease (disorder)"`

which is interpreted as the first Coding in the CodeableConcept.Coding array:

`* code.coding[0] = SCT#363346000 "Malignant neoplastic disease (disorder)"`

To fix the top-level text of a CodeableConcept, use dot notation:

`* code.text = "diagnosis of malignant neoplasm left breast"`

To specify alternative Codings in Condition.code, specify the array index:

`* code.coding[1] = ICD10#C80.1 "Malignant (primary) neoplasm, unspecified"`

> **Note:** Arrays are zero-based.

#### Quantity

A FHIR Quantity can be bound to a value set or set to a fixed codes. The binding or coded value is interpreted as the units of that Quantity. To make this more intuitive, FSH uses the reserved word `units`, as follows:

`* {Quantity type} units from {value set}`

`* {Quantity type} units = {system}#{code} "{display text}"`

`* {Quantity type} units = '{Any UCUM unit}'`
>**NOTE:** Unified Code for Units of Measure (UCUM) is implicit when single quotes are used

**Examples:**

`* valueQuantity units from http://hl7.org/fhir/ValueSet/distance-units`

`* valueQuantity units = http://unitsofmeasure.org#mm "millimeters"`

`* valueQuantity units = 'mm'`  

### Keywords

Keywords are used to make declarations that introduce new items, such as profiles and instances. Keywords always appear at the beginning of a declaration statement and are followed by a colon and the value assigned to the keyword:

`{Keyword}: {value}`

For example:

`Profile: SecondaryCancerCondition`

`Description: "The intent of the treatment"`

The use of individual keywords is explained in greater detail in the section "Declaring Items in FSH".  (_fix cross-reference_) The following is a summary of keywords in FSH:


| Keyword | Purpose | Data Type |
|----------|---------|---------|
| `Alias`| Defines an alias for a URL or OID | uri, url, or oid  |
| `CodeSystem` | Declares a new code system | name |
| `Description` | Provides a human-readable description | string, markdown |
| `Expression` | The actual computable expression in an invariant |
| `Extension` | Declares a new extension | name |
| `Instance` | Declare a new instance | name |
| `InstanceOf` | The profile or resource an instance instantiates | name |
| `Invariant` | Declares a new invariant | name |
| `Mapping` | Introduces a new mapping | name |
| `Mixin` | Introduces a class only to be used as a mixin (no profile generated) | name |
| `Mixins` | Declares mix-in constraints in a profile | name |
| `Language` | Declares the language of texts in a localization file | language ISO code |
| `Parent` | Specifies the base class for a profile or extension | name |
| `Profile` | Introduces a new profile | name |
| `Severity` | error, warning, or guideline in invariant | code |
| `Slice` | Introduces a new slice | name, string |
| `Source` | Profile or path a mapping applies to | path |
| `Target` | The standard that the mapping maps to | string |
| `Title` | Short human-readable name | string |
| `ValueSet` | Declares a new value set | name, string |
| `XPath` | the xpath in invariant | string |

### Rules

Rules are the mechanism for constraining a profile, defining an extension, creating slices, and more. Rules begin with an asterisk:

`* {rule statement}`

Here is a summary of the rules supported in FSH:

| Rule Type | Rule Syntax | Example |
| --- | --- |---|
| Fixed value |`* {path} = {value}`  | `* experimental = true` <br/> `* status = #active` <br/> `* valueString = "foo"` <br/> `* valueQuantity.value = 1.23` |
| Value set binding |`* {path} from {valueSet} ({strength})`| `* telecom.system from http://hl7.org/fhir/ValueSet/contact-point-system (required)`
| Narrowing cardinality | `* {path} {min}..{max}` | `* identifier 1..*` <br/> `* identifier.system 1..1`
| Data type restriction | `* {path} only {type1} or {type2} or {type3}` | `* value[x] only code` <br/> `* value[x] only code or Quantity` |
| Reference type restriction | `* {path} only Reference({type1} | {type2} | {type3})` | `* subject only Reference(Patient)` <br/> `* basedOn only Reference(MedicationRequest | ServiceRequest)` |
| Flag assignment | `* {path} {flag1} {flag2}` <br/> `* {path1}, {path2}, {path3}... {flag}` | `* communication MS ?!` <br> `* identifier, identifier.system, identifier.value, name, name.family MS`
| Slicing and extensions | `* {array} contains {sliceName1} {card1} and {sliceName2} {card2} ...` | `* component contains SystolicBP 1..1 and DiastolicBP 1..1` |
| Invariants | `* obeys {invariant}` <br/> `* {path} obeys {invariant}` <br/> `* {path1}, {path2}, ... obeys {invariant}` | `* name obeys USCoreNameInvariant` |

#### Fixed Value Rules

Fixed value assignments follow this syntax:

`* {path} = {value}`

The left side of the expression follows the [FSH path grammar](#Paths). The value have a data type aligned with the last element in the path.

Assignment of coded types can use the [shorthand for coded data types](#coded-data-types).

**Examples:**

`* status = #arrived`

`* code = SCT#363346000 "Malignant neoplastic disease (disorder)"`

`* active = true`

`* onsetDateTime = "2019-04-02"` (_are quotes needed?_)

`* valueQuantity = 36.5 'C'`

#### Value Set Binding Rules

Binding is the process of associating a coded element with a set of possible values. The syntax to bind a value set, or alter an inherited binding, uses the reserved word `from`:

`* {path} from {valueSet} ({strength})`

The value set can be the name of a value set defined in the same FSH tank, or the defining URL of an external value set that is part of the core FHIR spec, or an IG that has been declared a dependency in the package.json file.

The strengths are the same as the [binding strengths defined in FHIR](https://www.hl7.org/fhir/valueset-binding-strength.html), namely: `example`, `preferred`, `extensible`, and `required`. If the strength is omitted, the binding is assume to be `required`, by default.

The following rules apply to binding in FSH:

* If no binding strength is specified, the binding is assumed to be `required`.
* When further constraining an existing binding, the binding strength can stay the same or be made tighter (e.g., replacing a `preferred` binding with an `extensible` or `required` binding), but never loosened.
* Constraining may leave the binding strength the same and change the value set instead. However, certain changes permitted in FSH may violate [FHIR profiling principles](http://hl7.org/fhir/R4/profiling.html#binding-strength). In particular, FHIR will permit a `required` value set to be replaced by another `required` value set only if the codes in the new value set are a subset of the codes in the original value set. For `extensible` bindings, the new value set can contain codes not in the existing value set, but additional codes _should not_ have the same meaning as existing codes in the base value set. These constraints are difficult to check, and are not currently enforced by SUSHI.


**Examples**:

`* telecom.system from http://hl7.org/fhir/ValueSet/contact-point-system (required)`

`* gender from http://hl7.org/fhir/ValueSet/administrative-gender`

`* address.state from USPSTwoLetterAlphabeticCodes (extensible)`

#### Cardinality Rules

Cardinality rules constrain the number of repetitions of an element. Every element has a cardinality inherited from its parent resource or profile. If the inheriting profile does not alter the cardinality, no cardinality rule is required.

To change the cardinality, the grammar is:

`* {path} {min}..{max}`

As in FHIR, min and max are integers, and max can be *, representing unbounded.

Cardinalities must follow [rules of FHIR profiling](https://www.hl7.org/fhir/conformance-rules.html#cardinality), namely that the min and max cardinalities must stay within the constraints of the parent.

**Examples:**

`* subject 1..1`

`* component.referenceRange 0..0`

#### Data Type Restriction Rules



#### Reference Type Restriction Rules



#### Flag Assignment Rules

Flags are a set of information about the element that impacts how implementers handle them. The [flags defined in FHIR](http://hl7.org/fhir/R4/formats.html#table), and the symbols used to describe them, as as follows:

| FHIR Flag | FSH Flag | Meaning |
|------|-----|----|
| S | MS  | Must Support |
| &#931;  | SU  | Include in summary |
| ?! | ?! | Modifier |

The flags I, NE, TU, N, and D are currently not supported by FSH.

The following syntax can be used to assigning flags:

`* {path} {flag1} {flag2} ...`

`* {path1}, {path2}, {path3}... {flag}`

**Examples:**

`* communication MS ?!`

`* identifier, identifier.system, identifier.value, name, name.family MS`

#### Slicing and Extension Rules



#### Invariant Rules

[Invariants](https://www.hl7.org/fhir/conformance-rules.html#constraints) are constraints that apply to one or more values in instances, expressed as [FHIRPath expressions](https://www.hl7.org/fhir/fhirpath.html). An invariant can apply to an instance as a whole, a single element, or multiple elements. The FSH grammars for applying invariants in profiles are as follows:

`* obeys {invariant}`

`* {path} obeys {invariant}`

`* {path1}, {path2}, ... obeys {invariant}`

The first case is where the invariant applies to the profile as a whole. The second is where the invariant applies to a single element, and the third is where the invariant applies to multiple elements.

The referenced invariant and its properties must be declared somewhere within the same FSH tank, using the `Invariant` keyword. See [Defining Invariants](#defining-invariants).

Examples:

`* name obeys USCoreNameInvariant`



## Paths

Path grammar allows you to refer to any element of a profile, extension, or profile, regardless of nesting. Paths also provide a grammar for addressing elements of a SD directly. This section outlines FSH path grammar, used to specify constraints and more.

Here are a few examples of how paths are used in FSH:

* To refer to a nested element, such as method.text in Observation
* To address a particular item in a list or array
* To refer to individual elements inside choice elements (e.g., `onsetAge` in `onset[x]`)
* To pick out an individual item within a multiple choice reference, such as `Observation` in `Reference(Observation | Condition)`
* To refer to an individual slice within a sliced array, such as the `SystolicBP`component within a blood pressure
* To set metadata elements in SD, like StructureDefinition.active
* To address elements of ElementDefinitions associated with a SD, such as `maxLength` property of string elements

### Nested Property Paths

To refer to simple or nested properties, the path lists the properties in order, separated by a dot (.) 

For example, `Observation` has a `method` property, and `method` (a CodeableConcept) has a `text` property, then the path is `method.text`:

`* method.text = "Laparoscopy"`

In this example, the root `Observation` is inferred from the context and not a formal part of the path. In this way, it differs from the `path` found in StructureDefinition elements.

> **NOTE:** It is not possible to cross reference boundaries when profiling (except for slice discriminators, which may `resolve()` references). This means that when a path gets to a _Reference_ type, that path cannot be nested any further.  For example, if `Procedure` has a `subject`, and `subject` is a `Reference` to a `Patient` which has a `gender` property, then `Procedure.subject` is a valid path, but `Procedure.subject.gender` is not, because it crosses into the Patient reference.

### Array Property Paths

If a property allows more than one value (e.g., `0..*`), then it must be possible to address each individual value. This is mainly necessary when creating instances, but may be needed in other contexts as well. FSH denotes this with square brackets (`[` `]`) containing the **0-based** index of the item (e.g., first item is `[0]`, second item is `[1]`, etc.).

If the index is omitted, the first element of the array (`[0]`) is assumed. 

**Example:** Set a Patient's first name's second given name to "Marie":

`* name[0].given[1] = "Marie"`

or:

`* name.given[1] = "Marie"`

since the zero index is assumed when omitted.

### Data Type Choice ([x]) Paths

Addressing a type from a choice of types replaces the `[x]` in the property name with the type name (while also capitalizing the first letter). This follows the approach used in FHIR JSON and XML serialization.

**Example:** Fix value[x] string property to "Hello World"

`* valueString = "Hello World"`

### Profiled Type Choice Paths

In some cases, a type may be constrained to a set of possible profiles. To address a specific profile on that type, follow the path with square brackets (`[` `]`) containing the profile's `name`, `id`, or `url`.

**Example:** In an instance, set the address.state property to the code for Massachusetts (assumes the address type indicates several profiles, one being USAddress)

`* address[USAddress].state = UspsTwoLetterAlphabeticCodes#MA`

> **NOTE:** The example above assumes the context of an instance.  If we were trying to constrain the `state` only in the `USAddress` profile (and other profiles of `Address` were possible), then this would actually be slicing -- and slicing syntax should be used.

### Reference Paths

Frequently in FHIR, an element has a `Reference` that has multiple targets. To address a specific target, follow the path with square brackets (`[` `]`) containing the target type (or the profile's `name`, `id`, or `url`).

**Example:** Restrict Practitioner to PrimaryCareProvider in a profile, assuming `performer` is type   `Reference(Organization | Practitioner)`:

`* performer[Practitioner] only PrimaryCareProvider`

### Sliced Array/List Paths

FHIR allows lists to be compartmentalized into sublists called "slices".  For example, the `Observation.component` list in a profile for Apgar score might have a RespiratoryScore component slice and a Appearance component slice, among others.  To address a specific slice, follow the path with square brackets (`[` `]`) containing the slice name.  To access a slice of a slice (i.e., _reslicing_), follow the first pair of brackets with a second pair containing the resliced slice name.

**Example:** Fix the code in an existing slice on Observation.component called `RespiratoryScore`:

`* component[RespiratoryScore].code = SCT#24388001 "Apgar score 5 (finding)"`

**Example:** If the Apgar RespiratoryScore has been resliced to represent the 1, 5 and 10 minute scores:

`* component[RespiratoryScore][FiveMinute].code = SCT#13323003 "Apgar score 7 (finding)"`

### Extension Paths

Extensions are arrays populated by slicing. They may be addressed using the slice path syntax presented above. However, extensions being very common in FHIR, FSH supports a compact syntax for paths that involve extensions. The compact syntax drops `extension[ ]` or `modifierExtension[ ]` (similar to the way the `[0]` index can be dropped). The only time this is not allowed is when dropping these terms creates a naming conflict.

**Example:** Explicit path syntax for extensions within US Core Patient:

* extension[us-core-ethnicity].extension[ombCategory].valueCoding = RACE#2135-2 "Hispanic or Latino"
* extension[us-core-ethnicity].extension[detailed][0].valueCoding = RACE#2184-0 "Dominican"
* extension[us-core-ethnicity].extension[detailed][1].valueCoding = RACE#2148-5 "Mexican"
* extension[us-core-ethnicity].extension[text].valueString = "Hispanic or Latino"
* extension[us-core-birthsex].valueCode = #F

**Example:** Abbreviated grammar addressing extensions in US Core Patient:

```
* us-core-ethnicity.ombCategory.valueCoding = RACE#2135-2 "Hispanic or Latino"
* us-core-ethnicity.detailed[0].valueCoding = RACE#2184-0 "Dominican"
* us-core-ethnicity.detailed[1].valueCoding = RACE#2148-5 "Mexican"
* us-core-ethnicity.text.valueString = "Hispanic or Latino"
* us-core-birthsex.valueCode = #F
```

### Structure Definition Paths

FSH uses the carat (^) syntax to provide direct access to any element in StructureDefinition. The carat syntax is the method for setting metadata attributes in SD (attributes not associated with any element). The carat syntax can be combined with non-carat (element) paths to set values in the SD associated with a particular element (see example below).

**Example:** Setting metadata attributes in a profile

```
Profile:        USCorePatient
Parent:         Patient
* ^description = "Defines constraints and extensions on the patient resource for the minimal set of data to query and retrieve patient demographic information."
* ^id = "us-core-patient"
* ^status = #active
* ^experimental = false
```

**Example:** Setting metadata attribute for value set
```
ValueSet:  BirthSex
* ^id = "birthsex"
GEN#F   "Female"
GEN#M   "Male"
NUL#UNK "Unknown"
```

**Example:** Addressing SD attributes in an individual element definition
```
Profile:        USCorePatient
Parent:         Patient
* communication.language ^binding.extension[0].url = "http://hl7.org/fhir/StructureDefinition/elementdefinition-maxValueSet"
```

## Slicing

### "Ginzu" Slicing

* SUSHI will attempt to infer slicing discriminators based on a set of explicit algorithms
  * E.g.,
    1. If all slices have unique `fixed[x]` values at the same path(s), use discriminator type `'value'` and the associated paths
    2. Else if all slices have unique `pattern[x]` values at the same path(s), use discriminator type `'pattern'` and the associated paths
  * TODO: Survey most popular IGs for slicing patterns to derive more algorithms
  * TODO: Determine appropriate defaults for `description`, `ordered`, and `rules`
* If SUSHI cannot infer a slicing discriminator, an error is issued and the author must use escape syntax to fully define the slicing criteria.

For example, if the author specifies two slices on **Observation.component**, `SystolicBP` and `DiastolicBP`, SUSHI can determine that each of those uses a `pattern[x]` on the `code` and that the patterns are unique.  It can then infer that the discriminator should slice by `pattern` at `code`.

> NOTE: The Ginzu algorithm must be documented in the specification so that implementation does not vary.


### Explicit Slicing (Escape Syntax)

This approach uses the proposed escape syntax (`^`).  The author identifies an element from the _profiled resource_ and then traverses the _structure definition_ at that point.

Example:
```
* component[0] ^discriminator[0].type = #pattern
* component[0] ^discriminator[0].path = "code"
* component[0] ^ordered = false
* component[0] ^rules = #open
* component[0] ^description = "Slice based on the component.code pattern"
```

## Specifying Slices

Slices are specified using the `contains` keyword. This approach is used only for creating new slices.
```
* {array} contains {sliceName} {card} and {sliceName2} {card2}
```

Example:
```
* component contains SystolicBP 1..1 and DiastolicBP 1..1
```

Because FSH is white-space invariant, this can be written so the slices appear one-per-line for readability:
```
* component contains
    SystolicBP 1..1 and
    DiastolicBP 1..1
```

### Reslicing

Reslicing uses a similar syntax, but the left-hand side uses [slice path syntax](../2.2-Paths#addressing-individual-slices-from-a-slicing) to refer to the slice that is being resliced:
```
* {array}[{sliceName}] contains {resliceName} {card} // reslice
```

## Slicing Extensions

### Full Grammar

Extensions are created by slicing the extension array that is present at the root level of each resource, in each element, and in each extension.

Extensions can be created by slicing the `extension` (or `modifierExtension`) array, for example:

```
* extension contains 
    USCoreRaceExtension 0..1 MS and 
    USCoreEthnicityExtension 0..1 MS and 
    USCoreBirthsexExtension 0..1 MS
```

## Defining Slice Contents

There are two general approaches to defining the slices themselves:
1. Define the slice details inline in the profile. 
2. Define the slice details in a separate slice definition.

When slicing an array of references, such as Observation.hasMember, the in-line approach can be used to constrain the slice's reference to a specific profile, but that profile must be defined independently using the `Profile:` keyword.

### Definition of Slices: Inline Approach

This approach allows the details to be seen in the context of the whole profile but lacks the reusability of separately defined Slice entities.

After specifying the slices using `contains`, the syntax for inline definition of slices is the same as constraining any other path in a profile, but uses the [slice path syntax](../2.2-Paths#addressing-individual-slices-from-a-slicing) in the path:

```
* component[{sliceName}].{subpath} {constraint}
```

Example:
```
* component contains SystolicBP 1..1 and DiastolicBP 1..1
* component[SystolicBP].code = LNC#8480-6 "Systolic blood pressure"
* component[SystolicBP].value[x] only Quantity
* component[SystolicBP].valueQuantity units = UCUM#mm[Hg] "mmHg"
* component[DiastolicBP].code = LNC#8462-4 "Diastolic blood pressure"
* component[DiastolicBP].value[x] only Quantity
* component[DiastolicBP].valueQuantity units = UCUM#mm[Hg] "mmHg"
```









### Rule Validity

Rules must be valid not only in terms of syntax but also in terms what the rule is trying to accomplish. For example, a rule that constrains cardinality must only narrow the inherited cardinality. An example of an illegal rule would be one that changes the strength of a value set binding from `required` to `extensible`. Rules that apply to profiles are [defined by FHIR](http://www.hl7.org/fhiR/profiling.html).

Another requirement involves data type agreement. Elements in FHIR have a required data type or a choice of data types, and rules that do assignments or further restrict inherited data types must align with those data types.

**Valid Rule:** Restricting `Condition.encounter` that has type `Reference(Encounter))`, given that `InpatientEncounter` is a profile of `Encounter`:

`* encounter only Reference(InpatientEncounter)`

**Valid Rule:** Restricting the type of `Condition.recorder` that has type `Reference(Practitioner | PractitionerRole | Patient | RelatedPerson)`, where `PrimaryCarePhysician` and `EmergencyRoomPhysician` are profiles on `Practitioner`:

`* practitioner only Reference(PrimaryCarePhysician | EmergencyRoomPhysician | PractitionerRole)`

**Invalid Rule**: Restricting the type of [US Core Condition](http://hl7.org/fhir/us/core/StructureDefinition-us-core-condition.html) `subject` that has type `Reference(US Core Patient)`:

`* subject only Reference(Patient) // invalid`

Semantic errors are caught when the FSH file is processed by a valid FSH compiler, such as SUSHI.

## Defining Items in FHIR Shorthand

This section shows how to define various items in FSH:
* Profiles
* Slices
* Extensions
* Value Sets
* Mappings
* Invariants
* Instances

### Defining Profiles

### Defining Slices

In this case, each slice is defined as a separate entity containing the constraint rules. This approach allows the slices to be re-used in other contexts. The syntax follows the same syntax as FSH profiles, except the `Metadata` keyword cannot be used since this is not defining a separate profile, but rather a set of elements to be in-lined in a profile. 

Example (slices declared in the BloodPressure profile as above):
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

Note that since `Observation.component` is a `BackboneElement`, the example above must use the path `Observation.component` for the `Parent` value. It is also possible, however, to specify a FHIR type as the value for `Parent`.  This would allow the slice to be used wherever there is an array of that type.  For example:

```
Slice:    NPI
Parent:   Identifier
Description: "The U.S. National Provider Identifier (NPI)"
* system = http://hl7.org/fhir/sid/us-npi
```
