This chapter describes the FHIR Shorthand (FSH) language in detail. It is intended to be used as a reference manual, not a pedagogical document.

This chapter uses an intuitive pseudo-grammar to illustrate the patterns used in FSH. (Readers interested in the formal grammar are referred to this [Appendix](#appendix-formal-grammar).) Syntatic patterns are presented first, followed by examples. The presentation uses the following conventions:

| Style | Explanation | Example |
|:----------|:------|:---------|
| `Code` | Code fragments, such as commands, FSH statements, and syntax expressions  | `* status = #open` |
| `{curly braces}` | An item to be substituted in a syntax pattern | `{string}` |
| `<data type>` | An element, or path to an element, of the given data type | `<CodeableConcept>`
| _italics_ | An optional item in a syntax pattern | <code><i>"{string}"</i></code> |
| ellipsis (...) | A repeated pattern that can continue | <code><i>{flag1} {flag2}</i>&nbsp;...</code>
| **bold** | A directory path or file name | **example-1.fsh** |
{: .grid }


<!--


coded = Any element of type code, Coding, CodeableConcept, or Quantity
flags = 

|  Pattern | Meaning |
|----|---|
| {Resource} | An indication to a Resource, a name, id, or URL |

-->

### FSH Foundations

#### Projects

The main organizing construct is a FSH project, sometimes called a "FSH Tank". Each project must have a canonical URL associated with it, used for constructing canonical URLs for items created in the project. It is up to implementations to decide how this association is made. Typically, one FSH project equates to one FHIR IG.

#### Files

Content in one FSH project is contained in one or more FSH files. FSH files use the **.fsh** extension. 

The items defined by FSH are: Aliases, Profiles, Extensions, Instances, Value Sets, Code Systems, Mappings, Rule Sets, and Invariants. How items are divided among files is not meaningful in FSH, and items from all files in one project can be considered pooled together for the purposes of FSH. It is up to implementations to define the association between FSH files and FSH projects.

Items can appear in any order within **.fsh** files, and can be moved around within a file (or to other **.fsh** files) without affecting the interpretation of the content.

#### Dependency on FHIR Version

Each FSH project must declare the version of FHIR it depends upon. The form of this declaration is outside the scope of the FSH specification, and should be managed by implementations. The FSH specification is not explicitly FHIR-version dependent, but implementations may support particular version(s) of FHIR.

The FSH language specification has been designed around FHIR R4. Compatibility with previous FHIR versions of FHIR has not been evaluated. FSH depends primarily on normative parts of the FHIR R4 specification (in particular, StructureDefinition and primitive data types). It is conceivable that future changes in FHIR could impact the FSH language specification, for example, if FHIR introduces new data types.

#### Dependency on other IGs

Dependencies between a FSH project and other IGs must be declared. The form of this declaration is outside the scope of the FSH language and should be managed by implementations. These are referred to as "external" IGs.

#### Version Numbering

The FSH specification, like other FHIR Implementation Guides (IGs), expresses versions in terms of three integers, x.y.z, indicating the sequence of releases. Release 2 is later than release 1 if x2 > x1 or (x2 = x1 and y2 > y1), or (x2 = x1 and y2 = y1 and z2 > z1). Implementations should indicate what version or versions of the FSH specification they implement.

Like other HL7 FHIR IGs, the numbering of FSH releases does not entirely follow the [semantic versioning convention](https://semver.org). Consistent with semantic versioning, an increment of z indicates a patch release containing minor updates and bug fixes, while maintaining backwards compatibility with the previous version. Increments in y indicates new or modified features, and potentially, non-backward-compatible changes (i.e., a minor or major release in semantic versioning). By HL7 convention, the major version number x typically does not increment until the release of a new balloted version.

### FSH Language Basics

#### Formal Grammar

[FSH has a formal grammar](#appendix-formal-grammar) defined in [ANTLR4](https://www.antlr.org/). The grammar is looser than the language specification since many things, such as data type agreement, are not enforced by the grammar. If there is discrepancy between the grammar and the FSH language description, the language description is considered correct until the discrepancy is clarified and addressed.

#### Reserved Words

FSH has a number of reserved words, symbols, and patterns. Reserved words and symbols with special meaning in FSH are: `contains`, `named`, `and`, `only`, `or`, `obeys`, `true`, `false`, `exclude`, `codes`, `where`, `valueset`, `system`, `from`, `insert`, `!?`, `MS`, `SU`, `N`, `TU`, `D`, `=`, `*`, `:`, `->`, `.`,`[`, `]`.

The following words are reserved only if followed by a colon (intervening white spaces allowed): `Alias`, `Profile`, `Extension`, `Instance`, `InstanceOf`, `Invariant`, `ValueSet`, `CodeSystem`, `RuleSet`, `Parent`, `Id`, `Title`, `Description`, `Expression`, `XPath`, `Severity`, `Usage`, `Source`, `Target`.

The following words are reserved only when enclosed in parentheses (intervening white spaces allowed): `example`, `preferred`, `extensible`, `required`, `exactly`.

#### Primitives

The primitive data types and value formats in FSH are identical to the [primitive types and value formats in FHIR](https://www.hl7.org/fhir/datatypes.html#primitive). References in this document to `code`, `id`, `oid`, etc. refer to the primitive datatypes defined in FHIR.

FSH strings support the escape sequences that FHIR already defines as valid in its [regex for strings](https://www.hl7.org/fhir/datatypes.html#primitive): \r, \n, and \t.

#### Names

FSH uses names to reference items within the same FSH project. FSH names follow [FHIR naming guidance](http://hl7.org/fhir/R4/structuredefinition-definitions.html#StructureDefinition.name). Names must be between 1 and 255 characters, begin with an uppercase, and contain only letters, numbers, and "_". 

By convention, item names should use [PascalCase (also known as UpperCamelCase)](https://wiki.c2.com/?UpperCamelCase). [Slice names](#contains-rules-for-slicing) and [local slice names for extensions](#contains-rules-for-extensions) should use [lower camelCase](https://wiki.c2.com/?CamelCase). These conventions are consistent with FHIR naming conventions.

Alias names may begin with `$`. Choosing alias names beginning with `$` allows for additional error checking [see Defining Aliases](#defining-aliases).

#### Identifiers

Items in FSH may have an identifier (id), typically specified using the [`Id` keyword](#defining-items). Each id must be unique within the scope of their item type in the FSH project. For example, two Profiles with the same id cannot coexist, but it is possible to have a Profile with id “foo” and a ValueSet with id “foo” in the same FSH Project. However, to minimize potential confusion, it is recommended to use a unique id for every id-bearing item in a FSH project.

If no id is provided, implementations may create an id. It is recommended that the id be based on the item's name, with _ replaced by -, and the overall length truncated to 64 characters (per the requirements of the FHIR id datatype).

#### Indicating External FHIR Artifacts

External FHIR artifacts in core FHIR and external IGs can be referred to by their names, ids, or canonical URLs. Core FHIR resources can be referred to by their common names, for example, `Patient` or `Observation`. Other than core FHIR resources, the use of canonical URLs to refer to external resources is recommended, since this approach minimizes the chance of name collisions.

#### Indicating Items within the FSH Project

Internal FSH items can be referred to by their names, ids, or canonical URLs. The canonical URL is usually a poor choice for referring to an internal item because it is constructed using the base canonical URL of the IG, which is part of the IG publishing process, external to FSH. Using the name or id that appears in the item's [declaration statement](#defining-items) is recommended.

#### Reference and Canonical Data Types

FHIR resources contain [two types of references](https://www.hl7.org/fhir/references.html) to other resources:

* Resource references
* Canonical references

FSH represents Resource references using the syntax `Reference({Resource})`. FSH will not accept a Resource where a Reference type is required; i.e., `Reference()` is required.

Canonical references refer to the standard URL associated with a type of FHIR resource. For elements that require a canonical reference, FSH will accept a URL, `Canonical({name})` or `Canonical({id})`, where `name` and `id` refer to items defined in the same FSH project. Implementations are to interpret `Canonical()` as an instruction to construct the canonical URL for the referenced item using the FSH project's canonical URL. `Canonical()` therefore enables a user to change the project’s canonical URL in a single place with no changes to FSH definitions.

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

The formal grammar for FSH discards all comments during import; they are not retained or used during IG generation. Implementations are free to modify the grammar to allow retention of comments.

#### Multi-line String Alternative

While line breaks are supported using FHIR strings, FSH also supports slightly different processing for strings demarcated with three double quotation marks `"""`. This feature can help authors to maintain consistent indentation in the FSH file.

As an example, an author might use a multi-line string to write markdown so that the markdown is neatly indented:

```
* ^purpose = """
    * This profile is intended to support workflows where:
      * this happens; or
      * that happens
    * This profile is not intended to support workflows where:
      * nothing happens
  """
```

Using a single-quoted string requires the following spacing to accomplish the same markdown formatting:

```
* ^purpose = "* This profile is intended to support workflows where:
  * this happens; or
  * that happens
* This profile is not intended to support workflows where:
  * nothing happens"
```

The difference between these two approaches is that the latter obscures the fact that the first and fourth line are at the same indentation level, and makes it appear there are two rules because of the asterisk in the first column. The former approach allows the first line to be empty so the string is defined as a block, and allows the entire block to be indented, so visually, it does not appear a second rule is involved.

When processing multi-line strings, the following approach is used:

* If the first line or last line contains only whitespace (including newline), discard it.
* If any other line contains only whitespace, truncate it to zero characters.
* For all other non-whitespace lines, detect the smallest number of leading spaces and trim that from the beginning of every line.

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

The FSH represents a Coding in the following ways:

<pre><code>{CodeSystem}#{code} <i>"{display string}"</i>

{CodeSystem}|{version string}#{code} <i>"{display string}"</i></code></pre>


As indicated by italics, the `"{display string}"` is optional. The `{CodeSystem}` is a reference to the controlled terminology that the code is taken from. This reference can be the name of a CodeSystem defined in the same FSH project, a URL, OID, or alias. The bar syntax for code system version is the same approach used in the `canonical` data type in FHIR. An alternative to the bar syntax is to set the `version` element of Coding (see examples). To set the less-common properties of a Coding, an [assignment rule](#assignment-rules) can be used on that element.

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

A CodeableConcept consists of an array of Codings. To populate the array, array indices, denoted by brackets, are used. The shorthand is:

<pre><code>* &lt;CodeableConcept&gt;.coding[{index}] = {CodeSystem}#{code} <i>"{display string}"</i></code></pre>

To set the first Coding in a CodeableConcept, FSH offers the following shortcut:

<pre><code>* &lt;CodeableConcept&gt; = {CodeSystem}#{code} <i>"{display string}"</i></code></pre>

To set the top-level text of a CodeableConcept, the FSH expression is:

```
* <CodeableConcept>.text = {string}
```

**Examples:**

* Set the first Coding in Condition.code (a CodeableConcept type):

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
    
* Add a second value to the array of Codings:

  ```
  * code.coding[1] = ICD10#C80.1 "Malignant (primary) neoplasm, unspecified"
  ```
    
* Set the top-level text of Condition.code:

  ```
  * code.text = "Diagnosis of malignant neoplasm left breast."
  ```
    
##### Quantities

FSH provides a shorthand that allows quantities with units of measure to be specified simultaneously, provided the units of measure are [Unified Code for Units of Measure](http://unitsofmeasure.org/) (UCUM) codes. The syntax is:

```
* <Quantity> = {decimal or integer} '{UCUM unit}'
```

This syntax is borrowed from the [Clinical Quality Language](https://cql.hl7.org) (CQL).

The value and units can also be set independently. To set the value of quantity value, the quantity `value` property can be set directly:

```
* <Quantity>.value = {decimal or integer}
```

To set the units of measure independently, a Quantity can be bound to a value set or assigned a coded value. The syntax is:

<pre><code>* &lt;Quantity&gt; = {CodeSystem}#{code} <i>"{display string}"</i></code></pre>

Although it appears the quantity itself is being set to a coded value, this expression sets the units of measure. It is a result of FHIR's definition of the Quantity data type.

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

* The path to the text sub-property of Observation.method:

  ```
  method.text
  ```

#### Array Property Paths

If an element allows more than one value (e.g., `0..*`), then it must be possible to address each individual value. FSH denotes this with square brackets (`[` `]`) containing the 0-based index of the item (e.g., first item is `[0]`, second item is `[1]`, etc.).

If the index is omitted, the first element of the array (`[0]`) is assumed. 

**Examples:**

* Path to a patient's second given name in the first name field:

  ```
  name[0].given[1]
  ```

* Equivalent path expression, since the zero index is assumed when omitted:

  ```
  name.given[1]
  ```

#### Reference Paths

Elements can offer a choice of reference types. To address a specific resource or profile among the choices, follow the path with square brackets (`[ ]`) containing the target type (or the profile's `name`, `id`, or `url`).

**Example:**

* Given an element named `performer` with an inherited choice type of Reference(Organization or Practitioner), the path to the Practitioner:

  ```
  performer[Practitioner]
  ```

#### Data Type Choice [x] Paths

Addressing a type from a choice of types replaces the `[x]` in the property name with the type name (while also capitalizing the first letter). This follows the approach used in FHIR JSON and XML serialization.

**Example:**

* The path to the string data type of Observation.value[x]:

  ```
  valueString
  ```

* The path to the Quantity within the SystolicBP component of the [Blood Pressure profile](https://www.hl7.org/fhir/bp.html):

  ```
  component[SystolicBP].valueQuantity
  ```

#### Profiled Type Choice Paths

In some cases, a data type may be constrained to a set of possible profiles. To address a specific profile on that type, follow the path with square brackets (`[ ]`) containing the profile's `name`, `id`, or `url`.

**Example:**

* After constraining Patient.contact.address to be either a USAddress or a CanadianAddress (assuming these are profiles on Address), the paths to the respective `state` elements in the first contact:

  ```
  contact[0].address[USAddress].state

  contact[0].address[CanadianAddress].state
  ```

#### Extension Paths

Extension arrays are found at the root level of every resource, nested inside every element, and recursively inside each extension. Extensions are elements in these arrays. When an extension is added to an extension array, a name (technically, a slice name) is assigned. Extensions can be identified by that slice name, or the extension's URL.

The path to an extension is constructed by combining the path to the extension array with a reference to the extension in square brackets:

```
<Extension array>[{extension slice name or URL}]
```

For locally-defined extensions, using the slice name is the simplest choice. For externally-defined extensions, the canonical URL can be easier to find than the slice name.

> **Note:** The same path construction applies to `modifierExtension` arrays; simply replace `extension` with `modifierExtension`.

<!-- However, extensions being very common in FHIR, FSH supports a compact syntax for paths that involve extensions. The compact syntax drops `extension[ ]` or `modifierExtension[ ]` (similar to the way the `[0]` index can be dropped). The only time this is not allowed is when dropping these terms creates a naming conflict.-->

**Examples:**

* Path to the value of the birthsex extension in US Core Patient, whose local name is `birthsex`:

  ```
  extension[birthsex].valueCode
  ```

* Path to an extension on the telecom element of US Core Patient, assuming the extension is given the local slice name `directMailAddress`:

  ```
  telecom.extension[directMailAddress]
  ```

* Same as the previous example, but using the canonical URL for the direct mail extension:

  ```
  telecom.extension[http://hl7.org/fhir/us/core/StructureDefinition/us-core-direct]
  ```

* Path to the Coding data type of the value[x] in the nested extension `ombCategory` under the ethnicity extension in US Core, using the slice names of the extensions:

  ```
  extension[ethnicity].extension[ombCategory].valueCoding
  ```

* Path to the Coding value in second element in the nested extension array named `detailed`, under USCoreEthnicity extension:

  ```
  extension[ethnicity].extension[detailed][1].valueCoding
  ```

#### Sliced Array Paths

FHIR allows lists to be compartmentalized into sublists called "slices".  To address a specific slice, follow the path with square brackets (`[ ]`) containing the slice name. Since slices are most often unordered, slice names rather than array indices should be used. Note that slice names (like other [FSH names](#names)) cannot be purely numerical, so slice names cannot be confused with indices.

To access a slice of a slice (a resliced array), follow the first pair of brackets with a second pair containing the resliced slice name.

**Examples:**

* In an Observation profile representing Apgar score, with slices for respiratory score, appearance score, and others, path to the coded value of RespirationScore:

  ```
  component[respiratoryScore].code
  ```

* If the respiratoryScore is resliced to represent the one and five minute Apgar scores, the paths to the codes representing the one minute and five minute scores are:

  ```
  component[respiratoryScore][oneMinuteScore].code

  component[respiratoryScore][fiveMinuteScore].code
  ```

#### StructureDefinition Escape Paths

FSH uses the caret (`^`) syntax to provide direct access to elements of an SD. The caret syntax should be reserved for situations not addressed through [FSH Keywords](#defining-items) or IG configuration files (i.e., elements other than name, id, title, description, url, publisher, fhirVersion, etc.). Examples of metadata elements in SDs that require the caret syntax include experimental, useContext, and abstract. The caret syntax also provides a simple way to set metadata attributes in the ElementDefinitions that comprise the snapshot and differential tables (e.g., short, slicing discriminator and rules, meaningWhenMissing, etc.).

> **Note:** Caret syntax is only applicable to FSH items that have corresponding StructureDefintions, specifically, profiles and stand-alone extensions.

For a path to an element of an SD, excluding the differential and snapshot, use the following syntax inside a Profile or Extension:

```
^<element of SD>
```

For a path to an attribute of an ElementDefinition within an SD, corresponding to the elements in the profiled resource, use this syntax:

```
<element of Profile> ^<element of corresponding ElementDefinition>
```

**Note:** There is a required space before the ^ character.

A special case of the ElementDefinition path is setting properties of the first element of the differential (i.e., StructureDefinition.differential.element[0]). This element always refers to the profile or standalone extension itself. Since this element does not correspond to an named element appearing in an instance, we use the dot or full stop (`.`) to represent it. (The dot symbol is often used to represent "current context" in other languages.) It is important to note that the "self" elements are not the elements of an SD directly, but elements of the first ElementDefinition contained in the SD. The syntax is:

```
. ^<element of ElementDefinition[0]>
```

**Examples:**

* In a profile definition, path to the 'experimental' attribute in the SD for that profile:

  ```
  ^experimental
  ```

* In a profile of Patient, the path to binding.description in the ElementDefinition corresponding to communication.language:

  ```
  communication.language ^binding.description
  ```

* The path to the short description of an extension (defined in the first ElementDefinition):

  ```
  . ^short
  ```

***

### Rules for Profiles, Extensions, and Instances

> * For rules applicable to code systems, see [Defining Code Systems](#defining-code-systems)
> * For rules applicable to mappings, see [Defining Mappings](#defining-mappings).
> * For rules applicable to value sets, see [Defining Value Sets](#defining-value-sets).

Rules are the mechanism for setting cardinality, applying must-support flags, defining extensions, creating slices, and more. All rules begin with an asterisk:

```
* {rule statement}
```

The following table is a summary of the rules applicable to profiles, extensions, and instances:

| Rule Type | Syntax |
| --- | --- |
| Assignment |`* <element> = {value}` <br/> `* <element> = {value} (exactly)` |
| Binding |`* <coded> from {ValueSet}` <br/> `* <coded> from {ValueSet} ({strength})`|
| Cardinality | `* <element> {min}..{max}` <br/>`* <element> {min}..` <br/>`* <element> ..{max}` |
| Contains (inline extensions)| <code>* &lt;Extension array&gt; contains {slice name} {card} <i>{flags}</i> </code>  <br/> <code>* &lt;Extension array&gt; contains {slice1 name} {card1} <i>{flags1}</i> and {slice2 name} {card2} <i>{flags2}</i> ...</code> |
| Contains (standalone extensions) | <code>* &lt;Extension array&gt; contains {Extension} named {slice name} {card} <i>{flags}</i></code> <br/>  <code> * &lt;Extension array&gt; contains {Extension1} named {slice1 name} {card1} <i>{flags1}</i> and {Extension2} named {slice2 name} {card2} <i>{flags2}</i> ...</code>
| Contains (slicing) | <code>* &lt;array&gt; contains {slice name} {card} <i>{flags}</i></code> <br/> <code>* &lt;array&gt; contains {slice1 name} {card1} <i>{flags1}</i> and {slice2 name} {card2} <i>{flags2}</i> ...</code>|
| Flag | `* <element> {flag}` <br/> `* <element> {flag1} {flag2} ...` <br/> `* <element1> and <element2> and <element3> ... {flag1} {flag2} ...` |
| Insert | `* insert {RuleSet name}` |
| Obeys | `* obeys {invariant id}` <br/> `* obeys {invariant1 id} and {invariant2 id} ...` <br/> `* <element> obeys {invariant id}` <br/> `* <element> obeys {invariant1 id} and {invariant2 id} ...` |
| Type | `* <element> only {type}` <br/> `* <element> only {type1} or {type2} or {type3} or ...` <br/> `* <element> only Reference({type})` <br/> `* <element> only Reference({type1} or {type2} or {type3} or ...)`|
{: .grid }

**Notes:**

* The Assignment rule is only type of rule applicable to instances
* Any type of rule (including ValueSet, CodeSystem, and Mapping rules) can be included in a rule set

In the following, we explain each of these rule types in detail.

#### Assignment Rules

Assignment rules follow this syntax:

```
* <element> = {value}
```

The left side of this expression follows the [FSH path grammar](#paths). The data type on the right side must align with the data type of the final element in the path, and may be a complex data type (such as an address).

Assignment rules have two different interpretations, depending on context:

* In an instance, an assignment rule fixes the value of the target element.
* In a profile or an extension, an assignment rule establishes a pattern that must be satisfied by instances conforming to that profile or extension. The pattern is considered "open" in the sense that the element in question may have additional content in addition to the prescribed value, such as additional codes in a CodeableConcept or an extension.

If conformance to a profile requires a precise match to the specified value (which is rare), then the following syntax can be used:

```
* <element> = {value} (exactly)
```

Adding `(exactly)` indicates that conformance to the profile requires a precise match to the specified values. No additional values or extensions are allowed. In general, using `(exactly)` is not the best option for interoperability because it creates very tight (potentially unnecessary) conformance criteria. FSH offers this option primarily because exact value matching is used in some current IGs and profiles.

> **Note:** The `(exactly)` modifier does not apply to instances.

**Examples:**

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
  Instance: EveAnyperson
  InstanceOf: Patient
  Usage: #example
  * name.given = "Eve"
  * name.family = "Anyperson"
  
  // Use this instance in a profile
  ...
  * subject = Reference(EveAnyperson)
  ```

* Assignment of an inline instance to a Bundle:

  ```
  Instance: AdamEveryperson
  InstanceOf: Patient
  Usage: #inline
  * name.given = "Adam"
  * name.family = "Everyperson"

  // Create an example Bundle using this instance
  Instance: AdamBundle
  InstanceOf: Bundle
  Usage: #example
  * type = #collection
  * entry.resource = AdamEveryperson
  ```

* Contrast the behavior of assignment statements in profiles and instances:

  Assuming `code` is type CodeableConcept and LNC is an alias for http://loinc.org, consider the following three assignment statements:

  ```
  * code = LNC#69548-6

  * code = LNC#69548-6 "Genetic variant assessment"

  * code = LNC#69548-6 (exactly)
  ```

  In the context of a profile:

  * The first statement signals that to pass validation, an instance must have the system http://loinc.org and the code 69548-6 (appearing in coding.code).
  * The second statement says that an instance must have the system http://loinc.org, the code 69548-6, and the display text "Genetic variant assessment" to pass validation.
  * The third statement says that an instance must have the system http://loinc.org and the code 69548-6, and must not have a display text, alternate codes, or extensions.

  In the context of an instance:

  * The first statement fixes the system and code, leaving the display empty
  * The second statement fixes the system, code, and display text
  * The third statement has the same meaning as the first statement
  
  In a profiling content, typically only the system and code are important conformance criteria, so the first statement is preferred. In the context of an instance, the display text conveys additional information useful to the information receiver, so the second statement would be preferred.

#### Binding Rules

Binding is the process of associating a coded element with a set of possible values. The syntax to bind a value set, or alter an inherited binding, uses the reserved word `from`:

```
* <coded> from {valueSet}   // defaults to required

* <coded> from {valueSet} ({strength})
```

The value set can be the name of a value set defined in the same FSH project or the defining URL of an external value set in the core FHIR spec or in an IG that has been declared an external dependency.

The strengths are the same as the [binding strengths defined in FHIR](https://www.hl7.org/fhir/valueset-binding-strength.html), namely: example, preferred, extensible, and required.

The following rules apply to binding in FSH:

* If no binding strength is specified, the binding is assumed to be required.
* When further constraining an existing binding, the binding strength can stay the same or be made tighter (e.g., replacing a preferred binding with extensible or required), but never loosened.
* Constraining may leave the binding strength the same and change the value set instead. However, certain changes permitted in FSH may violate [FHIR profiling principles](http://hl7.org/fhir/R4/profiling.html#binding-strength). In particular, FHIR will permit a required value set to be replaced by another required value set only if the codes in the new value set are a subset of the codes in the original value set. For extensible bindings, the new value set can contain codes not in the existing value set, but additional codes should not have the same meaning as existing codes in the base value set.

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
* <element> {min}..{max}

* <element> {min}..   // leave max as-is

* <element> ..{max}   // leave min as-is
```

As in FHIR, min and max are non-negative integers, and max can also be *, representing unbounded. It is valid to include both the min and max, even if one of them remains the same as in the original cardinality. In this case, FSH implementations should only generate constraints for the changed values.

Cardinalities must follow [rules of FHIR profiling](https://www.hl7.org/fhir/conformance-rules.html#cardinality), namely that the min and max cardinalities must stay within the constraints of the parent.

For convenience and compactness, cardinality rules can be combined with [flag rules](#flag-rules) via the following grammar:

```
* <element> {min}..{max} {flag}

* <element> {min}..{max} {flag1} {flag2} ...
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

#### Contains Rules for Extensions

Extensions are created by adding elements to built-in extension arrays. Extension arrays are found at the root level of every resource, nested inside every element, and recursively inside each extension. The structure of extensions is defined by FHIR (see [Extension element](https://www.hl7.org/fhir/extensibility.html#extension)). Profiling extensions is discussed in [Defining Extensions](#defining-extensions). The same instructions apply to 'modifierExtension' arrays.

Extensions are specified using the `contains` keyword. There are two types of extensions: standalone and inline:

* Standalone extensions have independent SDs, and can be reused. They can be defined internally (in the same FSH project) or externally in FHIR core or a external IG. External standalone extensions can be referred to by their canonical URLs or their ids. Internal standalone extensions can be referred to by their FSH names or ids.
* Inline extensions do not have separate SDs, and cannot be reused in other profiles. Inline extensions are typically used to specify sub-extensions in a complex (nested) extension. When defining an inline extension, it is typical to use additional rules (such as cardinality, data type and binding rules) to further define the extension.

The syntax to specify standalone extension(s) is:

<pre><code>* &lt;Extension array&gt; contains {Extension} named {slice name} {card} <i>{flags}</i>

* &lt;Extension array&gt; contains 
    {Extension1} named {slice1 name} {card1} <i>{flags1}</i> and 
    {Extension2} named {slice2 name} {card2} <i>{flags2}</i> and
    {Extension3} named {slice3 name} {card3} <i>{flags3}</i> ...
</code></pre>

The syntax to define inline extension(s) is:

<pre><code>* &lt;Extension array&gt; contains {slice name} {card} <i>{flags}</i>

* &lt;Extension array&gt; contains 
    {slice1 name} {card1} <i>{flags1}</i> and
    {slice2 name} {card2} <i>{flags2}</i> and
    {slice3 name} {card3} <i>{flags3}</i> ...</code></pre>

Note that the slice name and cardinality are required, and flags are optional.

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

* Add a standalone extension, defined in the same FSH project, to a bodySite attribute (second level extension):

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


#### Contains Rules for Slicing

Slicing is an advanced, but necessary, feature of FHIR. It is helpful to have a basic understanding of [slicing](http://hl7.org/fhir/R4/profiling.html#slicing) and [discriminators](http://hl7.org/fhir/R4/profiling.html#discriminator) before attempting slicing in FSH. 

In FSH, slicing is addressed in three steps: (1) identifying the slices, (2) defining each slice's contents, and (3) specifying the slicing logic.

##### Step 1. Identifying the Slices

The first step in slicing is populating the array that is to be sliced, using the `contains` keyword. The syntax is very similar to [`contains` rules for inline extensions](#contains-rules-for-extensions):

<pre><code>* &lt;array&gt; contains {slice name} {card} <i>{flags}</i>

* &lt;array&gt; contains 
    {slice1 name} {card1} <i>{flags1}</i> and 
    {slice2 name} {card2} <i>{flags2}</i> and
    {slice3 name} {card3} <i>{flags3}</i> ...
</code></pre>


In this pattern, `<array>` is a path to the element that is to be sliced (and to which the slicing rules will applied in step 3). The `{card}` declaration is required, and `{flags}` are optional.

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

<pre><code>* &lt;array[{slice name}]&gt; contains {reslice name} {card} <i>{flags}</i>

* &lt;array[{slice name}]&gt; contains 
    {reslice1 name} {card1} <i>{flags1}</i> and 
    {reslice2 name} {card2} <i>{flags2}</i> and
    {reslice3 name} {card3} <i>{flags3}</i> ...
</code></pre>

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
* <array>[{slice name}].<element> {constraint}
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

FHIR also defines I and NE flags, representing elements affected by constraints, and elements that cannot have extensions, respectively. These flags are not directly supported in flag syntax, since the I flag is determined by the presence of [invariants](#obeys-rules), and NE flags apply only to infrastructural elements in base resources. If needed, these flags can be set using [caret syntax](#structuredefinition-escape-paths).

The following syntax can be used to assigning flags:

```
* <element> {flag}

* <element> {flag1} {flag2} ...

* <element1> and <element2> and <element3> ... {flag}

* <element1> and <element2> and <element3> ... {flag1} {flag2} ...
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

#### Insert Rules

[Rule sets](#defining-rule-sets) are reusable groups of rules that are defined independently of other items. To use a rule set, an `insert` rule is used:

```
* insert {RuleSet name}
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

#### Obeys Rules

[Invariants](https://www.hl7.org/fhir/conformance-rules.html#constraints) are constraints that apply to one or more values in instances, expressed as [FHIRPath expressions](https://www.hl7.org/fhir/fhirpath.html). An invariant can apply to an instance as a whole or a single element. Multiple invariants can be applied to an instance as a whole or to a single element. The syntax for applying invariants in profiles is:

```
* obeys {Invariant id}

* obeys {Invariant1 id} and {Invariant2 id} ...

* <element> obeys {Invariant id}

* <element> obeys {Invariant1 id} and {Invariant2 id} ...
```

The first case applies the invariant to the profile as a whole. The second case applies the invariant to a single element. The third case applies multiple invariants to the profile as a whole, and the fourth case applies multiple invariants to a single element.

The referenced invariant and its properties must be declared somewhere within the same FSH project, using the `Invariant` keyword. See [Defining Invariants](#defining-invariants).

**Examples:**

* Assign invariant to US Core Implantable Device (invariant applies to profile as a whole):

  ```
  * obeys us-core-9
  ```

* Assign invariant to Patient.name in US Core Patient:

  ```
  * name obeys us-core-8
  ```


#### Type Rules

FSH rules can be used to restrict the data type of an element. The syntax to restrict the type is:

```
* <element> only {type}
```

```
* <element> only {type1} or {type2} or {type3}...
```

```
* <element> only Reference({type})
```

```
* <element> only Reference({type1} or {type2} or {type3} ...)
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
| `Usage` | Specifies how an instance is intended to be used in the IG | code |
| `XPath` | the xpath in an invariant | XPath string |
{: .grid }

> **Note:** Keywords are case-sensitive.

The following table shows the relationship between declaration keywords and additional keywords.

_R = required (must), S = should (optional but recommended), M = optional (may), blank = disallowed, x = Id is required but specified in the declaration_

| Declaration \ Keyword               | Id  | Description | Title | Parent | InstanceOf | Usage | Source | Target | Severity | XPath | Expression |
|-------------------------------------|-----|-------------|-------|--------|------------|-------|--------|--------|----------|-------|------------|
[Alias](#defining-aliases)            |     |             |       |        |            |       |        |        |          |       |            |
[Code System](#defining-code-systems) |  S  |     S       |   S   |        |            |       |        |        |          |       |            |
[Extension](#defining-extensions)     |  S  |     S       |   S   |   O    |            |       |        |        |          |       |            |
[Instance](#defining-instances)       |  x  |     S       |   S   |        |     R      |   O   |        |        |          |       |            |
[Invariant](#defining-invariants)     |  x  |     R       |       |        |            |       |        |        |    R     |    O  |    O       |
[Mapping](#defining-mappings)         |  x  |     S       |   S   |        |            |       |   R    |   R    |          |       |            |
[Profile](#defining-profiles)         |  O  |     S       |   S   |   R    |            |       |        |        |          |       |            |
[Rule Set](#defining-rule-sets)       |  x  |             |       |        |            |       |        |        |          |       |            |
[Value Set](#defining-value-sets)     |  O  |     S       |   S   |        |            |       |        |        |          |       |            |
{: .grid }


#### Defining Aliases

Aliases allow the user to replace a lengthy url or oid with a short string. Aliases are for readability only, and do not change the meaning of rules. Typical uses of aliases are to represent code systems and canonical URLs.

Alias definitions follow this syntax:

```
Alias: {Alias name} = {url or oid}
```

Several things to note about aliases:

* Aliases do not permit additional keywords or rules.
* Alias statements stand alone, and cannot be mixed into rule sets of other items.
* Aliases are global within a FSH project.

In contrast with other names in FSH (for profiles, extensions, etc.), alias names can optionally begin with a dollar sign ($). If you define an alias with a leading $, you are protected against misspellings. For example, if you choose the alias name `$RaceAndEthnicityCDC` and accidentally type `$RaceEthnicityCDC`, implementations can easily detect there is no alias by that name. However, if the alias is `RaceAndEthnicityCDC` and the misspelling is `RaceEthnicityCDC`, implementations do not know an alias is intended, and will look through FHIR Core and all external implementation guides for anything with that name or id, or in some contexts, assume it is a new item, with unpredictable results.

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

#### Defining Code Systems
It is sometimes necessary to define new codes inside an IG that are not drawn from an external code system (aka _local codes_). When defining local codes, you must define them in the context of a code system.

> **Note:** Defining local codes is not generally recommended, since those codes will not be part of recognized terminology systems. However, when existing vocabularies do not contain necessary codes, it may be necessary to define them -- at least temporarily -- as local codes.

Creating a code system uses the keywords `CodeSystem`, `Id`, `Title` and `Description`. Codes are then added, one per rule, using the following syntax:


```
* include #{code} {display string} {definition string}
```

Similar to [value sets](#defining-value-sets), the word `include` can be dropped for brevity, without changing the meaning:

```
* #{code} {display string} {definition string}
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

If `Usage` is unspecified, the default is `#example`.

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

#### Defining Invariants

Invariants are defined using the keywords `Invariant`, `Description`, `Expression`, `Severity`, and `XPath`. An invariant definition does not have any rules.

Invariants are incorporated into a profile via [obeys rules](#obeys-rules).

**Example:**

* Define an invariant found in US Core using FSH:

  ```
  Invariant:  us-core-8
  Description: "Patient.name.given or Patient.name.family or both SHALL be present"
  Expression: "family.exists() or given.exists()"
  Severity:   #error
  XPath:      "f:given or f:family"
  ```

#### Defining Mappings

[Mappings](https://www.hl7.org/fhir/mappings.html) are an optional part of an SD, intended to help implementers understand the SD in relation to other standards. While it is possible to define mappings using escape (caret) syntax, FSH provides a more concise approach. These mappings are informative and are not to be confused with the computable mappings provided by [FHIR Mapping Language](https://www.hl7.org/fhir/mapping-language.html) and the [StructureMap resource](https://www.hl7.org/fhir/structuremap.html).

To create a mapping, the keywords `Mapping`, `Source`, `Target` and `Id` are required and `Title` and `Description` are optional. Any number of [mapping rules](#mapping-rules) follow. The keywords are defined as follows:

| Keyword | Usage | SD element |
|-------|------------|--------------|
| Mapping | Appears first and provides a unique name for the mapping | n/a |
| Source | The name of the profile the mapping applies to | n/a |
| Target | The URL, URI, or OID for the specification being mapped to | mapping.uri |
| Id | An internal identifier for the target specification | mapping.identity |
| Title | A human-readable name for the target specification | mapping.name  |
| Description | Additional information such as version notes, issues, or scope limitations. | mapping.comment |

The mappings themselves are declared in rules with the following syntax:

```
* -> "{map}" "{comment}" {mime-type}
```

```
* <element> -> "{map}" "{comment}" {mime-type}
```

The first type of rule applies to mapping the profile as a whole to the target specification. The second type of rule maps a specific element to the target.

In these rules, the `"{comment}"` string and `{mime-type}` code are optional. The mime type code must conform to https://tools.ietf.org/html/bcp13 (FHIR value set https://www.hl7.org/fhir/valueset-mimetypes.html).

Note that the right-hand side of mapping rules are strings. This follows directly from the mapping structures in [StructureDefinition.mapping](http://www.hl7.org/fhir/structuredefinition.html) and [ElementDefinition.mapping](https://www.hl7.org/fhir/elementdefinition.html) in FHIR. FHIR avoids assumptions about path grammar in the target, even if the target is FHIR.

>**Note:** Unlike setting the mapping directly in the SD, mapping rules within a Mapping item do not include the name of the resource in the path on the left hand side.

**Examples:**

* Map the entire profile to a Patient item in another specification:

  ```
  * -> "Patient" "This profile maps to Patient in Argonaut"
  ```

* Map the identifier.value element from one IG to another:

  ```
  * identifier.value -> "Patient.identifier.value"
  ```
* Define a map between USCorePatient and Argonaut:
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


#### Defining Rule Sets

Rule sets provide the ability to define rules and apply them to a compatible target. The rules are copied from the rule set at compile time. Any item admitting rules can have one or more rule sets applied to them. The same rule set can be used in multiple places.

All types of rules can be used in rule sets.

Rule sets are defined by using the keyword `RuleSet`:

```
RuleSet: {RuleSetName}
* {rule1}
* {rule2}
// More rules
```

Once defined, the rule set is applied to an item by using an [insert rule](#insert-rules).

**Example:**

* Define a rule set for metadata to be used in multiple profiles:

  ```
  RuleSet: MyMetadata
  * ^status = #draft
  * ^experimental = true
  * ^publisher = "Elbonian Medical Society"
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
| All codes from a value set | `* include codes from valueset {ValueSet}` | `* include codes from valueset http://hl7.org/fhir/ValueSet/data-absent-reason`  <br/> or equivalently, <br/> `* codes from valueset http://hl7.org/fhir/ValueSet/data-absent-reason`|
| All codes from a code system | `* include codes from system {CodeSystem}` | `* include codes from system http://snomed.info/sct` <br/> or equivalently, <br/> `* codes from system http://snomed.info/sct`|
| Selected codes from a code system (filters are code system dependent) | `* include codes from system {CodeSystem} where {filter} and {filter} and ...` | `* include codes from system SCT where concept is-a #254837009` <br/> or equivalently, <br/> `* codes from system SCT where concept is-a #254837009`|
{: .grid }

See [below](#filters) for discussion of filters.

> **Note:** `{CodeSystem}` can be a FSH name, alias or URL.

Analogous rules can be used to leave out certain codes, with the word `exclude` replacing the word `include`:

| To exclude... | Syntax | Example |
|-------|---------|----------|
| A single code | `* exclude {Coding}` | `* exclude SCT#961000205106 "Wearing street clothes, no shoes"` |
| All codes from a value set | `* exclude codes from valueset {ValueSet}` | `* exclude codes from valueset http://hl7.org/fhir/ValueSet/data-absent-reason` |
| All codes from a code system | `* exclude codes from system {CodeSystem}` | `* exclude codes from system http://snomed.info/sct` |
| Selected codes from a code system (filters are code system dependent) | `* exclude codes from system {CodeSystem} where {filter}` | `* exclude codes from system SCT where concept is-a #254837009` |
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

### Appendix: Abbreviations

| Abbreviation | Description |
|-----|----|
| ANTLR4  | ANother Tool for Language Recognition, version 4
| CQL | Clinical Quality Language
| D  | Flag denoting draft status
| FHIR  | Fast Healthcare Interoperability Resources
| FSH   | FHIR Shorthand
| IG | Implementation Guide
| JSON   | JavaScript Object Notation
| LNC | Common FSH alias for LOINC
| LOINC | Logical Observation Identifiers Names and Codes
| NPI   | National Provider Identifier (US)
| N   |  Flag denoting normative element
| MS  | Flag denoting a Must Support element
|  OID   | Object Identifier
| SCT | Common FSH alias for SNOMED Clinical Terms
|  SD   | StructureDefinition
|  SU  | Flag denoting "include in summary"
|  TU  | Flag denoting trial use element
| UCUM  | Unified Code for Units of Measure
| URL    | Uniform Resource Locator
| XML   | Extensible Markup Language

### Appendix: Formal Grammar

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