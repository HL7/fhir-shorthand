# FHIR Shorthand Reference Manual

## Table of Contents

[TOC]

***

## Introduction

FHIR Shorthand (FSH) is a domain-specific language (DSL) for defining the content of FHIR Implementation Guides (IG). It is simple and compact, with tools to produce [Health Level Seven (HL7®) Fast Healthcare Interoperability Resources (FHIR®)](https://www.hl7.org/fhir/overview.html) profiles, extensions and implementation guides (IG). Because it is written in text statements, FHIR Shorthand encourages distributed, team-based development using conventional source code control tools such as Github.

> **NOTE**: HL7® and FHIR® are registered trademarks owned by Health Level Seven International, and are registered with the United States Patent and Trademark Office.

### Purpose

This reference manual is a comprehensive guide to the syntax of FHIR Shorthand.

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

## Basics

### Versions

The FSH specification, like other IGs, follows the [semantic versioning](https://semver.org) convention (MAJOR.MINOR.PATCH):

* MAJOR: A major release has significant new functionality and potentially, grammar changes or other non-backward-compatible changes.
* MINOR: Contains new or modified features, while maintaining backwards compatibility within the major version.
* PATCH: Contains minor updates and bug fixes, while maintaining backwards compatibility within the major version.

For a full change log, see the [FHIR Shorthand Release Notes](_#missing link_).

### File Types and FSH Tanks

Information in FSH is stored in files with _.fsh_ extension. How information is divided between files is up to the user. You might put value sets in one file, profiles into another, extensions in another, etc. Or, you can put all items related to a single topic in a single file, grouping related profiles, extensions, invariants, and examples. It's up to you.

A **FSH Tank** is a folder that contains FSH files. A FSH Tank corresponds one-to-one to an IG and represents a complete module that can be placed under SCC. The contents of the IG (the profiles, extensions, value sets, examples, search parameters, and operations to be included) are determined by the contents of the directory/folder that contains the Configuration file. Anything else is "external" and must be declared in dependencies.

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

### Reserved Words

FSH has a number of reserved words and phrases that are part of FSH's grammar (e.g., `boolean`, `or`, `from`, `maps to`). For a complete list of reserved words, refer to the [ANTLR4 grammar](_#missing link_).

### Primitives

The primitive types and associated value formats in FSH are identical to the [primitive types and value formats in FHIR](https://www.hl7.org/fhir/datatypes.html#primitive).

### Coded Types

FSH provides shorthand notation for expressing coded types. FHIR coded types include code, Coding, CodeableConcept, and Quantity (units).

#### code

Codes are denoted with # sign. The shorthand is:

`#{code}`

**Example:**

  `* verificationStatus = #confirmed`

#### Coding

The shorthand for Coding is:

`{system}#{code} "{display text}"`

The code system `{system}` can be a URL, OID, or alias for a canonical URI that represents a code system. Aliases must be declared in the file header using the `Alias` keyword.

Examples:

  `SCT#363346000 "Malignant neoplastic disease (disorder)"`

  `http://snomed.info/sct#363346000 "Malignant neoplastic disease (disorder)"`

  `ICD10CM#C004  "Malignant neoplasm of lower lip, inner aspect"`

To set the less-common properties of a Coding:

  `myCoding.userSelected = true`

#### Code System Version

For code systems that encode the version separately from the URL, the version can be specified either using the `version` element of Coding, or using the vertical bar syntax (the same approach used in the `canonical` data type in FHIR):

`myCoding.version = "1.0.2"`

`ANYSYSTEM|1.0.2#C1234 "A version-specific code"`

### CodeableConcept

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

A FHIR Quantity can be bound to a value set or set to a fixed codes. The binding or coded value is interpreted as the units of that Quantity. Because this is counter-intuitive, Shorthand uses the reserved word `units`, as follows:

`* {Quantity type} units from {value set}`

`* {Quantity type} units = {system}#{code} "{display text}"`

`* {Quantity type} units = '{Any UCUM unit}'`
>**NOTE:** Unified Code for Units of Measure (UCUM) is implicit when single quotes are used

For example:

`* valueQuantity units from http://hl7.org/fhir/ValueSet/distance-units`

`* valueQuantity units = http://unitsofmeasure.org#mm "millimeters"`

`* valueQuantity units = 'mm'`  

### Keywords

Keywords are used to make declarations that introduce new items, such as profiles and instances. Keywords always appear at the beginning of a declaration statement and are followed by a colon and the value assigned to the keyword: 

`{Keyword}: {value}`

For example:

`Profile: SecondaryCancerCondition`

`Description: "The intent of the treatment"`

The following is a summary of keywords in FSH:


| Keyword | Purpose | Type |
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

## Paths

Path grammar allows you to refer to any element of a profile, extension, or profile, regardless of nesting. Paths also provide a grammar for addressing elements of a SD directly. This section outlines FSH path grammar, used to specify constraints and more.

Here are a few examples of how paths are be used in FSH:

* To refer to a nested element, such as method.text in Observation
* To address a particular item in a list or array
* To refer to individual elements inside choice elements (e.g., `onsetAge` in `onset[x]`)
* To pick out an individual item within a multiple choice reference, such as `Observation` in `Reference(Observation | Condition)`
* To refer to an individual slice within a sliced array, such as the `SystolicBP`component within a blood pressure
* To set metadata elements in SD, like StructureDefinition.active
* To address elements of ElementDefinitions associated with a SD, such as `maxLength` property of string elements

### Simple Nested Properties

To refer to nested properties, the path lists the properties in order, separated by a dot (.) 

For example, `Observation` has a `method` property, and `method` (a CodeableConcept) has a `text` property, then the path is `method.text`:

`* method.text = "Laparoscopy"`

In this example, the root `Observation` is inferred from the context and not a formal part of the path. In this way, it differs from the `path` found in StructureDefinition elements.

> **NOTE:** It is not possible to cross reference boundaries when profiling (except for slice discriminators, which may `resolve()` references). This means that when a path gets to a _Reference_ type, that path cannot be nested any further.  For example, if `Procedure` has a `subject`, and `subject` is a `Reference` to a `Patient` which has a `gender` property, then `Procedure.subject` is a valid path, but `Procedure.subject.gender` is not, because it crosses into the Patient reference.

### Array/List Properties

If a property allows more than one value (e.g., `0..*`), then it must be possible to address each individual value. This is mainly necessary when creating instances, but may be needed in other contexts as well. FSH denotes this with square brackets (`[` `]`) containing the **0-based** index of the item (e.g., first item is `[0]`, second item is `[1]`, etc.).

If the index is omitted, the first element of the array (`[0]`) is assumed. 

**Example:** Set a Patient's first name's second given name to "Marie":

`* name[0].given[1] = "Marie"`

or:

`* name.given[1] = "Marie"`

since the zero index is assumed when omitted.

### Type Choices ([x])

Addressing a type from a choice of types replaces the `[x]` in the property name with the type name (while also capitalizing the first letter). This follows the approach used in FHIR JSON and XML serialization.

**Example:** Fix value[x] string property to "Hello World"

`* valueString = "Hello World"`

### Profiled Type Choices

In some cases, a type may be constrained to a set of possible profiles. To address a specific profile on that type, follow the path with square brackets (`[` `]`) containing the profile's `name`, `id`, or `url`.

**Example:** In an instance, set the address.state property to the code for Massachusetts (assumes the address type indicates several profiles, one being USAddress)

`* address[USAddress].state = UspsTwoLetterAlphabeticCodes#MA`

> **NOTE:** The example above assumes the context of an instance.  If we were trying to constrain the `state` only in the `USAddress` profile (and other profiles of `Address` were possible), then this would actually be slicing -- and slicing syntax should be used.

### Reference with Multiple Targets

Frequently in FHIR, an element has a `Reference` that has multiple targets. To address a specific target, follow the path with square brackets (`[` `]`) containing the target type (or the profile's `name`, `id`, or `url`).

**Example:** Restrict Practitioner to PrimaryCareProvider in a profile, assuming `performer` is type   `Reference(Organization | Practitioner)`:

`* performer[Practitioner] only PrimaryCareProvider`

### Sliced Array/List

FHIR allows lists to be compartmentalized into sublists called "slices".  For example, the `Observation.component` list in a profile for Apgar score might have a RespiratoryScore component slice and a Appearance component slice, among others.  To address a specific slice, follow the path with square brackets (`[` `]`) containing the slice name.  To access a slice of a slice (i.e., _reslicing_), follow the first pair of brackets with a second pair containing the resliced slice name.

**Example:** Fix the code in an existing slice on Observation.component called `RespiratoryScore`:

`* component[RespiratoryScore].code = SCT#24388001 "Apgar score 5 (finding)"`

**Example:** If the Apgar RespiratoryScore has been resliced to represent the 1, 5 and 10 minute scores:

`* component[RespiratoryScore][FiveMinute].code = SCT#13323003 "Apgar score 7 (finding)"`

### Extensions and ModifierExtensions

Extensions are arrays that are populated by slicing. They addressed using the slice path syntax presented above. However, extensions being very common in FHIR, FSH supports a compact syntax for paths that involve extensions. The compact syntax drops `extension[ ]` or `modifierExtension[ ]` (similar to the way the `[0]` index can be dropped). The only time this is not allowed is when dropping these terms creates a naming conflict.

An example of the full path syntax for the race extension within US Core Patient:

* extension[us-core-race].extension[ombCategory][0].valueCoding = RACE#2028-9 "Asian"

The compact syntax for the same path is:

* us-core-race.ombCategory.valueCoding = OMB#2028-9 "Asian"

### Structure Definition Attributes

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

## Rules

Rules are the mechanism for constraining a profile, defining an extension, slice, or other item. There are several different types of rules, with different syntax. The unique distinguishing feature of a rule is that it begins with an asterisk:

`* {rule statement}`

### Rule Summary

| Rule Type | Rule Syntax | Example |
| --- | --- |---|
| Fixed Value |`* {path} = {value}`  | `* experimental = true` <br/> `* status = #active` <br/> `* valueString = "foo"` <br/> `* valueQuantity.value = 1.23` |
| Binding to a Value Set |`* {path} from {valueSet} ({strength})`| `* telecom.system from http://hl7.org/fhir/ValueSet/contact-point-system (required)` |
| Narrowing a choice | `* {path} only {type1} or {type2} or {type3}` | `* value[x] only code` <br/> `* value[x] only code or string` |
| Narrowing a reference choice | `* {path} only Reference({type1} | {type2} | {type3})` | `* subject only Reference(Patient)` <br/> `* basedOn only Reference(MedicationRequest | ServiceRequest)` |
| Narrowing cardinality | `* {path} {min}..{max}` | `* identifier 1..*` <br/> `* identifier.system 1..1`
| Assigning Flags (MS, SU, ?!) | `* {path1} {flag1} {flag2}` <br/> `* {path1}, {path2}, {path3} {flag}` | `* communication MS ?!` <br> `* identifier, identifier.system, identifier.value, name, name.family MS`

### Rule Semantics

Rules must be legal from a FHIR point of view. For example, if you apply a rule to further constrain a cardinality that is 0..1 in a parent class, the only legal choices are 0..0 or 1..1. An example of an illegal rule would be one that changes the strength of a value set binding from `required` to `extensible`. Profiling rules are [defined by FHIR](http://www.hl7.org/fhiR/profiling.html), not FSH.

Semantic errors are caught when the FSH file is processed by a valid FSH compiler, such as SUSHI.

