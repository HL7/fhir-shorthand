# FHIR Shorthand

FHIR Shorthand (FSH) is a domain-specific language (DSL) for defining the content of FHIR Implementation Guides (IG). It is simple and compact, with tools to produce [Health Level Seven (HL7®) Fast Healthcare Interoperability Resources (FHIR®)](https://www.hl7.org/fhir/overview.html) profiles, extensions and implementation guides (IG). Because it is written in text statements, FHIR Shorthand encourages distributed, team-based development using conventional source code control tools such as Github.

> **NOTE**: HL7® and FHIR® are registered trademarks owned by Health Level Seven International.

## Contents

This implementation guide includes the following sections:

* [FHIR Shorthand Tutorial](tutorial.html) -- A step-by-step hands-on introduction to producing an IG with FHIR Shorthand
* [FHIR Shorthand Language Reference](shorthand.html) -- Describes the syntax and usage of the FHIR Shorthand language
* [SUSHI - The Reference Implementation](sushi.html) -- How to produce an IG from FSH files using SUSHI compiler and IG Publisher.


## Motivations for FHIR Shorthand

1. The FHIR community needs scalable, fast, and user-friendly tools for IG creation and maintenance. Profiling projects can be difficult and slow, and the resulting IG quality can be inconsistent.
1. Editing StructureDefinitions (SDs) by hand is complex and unwieldy.
1. Available tools such as Forge, Trifolia-on-FHIR, and Excel spreadsheets improve this situation, but still have drawbacks:
    1. Although the tools provide a friendlier interface, the user must still understand many SD details.
    1. The tools are not particularly agile when it comes to [refactoring](https://resources.collab.net/agile-101/code-refactoring).
    1. Source code control (SCC) features such as version-to-version differences and merging changes are not well supported.
1. It can be difficult make sense of the Profile pages in IGs ([see this example from the September 2019 ballot](http://hl7.org/fhir/us/breast-radiology/2019Sep/StructureDefinition-breastrad-BreastRadiologyDocument.html)). FSH compiles to SD, but FSH itself is clearer and more compact and could represent the snapshot and differential.
1. Experience has shown that complex software projects are best approached with textual languages. As a DSL designed for the job of profiling and IG creation, FSH is concise, understandable, and aligned to user intentions.
1. FSH is ideal for SCC, with meaningful version-to-version differentials, support for merging and conflict resolution, and refactoring through global search/replace operations. These features allow FSH to scale in ways that other approaches cannot.

## Benefits of FHIR Shorthand

* Agile -- rapid refactoring and revision cycles
* Readable and easy to understand
* Makes the author’s intent clear
* Reduces implementation errors
* Enforces consistency by compiling FSH into FHIR artifacts using consistent patterns
* Provides meaningful differentials in SCC
* Enables merging at the statement/line-level in SCC
* Supports distributed development under SCC
* Any text editor can be used to modify an FSH file, but editing environments such as VS Code and Notepad++ can provide text colorization, look-ahead syntax, go-to-definition, etc.

## Versioning

The FSH specification, like other IGs, follows the [semantic versioning](https://semver.org) convention (MAJOR.MINOR.PATCH):

* MAJOR: A major release has significant new functionality and potentially, grammar changes or other non-backward-compatible changes.
* MINOR: Contains new or modified features, while maintaining backwards compatibility within the major version.
* PATCH: Contains minor updates and bug fixes, while maintaining backwards compatibility within the major version.

For a full change log, see the [FHIR Shorthand Release Notes](_#missing link_).

