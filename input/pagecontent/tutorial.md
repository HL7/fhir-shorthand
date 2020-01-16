
[FHIR Shorthand](https://github.com/HL7/fhir-shorthand) (FSH) is a specially-designed language for defining the content of FHIR Implementation Guides (IGs). It is simple and compact, with tools to produce Fast Healthcare Interoperability Resources (FHIR) profiles, extensions and IGs. FSH is compiled from text files to FHIR artifacts using [SUSHI](https://github.com/standardhealth/sushi). To get started using FSH, you need to install and run SUSHI using the steps below.

**Platform notes:**

| Symbol | Explanation |
|:----------|:------|
| 🍎 | Indicates information or command specific to OS X. The instructions assume the shell script is **bash**. As of the Mac Catalina release, the default is **zsh** and will need to be reconfigured as a default or at runtime to call bash shell. You can find out the default shell in a Mac terminal by running `echo $SHELL`.|
| 💻 | Indicates information or command specific to Windows. A command window can be launched by typing `cmd` at the _Search Windows_ tool. |
| $ | Represents command prompt (may vary depending on platform) |

### Step 1: Install Node.js
SUSHI requires Node.js. To install Node.js, go to [https://nodejs.org/](https://nodejs.org/) and you should see links to download an installer for your operating system. Download the installer for the LTS version. If you do not see a download appropriate for your operating system, click the "other downloads" link and look there. Once the installer is downloaded, run the installer. It is fine to select default options during installation.

Ensure that Node.js is correctly installed by opening a command window and typing the following two commands. Each command should return a version number.
```
$ node --version
$ npm --version

### Step 2: Install SUSHI
To install SUSHI, open up a command prompt. 
```
For each command, you should see a version number. If this works correctly, you can install SUSHI by doing:
```
$ npm install -g fsh-sushi
``` 

### Step 3: Download Sample FSH Tank
To start with some working examples of FSH files and a skeleton FSH tank, [download the fsh-tutorial-master.zip file](fsh-tutorial-master.zip) and unzip it into a directory of your choice. 

You should see three subdirectories:

* _FishExample_
* _FishExampleComplete_
* _USCoreExample_ (this is a work in progress, so ignore it)

Change the working directory to FishExample. You should see two FSH files:

* _FishPatient.fsh_
* _Veterinarian.fsh_

In addition, there is a _package.json_ file and an _ig-data_ folder containing some inputs for building the IG.

### Step 4: Run SUSHI
Now that you have SUSHI installed and a minimal FSH tank, open up a command window, and navigate to the _FishExample_ directory. Run SUSHI on those FSH files by executing:

`$ sushi <path>`

where `<path>` is the path to the folder containing the FSH files. Since the working directory is already FishExample, type:

`$ sushi .`

This will create a _FishExample/build_ directory, and populate it with the files needed to create the IG using the HL7 FHIR IG Publisher tool. Optionally, you can specify your output directory name using the `-o` option.

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

Check to see if the _FishExample/build_ directory (or the directory you specified) is present, and change working directory of the command window to the _build_ directory. At the command prompt, enter:

💻   `$ _updatePublisher`

🍎   `$ sh _updatePublisher.sh`

This will download the latest version of the HL7 FHIR IG Publisher tool. **This step can be skipped if you already have the latest version of the IG Publisher tool.**

> **Note:** If you are blocked by a firewall, or if for any reason __updatePublisher_ fails to execute, download the current IG Publisher jar file [here](https://fhir.github.io/latest-ig-publisher/org.hl7.fhir.publisher.jar). When the file has downloaded, move it into the directory _/FishExample/build/input-cache_ (create the directory if necessary.)

**Step 5.5  Extra step to take because SUSHI is still under construction:** Manually copy the _Shorty.png_ file from _FishExample/ig-data/input/pagecontent_ to _FishExample/build/input/pagecontent_

Now run:

💻   `$ _genonce`

🍎   `$ sh _genonce.sh`


This will run the HL7 IG generator, which will take several minutes to complete. After the publisher is finished, open the file _/FishExample/build/output/index.html_ to see the resulting IG.

Under artifacts menu, the IG contains two profiles, FishPatient and Veterinarian. However, if you look more closely, they don't yet have any differentials.

### Step 6: Setting Cardinalities in a Profile

It is not widely known, but FHIR is designed to be used for veterinary medicine as well as human. For a non-human patient, we need to record the species. The Patients in this Tutorial are going to be various species of fish 🐟. 

Since (as far as we know) fish don't get married or communicate in a human language, the first thing we'll do in the Patient profile is eliminate these elements from Patient. To do this, open the file _FishPatient.fsh_ in your favorite plain-text editor, and add the following rules after `Description` line:

```
* maritalStatus 0..0
* communication 0..0
```

Note that rules start with `*`. The way FSH expresses cardinality, `{min}..{max}`, should be familiar to FHIR users.

### Step 7: Create a Species Extension for FishPatient

To specify the species of our aquatic patients, we'll need an extension.

Extensions are created using the `contains` keyword. To add a species extension, add the following rule after the cardinality rules:

`* extension contains FishSpecies 0..1`

This rule states that the `extension` array (built into the Patient resource) will now contain an [Extension element](https://www.hl7.org/fhir/extensibility.html#extension) by the name of 'FishSpecies'.

Now save your file, change the command window back to the _FishExample_ directory, and run SUSHI again (remember `$ sushi .`?). You should now get an error message from SUSHI indicating _"The slice FishSpecies on extension must reference an existing extension"_, indicating that you haven't defined the 'FishSpecies' extension.

To do this, add the following lines to the end of the _FishPatient.fsh_ file:

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

* Do you see where the FishPatient profile is in the IG?
* Does the differential reflect your changes?
* How does FHIR render the value set you defined?

### Step 9: Define an Alias

An `Alias` is a way to define a shorthand for a URL or OID. For example, in the extension definition above, we could have defined an `Alias` to make referencing the `http://snomed.info/sct` URL easier, as shown below. Aliases are conventionally defined at the top of the file.

Add this line at the top of the _FishPatient.fsh_ file:

`Alias:   SCT = http://snomed.info/sct`

and then replace the last line with:

`* codes from system SCT where code is-a SCT#90580008  "Fish (organism)"`

Using aliases has no effect on the IG; it simply makes the FSH code a bit neater.
