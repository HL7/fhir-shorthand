# FHIR Shorthand Reference Manual

## Table of Contents

[TOC]

***

## Introduction

FHIR Shorthand (FSH) is a specially-designed language for defining the content of FHIR Implementation Guides (IG). It is simple and compact, with tools to produce [Health Level Seven (HL7®) Fast Healthcare Interoperability Resources (FHIR®)](https://www.hl7.org/fhir/overview.html) profiles, extensions and implementation guides (IG). Because it is a **language**, written in text statements, FHIR Shorthand encourages distributed, team-based development using conventional source code control tools such as Github. FHIR Shorthand provides tooling that enables you to define a model once, and publish that model to multiple versions of FHIR.

> **NOTE**: HL7® and FHIR® are registered trademarks owned by Health Level Seven International, and are registered with the United States Patent and Trademark Office.

### Purpose

This reference manual is a comprehensive guide to the syntax of FSH, used to create an HL7 FHIR IG using SUSHI.

### Intended Audience

The reference manual is targeted to people doing IG development using FSH. Familiarity with FHIR is helpful as the manual references various FHIR concepts (profiles, extensions, value sets, etc.)

### Prerequisite

This guide assumes you have:

* A text editor to create your FSH files (preferably VSCode with the _vscode-language-fsh_ extension, but not required).
* Reviewed the [FHIR Shorthand Tutorial](tutorial.md).

### Document Conventions

| Style | Explanation | Example |
|:----------|:------|:---------|
| `Code` | Code fragments, such as commands and Shorthand statements  | `* status = #open` |
| _italics_ | File names | _example-1.fsh_ |
| {curly braces} | An item to be substituted | `* status = {code}` |
| **bold** | General emphasis |  Do **not** fold, spindle or mutilate. |

## Motivations

1)	The FHIR community needs scalable, fast, and user-friendly tools for IG creation and maintenance. Profiling projects are difficult and slow, and the resulting IG quality is inconsistent.
1)	As a user-facing format, StructureDefinitions (SDs) are complex and unwieldy.
1)	Available tools (Forge, Trifolia-on-FHIR, Excel spreadsheets) improve this situation. These tools share certain characteristics:
    1) Although the tools provide a friendlier interface, the user must still understand many SD details.
    1) The tools are not particularly agile when it comes to refactoring. Cross-cutting revisions happen all the time in non-trivial profiling projects.
    1) Source code control system (SCCS) features such as differentials and merging changes are not well supported. Excel files cannot be effectively diff’ed, and the other tools can be managed in SCCS only as SDs.
1)	It can be difficult make sense of the Profile pages in IGs [see this example from the September 2019 ballot](http://hl7.org/fhir/us/breast-radiology/2019Sep/StructureDefinition-breastrad-BreastRadiologyDocument.html). FSH compiles to SD, but FSH itself is clearer and more compact and could represent the snapshot and differential. 
1)	Many years of experience has proven that creating and maintaining complex software projects is best approached with textual languages. As a DSL designed for the job of profiling, FSH is concise, understandable, and aligned to user intentions. 
1)	FSH is ideal for SCCS, with meaningful differentials, support for merging and conflict resolution, and refactoring through global search/replace operations. These features allow FSH to scale in ways that visual editors and spreadsheets cannot.

## Benefits of FHIR Shorthand

* Agile -- rapid refactoring and revision cycles 
* Readable and easy to understand
* Makes the author’s intent clear
* Reduces implementation errors
* Enforces consistency in SDs (compiling FSH into SD using consistent patterns)
* Provides meaningful differentials in SCCS
* Enables merging at the statement/line-level in SCCS
* Supports distributed development under SCCS
* Any text editor can be used to modify an FSH file, but editing environments such as VS Code and Notepad++ can provide text colorization, look-ahead syntax, go-to-definition, etc.

## Basics
### Versioning

