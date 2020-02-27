SUSHI ("SUSHI Unshortens ShortHand Inputs") is a reference implementation of an interpreter/compiler for the FHIR Shorthand ("FSH" or "Shorthand") language. SUSHI produces [Health Level Seven (HL7®) Fast Healthcare Interoperability Resources (FHIR®)](https://www.hl7.org/fhir/overview.html) profiles, extensions, and other artifacts needed to create FHIR Implementation Guides (IG).

> **Note:** HL7® and FHIR® are registered trademarks owned by Health Level Seven International, and are registered with the United States Patent and Trademark Office.

#### Purpose

This reference manual is a comprehensive guide to the command line interface, auxiliary files, and configurations needed to create an HL7 FHIR IG using SUSHI.

#### Intended Audience

The reference manual is targeted to people doing IG development using FSH. Familiarity with FHIR is helpful as the manual references various FHIR concepts (profiles, extensions, value sets, etc.)

#### Prerequisite

This guide assumes you have:

* Reviewed the [FHIR Shorthand Tutorial](tutorial.html)
* Created FSH files representing your profiles and other IG artifacts (see [Authoring Guide](index.html) and [FSH Language Reference](reference.html) for details).

#### Document Conventions

| Style | Explanation | Example |
|:----------|:------|:---------|
| `Code` | Code fragments, such as commands and Shorthand statements  | `* status = #open` |
| _italics_ | File and directory names | _example-1.fsh_ |
| {curly braces} | An item to be substituted | `* status = {code}` |
| **bold** | General emphasis |  Do **not** fold, spindle or mutilate. |
{: .grid }


| Symbol | Explanation |
|:----------|:------|
| 🚧 | Under construction; full functionality not yet available |
| 🚫 | Indicates a planned feature, not yet implemented |
| 🍎 | Indicates information or command specific to OS X. The instructions assume the shell script is **bash**. As of the Mac Catalina release, the default is **zsh** and will need to be reconfigured as a default or at runtime to call bash shell. You can find out the default shell in a Mac terminal by running `echo $SHELL`.|
| 💻 | Indicates information or command specific to Windows. A command window can be launched by typing `cmd` at the _Search Windows_ tool. |
| $ | Represents command prompt (may vary depending on platform) |
{: .grid }

### Installation

#### Step 1: Install Node.js
SUSHI requires Node.js. To install Node.js, go to [https://nodejs.org/](https://nodejs.org/) and you should see links to download an installer for your operating system. Download the installer for the LTS version. If you do not see a download appropriate for your operating system, click the "other downloads" link and look there. Once the installer is downloaded, run the installer. It is fine to select default options during installation.

Ensure that Node.js is correctly installed by opening a command window and typing the following two commands. Each command should return a version number.
```
$ node --version
$ npm --version
```

#### Step 2: Install SUSHI

To install SUSHI, open up a command prompt.

`$ npm install -g fsh-sushi`

Check the installation by typing the following command:

`$ sushi -h`

If the command outputs instructions on using SUSHI command line interface (CLI), you're ready to run SUSHI.

Use `$ sushi -v` to display version of SUSHI

SUSHI follows the [semantic versioning](https://semver.org) convention (MAJOR.MINOR.PATCH):

* MAJOR: A major release has significant new functionality and potentially, grammar changes or other non-backward-compatible changes.
* MINOR: Contains new or modified features, while maintaining backwards compatibility within the major version.
* PATCH: Contains minor updates and bug fixes, while maintaining backwards compatibility within the major version.

> **Note:** For the most up-to-date information and latest releases of SUSHI, check the [release history and release notes](https://github.com/FHIR/sushi/releases). To update SUSHI to the latest version, re-run:

> `$ npm install -g fsh-sushi`

> To revert to a previous version of SUSHI, run:

>  `npm install -g fsh-sushi@{version}`

> where the version is in the form MAJOR.MINOR.PATCH.


### Executing SUSHI from Command Line

The general form of the SUSHI execution command is as follows:

`$ sushi {specification-directory} {options}`

where options include:

```
-o, --out <out>   the path to the output folder (default: /build)
-h, --help        output usage information
-v, --version     output the version of SUSHI
```

The options are not order-sensitive.

If you run SUSHI from the same folder where your .fsh files are located, and you use the default output location, the command can be shortened to:

`$ sushi .`

The resulting _/build_ folder will look something like this:

```
/build
├── _genonce.bat
├── _genonce.sh
├── _updatePublisher.sh
├── _updatePublisher.sh
├── ig.ini
├── package.json
├── package-list.json
└── /input
    ├── ImplementationGuide-myIG.json
    ├── /examples
    │   └── Patient-myPatient-example.json
    ├── /extensions
    │   └── StructureDefinition-myExtension.json
    ├── /images
    │   ├── myJpgGraphic.jpg
    │   ├── myDocument.docx
    │   ├── mySpreadsheet.xlsx
    │   └── myPngGraphic.png
    ├── /includes
    │   └── menu.xml
    ├── /pagecontent
    │   ├── index.md
    │   ├── mySecondPage.md
    │   ├── myThirdPage.md
    │   └── myFourthPage.md
    ├── /profiles
    │   └── StructureDefinition-myProfile.json
    └── /vocabulary
        ├── ValueSet-myValueSet.json
        └── CodeSystem-myCodeSystem.json
```

 SUSHI puts each item where the FHIR publisher expects to find them, assuming the IG publisher is run from the _/build_ directory.

#### Error Messages

In the process of developing your IG using FSH, you may encounter SUSHI error messages (written to the command console). Most error messages point to a specific line or lines in a `.fsh` file. If possible, SUSHI will continue, despite errors, to produce FHIR artifacts, but those artifacts will omit any problematic rules. SUSHI should always exit gracefully. If SUSHI crashes, please report the issue using the [SUSHI issue tracker](https://github.com/FHIR/sushi/issues).

Here are some general tips on approaching debugging:

* Eliminate parsing (syntax) errors first. Messages include `extraneous input {x} expecting {y}`, `mismatched input {x} expecting {y}` and `no viable alternative at {x}`. These messages indicate that the line in question is not a valid FSH statement.
* The order of keywords is not arbitrary. The declarations must start with the type of item you are creating (e.g., Profile, Instance, ValueSet).
* The order of rules usually doesn't matter, but there are exceptions. Slices and extensions must be created (with `contains` rule) before they are constrained.
* A common error is `No element found at path`. This means although the overall grammar of the statement is correct, SUSHI could not find the FHIR element you are referring to in the rule. Make sure there is no spelling error, the element names in the path are correct, and you are using the [path grammar](index#paths) correctly.

### IG Creation

SUSHI supports publishing implementation guides via the new template-based IG Publisher. See the [Guidance for HL7 IG Creation](https://build.fhir.org/ig/FHIR/ig-guidance/) for more details.

#### Setting Up

SUSHI uses the contents of the _ig-data_ directory to generate an Implementation Guide project that can be built using the template-based IG Publisher. Currently, you must create the _ig-data_ directory and its subdirectories. Here is the directory structure to add to the top level of your FSH tank:

```
/ig-data
└── /input
    ├── /images
    ├── /includes
    └── /pagecontent
```
Populate these directories as follows:

* _ig-data/ig.ini_: If present, the user-provided _ig.ini_ values will be merged with SUSHI-generated _ig.ini_.
* _ig-data/package-list.json_: This file should contain the version history of your IG. If present, it will be used instead of a generated _package-list.json_.
* _ig-data/input/images/*_: Anything that is not a page in the IG, such as images, spreadsheets or zip files, put in the _images_ folder. If present, these files will be copied into the build and can be referenced by user-provided pages.
* _ig_data/input/includes/menu.xml_: If present, _menu.xml_ will be used for the IG's main menu layout.
* Pages to be included in the IG:
  * _ig-data/input/pagecontent/index.md_ (or .xml): If present, it will provide the content for the IG's main page.
  * _ig-data/input/pagecontent/n\_pagename.md_ (or .xml): If present, these files will be generated as individual pages in the IG and will be present in the table of contents in the order indicated by the leading integer (n).
  * _ig-data/input/pagecontent/{name-of-resource-file}-[intro|notes].md_ (or .xml): If present, these files will place content directly on the relevant resource page. `intro` file contents will placed before the resource definition; `notes` file contents will placed after.

Examples of ig.ini, package-list.json, and menu.xml files can be found in the [sample IG project](https://github.com/FHIR/sample-ig) provided for this purpose. An example of a complete IG with examples of these files is the [mCODE IG](https://github.com/standardhealth/fsh-mcode). More general guidance can be found in [Guidance for HL7 IG Creation](https://build.fhir.org/ig/FHIR/ig-guidance/). 

The resulting populated _ig-data_ directory should look something like this:

```
/ig-data
├── ig.ini (optional)
├── package-list.json (optional)
└── /input
    ├── /images
    │   ├── graphic.jpg
    │   ├── recipes.docx
    │   ├── tables.xlsx
    │   └── flowchart.png
    ├── /includes
    │   └── menu.xml (optional)
    └── /pagecontent
        ├── index.md
        ├── 1_mySecondPage.md
        ├── 2_myThirdPage.md
        └── 3_myFourthPage.md
```

The page number prefixes control the ordering of the pages in the table of contents. These numbers are stripped by SUSHI, and do not appear in the page URLs.

Based on these inputs, SUSHI builds the [ImplementationGuide resource](http://hl7.org/fhir/R4/implementationguide.html) for your IG, which can be found in _/build/input_ after you run SUSHI.

**Note**: If the input folder does not contain a sub-folder named _ig-data_, then only the FHIR artifacts (e.g., profiles, extensions, etc.) will be generated.

#### Downloading and Running the IG Publisher

After running SUSHI, change directories to the output directory, usually _/build_. At the command prompt, enter:

💻   `$ _updatePublisher`

🍎   `$ ./_updatePublisher.sh`

This will download the latest version of the HL7 FHIR IG Publisher tool into the _/build/input-cache_ directory. **This step can be skipped if you already have the latest version of the IG Publisher tool in _input-cache_.**

> **Note:** If you are blocked by a firewall, or if for any reason __updatePublisher_ fails to execute, download the current IG Publisher jar file [here](https://fhir.github.io/latest-ig-publisher/org.hl7.fhir.publisher.jar). When the file has downloaded, move it into the directory _/build/input-cache_ (create the directory if necessary.)

Now run:

💻   `$ _genonce`

🍎   `$ ./_genonce.sh`

This will run the HL7 IG Publisher, which will take several minutes to complete. After the publisher is finished, open the file _/build/output/index.html_ in a browser to see the resulting IG.

### Get Involved
Thank you for using FHIR Shorthand and the SUSHI reference implementation. We hope it will help you succeed in your FHIR projects. The SUSHI software is provided free of charge. All we ask in return is that you share your ideas, suggestions, and experience with the community. If you are a Typescript developer, code contributions to SUSHI are gladly accepted!

Here are some links to get started:

* Participate, ask or answer questions on the [FHIR Shorthand Chat](https://chat.fhir.org/#narrow/stream/215610-shorthand).

* If you encounter issues with SUSHI, please report them on the [SUSHI issue tracker](https://github.com/FHIR/sushi/issues).

* For up-to-date with information and latest releases of SUSHI, check the [release history and release notes](https://github.com/FHIR/sushi/releases).

* To download the source code, and contribute to SUSHI, check out the open source project [hosted on Github](https://github.com/FHIR/sushi).
