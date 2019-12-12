### Introduction

SUSHI ("SUSHI Unshortens ShortHand Inputs") is a reference implementation of an interpreter/compiler for the FHIR Shorthand ("FSH" or "Shorthand") language. SUSHI produces [Health Level Seven (HL7®) Fast Healthcare Interoperability Resources (FHIR®)](https://www.hl7.org/fhir/overview.html) profiles, extensions, and other artifacts needed to create FHIR Implementation Guides (IG).

> **NOTE**: HL7® and FHIR® are registered trademarks owned by Health Level Seven International, and are registered with the United States Patent and Trademark Office.

#### Purpose

This reference manual is a comprehensive guide to the command line interface, auxiliary files, and configurations needed to create an HL7 FHIR IG using SUSHI.

#### Intended Audience

The reference manual is targeted to people doing IG development using FSH. Familiarity with FHIR is helpful as the manual references various FHIR concepts (profiles, extensions, value sets, etc.)

#### Prerequisite

This guide assumes you have:

* Created FSH files representing your profiles and other IG artifacts (see [FHIR Shorthand Reference Manual](index.html) for details).
* Reviewed the [FHIR Shorthand Tutorial](tutorial.html).

#### Document Conventions

| Style | Explanation | Example |
|:----------|:------|:---------|
| `Code` | Code fragments, such as commands and Shorthand statements  | `* status = #open` |
| _italics_ | File names | _example-1.fsh_ |
| {curly braces} | An item to be substituted | `* status = {code}` |
| **bold** | General emphasis |  Do **not** fold, spindle or mutilate. |
{: .grid }

We use `$` to represent the command prompt, although that may differ on your operating system.

### Installation
Install SUSHI in two easy steps:

1) Install Node.js
    
    a) Download from https://nodejs.org 
    
    b) Run the installer

    c) Check the installation by opening a command window and typing the following two commands. Each command should return a version number. 

    `$ node --version`

    `$ npm --version`

1) Install SUSHI

    a) Issue this command at the prompt:

    `$ npm install -g fsh-sushi`

    b) Check the installation by typing the following command:

    `$ sushi -h`

If the command outputs instructions on using SUSHI command line interface (CLI), you're ready to run SUSHI.

### SUSHI Version

SUSHI follows the [semantic versioning](https://semver.org) convention (MAJOR.MINOR.PATCH):

* MAJOR: A major release has significant new functionality and potentially, grammar changes or other non-backward-compatible changes.
* MINOR: Contains new or modified features, while maintaining backwards compatibility within the major version.
* PATCH: Contains minor updates and bug fixes, while maintaining backwards compatibility within the major version.

_Is this correct?_

> The config file must declare the minimum version of SUSHI compiler it requires. For example, if the config declares SUSHI 1.2, it requires major version 1, any minor version >= 2.

>**NOTE:** There is no guarantee that a FSH file declaring major version X will compile correctly on major version Y, if X /= Y.

_end_

### Configuration File

Shorthand uses the FHIR packaging approach:

* packages are defined using a _package.json_ file
* dependencies are defined in the _package.json_
* package managers handle the resolution of dependency packages
* dependency resolution follows the same rules as FHIR dependency resolution

> **NOTE**: In addition, however, we may want to support dependencies for which there is not a _built_ package yet, but there is an accessible GitHub repository or even a local folder representing a package (NPM supports this).

See: [FHIR NPM Package Spec](https://wiki.hl7.org/index.php?title=FHIR_NPM_Package_Spec#Format)


### Executing SUSHI from Command Line

The general form of the SUSHI execution command is as follows:

`$ sushi {specification-directory} {options}`

where options include:

```
-o, --out <out>          the path to the output folder (default: /out)
-h, --help               output usage information
```

The options are not order-sensitive.

If you run SUSHI from the same folder where your .fsh files are located, the command can be shortened to:

`$ sushi . {options}`


### Error Messages

In the process of building profiles, you will inevitably encounter SUSHI error messages. Debugging the model is an iterative process, and it could take some time to arrive at a clean compile. SUSHI will only produce IG artifacts if it runs to completion without errors.

Here are some general tips on approaching debugging your model:

* Always eliminate parsing (grammar) errors first. Parsing errors usually trigger cascades of other errors. You can't really start debugging until parsing errors have been eliminated.
* Once all parsing errors have been eliminated, start working top down on the first (or first few) errors. Often, subsequent errors are a consequence of the first error.
* Don't be discouraged by the number of errors, since a single correction can silence multiple logged errors.
* Read the error messages carefully.
* SUSHI should always exit gracefully, but there is a possibility for the SUSHI process to crash if there is an unanticipated error. Usually this is not a cause for concern, and fixing errors reported prior to the abnormal exit might result in a successful run. If not, please report the issue using the SUSHI issue tracker.
