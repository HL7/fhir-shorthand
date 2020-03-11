This chapter describes the FHIR Shorthand (FSH) language in detail. It is intended as a reference manual, not a pedagogical document. 

This chapter uses the following conventions:

| Style | Explanation | Example |
|:----------|:------|:---------|
| `Code` | Code fragments, such as commands and FSH statements  | `* status = #open` |
| _italics_ | Used to introduce named items, such as data types, resource names, file names, etc. | _example-1.fsh_ |
| ' ' (single quotes) | Used to highlight a literal value | the code 'confirmed'|
| {curly braces} | An item to be substituted | `{codesystem}#{code}` |
| **bold** | Emphasis |  Do **not** ignore this. |
| 💪 | Power User Feature | 💪 Don't try this at home |
{: .grid }

### FSH Foundations

#### Versioning

The FSH specification, like other IGs, follows the [semantic versioning](https://semver.org) convention (MAJOR.MINOR.PATCH):

* MAJOR: A major release has significant new functionality and, potentially, grammar changes or other non-backward-compatible changes.
* MINOR: Contains new or modified features, while maintaining backwards compatibility within the major version.
* PATCH: Contains minor updates and bug fixes, while maintaining backwards compatibility within the major version.

There are some language elements documented here that are not yet implemented in SUSHI. See the [SUSHI Release Notes](https://github.com/FHIR/sushi/releases) for further details.

#### Formal Grammar

[FSH has a formal grammar](https://github.com/FHIR/sushi/tree/master/antlr/src/main/antlr) defined in [ANTLR4](https://www.antlr.org/).

#### Keywords

FSH has a number of reserved words, symbols, and patterns. Reserved words and symbols are `contains`, `named`, `and`, `only`, `or`, `obeys`, `true`, `false`, `exclude`, `codes`, `where`, `valueset`, `system`, `from`, `!?`, `MS`, `SU`, `N`, `TU`, `D`, `=`, `*`, `:`, and `,`. The following words are reserved only if followed by a colon (intervening white spaces allowed): `Alias`, `Profile`, `Extension`, `Instance`, `InstanceOf`, `Invariant`, `ValueSet`, `CodeSystem`, `RuleSet`, `Mixins`, `Parent`, `Id`, `Title`, `Description`, `Expression`, `XPath`, `Severity`, `Usage`. The following words are reserved when enclosed in parentheses (intervening white spaces allowed): `example`, `preferred`, `extensible`, `required`.

#### Primitives

The primitive data types and value formats in FSH are identical to the [primitive types and value formats in FHIR](https://www.hl7.org/fhir/datatypes.html#primitive).

##### Multi-line Strings

For convenience, FSH also supports multi-line strings, demarcated with three double quotation marks `"""`. This feature allows for authors to split text over multiple lines and retain consistent indentation in the FSH file. When processing multi-line strings, the following approach is followed:
* If the first line or last line contains only whitespace (including newline), discard it.
* If another line contains only whitespace, truncate it to zero characters.
* For all other non-whitespace lines, detect the shortest number of leading spaces and trim that from the beginning of every line.

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
SecondaryCancerCondition            Parent: CancerCondition

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

#### Coded Data Types

The four "coded" types in FHIR are _code_, _Coding_, _CodeableConcept_, and _Quantity_. These data types can be bound to a value set or assigned a fixed code.  FSH provides special grammar for expressing codes and setting fixed coded values.

##### code

Codes are denoted with `#` sign. The shorthand is:

`#{code}`

>**Note:** In this document, curly braces are used to indicate a term that should be substituted.

**Examples:**

* The code `postal` used in Address.type:

  `#postal`

* The code '<=' from the [Quantity Comparator value set](http://hl7.org/fhir/R4/valueset-quantity-comparator.html):

  `#<=`

* Assign the code `female` to the gender of a Patient:

  `* gender = #female`

##### Coding

The shorthand for a Coding value is:

`{system}#{code} "{display text}"`

For code systems that encode the version separately from the URL, the version can be specified as follows:

`{system}|{version}#{code} "{display text}"`

While `{system}` and `{code}` are required, `|{version}` and `"{display text}"` are optional. The `{system}` represents the controlled terminology that the code is taken from. It can be a URL, OID, or alias for a URL or OID (see [defining aliases](#defining-aliases)). The bar syntax for code system version is the same approach used in the `canonical` data type in FHIR. An alternative is to set the `version` element of Coding (see examples).

To set the less-common properties of a Coding, use a [fixed value rule](#fixed-value-rules) on that element.

**Examples:**

* The code for malignant neoplastic disease from SNOMED-CT:

  `http://snomed.info/sct#363346000 "Malignant neoplastic disease (disorder)"`

* The same code, assuming SCT has been defined as an alias for http://snomed.info/sct:

  `SCT#363346000 "Malignant neoplastic disease (disorder)"`

* A code from ICD10-CM (assuming a code system alias has been defined):

  `ICD10CM#C004  "Malignant neoplasm of lower lip, inner aspect"`

* A code with an explicit version set specified with bar syntax:

  `http://hl7.org/fhir/CodeSystem/example-supplement|201801103#chol-mmol`

* As an alternative to the bar syntax, set the version of a Coding directly:

  `* myCoding.version = "201801103"`

* Set the 'type' element of a Signature:

  `* type = urn:iso-astm:E1762-95:2013#1.2.840.10065.1.12.1.2 "Coauthor's Signature"`

* Set `userSelected`, one of the lesser-used attributes of a Coding:

  `* myCoding.userSelected = true`

##### CodeableConcept

A CodeableConcept consists of an array of Codings, plus a text. Codings are expressed using the shorthand explained [directly above](#coding). The shorthand for setting the first Coding in a CodeableConcept is:

`* {CodeableConcept type} = {system}#{code} "{display text}"`

To set additional values, array indices are used. Indices are denoted by bracketed integers. The shorthand is:

`* {CodeableConcept type}.coding[{i}] = {system}#{code} "{display text}"`

FSH arrays are zero-based. If no array index is given, the index [0] is assumed (see [Array Property Paths](#array-property-paths) for more information).

To set the top-level text of a CodeableConcept, the shorthand expression is:

`* {CodeableConcept type}.text = {string}`

**Examples:**

* To set the first Coding in Condition.code (a CodeableConcept type):

  `* code = SCT#363346000 "Malignant neoplastic disease (disorder)"`

* An equivalent representation, using explicit array index on the coding array:

  `* code.coding[0] = SCT#363346000 "Malignant neoplastic disease (disorder)"`

* Another equivalent representation, using the shorthand that allows dropping the [0] index:

  `* code.coding = SCT#363346000 "Malignant neoplastic disease (disorder)"`

* Adding a second value to the array of Codings:

  `* code.coding[1] = ICD10#C80.1 "Malignant (primary) neoplasm, unspecified"`

* Set the top-level text of Condition.code:

  `* code.text = "Diagnosis of malignant neoplasm left breast."`

##### Quantity

FSH provides a shorthand that allows quantities with units of measure to be specified simultaneously, provided the units of measure are [Unified Code for Units of Measure](http://unitsofmeasure.org/) (UCUM) codes. The syntax is:

`* {Quantity type} = {number} '{valid UCUM unit}'`

This syntax is borrowed from the [Clinical Quality Language](https://cql.hl7.org) (CQL).

The value and units can also be set independently. To set the value of quantity value, the quantity `value` property can be set directly:

`* {Quantity type}.value = {number}`

To set the units of measure independently, a Quantity can be bound to a value set or assigned a coded value. The shorthand is:

`* {Quantity type} = {system}#{code} "{display text}"`

Although it appears the quantity itself is being set to a coded value, this expression sets only the units of measure. To make this more intuitive, FSH allows you to use the word `units`, as follows:

🚧 `* {Quantity type} units = {system}#{code} "{display text}"`

and for [binding](#value-set-binding-rules):

🚧 `* {Quantity type} units from {value set} ({strength})`

>**Note:** Use of the word `units` is suggested for clarity, but is optional.

**Examples:**

* Set the valueQuantity of an Observation to 55 millimeters using UCUM units:

  `* valueQuantity = 55.0 'mm'`

* Set the numerical value of Observation.valueQuantity to 55.0 without setting the units:

  `* valueQuantity.value = 55.0`

* Set the units of the same valueQuantity to millimeters, without setting the value (assuming UCUM has been defined as an alias for http://unitsofmeasure.org):

  `* valueQuantity = UCUM#mm "millimeters"`

* Alternate syntax for the same operation (addition of the word `units`):

  `* valueQuantity units = UCUM#mm "millimeters"`

* Bind a value set to the units of the same quantity (using alternate syntax):

  `* valueQuantity units from http://hl7.org/fhir/ValueSet/distance-units`


### Paths

FSH path grammar allows you to refer to any element of a profile, extension, or instance, regardless of nesting. Paths also provide a grammar for addressing elements of a SD directly. Here are a few examples of how paths are used in FSH:

* To refer to a top-level element such as the 'code' element in Observation
* To refer to a nested element, such as the 'method.text' element in Observation
* To address a particular item in a list or array
* To refer to individual elements inside choice elements (e.g., onsetAge in onset[x])
* To pick out an individual item within a multiple choice reference, such as Observation in Reference(Observation \| Condition)
* To refer to an individual slice within a sliced array, such as the SystolicBP component within a blood pressure
* To set metadata elements in SD, like 'active' and 'experimental'
* To address properties of ElementDefinitions nested within a SD, such as 'maxLength' property of string-type elements

In the following, the various types of path references are discussed.

#### Nested Element Paths

To refer to nested elements, the path lists the properties in order, separated by a dot (`.`).  Since the resource can be inferred from the definition, the resource name is not a formal part of the path (e.g., `subject` is a valid path within a Procedure definition, but `Procedure.subject` is not).

> **Note:** It is not permissible to cross reference boundaries in paths. This means that when a path gets to a Reference, that path cannot be extended further. For example, if Procedure has a subject element that is a Reference(Patient), and Patient has a gender, then `subject` is a valid path, but `subject.gender` is not, because it crosses into the Patient reference.

**Example:**

* Observation has an element named method, and method has a text property.  Set the text property of an Observation's method to "Laparoscopy":

  `* method.text = "Laparoscopy"`

#### Array Property Paths

If an element allows more than one value (e.g., `0..*`), then it must be possible to address each individual value. FSH denotes this with square brackets (`[` `]`) containing the **0-based** index of the item (e.g., first item is `[0]`, second item is `[1]`, etc.).

If the index is omitted, the first element of the array (`[0]`) is assumed. 

**Examples:**

* Set a Patient's first name's second given name to "Marie":

  `* name[0].given[1] = "Marie"`

* Equivalent expression, since the zero index is assumed when omitted:

  `* name.given[1] = "Marie"`

#### Reference Paths

Frequently in FHIR, an element has a Reference that has multiple targets. To address a specific target, follow the path with square brackets (`[` `]`) containing the target type (or the profile's `name`, `id`, or `url`).

**Example:**

* Restrict the Practitioner reference in a performer element (type Reference(Organization \| Practitioner)) to PrimaryCareProvider, assuming PrimaryCareProvider is a profile on Practitioner:

  `* performer[Practitioner] only PrimaryCareProvider`

#### Data Type Choice [x] Paths

Addressing a type from a choice of types replaces the `[x]` in the property name with the type name (while also capitalizing the first letter). This follows the approach used in FHIR JSON and XML serialization.

**Example:**

* Fix value[x] string value to "Hello World":

  `* valueString = "Hello World"`

* Fix the value[x] Reference (permitted in extensions) to an instance of the Patient resource:

  `* valueReference = Reference(EveAnyperson)`

#### Profiled Type Choice Paths

In some cases, a type may be constrained to a set of possible profiles. To address a specific profile on that type, follow the path with square brackets (`[` `]`) containing the profile's `name`, `id`, or `url`.

**Example:**

* After constraining an address element to either a USAddress or a CanadianAddress, bind the address.state properties to a value set of US states and Canadian provences:

  ```
  * address only USAddress or CanadianAddress
  * address[USAddress].state from USStateValueSet (required)
  * address[CanadianAddress].state from CanadianProvenceValueSet (required)
  ```

#### Extension Paths

Extensions are arrays populated by slicing. They may be addressed using the slice path syntax presented above. However, extensions being very common in FHIR, FSH supports a compact syntax for paths that involve extensions. <!--The compact syntax drops `extension[ ]` or `modifierExtension[ ]` (similar to the way the `[0]` index can be dropped). The only time this is not allowed is when dropping these terms creates a naming conflict.-->

**Examples:**

* Set the value of the birthsex extension in US Core Patient (assume USCoreBirthsex has been defined as an alias for the birthsex extension):

  `* extension[USCoreBirthsex].valueCode = #F`

* Set the nested ombCategory extension, under the ethnicity extension in US Core:

  `* extension[USCoreEthnicity].extension[ombCategory].valueCoding = RACE#2135-2 "Hispanic or Latino"`

* Set two values in the multiply-valued nested extension, detailed, under USCoreEthnicity extension:

```
  * extension[USCoreEthnicity].extension[detailed][0].valueCoding = RACE#2184-0 "Dominican"
  * extension[USCoreEthnicity].extension[detailed][1].valueCoding = RACE#2148-5 "Mexican"
```

#### Sliced Array Paths

FHIR allows lists to be compartmentalized into sublists called "slices".  To address a specific slice, follow the path with square brackets (`[` `]`) containing the slice name. Since slices are most often unordered, slice names rather than array indices should be used.

To access a slice of a slice (i.e., _reslicing_), follow the first pair of brackets with a second pair containing the resliced slice name.

**Examples:**

* In an Observation profile representing Apgar score, with slices for RespiratoryScore, AppearanceScore, and others, fix the RespirationScore:

  `* component[RespiratoryScore].code = SCT#24388001 "Apgar score 5 (finding)"`

* If the Apgar RespiratoryScore is resliced to represent the one and five minute Apgar scores, set the OneMinuteScore and FiveMinuteScore sub-slices:

  `* component[RespiratoryScore][OneMinuteScore].code = SCT#24388001 "Apgar score 5 (finding)"`

  `* component[RespiratoryScore][FiveMinuteScore].code = SCT#13323003 "Apgar score 7 (finding)"`

#### Structure Definition Escape Paths

FSH uses the caret (`^`) syntax to provide direct access to attributes of a StructureDefinition. The caret syntax is used to set the metadata attributes in SD, other than those set through [FSH Keywords](#keywords) (name, id, title, and description) or specified in one of the configuration files used to create the IG. Examples of metadata elements in SDs can be set with caret syntax include experimental, useContext, and abstract.

The caret syntax can also be combined with element paths to set values in the ElementDefinitions that populate the SD.

**Examples:**

* Set the status 'experimental' attribute of a StructureDefinition from inside a profile:

  `* ^experimental = false`

* For element communication.language, set the description attribute of the binding in the ElementDefinition:

  `* communication.language ^binding.description = "This binding is dictated by US FDA regulations."`


***
### Rules

Rules are the mechanism for constraining a profile, defining an extension, creating slices, and more. All rules begin with an asterisk:

`* {rule statement}`

We have already sneakily introduced a few types of rules: the fixed value rule (assignment using `=`), the binding rule (using `from`), and the data type restriction rule (using `only`).

Here is a summary of the rules supported in FSH:

| Rule Type | Syntax |
| --- | --- |
| Fixed value |`* {path} = {value}` <br/> `* {path} = {value} (exactly)` |
| Value set binding |`* {path} from {valueSet} ({strength})`| 
| Narrowing cardinality | `* {path} {min}..{max}` <br/>`* {path} {min}..` <br/>`* {path} ..{max}` |
| Data type restriction | `* {path} only {type1} or {type2} or {type3}` |
| Reference type restriction | `* {path} only Reference({type1} | {type2} | {type3})` |
| Flag assignment | `* {path} {flag1} {flag2}` <br/> `* {path1}, {path2}, {path3}... {flag}` |
| Standalone Extensions | `* {extension path} contains {ExtensionNameIdOrURL} named {extensionSliceName} {card} {flags}` <br/>  `* {extension path} contains {ExtensionNameIdOrURL1} named {extensionSliceName1} {card1} {flags1} and {ExtensionNameIdOrURL2} named {extensionSliceName2} {card2} {flags2} ...` 
| Inline Extensions | `* {extension path} contains {extensionSliceName} {card} {flags}`  <br/> `* {extension path} contains {extensionSliceName1} {card1} {flags1} and {extensionSliceName2} {card2} {flags2} ...` |
| Slicing | `* {array element path} contains {sliceName1} {card1} {flags1} and {sliceName2} {card2} {flags2}...` |
| Invariants | `* obeys {invariant}` <br/> `* {path} obeys {invariant}` <br/> `* obeys {invariant1} and {invariant2} ...` <br/> `* {path} obeys {invariant1} and {invariant2} ...` |
| Mapping | `* {path} -> {string}` |
{: .grid }

#### Fixed Value Rules

Fixed value assignments follows this syntax:

`* {path} = {value}`

To assign a reference to another resource, use:

`* {path} = Reference({resource instance})`

The left side of the expression follows the [FSH path grammar](#paths). The right side's data type must aligned with the data type of the final element in the path.

**Note:** In profiles and extensions, fixed values represent the **minimum criteria** for conformance. Consider the following two statements:

`* code = http://loinc.org#69548-6`

`* code = http://loinc.org#69548-6 "Genetic variant assessment"`

In the context of a **profile**, the first statement signifies an instance must have (1) the system http://loinc.org and (2) the code 69548-6 to pass validation. The second statement says that an instance must have (1) the system http://loinc.org, (2) the code 69548-6, **and (3)** the display text "Genetic variant assessment" to pass validation. Typically, only the system and code are important conformance criteria, so the first statement (without the display text) is preferred in a profiling context. In an **instance**, however, the display text conveys additional information useful to the information receiver, so the second statement would be preferred.

***
 💪 Power-User Feature: Forcing An Exact Match

An additional syntax, applicable only to Profiles and Extensions, is:

`* {path} = {value} (exactly)`

The `exactly` option indicates that conformance to the profile requires a precise match to the specified value, **no more and no less**. Any additional extensions, ids, or additional array elements are specifically disallowed. The usual assignment, without `(exactly)`, allows any instance that fulfills the prescribed pattern to be considered conformant, **no less but possibly more**. For example, when assigning a fixed CodeableConcept in a profile, the typical simple assignment `=` allows additional codes in the Coding array. If you specify `(exactly)`, then one and only one Coding is allowed.

**Note:** The `(exact)` modifier does not apply to instances.

***

**Examples:**

* Assignment of a code data type:

  `* status = #arrived`

* Recommended style for assignment of a LOINC code in an **instance** of an Observation:

  `* code = LNC#69548-6 "Genetic variant assessment"`

* Recommended style for assignment of a LOINC code in an Observation **profile**:

  `* code = LNC#69548-6  // Genetic variant assessment (display text in comment only!)`

* Assignment of a boolean:

  `* active = true`

* Assignment of a date:

  `* onsetDateTime = "2019-04-02"`

* Assignment of a quantity with single quotes indicating UCUM units:

  `* valueQuantity = 36.5 'C'`

* Assignment of a reference type to another resource:

  `* subject = Reference(EveAnyperson)`


#### Value Set Binding Rules

Binding is the process of associating a coded element with a set of possible values. The syntax to bind a value set, or alter an inherited binding, uses the reserved word `from`:

`* {path} from {valueSet} ({strength})`

The value set can be the name of a value set defined in the same [FSH tank](index.html#fsh-tanks), or the defining URL of an external value set that is part of the core FHIR spec, or an IG that has been declared an external dependency.

The strengths are the same as the [binding strengths defined in FHIR](https://www.hl7.org/fhir/valueset-binding-strength.html), namely: example, preferred, extensible, and required.

The following rules apply to binding in FSH:

* If no binding strength is specified, the binding is assumed to be required.
* When further constraining an existing binding, the binding strength can stay the same or be made tighter (e.g., replacing a preferred binding with extensible or required), but never loosened.
* Constraining may leave the binding strength the same and change the value set instead. However, certain changes permitted in FSH may violate [FHIR profiling principles](http://hl7.org/fhir/R4/profiling.html#binding-strength). In particular, FHIR will permit a required value set to be replaced by another required value set only if the codes in the new value set are a subset of the codes in the original value set. For extensible bindings, the new value set can contain codes not in the existing value set, but additional codes **should not** have the same meaning as existing codes in the base value set.

**Examples:**

* Bind to an externally-defined value set using its canonical URL:

  `* telecom.system from http://hl7.org/fhir/ValueSet/contact-point-system (required)`

* Bind to an externally-defined value set with required binding by default:

  `* gender from http://hl7.org/fhir/ValueSet/administrative-gender`

* Bind to a value set using an alias name:

  `* address.state from USPSTwoLetterAlphabeticCodes (extensible)`

#### Cardinality Rules

Cardinality rules constrain (narrow) the number of repetitions of an element. Every element has a cardinality inherited from its parent resource or profile. If the inheriting profile does not alter the cardinality, no cardinality rule is required.

To change the cardinality, the grammar is:

`* {path} {min}..{max}`

As in FHIR, min and max are non-negative integers, and max can also be *, representing unbounded. It is valid (and even encouraged) to include both the min and max, even if one of them remains the same as in the original cardinality. In this case, FSH processors (e.g., SUSHI) should only generate constraints for the changed values. FSH also supports one-sided cardinalities if the author wishes to omit an unconstrained min or max in the expression.

Cardinalities must follow [rules of FHIR profiling](https://www.hl7.org/fhir/conformance-rules.html#cardinality), namely that the min and max cardinalities must stay within the constraints of the parent.

For convenience and compactness, cardinality rules can be combined with [flag assignment rules](#flag-assignment-rules) via the following grammar:

`* {path} {min}..{max} {flag1} {flag2} ...`

**Examples:**

* Set the cardinality of the subject element to 1..1 (required, non-repeating):

  `* subject 1..1`

* Set the cardinality of the subject element to 1..1 and declare it Must Support:

  `* subject 1..1 MS`

* Set the cardinality of a sub-element to 0..0 (not permitted):

  `* component.referenceRange 0..0`

* 🚧 Require at least one category without changing its upper bound (*):

  `* category 1..`

* 🚧 Allow at most one category without changing its lower bound (0):

  `* category ..1`

#### Data Type Restriction Rules

FSH rules can be used to restrict the data type of an element. The shorthand syntax to restrict the type is:

 `* {path} only {type}`

 `* {path} only {type1} or {type2} or {type3}...`

where the latter offers a choice of data type. The data type choices must always be more restrictive than the original data type. For example, if the parent data type is Quantity, it can be replaced in an `only` rule by SimpleQuantity, since SimpleQuantity is a profile on Quantity (hence more restrictive than Quantity itself).

Certain elements in FHIR offer a choice of data types using the [x] syntax. Choices can be restricted in two ways: reducing the number or choices, or substituting a more restrictive data type or profile for one of the original choices.  

**Examples:**

* Restrict a Quantity type to SimpleQuantity:

  `* valueQuantity only SimpleQuantity`

* Condition.onset[x] is a choice of dateTime, Age, Period, Range or string. To restrict onset[x] to dateTime:

  `* onset[x] only dateTime`

* Restrict onset[x] to either Period or Range:

  `* onset[x] only Period or Range`

* Restrict onset[x] to Age, AgeRange, or DateRange, assuming AgeRange and DateRange are profiles of FHIR's Range datatype (thus permissible restrictions on Range):

  `* onset[x] only Age or AgeRange or DateRange`

#### Reference Type Restriction Rules

Elements that refer to other resources often offer a choice of target resource types. For example, Condition.recorder has reference type choice Reference(Practitioner \| PractitionerRole \| Patient \| RelatedPerson). A reference type restriction rule can narrow these choices, using the following grammar:

`{path} only Reference({type1} | {type2} | {type3} ...)`

> **Note:** The vertical bar within references represents logical 'or'.

It is important to note that a reference can only be restricted to a compatible type. For example, the subject of [US Core Condition](http://hl7.org/fhir/us/core/StructureDefinition-us-core-condition.html), with type Reference(US Core Patient), cannot be restricted to Reference(Patient), because Patient is not a profile of US Core Patient.

**Examples:**

* Restrict recorder to a reference to any Practitioner:

  `* recorder only Reference(Practitioner)`

* Restrict recorder to either a Practitioner or a PractitionerRole:

  `* recorder only Reference(Practitioner | PractitionerRole)`

* Restrict recorder to `PrimaryCarePhysician` or `EmergencyRoomPhysician`, assuming these are both profiles on `Practitioner`:

  `* recorder only Reference(PrimaryCarePhysician | EmergencyRoomPhysician)`

#### Flag Assignment Rules

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

FHIR also defines I and NE flags. These are not supported by FSH, since they are derived from other information.

The following syntax can be used to assigning flags:

`* {path} {flag1} {flag2} ...`

`* {path1}, {path2}, {path3}... {flag}`

**Examples:**

* Declare communication to be MustSupport and Modifier:

  `* communication MS ?!`

* Declare a list of elements and nested elements to be MustSupport:

  `* identifier, identifier.system, identifier.value, name, name.family MS`

#### Extension Rules

Extensions are created by adding elements to built-in 'extension' array elements. Extension arrays are found at the root level of every resource, nested inside every element, and recursively inside each extension. The structure of extensions is defined by FHIR (see [Extension element](https://www.hl7.org/fhir/extensibility.html#extension)). Constraining extensions is discussed in [Defining Extensions](#defining-extensions). The same instructions apply to 'modifierExtension' arrays.

Extensions are specified using the `contains` keyword. There are two types of extensions: **standalone** and **inline**:

* Standalone extensions have independent StructureDefinitions, and can be reused. Standalone extension can be externally-defined, and referred to by their canonical URLs, or defined in the same FSH tank using the `Extension` keyword, and referenced by their name or id.
* Inline extensions do not have separate StructureDefinitions, and cannot be reused in other profiles. Inline extensions are typically used to specify sub-extensions in a complex (nested) extension. When defining an inline extension, it is typical to use additional rules (such as cardinality, data type and binding rules) to further define the extension.

The shorthand syntax to specify a standalone extension is:

`* {extension element path} contains {ExtensionNameIdOrURL1} named {extensionSliceName1} {card1} {flags1} and {ExtensionNameIdOrURL2} named {extensionSliceName2} {card2} {flags2}...`

The shorthand syntax to define an inline extension is:

`* {extension element path} contains {extensionSliceName1} {card1} {flags1} and {extensionSliceName2} {card2} {flags2}...`

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

* Add a standalone extension, defined in the same FSH tank, to a bodySite attribute (second level extension):

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
  * extension[ombCategory] only Coding
  * extension[ombCategory].valueCoding from http://hl7.org/fhir/us/core/ValueSet/omb-race-category (required)
  * extension[text] only string
  // etc...
  ```



#### Slicing Rules

Slicing is an advanced, but necessary, feature of FHIR. While future versions of FHIR Shorthand will aim to lower the learning curve, FHIR Shorthand version 1.0 requires authors to have a basic understanding of [slicing](http://hl7.org/fhir/R4/profiling.html#slicing) and [discriminators](http://hl7.org/fhir/R4/profiling.html#discriminator). In FSH, slicing is addressed in three steps: (1) specifying the slicing logic, (2) identifying the slices, and (3) defining each slice's contents.

##### Step 1. Specifying the Slicing Logic

Slicing in FHIR requires authors to specify a [discriminator path, type, and rules](http://www.hl7.org/fhir/R4/profiling.html#discriminator). In addition, authors can optionally declare the slice as ordered or unordered (default: unordered), and/or provide a description.

In FSH, authors must specify the slicing logic parameters using [structure definition escape (caret) syntax](#structure-definition-escape-paths). First they identify the element to be sliced, which is typically a multi-cardinality element. Then they traverses the structure definition at that point.

**Example:**

* Provide slicing logic for slices on Observation.component that should be distinguished by their code:

```
* component ^slicing.discriminator.type = #pattern
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open
* component ^slicing.ordered = false   // can be omitted, since false is the default
* component ^slicing.description = "Slice based on the component.code pattern"
```

##### Step 2. Identifying Slices

The next step in slicing is exactly the same as specifying inline extensions, using the `contains` keyword. The following syntax is used:

```
* {array element path} contains
       {sliceName1} {card1} {flags1} and
       {sliceName2} {card2} {flags2} and
       {sliceName3} {card3} {flags3} ...
```

In this pattern, the `{array element path}` is a path to the element that is to be sliced (and to which the slicing rules were applied in step 1). The `{card}` declaration is required, and `{flags}` are optional.

Each slice will match or constrain the data type of the array it slices. In particular:

* If an array is a one of the FHIR data types, each slice will be the same data type or a profile of it. For example, if an array of 'identifier' is sliced, then each slice will also be type 'identifier' or a profile of 'identifier'.
* If the sliced array is a backbone element, each slice "inherits" the sub-elements of the backbone. For example, the slices of Observation.component possess all the elements of Observation.component (code, value[x], dataAbsentReason, etc.). Constraints may be applied to the slices.
* If the array to be sliced is a Reference, then each slice must be a reference to one or more of the allowed Reference types. For example, if the element to be sliced is Reference(Observation \| Condition), then each slice must either be Reference(Observation \| Condition), Reference(Observation), Reference(Condition), or a profiled version of those resources.

**Example:**

* Slice the Observation.component array for blood pressure:

  `* component contains SystolicBP 1..1 MS and DiastolicBP 1..1 MS`

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

##### Step 3. Defining Slice Contents

At a minimum, each slice must be constrained such that it can be uniquely identified via the discriminator. For example, if the discriminator points to a "code" path that is a CodeableConcept, and it discriminates by "pattern", then each slice must have a constraint on "code" that uniquely distinguishes it from the other slices' codes. In addition to this minimum requirement, authors often place additional constraints on other aspects of each slice.

Future versions of FHIR Shorthand may support standalone slice definitions, but FHIR Shorthand version 1.0 requires slice contents to be defined inline. The rule syntax for inline slices is the same as constraining any other path in a profile, but uses the [slice path syntax](#sliced-array-paths) in the path:

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
* component[SystolicBP].valueQuantity units = UCUM#mm[Hg] "mmHg"
* component[DiastolicBP].code = LNC#8462-4 // Diastolic blood pressure
* component[DiastolicBP].value[x] only Quantity
* component[DiastolicBP].valueQuantity units = UCUM#mm[Hg] "mmHg"
```

#### Invariant Rules

[Invariants](https://www.hl7.org/fhir/conformance-rules.html#constraints) are constraints that apply to one or more values in instances, expressed as [FHIRPath expressions](https://www.hl7.org/fhir/fhirpath.html). An invariant can apply to an instance as a whole or a single element. Multiple invariants can be applied to an instance as a whole or to a single element. The FSH grammars for applying invariants in profiles are as follows:

`* obeys {invariant}`

`* {path} obeys {invariant}`

`* obeys {invariant1} and {invariant2} ...`

`* {path} obeys {invariant1} and {invariant2} ...`

The first case applies the invariant to the profile as a whole. The second case applies the invariant to a single element. The third case applies multiple invariants to the profile as a whole, and the fourth case applies multiple invariants to a single element.

The referenced invariant and its properties must be declared somewhere within the same [FSH tank](index.html#fsh-tanks), using the `Invariant` keyword. See [Defining Invariants](#defining-invariants).

**Examples:**

* Assign invariant to US Core Implantable Device (invariant applies to profile as a whole):

  `* obeys us-core-9`

* Assign invariant to Patient.name in US Core Patient:

  `* name obeys us-core-8`

#### Mapping Rules

🚧 [Mappings](https://www.hl7.org/fhir/mappings.html) are an optional part of SDs that can be provided to help implementers understand the content and use resources correctly. These mappings are informative and are not to be confused with the computable mappings provided by [FHIR Mapping Language](https://www.hl7.org/fhir/mapping-language.html) and the [StructureMap resource](https://www.hl7.org/fhir/structuremap.html).

In FSH, mapping rules are not included in the profile definition.  Rather, they are included in a separate [Mapping definition](#defining-mappings) that provides additional context such as the higher level source and target. Within that definition mapping rules use the symbol `->` with the following grammar:

`* {path} -> {string}`

**Examples:**

* Map the entire profile to a Patient item in another specification:

  `* -> Patient`

* Map the identifier.value element from one IG to another:

  `* identifier.value -> "Patient.identifier.value"`

>**Note:** Unlike setting the mapping directly in the SD, mapping rules within a Mapping item do not include the name of the resource in the path on the left hand side.

***

### Defining Items

This section shows how to define various items in FSH:

* [Aliases](#defining-aliases)
* [Profiles](#defining-profiles)
* [Extensions](#defining-extensions)
* [Instances](#defining-instances)
* [Value Sets](#defining-value-sets)
* [Code Systems](#defining-code-systems)
* [Mappings](#defining-mappings)
* [Rule Sets](#defining-rule-sets)
* [Invariants](#defining-invariants)

#### Keywords

Keywords are used to make declarations that introduce new items, such as profiles and instances. For each item defined in FSH, a keyword section is first followed by a number of rules. The keyword statements themselves follow the syntax:

`{Keyword}: {value}`

For example:

`Profile: SecondaryCancerCondition`

`Description: "The intent of the treatment."`

For some keywords, values are **FSH names**. A name is any sequence of non-whitespace characters, used to refer to the item within the same [FSH tank](index.html#fsh-tanks). By convention, names should use [PascalCase (also known as UpperCamelCase)](https://wiki.c2.com/?UpperCamelCase).

The use of individual keywords is explained in greater detail in the following sections. Here is a summary of keywords in FSH:

| Keyword | Purpose | Data Type |
|----------|---------|---------|
| `Alias`| Defines an alias for a URL or OID | uri, url, or oid  |
| `CodeSystem` | Declares a new code system | name |
| `Description` | Provides a human-readable description | string, markdown |
| `Expression` | The FHIR path expression in an invariant | string |
| `Extension` | Declares a new extension | name |
| `Id` | Set a unique identifier of an item | name |
| `Instance` | Declares a new instance | name |
| `InstanceOf` | The profile or resource an instance instantiates | name |
| `Invariant` | Declares a new invariant | name |
| 🚧 `Mapping` | Declares a new mapping | name |
| `Mixins` | Declares rule sets or profile rules to be included in a profile | name or names (comma separated) |
| `Parent` | Specifies the base class for a profile or extension | name |
| `Profile` | Declares a new profile | name |
| `RuleSet` | Declares a set of rules that can be used as a mixin | name |
| `Severity` | error, warning, or guideline in invariant | code |
| `Source` | Profile or path a mapping applies to | path |
| `Target` | The standard that the mapping maps to | string |
| `Title` | Short human-readable name | string |
| `Usage` | Specifies how an instance is intended to be used in the IG | Example, Definition, or Inline |
| `ValueSet` | Declares a new value set | name |
| `XPath` | the xpath in an invariant | string |
{: .grid }

#### Defining Aliases

Aliases allow the user to replace a lengthy url or oid with a short string. Aliases are for readability only, and do not change the meaning of rules. Typical uses of aliases are to represent code systems and canonical URLs.

Alias definitions follow this syntax:

`Alias: {AliasName} = {url or oid}`

In contrast with other names in FSH (for profiles, extensions, etc.), aliases can begin with a dollar sign ($).

If you choose a name beginning with a dollar sign, then additional error checks can be carried out. Specifically, if a rule involves a $name, it can only be an alias. If there is no corresponding alias definition, an error can be signalled.

Another best practice is to choose alias names written in all capitals.

**Examples:**

`Alias: SCT = http://snomed.info/sct`

`Alias: RACE = urn:oid:2.16.840.1.113883.6.238`

`Alias: $ObsCat = http://terminology.hl7.org/CodeSystem/observation-category`

#### Defining Profiles

To define a profile, the keywords `Profile` and `Parent` are required, and `Id`, `Title`, and `Description` should be used. The keyword `Mixins` is optional.

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

Instances inherit structures and values from their StructureDefinition (i.e. fixed codes, extensions). Fixed value rules are used to set additional values.

The `Usage` keyword specifies how the instance should be presented in the IG:

* `Usage: Example` means the instance is intended as an illustration of a profile, and will be presented on the Examples tab for the corresponding profile.
* `Usage: Definition` means the instance is a conformance item that is an instances of a resource such as a search parameter, operation definition, or questionnaire. These items will presented on their own IG page.
* `Usage: Inline` means the instance should not be instantiated as an independent resource, but appears as part of another instance (for example, in a composition or bundle).


**Examples:**
```
Instance:  EveAnyperson
InstanceOf: http://hl7.org/fhir/us/core/StructureDefinition/us-core-patient
Title:   "Eve Anyperson"
Usage:  Example
* name.given = "Eve"
* name.given[1] = "Steve"
* name.family = "Anyperson"
* birthDate = 1960-04-25
* us-core-race.ombCategory.valueCoding = RACE#2106-3 "White"
* us-core-ethnicity.ombCategory.valueCoding = RACE#21865 "Non Hispanic or Latino"
```

```
Instance:   DrDavidAnydoc
InstanceOf: http://hl7.org/fhir/us/core/StructureDefinition/us-core-practitioner
Title:  "Dr. David Anydoc"
Usage:  Example
* name[0].family = Anydoc
* name[0].given[0] = David
* name[0].suffix[0] = MD
* identifier[NPI].value = 8274017284
```

```
Instance:   PrimaryCancerDiagnosis
InstanceOf: http://hl7.org/fhir/us/mcode/StructureDefinition/onco-core-PrimaryCancerCondition
Title:  "Primary Cancer Diagnosis"
Usage:  Example
* subject = EveAnyperson
* clinicalStatus = #active
* verificationStatus = #confirmed
* category = CCAT#problem-list-item
* asserter = DrDavidAnydoc
* condition-assertedDate.valueDateTime = 2019-09-13T12:30:00.0Z
* onco-core-HistologyMorphologyBehavior-extension.valueCodeableConcept = SCT#35917007 "Adenocarcinoma, no subtype"
* code = SCT#93864006 "Primary malignant neoplasm of lower lobe of left lung"
```

#### Defining Value Sets

A value set is a group of coded values, usually representing the acceptable values in a FHIR element whose data type is code, Coding, or CodeableConcept.

Value sets are defined using the keywords `ValueSet`, `Id`, `Title` and `Description`.

Codes must be taken from one or more terminology systems (also called code systems or vocabularies), and cannot be defined inside a value set. If necessary, [you can define your own code system](#defining-code-systems).

The contents of a value set are defined by a set of rules. There are four types of rules to populate a value set:

| To include... | Syntax | Example |
|-------|---------|----------|
| A single code | `* {Coding}` | `* SCT#961000205106 "Wearing street clothes, no shoes"` |
| All codes from a value set | `* codes from valueset {Id}` | `* codes from valueset http://hl7.org/fhir/ValueSet/data-absent-reason` |
| All codes from a code system | `* codes from system {Id}` | `* codes from system http://snomed.info/sct` |
| Selected codes from a code system (filters are code system dependent) | `* codes from system {system} where {filter} and {filter} and ...` | `* codes from system SCT where concept is-a #254837009` |
{: .grid }

See [below](#filters) for discussion of filters.

> **Note:** `{system}` can be a FSH name, alias or URL.

Analogous rules can be used to leave out certain codes, with the addition of the word `exclude`:

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

* Explicit ([extensional](https://www.hl7.org/fhir/valueset.html#int-ext)) value set:

```
ValueSet: BodyWeightPreconditionVS
Title: "Body weight preconditions."
Description:  "Circumstances for body weight measurement."
* SCT#971000205103 "Wearing street clothes with shoes"
* SCT#961000205106 "Wearing street clothes, no shoes"
* SCT#951000205108 "Wearing underwear or less"
```

* Algorithmically-defined ([intensional](https://www.hl7.org/fhir/valueset.html#int-ext))  value set:

```
* codes from system SCT where concept is-a #367651003 "Malignant neoplasm of primary, secondary, or uncertain origin (morphologic abnormality)"
* codes from system SCT where concept is-a #399919001 "Carcinoma in situ - category (morphologic abnormality)"
* codes from system SCT where concept is-a #399983006 "In situ adenomatous neoplasm - category (morphologic abnormality)"
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

`* #{code} {display text string} {definition text string}`

**Note:**
* Do not include a code system before the hash sign `#`. The code system name is given by the `CodeSystem` keyword.
* The definition of the term can be optionally provided as the second string following the code.

**Example:**

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

🚧 [Mappings to other standards](https://www.hl7.org/fhir/mappings.html) are an optional part of a SD. These mappings are informative and are provided to help implementers understand the content of the SD and use the profile or resource correctly. While it is possible for profile authors to include mappings using escape syntax, FSH provides a more modular approach.

> **Note:** The informational mappings in SDs should not be confused with functional mappings provided by [FHIR Mapping Language](https://www.hl7.org/fhir/mapping-language.html) and the [StructureMap resource](https://www.hl7.org/fhir/structuremap.html).

To create a mapping, the keywords `Mapping`, `Source`, `Target` and `Id` are used. Any number of [mapping rules](#mapping-rules) then follow.

**Example:**

```
  Mapping:  USCorePatientToArgonaut
  Source:   USCorePatient
  Target:   "http://unknown.org/Argonaut-DQ-DSTU2"
  Id:       argonaut-dq-dstu2
  * -> Patient
  * extension[USCoreRaceExtension] -> "Patient.extension[http://fhir.org/guides/argonaut/StructureDefinition/argo-race]"
  * extension[USCoreEthnicityExtension] -> "Patient.extension[http://fhir.org/guides/argonaut/StructureDefinition/argo-ethnicity]"
  * extension[USCoreBirthSexExtension] -> "Patient.extension[http://fhir.org/guides/argonaut/StructureDefinition/argo-birthsex]"
  * identifier -> "Patient.identifier"
  * identifier.system -> "Patient.identifier.system"
  * identifier.value -> "Patient.identifier.value"
```

In the example above, the target is another FHIR profile, but in many cases, the target will not use FHIR. For this reason, the right-hand side of mapping statements is always a string in order to allow the greatest flexibility. For this same reason, even though the target is FHIR in the example above, FSH cannot make any assumptions about how the individual target values work; thus the resource name "Patient" is included in the right-hand side values since this is how the mapping targets should be expressed in the SD.

#### Defining Rule Sets

🚧 Rule sets provide the ability to define rules and apply them ("mix in") to a compatible target. The rules are copied from the rule set at compile time. Profiles, extensions, and instances can have one or more rule sets applied to them. The same rule set can be used in multiple places.

Rule sets are defined by using the keyword `RuleSet`:
```
RuleSet: {RuleSetName}
* {rule1}
* {rule2}
// More rules
```
A defined rule set can be applied to an item by using the keyword `Mixins`:
```
Profile: MyPatientProfile
Parent: Patient
Mixins: {RuleSet1}, {RuleSet2}
```
Each rule set should be compatible with the target, in the sense that all the rules defined in the rule set apply to elements actually present in the target. The legality of a rule set is checked at compile time. If a particular rule from a rule set does not match an element in the target, that rule will not be applied, and an error will be emitted. However, all other valid rules from the rule set will still be applied. The rules from a rule set are applied **before** rules defined on the target itself. When multiple rule sets are included using the `Mixins` keyword, the rule set rules are applied in the order that the rule sets are listed.

Currently only rule sets can be mixed into profiles and extensions, but future versions of FHIR Shorthand may allow external definitions (such as other profiles and extensions) to be mixed in as well.

**Examples:**
Defining and using a mixin for metadata shared in all US Core Profiles:
```
  RuleSet: USCoreMetadata
  * ^version = "3.1.0"
  * ^status = #active
  * ^experimental = false
  * ^publisher = "HL7 US Realm Steering Committee"
  * ^contact.telecom.system = #url
  * ^contact.telecom.value = "http://www.healthit.gov"
  * ^jurisdiction.coding = COUNTRY#US "United States of America"

  Profile: MyUSCorePatientProfile
  Parent: Patient
  Mixins: USCoreMetadata
  * deceased[x] only deceasedBoolean
  // More profile rules
```
The `MyUSCorePatientProfile` defined above is equivalent to the following:
```
  Profile: MyUSCorePatientProfile
  Parent: Patient
  * ^version = "3.1.0"
  * ^status = #active
  * ^experimental = false
  * ^publisher = "HL7 US Realm Steering Committee"
  * ^contact.telecom.system = #url
  * ^contact.telecom.value = "http://www.healthit.gov"
  * ^jurisdiction.coding = COUNTRY#US "United States of America"
  * deceased[x] only deceasedBoolean
  // More profile rules
```
Mixins give you the capability to define that metadata once and apply it in as many places as it is applicable. Here is another example showing how mixins can be used to define two national IGs:
```
  Profile: USCoreBreastRadiologyProfile
  Parent: BreastRadiologyProfile
  Mixins:  USObservationRuleSet

  Profile: FranceBreastRadiologyProfile
  Parent: BreastRadiologyProfile
  Mixins: FranceObservationRuleSet
 ```

#### Defining Invariants

Invariants are defined using the keywords `Invariant`, `Description`, `Expression`, `Severity`, and `XPath`. An invariant definition does not have any rules.

**Example:**
```
Invariant:  us-core-8
Definition: "Patient.name.given or Patient.name.family or both SHALL be present"
Expression: "family.exists() or given.exists()"
Severity:   #error
XPath:      "f:given or f:family"
```

> **Note:** The Invariant is incorporated into a profile via `obeys` rules explained [above](#invariant-rules).