FSH follows the [semantic versioning](https://semver.org) convention (MAJOR.MINOR.PATCH).

* MAJOR: A major release has significant new functionality and potentially, grammar changes or other non-backward-compatible changes.
* MINOR: Contains new or modified features, while maintaining backwards compatibility within the major version.
* PATCH: Contains minor updates and bug fixes, while maintaining backwards compatibility within the major version.

For a full change log, see the [FHIR Shorthand Release Notes](_#missing link_).

### File Types and FSH Tanks

Information in FSH is stored in files with _.fsh_ extension. How information is divided between files is up to the user. You can put everything in one file, or split into multiple files. For example, you might put all value sets in one file, profiles into another, extensions in another, and examples in another. Or, you can put all items related to a single topic in a single file, such as profiles, extensions, invariants, and examples.

A FSH Tank is a folder that contains FSH files. A FSH Tank corresponds 1-to-1 to an IG and represents a complete module that can be placed under source code control. The contents of the IG (the profiles, extensions, value sets, examples, search parameters, and operations to be included) are determined by the contents of the directory/folder that contains the Configuration file. Anything else is "external" and must be declared in dependencies.

### Whitespace

Repeated whitespace is not meaningful within CIMPL files. This:

```
Grammar:    DataElement 6.0
Namespace:  myExampleNamespace
```

is equivalent to this:

```
Grammar:        DataElement 6.0

  Namespace:    myExampleNamespace
```

### Comments

CIMPL follows [JavaScript syntax](https://www.w3schools.com/js/js_comments.asp) for code comments:

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

Primitives are data types, distinguished by starting with a lower case letter. FSH defines the following primitive data types. With the exception of `concept` (a simplified representation of **code**, **Coding**, and **CodeableConcept**), the primitive types in CIMPL align with FHIR:

* [`concept`](#concept-codes)
* [`boolean`](https://www.hl7.org/fhir/datatypes.html#boolean)
* [`integer`](https://www.hl7.org/fhir/datatypes.html#integer)
* [`string`](https://www.hl7.org/fhir/datatypes.html#string)
* [`decimal`](https://www.hl7.org/fhir/datatypes.html#decimal)
* [`uri`](https://www.hl7.org/fhir/datatypes.html#uri)
* [`base64Binary`](https://www.hl7.org/fhir/datatypes.html#base64Binary)
* [`instant`](https://www.hl7.org/fhir/datatypes.html#instant)
* [`date`](https://www.hl7.org/fhir/datatypes.html#date)
* [`dateTime`](https://www.hl7.org/fhir/datatypes.html#dateTime)
* [`time`](https://www.hl7.org/fhir/datatypes.html#time)
* [`oid`](https://www.hl7.org/fhir/datatypes.html#oid)
* [`id`](https://www.hl7.org/fhir/datatypes.html#id)
* [`markdown`](https://www.hl7.org/fhir/datatypes.html#markdown)
* [`unsignedInt`](https://www.hl7.org/fhir/datatypes.html#unsignedInt)
* [`positiveInt`](https://www.hl7.org/fhir/datatypes.html#positiveInt)
* [`xhtml`](https://www.hl7.org/fhir/narrative.html#xhtml)


### Concept Codes

FSH uses a single primitive type, `concept` to represent coded terms from controlled vocabularies. A concept is comprised of code system, code, and optional display text. The grammar for specifying concepts follows the pattern:

`{SYSTEM</i>#<i>code</i> "<i>Display text</i>"</code>

Examples:

`SCT#363346000 "Malignant neoplastic disease (disorder)"`

`ICD10CM#C004  "Malignant neoplasm of lower lip, inner aspect"`

_SYSTEM_ (`SCT` and `ICD10CM` in the examples) is an alias for a canonical URI that represents a code system. Aliases must be declared in the file header using the keyword [`CodeSystem`](#codesystem). You cannot use the canonical URI directly in the concept grammar.

Unlike FHIR, CIMPL does not differentiate between **code**, **Coding**, and **CodeableConcept**. See [Mapping Concept Codes](#mapping-concept-codes) for information on how CIMPL maps `concept` to these FHIR data types.

***

## Language Constructs

### Keywords

Keywords are used to make various declarations. Keywords always appear at the beginning of a line and are followed by a colon.


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
| `Parent` | Specifies the base class for a profile or ____ | name |
| `Profile` | Introduces a new profile | name |
| `Severity` | error, warning, or guideline in invariant | code |
| `Slice` | Introduces a new slice | name, string |
| `Source` | Profile or path a mapping applies to | path |
| `Target` | The standard that the mapping maps to | string |
| `Title` | Short human-readable name | string |
| `ValueSet` | Declares a new value set | name, string |
| `XPath` | the xpath in invariant | string |


## Requirements

* Provide a deterministic mechanism for identifying any part of a profile/extension/logical-model/resource that should be addressable in FSH
* Provide a way to address elements in the StructureDefinition (e.g., metadata elements like StructureDefinition.active)
* Provide a way to address elements in ElementDefinitions associated with the SD, such as `maxLength` for strings

* Disambiguate:
  * individual types from a choice (e.g., `string` from `value[x]`)
  * individual profiles from a profiled type (e.g., 'us-address' from an `address` type)
  * individual targets from a reference (e.g., `Observation` from `Reference(Observation | Condition)`)
  * individual slices from a slicing (e.g., `SystolicBP` slice vs. `DiastolicBP` slice)
* Borrow from existing constructs where it makes sense
  * [ElementDefinition.path](http://hl7.org/fhir/R4/elementdefinition.html#path)
  * [ElementDefinition.id](http://hl7.org/fhir/R4/elementdefinition.html#id)
  * [FHIRPath](http://hl7.org/fhirpath/)
  * [JSON format](http://hl7.org/fhir/R4/json.html) / [XML format](http://hl7.org/fhir/R4/xml.html)
  * [CQL](https://cql.hl7.org/)
* But... balance value of using existing constructs w/ user-friendliness and consistency across FSH

## Path Grammar

Path grammar allows you to refer to any element of a profile, extension, or profile, regardless of nesting. This section outlines FSH path grammar, used to specify constraints and more.

### Simple Nested Properties

Dot notation is used to denote nested properties. The path lists the properties in order, separated by a dot (.) For example, if `Observation` has a `0..1` `method` property, and `method` has a `0..1` `text` property, then the path within a profile on `Observation` is `method.text`.

Example: In an instance of an Observation: set method.text to "by land or sea"

`* method.text = "by land or sea"`

> **NOTE:** The root `Observation` is inferred from the context and not a formal part of the path. In this way, it differs from the `path` found in StructureDefinition elements.

> **IMPORTANT:** It is not possible to cross reference boundaries when profiling (except for slice discriminators, which may `resolve()` references). This means that when a path gets to a _Reference_ type, that path cannot be nested any further.

> For example, if `Procedure` has a `subject`, and `subject` is a `Reference` to a `Patient` which has a `gender` property, then `Procedure.subject` is a valid path, but `Procedure.subject.gender` is not, because it crosses into the Patient reference.

### Array/List Properties

If a property allows more than one value (e.g., `0..*`), then it must be possible to address each individual value.  This is mainly necessary when creating _Instances_, but may be needed in other contexts as well.  To do this, follow the path with square brackets (`[` `]`) containing the _0-based_ index of the item (e.g., first item is `[0]`, second item is `[1]`, etc.).

Example: In an Instance, set the first name's second given name to "Marie":

`* name[0].given[1] = "Marie"`

>**SHORTCUT**: If an index is omitted, the zero index will be assumed. For example,
>
> `* name.given[1] = "Marie"`
>
> has the same affect as the previous example.

### Type Choices (value[x])

Addressing a type from a choice of types replaces the `[x]` in the property name with the type name (while also capitalizing the first letter). This follows the approach used in FHIR JSON and XML serialization.

Example: Fix value[x] string property to "Hello World"

`* valueString = "Hello World"`

### Profiled Type Choices

In some cases, a type may be constrained to a set of possible profiles. To address a specific profile on that type, follow the path with square brackets (`[` `]`) containing the profile's `name`, `id`, or `url`.

Example: In an instance, set the address.state property to the code for Massachusetts (assumes the address type indicates several profiles, one being USAddress)

`* address[USAddress].state = UspsTwoLetterAlphabeticCodes#MA`

> **NOTE:** The example above assumes the context of an instance.  If we were trying to constrain the `state` only in the `USAddress` profile (and other profiles of `Address` were possible), then this would actually be slicing -- and slicing syntax should be used.

### Reference with Multiple Targets

In some cases, a path points to a `Reference` type that has multiple targets. To address a specific target, follow the path with square brackets (`[` `]`) containing the target type (or the profile's `name`, `id`, or `url`).

Example: Restrict Practitioner to PrimaryCareProvider in a profile, assuming `performer` is type   `Reference(Organization | Practitioner)`:

`* performer[Practitioner] only PrimaryCareProvider`

In an instance, square bracket references are usually not necessary, since the type matching can be inferred:

```
* performer[0] = DrBob  // instance of type Practitioner
* performer[1] = MyHospital  // instance of type Organization
* performer[2] = DrMike // instance of type Practitioner
```

### Sliced Array/List

FHIR allows lists to be compartmentalized into sublists called "slices".  For example, the `Observation.component` list in a profile for Apgar score might have a RespiratoryScore component slice and a Appearance component slice, among others.  To address a specific slice, follow the path with square brackets (`[` `]`) containing the slice name.  To access a slice of a slice (i.e., _reslicing_), follow the first pair of brackets with a second pair containing the resliced slice name.

See [[2.6 Slicing]] for more details on slicing.

Example: Fix the code in an existing slice on Observation.component called `RespiratoryScore`:

`* component[RespiratoryScore].code = SCT#24388001 "Apgar score 5 (finding)"`

Example: If the Apgar RespiratoryScore has been resliced to represent the 1, 5 and 10 minute scores:

`* component[RespiratoryScore][FiveMinute].code = SCT#13323003 "Apgar score 7 (finding)"`

### Extension and ModifierExtensions

Extensions being very common in FHIR, most of the time FSH allows dropping the extension[ ] and modifierExtension[ ] from paths (similar to the way the `[0]` index can be dropped). This is not allowed when dropping these terms creates a naming conflict.

### Structure Definition Attributes

FSH uses the carat (^) syntax to provide direct access to any element in StructureDefinition. The carat syntax is the method for setting metadata attributes in SD (attributes not associated with any element). The carat syntax can be combined with non-carat (element) paths to set values in the SD associated with a particular element (see example below).

Example: Setting metadata attributes in a profile

```
Profile:        USCorePatient
Parent:         Patient
* ^description = "Defines constraints and extensions on the patient resource for the minimal set of data to query and retrieve patient demographic information."
* ^id = "us-core-patient"
* ^status = #active
* ^experimental = false
```

Example: Setting metadata attribute for value set
```
ValueSet:       BirthSex
* ^id = "birthsex"
GEN#F   "Female"
GEN#M   "Male"
NUL#UNK "Unknown"
```

Example: Addressing SD attributes in an individual element definition
```
Profile:        USCorePatient
Parent:         Patient
* communication.language ^binding.extension[0].url = "http://hl7.org/fhir/StructureDefinition/elementdefinition-maxValueSet"
```
