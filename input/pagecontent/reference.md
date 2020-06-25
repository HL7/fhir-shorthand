This chapter describes the FHIR Shorthand (FSH) language in detail. It is intended as a reference manual, not a pedagogical document. 

This chapter uses the following conventions:

| Style | Explanation | Example |
|:----------|:------|:---------|
| `Code` | Code fragments, such as commands, FSH statements, and syntax expressions  | `* status = #open` |
| {curly braces} | An item to be substituted in a syntax pattern | `{codesystem}#{code}` |
| **bold** | A directory path or file name | **example-1.fsh** |
{: .grid }

### FSH Foundations

#### Versioning

The FSH specification, like other IGs, follows the [semantic versioning](https://semver.org) convention (Major.Minor.Patch).

#### Formal Grammar

[FSH has a formal grammar](#formal-grammar) defined in [ANTLR4](https://www.antlr.org/). If there is discrepancy between the grammar and the FSH language description, the language description is considered correct until the discrepancy is clarified and addressed. The grammar is looser than the language since many things such as data type agreement are not enforced in the grammar.

#### Reserved Words

FSH has a number of reserved words, symbols, and patterns. Reserved words and symbols are: `contains`, `named`, `and`, `only`, `or`, `obeys`, `true`, `false`, `exclude`, `codes`, `where`, `valueset`, `system`, `from`, `insert`, `!?`, `MS`, `SU`, `N`, `TU`, `D`, `=`, `*`, `:`, `->`, `.`.

The following words are reserved only if followed by a colon (intervening white spaces allowed): `Alias`, `Profile`, `Extension`, `Instance`, `InstanceOf`, `Invariant`, `ValueSet`, `CodeSystem`, `RuleSet`, `Parent`, `Id`, `Title`, `Description`, `Expression`, `XPath`, `Severity`, `Usage`, `Source`, `Target`.

The following words are reserved only when enclosed in parentheses (intervening white spaces allowed): `example`, `preferred`, `extensible`, `required`, `exactly`.

#### Primitives

The primitive data types and value formats in FSH are identical to the [primitive types and value formats in FHIR](https://www.hl7.org/fhir/datatypes.html#primitive). References in this document to `code`, `id`, `oid`, etc. refer to the primitive datatypes defined in FHIR.

FSH strings support the escape sequences that FHIR already defines as valid in its [regex for strings](https://www.hl7.org/fhir/datatypes.html#primitive): \r, \n, and \t.

#### FSH Names

FSH uses names to refer to items within the same [FSH tank](index.html#fsh-files-and-fsh-tanks). Names follow [FHIR naming guidance](http://hl7.org/fhir/R4/structuredefinition-definitions.html#StructureDefinition.name). Names must be between 1 and 255 characters, begin with an uppercase, and contain only letters, numbers, and "_". By convention, names should use [PascalCase (also known as UpperCamelCase)](https://wiki.c2.com/?UpperCamelCase).

Alias names may begin with `$`. Choosing alias names beginning with `$` allows for [additional error checking](#defining-aliases).

#### Identifiers

Items in FSH may have an identifier, typically specified using the [`Id` keyword](#defining-items). Each id must be unique within the scope of their item type in the FSH Tank, but are recommended to be unique across all types in the FSH Tank. For example, two Profiles with id “foo” cannot coexist, but it is possible to have a Profile with id “foo” and a ValueSet with id “foo” in the same FSH Tank.

If no Id is provided, implementations may create an Id. It is recommended that the Id be based on the item's name, with _ replaced by -, and the overall length truncated to 64 characters (per the requirements of the FHIR id datatype).

#### References to External FHIR Artifacts

FHIR resources, profiles, extensions, and value sets defined outside the [FSH tank](index.html#fsh-files-and-fsh-tanks) are referred to by their canonical URIs. Base FHIR resources can also be referred to by their id, for example, `Patient` or `Observation`. In cases where an IG defines a profile or extension matching an existing FHIR ID, use the canonical URL to refer to the FHIR resource.

#### Files

Content in one project can be contained in one or more files with **.fsh** extension. How content is divided among files is not meaningful in FSH, and all content can be considered pooled together for the purposes of FSH. It is up to implementations to define which **.fsh** files should be included in a given project.

#### Order of Items in Files

The items defined by FSH are: Aliases, Profiles, Extensions, Instances, Value Sets, Code Systems, Mappings, Rule Sets, and Invariants. Items can appear in any order within **.fsh** files, and can be moved around within a file (or to other **.fsh** files) without affecting the interpretation of the content.

#### Whitespace

Repeated whitespace is not meaningful within FSH files (except within string literals). This:

```
Profile:  SecondaryCancerCondition
Parent:   CancerCondition
* focus only PrimaryCancerCondition
```

is equivalent to:
```
             Profile:  
SecondaryCancerCondition     Parent: CancerCondition

         * focus only
PrimaryCancerCondition
```

#### Comments

FSH follows [JavaScript syntax](https://www.w3schools.com/js/js_comments.asp) for code comments:

```
// Use a double-slash for comments on a single line

/*
Use slash-asterisk and asterisk-slash for larger block comments.
These comments can take up multiple lines.
*/
```

The formal grammar for FSH discards all comments during import; they are not retained or used during IG generation.

#### Multi-line Strings

For convenience, FSH also supports multi-line strings, demarcated with three double quotation marks `"""`. This feature allows for authors to split text over multiple lines and retain consistent indentation in the FSH file. When processing multi-line strings, the following approach is followed:

* If the first line or last line contains only whitespace (including newline), discard it.
* If another line contains only whitespace, truncate it to zero characters.
* For all other non-whitespace lines, detect the smallest number of leading spaces and trim that from the beginning of every line.

For example, an author might use a multi-line string to write markdown so that the markdown can be indented inside the FSH:

```
* ^purpose = """
    * This profile is intended to support workflows where:
      * this happens; or
      * that happens
    * This profile is not intended to support workflows where:
      * nothing happens
  """
```

Using a normal string would require the following spacing to accomplish the same markdown formatting:

```
* ^purpose = "* This profile is intended to support workflows where:
  * this happens; or
  * that happens
* This profile is not intended to support workflows where:
  * nothing happens"
```

#### Coded Data Types

The four "coded" types in FHIR are code, Coding, CodeableConcept, and Quantity. FSH provides special grammar for expressing codes and assigning coded values for these data types.

##### code

Codes are denoted with `#` sign. The FSH is:

```
#{code}
```
or 
```
#"{code}"
```
In general, the first syntax is sufficient. Quotes are only required in the rare situation of a code containing white space.

**Examples:**

* The code `postal` used in Address.type:

  ```
  #postal
  ```

* The code `<=` from the [Quantity Comparator value set](http://hl7.org/fhir/R4/valueset-quantity-comparator.html):

  ```
  #<=
  ```

* Express a code with white space:

  ```
  #"VL 1-1, 18-65_1.2.2"
  ```

* Assign the code `female` to the gender of a Patient:

  ```
  * gender = #female
  ```

##### Coding

The FSH for a Coding value is:

```
{system}#{code} "{display text}"
```

For code systems that encode the version separately from the URL, the version can be specified as follows:

```
{system}|{version}#{code} "{display text}"
```

While `{system}` and `{code}` are required, `|{version}` and `"{display text}"` are optional. The `{system}` represents the controlled terminology that the code is taken from. It can be a URL, OID, or alias for a URL or OID (see [defining aliases](#defining-aliases)). The bar syntax for code system version is the same approach used in the `canonical` data type in FHIR. An alternative is to set the `version` element of Coding (see examples).

To set the less-common properties of a Coding, use an [assignment rule](#assignment-rules) on that element.

**Examples:**

* A Coding from SNOMED-CT:

  ```
  http://snomed.info/sct#363346000 "Malignant neoplastic disease (disorder)"
  ```
  
* The same Coding, assuming SCT has been defined as an alias for http://snomed.info/sct:

  ```
  SCT#363346000 "Malignant neoplastic disease (disorder)"
  ```
  
* A Coding from ICD10-CM, assuming the alias $ICD for that code system:

  ```
  $ICD#C004  "Malignant neoplasm of lower lip, inner aspect"
  ```
  
* A Coding with an explicit version specified with bar syntax:

  ```
  http://hl7.org/fhir/CodeSystem/example-supplement|201801103#chol-mmol
  ```
  
* As an alternative to the bar syntax for version, set the code system version of a Coding datatype (myCoding) directly:

  ```
  * myCoding.version = "201801103"
  ```

* Set the userSelected property of myCoding (one of the lesser-used attributes of Codings):

  ```
  * myCoding.userSelected = true
  ```
  
* In an instance of a Signature, set Signature.type:

  ```
  * type = urn:iso-astm:E1762-95:2013#1.2.840.10065.1.12.1.2 "Coauthor's Signature"
  ```
  
##### CodeableConcept

A CodeableConcept consists of an array of Codings, plus a text. Codings are expressed using the shorthand explained [directly above](#coding). The FSH for setting the first Coding in a CodeableConcept is:

```
* {CodeableConcept type} = {system}#{code} "{display text}"
```

To set additional values, array indices are used. Indices are denoted by bracketed integers. The shorthand is:

```
* {CodeableConcept type}.coding[{i}] = {system}#{code} "{display text}"
```

FSH arrays are zero-based. If no array index is given, the index [0] is assumed (see [Array Property Paths](#array-property-paths) for more information).

To set the top-level text of a CodeableConcept, the FSH expression is:

```
* {CodeableConcept type}.text = {string}
```

**Examples:**

* To set the first Coding in Condition.code (a CodeableConcept type):

  ```
  * code = SCT#363346000 "Malignant neoplastic disease (disorder)"
  ```
    
* An equivalent representation, using explicit array index on the coding array:

  ```
  * code.coding[0] = SCT#363346000 "Malignant neoplastic disease (disorder)"
  ```
    
* Another equivalent representation, using the shorthand that allows dropping the [0] index:

  ```
  * code.coding = SCT#363346000 "Malignant neoplastic disease (disorder)"
  ```
    
* Adding a second value to the array of Codings:

  ```
  * code.coding[1] = ICD10#C80.1 "Malignant (primary) neoplasm, unspecified"
  ```
    
* Set the top-level text of Condition.code:

  ```
  * code.text = "Diagnosis of malignant neoplasm left breast."
  ```
    
##### Quantity

FSH provides a shorthand that allows quantities with units of measure to be specified simultaneously, provided the units of measure are [Unified Code for Units of Measure](http://unitsofmeasure.org/) (UCUM) codes. The syntax is:

```
* {Quantity type} = {number} '{valid UCUM unit}'
```

This syntax is borrowed from the [Clinical Quality Language](https://cql.hl7.org) (CQL).

The value and units can also be set independently. To set the value of quantity value, the quantity `value` property can be set directly:

```
* {Quantity type}.value = {number}
```

To set the units of measure independently, a Quantity can be bound to a value set or assigned a coded value. The FSH is:

```
* {Quantity type} = {system}#{code} "{display text}"
```

Although it appears the quantity itself is being set to a coded value, this expression sets only the units of measure.

**Examples:**

* Set the valueQuantity of an Observation to 55 millimeters using UCUM units:

  ```
  * valueQuantity = 55.0 'mm'
  ```

* Set the numerical value of Observation.valueQuantity to 55.0 without setting the units:

  ```
  * valueQuantity.value = 55.0
  ```
  
* Set the units of the same valueQuantity to millimeters, without setting the value (assuming UCUM has been defined as an alias for http://unitsofmeasure.org):

  ```
  * valueQuantity = UCUM#mm "millimeters"
  ```

* Bind a value set to a Quantity, constraining the units of that Quantity:

  ```
  * valueQuantity from http://hl7.org/fhir/ValueSet/distance-units
  ```

### Paths

FSH path grammar allows you to refer to any element of a profile, extension, or instance, regardless of nesting. Paths also provide a grammar for addressing elements of a StructureDefinition (SD) directly. Here are a few examples of how paths are used in FSH:

* To refer to a top-level element such as the 'code' element in Observation
* To refer to a nested element, such as the 'method.text' element in Observation
* To address a particular item in a list or array
* To refer to individual elements inside choice elements (e.g., onsetAge in onset[x])
* To pick out an individual item within a multiple choice reference, such as Observation in Reference(Observation or Condition)
* To refer to an individual slice within a sliced array, such as the SystolicBP component within a blood pressure
* To set metadata elements in an SD, like 'active' and 'experimental'
* To address properties of ElementDefinitions nested within an SD, such as 'maxLength' property of string-type elements

In the following, the various types of path references are discussed.

#### Nested Element Paths

To refer to nested elements, the path lists the properties in order, separated by a dot (`.`).  Since the resource can be inferred from the definition, the resource name is not a formal part of the path (e.g., `subject` is a valid path within a Procedure definition, but `Procedure.subject` is not).

> **Note:** It is not permissible to cross reference boundaries in paths. This means that when a path gets to a Reference, that path cannot be extended further. For example, if Procedure has a subject element that is a Reference(Patient), and Patient has a gender, then `subject` is a valid path, but `subject.gender` is not, because it crosses into the Patient reference.

**Example:**

* Observation has an element named method, and method has a text property. Assign "Laparoscopy"to the text property:

  ```
  * method.text = "Laparoscopy"
  ```

#### Array Property Paths

If an element allows more than one value (e.g., `0..*`), then it must be possible to address each individual value. FSH denotes this with square brackets (`[` `]`) containing the 0-based index of the item (e.g., first item is `[0]`, second item is `[1]`, etc.).

If the index is omitted, the first element of the array (`[0]`) is assumed. 

**Examples:**

* Set a Patient's first name's second given name to "Marie":

  ```
  * name[0].given[1] = "Marie"
  ```

* Equivalent expression, since the zero index is assumed when omitted:

  ```
  * name.given[1] = "Marie"
  ```

#### Reference Paths

Elements can offer a choice of reference types. To address a specific resource or profile among the choices, follow the path with square brackets (`[` `]`) containing the target type (or the profile's `name`, `id`, or `url`).

**Example:**

* Given an element named `performer` with an inherited choice type of Reference(Organization or Practitioner), refer to the Practitioner:

  ```
  performer[Practitioner]
  ```

#### Data Type Choice [x] Paths

Addressing a type from a choice of types replaces the `[x]` in the property name with the type name (while also capitalizing the first letter). This follows the approach used in FHIR JSON and XML serialization.

**Example:**

* Assign value[x] string value to "Hello World":

  ```
  * valueString = "Hello World"
  ```

* Assign the value[x] Reference value to an instance of the Patient resource:

  ```
  * valueReference = Reference(EveAnyperson)
  ```

#### Profiled Type Choice Paths

In some cases, a type may be constrained to a set of possible profiles. To address a specific profile on that type, follow the path with square brackets (`[ ]`) containing the profile's `name`, `id`, or `url`.

**Example:**

* After constraining an address element to be either a USAddress or a CanadianAddress, bind the address.state properties to value sets of US states and Canadian provinces:

  ```
  * address only USAddress or CanadianAddress
  * address[USAddress].state from https://www.usps.com
  * address[CanadianAddress].state from http://ehealthontario.ca/fhir/CodeSystem/province-state-codes
  ```

#### Extension Paths

FHIR provides for user customization through extensions. Extensions are added to resources by populating pre-existing arrays designated for this purpose. Most resources have extension and a modifierExtension arrays at the top level, inherited from [DomainResource](http://hl7.org/fhir/R4/domainresource.html) (exceptions include Bundle, Parameters, and Binary). Every element of a resource also has an extension array, inherited from [Element](https://www.hl7.org/fhir/element.html). These arrays contain elements of [data type Extension](https://www.hl7.org/fhir/extensibility.html#extension). Particular types of extensions are created by profiling Extension.

In FSH, extensions are created using [extension rules](#extension-rules). These rules have the effect of adding the extension to the corresponding FHIR extension array (technically, by slicing that array). The extension is then referred to by its name or URL as a member of the extension array using square brackets, i.e., `extension[{name or URL}]`.

<!-- However, extensions being very common in FHIR, FSH supports a compact syntax for paths that involve extensions. The compact syntax drops `extension[ ]` or `modifierExtension[ ]` (similar to the way the `[0]` index can be dropped). The only time this is not allowed is when dropping these terms creates a naming conflict.-->

**Examples:**

* Set the value of the birthsex extension in US Core Patient (assume USCoreBirthsex has been defined as an alias for the birthsex extension):

  ```
  * extension[USCoreBirthsex].valueCode = #F
  ```

* Set the value of a nested extension in US Core Patient, indicating the given email address is a "direct" address:

  ```
  * telecom.extension[http://hl7.org/fhir/us/core/StructureDefinition/us-core-direct] = true
  ```

* Set the nested ombCategory extension, under the ethnicity extension in US Core:

  ```
  * extension[USCoreEthnicity].extension[ombCategory].valueCoding = RaceAndEthnicityCDC#2135-2 "Hispanic or Latino"
  ```

* Set two values in the multiple-valued nested extension, detailed, under USCoreEthnicity extension:

  ```
  * extension[USCoreEthnicity].extension[detailed][0].valueCoding = RaceAndEthnicityCDC#2184-0 "Dominican"
  * extension[USCoreEthnicity].extension[detailed][1].valueCoding = RaceAndEthnicityCDC#2148-5 "Mexican"
  ```

#### Sliced Array Paths

FHIR allows lists to be compartmentalized into sublists called "slices".  To address a specific slice, follow the path with square brackets (`[` `]`) containing the slice name. Since slices are most often unordered, slice names rather than array indices should be used. Note that slice names (like other [FSH names](#fsh-names)) cannot be purely numeric, so slice names cannot be confused with indices.

To access a slice of a slice (i.e., _reslicing_), follow the first pair of brackets with a second pair containing the resliced slice name.

**Examples:**

* In an Observation profile representing Apgar score, with slices for RespiratoryScore, AppearanceScore, and others, fix the RespirationScore:

  ```
  * component[RespiratoryScore].code = SCT#24388001 "Apgar score 5 (finding)"
  ```

* If the Apgar RespiratoryScore is resliced to represent the one and five minute Apgar scores, set the OneMinuteScore and FiveMinuteScore sub-slices:

  ```
  * component[RespiratoryScore][OneMinuteScore].code = SCT#24388001 "Apgar score 5 (finding)"
  ```

  ```
  * component[RespiratoryScore][FiveMinuteScore].code = SCT#13323003 "Apgar score 7 (finding)"
  ```

#### StructureDefinition Escape Paths

FSH uses the caret (`^`) syntax to provide direct access to elements of an SD. The caret syntax should be reserved for situations not addressed through [FSH Keywords](#defining-items) or IG configuration files (i.e., elements other than name, id, title, description, url, publisher, fhirVersion, etc.). Examples of metadata elements in SDs that require the caret syntax include experimental, useContext, and abstract. The caret syntax also provides a simple way to set metadata attributes in the ElementDefinitions that comprise the snapshot and differential tables (e.g., short, slicing discriminator and rules, meaningWhenMissing, etc.).

To set a value in the root-level attributes of an SD, use the following syntax:

```
* ^{StructureDefinition path} = {value}
```

To set values in ElementDefinitions, corresponding to the elements in the resource or slices of arrays, use this syntax:

```
* {Element path} ^{ElementDefinition path} = {value}
```

A special case of the Element path is setting properties of the first element of the differential (i.e., StructureDefinition.differential.element[0]). This element always refers to the profile or standalone extension itself. Since this element does not correspond to an named element appearing in an instance, we use the dot or full stop (`.`) to represent it. (The dot symbol is often used to represent "current context" in other languages.) It is important to note that the "self" elements are not the elements of an SD directly, but elements of the first ElementDefinition contained in the SD. The syntax is:

```
* . ^{ElementDefinition path} = {value}
```

**Examples:**

* In a profile definition, set the 'experimental' attribute in the SD for that profile:

  ```
  * ^experimental = false
  ```

* In a profile of Patient, set the description attribute on the binding of communication.language:

  ```
  * communication.language ^binding.description = "This binding is dictated by US FDA regulations."
  ```

* Provide a short description for an extension (defined in the "self" ElementDefinition):

  ```
  * . ^short = "US Core Race Extension"
  ```

***

### Rules

* For rules applicable to Value Sets, see [Defining Value Sets](#defining-value-sets).
* For rules applicable to Code Systems, see [Defining Code Systems](#defining-code-systems).

Rules are the mechanism for constraining a profile, defining an extension, creating slices, and more. All rules begin with an asterisk:

```
* {rule statement}
```

We have already introduced a few types of rules: the assignment rule (using `=`), the binding rule (using `from`), and the data type restriction rule (using `only`).

The following table is a summary of the rules applicable to profiles and standalone extensions. Only the Assignment rule is applicable to instances. 

| Rule Type | Syntax |
| --- | --- |
| Assignment |`* {path} = {value}` <br/> `* {path} = {value} (exactly)` |
| Binding |`* {path} from {valueSet} ({strength})`|
| Cardinality | `* {path} {min}..{max}` <br/>`* {path} {min}..` <br/>`* {path} ..{max}` |
| Extension, inline | `* {extension path} contains {extensionSliceName} {card} {flags}`  <br/> `* {extension path} contains {extensionSliceName1} {card1} {flags1} and {extensionSliceName2} {card2} {flags2} ...` |
| Extension, standalone | `* {extension path} contains {ExtensionNameIdOrURL} named {extensionSliceName} {card} {flags}` <br/>  `* {extension path} contains {ExtensionNameIdOrURL1} named {extensionSliceName1} {card1} {flags1} and {ExtensionNameIdOrURL2} named {extensionSliceName2} {card2} {flags2} ...`
| Flag | `* {path} {flag}` <br/> `* {path} {flag1} {flag2} ...` <br/> `* {path1} and {path2} and {path3} and ... {flag}` <br/> `* {path1} and {path2} and {path3} and ... {flag1} {flag2} ...` |
| Invariant | `* obeys {invariant}` <br/> `* {path} obeys {invariant}` <br/> `* obeys {invariant1} and {invariant2} ...` <br/> `* {path} obeys {invariant1} and {invariant2} ...` |
| Mapping | `* -> "{map}" "{comment}" {mime-type}` <br/> `* {path} -> "{map}" "{comment}" {mime-type}` |
| Rule set | `* insert {ruleSetName}` |
| Slicing | `* {array element path} contains {sliceName1} {card1} {flags1} and {sliceName2} {card2} {flags2}...` |
| Type | `* {path} only {type}` <br/> `* {path} only {type1} or {type2} or {type3} or ...` <br/> `* {path} only Reference({type})`  <br/> `* {path} only Reference({type1} or {type2} or {type3} or ...)`|
{: .grid }

#### Assignment Rules

Assignment rules follow this syntax:

```
* {path} = {value}
```

The left side of this expression follows the [FSH path grammar](#paths). The data type on the right side must align with the data type of the final element in the path.

Assignment rules have two different interpretations, depending on context:

* In an instance, an assignment rule fixes the value of the target element.
* In a profile or extension, an assignment rule establishes a pattern that must be satisfied by instances conforming to that profile or extension. The pattern is considered "open" in the sense that the element in question may have additional content in addition to the prescribed value, such as additional codes in a CodeableConcept or an extension.

If conformance to a profile requires a precise match to the specified value (which is rare), then the following syntax can be used:

```
* {path} = {value} (exactly)
```

Adding `exactly` indicates that conformance to the profile requires a precise match to the specified value, **no more and no less**. This syntax is valid only in the context of profiles and extensions.

**Example:**

* Consider the following assignment statements (assuming LNC is an alias for http://loinc.org):

  ```
  * code = LNC#69548-6
  ```

  ```
  * code = LNC#69548-6 "Genetic variant assessment"
  ```

  ```
  * code = LNC#69548-6 (exactly)
  ```

  In the context of a **profile**, the first statement signifies an instance must have the system http://loinc.org and the code 69548-6 to pass validation. The second statement says that an instance must have the system http://loinc.org, the code 69548-6, **and** the display text "Genetic variant assessment" to pass validation. The third statement says that an instance must have the system http://loinc.org and the code 69548-6, and **must not** have a display text, alternate codes, or extensions. Typically, only the system and code are important conformance criteria, so the first statement (without the display text) is preferred in a profiling context. In an **instance**, however, the display text conveys additional information useful to the information receiver, so the second statement would be preferred.

  In summary, the recommended style for assignment of a LOINC code in an Observation **instance** is:

  ```
  * code = LNC#69548-6 "Genetic variant assessment"
  ```

  The recommended style for assignment of a LOINC code in an Observation **profile** is:

  ```
  * code = LNC#69548-6  // Genetic variant assessment (display text in comment for convenience)
  ```

**Note:** The `(exactly)` modifier does not apply to instances.

**Additional Examples:**

* Assignment of a code data type:

  ```
  * status = #arrived
  ```

* Assignment of a boolean:

  ```
  * active = true
  ```

* Assignment of a date:

  ```
  * onsetDateTime = "2019-04-02"
  ```

* Assignment of a quantity with single quotes indicating UCUM units:

  ```
  * valueQuantity = 36.5 'C'
  ```

* Assignment of a reference to another resource:

  ```
  * subject = Reference(EveAnyperson)
  ```


#### Binding Rules

Binding is the process of associating a coded element with a set of possible values. The syntax to bind a value set, or alter an inherited binding, uses the reserved word `from`:

```
* {path} from {valueSet} ({strength})
```

The value set can be the name of a value set defined in the same [FSH tank](index.html#fsh-files-and-fsh-tanks) or the defining URL of an external value set in the core FHIR spec or in an IG that has been declared an external dependency.

The strengths are the same as the [binding strengths defined in FHIR](https://www.hl7.org/fhir/valueset-binding-strength.html), namely: example, preferred, extensible, and required.

The following rules apply to binding in FSH:

* If no binding strength is specified, the binding is assumed to be required.
* When further constraining an existing binding, the binding strength can stay the same or be made tighter (e.g., replacing a preferred binding with extensible or required), but never loosened.
* Constraining may leave the binding strength the same and change the value set instead. However, certain changes permitted in FSH may violate [FHIR profiling principles](http://hl7.org/fhir/R4/profiling.html#binding-strength). In particular, FHIR will permit a required value set to be replaced by another required value set only if the codes in the new value set are a subset of the codes in the original value set. For extensible bindings, the new value set can contain codes not in the existing value set, but additional codes **should not** have the same meaning as existing codes in the base value set.

**Examples:**

* Bind to an externally-defined value set using its canonical URL:

  ```
  * telecom.system from http://hl7.org/fhir/ValueSet/contact-point-system (required)
  ```

* Bind to an externally-defined value set with required binding by default:

  ```
  * gender from http://hl7.org/fhir/ValueSet/administrative-gender
  ```

* Bind to a value set using an alias name:

  ```
  * address.state from USPSTwoLetterAlphabeticCodes (extensible)
  ```

#### Cardinality Rules

Cardinality rules constrain (narrow) the number of repetitions of an element. Every element has a cardinality inherited from its parent resource or profile. If the inheriting profile does not alter the cardinality, no cardinality rule is required.

To change the cardinality, the grammar is:

```
* {path} {min}..{max}
```

As in FHIR, min and max are non-negative integers, and max can also be *, representing unbounded. It is valid (and even encouraged) to include both the min and max, even if one of them remains the same as in the original cardinality. In this case, FSH processors (e.g., SUSHI) should only generate constraints for the changed values. FSH also supports one-sided cardinalities if the author wishes to omit an unconstrained min or max in the expression.

Cardinalities must follow [rules of FHIR profiling](https://www.hl7.org/fhir/conformance-rules.html#cardinality), namely that the min and max cardinalities must stay within the constraints of the parent.

For convenience and compactness, cardinality rules can be combined with [flag rules](#flag-rules) via the following grammar:

```
* {path} {min}..{max} {flag1} {flag2} ...
```

**Examples:**

* Set the cardinality of the subject element to 1..1 (required, non-repeating):

  ```
  * subject 1..1
  ```

* Set the cardinality of the subject element to 1..1 and declare it Must Support:

  ```
  * subject 1..1 MS
  ```

* Set the cardinality of a sub-element to 0..0 (not permitted):

  ```
  * component.referenceRange 0..0
  ```

* Require at least one category without changing its upper bound:

  ```
  * category 1..
  ```

* Allow at most one category without changing its lower bound:

  ```
  * category ..1
  ```

#### Extension Rules

Extensions are created by adding elements to built-in 'extension' array elements. Extension arrays are found at the root level of every resource, nested inside every element, and recursively inside each extension. The structure of extensions is defined by FHIR (see [Extension element](https://www.hl7.org/fhir/extensibility.html#extension)). Constraining extensions is discussed in [Defining Extensions](#defining-extensions). The same instructions apply to 'modifierExtension' arrays.

Extensions are specified using the `contains` keyword. There are two types of extensions: **standalone** and **inline**:

* Standalone extensions have independent SDs, and can be reused. They can be externally-defined, and referred to by their canonical URLs, or defined in the same [FSH tank](index.html#fsh-files-and-fsh-tanks) using the `Extension` keyword, and referenced by their name or id.
* Inline extensions do not have separate SDs, and cannot be reused in other profiles. Inline extensions are typically used to specify sub-extensions in a complex (nested) extension. When defining an inline extension, it is typical to use additional rules (such as cardinality, data type and binding rules) to further define the extension.

The FSH syntax to specify a standalone extension is:

```
* {extension element path} contains {ExtensionNameIdOrURL1} named {extensionSliceName1} {card1} {flags1} and {ExtensionNameIdOrURL2} named {extensionSliceName2} {card2} {flags2}...
```

The FSH syntax to define an inline extension is:

```
* {extension element path} contains {extensionSliceName1} {card1} {flags1} and {extensionSliceName2} {card2} {flags2}...
```

In both styles, the cardinality is required, and flags are optional. Adding an extension below the root level is achieved by giving the full path to the extension array to be sliced.

**Examples:**

* Add standalone FHIR extensions [`patient-disability`](http://hl7.org/fhir/R4/extension-patient-disability.html) and [`patient-genderIdentity`](http://hl7.org/fhir/StructureDefinition/patient-genderIdentity) to a profile on the Patient resource, at the top level:

  ```
  * extension contains http://hl7.org/fhir/StructureDefinition/patient-disability named disability 0..1 MS and http://hl7.org/fhir/StructureDefinition/patient-genderIdentity named genderIdentity 0..1 MS
  ```

* The same statement, using aliases and whitespace flexibility for readability:

  ```
  * Alias: DisabilityExtension = http://hl7.org/fhir/StructureDefinition/patient-disability
  * Alias: GenderIdentityExtension = http://hl7.org/fhir/StructureDefinition/patient-genderIdentity
    ...

  * extension contains
        DisabilityExtension named disability 0..1 MS and
        GenderIdentityExtension named genderIdentity 0..1 MS
  ```

* Add a standalone extension, defined in the same [FSH tank](index.html#fsh-files-and-fsh-tanks), to a bodySite attribute (second level extension):

  ```
  * bodySite.extension contains Laterality 0..1
    ...

    // Definition of Laterality used as standalone extension
    Extension: Laterality
    Description: "Body side of a body location."
  * value[x] only CodeableConcept
  * valueCodeableConcept from LateralityVS (required)
  ```

* Add inline extensions to the US Core Race extension:

  ```
  * extension contains
        ombCategory 0..5 MS
        detailed 0..*
        text 1..1 MS

    // constraints to define the inline extensions would follow, e.g.:
  * extension[ombCategory].value[x] only Coding
  * extension[ombCategory].valueCoding from http://hl7.org/fhir/us/core/ValueSet/omb-race-category (required)
  * extension[text].value[x] only string
    // etc...
  ```

#### Flag Rules

Flags are a set of information about the element that impacts how implementers handle them. The [flags defined in FHIR](http://hl7.org/fhir/R4/formats.html#table), and the symbols used to describe them, are as follows:

| FHIR Flag | FSH Flag | Meaning |
|------|-----|----|
| S | MS  | Must Support |
| &#931;  | SU  | Include in summary |
| ?! | ?! | Modifier |
| N | N | Normative element |
| TU | TU | Trial use element |
| D | D | Draft element |
{: .grid }

FHIR also defines I and NE flags, representing elements affected by constraints, and elements that cannot have extensions, respectively. These flags are not directly supported in flag syntax, since the I flag is determined by the actual inclusion of [invariants](#invariant-rules), and NE flags apply only to infrastructural elements in base resources. If needed, these flags can be set using [caret syntax](#structuredefinition-escape-paths).

The following syntax can be used to assigning flags:

```
* {path} {flag1} {flag2} ...
```

```
* {path1} and {path2} and {path3}... {flag}
```

**Examples:**

* Declare communication to be MustSupport and Modifier:

  ```
  * communication MS ?!
  ```

* Declare a list of elements and nested elements to be MustSupport:

  ```
  * identifier and identifier.system and identifier.value and name and name.family MS
  ```

#### Invariant Rules

[Invariants](https://www.hl7.org/fhir/conformance-rules.html#constraints) are constraints that apply to one or more values in instances, expressed as [FHIRPath expressions](https://www.hl7.org/fhir/fhirpath.html). An invariant can apply to an instance as a whole or a single element. Multiple invariants can be applied to an instance as a whole or to a single element. The FSH grammars for applying invariants in profiles are as follows:

```
* obeys {invariant}
```

```
* {path} obeys {invariant}
```

```
* obeys {invariant1} and {invariant2} ...
```

```
* {path} obeys {invariant1} and {invariant2} ...
```

The first case applies the invariant to the profile as a whole. The second case applies the invariant to a single element. The third case applies multiple invariants to the profile as a whole, and the fourth case applies multiple invariants to a single element.

The referenced invariant and its properties must be declared somewhere within the same [FSH tank](index.html#fsh-files-and-fsh-tanks), using the `Invariant` keyword. See [Defining Invariants](#defining-invariants).

**Examples:**

* Assign invariant to US Core Implantable Device (invariant applies to profile as a whole):

  ```
  * obeys us-core-9
  ```

* Assign invariant to Patient.name in US Core Patient:

  ```
  * name obeys us-core-8
  ```

#### Mapping Rules

[Mappings](https://www.hl7.org/fhir/mappings.html) are an optional part of SDs that can be provided to help implementers understand the content and use resources correctly. These mappings are informative and are not to be confused with the computable mappings provided by [FHIR Mapping Language](https://www.hl7.org/fhir/mapping-language.html) and the [StructureMap resource](https://www.hl7.org/fhir/structuremap.html).

In FSH, mapping rules are not included in the profile definition. They are included in a separate [Mapping definition](#defining-mappings) that provides additional context such as the higher level source and target. Within that definition mapping rules use the symbol `->` with the following grammar:

```
* -> "{map}" "{comment}" {mime-type}
```

```
* {path} -> "{map}" "{comment}" {mime-type}
```

The first type of rule applies to mapping the profile as a whole to the target specification. The second type of rule maps a specific element to the target.

In these rules, the `"{comment}"` string and `{mime-type}` code are optional. The mime type code must conform to https://tools.ietf.org/html/bcp13 (FHIR value set https://www.hl7.org/fhir/valueset-mimetypes.html).

**Examples:**

* Map the entire profile to a Patient item in another specification:

  ```
  * -> "Patient" "This profile maps to Patient in Argonaut"
  ```

* Map the identifier.value element from one IG to another:

  ```
  * identifier.value -> "Patient.identifier.value"
  ```

>**Note:** Unlike setting the mapping directly in the SD, mapping rules within a Mapping item do not include the name of the resource in the path on the left hand side.

#### Rule Set Rules

[Rule sets](#defining-rule-sets) are reusable groups of rules that are defined independently of other items. To use a rule set, an `insert` rule is used:

```
* insert {rule set name}
```

The rules in the named rule set are evaluated as if they were copied and pasted in the designated location. Rule sets can contain other rule sets, but circular dependencies are not allowed.

Each rule in the rule set should be compatible with item where the rule set is inserted, in the sense that all the rules defined in the rule set apply to elements actually present in the target. Implementations should check the legality of a rule set at compile time. If a particular rule from a rule set does not match an element in the target, that rule will not be applied, and an error should be emitted. It is up to implementations if other valid rules from the rule set are applied.

**Example:**

* Insert the rule set `MyMetadata` [defined here](#defining-rule-sets) into a profile:

  ```
  Profile: MyPatientProfile
  Parent: Patient
  * insert MyMetadata
  * deceased[x] only deceasedBoolean
  // More profile rules
  ```

  This is equivalent to the following:

  ```
  Profile: MyPatientProfile
  Parent: Patient
  * ^status = #draft
  * ^experimental = true
  * ^publisher = "Elbonian Medical Society"
  * deceased[x] only deceasedBoolean
  // More profile rules
  ```

* Use rule sets to define two different national profiles, both using a common clinical profile:

  ```
  Profile: USCoreBreastRadiologyObservationProfile
  Parent: BreastRadiologyObservationProfile
  * insert USObservationRuleSet
  ```

  ```
  Profile: FranceBreastRadiologyObservationProfile
  Parent: BreastRadiologyObservationProfile
  * insert FranceObservationRuleSet
  ```


#### Slicing Rules

Slicing is an advanced, but necessary, feature of FHIR. While future versions of FSH will aim to lower the learning curve, FSH version 1.0 requires authors to have a basic understanding of [slicing](http://hl7.org/fhir/R4/profiling.html#slicing) and [discriminators](http://hl7.org/fhir/R4/profiling.html#discriminator). In FSH, slicing is addressed in three steps: (1) identifying the slices, (2) defining each slice's contents, and (3) specifying the slicing logic.

##### Step 1. Identifying the Slices

The first step in slicing is populating the array that is to be sliced, using the `contains` keyword. The following syntax is used:

```
* {array element path} contains
       {sliceName1} {card1} {flags1} and
       {sliceName2} {card2} {flags2} and
       {sliceName3} {card3} {flags3} ...
```

In this pattern, the `{array element path}` is a path to the element that is to be sliced (and to which the slicing rules will applied in step 3). The `{card}` declaration is required, and `{flags}` are optional.

Each slice will match or constrain the data type of the array it slices. In particular:

* If an array is a one of the FHIR data types, each slice will be the same data type or a profile of it. For example, if an array of 'identifier' is sliced, then each slice will also be type 'identifier' or a profile of 'identifier'.
* If the sliced array is a backbone element, each slice "inherits" the sub-elements of the backbone. For example, the slices of Observation.component possess all the elements of Observation.component (code, value[x], dataAbsentReason, etc.). Constraints may be applied to the slices.
* If the array to be sliced is a Reference, then each slice must be a reference to one or more of the allowed Reference types. For example, if the element to be sliced is Reference(Observation or Condition), then each slice must either be Reference(Observation or Condition), Reference(Observation), Reference(Condition), or a profiled version of those resources.

**Example:**

* Slice the Observation.component array for blood pressure:

  ```
  * component contains SystolicBP 1..1 MS and DiastolicBP 1..1 MS
  ```

* Because FSH is white-space invariant, the previous example can be rewritten so the slices appear one-per-line for readability:

  ```
  * component contains
        SystolicBP 1..1 and
        DiastolicBP 1..1
  ```

###### Reslicing

Reslicing (slicing an existing slice) uses a similar syntax, but the left-hand side uses [slice path syntax](#sliced-array-paths) to refer to the slice that is being resliced:

```
* {array element path}[{sliceName}] contains {resliceName1} {card1} and {resliceName2} {card2} and ...
```

**Example:**

* Reslice the Apgar Respiration score for one-, five-, and ten-minute scores:

  ```
  * component[RespiratoryScore] contains
      OneMinuteScore 0..1 and
      FiveMinuteScore 0..1 and
      TenMinuteScore 0..1
  ```

##### Step 2. Defining Slice Contents

At minimum, each slice must be constrained such that it can be uniquely identified via the discriminator. For example, if the discriminator points to a "code" path that is a CodeableConcept, and it discriminates by "pattern", then each slice must have a constraint on "code" that uniquely distinguishes it from the other slices' codes. In addition to this minimum requirement, authors often place additional constraints on other aspects of each slice.

FSH requires slice contents to be defined inline. The rule syntax for inline slices is the same as constraining any other path in a profile, but uses the [slice path syntax](#sliced-array-paths) in the path:

```
* {path to slice}.{subpath} {constraint}
```

**Examples:**

* Define SystolicBP and DiastolicBP slices inline:

  ```
  * component contains
      SystolicBP 1..1 and
      DiastolicBP 1..1
  * component[SystolicBP].code = LNC#8480-6 // Systolic blood pressure
  * component[SystolicBP].value[x] only Quantity
  * component[SystolicBP].valueQuantity = UCUM#mm[Hg] "mmHg"
  * component[DiastolicBP].code = LNC#8462-4 // Diastolic blood pressure
  * component[DiastolicBP].value[x] only Quantity
  * component[DiastolicBP].valueQuantity = UCUM#mm[Hg] "mmHg"
  ```

##### Step 3. Specifying the Slicing Logic

Slicing in FHIR requires authors to specify a [discriminator path, type, and rules]. In addition, authors can optionally declare the slice as ordered or unordered (default: unordered), and/or provide a description. The meaning and values are exactly [as defined in FHIR](http://www.hl7.org/fhir/R4/profiling.html#discriminator).

In FSH, authors must specify the slicing logic parameters using [StructureDefinition escape (caret) syntax](#structuredefinition-escape-paths). The discriminator path identifies the element to be sliced, which is typically a multi-cardinality (array) element. The discriminator type determines how the slices are differentiated, e.g., by value, pattern, existence of the sliced element, data type of sliced element, or profile conformance.

**Example:**

* Provide slicing logic for slices on Observation.component that should be distinguished by their code:

  ```
  * component ^slicing.discriminator.type = #pattern
  * component ^slicing.discriminator.path = "code"
  * component ^slicing.rules = #open
  * component ^slicing.ordered = false   // can be omitted, since false is the default
  * component ^slicing.description = "Slice based on the component.code pattern"
  ```

#### Type Rules

FSH rules can be used to restrict the data type of an element. The FSH syntax to restrict the type is:

```
* {path} only {type}
```

```
* {path} only {type1} or {type2} or {type3}...
```

```
* {path} only Reference({type})
```

```
* {path} only Reference({type1} or {type2} or {type3} ...)
```

Certain elements in FHIR offer a choice of data types using the [x] syntax. Choices also frequently appear in references. For example, Condition.recorder has the choice Reference(Practitioner or PractitionerRole or Patient or RelatedPerson). In both cases, choices can be restricted in two ways: reducing the number or choices, and/or substituting a more restrictive data type or profile for one of the choices appearing in the parent profile or resource.

Following [standard profiling rules established in FHIR](https://www.hl7.org/fhir/profiling.html), the data type(s) in a type rule must always be more restrictive than the original data type. For example, if the parent data type is Quantity, it can be replaced by SimpleQuantity, since SimpleQuantity is a profile on Quantity (hence more restrictive than Quantity itself), but cannot be replaced with Ratio, because Ratio is not a type of Quantity. Similarly, Condition.subject, defined as Reference(Patient or Group), can be constrained to Reference(Patient), Reference(Group), or Reference(us-core-patient), but cannot be restricted to Reference(RelatedPerson), since that is neither a Patient nor a Group.

**Examples:**

* Restrict a Quantity type to SimpleQuantity:

  ```
  * valueQuantity only SimpleQuantity
  ```

* Condition.onset[x] is a choice of dateTime, Age, Period, Range or string. To restrict onset[x] to dateTime:

  ```
  * onset[x] only dateTime
  ```

* Restrict onset[x] to either Period or Range:

  ```
  * onset[x] only Period or Range
  ```

* Restrict onset[x] to Age, AgeRange, or DateRange, assuming AgeRange and DateRange are profiles of FHIR's Range datatype (thus permissible restrictions on Range):

  ```
  * onset[x] only Age or AgeRange or DateRange
  ```

* Restrict Observation.performer to reference only a Practitioner:

  ```
  * performer only Reference(Practitioner)
  ```

* Restrict performer to either a Practitioner or a PractitionerRole:

  ```
  * performer only Reference(Practitioner or PractitionerRole)
  ```

* Restrict performer to PrimaryCarePhysician or EmergencyRoomPhysician (assuming these are profiles on Practitioner):

  ```
  * performer only Reference(PrimaryCarePhysician or EmergencyRoomPhysician)
  ```

* Restrict the Practitioner choice of performer to a PrimaryCarePhysician, without restricting other choices:

  ```
  * performer[Practitioner] only Reference(PrimaryCareProvider)
  ```


### Defining Items

This section explains how to define items in FSH. The general pattern used to define an item in FSH is:

* One declaration keyword statement
* A number of additional keyword statements
* A number of rules

Keyword statements follow the syntax:

```
{Keyword}: {value}
```

For example:

```
Extension: TreatmentIntent
Description: "The purpose of the treatment."
```

Declaration keywords, corresponding to the items defined by FSH, are as follows:

| Declaration Keyword | Purpose | Data Type |
|----------|---------|---------|
| `Alias`| Declares an alias for a URL or OID | name or $name |
| `CodeSystem` | Declares a new code system | name |
| `Extension` | Declares a new extension | name |
| `Instance` | Declares a new instance | id |
| `Invariant` | Declares a new invariant | id |
| `Mapping` | Declares a new mapping | id |
| `Profile` | Declares a new profile | name |
| `RuleSet` | Declares a set of rules that can be reused | id |
| `ValueSet` | Declares a new value set | name |
{: .grid }

Additional keywords are as follows:

| Additional Keyword | Purpose | Data Type |
|----------|---------|---------|
| `Description` | Provides a human-readable description | string, markdown |
| `Expression` | The FHIR path expression in an invariant | FHIRPath string |
| `Id` | An identifier for an item | id |
| `InstanceOf` | The profile or resource an instance instantiates | name |
| `Parent` | Specifies the base class for a profile or extension | name or url |
| `Severity` | error, warning, or guideline in invariant | code |
| `Source` | The profile the mapping applies to | name |
| `Target` | The standard being mapped to | uri |
| `Title` | Short human-readable name | string |
| `Usage` | Specifies how an instance is intended to be used in the IG | code (choice of `#example`, `#definition`, or `#inline`) |
| `XPath` | the xpath in an invariant | XPath string |
{: .grid }

The following table shows the relationship between declaration keywords and additional keywords, with R = required, O = optional, blank = not allowed:

| Declaration \ Keyword                      | Id  | Description | Title | Parent | InstanceOf | Usage | Source | Target | Severity | XPath | Expression |
|-------------------------------------|-----|-------------|-------|--------|------------|-------|--------|--------|----------|-------|------------|
[Alias](#defining-aliases)            |     |             |       |        |            |       |        |        |          |       |            |
[Code System](#defining-code-systems) |  O  |     O       |   O   |        |            |       |        |        |          |       |            |
[Extension](#defining-extensions)     |  O  |     O       |   O   |   O    |            |       |        |        |          |       |            |
[Instance](#defining-instances)       |     |     O       |   O   |        |     R      |   O   |        |        |          |       |            |
[Invariant](#defining-invariants)     |     |     R       |       |        |            |       |        |        |    R     |    O  |    O       |
[Mapping](#defining-mappings)         |  O  |     O       |   O   |        |            |       |   R    |   R    |          |       |            |
[Profile](#defining-profiles)         |  O  |     O       |   O   |   R    |            |       |        |        |          |       |            |
[Rule Set](#defining-rule-sets)       |     |             |       |        |            |       |        |        |          |       |            |
[Value Set](#defining-value-sets)     |  O  |     O       |   O   |        |            |       |        |        |          |       |            |
{: .grid }

#### Defining Aliases

Aliases allow the user to replace a lengthy url or oid with a short string. Aliases are for readability only, and do not change the meaning of rules. Typical uses of aliases are to represent code systems and canonical URLs.

Alias definitions follow this syntax:

```
Alias: {AliasName} = {url or oid}
```

Several things to note about aliases:

* Aliases do not have additional keywords or rules.
* Alias statements stand alone, and cannot be mixed into rule sets of other items.
* Aliases are global within a FSH Tank.

In contrast with other names in FSH (for profiles, extensions, etc.), alias names can optionally begin with a dollar sign ($). If you define an alias with a leading $, you are protected against misspellings. For example, if you choose the alias name `$RaceAndEthnicityCDC` and accidentally type `$RaceEthnicityCDC`, implementations can easily detect there is no alias by that name. However, if the alias is `RaceAndEthnicityCDC` and the misspelling is `RaceEthnicityCDC`, implementations do not know an alias is intended, and will look through FHIR Core and all dependent implementation guides for anything with that name or id, or in some contexts, assume it is a new item, with unpredictable results.

**Examples:**

  ```
  Alias: SCT = http://snomed.info/sct
  ```

  ```
  Alias: $RaceAndEthnicityCDC = urn:oid:2.16.840.1.113883.6.238
  ```

  ```
  Alias: $ObsCat = http://terminology.hl7.org/CodeSystem/observation-category
  ```

#### Defining Profiles

To define a profile, the keywords `Profile` and `Parent` are required, and `Id`, `Title`, and `Description` are optional.

**Example:**

* Define a profile for USCorePatient:

  ```
  Profile:        USCorePatient
  Parent:         Patient
  Id:             us-core-patient
  Title:          "US Core Patient Profile"
  Description:    "Defines constraints and extensions on the patient resource for the minimal set of data to query and retrieve patient demographic information."
  ```

Any rules defined for the profiles would follow immediately after the keyword section.

#### Defining Extensions

Defining extensions is similar to defining a profile, except that the parent of an extension is not required. Extensions can also inherit from other extensions, but if the `Parent` keyword is omitted, the parent is assumed to be FHIR's [Extension element](https://www.hl7.org/fhir/extensibility.html#extension).

> **Note:** All extensions have the same structure, but extensions can either have a value (i.e. a value[x] element) or sub-extensions, but not both. To create a complex extension, the extension array of the extension must be sliced (see example, below).

**Example:**

* Define a simple (non-nested) extension for BirthSex, whose data type is `code`:

  ```
  Extension: USCoreBirthSexExtension
  Id:   us-core-birthsex
  Title:  "US Core Birth Sex Extension"
  Description: "A code classifying the person's sex assigned at birth"
  // publisher, contact, and other metadata here using caret (^) syntax (omitted)
  * value[x] only code
  * valueCode from BirthSexValueSet (required)
  ```

* Define a complex extension (extension with nested extensions) for US Core Ethnicity:

  ```
  Extension:      USCoreEthnicityExtension
  Id:             us-core-ethnicity
  Title:          "US Core Ethnicity Extension"
  Description:    "Concepts classifying the person into a named category of humans sharing common history, traits, geographical origin or nationality. "
  * extension contains
      ombCategory 0..1 MS and
      detailed 0..* and
      text 1..1 MS
  // inline definition of sub-extensions
  * extension[ombCategory] ^short = "Hispanic or Latino|Not Hispanic or Latino"
  * extension[ombCategory].value[x] only Coding
  * extension[ombCategory].valueCoding from OmbEthnicityCategories (required)
  * extension[detailed] ^short = "Extended ethnicity codes"
  * extension[detailed].value[x] only Coding
  * extension[detailed].valueCoding from DetailedEthnicity (required)
  * extension[text] ^short = "Ethnicity text"
  * extension[text].value[x] only string
  ```

* Define an extension with an explicit parent, specializing the US Core Birth Sex extension:

  ```
  Extension:      BinaryBirthSexExtension
  Parent:         USCoreBirthSexExtension
  Id:             binary-birthsex
  Title:          "Binary Birth Sex Extension"
  Description:     "As of 2019, certain US states only allow M or F on birth certificates."
  * valueCode from BinaryBirthSex (required)
  ```

#### Defining Instances

Instances are defined using the keywords `Instance`, `InstanceOf`, `Title`, `Usage` and `Description`. The `InstanceOf` is required, and plays a role analogous to the `Parent` of a profile. The value of `InstanceOf` can be the name of a profile defined in FSH, or a canonical URL (or alias) if defined externally.

Instances inherit structures and values from their StructureDefinition (i.e. assigned codes, extensions). Assignment rules are used to set additional values.

The `Usage` keyword specifies how the instance should be presented in the IG:

* `Usage: #example` means the instance is intended as an illustration of a profile, and will be presented on the Examples tab for the corresponding profile.
* `Usage: #definition` means the instance is a conformance item that is an instance of a resource such as a search parameter, operation definition, or questionnaire. These items will be presented on their own IG page.
* `Usage: #inline` means the instance should not be instantiated as an independent resource, but appears as part of another instance (for example, in a composition or bundle).


**Examples:**

* Define an example instance of US Core Patient, with name, birthdate, race, and ethnicity:

  ```
  Instance:  EveAnyperson
  InstanceOf: http://hl7.org/fhir/us/core/StructureDefinition/us-core-patient
  Title:   "Eve Anyperson"
  Usage:  #example
  * name.given = "Eve"
  * name.given[1] = "Steve"
  * name.family = "Anyperson"
  * birthDate = 1960-04-25
  * extension[us-core-race].extension[ombCategory].valueCoding = RaceAndEthnicityCDC#2106-3 "White"
  * extension[us-core-ethnicity].extension[ombCategory].valueCoding = RaceAndEthnicityCDC#2186-5 "Non Hispanic or Latino"
  ```

* Define an instance of US Core Practitioner, with name and NPI, meant to be inlined in a composition:

  ```
  Instance:   DrDavidAnydoc
  InstanceOf: http://hl7.org/fhir/us/core/StructureDefinition/us-core-practitioner
  Title:  "Dr. David Anydoc"
  Usage:  #inline
  * name[0].family = Anydoc
  * name[0].given[0] = David
  * name[0].suffix[0] = MD
  * identifier[NPI].value = 8274017284
  ```

* Define an instance of PrimaryCancerCondition, using many available features:

  ```
  Instance: mCODEPrimaryCancerConditionExample01
  InstanceOf: PrimaryCancerCondition
  Description: "mCODE Example for Primary Cancer Condition"
  Usage: #example
  * id = "mCODEPrimaryCancerConditionExample01"
  * meta.profile = "http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-primary-cancer-condition"
  * clinicalStatus = $ClinStatus#active "Active"
  * verificationStatus = $VerStatus#confirmed "Confirmed"
  * code = SCT#254637007 "Non-small cell lung cancer (disorder)"
  * extension[HistologyMorphologyBehavior].valueCodeableConcept = SCT#35917007 "Adenocarcinoma"
  * bodySite = SCT#39607008 "Lung structure (body structure)"
  * bodySite.extension[Laterality].valueCodeableConcept = SCT#7771000 "Left (qualifier value)"
  * subject = Reference(mCODEPatientExample01)
  * onsetDateTime = "2019-04-01"
  * asserter = Reference(mCODEPractitionerExample01)
  * stage.summary = AJCC#3C "IIIC"
  * stage.assessment = Reference(mCODETNMClinicalStageGroupExample01)
  ```

#### Defining Value Sets

A value set is a group of coded values, usually representing the acceptable values in a FHIR element whose data type is code, Coding, or CodeableConcept.

Value sets are defined using the declarative keyword `ValueSet`, with optional keywords `Id`, `Title` and `Description`

Codes must be taken from one or more terminology systems (also called code systems or vocabularies). Codes cannot be defined inside a value set. If necessary, [you can define your own code system](#defining-code-systems).

The contents of a value set are defined by a set of rules. There are four types of rules to populate a value set:

> **Note:** In the syntax below, the word `include` is optional:


| To include... | Syntax | Example |
|-------|---------|----------|
| A single code | `* include {Coding}` | `* include SCT#961000205106 "Wearing street clothes, no shoes"` <br/> or equivalently, <br/> `* SCT#961000205106 "Wearing street clothes, no shoes"`|
| All codes from a value set | `* include codes from valueset {Id}` | `* include codes from valueset http://hl7.org/fhir/ValueSet/data-absent-reason`  <br/> or equivalently, <br/> `* codes from valueset http://hl7.org/fhir/ValueSet/data-absent-reason`|
| All codes from a code system | `* include codes from system {Id}` | `* include codes from system http://snomed.info/sct` <br/> or equivalently, <br/> `* codes from system http://snomed.info/sct`|
| Selected codes from a code system (filters are code system dependent) | `* include codes from system {system} where {filter} and {filter} and ...` | `* include codes from system SCT where concept is-a #254837009` <br/> or equivalently, <br/> `* codes from system SCT where concept is-a #254837009`|
{: .grid }

See [below](#filters) for discussion of filters.

> **Note:** `{system}` can be a FSH name, alias or URL.

Analogous rules can be used to leave out certain codes, with the word `exclude` replacing the word `include`:

| To exclude... | Syntax | Example |
|-------|---------|----------|
| A single code | `* exclude {Coding}` | `* exclude SCT#961000205106 "Wearing street clothes, no shoes"` |
| All codes from a value set | `* exclude codes from valueset {Id}` | `* exclude codes from valueset http://hl7.org/fhir/ValueSet/data-absent-reason` |
| All codes from a code system | `* exclude codes from system {Id}` | `* exclude codes from system http://snomed.info/sct` |
| Selected codes from a code system (filters are code system dependent) | `* exclude codes from system {Id} where {filter}` | `* exclude codes from system SCT where concept is-a #254837009` |
{: .grid }

##### Filters

A filter is a logical statement in the form {property} {operator} {value}, where operator is chosen from [a value set](http://hl7.org/fhir/ValueSet/filter-operator) containing the values:

`is-a | descendent-of | is-not-a | regex | in | not-in | generalizes | exists`

Not all operators are valid for any code system. The `property` and `value` are dependent on the code system. For choices for the most common code systems, see the [FHIR documentation on filters]( http://hl7.org/fhir/valueset.html#csnote).

**Examples** 

* Define a value set using [extensional](https://www.hl7.org/fhir/valueset.html#int-ext) rules. This example demonstrates the optionality of the word `include`:

  ```
  ValueSet: BodyWeightPreconditionVS
  Title: "Body weight preconditions."
  Description:  "Circumstances for body weight measurement."
  * SCT#971000205103 "Wearing street clothes with shoes"
  * SCT#961000205106 "Wearing street clothes, no shoes"
  * SCT#951000205108 "Wearing underwear or less"
  ```

* Define a value set using [intensional](https://blog.healthlanguage.com/the-difference-between-intensional-and-extensional-value-sets) rules:

  ```
  * include codes from system SCT where concept is-a #367651003 "Malignant neoplasm of primary, secondary, or uncertain origin (morphologic abnormality)"
  * include codes from system SCT where concept is-a #399919001 "Carcinoma in situ - category (morphologic abnormality)"
  * include codes from system SCT where concept is-a #399983006 "In situ adenomatous neoplasm - category (morphologic abnormality)"
  * exclude codes from system SCT where concept is-a #450893003 "Papillary neoplasm, pancreatobiliary-type, with high grade intraepithelial neoplasia (morphologic abnormality)"
  * exclude codes from system SCT where concept is-a #128640002 "Glandular intraepithelial neoplasia, grade III (morphologic abnormality)"
  * exclude codes from system SCT where concept is-a #450890000 "Glandular intraepithelial neoplasia, low grade (morphologic abnormality)"
  * exclude codes from system SCT where concept is-a #703548001 "Endometrioid intraepithelial neoplasia (morphologic abnormality)"
  ```

> **Note:** Intensional and extensional forms can be used together in a single value set definition.

#### Defining Code Systems
It is sometimes necessary to define new codes inside an IG that are not drawn from an external code system (aka _local codes_). When defining local codes, you must define them in the context of a code system.

> **Note:** Defining local codes is not generally recommended, since those codes will not be part of recognized terminology systems. However, when existing vocabularies do not contain necessary codes, it may be necessary to define them -- at least temporarily -- as local codes.

Creating a code system uses the keywords `CodeSystem`, `Id`, `Title` and `Description`. Codes are then added, one per rule, using the following syntax:

```
* #{code} {display text string} {definition text string}
```

**Note:**
* Do not put a code system before the hash sign `#`. The code system name is given by the `CodeSystem` keyword.
* The definition of the term can be optionally provided as the second string following the code.

**Example:** Define a code system for yoga poses.

  ```
  CodeSystem:  YogaCS
  Title: "Yoga Code System."
  Description:  "A brief vocabulary of yoga-related terms."
  * #Sirsasana "Headstand" "An inverted asana, also called mudra in classical hatha yoga, involves standing on one's head."
  * #Halasana "Plough Pose" "Halasana or Plough pose is an inverted asana in hatha yoga and modern yoga as exercise. Its variations include Karnapidasana with the knees by the ears, and Supta Konasana with the feet wide apart."
  * #Matsyasana "Fish Pose"  "Matsyasana is a reclining back-bending asana in hatha yoga and modern yoga as exercise. It is commonly considered a counterasana to Sarvangasana, or shoulder stand, specifically within the context of the Ashtanga Vinyasa Yoga Primary Series."
  * #Bhujangasana "Cobra Pose" "Bhujangasana, or Cobra Pose is a reclining back-bending asana in hatha yoga and modern yoga as exercise. It is commonly performed in a cycle of asanas in Surya Namaskar (Salute to the Sun) as an alternative to Urdhva Mukha Svanasana (Upwards Dog Pose)."
  ```

> **Note:** FSH does not currently support definition of relationships between local codes, such as parent-child (is-a) relationships.

#### Defining Mappings

[Mapping to other standards](https://www.hl7.org/fhir/mappings.html) is an optional part of an SD. These mappings are intended to help implementers understand the SD in relation to other standards. While it is possible to define mappings using escape (caret) syntax, FSH provides a more concise approach.

> **Note:** The informational mappings in SDs should not be confused with functional mappings provided by [FHIR Mapping Language](https://www.hl7.org/fhir/mapping-language.html) and the [StructureMap resource](https://www.hl7.org/fhir/structuremap.html).

To create a mapping, the keywords `Mapping`, `Source`, `Target` and `Id` are required and `Title` and `Description` are optional. Any number of [mapping rules](#mapping-rules) follow. The keywords are defined as follows:

| Keyword | Usage | SD element |
|-------|------------|--------------|
| Mapping | Appears first and provides a unique name for the mapping | n/a |
| Source | The name of the profile the mapping applies to | n/a |
| Target | The URL, URI, or OID for the specification being mapped to | mapping.uri |
| Id | An internal identifier for the target specification | mapping.identity |
| Title | A human-readable name for the target specification | mapping.name  |
| Description | Additional information such as version notes, issues, or scope limitations. | mapping.comment |

**Example:**

* Define a map between USCorePatient and Argonaut
  ```

  Mapping:  USCorePatientToArgonaut
  Source:   USCorePatient
  Target:   "http://unknown.org/Argonaut-DQ-DSTU2"
  Title:    "Argonaut DSTU2"
  Id:       argonaut-dq-dstu2
  * -> "Patient"
  * extension[USCoreRaceExtension] -> "Patient.extension[http://fhir.org/guides/argonaut/StructureDefinition/argo-race]" 
  * extension[USCoreEthnicityExtension] -> "Patient.extension[http://fhir.org/guides/argonaut/StructureDefinition/argo-ethnicity]"
  * extension[USCoreBirthSexExtension] -> "Patient.extension[http://fhir.org/guides/argonaut/StructureDefinition/argo-birthsex]"
  * identifier -> "Patient.identifier"
  * identifier.system -> "Patient.identifier.system"
  * identifier.value -> "Patient.identifier.value"
  ```

In the example above, the target is another FHIR IG, but in many cases, the target will not use FHIR. For this reason, the right-hand side of mapping statements is always a string, to allow the greatest flexibility. For the same reason, even though the target is FHIR in the example above, FSH cannot make any assumptions about how the individual target values work; thus the resource name "Patient" is included in the right-hand side values since this is how the mapping targets should be expressed in the SD.

#### Defining Rule Sets

Rule sets provide the ability to define rules and apply them ("mix in") to a compatible target. The rules are copied from the rule set at compile time. Profiles, extensions, and instances can have one or more rule sets applied to them. The same rule set can be used in multiple places. Rule sets can only be mixed into profiles and extensions.

Rule sets are defined by using the keyword `RuleSet`:

```
RuleSet: {RuleSetName}
* {rule1}
* {rule2}
// More rules
```

A defined rule set can be applied to an item by using an [`insert` rule](#rule-set-rules).

**Example:**

* Define a rule set for metadata to be used in multiple profiles:

  ```
  RuleSet: MyMetadata
  * ^status = #draft
  * ^experimental = true
  * ^publisher = "Elbonian Medical Society"
  ```

#### Defining Invariants

Invariants are defined using the keywords `Invariant`, `Description`, `Expression`, `Severity`, and `XPath`. An invariant definition does not have any rules.

Invariants are incorporated into a profile via `obeys` rules explained [above](#invariant-rules).

**Example:**

* Define an invariant found in US Core using FSH:

  ```
  Invariant:  us-core-8
  Description: "Patient.name.given or Patient.name.family or both SHALL be present"
  Expression: "family.exists() or given.exists()"
  Severity:   #error
  XPath:      "f:given or f:family"
  ```

### Formal Grammar

The grammar of FSH described in [ANTLR4](https://www.antlr.org/):

```
grammar FSH;

doc:                entity* EOF;
entity:             alias | profile | extension | invariant | instance | valueSet | codeSystem | ruleSet | mapping;

alias:              KW_ALIAS SEQUENCE EQUAL SEQUENCE;

profile:            KW_PROFILE SEQUENCE sdMetadata+ sdRule*;
extension:          KW_EXTENSION SEQUENCE sdMetadata* sdRule*;
sdMetadata:         parent | id | title | description | mixins;
sdRule:             cardRule | flagRule | valueSetRule | fixedValueRule | containsRule | onlyRule | obeysRule | caretValueRule;

instance:           KW_INSTANCE SEQUENCE instanceMetadata* fixedValueRule*;
instanceMetadata:   instanceOf | title | description | usage | mixins;

invariant:          KW_INVARIANT SEQUENCE invariantMetadata+;
invariantMetadata:  description | expression | xpath | severity;

valueSet:           KW_VALUESET SEQUENCE vsMetadata* (caretValueRule | vsComponent)*;
vsMetadata:         id | title | description;
codeSystem:         KW_CODESYSTEM SEQUENCE csMetadata* (caretValueRule | concept)*;
csMetadata:         id | title | description;

ruleSet:            KW_RULESET SEQUENCE sdRule+;

mapping:            KW_MAPPING SEQUENCE mappingMetadata* mappingRule*;
mappingMetadata:    id | source | target | description | title;

// METADATA FIELDS
parent:             KW_PARENT SEQUENCE;
id:                 KW_ID SEQUENCE;
title:              KW_TITLE STRING;
description:        KW_DESCRIPTION (STRING | MULTILINE_STRING);
expression:         KW_EXPRESSION STRING;
xpath:              KW_XPATH STRING;
severity:           KW_SEVERITY CODE;
instanceOf:         KW_INSTANCEOF SEQUENCE;
usage:              KW_USAGE CODE;
mixins:             KW_MIXINS (SEQUENCE | COMMA_DELIMITED_SEQUENCES);
source:             KW_SOURCE SEQUENCE;
target:             KW_TARGET STRING;


// RULES
cardRule:           STAR path CARD flag*;
flagRule:           STAR (path | paths) flag+;
valueSetRule:       STAR path KW_UNITS? KW_FROM SEQUENCE strength?;
fixedValueRule:     STAR path KW_UNITS? EQUAL value KW_EXACTLY?;
containsRule:       STAR path KW_CONTAINS item (KW_AND item)*;
onlyRule:           STAR path KW_ONLY targetType (KW_OR targetType)*;
obeysRule:          STAR path? KW_OBEYS SEQUENCE (KW_AND SEQUENCE)*;
caretValueRule:     STAR path? caretPath EQUAL value;
mappingRule:        STAR path? ARROW STRING STRING? CODE?;

// VALUESET COMPONENTS
vsComponent:        STAR KW_EXCLUDE? ( vsConceptComponent | vsFilterComponent );
vsConceptComponent: code vsComponentFrom?
                    | COMMA_DELIMITED_CODES vsComponentFrom;
vsFilterComponent:  KW_CODES vsComponentFrom (KW_WHERE vsFilterList)?;
vsComponentFrom:    KW_FROM (vsFromSystem (KW_AND vsFromValueset)? | vsFromValueset (KW_AND vsFromSystem)?);
vsFromSystem:       KW_SYSTEM SEQUENCE;
vsFromValueset:     KW_VSREFERENCE (SEQUENCE | COMMA_DELIMITED_SEQUENCES);
vsFilterList:       (vsFilterDefinition KW_AND)* vsFilterDefinition;
vsFilterDefinition: SEQUENCE vsFilterOperator vsFilterValue?;
vsFilterOperator:   EQUAL | SEQUENCE;
vsFilterValue:      code | KW_TRUE | KW_FALSE | REGEX | STRING;

// MISC
path:               SEQUENCE | KW_SYSTEM;
paths:              COMMA_DELIMITED_SEQUENCES;
caretPath:          CARET_SEQUENCE;
flag:               KW_MOD | KW_MS | KW_SU | KW_TU | KW_NORMATIVE | KW_DRAFT;
strength:           KW_EXAMPLE | KW_PREFERRED | KW_EXTENSIBLE | KW_REQUIRED;
value:              SEQUENCE | STRING | MULTILINE_STRING | NUMBER | DATETIME | TIME | reference | code | quantity | ratio | bool ;
item:               SEQUENCE (KW_NAMED SEQUENCE)? CARD flag*;
code:               CODE STRING?;
concept:            STAR code (STRING | MULTILINE_STRING)?;
quantity:           NUMBER UNIT;
ratio:              ratioPart COLON ratioPart;
reference:          REFERENCE STRING?;
ratioPart:          NUMBER | quantity;
bool:               KW_TRUE | KW_FALSE;
targetType:         SEQUENCE | reference;

// KEYWORDS
KW_ALIAS:           'Alias' WS* ':';
KW_PROFILE:         'Profile' WS* ':';
KW_EXTENSION:       'Extension' WS* ':';
KW_INSTANCE:        'Instance' WS* ':';
KW_INSTANCEOF:      'InstanceOf' WS* ':';
KW_INVARIANT:       'Invariant' WS* ':';
KW_VALUESET:        'ValueSet' WS* ':';
KW_CODESYSTEM:      'CodeSystem' WS* ':';
KW_RULESET:         'RuleSet' WS* ':';
KW_MAPPING:         'Mapping' WS* ':';
KW_MIXINS:          'Mixins' WS* ':';
KW_PARENT:          'Parent' WS* ':';
KW_ID:              'Id' WS* ':';
KW_TITLE:           'Title' WS* ':';
KW_DESCRIPTION:     'Description' WS* ':';
KW_EXPRESSION:      'Expression' WS* ':';
KW_XPATH:           'XPath' WS* ':';
KW_SEVERITY:        'Severity' WS* ':';
KW_USAGE:           'Usage' WS* ':';
KW_SOURCE:          'Source' WS* ':';
KW_TARGET:          'Target' WS* ':';
KW_MOD:             '?!';
KW_MS:              'MS';
KW_SU:              'SU';
KW_TU:              'TU';
KW_NORMATIVE:       'N';
KW_DRAFT:           'D';
KW_FROM:            'from';
KW_EXAMPLE:         '(' WS* 'example' WS* ')';
KW_PREFERRED:       '(' WS* 'preferred' WS* ')';
KW_EXTENSIBLE:      '(' WS* 'extensible' WS* ')';
KW_REQUIRED:        '(' WS* 'required' WS* ')';
KW_CONTAINS:        'contains';
KW_NAMED:           'named';
KW_AND:             'and';
KW_ONLY:            'only';
KW_OR:              'or';
KW_OBEYS:           'obeys';
KW_TRUE:            'true';
KW_FALSE:           'false';
KW_EXCLUDE:         'exclude';
KW_CODES:           'codes';
KW_WHERE:           'where';
KW_VSREFERENCE:     'valueset';
KW_SYSTEM:          'system';
KW_UNITS:           'units';
KW_EXACTLY:         '(' WS* 'exactly' WS* ')';

// SYMBOLS
EQUAL:              '=';
STAR:               '*'  [0-9]*;
COLON:              ':';
COMMA:              ',';
ARROW:              '->';

// PATTERNS

                 //  "    CHARS    "
STRING:             '"' (~[\\"] | '\\"' | '\\\\')* '"';
                 //  """ CHARS """
MULTILINE_STRING:   '"""' .*? '"""';
                 //  +/- ? DIGITS( .  DIGITS)?
NUMBER:             [+\-]? [0-9]+('.' [0-9]+)?;
                 //   '  UCUM UNIT   '
UNIT:               '\'' (~[\\'])* '\'';
                 // SYSTEM     #  SYSTEM
CODE:               SEQUENCE? '#' (SEQUENCE | CONCEPT_STRING);
CONCEPT_STRING:      '"' (NONWS_STR | '\\"' | '\\\\')+ (WS (NONWS_STR | '\\"' | '\\\\')+)* '"';
                 //        YEAR         ( -   MONTH   ( -    DAY    ( T TIME )?)?)?
DATETIME:           [0-9][0-9][0-9][0-9]('-'[0-9][0-9]('-'[0-9][0-9]('T' TIME)?)?)?;
                 //    HOUR   ( :   MINUTE  ( :   SECOND  ( . MILLI )?)?)?( Z  |     +/-        HOUR   :  MINUTE   )?
TIME:               [0-9][0-9](':'[0-9][0-9](':'[0-9][0-9]('.'[0-9]+)?)?)?('Z' | ('+' | '-')[0-9][0-9]':'[0-9][0-9])?;
                 // DIGITS  ..  (DIGITS |  * )
CARD:               ([0-9]+)? '..' ([0-9]+ | '*')?;
                 //  Reference       (        ITEM         |         ITEM         )
REFERENCE:          'Reference' WS* '(' WS* SEQUENCE WS* ('|' WS* SEQUENCE WS*)* ')';
                 //  ^  NON-WHITESPACE
CARET_SEQUENCE:     '^' NONWS+;
                 // '/' EXPRESSION '/'
REGEX:              '/' ('\\/' | ~[*/\r\n])('\\/' | ~[/\r\n])* '/';
COMMA_DELIMITED_CODES: (CODE (WS+ STRING)? WS* COMMA WS+)+ CODE (WS+ STRING)?;
                        // (NON-WS  WS  ,   WS )+ NON-WS
COMMA_DELIMITED_SEQUENCES: (SEQUENCE WS* COMMA WS*)+ SEQUENCE;
                 // NON-WHITESPACE
SEQUENCE:           NONWS+;
// FRAGMENTS
fragment WS: [ \t\r\n\f\u00A0];
fragment NONWS: ~[ \t\r\n\f\u00A0];
fragment NONWS_STR: ~[ \t\r\n\f\u00A0\\"];

// IGNORED TOKENS
WHITESPACE:         WS -> channel(HIDDEN);
BLOCK_COMMENT:      '/*' .*? '*/' -> skip;
LINE_COMMENT:       '//' .*? [\r\n] -> skip;
```