# SUSHI Reference Manual

## Table of Contents

[TOC]

***

## Introduction

SUSHI ("SUSHI Unshortens ShortHand Inputs") is a reference implementation of an interpreter/compiler for the FHIR Shorthand ("FSH" or "Shorthand") language. SUSHI produces [Health Level Seven (HL7®) Fast Healthcare Interoperability Resources (FHIR®)](https://www.hl7.org/fhir/overview.html) profiles, extensions, and other artifacts needed to create FHIR Implementation Guides (IG).

> **NOTE**: HL7® and FHIR® are registered trademarks owned by Health Level Seven International, and are registered with the United States Patent and Trademark Office.

### Purpose

This reference manual is a comprehensive guide to the command line interface, auxiliary files, and configurations needed to create an HL7 FHIR IG using SUSHI.

### Intended Audience

The reference manual is targeted to people doing IG development using FSH. Familiarity with FHIR is helpful as the manual references various FHIR concepts (profiles, extensions, value sets, etc.)

### Prerequisite

This guide assumes you have:

* Created FSH files representing your profiles and other IG artifacts (see [FHIR Shorthand Reference Manual](shorthand.md) for details).
* Reviewed the [FHIR Shorthand Tutorial](tutorial.md).

### Document Conventions

| Style | Explanation | Example |
|:----------|:---------|:---------|
| `Code` | Code fragments, such as commands and Shorthand statements  | `* status = #open` |
| _Italics_ | File names | _example-1.fsh_ |
| Curly braces | An item to be substituted | `* status = {coded type}` |
| **bold** | General emphasis |  Do **not** delete. |

We use `$` to represent the command prompt, although that may differ on your operating system.

## Installation
Installing SUSHI is easy!

1) Install Node.js (download from https://nodejs.org)
1) Check the installation by opening a command window and typing the following two commands. Each command should return a version number. 

    `$ node --version`

    `$ npm --version`

1) Next, issue this command at the prompt:

    `$ npm install -g fsh-sushi`

1) Check the installation by typing the following command:

    `$ sushi -h`

If you see instructions on using SUSHI command line interface (CLI), you're ready to run SUSHI.

## Configuration File

## Executing SUSHI from Command Line

The general form of the SUSHI execution command is as follows:

`$ sushi {specification-directory} [options]`

where options include:

```
-o, --out <out>          the path to the output folder (default: _out_)
-h, --help               output usage information
```

The options are not order-sensitive.

If you run SUSHI from the same folder where your .fsh files are located, the command can be shortened to:

`$ sushi . [options]`


## Error Messages

In the process of building a model, it is inevitable that you will encounter error messages from SUSHI. Debugging the model is an iterative process, and it could take some perseverance to arrive at a _clean_ run with no errors.

Here are some general tips on approaching debugging your model:

* Always eliminate parsing (grammar) errors first. Parsing errors usually trigger cascades of other errors. You can't really start debugging until parsing errors have been eliminated.
* Once all parsing errors have been eliminated, start working top down on the first (or first few) errors. Often, subsequent errors are a consequence of the first error.
* Don't be discouraged by the number of errors, since a single correction can silence multiple logged errors.
* Read the error messages carefully.
* SUSHI _should_ always run to completion, but sometimes the SUSHI process can crash if there is an unanticipated error. Usually this is not a cause for concern, and fixing any reported errors will eliminate the crash.

