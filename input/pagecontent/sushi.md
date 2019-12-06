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
| `Code` | A CIMPL term, phrase, example, or command | `CodeSystem: LNC = http://loinc.org` |
| <code><i>Italics</i> appearing in a code block | Indicates an item that should be substituted | <code>Value only <i>datatype</i></code> |
| _Italics_ | A file name, or general emphasis in text | _obf-action.txt_ |
| _Italics with **bold** highlight_ | Indicates a substring in the file name that should be substituted | _ig-**myigname**-config.json_ |
| Leading Capitalization | CIMPL keywords or references that are capitalized; specific instances of FHIR artifacts | The `Grammar` keyword |
| **Note:** | Something to keep in mind about the current topic | **Note:** Value Set names must begin with an uppercase letter. |

## Installation


## Configuration File

## Executing SUSHI from Command Line

The general form of the SUSHI execution command is as follows (where $ stands for the command prompt, which could be different on your system):

$ <code>node <i>tooling-directory  <specification-directory [options]</i></code>

where options include:

```
-c, --config <config>    the name of the Configuration file (default: _config.json_)
-l, --log-level <level>  the console log level <fatal, error, warn, info, debug, trace> (default: info)
-o, --out <out>          the path to the output folder (default: _out_)
-m, --log-mode <mode>    the console log mode <short,long,json,off> (default: short)
-d, --duplicate          show duplicate error messages (default: false)
-n, --clean              Save archive of old output directory and perform clean build (default: false)
-h, --help               output usage information
```

The options are not order-sensitive. Here is an example of a SUSHI command and an explanation of its parts:

$ `node . ../shr-spec/spec -c ig-mcode/ig-mcode-r4-config.json -l error`

* `node` is the command that starts the SUSHI application.
* The dot `.` represents the current directory in Windows and macOS. In this example, the tooling directory is the current working directory.
* `../shr-spec/spec` represents the location of the _specification_ directory. The double dot `..` represents the directory above the current _working directory_ in Windows and macOS. In this case, `/shr-spec` is parallel to the _tooling directory_, and `/spec` is one level below that.
* `-c ig-mcode/ig-mcode-r4-config.json` directs the execution engine to the Configuration file. Note that the Configuration file location is relative to the _specification_ directory, implying the full path to the configuration is `../shr-spec/spec/ig-mcode/ig-mcode-r4-config.json`
* `-l error` is an option that sets tells the system to suppress any messages that don't rise to the level of an `error`. This reduces the amount of output to the console window.

>**Note:** SUSHI will abort if the `--clean`(`-n`) option is selected and the output folder is locked by another application (e.g., the folder is open in File Explorer).

## Error Messages

In the process of building a model, it is inevitable that you will encounter error messages from SUSHI. Debugging the model is an iterative process, and it could take some perseverance to arrive at a _clean_ run with no errors.

Here are some general tips on approaching debugging your model:

* Always eliminate parsing (grammar) errors first. Parsing errors usually trigger cascades of other errors. You can't really start debugging until parsing errors have been eliminated.
* Once all parsing errors have been eliminated, start working top down on the first (or first few) errors. Often, subsequent errors are a consequence of the first error.
* Don't be discouraged by the number of errors, since a single correction can silence multiple logged errors.
* Read the error messages carefully.
* SUSHI _should_ always run to completion, but sometimes the SUSHI process can crash if there is an unanticipated error. Usually this is not a cause for concern, and fixing any reported errors will eliminate the crash.

