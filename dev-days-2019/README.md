
# Getting Started with FHIR Shorthand
[FHIR Shorthand](https://github.com/HL7/fhir-shorthand) (FSH) is a specially-designed language for defining the content of FHIR Implementation Guides (IGs). It is simple and compact, with tools to produce Fast Healthcare Interoperability Resources (FHIR) profiles, extensions and IGs. FSH is compiled from text files to FHIR artifacts using [SUSHI](https://github.com/standardhealth/sushi). To get started using FSH, you need to install and run SUSHI using the steps below.
### Step 1: Install Node.js
SUSHI requires Node.js. To install Node.js, go to [https://nodejs.org/](https://nodejs.org/) and you should see links to download an installer for your operating system. Download the installer for the LTS version. If you do not see a download appropriate for your operating system, click the "other downloads" link and look there. Once the installer is downloaded, run the installer. It is fine to select default options during installation.
### Step 2: Install SUSHI
To install SUSHI, open up a command prompt. Ensure that Node.js is correctly installed by running the following two commands
```
$ node --version
$ npm --version
```
For each command, you should see a version number. If this works correctly, you can install SUSHI by doing
```
$ npm install -g fsh-sushi
``` 
### Step 3: Download Sample FSH Files
To start with some working examples of FSH files, visit the this repository's [home page](https://github.com/HL7/fhir-shorthand). If you are comfortable using `git`, you can clone this repository by doing
```
$ git clone https://github.com/standardhealth/sushi.git
```
If you do not use `git`, click the "Clone or Download" button, the click "Download Zip". When the zip file is downloaded, unzip it to the folder of your choosing. The folder `dev-days-2019/working-samples` contains a set of FSH files that use only syntax that is currently supported by SUSHI. Note that the `samples` folder contains syntax that is **not** yet supported. Do not try to run SUSHI using that folder.
### Step 4: Run SUSHI
Now that you have SUSHI installed and a folder containing FSH files, you can run SUSHI on those FSH files by executing
```
$ sushi <path>
```
Where `<path>` is the path to the folder containing the FSH files. So if your FSH files were in `~/fhir-shorthand/dev-days-2019/working-samples`, the command would be
```
$ sushi ~/fhir-shorthand/dev-days-2019/working-samples
```
This will send the resulting FHIR output to an `out` directory in your current working directory. Optionally, you can specify your output directory name using the `-o` option.
```
$ sushi <path> -o <output-directory>
```
### Step 5: Experiment
SUSHI is still a work in progress, so not every feature described on the [wiki](https://github.com/HL7/fhir-shorthand/wiki) is currently supported. Below is a list of all of the features that are supported. Modify the given examples to see how things change, or try to create some profiles of your own.
#### Defining a Profile
This functionality allows you to constrain the elements of a FHIR resource. In the example below, we are defining a `Profile` called `FSHPatient` that is based on the FHIR Patient resource, as indicated by the `Parent` keyword. Then the `Id`, `Title`, and `Description` keywords are used to set metadata on this profile. Below that, we begin constraining the original FHIR resource using rules.
```
Profile:        FSHPatient
Parent:         Patient
Id:             fsh-patient
Title:          "FSH Patient"
Description:    """ 
    Defines constraints and extensions on the patient resource for 
    the minimal set of data to query and retrieve patient demographic information."""
* identifier, identifier.system, identifier.value, name, name.family, name.given
  telecom, telecom.system, telecom.value, telecom.use, gender, birthDate, address,
  address.line, address.city, address.state, address.postalCode, communication,
  communication.language MS
* identifier 1..*
* identifier.system 1..1
* identifier.value 1..1
* name 1..*
// More rules
```
#### Defining an Extension
To add information to a FHIR resource, we create extensions and add them to profiles. Creating an extension is a supported feature, but adding that extension to a profile is not yet supported. In this example, we create an `Extension` called `FSHBirthSex`, and then set metadata using the same keywords as in a profile. Note that an `Extension` does not need a `Parent`, because it is not based on any specific FHIR resource.
```
Extension:      FSHBirthSex 
Id:             fsh-birthsex
Title:          "FSH Birth Sex Extension"
Description:     """
    A code classifying the person's sex assigned at birth as specified 
    by the [Office of the National Coordinator for Health IT (ONC)](https://www.healthit.gov/newsroom/about-onc). 
    This extension aligns with the C-CDA Birth Sex Observation (LOINC 76689-9)."""
* value[x] only code
* valueCode from http://hl7.org/fhir/us/core/ValueSet/birthsex (required)
```
#### Defining an Alias
An `Alias` is a way to define an shorthand for a URL or OID. For example, in the extension definition above, we could have defined an `Alias` to make referencing the `http://hl7.org/fhir/us/core/ValueSet/birthsex` URL easier, as shown below.
```
Alias:      BSEX = http://hl7.org/fhir/us/core/ValueSet/birthsex
Extension:      FSHBirthSex 
Id:             fsh-birthsex
Title:          "FSH Birth Sex Extension"
Description:     """
    A code classifying the person's sex assigned at birth as specified 
    by the [Office of the National Coordinator for Health IT (ONC)](https://www.healthit.gov/newsroom/about-onc). 
    This extension aligns with the C-CDA Birth Sex Observation (LOINC 76689-9)."""
* value[x] only code
* valueCode from BSEX (required)
```
#### Rules
In a rule, an element is accessed via its path, and then some constraint is applied to that element. The supported rules are listed below.
| Rule Type | Rule Syntax | Example |
| --- | --- |---|
| Fixed Value |`* path = value`  | `* experimental = true` <br/> `* status = #active` <br/> `* valueString = "foo"` <br/> `* valueQuantity.value = 1.23` |
| Binding to a Value Set |`* path from valueSet (strength)`| `* telecom.system from http://hl7.org/fhir/ValueSet/contact-point-system (required)` |
| Narrowing a choice | `* path only type1 or type2 or type3` | `* value[x] only code` <br> `* value[x] only code or string` |
| Narrowing cardinality | `* path min..max` | `* identifier 1..*` <br> `* identifier.system 1..1`
| Assigning Flags (MS, SU, ?!) | `* path flag1 flag2` <br> `* path1, path2, path3 flag` | `* communication MS ?!` <br> `* identifier, identifier.system, identifier.value, name, name.family MS`