This chapter contains the formal specification of the FHIR Shorthand (FSH) language. It is intended as a reference, not a tutorial.

### About this Guide
This chapter uses syntax expressions to illustrate the FSH language. While there is a formal grammar (see [Appendix](#appendix-formal-grammar)), most readers will find the syntax expressions more instructive.

Syntax expressions uses the following conventions:

| Style | Explanation | Example |
|:------------|:------|:---------|
| `Code` | Code fragments, such as commands, FSH statements, and syntax expressions  | `* status = #open` |
| `{curly braces}` | An item to be substituted in a syntax expression | `{display string}` |
| `<datatype>` | An element or path to an element with the given data type, to be substituted in the syntax expression | `<CodeableConcept>`
| _italics_ | An optional item in a syntax expression | <code><i>"{string}"</i></code> |
| ellipsis (...) | Indicates a pattern that can be repeated | <code>{flag1} {flag2} {flag3}&nbsp;...</code>
| **bold** | A directory path or file name | **example-1.fsh** |
{: .grid }


**Examples:**

* A FSH rule to assign the value of a Quantity:

  ```
  * <Quantity> = {decimal or integer} '{UCUM unit}'
  ```

  A FSH statement following this pattern would be written as:

  * An asterisk, followed by
  * Any element of data type Quantity or a path to an element with data type Quantity, followed by
  * An equals sign, followed by
  * Any decimal or integer number, followed by
  * Any Unified Code for Units of Measure (UCUM) unit, enclosed in single quotes.

* A rule to constrain an element to a certain data type or types:

  ```
  * <element> only {datatype1} or {datatype2} or {datatype3}...
  ```

  A FSH statement following this pattern would be written as:

  * An asterisk, followed by
  * Any element or a path to any element, followed by
  * The word `only`, followed by 
  * A list including at least one data type, separated by the word `or`

Here are some examples of curly braces and angle brackets used in this Guide:

| Symbol | Meaning | Examples |
|--------|--------|---------|
| `{Coding}`  | Instance of a Coding | `SCT#961000205106 "Wearing street clothes, no shoes"` |
| `<CodeableConcept>`  | An element or path to an element whose data type is CodeableConcept |  `category`  |
|  `<coded>` | An element or path to an element that has one of the coded data types (`code`, `Coding`, `CodeableConcept` or `Quantity`) | `status` |
| `{flag}`  | One of the valid [FSH flags](#flag-rules) |  `MS` |
| `{flags}` | A sequence of 1 or more flags, separated by whitespace | `MS SU TU` |
| `{card}` | A [cardinality expression](#cardinality-rules) |  `0..1` |
| `<element>` | Any element or path to any element | `method.type` |
| `<Extension>` | An element or path to an element with data type `Extension` | `extension` <br/> `modifierExtension` <br/> `bodySite.extension` |
| `{Extension name|id|url}` |  The name, id, or canonical URL (or alias) of an Extension | `duration` <br/> `allergyintolerance-duration` <br/> `http://hl7.org/fhir/StructureDefinition/allergyintolerance-duration` |
| `{rule}` | Any FSH rule | `* category 1..1 MS`
| `{RuleSet name}` | The name of a RuleSet | `MyMetadata`
| `{Invariant id}` | The id of an Invariant | `us-core-8`
| `{datatype}` | Any primitive or complex data type | `decimal` <br/> `ContactPoint` |
| `{ValueSet name|id|url}` | The name, id, or canonical URL (or alias) of a ValueSet | `http://hl7.org/fhir/ValueSet/address-type` |
| `{ResourceType name|id|url}` | The name, id, or canonical URL (or alias) for any type of Resource or Profile | `Condition` <br/>  `http://hl7.org/fhir/us/core/StructureDefinition/us-core-location` |
{: .grid }

### FSH Foundations

#### Projects

The main organizing construct is a FSH project, sometimes called a "FSH Tank". Each project must have an associated canonical URL, used for constructing canonical URLs for items created in the project. It is up to implementations to decide how this association is made. Typically, one FSH project equates to one FHIR IG.

#### Files

Content in one FSH project may be contained in one or more FSH files (storage of FSH in a database is also possible). If stored in files, the files must use the **.fsh** extension. It is up to implementations to define the association between FSH files and FSH projects.

The items defined by FSH are: Aliases, Profiles, Extensions, Instances, Value Sets, Code Systems, Mappings, Rule Sets, and Invariants. How items are divided among files is not meaningful in FSH, and items from all files in one project can be considered pooled together for the purposes of FSH.

Items can appear in any order within **.fsh** files, and can be moved around within a file or to other **.fsh** files in the same project without affecting the interpretation of the content.

#### Dependency on FHIR Version

Each FSH project must declare the version of FHIR it depends upon. The form of this declaration is outside the scope of the FSH specification, and should be managed by implementations. The FSH specification is not explicitly FHIR-version dependent, but implementations may support particular version(s) of FHIR.

The FSH language specification has been designed around FHIR R4. Compatibility with previous versions has not been evaluated. FSH depends primarily on normative parts of the FHIR R4 specification (in particular, StructureDefinition and primitive data types). It is conceivable that future changes in FHIR could impact the FSH language specification, for example, if FHIR introduces new data types.

#### Dependency on other IGs

Dependencies between a FSH project and other IGs must be declared. The form of this declaration is outside the scope of the FSH language and should be managed by implementations. In this Guide, these are referred to as "external" IGs.

#### Version Numbering

The FSH specification, like other FHIR Implementation Guides (IGs), expresses versions in terms of three integers, x.y.z, indicating the sequence of releases. Release 2 is later than release 1 if x2 > x1 or (x2 = x1 and y2 > y1), or (x2 = x1 and y2 = y1 and z2 > z1). Implementations should indicate what version or versions of the FSH specification they implement.

Like other HL7 FHIR IGs, the version numbering of the FSH specification does not entirely follow the [semantic versioning convention](https://semver.org). Consistent with semantic versioning, an increment of z indicates a patch release containing minor updates and bug fixes, while maintaining backwards compatibility with the previous version. An increment in y indicates new or modified features, and potentially, non-backward-compatible changes (i.e., a minor or major release in semantic versioning). By HL7 convention, the major version number x typically does not increment until the release of a new balloted version.

### FSH Language Basics

#### Formal Grammar

[FSH has a formal grammar](#appendix-formal-grammar) defined in [ANTLR4](https://www.antlr.org/). The grammar is looser than the language specification since many things, such as data type agreement, are not enforced by the grammar. If there is discrepancy between the grammar and the FSH language description, the language description is considered correct until the discrepancy is clarified and addressed.

#### Reserved Words

FSH has a number of reserved words, symbols, and patterns. Reserved words and symbols with special meaning in FSH are: `contains`, `named`, `and`, `only`, `or`, `obeys`, `true`, `false`, `include`, `exclude`, `codes`, `where`, `valueset`, `system`, `from`, `insert`, `!?`, `MS`, `SU`, `N`, `TU`, `D`, `=`, `*`, `:`, `->`, `.`,`[`, `]`.

The following words are reserved only if followed by a colon (intervening white spaces allowed): `Alias`, `CodeSystem`, `Extension`, `Instance`, `Invariant`, `Mapping`, `Profile`, `RuleSet`, `ValueSet`, `Description`, `Expression`, `Id`, `InstanceOf`, `Parent`, `Severity`, `Source`, `Target`, `Title`, `Usage`, `XPath`.

The following words are reserved only when enclosed in parentheses (intervening white spaces allowed): `example`, `preferred`, `extensible`, `required`, `exactly`.

#### Primitives

The primitive data types and value formats in FSH are identical to the [primitive types and value formats in FHIR](https://www.hl7.org/fhir/R4/datatypes.html#primitive). References in this document to `code`, `id`, `oid`, etc. refer to the primitive datatypes defined in FHIR.

FSH strings support the escape sequences that FHIR already defines as valid in its [regex for strings](https://www.hl7.org/fhir/R4/datatypes.html#primitive): \r, \n, and \t.

#### Names

FSH item names follow [FHIR naming guidance](http://hl7.org/fhir/R4/structuredefinition-definitions.html#StructureDefinition.name). Names must be between 1 and 255 characters, begin with an uppercase letter, and contain only letters, numbers, and "_". 

By convention, item names should use [PascalCase (also known as UpperCamelCase)](https://wiki.c2.com/?UpperCamelCase). [Slice names](#contains-rules-for-slicing) and [local slice names for extensions](#contains-rules-for-extensions) should use [lower camelCase](https://wiki.c2.com/?CamelCase). These conventions are consistent with FHIR naming conventions.

Alias names may begin with `$`. Choosing alias names beginning with `$` allows for additional error checking ([see Defining Aliases](#defining-aliases) for details).

#### Identifiers

Items in FSH may have an identifier (id), typically specified using the [`Id` keyword](#defining-items). Each id must be unique within the scope of its item type in the FSH project. For example, two Profiles with the same id cannot coexist, but it is possible to have a Profile and a ValueSet with the same id in the same FSH Project. However, to minimize potential confusion, it is recommended to use a unique id for every item in a FSH project.

If no id is provided by a FSH author, implementations may create an id. It is recommended that the id be based on the item's name, with _ replaced by -, and the overall length truncated to 64 characters (per the requirements of the [FHIR id datatype](https://www.hl7.org/fhir/R4/datatypes.html#primitive)).

#### Referring to Other Items

FSH items within the same project can be referred to by their names or ids. Preferably, references should align with the name or id given in the [declaration statement](#defining-items).

External FHIR artifacts in FHIR core and external IGs can be referred to by name, id, or canonical URL. Referring to core FHIR resources by name, e.g., `Patient` or `Observation`, is recommended. For other external items, the use of canonical URLs is recommended, since this approach minimizes the chance of name collisions. In cases where an external name or id clashes with an internal name or id, then the internal entity takes precedence, and external entity must be referred to by its canonical URL.

#### Reference and Canonical Data Types

FHIR resources contain [two types of references](https://www.hl7.org/fhir/R4/references.html) to other resources:

* Resource references
* Canonical references

FSH represents Resource references using the syntax `Reference({Resource  name|id|url})`. Where the type is Reference, `Reference()` is required.

Canonical references refer to the standard URL associated with a type of FHIR resource. For elements that require a canonical reference, FSH will accept a URL, or an expression in the form `Canonical({name|id})` where `name` and `id` refer to items defined in the same FSH project. Implementations are to interpret `Canonical()` as an instruction to construct the canonical URL for the referenced item using the FSH project's canonical URL. `Canonical()` therefore enables a user to change the project’s canonical URL in a single place with no changes to FSH definitions.

#### Whitespace

Repeated whitespace is not meaningful within FSH files (except within string literals). New lines are considered whitespace. Whitespace insensitivity can be used to improve readability. For example:

```
* component contains appearanceScore 0..3 and pulseScore 0..3 and grimaceScore 0..3 and activityScore 0..3 and respirationScore 0..3
```

can be reformatted as:

```
* component contains
    appearanceScore 0..3 and
    pulseScore 0..3 and
    grimaceScore 0..3 and
    activityScore 0..3 and
    respirationScore 0..3
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

While line breaks are supported using normal strings, FSH also supports different processing for strings demarcated with three double quotation marks `"""`. This feature can help authors to maintain consistent indentation in the FSH file.

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

##### Representing the `code` Data Type

Codes are denoted with `#` sign. The FSH syntax is:

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

##### Representing the `Coding` Data Type

FSH represents a Coding in the following ways:

<pre><code>{CodeSystem name|id|url}#{code} <i>"{display string}"</i>

{CodeSystem name|id|url}|{version string}#{code} <i>"{display string}"</i></code></pre>


As [indicated by italics](#about-this-guide), the `"{display string}"` is optional. The `CodeSystem` represents the controlled terminology that the code is taken from. The bar syntax for the version of the code system is the same approach used in the `canonical` data type in FHIR. An alternative to the bar syntax is to set the `version` element of Coding directly (see examples). To set the less-common properties of a Coding, [assignment rules](#assignment-rules) can be used.

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
  
##### Representing the `CodeableConcept` Data Type

A CodeableConcept consists of an array of Codings. To populate the array, array indices, denoted by brackets, are used. The shorthand is:

<pre><code>* &lt;CodeableConcept&gt;.coding[{index}] = {CodeSystem name|id|url}#{code} <i>"{display string}"</i></code></pre>

To set the first Coding in a CodeableConcept, FSH offers the following shortcut:

<pre><code>* &lt;CodeableConcept&gt; = {CodeSystem name|id|url}#{code} <i>"{display string}"</i></code></pre>

To set the top-level text of a CodeableConcept, the FSH expression is:

```
* <CodeableConcept>.text = "{string}"
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
    
##### Representing `Quantity` Data Type

FSH provides a shorthand that allows quantities with units of measure to be specified simultaneously, provided the units of measure are [Unified Code for Units of Measure](http://unitsofmeasure.org/) (UCUM) codes. The syntax is:

```
* <Quantity> = {decimal} '{UCUM unit}'
```

This syntax is borrowed from the [Clinical Quality Language](https://cql.hl7.org/02-authorsguide.html#quantities).

The value and units can also be set independently. To set the value of quantity value, the quantity `value` property can be set directly:

```
* <Quantity>.value = {decimal}
```

To set the units of measure independently of the value, a Quantity can be bound to a value set or assigned a coded value. The syntax is:

<pre><code>* &lt;Quantity&gt; = {CodeSystem name|id|url}#{code} <i>"{display string}"</i></code></pre>

The `CodeSystem` corresponds to Quantity.system, `code` to Quantity.code, and `display string` to Quantity.unit.

> **Note:** Although this example appears to set the Quantity itself to a coded value, this expression does in fact set the units of measure. This is a consequence of FHIR's definition of Quantity *as* a coded data type, rather than *having* a coded data type to represent the Quantity's units of measure.

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

### FSH Paths

FSH path grammar allows you to refer to any element of a profile, extension, or instance, regardless of nesting. Here are examples of things paths can refer to:

* Top-level elements such as the `code` element in Observation
* Nested elements, such as the `method.text` element in Observation
* Elements in a list or array by index
* Individual data types of choice elements, such as `onsetAge` in onset[x]
* Individual items within a multiple choice reference, such as Observation in `Reference(Observation or Condition)`
* Individual slices within a sliced array, such as the `systolicBP` component within blood pressure
* Metadata elements in an SD, like `active` and `experimental`
* Properties of ElementDefinitions nested within an SD, such as the `maxLength` property of string elements

In the following, the various types of path references are discussed.

#### Top-Level Paths

The path to a top-level element is denoted by the element's name. Because paths are used within the context of a FSH definition or instance, the path does not include the known context. For example, when defining a profile of Observation, the path to Observation.code is denoted as `code`.

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

Elements can offer a choice of reference types. To address a specific resource or profile among the choices, follow the path with square brackets (`[ ]`) containing the target type (represented by a `name`, `id`, or `url`).

**Example:**

* Path to the Reference(Practitioner) option of [DiagnosticReport.performer](https://www.hl7.org/fhir/R4/diagnosticreport.html), whose acceptable data types are Reference(Practitioner), Reference(PractitionerRole), Reference(Organization) or Reference(CareTeam):

  ```
  performer[Practitioner]
  ```

* Path to the Reference(US Core Organization) option of the `performer` element in [US Core DiagnosticReport Lab](http://hl7.org/fhir/us/core/StructureDefinition-us-core-diagnosticreport-lab.html), using the canonical URL:

  ```
  performer[http://hl7.org/fhir/us/core/StructureDefinition/us-core-organization]
  ```

* The same path, using the id of the US Core Organization profile instead of its canonical URL:

  ```
  performer[us-core-organization]
  ```

#### Data Type Choice [x] Paths

FHIR represents a choice of data types using `foo[x]` notation. To address a single data type, replace the `[x]` with the data type name (also capitalizing the first letter). To illustrate, Condition.onset[x], with choices dateTime, Age, Period, Range or string would have paths onsetDateTime, onsetAge, onsetPeriod, etc. This follows [the approach used in FHIR](http://hl7.org/fhir/R4/formats.html#choice).

> **Note:** foo[x] choices are NOT addressed as foo[boolean], foo[Quantity], etc.

**Example:**

* The path to the string data type of Observation.value[x]:

  ```
  valueString
  ```

* The path to the dateTime data type within Condition.onset[x]:

  ```
  onsetDateTime
  ```

#### Profiled Type Choice Paths

In some cases, a data type may be constrained to a set of possible profiles. To address a specific profile of that type, follow the path with square brackets (`[ ]`) containing the profile's `name`, `id`, or `url`.

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
<Extension>[{extension slice name or URL}]
```

For locally-defined extensions, using the slice name is the simplest choice. For externally-defined extensions, the canonical URL can be easier to find than the slice name.

> **Note:** The same path construction applies to `modifierExtension` arrays; simply replace `extension` with `modifierExtension`.

<!-- However, extensions being very common in FHIR, FSH supports a compact syntax for paths that involve extensions. The compact syntax drops `extension[ ]` or `modifierExtension[ ]` (similar to the way the `[0]` index can be dropped). The only time this is not allowed is when dropping these terms creates a naming conflict.-->

**Examples:**

* Path to the value of the birthsex extension in US Core Patient, whose local name is `birthsex`:

  ```
  extension[birthsex].valueCode
  ```

* Path to an extension on the telecom element of Patient, assuming the extension has been given the local slice name `directMailAddress`:

  ```
  telecom.extension[directMailAddress]
  ```

* Same as the previous example, but using the canonical URL for the direct mail extension defined in US Core:

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

* Path to the coded value of the respirationScore component within an Observation profile representing an Apgar test:

  ```
  component[respirationScore].code
  ```

* Paths to the codes representing the one minute and five minute respiration scores, assuming the Apgar respiration component has been resliced:

  ```
  component[respirationScore][oneMinuteScore].code

  component[respirationScore][fiveMinuteScore].code
  ```

#### Caret Paths

FSH uses the caret (`^`) symbol to access to elements of definitional item corresponding to the current context. Caret paths can be used in the following FSH items: Profile, Extension, ValueSet, and CodeSystem. Caret syntax should be reserved for situations not addressed through [FSH Keywords](#defining-items) or external configuration files. Examples of metadata elements that might require the caret syntax include `experimental`, `useContext`, and `abstract` in StructureDefinitions, and `purpose` in ValueSet. The caret syntax also provides a simple way to set metadata attributes in the ElementDefinitions that comprise the snapshot and differential tables (e.g., `short`, `meaningWhenMissing`, [slicing discriminator properties](#step-3-specifying-the-slicing-logic), etc.).

For a path to an element of an SD, excluding the differential and snapshot, use the following syntax inside a Profile or Extension:

```
^<element of SD>
```

For a path to an element of an ElementDefinition within an SD, use this syntax:

```
<element in Profile> ^<element of corresponding ElementDefinition>
```

**Note:** There is a required space before the ^ character.

A special case of the ElementDefinition path is setting properties of the first element of the differential (i.e., StructureDefinition.differential.element[0]). This element always refers to the profile or standalone extension itself. Since this element does not correspond to a named element appearing in an instance, we use the dot or full stop (`.`) to represent it. (The dot symbol is often used to represent "current context" in other languages.) It is important to note that the "self" elements are not the elements of an SD directly, but elements of the first ElementDefinition contained in the SD. The syntax is:

```
. ^<element of ElementDefinition[0]>
```

**Examples:**

* In a profile definition, path to the corresponding StructureDefinition.experimental attribute:

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
| Binding |`* <coded> from {ValueSet name|id|url}` <br/> `* <coded> from {ValueSet name|id|url} ({strength})`|
| Cardinality | `* <element> {min}..{max}` <br/>`* <element> {min}..` <br/>`* <element> ..{max}` |
| Contains (for inline extensions)| <code>* &lt;Extension&gt; contains {name} {card} <i>{flags}</i> </code>  <br/> <code>* &lt;Extension&gt; contains {name1} {card1} <i>{flags1}</i> and {name2} {card2} <i>{flags2}</i> ...</code> |
| Contains (for standalone extensions) | <code>* &lt;Extension&gt; contains {Extension name|id|url} named {name} {card} <i>{flags}</i></code> <br/>  <code> * &lt;Extension&gt; contains {Extension1 name|id|url} named {name1} {card1} <i>{flags1}</i> and {Extension2 name|id|url} named {name2} {card2} <i>{flags2}</i> ...</code>
| Contains (for slicing) | <code>* &lt;array&gt; contains {name} {card} <i>{flags}</i></code> <br/> <code>* &lt;array&gt; contains {name1} {card1} <i>{flags1}</i> and {name2} {card2} <i>{flags2}</i> ...</code>|
| Flag | `* <element> {flag}` <br/> `* <element> {flag1} {flag2} ...` <br/> `* <element1> and <element2> and <element3> ... {flag1} {flag2} ...` |
| Insert | `* insert {RuleSet name}` |
| Obeys | `* obeys {Invariant id}` <br/> `* obeys {invariant1 id} and {invariant2 id} ...` <br/> `* <element> obeys {Invariant id}` <br/> `* <element> obeys {invariant1 id} and {invariant2 id} ...` |
| Type | `* <element> only {datatype}` <br/> `* <element> only {datatype1} or {datatype2} or {datatype3} ...` <br/> `* <element> only Reference({ResourceType name|id|url})` <br/> `* <element> only Reference({ResourceType1 name|id|url} or {ResourceType2 name|id|url} or {ResourceType3 name|id|url} ...)`|
{: .grid }

**Notes:**

* The Assignment rule is the only type of rule applicable to instances
* Any type of rule (including ValueSet, CodeSystem, and Mapping rules) can be included in a rule set

In the following, we explain each of these rule types in detail.

#### Assignment Rules

Assignment rules follow this syntax:

```
* <element> = {value}
```

The left side of this expression follows the [FSH path grammar](#fsh-paths). The data type on the right side must align with the data type of the final element in the path, and may be a complex data type (such as an address).

Assignment rules have two different interpretations, depending on context:

* In an instance, an assignment rule sets the value of the target element.
* In a profile or extension, an assignment rule establishes a pattern that must be satisfied by instances conforming to that profile or extension. The pattern is considered "open" in the sense that the element in question may have additional content in addition to the prescribed value, such as additional codes in a CodeableConcept or an extension.

If conformance to a profile requires a precise match to the specified value (which is rare), then the following syntax can be used:

```
* <element> = {value} (exactly)
```

Adding `(exactly)` indicates that conformance to the profile requires a precise match to the specified values. No additional values or extensions are allowed. In general, using `(exactly)` is not the best option for interoperability because it creates conformance criteria that could be too tight, risking the rejection of valid, useful data. FSH offers this option primarily because exact value matching is used in some current IGs and profiles.

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

* Assignment of a reference to an example of a Patient resource, EveAnyperson, to Observation.subject:

  ```
  * subject = Reference(EveAnyperson)
  ```

  where, for example:

  ```
  Instance: EveAnyperson
  InstanceOf: Patient
  Usage: #example
  * name.given = "Eve"
  * name.family = "Anyperson"
  ```

* Assignment of an inline instance, AdamEveryperson, to Bundle.entry.resource, whose data type is Resource (not Reference(Resource)):

  ```
  * entry.resource = AdamEveryperson
  ```

  where, for example:

  ```
  Instance: AdamEveryperson
  InstanceOf: Patient
  Usage: #inline
  * name.given = "Adam"
  * name.family = "Everyperson"
  ```


* Contrast the behavior of assignment statements in profiles and instances:

  Assuming the `code` element is type CodeableConcept and LNC is an alias for http://loinc.org, consider the following three assignment statements:

  ```
  * code = LNC#69548-6

  * code = LNC#69548-6 "Genetic variant assessment"

  * code = LNC#69548-6 (exactly)
  ```

  In the context of a profile:

  * The first statement signals that an instance must have the system http://loinc.org and the code 69548-6 to pass validation.
  * The second statement says that an instance must have the system http://loinc.org, the code 69548-6, *and* the display text "Genetic variant assessment" to pass validation.
  * The third statement says that an instance must have the system http://loinc.org and the code 69548-6, and *must not have* a display text, additional codes, or extensions.

  In the context of an instance:

  * The first statement sets the system and code, leaving the display empty.
  * The second statement sets the system, code, and display text.
  * The third statement has the same meaning as the first statement.
  
  In a profiling context, typically only the system and code are important conformance criteria, so the first statement is preferred. In the context of an instance, the display text conveys additional information useful to the information receiver, so the second statement would be preferred.

#### Binding Rules

Binding is the process of associating a coded element with a set of possible values. The syntaxes to bind a value set, or alter an inherited binding, use the reserved word `from`:

```
* <coded> from {ValueSet name|id|url} ({strength})

* <coded> from {ValueSet name|id|url}   // strength defaults to required
```

The value set can be the name of a value set defined in the same FSH project or the defining URL of an external value set in the core FHIR spec or in an IG that has been declared an external dependency.

The strengths are the same as the [binding strengths defined in FHIR](https://www.hl7.org/fhir/R4/valueset-binding-strength.html), namely: example, preferred, extensible, and required.

The following rules apply to binding in FSH:

* If no binding strength is specified, a required binding is assumed.
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

Cardinalities must follow [rules of FHIR profiling](https://www.hl7.org/fhir/R4/conformance-rules.html#cardinality), namely that the min and max cardinalities must stay within the constraints of the parent.

For convenience and compactness, cardinality rules can be combined with [flag rules](#flag-rules) via the following grammar:

```
* <element> {card} {flag}

* <element> {card} {flag1} {flag2} {flag3}...
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

Extensions are created by adding elements to built-in extension arrays. Extension arrays are found at the root level of every resource, nested inside every element, and recursively inside each extension. The structure of extensions is defined by FHIR (see [Extension element](https://www.hl7.org/fhir/R4/extensibility.html#extension)). Profiling extensions is discussed in [Defining Extensions](#defining-extensions).

Extensions are specified using the `contains` keyword. There are two types of extensions, standalone and inline:

* Standalone extensions have their own SDs, and can be reused. They can be defined internally (in the same FSH project), or externally in core FHIR or an external IG.
* Inline extensions do not have separate SDs, and cannot be reused in other profiles. Inline extensions are typically used to specify sub-extensions in a complex (nested) extension.

The syntaxes to specify standalone extension(s) are:

<pre><code>* &lt;Extension&gt; contains {Extension name|id|url} named {name} {card} <i>{flags}</i>

* &lt;Extension&gt; contains 
    {Extension1 name|id|url} named {name1} {card1} <i>{flags1}</i> and 
    {Extension2 name|id|url} named {name2} {card2} <i>{flags2}</i> and
    {Extension3 name|id|url} named {name3} {card3} <i>{flags3}</i> ...
</code></pre>

The syntaxes to define inline extension(s) are:

<pre><code>* &lt;Extension&gt; contains {name} {card} <i>{flags}</i>

* &lt;Extension&gt; contains 
    {name1} {card1} <i>{flags1}</i> and
    {name2} {card2} <i>{flags2}</i> and
    {name3} {card3} <i>{flags3}</i> ...</code></pre>

In these expressions, the names (`name`, `name1`, `name2`, etc.) are new names that the rule author creates. They should describe the extension in the context of the profile. These names are used to refer to that extension in later rules. By convention, the names should be [lower camelCase](https://wiki.c2.com/?CamelCase).

> **Note:** Contains rules can also be applied to 'modifierExtension' arrays; simply replace `extension` with `modifierExtension`.

**Examples:**

* Add standalone FHIR extensions [`patient-disability`](http://hl7.org/fhir/R4/extension-patient-disability.html) and [`patient-genderIdentity`](http://hl7.org/fhir/StructureDefinition/patient-genderIdentity) to a profile of the Patient resource, at the top level using the canonical URLs for the extensions:

  ```
  * extension contains http://hl7.org/fhir/StructureDefinition/patient-disability named disability 0..1 MS and http://hl7.org/fhir/StructureDefinition/patient-genderIdentity named genderIdentity 0..1 MS
  ```

* The same statement, using aliases and whitespace flexibility for better readability:

  ```
  * Alias: $Disability = http://hl7.org/fhir/StructureDefinition/patient-disability
  * Alias: $GenderIdentity = http://hl7.org/fhir/StructureDefinition/patient-genderIdentity
  
  // intervening lines not shown

  * extension contains
        $Disability named disability 0..1 MS and
        $GenderIdentity named genderIdentity 0..1 MS
  ```

* Add a standalone extension Laterality, defined in the same FSH project, to a bodySite attribute (second level extension):

  ```
  * bodySite.extension contains Laterality named laterality 0..1

  // intervening lines not shown

  Extension: Laterality
  Description: "Body side of a body location."
  * value[x] only CodeableConcept
  * valueCodeableConcept from LateralityVS (required)
  ```

* Show how the inline extensions in [US Core Race](https://www.hl7.org/fhir/us/core/StructureDefinition-us-core-race.html) would be defined in FSH:

  ```
  * extension contains
        ombCategory 0..5 MS
        detailed 0..*
        text 1..1 MS
  // rules defining the inline extensions would typically follow:
  * extension[ombCategory].value[x] only Coding
  * extension[ombCategory].valueCoding from http://hl7.org/fhir/us/core/ValueSet/omb-race-category (required)
  * extension[text].value[x] only string
  // etc.
  ```

#### Contains Rules for Slicing

Slicing is an advanced, but necessary, feature of FHIR. It is helpful to have a basic understanding of [slicing](http://hl7.org/fhir/R4/profiling.html#slicing) and [discriminators](http://hl7.org/fhir/R4/profiling.html#discriminator) before attempting slicing in FSH.

In FSH, slicing is addressed in three steps: (1) identifying the slices, (2) defining each slice's contents, and (3) specifying the slicing logic.

##### Step 1. Identifying the Slices

The first step in slicing is to populate the array that is to be sliced, using the `contains` keyword. The syntaxes are very similar to [`contains` rules for inline extensions](#contains-rules-for-extensions):

<pre><code>* &lt;array&gt; contains {name} {card} <i>{flags}</i>

* &lt;array&gt; contains 
    {name1} {card1} <i>{flags1}</i> and 
    {name2} {card2} <i>{flags2}</i> and
    {name3} {card3} <i>{flags3}</i> ...
</code></pre>

In this pattern, `<array>` is a path to the element that is to be sliced and to which the slicing rules will applied in step 3. The names (`name`, `name1`, etc.) are created by the rule author to describe the slice in the context of the profile. These names are used to refer to the slice in later rules. By convention, the slice names should be [lower camelCase](https://wiki.c2.com/?CamelCase).

Each slice will match or constrain the data type of the array it slices. In particular:

* If an array is a one of the FHIR data types, each slice will be the same data type or a profile of it. For example, if Observation.identifier is sliced, each slice will have type Identifier or be constrained to a profile of the Identifier data type.
* If the sliced array is a backbone element, each slice "inherits" the sub-elements of the backbone. For example, the slices of Observation.component possess all the elements of Observation.component (code, value[x], dataAbsentReason, etc.). Constraints may be applied to the slices.
* If the array to be sliced is a Reference, then each slice must be a reference to one or more of the allowed Reference types. For example, if the element to be sliced is Reference(Observation or Condition), then each slice must either be Reference(Observation or Condition), Reference(Observation), Reference(Condition), or a profiled version of those resources.

**Example:**

* Slice the Observation.component array for blood pressure:

  ```
  * component contains systolicBP 1..1 MS and diastolicBP 1..1 MS
  ```

* Because FSH is white-space invariant, the previous example can be rewritten so the slices appear one-per-line for readability:

  ```
  * component contains
      systolicBP 1..1 MS and
      diastolicBP 1..1 MS
  ```

###### Reslicing

Reslicing (slicing an existing slice) uses a similar syntax, but the left-hand side uses [slice path syntax](#sliced-array-paths) to refer to the slice that is being resliced:

<pre><code>* &lt;array[{slice name}]&gt; contains {name} {card} <i>{flags}</i>

* &lt;array[{slice name}]&gt; contains 
    {name1} {card1} <i>{flags1}</i> and 
    {name2} {card2} <i>{flags2}</i> and
    {name3} {card3} <i>{flags3}</i> ...
</code></pre>

**Example:**

* In an Observation for Apgar score, reslice the Apgar respiration score component into one-, five-, and ten-minute scores:

  ```
  * component contains
       appearanceScore 0..3 and
       pulseScore 0..3 and
       grimaceScore 0..3 and
       activityScore 0..3 and
       respirationScore 0..3
  * component[respirationScore] contains
      oneMinuteScore 0..1 and
      fiveMinuteScore 0..1 and
      tenMinuteScore 0..1
  ```

##### Step 2. Defining Slice Contents

The next step is to define the properties of each slice. FSH requires slice contents to be defined inline. The rule syntax is the same as constraining any other element, but the [slice path syntax](#sliced-array-paths) is used to specify the path:

```
* <array>[{slice name}].<element> {constraint}
```

The slice content rules must appear *after* the contains rule that creates the slices.

**Examples:**

* Define the content of the systolicBP and diastolicBP slices:

  ```
  * component[systolicBP].code = LNC#8480-6 // Systolic blood pressure
  * component[systolicBP].value[x] only Quantity
  * component[systolicBP].valueQuantity = UCUM#mm[Hg] "mmHg"
  * component[diastolicBP].code = LNC#8462-4 // Diastolic blood pressure
  * component[diastolicBP].value[x] only Quantity
  * component[diastolicBP].valueQuantity = UCUM#mm[Hg] "mmHg"
  ```

At minimum, each slice must be constrained such that it can be uniquely identified via the discriminator (see Step 3). For example, if the discriminator path points to a "code" path that is a CodeableConcept, and it discriminates by value or pattern, then each slice must constrain "code" using an assignment rule or binding rule that uniquely distinguishes it from the other slices' codes.

##### Step 3. Specifying the Slicing Logic

Slicing in FHIR requires authors to specify a [discriminator path, type, and rules](http://www.hl7.org/fhir/R4/profiling.html#discriminator). In addition, authors can optionally declare the slice as ordered or unordered (default: unordered), and/or provide a description. The meaning and allowable values are exactly [as defined in FHIR](http://www.hl7.org/fhir/R4/profiling.html#discriminator).

The slicing logic parameters are specified using [caret paths](#caret-paths). The discriminator path identifies the element to be sliced, which is typically a multi-cardinality (array) element. The discriminator type determines how the slices are differentiated, e.g., by value, pattern, existence of the sliced element, data type of sliced element, or profile conformance.

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

FHIR also defines I and NE flags, representing elements affected by constraints, and elements that cannot have extensions, respectively. These flags are not directly supported in flag syntax, since the I flag is determined by the presence of [invariants](#obeys-rules), and NE flags apply only to infrastructural elements in base resources.

The following syntaxes can be used to assign flags:

```
* <element> {flag}

* <element> {flag1} {flag2} ...

* <element1> and <element2> and <element3> ... {flag}

* <element1> and <element2> and <element3> ... {flag1} {flag2} ...
```

**Examples:**

* Declare communication to be a MustSupport and Summary element:

  ```
  * communication MS SU
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

The rules in the named rule set are evaluated as if they were copied and pasted in the designated location.

Each rule in the rule set should be compatible with the item where the rule set is inserted, in the sense that all the rules defined in the rule set apply to elements actually present in the target. Implementations should check the legality of a rule set at compile time. If a particular rule from a rule set does not match an element in the target, that rule will not be applied, and an error should be emitted. It is up to implementations if other valid rules from the rule set are applied.

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

[Invariants](https://www.hl7.org/fhir/R4/conformance-rules.html#constraints) are constraints that apply to one or more values in instances, expressed as [FHIRPath](https://www.hl7.org/fhir/R4/fhirpath.html) or [XPath](https://developer.mozilla.org/en-US/docs/Web/XPath) expressions. An invariant can apply to an instance as a whole or a single element. Multiple invariants can be applied to an instance as a whole or to a single element. The syntax for applying invariants in profiles is:

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

FSH rules can be used to restrict the data type of an element. The syntaxes to restrict the type are:

```
* <element> only {datatype}

* <element> only {datatype1} or {datatype2} or {datatype3} ...

* <element> only Reference({ResourceType name|id|url})

* <element> only Reference({ResourceType1 name|id|url} or {ResourceType2 name|id|url} or {ResourceType3 name|id|url} ...)
```

Certain elements in FHIR offer a choice of data types using the [x] syntax. Choices also frequently appear in references. For example, Condition.recorder has the choice Reference(Practitioner or PractitionerRole or Patient or RelatedPerson). In both cases, choices can be restricted in two ways: reducing the number or choices, and/or substituting a more restrictive data type or profile for one of the choices appearing in the parent profile or resource.

Following [standard profiling rules established in FHIR](https://www.hl7.org/fhir/R4/profiling.html), the data type(s) in a type rule must always be more restrictive than the original data type. For example, if the parent data type is Quantity, it can be replaced by SimpleQuantity, since SimpleQuantity is a profile on Quantity (hence more restrictive than Quantity itself), but cannot be replaced with Ratio, because Ratio is not a type of Quantity. Similarly, Condition.subject, defined as Reference(Patient or Group), can be constrained to Reference(Patient), Reference(Group), or Reference(us-core-patient), but cannot be restricted to Reference(RelatedPerson), since that is neither a Patient nor a Group.

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

* Restrict Observation.performer (a choice of reference to Practitioner, PractitionerRole, Organization, CareTeam, Patient, or RelatedPerson) to allow only Practitioner:

  ```
  * performer only Reference(Practitioner)
  ```

* Restrict Observation.performer to either a Practitioner or a PractitionerRole:

  ```
  * performer only Reference(Practitioner or PractitionerRole)
  ```

* Restrict performer to PrimaryCarePhysician or EmergencyRoomPhysician (assuming these are profiles on Practitioner):

  ```
  * performer only Reference(PrimaryCarePhysician or EmergencyRoomPhysician)
  ```

* Restrict the Practitioner choice of performer to a PrimaryCarePhysician, without restricting other choices. Because the path specifically calls out the Practitioner choice, the result is that performer can reference a Practitioner resource that validates against the PrimaryCareProvider profile or any of the other choices (PractitionerRole, Organization, CareTeam, Patient, and RelatedPerson):

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
| `RuleSet` | Declares a set of rules that can be reused | name |
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
| `Severity` | whether violation of an invariant represents an error or a warning | code |
| `Source` | The profile the mapping applies to | name |
| `Target` | The standard being mapped to | uri |
| `Title` | Short human-readable name | string |
| `Usage` | Specifies how an instance is intended to be used in the IG | code |
| `XPath` | the XPath in an invariant | XPath string |
{: .grid }

> **Note:** Keywords are case-sensitive.

The following table shows the relationship between declaration keywords and additional keywords.


| Declaration \ Keyword               | Id  | Description | Title | Parent | InstanceOf | Usage | Source | Target | Severity | XPath | Expression |
|-------------------------------------|-----|-------------|-------|--------|------------|-------|--------|--------|----------|-------|------------|
[Alias](#defining-aliases)            |     |             |       |        |            |       |        |        |          |       |            |
[Code System](#defining-code-systems) |  S  |     S       |   S   |        |            |       |        |        |          |       |            |
[Extension](#defining-extensions)     |  S  |     S       |   S   |   O    |            |       |        |        |          |       |            |
[Instance](#defining-instances)       |  x  |     S       |   S   |        |     R      |   O   |        |        |          |       |            |
[Invariant](#defining-invariants)     |  x  |     R       |       |        |            |       |        |        |    R     |    O  |    O       |
[Mapping](#defining-mappings)         |  x  |     S       |   S   |        |            |       |   R    |   R    |          |       |            |
[Profile](#defining-profiles)         |  S  |     S       |   S   |   R    |            |       |        |        |          |       |            |
[Rule Set](#defining-rule-sets)       |     |             |       |        |            |       |        |        |          |       |            |
[Value Set](#defining-value-sets)     |  S  |     S       |   S   |        |            |       |        |        |          |       |            |
{: .grid }

**KEY:**  R = required, S = suggested (optional but recommended), O = optional, blank = disallowed, x = Id is required but specified in the declaration statement

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
 
  Alias: $RaceAndEthnicityCDC = urn:oid:2.16.840.1.113883.6.238
 
  Alias: $ObsCat = http://terminology.hl7.org/CodeSystem/observation-category
  ```

#### Defining Code Systems
It is sometimes necessary to define new codes inside an IG that are not drawn from an external code system (aka _local codes_). When defining local codes, you must define them in the context of a code system.

> **Note:** Defining local codes is not generally recommended, since those codes will not be part of recognized terminology systems. However, when existing vocabularies do not contain necessary codes, it may be necessary to define them -- at least temporarily -- as local codes.

Creating a code system uses the keywords `CodeSystem`, `Id`, `Title` and `Description`. Codes are then added, one per rule, using the following syntax:


```
* #{code} "{display string}" "{definition string}"
```

**Notes:**
* Do not put a code system before the hash sign `#`. The code system name is given by the `CodeSystem` keyword.
* The definition of the term can be optionally provided as the second string following the code.
* Do not use the word `include` in a code system rule. The rule is creating a brand new code, not including an existing code defined elsewhere.

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

> **Note:** FSH does not support definition of relationships between local codes, such as parent-child (is-a) relationships.

#### Defining Extensions

Defining extensions is similar to defining a profile, except that the parent of an extension is not required. Extensions can also inherit from other extensions, but if the `Parent` keyword is omitted, the parent is assumed to be FHIR's [Extension element](https://www.hl7.org/fhir/R4/extensibility.html#extension).

All extensions have the same structure, but extensions can either have a value (i.e. a value[x] element) or sub-extensions, but not both. To create a simple extension, the value[x] element should be constrained. To create a complex extension, the extension array of the extension must be sliced (see [Contains Rules for Extensions](#contains-rules-for-extensions)).

Since simple and complex extensions are mutually-exclusive, FSH implementations should set the value[x] cardinality to 0..0 if sub-extensions are specified, set extension cardinality to 0..0 if constraints are applied to value[x], and signal an error if value[x] and extensions are simultaneously specified.

**Example:**

* Show how the [US Core BirthSex extension](http://hl7.org/fhir/us/core/StructureDefinition-us-core-birthsex.html) (a simple extension) would be defined in FSH:

  ```
  Extension: USCoreBirthSexExtension
  Id:   us-core-birthsex
  Title:  "US Core Birth Sex Extension"
  Description: "A code classifying the person's sex assigned at birth as specified by the [Office of the National Coordinator for Health IT (ONC)](https://www.healthit.gov/newsroom/about-onc). This extension aligns with the C-CDA Birth Sex Observation (LOINC 76689-9)."
  // publisher, contact, and other metadata could be defined here using caret syntax (omitted)
  * value[x] only code
  * valueCode from http://hl7.org/fhir/us/core/ValueSet/birthsex (required)
  ```

* Show how [US Core Ethnicity extension](https://www.hl7.org/fhir/us/core/StructureDefinition-us-core-ethnicity.html) (a complex extension with inline sub-extensions) would be defined in FSH:

  ```
  Extension:      USCoreEthnicityExtension
  Id:             us-core-ethnicity
  Title:          "US Core Ethnicity Extension"
  Description:    "Concepts classifying the person into a named category of humans sharing common history, traits, geographical origin or nationality. The ethnicity codes used to represent these concepts are based upon the [CDC ethnicity and Ethnicity Code Set Version 1.0](http://www.cdc.gov/phin/resources/vocabulary/index.html) which includes over 900 concepts for representing race and ethnicity of which 43 reference ethnicity.  The ethnicity concepts are grouped by and pre-mapped to the 2 OMB ethnicity categories: - Hispanic or Latino - Not Hispanic or Latino."
  * extension contains
      ombCategory 0..1 MS and
      detailed 0..* and
      text 1..1 MS
  * extension[ombCategory] ^short = "Hispanic or Latino|Not Hispanic or Latino"
  * extension[ombCategory].value[x] only Coding
  * extension[ombCategory].valueCoding from OmbEthnicityCategories (required)
  * extension[detailed] ^short = "Extended ethnicity codes"
  * extension[detailed].value[x] only Coding
  * extension[detailed].valueCoding from DetailedEthnicity (required)
  * extension[text] ^short = "Ethnicity text"
  * extension[text].value[x] only string
  ```

* Define an extension with an explicit parent, constraining the US Core Birth Sex extension for US states that do not recognize non-binary birth sex:

  ```
  Extension:      BinaryBirthSexExtension
  Parent:         USCoreBirthSexExtension
  Id:             binary-birthsex
  Title:          "Binary Birth Sex Extension"
  Description:    "As of 2019, certain US states only allow M or F on birth certificates."
  * valueCode from BinaryBirthSexValueSet (required)
  ```

#### Defining Instances

Instances are defined using the keywords `Instance`, `InstanceOf`, `Title`, `Usage` and `Description`. The `InstanceOf` is required, and plays a role analogous to the `Parent` of a profile. The value of `InstanceOf` can be the name, id, or url for any profile, resource, or complex data type defined internally or externally.

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
  * name.family = "Anydoc"
  * name.given = "David"
  * name.suffix = "MD"
  * identifier[NPI].value = "8274017284"
  ```

* Define an instance of PrimaryCancerCondition, using many available features:

  ```
  Instance: mCODEPrimaryCancerConditionExample01
  InstanceOf: PrimaryCancerCondition
  Description: "mCODE Example for Primary Cancer Condition"
  Usage: #example
  * id = "mCODEPrimaryCancerConditionExample01"
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

##### Defining Instances of Conformance Resources

The FSH language is designed to support creation of StructureDefinitions (the underlying type for profiles and extensions), ValueSets and CodeSystems. Tools like [SUSHI](sushi.html) address the creation of the ImplementationGuide resource, which is important for producing an IG. However, there are other [conformance resources](https://www.hl7.org/fhir/R4/conformance-module.html) that can be involved with IG creation that FSH does not explicitly support. These include [CapabilityStatement](https://www.hl7.org/fhir/R4/capabilitystatement.html), [OperationDefinition](https://www.hl7.org/fhir/R4/operationdefinition.html), [SearchParameter](https://www.hl7.org/fhir/R4/searchparameter.html), and [CompartmentDefinition](https://www.hl7.org/fhir/R4/compartmentdefinition.html).

These conformance resources are created using FSH instance grammar. For example, to create a CapabilityStatement, use `InstanceOf: CapabilityStatement`. The values of the CapabilityStatement are then set using assignment statements. Because CapabilityStatements can be very long, we provide a [downloadable template](CapabilityStatementTemplate.fsh) as a starting point.

#### Defining Invariants

Invariants are defined using the keywords `Invariant`, `Description`, `Expression`, `Severity`, and `XPath`. The keywords correspond directly to elements in ElementDefinition.constraint. An invariant definition cannot have rules, and are incorporated into a profile via [obeys rules](#obeys-rules).

| Keyword | Usage | Corresponding element in ElementDefinition | Data Type | Required |
|-------|------------|--------------|-------|----|
| Invariant | Identifier for the invariant | constraint.key | id | yes |
| Description | Human description of constraint | constraint.human | string or markdown  | yes |
| Expression | FHIRPath expression of constraint | constraint.expression | FHIRPath string | no |
| Severity | Either `#error` or `#warning`, as defined in [ConstraintSeverity](https://www.hl7.org/fhir/R4/valueset-constraint-severity.html) | constraint.severity | code | yes |
| XPath | XPath expression of constraint | constraint.xpath | XPath string | no |

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

[Mappings](https://www.hl7.org/fhir/R4/mappings.html) are an optional part of an SD, intended to help implementers understand the SD in relation to other standards. While it is possible to define mappings using escape (caret) syntax, FSH provides a more concise approach. These mappings are informative and are not to be confused with the computable mappings provided by [FHIR Mapping Language](https://www.hl7.org/fhir/R4/mapping-language.html) and the [StructureMap resource](https://www.hl7.org/fhir/R4/structuremap.html).

To create a mapping, the keywords `Mapping`, `Source`, `Target` are required and `Title` and `Description` are optional.

| Keyword | Usage | SD element |
|-------|------------|--------------|
| Mapping | Appears first and provides a unique name for the mapping | n/a |
| Source | The name of the profile the mapping applies to | n/a |
| Target | The URL, URI, or OID for the specification being mapped to | mapping.uri |
| Id | An internal identifier for the target specification | mapping.identity |
| Title | A human-readable name for the target specification | mapping.name  |
| Description | Additional information such as version notes, issues, or scope limitations. | mapping.comment |

The mappings themselves are declared in rules with the following syntaxes:

<pre><code>* -> "{map string}" <i>"{comment string}" #{mime-type code}</i>

* &lt;element&gt; -> "{map string}" <i>"{comment string}" #{mime-type code}</i>
</code></pre>

The first type of rule applies to mapping the profile as a whole to the target specification. The second type of rule maps a specific element to the target.

The `map`, `comment`, and `mime-type` are as defined in FHIR and correspond to elements in [StructureDefinition.mapping](http://www.hl7.org/fhir/structuredefinition.html) and [ElementDefinition.mapping](https://www.hl7.org/fhir/R4/elementdefinition.html) (map corresponds to mapping.map, mime-type to mapping.language, and comment to mapping.comment). The mime type code must come from FHIR's [MimeType value set](https://www.hl7.org/fhir/R4/valueset-mimetypes.html). For further information, the reader is referred to the FHIR definitions of these elements.

>**Note:** Unlike setting the mapping.map directly in the SD, mapping rules within a Mapping item do not include the name of the resource in the path on the left hand side.

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

Rules defining the profile follow immediately after the keyword section.

#### Defining Rule Sets

Rule sets provide the ability to define rules and apply them to a compatible target. The rules are copied from the rule set at compile time. Any item admitting rules can have one or more rule sets applied to them. The same rule set can be used in multiple places.

All types of rules can be used in rule sets, including [insert rules](#insert-rules), enabling the nesting of rule sets in other rule sets. Circular dependencies are not allowed.

Rule sets are defined by using the keyword `RuleSet`:

```
RuleSet: {name}
{rule1}
{rule2}
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

A value set is a group of coded values representing acceptable values for a FHIR element whose data type is code, Coding, or CodeableConcept.

Value sets are defined using the declarative keyword `ValueSet`, with optional keywords `Id`, `Title` and `Description`.

Codes must be taken from one or more terminology systems (also called code systems or vocabularies). Codes cannot be defined inside a value set. If necessary, [you can define your own code system](#defining-code-systems).

The contents of a value set are defined by a set of rules. There are four types of rules to populate a value set:

> **Note:** In value set rules, the word `include` is optional.

| To include... | Syntax | Example |
|-------|---------|----------|
| A single code | `* include {Coding}` | `* include SCT#961000205106 "Wearing street clothes, no shoes"` <br/> or equivalently, <br/> `* SCT#961000205106 "Wearing street clothes, no shoes"`|
| All codes from another value set | `* include codes from valueset {ValueSet name|id|url}` | `* include codes from valueset http://hl7.org/fhir/ValueSet/data-absent-reason`  <br/> or equivalently, <br/> `* codes from valueset http://hl7.org/fhir/ValueSet/data-absent-reason`|
| All codes from a code system | `* include codes from system {CodeSystem name|id|url}` | `* include codes from system http://snomed.info/sct` <br/> or equivalently, <br/> `* codes from system http://snomed.info/sct`|
| Selected codes from a code system (filters are code system dependent) | `* include codes from system {CodeSystem name|id|url} where {filter} and {filter} and ...` | `* include codes from system SCT where concept is-a #254837009` <br/> or equivalently, <br/> `* codes from system SCT where concept is-a #254837009`|
{: .grid }

See [below](#filters) for discussion of filters.

Analogous rules can be used to leave out certain codes, with the word `exclude` replacing the word `include`:

| To exclude... | Syntax | Example |
|-------|---------|----------|
| A single code | `* exclude {Coding}` | `* exclude SCT#961000205106 "Wearing street clothes, no shoes"` |
| All codes from another value set | `* exclude codes from valueset {ValueSet name|id|url}` | `* exclude codes from valueset http://hl7.org/fhir/ValueSet/data-absent-reason` |
| All codes from a code system | `* exclude codes from system {CodeSystem name|id|url}` | `* exclude codes from system http://snomed.info/sct` |
| Selected codes from a code system (filters are code system dependent) | `* exclude codes from system {CodeSystem name|id|url} where {filter}` | `* exclude codes from system SCT where concept is-a #254837009` |
{: .grid }

##### Filters

A filter is a logical statement in the form `{property} {operator} {value}`, where operator is chosen from the [FilterOperator value set](http://hl7.org/fhir/ValueSet/filter-operator). Not all operators in that value set are valid for all code systems. The `property` and `value` are dependent on the code system. For choices for the most common code systems, see the [FHIR documentation on filters]( http://hl7.org/fhir/valueset.html#csnote).

**Examples** 

* Define a value set using [extensional](https://www.hl7.org/fhir/R4/valueset.html#int-ext) rules. This example demonstrates the optionality of the word `include`:

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
  ValueSet: HistologyMorphologyBehaviorVS
  Id: mcode-histology-morphology-behavior-vs
  Title: "Histology Morphology Behavior Value Set"
  Description: "Codes representing the structure, arrangement, and behavioral characteristics of malignant neoplasms, and cancer cells.
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