**The document is under development. [Design discussions are taking place in the github wiki](https://github.com/HL7/fhir-shorthand/wiki).**

## Overview

FHIR Shorthand (FSH) is a specially-designed language for defining the content of FHIR Implementation Guides (IG). It is simple and compact, with tools to produce [Fast Healthcare Interoperability Resources (FHIR)](https://www.hl7.org/fhir/overview.html) profiles, extensions and implementation guides (IG). Because it is a _language_, written in text statements, FHIR Shorthand encourages distributed, team-based development using conventional source code control tools such as Github. FHIR Shorthand provides tooling that enables you to define a model once, and publish that model to multiple versions of FHIR.

SUSHI (aka "SUSHI Unshortens Short Hand Inputs") is the proposed name for the command-line interpreter/compiler for FHIR Shorthand (FSH).


## Benefits of FHIR Shorthand

* Agile -- rapid refactoring and revision cycles 
* Readable and easy to understand
* Makes the author’s intent clear
* Reduces implementation errors
* Enforces consistency in SDs (compiling FSH into SD using consistent patterns)
* Provides meaningful differentials in Source Code Control Systems (SCCS)
* Enables merging at the statement/line-level in SCCS
* Supports distributed development under SCCS
* Any text editor can be used to modify an FSH file, but editing environments can provide text colorization, look-ahead syntax, go-to-definition, etc.

## Contributors

Mark Kramer (MITRE), Chris Moesel (MITRE), Grahame Grieve, (add your name here)
