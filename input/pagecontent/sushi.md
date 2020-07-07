
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

Use `$ sushi -v` to display the current version of SUSHI and the version of FSH specification supported by the current version of SUSHI. SUSHI follows the [semantic versioning](https://semver.org) convention (MAJOR.MINOR.PATCH):

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
-v, --version     output the version of SUSHI and the version of FSH specification implemented
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

* Eliminate parsing (syntax) errors first. Syntax error messages may include `extraneous input {x} expecting {y}`, `mismatched input {x} expecting {y}` and `no viable alternative at {x}`. These messages indicate that the line in question is not a valid FSH statement.
* The order of keywords is not arbitrary. The declarations must start with the type of item you are creating (e.g., Profile, Instance, ValueSet).
* The order of rules usually doesn't matter, but there are exceptions. Slices and extensions must be created before they are constrained.
* A common error is `No element found at path`. This means that although the overall grammar of the statement is correct, SUSHI could not find the FHIR element you are referring to in the rule. Make sure there are no spelling errors, the element names in the path are correct, and you are using the [path grammar](reference.html#fsh-paths) correctly.
* If you are getting an error you can't resolve, you can ask for help on the [#shorthand chat channel](https://chat.fhir.org/#narrow/stream/215610-shorthand).

### IG Development

SUSHI supports publishing implementation guides via the [template-based IG Publisher](https://build.fhir.org/ig/FHIR/ig-guidance/). This section describes the inputs and outputs from this process.

#### Configuration File

Certain additional information, above and beyond what is found in `.fsh` files, is needed to produce an IG.

* The HL7 FHIR IG Publisher relies on several configuration files, including **ig.ini**, **package-list.json**, **menu.xml**, and an instance of the ImplementationGuide resource. Splitting information among multiple files and managing different formats makes IG configuration difficult to manage. There is also some duplication of information between these files.

* SUSHI offers the same functionality in a single configuration file, in consistent format, with no duplication of information. This file is written using [YAML](https://yaml.org/).

Here is a simple example of a config.yaml file:

```yaml
id: fhir.us.example
canonical: http://hl7.org/fhir/us/example
name: ExampleIG
title: "HL7 FHIR Implementation Guide: Example IG Release 1 - US Realm | STU1"
description: An example IG that exercises many of the fields in a SUSHI configuration
status: active
license: CC0-1.0
version: 1.0.0
fhirVersion: 4.0.1
template: hl7.fhir.template#0.0.5
copyrightYear: 2019+
releaseLabel: STU1
publisher:
  name: HL7 FHIR Management Group
  url: http://www.hl7.org/Special/committees/fhirmg
  email: fmg@lists.HL7.org
dependencies:
  hl7.fhir.us.core: 3.1.0
```

In YAML:

* White space (new lines and indentation) is significant
* Information is presented in `key: value` pairs
* Strings do not have to be quoted unless they contain reserved characters, such as colon (:)
* Arrays/sequences are created using indentation or `-`

While there are a variety of properties that can be used in the SUSHI configuration file, only a few are needed to create a complete IG. Readers are encouraged to examine the following examples:

* For an example of the minimal configuration, see the [minimal configuration file](minimal-config.yaml).

* For an example of a more extensive configuration file, see the [example configuration file](config.yaml).

Most properties that can be used in the SUSHI configuration file come directly from the [Implementation Guide resource](https://www.hl7.org/fhir/implementationguide.html#resource). Below are properties that can be used in SUSHI configuration, and any differences between those properties and the FHIR source are highlighted.

| Property  | Corresponding IG element | Usage   |
| :---------------------- | :-------------------------- |:---------|
| id | id | As specified in the IG resource |
| meta | meta | As specified in the IG resource |
| implicitRules | implicitRules | As specified in the IG resource |
| language | language | As specified in the IG resource |
| text | text | As specified in the IG resource |
| contained | contained | As specified in the IG resource |
| extension | extension | As specified in the IG resource |
| modifierExtension | modifierExtension | As specified in the IG resource |
| url | url | As specified in the IG resource. If not specified, defaults to `${canonical}/ImplementationGuide/${id}`. |
| version | version | As specified in the IG resource |
| name | name | As specified in the IG resource |
| title | title | As specified in the IG resource |
| status | status | As specified in the IG resource |
| experimental | experimental | As specified in the IG resource |
| date | date | As specified in the IG resource |
| publisher | publisher, with cardinality changed to 0..* | Publisher can be a single item or a list, each with a name and optional url and/or email. The first publisher's name will be used as IG.publisher.  The contact details and/or additional publishers will be translated into IG.contact values |
| contact | contact | As specified in the IG resource |
| description | description | As specified in the IG resource |
| useContext | useContext | As specified in the IG resource |
| jurisdiction | jurisdiction | As specified in the IG resource |
| copyright | copyright | As specified in the IG resource |
| packageId | packageI | As specified in the IG resource. If not specified, defaults to `id`. |
| license | license | As specified in the IG resource |
| fhirVersion | fhirVersion | As specified in the IG resource |
| dependencies | dependsOn | A `key: value` pair, where key is the package id and value is the version (or dev/current). |
| global | global | Key is the type and value is the profile |
| groups | definition.grouping | A `key: value` pair, where key is the name of the package and value is the description of the package |
| resources | definition.resource | SUSHI can auto-generate a list of resources based on FSH definitions and provided JSON resources, but this property can be used to add additional entries or override generated entries. SUSHI uses the {resource type}/{resource name} format as the YAML key (corresponding to IG.definition.resource.reference). Authors can specify the value "omit" to omit a FSH-generated resource from the resource list. `groupingId` can be used, but top-level groups syntax may be a better option. |
| pages | definition.page | SUSHI can auto-generate pages, but authors can manage pages through this property. If this property is used, SUSHI will not generate any page entries. The YAML key is the file name containing the page. The title key-value pair provides the title for the page. If a title is not provided, then the title will be generated from the file name. If a generation value (corresponding to definition.page.generation) is not provided, it will be inferred from the file name extension. In the IG resource, pages can contain sub-pages; so in the config file, any sub-properties that are valid filenames with supported extensions (e.g., .md/.xml) will be treated as sub-pages. |
| parameters | definition.parameter | The key is the code. If a parameter allows repeating values, the value in the YAML may be a sequence/array. |
| templates | definition.template | As specified in the IG resource |
| copyrightYear or copyrightyear | N/A | Used to add a `copyrightyear` parameter to `IG.definition.parameter` |
| releaseLabel or releaselabel | N/A | Used to add a `releaseLabel` parameter to `IG.definition.parameter` |
| canonical | N/A | The canonical URL to be used throughout the IG |
| template | N/A | Template used in `ig.ini` file. <br><br> Authors can provide their own `ig.ini` file by removing this property and placing an `igi.ini` file in the `ig-data` directory. |
| menu | N/A | Used to generate the input/index.md file. The key is the menu item name and the value is the URL. Menus can contain sub-menus, but the IG Publisher currently only supports sub-menus one level deep. <br><br> Authors can provide their own `menu.xml` by removing this property and placing a `menu.xml` file in `ig-data/input/includes` |
| history | N/A | Used to create a `package-list.json`. SUSHI will use the existing top-level properties in its config to populate the top-level package-list.json properties: package-id, canonical, title, and introduction. Authors who wish to provide different values can supply them as properties under history. All other properties under history are assumed to be versions. <br><br> Additionally, the current version is special. If the author provides only a single string value, it is assumed to be the URL path to the current build. The following default values will then be used: `desc: Continuous Integration Build` (latest in version control), `status: ci-build`, and `current: true`. <br><br> Authors can provide their own `package-list.json` by removing this property and placing a `package-list.json` file in `ig-data`. |
| indexPageContent | N/A | This property is provided for backwards compatibility reasons, and its use is discouraged. It was used to specify the content of `index.md`, however, authors should provide their own index file by not using this property and placing an `index.md` or `index.html` file in `input/pages` or `input/pagecontent`.  |
| FSHOnly | N/A | When this flag is set to true, no IG specific content will be generated, SUSHI will only convert FSH definitions to JSON files. When false or unset, IG content is generated. |
{: .grid }

#### SUSHI Inputs

SUSHI uses your FSH files, the **config.yaml** file, and the contents of a user-created **ig-data** directory to generate the inputs to the IG Publisher. For a bare-bones IG with no customization, create a minimal **config.yaml** file. For a customized IG, use the additional properties in the **config.yaml** file. Additionally, you can create and populate the **ig-data** folder with custom content for **package-list.json**, **ig.ini**, **menu.xml**, **index.md** (or **index.xml**), pages, images, and other IG Publisher inputs.

The FSH tank (project directory) should look something like this:

```
File1.fsh
File2.fsh
File3.fsh
config.yaml
/ig-data (optional)
├── package-list.json (config.yaml history property can be used instead)
├── ig.ini (config.yaml template property can be used instead)
└── /input
    ├── ignoreWarnings.txt (optional)
    ├── /images
    │   ├── myGraphic.jpg
    │   ├── myDocument.docx
    │   └── mySpreadsheet.xlsx
    ├── /includes
    │   └── menu.xml (config.yaml menu property can be used instead)
    └── /pagecontent
        ├── index.md
        ├── 1_mySecondPage.md
        ├── 2_myThirdPage.md
        └── 3_myFourthPage.md
```

Populate your project as follows:

* **config.yaml**: This required file provides all configuration for SUSHI and IG creation. The content is described [here](#configuration-file).
* **package-list.json**: This optional file, described [here](https://confluence.hl7.org/display/FHIR/FHIR+IG+PackageList+doco), should contain the version history of your IG. If present and no `history` property is specified in **config.yaml**, it will be used instead of a generated **package-list.json**.
* **ig.ini**: If present and no `template` property is specified in **config.yaml**, the user-provided file will be used instead of a generated one.
* **ignoreWarnings.txt**: If present, this file can be used to suppress specific QA warnings and information messages during the FHIR IG publication process.
* The **/images** subdirectory: Put anything that is not a page in the IG, such as images, spreadsheets or zip files, in the **images** subdirectory. These files will be copied into the build and can be referenced by user-provided pages or menus.
* **menu.xml**: If present and no `menu` property is specified in **config.yaml**, this file will be used for the IG's main menu layout.
* The **/pagecontent** subdirectory, put either markup (.xml) or markdown (.md) files with the narrative content of your IG. These files are the sources for the html pages that accompany the automatically-generated pages of your IG. The header and footer of these pages are automatically generated, so your content should not include these elements. Any number of pages can be added. In addition to stand-alone pages, you can provide additional text for generated artifact pages. The naming of these files is significant:
  * **index.xml\|md**: This file provides the content for the IG's main page, unless the `indexPageContent` property is specified in **config.yaml**, in which case this file should not exist. Providing an index file is strongly recommended over inlining the content in **config.yaml**.
  * **N\_pagename.xml\|md**: If present, these files will be generated as individual pages in the IG. The leading integer (N) determines the order of the pages in the table of contents. These numbers are stripped and do not appear in the actual page URLs.
  * **{artifact-file-name}-intro.xml\|md**: If present, the contents of the file will be placed on the relevant page _before_ the artifact's definition.
  * **{artifact-file-name}-notes.xml\|md**: If present, the contents of the file will be placed on the relevant page _after_ the artifact's definition.
* **input/{supported-resource-input-folder}** (not shown above): JSON files in supported resource folders (e.g., **profiles**, **extensions**, **examples**, etc.) will be be copied to the corresponding locations in the IG input and processed as additional (non-FSH) IG resources. This feature is not expected to be commonly used.

Examples of **package.json**, **ig.ini**, **package-list.json**, **ignoreWarnings.txt** and **menu.xml** files can be found in the [sample IG project](https://github.com/FHIR/sample-ig) provided for this purpose. More general guidance can be found in [Guidance for HL7 IG Creation](https://build.fhir.org/ig/FHIR/ig-guidance/). The [mCODE Implementation Guide](https://github.com/standardhealth/fsh-mcode) has a good example of a populated **ig-data** directory.

> ** Note:** If no IG is desired, and you only want to export the FHIR artifacts (e.g., profiles, extensions, etc.), ensure that the `FSHOnly` flag is enabled in **config.yaml**.

#### SUSHI Outputs

Based on the inputs in FSH files, **config.yaml**, and the **ig-data** directory, SUSHI populates the specified output directory (**build** by default). SUSHI will create the [ImplementationGuide resource](http://hl7.org/fhir/R4/implementationguide.html) for your IG, which can be found in **/build/input** after you run SUSHI.

The resulting **/build** directory will look something like this:

```
/build
├── _genonce.bat
├── _genonce.sh
├── _gencontinuous.bat
├── _gencontinous.sh
├── _updatePublisher.sh
├── _updatePublisher.sh
├── package-list.json (generated or copied from fsh tank)
├── ig.ini  (generated or copied from fsh tank)
└── /input
    ├── ImplementationGuide-myIG.json (generated)
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
    │   └── menu.xml (generated or copied from fsh tank)
    ├── /pagecontent
    │   ├── index.md (generated or copied from fsh tank)
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

> **Note:** If you are blocked by a firewall, or if for any reason `_updatePublisher` fails to execute, download the current IG Publisher jar file [here](https://github.com/HL7/fhir-ig-publisher/releases/latest/download/publisher.jar). When the file has downloaded, move it into the directory **/build/input-cache** (creating the directory if necessary.)

Now run the following command:

```
💻  $ _genonce
```

```
🍎  $ ./_genonce.sh
```
This will run the HL7 IG Publisher, which may take several minutes to complete. After the publisher is finished, open the file **/build/output/index.html** in a browser to see the resulting IG.

> **Note:** `_genonce` embeds the command `JAVA -jar input-cache/org.hl7.fhir.publisher.jar -ig ig.ini`. If the publisher jar or `ig.ini` file are in different locations, the command can be adjusted accordingly.

### IG Publisher Integration (Autobuild Configuration)

The IG Publisher version 1.0.75 and higher includes native support for FSH and SUSHI. The IG Publisher launches SUSHI and runs it if it detects a folder named **/fsh**. Not having to run SUSHI separately is a minor benefit, but there is a significant advantage related to the _autobuild_ process.

[Autobuild](https://github.com/FHIR/auto-ig-builder/blob/master/README.md) is a build service that can be triggered when you commit IG source code to any GitHub repository. Autobuild starts the IG Publisher and publishes your IG to http://build.fhir.org. Because SUSHI is now included in the IG Publisher, when you check your FSH files into a GitHub repository configured to autobuild, everything will run automatically to produce your IG.

To take advantage of autobuild with SUSHI support, the entire FSH tank must be put into a subdirectory named **fsh**:

```
{GitHub repository root}
      └── /fsh
          ├── File1.fsh
          ├── File2.fsh
          ├── File3.fsh
          ├── ...
          ├── config.yaml
          └── /ig-data (as shown above)
```
Every time you make a new commit to the repository, on any branch, the SUSHI and the IG Publisher will run automatically.

For testing purposes, it is useful to run the IG Publisher locally. If you are using the autobuild configuration, you need to manually [download the IG Publisher jar file](https://storage.googleapis.com/ig-build/org.hl7.fhir.publisher.jar) and put it into the **/input-cache** directory:

```
{GitHub repository root}
      ├── /input-cache
      │   └── org.hl7.fhir.publisher.jar
      └── /fsh
          ├── File1.fsh
          ├── File2.fsh
          ├── File3.fsh
          ├── ...
          ├── config.yaml
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
