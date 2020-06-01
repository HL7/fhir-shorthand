
SUSHI ("SUSHI Unshortens ShortHand Inputs") is a reference implementation of an interpreter/compiler for the FHIR Shorthand ("FSH" or "Shorthand") language. SUSHI produces [Health Level Seven (HL7®) Fast Healthcare Interoperability Resources (FHIR®)](https://www.hl7.org/fhir/overview.html) profiles, extensions, and other artifacts needed to create FHIR Implementation Guides (IG).

This reference manual is a comprehensive guide to the command line interface, auxiliary files, and configurations needed to create an HL7 FHIR IG using SUSHI. It is targeted to people doing IG development using FSH. Familiarity with FHIR is helpful as the manual references various FHIR concepts (profiles, extensions, value sets, etc.)

This guide assumes you have:

* Reviewed the [FHIR Shorthand Tutorial](tutorial.html).
* Created FSH files representing your profiles and other IG artifacts (see [Authoring Guide](index.html) and [FSH Language Reference](reference.html) for details).

The following conventions are used:

| Style | Explanation | Example |
|:----------|:------|:---------|
| `Code` | Code fragments, such as commands, FSH statements, and syntax expressions  | `* status = #open` |
| {curly braces} | An item to be substituted in a syntax pattern | `{codesystem}#{code}` |
| **bold** | A directory path or file name | **example-1.fsh** |
{: .grid }


| Symbol | Explanation |
|:----------|:------|
| 🍎 | Indicates information or command specific to OS X. Commands can be run within the Terminal application. |
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

```
$ npm install -g fsh-sushi
```

Check the installation by typing the following command:

```
$ sushi -h
```

If the command outputs instructions on using SUSHI command line interface (CLI), you're ready to run SUSHI.

Use `$ sushi -v` to display version of SUSHI

SUSHI follows the [semantic versioning](https://semver.org) convention (MAJOR.MINOR.PATCH):

* MAJOR: A major release has significant new functionality and, potentially, grammar changes or other non-backward-compatible changes.
* MINOR: Contains new or modified features, while maintaining backwards compatibility within the major version.
* PATCH: Contains minor updates and bug fixes, while maintaining backwards compatibility within the major version.

For the most up-to-date information and latest releases of SUSHI, check the [release history and release notes](https://github.com/FHIR/sushi/releases).

##### Updating or Reverting SUSHI

To update SUSHI to the latest version, re-run:

```
$ npm install -g fsh-sushi
```

To revert to a previous version of SUSHI, run:

```
npm install -g fsh-sushi@{version}
```

where the version is in the form MAJOR.MINOR.PATCH.


### Executing SUSHI

SUSHI is executed from the command line. The general form of the SUSHI execution command is as follows:

```
$ sushi {specification-directory} {options}
```

where options include:

```
-o, --out <out>   the path to the output directory (default: /build)
-h, --help        output usage information
-v, --version     output the version of SUSHI
-s, --snapshot    have SUSHI generate profile snapshots
```

The options are not order-sensitive.

> Note: By default, SUSHI only generates the [profile differential](https://www.hl7.org/fhir/profiling.html#snapshot), leaving it to the IG Publisher to create the [profile snapshot](https://www.hl7.org/fhir/profiling.html#snapshot). This is the approach recommended by HL7 FHIR leadership. If authors prefer, the `-s` option can be used to cause SUSHI to generate the snapshot without having to run the IG Publisher.

If you run SUSHI from the same directory where your .fsh files are located, and accept the defaults, the command can be shortened to:

```
$ sushi .
```

#### Error Messages

In the process of developing your IG using FSH, you may encounter SUSHI error messages (written to the command console). Most error messages point to a specific line or lines in a `.fsh` file. If possible, SUSHI will continue, despite errors, to produce FHIR artifacts, but those artifacts may omit problematic rules. SUSHI should always exit gracefully. If SUSHI crashes, please report the issue using the [SUSHI issue tracker](https://github.com/FHIR/sushi/issues).

Here are some general tips on approaching debugging:

* Eliminate parsing (syntax) errors first. Messages include `extraneous input {x} expecting {y}`, `mismatched input {x} expecting {y}` and `no viable alternative at {x}`. These messages indicate that the line in question is not a valid FSH statement.
* The order of keywords is not arbitrary. The declarations must start with the type of item you are creating (e.g., Profile, Instance, ValueSet).
* The order of rules usually doesn't matter, but there are exceptions. Slices and extensions must be created (with `contains` rule) before they are constrained.
* A common error is `No element found at path`. This means that although the overall grammar of the statement is correct, SUSHI could not find the FHIR element you are referring to in the rule. Make sure there are no spelling errors, the element names in the path are correct, and you are using the [path grammar](reference.html#paths) correctly.
* If you are getting an error you can't resolve, you can ask for help on the [#shorthand chat channel](https://chat.fhir.org/#narrow/stream/215610-shorthand).

### IG Creation

SUSHI supports publishing implementation guides via the [template-based IG Publisher](https://build.fhir.org/ig/FHIR/ig-guidance/). This section describes the inputs and outputs from this process.

#### SUSHI Inputs

SUSHI uses the contents of a user-created **package.json** and **ig-data** directory to generate the inputs to the IG Publisher. For a bare-bones IG with no customization, simply create an empty **ig-data** folder. For a customized IG, create and populate the **ig-data** folder with custom content and configurations.

The project should look something like this:

```
File1.fsh
File2.fsh
File3.fsh
...
package.json
/ig-data
├── package-list.json (optional)
├── ig.ini (optional)
└── /input
    ├── ignoreWarnings.txt (optional)
    ├── /images
    │   ├── myGraphic.jpg
    │   ├── myDocument.docx
    │   └── mySpreadsheet.xlsx
    ├── /includes
    │   └── menu.xml (optional)
    └── /pagecontent
        ├── index.md
        ├── 1_mySecondPage.md
        ├── 2_myThirdPage.md
        └── 3_myFourthPage.md
```

Populate your project as follows:

* **package.json**: This required file is the package manifest. The content is described [here](https://confluence.hl7.org/pages/viewpage.action?pageId=35718629#NPMPackageSpecification-Packagemanifest). 
* **package-list.json**: This optional file, described [here](https://confluence.hl7.org/display/FHIR/FHIR+IG+PackageList+doco), should contain the version history of your IG. If present, it will be used instead of a generated **package-list.json**.
* **ig.ini**: If present, the user-provided values will be merged with SUSHI-generated **ig.ini**.
* **ignoreWarnings.txt**: If present, this file can be used to suppress specific QA warnings and information messages during the FHIR IG publication process.
* The **/images** subdirectory: Put anything that is not a page in the IG, such as images, spreadsheets or zip files, in the **images** subdirectory. These files will be copied into the build and can be referenced by user-provided pages or menus.
* **menu.xml**: If present, this file will be used for the IG's main menu layout.
* The **/pagecontent** subdirectory, put either markup (.xml) or markdown (.md) files with the narrative content of your IG:
  * **index.xml\|md**: This file provides the content for the IG's main page.
  * **N\_pagename.xml\|md**: If present, these files will be generated as individual pages in the IG. The leading integer (N) determines the order of the pages in the table of contents. These numbers are stripped and do not appear in the actual page URLs.
  * **{artifact-file-name}-intro.xml\|md**: If present, the contents of the file will be placed on the relevant page _before_ the artifact's definition.
  * **{artifact-file-name}-notes.xml\|md**: If present, the contents of the file will be placed on the relevant page _after_ the artifact's definition.
* **input/{supported-resource-input-folder}** (not shown above): JSON files in supported resource folders (e.g., **profiles**, **extensions**, **examples**, etc.) will be be copied to the corresponding locations in the IG input and processed as additional (non-FSH) IG resources. This feature is not expected to be commonly used.

Examples of **package.json**, **ig.ini**, **package-list.json**, **ignoreWarnings.txt** and **menu.xml** files can be found in the [sample IG project](https://github.com/FHIR/sample-ig) provided for this purpose. More general guidance can be found in [Guidance for HL7 IG Creation](https://build.fhir.org/ig/FHIR/ig-guidance/). The [mCODE Implementation Guide](https://github.com/standardhealth/fsh-mcode) has a good example of a populated **ig-data** directory.

> ** Note:** If no IG is desired, and you only want to export the FHIR artifacts (e.g., profiles, extensions, etc.), ensure that no **ig-data** folder is present.

#### SUSHI Outputs

Based on the inputs in FSH files and the **ig-data** directory, SUSHI populates the specified output directory (**build** by default). SUSHI will create the [ImplementationGuide resource](http://hl7.org/fhir/R4/implementationguide.html) for your IG, which can be found in **/build/input** after you run SUSHI.

The resulting **/build** directory will look something like this:

```
/build
├── _genonce.bat
├── _genonce.sh
├── _gencontinuous.bat
├── _gencontinous.sh
├── _updatePublisher.sh
├── _updatePublisher.sh
├── package.json (copied from fsh tank)
├── package-list.json (generated or copied from fsh tank)
├── ig.ini  (generated or copied from fsh tank)
└── /input
    ├── ImplementationGuide-myIG.json
    ├── ignoreWarnings.txt
    ├── /examples
    │   └── Patient-myPatient-example.json
    ├── /extensions
    │   └── StructureDefinition-myExtension.json
    ├── /images
    │   ├── myGraphic.jpg
    │   ├── myDocument.docx
    │   └── mySpreadsheet.xlsx
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

 SUSHI puts each item where the FHIR publisher expects to find them, assuming the IG publisher is run from the **/build** directory.
 
 > Note: The **/build/input** directory is actually an _output_ of SUSHI, but so named because it is an _input_ to the IG Publisher.

### Downloading and Running the IG Publisher

After running SUSHI, change directories to the output directory, usually **/build**. At the command prompt, enter:

```
💻  $ _updatePublisher
```

```
🍎  $ ./_updatePublisher.sh
```

This will download the latest version of the HL7 FHIR IG Publisher tool into the **/build/input-cache** directory. _This step can be skipped if you already have the latest version of the IG Publisher tool in **input-cache**._

> **Note:** If you have never run the IG Publisher, you may need to install Jekyll first. See [Installing the IG Publisher](https://confluence.hl7.org/display/FHIR/IG+Publisher+Documentation) for details.

> **Note:** If you are blocked by a firewall, or if for any reason `_updatePublisher` fails to execute, download the current IG Publisher jar file [here](https://fhir.github.io/latest-ig-publisher/org.hl7.fhir.publisher.jar). When the file has downloaded, move it into the directory **/build/input-cache** (creating the directory if necessary.)

Now run the following command:

```
💻  $ _genonce
```

```
🍎  $ ./_genonce.sh
```
This will run the HL7 IG Publisher, which will take several minutes to complete. After the publisher is finished, open the file **/build/output/index.html** in a browser to see the resulting IG.

> **Note:** `_genonce` embeds the command `JAVA -jar input-cache/org.hl7.fhir.publisher.jar -ig ig.ini`. If the publisher jar or `ig.ini` file are different locations, the command can be adjusted accordingly.

### New! IG Publisher Integration (Autobuild Configuration)

The IG Publisher version 1.0.75 and higher includes native support for FSH and SUSHI. The IG Publisher launches SUSHI and runs it if it detects a folder named **/fsh**. Not having to run SUSHI separately is a minor benefit, but there is a significant advantage related to the _autobuild_ process.

[Autobuild](https://github.com/FHIR/auto-ig-builder/blob/master/README.md) is a build service that can be triggered when you commit IG source code to any GitHub repository. Autobuild starts the IG Publisher and publishes your IG to http://build.fhir.org. Because SUSHI is now included in the IG Publisher, when you check in your FSH files to a GitHub repository configured to autobuild, everything will run automatically to produce your IG.

To take advantage of autobuild with SUSHI support, the entire FSH tank must be put into a subdirectory named **fsh**:

```
{GitHub repository root}
      └── /fsh
          ├── File1.fsh
          ├── File2.fsh
          ├── File3.fsh
          ├── ...
          ├── package.json
          └── /ig-data (as shown above)
```
Every time you make a new commit to the repository, on any branch, the SUSHI and the IG Publisher will run automatically.

For testing purposes, it is useful to run the IG Publisher locally. If you are using the autobuild configuration, you need to manually [download the IG Publisher jar file](https://fhir.github.io/latest-ig-publisher/org.hl7.fhir.publisher.jar) and put it into the **/input-cache** directory:

```
{GitHub repository root}
      ├── /input-cache
      │   └── org.hl7.fhir.publisher.jar
      └── /fsh
          ├── File1.fsh
          ├── File2.fsh
          ├── File3.fsh
          ├── ...
          ├── package.json
          └── /ig-data (as shown above)
```

Instead of running `_genonce`, use the following command:

```
JAVA -jar input-cache/org.hl7.fhir.publisher.jar -ig .
```

The resulting directory structure will look something like this, with the home page of the resulting IG in the file **/output/index.html**:

```
{GitHub repository root}
      ├── /input
      ├── /input-cache
      ├── /output
      ├── /temp
      ├── /template
      ├── /fsh
      ├── ig.ini
      ├── package.json
      └── package-list.json
```
When your files are in the autobuild configuration, and you want to only run SUSHI, issue this command from your root directory:

```
$ sushi fsh -o .
```
This will create the **/input** directory containing the FHIR artifacts, but not the **/output,** **/temp** and **/template** directories.

### A Final Word

Thank you for using FHIR Shorthand and the SUSHI reference implementation. We hope it will help you succeed in your FHIR projects. The SUSHI software is provided free of charge. All we ask in return is that you share your ideas, suggestions, and experience with the community. If you are a Typescript developer, consider contributing to SUSHI open source project.

Here are some links to get started:

* Participate, ask or answer questions on the [#shorthand chat](https://chat.fhir.org/#narrow/stream/215610-shorthand).

* If you encounter issues with SUSHI, please report them on the [SUSHI issue tracker](https://github.com/FHIR/sushi/issues).

* For up-to-date information and latest releases of SUSHI, check the [release history and release notes](https://github.com/FHIR/sushi/releases).

* To download the source code, and contribute to SUSHI, check out the open source project [hosted on GitHub](https://github.com/FHIR/sushi).
