SUSHI ("SUSHI Unshortens ShortHand Inputs") is a reference implementation of an interpreter/compiler for the FHIR Shorthand ("FSH" or "Shorthand") language. SUSHI produces [Health Level Seven (HL7®) Fast Healthcare Interoperability Resources (FHIR®)](https://www.hl7.org/fhir/overview.html) profiles, extensions, and other artifacts needed to create FHIR Implementation Guides (IG).

> **Note:** HL7® and FHIR® are registered trademarks owned by Health Level Seven International, and are registered with the United States Patent and Trademark Office.

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
-o, --out <out>          the path to the output folder (default: /build)
-h, --help               output usage information
```

The options are not order-sensitive.

If you run SUSHI from the same folder where your .fsh files are located, and you use the default output location, the command can be shortened to:

`$ sushi .`

The resulting resources are found in in _/build/input/resources_. The subdirectory _/input/resources_ is automatically created because that is the location that the FHIR publisher expects to find the artifacts when the publishing the IG, if the IG publisher is run from the _/build_ directory.

#### Error Messages

In the process of developing your IG using FSH, you will inevitably encounter SUSHI error messages. Debugging the model is an iterative process, and it could take some time to arrive at a clean compile. If possible, SUSHI will produce StructureDefinitions even if there are compile errors, but those SDs will omit any problematic rules.

Here are some general tips on approaching debugging your model:

* Eliminate parsing (syntax) errors first.
* Most error messages include a file name and line number. This should pinpoint the source of the error.
* SUSHI should always exit gracefully. If SUSHI crashes, please report the issue using the [SUSHI issue tracker](https://github.com/FHIR/sushi/issues).

### Creating the IG

#### Setting Up

When SUSHI runs, in addition to creating the StructureDefintions, examples, and other artifacts, it has the capability to create additional files necessary to run the HL7 IG Publisher. This functionality will be executed only if SUSHI finds a directory named _/ig-data_ in the FSH tank.

🚧 Currently, SUSHI provides limited support for customizing your IG. Additional features are planned. To customize your IG, see [Customizing your IG](#customizing-your-ig).

To begin, follow these steps:

1. Create a _package.json_ file appropriate to your IG. The format and content of this file is [disussed here](https://confluence.hl7.org/pages/viewpage.action?pageId=35718629#NPMPackageSpecification-Packagemanifest). Put the _package.json_ at the top level of your FSH tank (the folder with your _.fsh_ files).
1. In your FSH Tank, create an _/ig-data_ subdirectory
1. In the _/ig-data_ directory, create a _/pagecontent_ subdirectory.
1. Create an index.md (markdown format) file containing the content for the home page of your IG, and put the file in the _/ig-data/pagecontent_ directory.

After completing these steps, re-run SUSHI. SUSHI will create and populate a _/build_ directory (or a directory name of your choice, with the `-o` flag) with all the files necessary to run the IG Publisher.

#### Downloading and Running the IG Publisher

At the command prompt, enter:

💻   `$ _updatePublisher`

🍎   `$ sh _updatePublisher.sh`

This will download the latest version of the HL7 FHIR IG Publisher tool. **This step can be skipped if you already have the latest version of the IG Publisher tool.**

> **Note:** If you are blocked by a firewall, or if for any reason __updatePublisher_ fails to execute, download the current IG Publisher jar file [here](https://fhir.github.io/latest-ig-publisher/org.hl7.fhir.publisher.jar). When the file has downloaded, move it into the directory _/build/input-cache_ (create this directory if necessary.)

Now run:

💻   `$ _genonce`

🍎   `$ sh _genonce.sh`


This will run the HL7 IG Publisher, which will take several minutes to complete. After the publisher is finished, open the file _/build/output/index.html_ to see the resulting IG.

#### Customizing your IG

🚧 The procedures here are a temporary workarounds, until SUSHI provides support for customizations.

Take the following steps to further customize your IG:

1. Make sure you have run SUSHI at least once and successfully produced the IG at least once, so you are sure the _/build_ directory exists, and contains the directories and files needed to run the IG Publisher. 
1. Make sure all the files in _/ig-data/pagecontent_ have been copied to _/build/input/pagecontent_. If not, manually copy them over.
1. Remove the _/ig-data_ directory from the FSH Tank (you may delete it, but it is safer to preserve it at another location.)
1. Introduce any desired customizations into the following files:
    * **Menus:** Edit _/build/input/include/menu.xml_
    * **List of pages and artifacts to be included in the IG:** Edit _/build/input/ImplementationGuide-{name}.json_. See [ImplementationGuide resource](https://www.hl7.org/fhir/implementationguide.html) for details.
    * **Additional pages:** Add your files to _/build/input/pagecontent_ directory, and link them to menus or other pages.
    * **Images and other files:** Anything that is not a page in the IG, such as images, spreadsheets or zip files, put in _/build/input/images_.
    * **Version history:** Edit _/build/package-list.json_

When SUSHI does not find the _/ig-data_ directory, it will only populate the _/build/input/resources_ directory, leaving your customizations intact.

> **Note:** After you introduce customizations, do **not** re-create the _/ig-data_ directory in the FSH tank, or SUSHI may overwrite the customizations you have introduced in _/build/input_.

### Get Involved!

#### Reporting Issues

If you have issues with SUSHI, please report them on the [SUSHI issue tracker](https://github.com/FHIR/sushi/issues).

#### SUSHI Releases

For the most up-to-date information and latest releases of SUSHI, check the [release history and release notes](https://github.com/FHIR/sushi/releases).

#### Contributing to SUSHI

SUSHI is an open source project [hosted on Github](https://github.com/FHIR/sushi). Contributions are welcome.
