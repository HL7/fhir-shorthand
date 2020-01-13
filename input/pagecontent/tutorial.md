
# Getting Started with FHIR Shorthand
[FHIR Shorthand](https://github.com/HL7/fhir-shorthand) (FSH) is a specially-designed language for defining the content of FHIR Implementation Guides (IGs). It is simple and compact, with tools to produce Fast Healthcare Interoperability Resources (FHIR) profiles, extensions and IGs. FSH is compiled from text files to FHIR artifacts using [SUSHI](https://github.com/standardhealth/sushi). To get started using FSH, you need to install and run SUSHI using the steps below.

### Step 1: Install Node.js
SUSHI requires Node.js. To install Node.js, go to [https://nodejs.org/](https://nodejs.org/) and you should see links to download an installer for your operating system. Download the installer for the LTS version. If you do not see a download appropriate for your operating system, click the "other downloads" link and look there. Once the installer is downloaded, run the installer. It is fine to select default options during installation.

### Step 2: Install SUSHI
To install SUSHI, open up a command prompt. Ensure that Node.js is correctly installed by running the following two commands:
```
$ node --version
$ npm --version
```
For each command, you should see a version number. If this works correctly, you can install SUSHI by doing:
```
$ npm install -g fsh-sushi
``` 

### Step 3: Download Sample FSH Tank
To start with some working examples of FSH files and a skeleton FSH tank, [download the fsh-tutorial-master.zip file](fsh-tutorial-master.zip) and unzip it into a directory of your choice. 

You should see three subdirectories:

* FishExample
* FishExampleComplete
* USCoreExample

Change the working directory to FishExample. You should see two FSH files:

* FishPatient.fsh
* Veterinarian.fsh

In addition, there is an ig-data folder containing some inputs for building the IG.

### Step 4: Run SUSHI
Now that you have SUSHI installed and a FSH tank, you can run SUSHI on those FSH files by executing:

`$ sushi <path>`

where `<path>` is the path to the folder containing the FSH files. Since the working directory is already FishExample, type:

`$ sushi .`

This will send the resulting FHIR output to an `build` directory in your current working directory. Optionally, you can specify your output directory name using the `-o` option.

`$ sushi <path> -o <output-directory>`

When running SUSHI successfully, you should see output similar to the following:

```
info: 
   Profiles:   2
   Extensions: 0
   Instances:  0
   Errors:     0
   Warnings:   0
```

### Step 5: Generate the Sample IG

Check to see if the /build directory (or the directory you specified) is present.

Now change directory of the command window to the output directory, `~/FishExample/build`. At the command prompt, enter:

`$ ./updatePublisher.sh`

This will download the latest version of the HL7 FHIR IG Publisher tool. Now run:

`$ ./_genonce.sh`

This will run the HL7 IG generator, which will take several minutes to complete. After the publisher is finished, open the file `/FishExample/build/output/index.html` to see the resulting IG.

Under artifacts menu, the IG contains two profiles, FishPatient and Veterinarian. However, if you look more closely, they don't yet have any differentials.

### Step 6: Disallow Married and Talking Animals

FHIR is intended to be used for both human and animal medicine. For any non-human patient, we need to record the species. Our example is going to have a patient that is - appropriately -  a fish. 

Since (as far as we know) fish don't get married or communicate in a human language, the first thing we'll do is eliminate these elements from Patient. To do this, and add the following rules after `Description` line:

* maritalStatus 0..0
* communication 0..0

Note that rules start with `*`. The way that cardinality is expressed should be familiar to FHIR users.

### Step 7: Create a Species Extension for FishPatient

To specify the species of our fish patient, we'll need an extension.

Extensions are created using the `contains` keyword. To add a species extension, open the file FishPatient.fsh, and add the following rule after the cardinality rules:

`* extension contains FishSpecies 0..1`

This rule states that the existing `extension` array built into Patient will now contain an [Extension](https://www.hl7.org/fhir/extensibility.html#extension) element named `FishSpecies`.

Now change the command prompt back to the FishExample directory, and run SUSHI again. You should now get an error message from SUSHI indicating _"The slice FishSpecies on extension must reference an existing extension"_, indicating that you have to define the FishSpecies extension.

To do this, add the following lines to the end of the FishPatient.fsh file:

```
Extension:  FishSpecies
Id: fish-species
Title: "Fish Species"
Description: "The species name of a piscine (fish) patient."
```

Run SUSHI again. The previous error message should disappear, and the count of Extensions should go up by 1.

### Step 8: Define a Value Set for Fish Species

The FishSpecies extension doesn't quite do its job yet, because we haven't specified what type of values it might accept. To add this information, enter these lines following the description of FishSpecies:

```
* value[x] only CodeableConcept
* valueCodeableConcept from FishSpeciesValueSet (extensible)
```

The first rule restricts the value[x] (an element of every extension) to a CodeableConcept using the `only` keyword. The second extensibly binds it to a value set containing codes for fish species (yet to be defined) using the `from` keyword.

If we compile at this point, SUSHI will note that FishSpeciesValueSet doesn't exist. To define it, add the following lines to the same file:

```
ValueSet:  FishSpeciesValueSet
Title: "Fish Species Value Set"
Description:  "Codes describing various species of fish from SNOMED-CT."
* codes from system http://snomed.info/sct where code is-a SCT#90580008  "Fish (organism)"
```

The rule that selects all the codes from SNOMED-CT that are children of the concept "Fish (organism)".

Run SUSHI again, and if are no errors, try generating the IG by running `_genonce` again in the build subdirectory. Open the file `/FishExample/build/output/index.html` to see the resulting IG.

* Does the differential reflect your changes?
* How does FHIR render the value set?

### Step 9: Define an Alias

An `Alias` is a way to define an shorthand for a URL or OID. For example, in the extension definition above, we could have defined an `Alias` to make referencing the `http://snomed.info/sct` URL easier, as shown below. Aliases are conventionally defined at the top of the file.

`Alias:   SCT = http://snomed.info/sct`

Then replace the last line with

`* codes from system SCT where code is-a SCT#90580008  "Fish (organism)"`
