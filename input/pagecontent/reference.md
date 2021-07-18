{%include shaded-table.html%}

This chapter contains the formal specification of the FHIR Shorthand (FSH) language. It is intended primarily as a reference, not a tutorial. For tutorials and additional documentation please go to [fshschool.org](https://fshschool.org).

In this specification, the key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" are to be interpreted as described in [RFC2119](https://tools.ietf.org/html/rfc2119).

Portions of the specification designated as "Trial Use" are indicated by {%include tu.html%} and <span style="background-color: #fff5e6;">background shading</span>. Remaining unmarked sections contain normative content.

### Notational Conventions

The FSH specification uses syntax expressions to illustrate the FSH language. While FSH has a formal grammar (see [Appendix](#appendix-formal-grammar)), most readers will find the syntax expressions more instructive.

Syntax expressions uses the following conventions:

| Style | Explanation | Example |
|:------------|:------|:---------|
| **bold** | A directory path or file name | **example-1.fsh** |
| `Code` | Code fragments, such as FSH keywords, FSH statements, and FSH syntax expressions  | `* status = #open` |
| `{curly braces}` | An item to be substituted in a syntax expression | `{flag}` |
| `<angle brackets>` | An element or path to an element with the given datatype, to be substituted in the syntax expression | `<CodeableConcept>` |
| `...` (ellipsis) | Indicates a pattern that can be repeated | <code>{flag1} {flag2} {flag3}&nbsp;...</code> |
| <code><span class="optional">italics</span></code> | An optional item in a syntax expression | <code><span class="optional">{flag}</span></code> |
{: .grid }

**Syntax Expression Examples:**

* A FSH rule to assign the value of a Quantity:

  ```
  * <Quantity> = {decimal or integer} '{UCUM unit}'
  ```

  A FSH statement following this pattern would be written as:

  * An asterisk, followed by
  * Any element of datatype Quantity or a path to an element with datatype Quantity, followed by
  * An equals sign, followed by
  * Any decimal or integer number, followed by
  * Any Unified Code for Units of Measure (UCUM) unit, enclosed in single quotes.

* A rule to constrain an element to a certain datatype or types:

  `* <element> only {datatype(s)}`

  A FSH statement following this pattern would be written as:

  * An asterisk, followed by
  * Any element or a path to any element, followed by
  * The word `only`, followed by
  * A list including at least one datatype, where datatype 

Here are some examples of angle brackets and curly braces and used in this IG:

| Angle Brackets | Meaning | Example(s) |
|--------|--------|---------|
| `<bindable>` | Substitute an element or path to an element whose datatype allows it to be bound to a value set | `code` |
| `<CodeableConcept>`  | Substitute an element or path to an element whose datatype is CodeableConcept |  `category`  |
| `<element>` | Substitute any element or path to any element | `method.type` |
| `<element(s)>` | Substitute one or more elements or paths, separated by `and` | `category and method and method.type` |
| `<Extension>` | Substitute an element or path to an element whose datatype is Extension | `extension` <br/> `modifierExtension` <br/> `bodySite.extension` |
{: .grid }

| Curly Braces | Meaning | Example(s) |
|--------|--------|---------|
| `{card}` | Substitute a [cardinality expression](#cardinality-rules) |  `0..1` |
| `{code}`  | Substitute an instance of a code | `#active` |
| `{CodeableConcept}`  | Substitute an instance of a CodeableConcept | `http://loinc.org#8480-6 "Systolic blood pressure"` |
| `{decimal}` | Substitute any decimal number | `124.0` |
| `{datatype}` | Substitute any single primitive or complex datatype name, Reference or Canonical | `decimal` <br/> `ContactPoint`<br/> `Reference(Patient)` |
| `{datatype(s)}` | Substitute one or more primitive or complex datatype names, Reference(s) or Canonical(s), separated by `or` | `Quantity or CodeableConcept`<br/>`Reference(Patient or Practitioner)`<br/>`Canonical(ActivityDefinition)` |
| `{Extension}` |  Substitute the name, id, or canonical URL (or alias) of an Extension | `duration` <br/> `allergyintolerance-duration` <br/> `http://hl7.org/fhir/StructureDefinition/allergyintolerance-duration` |
| `{flag}`  | Substitute one of the valid [FSH flags](#flag-rules) |  `MS` |
| `{flag(s)}` | Substitute one or more flags, separated by whitespace | `MS SU ?!` |
| `{Invariant}` | Substitute the id of an Invariant | `us-core-8` |
| `{ResourceOrProfile}` | Substitute the name, id, or canonical URL (or alias) of any Resource or Profile | `Condition` <br/> `http://hl7.org/fhir/us/core/StructureDefinition/us-core-location` |
| `{rule}` | Substitute any FSH rule | `* category 1..1 MS` |
| `{RuleSet}` | Substitute the name of a RuleSet | `MyRuleSet` |
| `{ValueSet}` | Substitute the name, id, or canonical URL (or alias) of a ValueSet | `http://hl7.org/fhir/ValueSet/address-type` |
{: .grid }

>**Note:** When listing multiple items, consecutive elements and paths are always separated by `and`, consecutive flags are always separated by white spaces, and consecutive datatypes area always separated by `or`. When listing multiple References, the `or` is placed *inside* the Reference(), e.g. `Reference(Patient or Practitioner)`, **not** `Reference(Patient) or Reference(Practitioner)`

### FSH Foundations

#### Projects

A major organizing construct is the FSH project. Each project MUST have an associated canonical URL, used for constructing canonical URLs for items created in the project. It is up to implementations to decide how this association is made. Typically, one FSH project equates to one FHIR Implementation Guide (IG).

#### Files

Content in one FSH project MAY be contained in one or more FSH files. Files MUST use the **.fsh** extension. It is up to implementations to define the association between FSH files and FSH projects.

The allocation of items to files is not meaningful in FSH, and items from all files in one project can be considered globally pooled for the purposes of FSH. Items can appear in any order within **.fsh** files, and items can be moved inside and between **.fsh** files within the same project without affecting the interpretation of the content.

> **Note:** FSH can also be contained in other ways, such as in a database or in a form field, and still be valid FSH. We assume FSH files for presentation purposes.

#### FHIR Version

Each FSH project MUST declare the version of FHIR it depends upon. The form of this declaration is outside the scope of the FSH specification, and SHOULD be managed by implementations. The FSH specification is not explicitly FHIR-version dependent, but implementations MAY support only a specific version or versions of FHIR.

The FSH language specification has been designed around FHIR R4 and later. Compatibility with previous versions has not been evaluated. FSH depends primarily on normative parts of the FHIR R4 specification (in particular, StructureDefinition and primitive datatypes).

{%include tu-div.html%}
FSH supports new pre-release FHIR R5 datatypes integer64 and CodeableReference on a trial use basis.
</div>

#### External IGs

Dependencies between a FSH project and other IGs MUST be declared. The form of this declaration is outside the scope of the FSH language and SHOULD be managed by implementations. In this Guide, these are referred to as "external" IGs.

#### Version Numbering

The FSH specification, like other FHIR Implementation Guides (IGs), expresses versions in terms of three integers, x.y.z, indicating the sequence of releases. Release 2 is later than release 1 if x2 > x1 or (x2 = x1 and y2 > y1), or (x2 = x1 and y2 = y1 and z2 > z1). Implementations SHOULD indicate what version or versions of the FSH specification they implement.

Like other HL7 FHIR IGs, the version numbering of the FSH specification does not entirely follow the [semantic versioning convention](https://semver.org). Consistent with semantic versioning, an increment of z indicates a patch release containing minor updates and bug fixes, while maintaining backwards compatibility with the previous version. An increment in y indicates new or modified features, and potentially, non-backward-compatible changes (i.e., a minor or major release in semantic versioning). By HL7 convention, the major version number x typically does not increment until the release of a new balloted version.

### FSH Language Basics

#### Formal Grammar

[FSH has a formal grammar](#appendix-formal-grammar) defined in [ANTLR4](https://www.antlr.org/). The grammar is looser than the language specification since many things, such as datatype agreement, are not enforced by the grammar. If there is discrepancy between the grammar and the FSH language description, the language description is considered correct until the discrepancy is clarified and addressed.

#### Reserved Words

FSH has a number of reserved words, symbols, and patterns. Reserved words and symbols with special meaning in FSH are: `contains`, `named`, `and`, `only`, `or`, `obeys`, `true`, `false`, `include`, `exclude`, `codes`, `where`, `valueset`, `system`, `from`, `insert`, `!?`, `MS`, `SU`, `N`, `TU`, `D`, `=`, `*`, `:`, `->`, `.`,`[`, `]`.

The following words are reserved, with or without white spaces prior to the colon: `Alias:`, `CodeSystem:`, `Extension:`, `Instance:`, `Invariant:`, `Mapping:`, `Profile:`, `RuleSet:`, `ValueSet:`, `Description:`, `Expression:`, `Id:`, `InstanceOf:`, `Parent:`, `Severity:`, `Source:`, `Target:`, `Title:`, `Usage:`, `XPath:`.

<span style="background-color: #fff5e6;"> {%include tu.html%} `Logical:` and `Resource:` are reserved on trial use basis.</span>

The following words are reserved, with or without white spaces inside the parentheses: `(example)`, `(preferred)`, `(extensible)`, `(required)`, `(exactly)`.

#### Whitespace

Repeated whitespace has meaning within FSH files only within string literals <span style="background-color: #fff5e6;">and when used for [indenting rules](reference.html#indented-rules) {%include tu.html%}</span>. In all other contexts, repeated whitespace is not meaningful. Whitespace insensitivity can be used to improve readability. For example:

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

#### Primitives

The primitive datatypes and value formats in FSH are identical to the [primitive types and value formats in FHIR](https://www.hl7.org/fhir/R4/datatypes.html#primitive). References in this document to code, id, oid, etc. refer to the primitive datatypes defined in FHIR.

FSH strings support the escape sequences that FHIR already defines as valid in its [regex for strings](https://www.hl7.org/fhir/R4/datatypes.html#primitive): \r, \n, and \t. Strings MUST be delimited by non-directional (neutral) quotes. Left and right directional quotes (unicode U+201C and U+201D) sometimes automatically inserted by "smart" text editors SHALL NOT be accepted. Left and right directional single quotes (U+2018 and U+2019) SHALL NOT be accepted in contexts requiring a single quotation mark.

#### Reference and Canonical Data Types

FHIR resources can contain two types of references, [Resource references](https://www.hl7.org/fhir/R4/references.html#2.3.0) and [Canonical references](https://www.hl7.org/fhir/R4/references.html#canonical).

FSH represents Resource references using the syntax `Reference({Resource})`. For elements that require a Reference datatype, `Reference()` MUST be included, except in the case of a [reference choice path](#reference-paths).

Canonical references refer to the standard URL associated with FHIR items. For elements that require a canonical datatype, FSH will accept a URL or an expression in the form `Canonical({name or id})`. `Canonical()` stands for the canonical URL of the referenced item. For items defined in the same FSH project, the canonical URL is constructed using the FSH project's canonical URL. `Canonical()` therefore enables a user to change the FSH project’s canonical URL in a single place with no changes to FSH definitions.

When syntax allows for multiple References of Canonicals, the items are separated by `or` placed *inside* the parentheses, e.g. `Reference(Patient or Practitioner)`, **not** `Reference(Patient) or Reference(Practitioner)`

#### Codes and Codings

FSH provides special grammar for expressing codes and Codings. Codes are denoted with `#` sign. The FSH syntax is:

```
#{code}
```

or

```
#"{code}"
```

In general, the first syntax is sufficient. Quotes are only required when a code contains white space.

FSH represents Codings as follows:

<pre><code>{CodeSystem}<span class="optional">|{version string}</span>#{code} <span class="optional">"{display string}"</span></code></pre>

As [indicated by italics](#notational-conventions), the version and display strings are optional. `CodeSystem` represents the controlled terminology the code is taken from, either by name, by id, or canonical URL. The vertical bar syntax for the version of the code system is the same approach used in the canonical datatype in FHIR. To set the less-common properties of a Coding or to set properties individually, [assignment rules](#assignments-with-the-coding-data-type) can be used.

This syntax is also used with CodeableConcepts (see [Assignments with the CodeableConcept Data Type](#assignments-with-the-codeableconcept-data-type))

**Examples:**

* The code postal used in Address.type:

  ```
  #postal
  ```

* The code <= from the [Quantity Comparator value set](http://hl7.org/fhir/R4/valueset-quantity-comparator.html):

  ```
  #<=
  ```

* A code containing white space:

  ```
  #"VL 1-1, 18-65_1.2.2"
  ```

* A Coding from SNOMED-CT:

  ```
  http://snomed.info/sct#363346000 "Malignant neoplastic disease (disorder)"
  ```
  
* The same Coding, assuming $SCT has been defined as an alias for http://snomed.info/sct:

  ```
  $SCT#363346000 "Malignant neoplastic disease (disorder)"
  ```
  
* A Coding from ICD10-CM, assuming the alias $ICD for that code system:

  ```
  $ICD#C004  "Malignant neoplasm of lower lip, inner aspect"
  ```
  
* A Coding with an explicit version specified with bar syntax:

  ```
  http://hl7.org/fhir/CodeSystem/example-supplement|201801103#chol-mmol
  ```
    
#### Quantities

FSH provides a shorthand that allows three aspects of a Quantity to be set simultaneously:

* The numerical quantity (`Quantity.value`)
* The units of measure (`Quantity.code`)
* Optionally, the human-readable displayed units (`Quantity.unit`)

The grammar is either:

<pre><code>{decimal} '{UCUM code}' <span class="optional">"{display}"</span></code></pre>

or

<pre><code>{decimal} {CodeSystem}<span class="optional">|{version string}</span>#{code} <span class="optional">"{display}"</span></code></pre>

The first shorthand only applies if the units are expressed in [Unified Code for Units of Measure](http://unitsofmeasure.org/) (UCUM). As a side effect of using this grammar, the code system (`Quantity.system`) will be automatically set to the UCUM code system (`http://unitsofmeasure.org`). The second shorthand can be used when the units are not UCUM. Alternatively, the value and units can be assigned independently (see [Assignments with the Quantity Data Type](#assignments-with-the-quantity-data-type)).

Example:

* Express a weight in pounds, using UCUM units, displaying "lb":

  ```
  155.0 '[lb_av]' "lb"
  ```

* Express the same weight in pounds, using NCI Thesaurus code for the units:

  ```
  155.0 http://ncithesaurus-stage.nci.nih.gov#C48531 "Pound"
  ```

#### Triple-Quoted Strings

While line breaks are supported using normal strings, FSH also supports different processing for strings demarcated with three double quotation marks `"""`. This feature can help authors to maintain consistent indentation in the FSH file. As an example, an author might use a triple-quote string to write markdown so that the markdown is neatly indented:

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

The difference between these two approaches is that the latter obscures the fact that the first and fourth line are at the same indentation level, and makes it appear there are two rules because of the asterisk in the first column. The former approach allows the first line to be empty so the string is defined as a block, and allows the entire block to be indented, so visually, it does not appear a second rule is involved (because of the asterisk in the first column). Using triple-quoted strings is entirely a matter of preference.

When processing triple-quote strings, the following approach is used:

* If the first line or last line contains only whitespace (including newline), discard it.
* If any other line contains only whitespace, truncate it to zero characters.
* For all other non-whitespace lines, detect the smallest number of leading spaces and trim that from the beginning of every line.

#### Item Names

Item names SHOULD follow [FHIR naming guidance](http://hl7.org/fhir/R4/structuredefinition-definitions.html#StructureDefinition.name). Names MUST be between 1 and 255 characters, begin with an uppercase letter, and contain only letters, numbers, and "_". By convention, item names SHOULD use [PascalCase (also known as UpperCamelCase)](https://wiki.c2.com/?UpperCamelCase). [Slice names](#contains-rules-for-slicing) and [local slice names for extensions](#contains-rules-for-extensions) SHOULD use [lower camelCase](https://wiki.c2.com/?CamelCase). These conventions are consistent with FHIR naming conventions.

Alias names MAY begin with `$`. Choosing alias names beginning with `$` allows for additional error checking ([see Defining Aliases](#defining-aliases) for details).

#### Item Identifiers

Item identifiers (ids) MUST be unique within the scope of its item type in the FSH project. For example, two Profiles with the same id cannot coexist, but it is possible to have a Profile and a ValueSet with the same id in the same FSH Project. However, to minimize potential confusion, it is best to use a unique id for every item in a FSH project. If no id is provided by a FSH author, implementations MAY create an id. It is RECOMMENDED that the id be based on the item's name, with _ replaced by -, and the overall length truncated to 64 characters (per the requirements of the [FHIR id datatype](https://www.hl7.org/fhir/R4/datatypes.html#primitive)).

#### Referring to Items

FSH allows internal and external items to be referred to by name, id, or canonical URL.  

A FSH item within the same project SHOULD be referred to by the name or id given in the item's [declaration statement](#declaration-statements). Core FHIR resources SHOULD be referred to by name, e.g., `Patient` or `Observation`. Items from external IGs and extensions, profiles, code systems, and value sets in core FHIR SHOULD be referred to by their canonical URLs, since this approach minimizes the chance of name collisions. In cases where an external name or id clashes with an internal name or id, then the internal item takes precedence, and external item MUST be referred to by its canonical URL.

### FSH Paths

FSH path grammar allows you to refer to any element of a profile, extension, or instance, regardless of nesting. Here are examples of things paths can refer to:

* Top-level elements such as the code element of an Observation
* Nested elements, such as the text element of the method element of an Observation
* Elements in a list or array, such as the second element in the name array of a Patient resource
* Individual datatypes of choice elements, such as onsetAge in onset[x]
* Individual slices within a sliced array, such as the systolicBP component in a blood pressure Observation
* Metadata elements of definitional resources, such as the experimental and active elements of a StructureDefinition.
* Properties of ElementDefinitions nested within a StructureDefinition, such as the maxLength property of string elements

In the following, the various types of path references are discussed. Some examples are presented using simple rules. For rule syntax and meaning, see [FSH Rules](#fsh-rules).

#### Top-Level Paths

The path to a top-level element is denoted by the element's name. Because paths are used within the context of a FSH definition or instance, the path MUST NOT include the resource name. For example, when defining a profile of Observation, the path to Observation.code is just `code`.

#### Nested Element Paths

To refer to nested elements, the path lists the properties in order, separated by a dot (`.`). Since the resource can be inferred from the context, the resource name is not included in the path.

**Example:**

* The path to the lot number of a Medication:

  ```
  batch.lotNumber
  ```

* The path to the plain text representation of the site of a MedicationAdministration:

  ```
  dosage.site.text
  ```

#### Reference Paths

Elements can offer a choice of reference types. In the FHIR specification, these choices are presented in the style Reference(Procedure \| Observation). To address a specific resource or profile among the choices, append the target Resource or Profile (represented by a name, id, or url) enclosed in square brackets to the path.

> **Note:** It is not permissible to cross reference boundaries in paths. This means that when a path gets to a Reference, that path cannot be extended further. For example, if Procedure has a subject element that has datatype Reference(Patient), and Patient has a gender, then `subject` is a valid path, but `subject.gender` is not, because it crosses into the Patient resource.

**Examples:**

* Path to the Reference(Practitioner) option of [DiagnosticReport.performer](https://www.hl7.org/fhir/R4/diagnosticreport.html), whose acceptable datatypes are Reference(Practitioner), Reference(PractitionerRole), Reference(Organization) or Reference(CareTeam):

  ```
  performer[Practitioner]
  ```

* Path to the Reference(US Core Organization) option of the performer element in [US Core DiagnosticReport Lab](http://hl7.org/fhir/us/core/StructureDefinition-us-core-diagnosticreport-lab.html), using the canonical URL:

  ```
  performer[http://hl7.org/fhir/us/core/StructureDefinition/us-core-organization]
  ```

* The same path, using the id of the US Core Organization profile instead of its canonical URL:

  ```
  performer[us-core-organization]
  ```

#### Data Type Choice [x] Paths

FHIR represents an element with a choice of datatypes using the style foo[x]. For example, Condition.onset[x] can be a dateTime, Age, Period, Range or string. In FSH, [as in FHIR](http://hl7.org/fhir/R4/formats.html#choice), to refer to one of these datatypes, replace the `[x]` with the datatype name, capitalizing the first letter. For Condition.onset[x], the individual choices are onsetDateTime, onsetAge, onsetPeriod, onsetRange, and onsetString.

> **Note:** foo[x] choices are NOT represented as foo[dateTime], foo[Period], etc.

**Examples:**

* The path to the string datatype of Observation.value[x]:

  ```
  valueString
  ```

* The path to the Reference datatype choice of Medication.ingredient.item[x]:

  ```
  ingredient.itemReference
  ```

* Given that the itemReference has further choices Reference(Substance) or Reference(Medication), the path to the Reference(Substance) choice:

  ```
  ingredient.itemReference[Substance]
  ```

#### Array Paths using Numerical Indices

FSH uses square-bracketed integers to address elements in arrays. Arrays are referenced using 0-based indices, meaning that the first array element is referenced by `[0]`, the second element is referenced by `[1]`, etc. Arrays with missing elements (gaps in the sequence of indices) are not allowed. If the index is omitted, the first element of the array (`[0]`) is assumed.

Numerical indices apply only to arrays that can be populated with concrete values, e.g., in instances or in metadata elements of SDs. Numerical indices SHOULD NOT be used in Profiles, because arrays in profiles are not populated _per se_, and only contain constraints on the values that can appear in instances. The exception is setting metadata properties of SDs using [caret paths](#caret-paths), since these are actually concrete properties of a StructureDefinition instance. The preferred way to reference arrays in Profiles is by [slice name](#sliced-array-paths).

**Examples:**

* Path to first element in Patient.name field:

  ```
  name[0]
  ```

* Path to a patient's second given name in the first name field:

  ```
  name[0].given[1]
  ```

* An equivalent path expression, since the zero index is assumed when omitted:

  ```
  name.given[1]
  ```

#### Array Paths using Soft Indexing

Numerical array references can be replaced with so-called "soft indexing." In soft indexing, `[+]` is used to increment the last referenced index by 1, and `[=]` is used to reference the same index that was last referenced. When an array is empty, `[+]` refers to the first element (`[0]`). FSH also allows for soft and numerical indexes to be mixed.

Similar to numerical indices, soft indices should only be used when populating or referencing arrays in instances (including definitional instances accessed via [caret paths](#caret-paths)).

Soft indexing is useful when populating long array, allowing elements to be inserted, deleted, or moved without updating numerical indices. Complex resources such as Bundle and CapabilityStatement have arrays may contain scores of items. Managing indexes can become quite tedious and error prone when adding or removing items in the middle of a long list.

Another use case for soft indexing involves [parameterized rule sets](#parameterized-rule-sets). Rule sets provide a way to avoid repeating the same pattern of rules when populating an array ([see example](#parameterized-rule-sets)).

For nested arrays, several sequences of soft indexes can run simultaneously. The sequence of indices at different levels of nesting are independent and do not interact with one another. However, when arrays are nested, incrementing the index of the parent (outer) array advances to the next child (inner) array, so the next child element referred to by `[+]` is at index [0]. (An analogy is using a keyboard's Enter key to advance to a new line that initially has no characters.)

-**Examples:**

* Assign multiple names in an instance of a Patient using soft indices:

  ```
  * name[+].given = "Robert"
  * name[=].family = "Smith"
  * name[+].given = "Rob"
  * name[=].family = "Smith"
  * name[+].given = "Bob"
  * name[=].family = "Smith"
  ```

  is equivalent to:

  ```
  * name[0].given = "Robert"
  * name[0].family = "Smith"
  * name[1].given = "Rob"
  * name[1].family = "Smith"
  * name[2].given = "Bob"
  * name[2].family = "Smith"
  ```

* Add second given name to the example above, using soft indexing:

  ```
  * name[+].given[+] = "Robert"
  * name[=].given[+] = "David"
  * name[=].family = "Smith"
  * name[+].given[+] = "Rob"
  * name[=].given[+] = "Dave"
  * name[=].family = "Smith"
  * name[+].given[+] = "Bob"
  * name[=].given[+] = "Davey"
  * name[=].family = "Smith"
  ```

  is equivalent to:

  ```
  * name[0].given[0] = "Robert"
  * name[0].given[1] = "David"
  * name[0].family = "Smith"
  * name[1].given[0] = "Rob"
  * name[1].given[1] = "Dave"
  * name[1].family = "Smith"
  * name[2].given[0] = "Bob"
  * name[2].given[1] = "Davey"
  * name[2].family = "Smith"
  ```


#### Sliced Array Paths

FHIR allows lists in profiles and extensions to be compartmentalized into sublists called "slices". To address a specific slice, follow the path with square brackets containing the slice name. Since slices are most often unordered, slice names rather than array indices SHOULD be used. Note that slice names (like other [FSH item names](#item-names)) cannot be purely numerical, so slice names cannot be confused with indices.

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

#### Extension Paths

Extension arrays are found at the root level of every resource, nested inside every element, and recursively inside each extension. Extensions are elements in these arrays. When an extension is added to an extension array, a name (technically, a slice name) is assigned. Extensions can be identified by that slice name, or the extension's URL.

The path to an extension is constructed by combining the path to the extension array with a reference to slice name in square brackets:

```
<Extension>[{name or id or URL}]
```

For locally-defined extensions, using the slice name is the simplest choice. For externally-defined extensions, the canonical URL can be easier to find than the slice name.

> **Note:** The same path construction applies to modifierExtension arrays; simply replace `extension` with `modifierExtension`.

**Examples:**

* Path to the value of the birth sex extension in US Core Patient, whose local name is birthsex:

  ```
  extension[birthsex].valueCode
  ```

* Path to an extension on the telecom element of Patient, assuming the extension has been given the local slice name directMailAddress:

  ```
  telecom.extension[directMailAddress]
  ```

* Same as the previous example, but using the canonical URL for the direct mail extension defined in US Core:

  ```
  telecom.extension[http://hl7.org/fhir/us/core/StructureDefinition/us-core-direct]
  ```

* Path to the Coding datatype of the value[x] in the nested extension ombCategory under the ethnicity extension in US Core, using the slice names of the extensions:

  ```
  extension[ethnicity].extension[ombCategory].valueCoding
  ```

* Path to the Coding value in second element in the nested extension array named detailed, under USCoreEthnicity extension:

  ```
  extension[ethnicity].extension[detailed][1].valueCoding
  ```

#### Caret Paths

FSH uses the caret (^) symbol to access to elements of definitional item corresponding to the current context. Caret paths can be used in the following FSH items: Profile, Extension, ValueSet, and CodeSystem. Caret syntax SHOULD be reserved for situations not addressed through [FSH Keywords](#fsh-items) or external configuration files. Examples of elements that require the caret syntax include StructureDefinition.experimental, StructureDefinition.abstract and ValueSet.purpose. The caret syntax also provides a simple way to set metadata attributes in the ElementDefinitions that comprise the snapshot and differential tables (e.g., short, meaningWhenMissing, and various [slicing discriminator properties](#step-1-specify-the-slicing-logic)).

For a path to an element of a StructureDefinition, excluding the differential and snapshot, use the following syntax inside a Profile or Extension:

```
^<element of StructureDefinition>
```

For a path to an element of an ElementDefinition within a StructureDefinition, use this syntax:

```
<element in Profile> ^<element of corresponding ElementDefinition>
```

**Note:** There is a required space before the ^ character.

A special case of the ElementDefinition path is setting properties of the first element of the differential (i.e., StructureDefinition.differential.element[0]). This element always refers to the profile or standalone extension itself. Since this element does not correspond to a named element appearing in an instance, we use the dot or full stop (`.`) to represent it. (The dot symbol is often used to represent "current context" in other languages.) It is important to note that the "self" elements are not the elements of a StructureDefinition directly, but elements of the first ElementDefinition contained in the StructureDefinition. The syntax is:

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

### FSH Items

#### Structure of FSH Items

A central purpose of FSH is to create and define items that represent and can be translated into FHIR artifacts. The general pattern used to define an item in FSH is:

* Declaration statement
* Keyword statements
* Rule statements

While every FSH item requires a declaration, depending on the item type, keyword statements and rules may not be required, or even permitted.

##### Declaration Statements

Declaration statements follow the syntax:

```
{declaration}: {value}
```

A declaration is always the first statement in an item definition. The value represents the item's name or identifier (id), depending on the item's type, as shown in the table below:

<div class = "shadeRow6 shadeRow9">

| Declaration | Purpose | Data Type |
|----------|---------|---------|
| [Alias](#defining-aliases)           | Declares an alias for a URL or OID | expression |
| [CodeSystem](#defining-code-systems) | Declares a new code system | name |
| [Extension](#defining-extensions)    | Declares a new extension | name |
| [Instance](#defining-instances)      | Declares a new instance | id |
| [Invariant](#defining-invariants)    | Declares a new invariant | id |
| {%include tu.html%} [Logical](#defining-logical-models) | Declares a new logical model | name |
| [Mapping](#defining-mappings)        | Declares a new mapping | id |
| [Profile](#defining-profiles)        | Declares a new profile | name |
| {%include tu.html%} [Resource](#defining-resources) | Declares a new resource | name |
| [RuleSet](#defining-rule-sets)       | Declares a set of rules that can be reused | name |
| [ValueSet](#defining-value-sets)     | Declares a new value set | name |
{: .grid }

</div>

##### Keyword Statements

Keyword statements directly follow the declaration and precede any rules. Keyword statements follow the syntax:

```
{keyword}: {value}
```

The following keywords (case-sensitive) are defined:

| Keyword | Purpose | Data Type |
|----------|---------|---------|
| Description | Provides a human-readable description | string or markdown |
| Expression | Provides a FHIR path expression in an invariant | FHIRPath string |
| Id | Provides a identifier for an item | id |
| InstanceOf | Names the profile or resource an instance instantiates | name or id or url |
| Parent | Names the base class for a profile or extension | name or id or url |
| Severity | Specifies whether violation of an invariant represents an error or a warning | code |
| Source | Provides the profile the mapping applies to | name |
| Target | Provides the standard being mapped to | uri |
| Title | Provides a short human-readable name | string |
| Usage | Specifies how an instance is intended to be used in the IG | code |
| XPath | Provides the XPath in an invariant | XPath string |
{: .grid }

In the above, `name` refers to a valid [item name](#item-names) and `id` to an [item identifier](#item-identifiers).

Depending on the type of item being defined, keywords may be required, suggested, optional, or prohibited. The following table shows the relationship between declarations and keywords:

<div class="shadeRow6 shadeRow9">

|         Keyword →<br/>Declaration ↓ | Id | Description | Title | Parent | InstanceOf | Usage | Source | Target | Severity | XPath | Expression |
|----------------------------------------|-----|-------------|-------|--------|------------|-------|--------|--------|----------|-------|------------|
[Alias](#defining-aliases)               |     |             |       |        |            |       |        |        |          |       |            |
[Code System](#defining-code-systems)    |  S  |     S       |   S   |        |            |       |        |        |          |       |            |
[Extension](#defining-extensions)        |  S  |     S       |   S   |   O    |            |       |        |        |          |       |            |
[Instance](#defining-instances)          |     |     S       |   S   |        |     R      |   O   |        |        |          |       |            |
[Invariant](#defining-invariants)        |     |     R       |       |        |            |       |        |        |    R     |    O  |    O       |
{%include tu.html%} [Logical](#defining-logical-models)  |  S  |     S       |   S   |   O    |            |       |        |        |          |       |            |
[Mapping](#defining-mappings)            |     |     S       |   S   |        |            |       |   R    |   R    |          |       |            |
[Profile](#defining-profiles)            |  S  |     S       |   S   |   R    |            |       |        |        |          |       |            |
{%include tu.html%}  [Resource](#defining-resources)    |  S  |     S       |   S   |   O    |            |       |        |        |          |       |            |
[Rule Set](#defining-rule-sets)          |     |             |       |        |            |       |        |        |          |       |            |
[Value Set](#defining-value-sets)        |  S  |     S       |   S   |        |            |       |        |        |          |       |            |
{: .grid }

</div>

**KEY:**  R = required, S = suggested (SHOULD be used), O = optional, blank = prohibited

##### Rule Statements

A number of rules may follow the keyword statements. The grammar and meaning of different rule types are discussed in the [FSH Rules](#fsh-rules) section. Without defining the rule types here, the following table shows the applicability of rule types to item types:

<div class = "shadeCol7 shadeCol10 shadeRow1 shadeRow15 unshadeHead unshadeHead7 unshadeHead10">

|              Item →<br/>Rule Type ↓ | [Alias](#defining-aliases) | [Code System](#defining-code-systems) | [Extension](#defining-extensions) | [Instance](#defining-instances) | [Invariant](#defining-invariants) | [Logical](#defining-logical-models)<br/>{%include tu.html%} | [Mapping](#defining-mappings) | [Profile](#defining-profiles) | [Resource](#defining-resources)<br/>{%include tu.html%} | [Rule Set](#defining-rule-sets) | [Value Set](#defining-value-sets) |
|--------------------------------------------------------------------|-------|-------------|-----------|----------|-----------|---------|---------|---------|----------|----------|-----------|
| {%include tu.html%} [Add Element](#addelement-rules)               |       |             |           |          |           | Y       |         |         | Y        | Y        |           |
| [Assignment](#assignment-rules)                                    |       | C           | Y         | Y        |           | C       |         | Y       | C        | Y        | C         |
| [Binding](#binding-rules)                                          |       |             | Y         |          |           | A       |         | Y       | A        | Y        |           |
| [Cardinality](#cardinality-rules)                                  |       |             | Y         |          |           | A       |         | Y       | A        | Y        |           |
| [Contains (inline extensions)](#contains-rules-for-extensions)     |       |             | Y         |          |           |         |         |         |          | Y        |           |
| [Contains (standalone extensions)](#contains-rules-for-extensions) |       |             | Y         |          |           |         |         | Y       |          | Y        |           |
| [Contains (slicing)](#contains-rules-for-slicing)                  |       |             | Y         |          |           |         |         | Y       |          | Y        |           |
| [Exclude](#exclude-rules)                                          |       |             |           |          |           |         |         |         |          | Y        | Y         |
| [Flag](#flag-rules)                                                |       |             | Y         |          |           | L       |         | Y       | L        | Y        |           |
| [Include](#include-rules)                                          |       |             |           |          |           |         |         |         |          | Y        | Y         |
| [Insert](#insert-rules)                                            |       | Y           | Y         | Y        |           | Y       | Y       | Y       | Y        | Y        | Y         |
| [Local Code](#local-code-rules)                                   |       | Y           |           |          |           |         |         |         |          | Y        |           |
| [Mapping](#mapping-rules)                                          |       |             |           |          |           |         | Y       |         |          | Y        |           |
| [Obeys](#obeys-rules)                                              |       |             | Y         |          |           | Y       |         | Y       | Y        | Y        |           |
| {%include tu.html%} [Path](#path-rules)                            |       |             | Y         | Y        |           | Y       |         | Y       | Y        | Y        |           |
| [Type](#type-rules)                                                |       |             | Y         |          |           | A       |         | Y       | A        | Y        |           |
{: .grid }

</div>

**KEY:** Y = Rule type can be used, L = All flags except must support (MS) are supported, C = Assignments can be applied only to [caret paths](#caret-paths), A = Rules can only be applied to elements defined by the item (not inherited elements), blank = prohibited.

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

In contrast with other names in FSH (for profiles, extensions, etc.), alias names optionally begin with a dollar sign ($). If you define an alias with a leading $, implementations can more easily check for misspellings. For example, if you choose the alias name $RaceAndEthnicity and accidentally type $RaceEthnicity, implementations can easily detect there is no alias by that name. Without the $ sign, implementations are forced to look through FHIR Core and all external implementation guides for anything with that name or id, or in some contexts, assume it is a new item, with unpredictable results.

**Examples:**

  ```
  Alias: $SCT = http://snomed.info/sct
 
  Alias: $RaceAndEthnicityCDC = urn:oid:2.16.840.1.113883.6.238
 
  Alias: obs-cat = http://terminology.hl7.org/CodeSystem/observation-category
  ```

#### Defining Code Systems

It is sometimes necessary to define new codes inside an IG that are not drawn from an external code system (aka _local codes_). Local codes MUST be defined in the context of a code system.

> **Note:** Defining local codes is not best practice, since those codes will not be part of recognized terminology systems. However, when existing vocabularies do not contain necessary codes, it might be necessary to define them -- at least temporarily -- as local codes.

Creating a code system uses the keywords `CodeSystem`, `Id`, `Title` and `Description`. Codes are then added, one per rule, using the following syntax:

```
* #{code} "{display string}" "{definition string}"
```

**Notes:**

* There MUST NOT be a code system before the hash sign `#`. The code system name is given by the `CodeSystem` keyword.
* The definition of the term, provided as the second string following the code, is RECOMMENDED but not required.
* Do not use the word `include` in a code system rule. The rule is creating a brand new code, not including an existing code defined elsewhere.
* Metadata attributes for individual concepts, such as designation, can be defined using [caret paths](#caret-paths).
* [Assignment rules](#assignment-rules) can be applied to CodeSystems, but only in the context of caret paths (to set metadata).

**Example:**

* Define a code system for yoga poses:

  ```
  CodeSystem:  YogaCS
  Id: yoga-code-system
  Title: "Yoga Code System"
  Description:  "A brief vocabulary of yoga-related terms."
  * #Sirsasana "Headstand"
      "An pose that involves standing on one's head."
  * #Halasana "Plough Pose"
      "A pose from supine position, bringing legs up and over until the toes touch the ground behind the head."
  * #Matsyasana "Fish Pose"
      "A pose from supine position, arching the back and pressing the chest upwards."
  * #Bhujangasana "Cobra Pose"
      "A pose starting from prone position with hands pushing the shoulders upward, with legs and hips remaining on the ground."
  ```

##### Defining Code Systems with Hierarchical Codes

{%include tu-div.html%}
Child codes can also be defined, resulting in a hierarchical structure of codes within a code system. To define such codes, list all of the preceding codes in the hierarchy before the new code:

```
* #{parent code} "{display string}" "{definition string}"
* #{parent code} #{child code} "{display string}" "{definition string}"
```

Another way to define child codes is to indent (by two spaces per level) their definitions after their parent's code definition:

```
* #{parent code} "{display string}" "{definition string}"
  * #{child code} "{display string}" "{definition string}"
```

Additional levels to any depth can be added in the same manner.

> **Note:** When defining hierarchical codes, parent codes must be defined before their children.

**Examples:**

  * Define a code system for anteater taxonomy with hierarchical codes:

  ```
  CodeSystem: AnteaterCS
  Id: anteater-code-system
  Title: "Anteater Code System"
  * #Anteater "Anteater" "Members of suborder Vermilingua, distinguished by its propensity to eat ants"
  * #Anteater #Tamandua "Members of genus Tamandua" "The Tamandua genus of anteaters, mainly found in forests and grasslands"
  * #Anteater #Tamandua #NorthernTamandua "Northern Tamandua" "The northern species of Tamandua anteaters"
  * #Anteater #Tamandua #SouthernTamandua "Southern Tamandua" "The southern species of Tamandua anteaters"
  * #Anteater #GiantAnteater "Giant Anteater" "The Giant Anteater, typically 6 - 7 feet in length"
  ```

  * Define the same code system using indentation instead of explicit parents:

  ```
  CodeSystem: AnteaterCS
  Id: anteater-code-system
  Title: "Anteater Code System"
  * #Anteater "Anteater" "Members of suborder Vermilingua, distinguished by its propensity to eat ants"
    * #Tamandua "Members of genus Tamandua" "The Tamandua genus of anteaters, mainly found in forests and grasslands"
      * #NorthernTamandua "Northern Tamandua" "The northern species of Tamandua anteaters"
      * #SouthernTamandua "Southern Tamandua" "The southern species of Tamandua anteaters"
    * #GiantAnteater "Giant Anteater" "The Giant Anteater, typically 6 - 7 feet in length"
  ```

##### Code Metadata

Within a CodeSystem definition, the caret syntax can be used to set metadata attributes for individual concepts (e.g., elements of CodeSystem.concept.designation and CodeSystem.concept.property).

For a path to a code within a code system, use this syntax:

```
#{code} ^<element of corresponding concept>
```

**Examples:**

* The set the to the designation use of the code `#active` in the [Condition Clinical Status value set](https://terminology.hl7.org/ValueSet-condition-clinical.html):

  ```
  * #active ^designation[0].use = $SCT#900000000000003001 "Fully specified name"
  ```

* The path to the property code of #recurrence code, a child of the #active code in the [Condition Clinical Status value set](https://terminology.hl7.org/ValueSet-condition-clinical.html):

  ```
  #active #recurrence ^property[0].code
  ```

</div>

#### Defining Extensions

Defining extensions is similar to defining a profile, except that the parent of an extension is not required. Extensions can also inherit from other extensions, but if the `Parent` keyword is omitted, the parent is assumed to be FHIR's [Extension element](https://www.hl7.org/fhir/R4/extensibility.html#extension).

All extensions have the same structure, but extensions can either have a value (i.e. a value[x] element) or sub-extensions, but not both. To create a simple extension, the value[x] element should be constrained. To create a complex extension, the extension array of the extension MUST be sliced (see [Contains Rules for Extensions](#contains-rules-for-extensions)).

Since simple and complex extensions are mutually-exclusive, FSH implementations SHOULD set the value[x] cardinality to 0..0 if sub-extensions are specified, set extension cardinality to 0..0 if constraints are applied to value[x], and signal an error if value[x] and extensions are simultaneously specified.

Rules types that apply to Extensions are: [Assignment](#assignment-rules), [Binding](#binding-rules), [Cardinality](#cardinality-rules), [Contains (standalone extensions)](#contains-rules-for-extensions), [Contains (inline extensions)](#contains-rules-for-extensions)[Contains (slicing)](#contains-rules-for-slicing), [Flag](#flag-rules), [Insert](#insert-rules), [Obeys](#obeys-rules), [Path](#path-rules), and [Type](#type-rules).

**Examples:**

* How the [US Core BirthSex extension](http://hl7.org/fhir/us/core/StructureDefinition-us-core-birthsex.html) (a simple extension) would be defined in FSH:

  ```
  Extension: USCoreBirthSexExtension
  Id:   us-core-birthsex
  Title:  "US Core Birth Sex Extension"
  Description: "A code classifying the person's sex assigned at birth as specified by the [Office of the National Coordinator for Health IT (ONC)](https://www.healthit.gov/newsroom/about-onc). This extension aligns with the C-CDA Birth Sex Observation (LOINC 76689-9)."
  // publisher, contact, and other metadata could be defined here using caret syntax (omitted)
  * value[x] only code
  * valueCode from http://hl7.org/fhir/us/core/ValueSet/birthsex (required)
  ```

* How [US Core Ethnicity extension](https://www.hl7.org/fhir/us/core/StructureDefinition-us-core-ethnicity.html) (a complex extension with inline sub-extensions) would be defined in FSH:

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
  * extension[ombCategory].valueCoding from OmbEthnicityCategories (required) // OmbEthnicityCategories is a value set defined by US Core
  * extension[detailed] ^short = "Extended ethnicity codes"
  * extension[detailed].value[x] only Coding
  * extension[detailed].valueCoding from DetailedEthnicity (required) // DetailedEthnicity is defined in US Core
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

Instances are defined using the keywords `Instance`, `InstanceOf`, `Title`, `Usage` and `Description`. The `InstanceOf` is required, and plays a role analogous to the `Parent` of a profile. The value of `InstanceOf` can be the name, id, or url for any profile, resource, or complex datatype defined internally or externally.

The `Usage` keyword specifies how the instance should be presented in the IG:

* `Usage: #example` (default) means the instance is intended as an illustration of a profile, and will be presented on the Examples tab for the corresponding profile.
* `Usage: #definition` means the instance is a conformance item that is an instance of a resource such as a search parameter, operation definition, or questionnaire. These items will be presented on their own IG page.
* `Usage: #inline` means the instance should not be instantiated as an independent resource, but can appear as part of another instance (for example, in any [DomainResource](https://www.hl7.org/fhir/domainresource.html) in the `contained` array, or in a [Bundle](https://www.hl7.org/fhir/bundle.html) in the `entry.resource` array.

Instances inherit values from their StructureDefinition (i.e. assigned codes, extensions) if those values are required. Assignment rules are used to set additional values.

Rules types that apply to Instances are: [Assignment](#assignment-rules), [Insert](#insert-rules), and [Path](#path-rules). No other rule types are allowed.

**Examples:**

* Define an example instance of US Core Patient, with name, birthDate, race, and ethnicity:

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

  This instance would be incorporated into a DomainResource with a statement such as:

  ```
  *  contained[0] = DrDavidAnydoc
  ```

* Define an `#inline` Patient instance, and then use that instance in a Condition resource, inlining it as a contained resource:

  ```
  Instance: EveAnyperson
  InstanceOf: Patient
  Usage: #inline // #inline means this instance should not be exported as a separate example
  * name.given[0] = "Eve"
  * name.family = "Anyperson"

  Instance: EvesCondition
  InstanceOf: Condition
  Usage: #example
  Description: "An example that uses contained"
  * contained[0] = EveAnyperson // this inlines EveAnyperson definition here
  * code = http://foo.org#bar
  * subject = Reference(EveAnyperson) // this automatically creates the relative reference correctly
  ```
  This results in:

  ```json
  {
    "resourceType": "Condition",
    "id": "EvesCondition",
    "contained": [
      {
        "resourceType": "Patient",
        "id": "EveAnyperson",
        "name": [
          {
            "given": [
              "Eve"
            ],
            "family": "Anyperson"
          }
        ]
      }
    ],
    "code": {
      "coding": [
        {
          "code": "bar",
          "system": "http://foo.org"
        }
      ]
    },
    "subject": {
      "reference": "#EveAnyperson"
    }
  }
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
  * code = $SCT#254637007 "Non-small cell lung cancer (disorder)"
  * extension[HistologyMorphologyBehavior].valueCodeableConcept = $SCT#35917007 "Adenocarcinoma"
  * bodySite = $SCT#39607008 "Lung structure (body structure)"
  * bodySite.extension[Laterality].valueCodeableConcept = $SCT#7771000 "Left (qualifier value)"
  * subject = Reference(mCODEPatientExample01)
  * onsetDateTime = "2019-04-01"
  * asserter = Reference(mCODEPractitionerExample01)
  * stage.summary = $AJCC#3C "IIIC"
  * stage.assessment = Reference(mCODETNMClinicalStageGroupExample01)
  ```

##### Defining Instances of Other Conformance Resources

The FSH language is designed to support creation of SDs for Profiles and Extensions, ValueSets, and CodeSystems. Tools like [SUSHI](https://fshschool.org/docs/sushi/) address the creation of the ImplementationGuide resource, which is important for producing an IG. However, there are other [conformance resources](https://www.hl7.org/fhir/R4/conformance-module.html) involved with IG creation not explicitly supported by FSH. These include [CapabilityStatement](https://www.hl7.org/fhir/R4/capabilitystatement.html), [OperationDefinition](https://www.hl7.org/fhir/R4/operationdefinition.html), [SearchParameter](https://www.hl7.org/fhir/R4/searchparameter.html), and [CompartmentDefinition](https://www.hl7.org/fhir/R4/compartmentdefinition.html).

These conformance resources are created using FSH instance grammar. For example, to create a CapabilityStatement, use `InstanceOf: CapabilityStatement`. The CapabilityStatement is populated using assignment statements.

#### Defining Invariants

Invariants are defined using the keywords `Invariant`, `Description`, `Expression`, `Severity`, and `XPath`. The keywords correspond directly to elements in ElementDefinition.constraint. An invariant definition cannot have rules. Invariants are incorporated into profiles, extensions, {%include tu.html%}logical models, or {%include tu.html%} resources via [obeys rules](#obeys-rules).

| Keyword | Usage | Corresponding element in ElementDefinition | Data Type | Required |
|-------|------------|--------------|-------|----|
| Invariant | Identifier for the invariant | constraint.key | id | yes |
| Description | Human description of constraint | constraint.human | string  | yes |
| Expression | FHIRPath expression of constraint | constraint.expression | FHIRPath string | no |
| Severity | Either #error or #warning, as defined in [ConstraintSeverity](https://www.hl7.org/fhir/R4/valueset-constraint-severity.html) | constraint.severity | code | yes |
| XPath | XPath expression of constraint | constraint.xpath | XPath string | no |
{: .grid }

**Example:**

* Define an invariant found in US Core using FSH:

  ```
  Invariant:  us-core-8
  Description: "Patient.name.given or Patient.name.family or both SHALL be present"
  Expression: "family.exists() or given.exists()"
  Severity:   #error
  XPath:      "f:given or f:family"
  ```

#### Defining Logical Models

{%include tu-div.html%}

Logical models allow authors to define new structures representing arbitrary content. While profiles can only add new properties as formal extensions, logical models can add properties as standard elements with standard paths. Logical models have many uses, [as described in the FHIR specification](http://hl7.org/fhir/R4/structuredefinition.html#logical), but are often used to convey domain-specific concepts in a user-friendly manner. Authors often use logical models as a basis for defining formal profiles in FHIR.

Logical models are defined in FSH using the keyword `Logical`. The keywords `Parent`, `Id`, `Title`, and `Description` are OPTIONAL.

If no `Parent` is specified, the empty [Base](http://hl7.org/fhir/2021May/types.html#Base) type is used as the default parent. Note that the Base type does not exist in FHIR R4, but both SUSHI and the FHIR IG Publisher have implemented special case logic to support Base in FHIR R4. Authors who wish to have top-level id and extension elements should use [Element](http://hl7.org/fhir/R4/element.html) as the logical model's parent instead. Authors may also specify another logical model, a resource, or a complex datatype as a logical model's parent.

Rules defining the logical model follow immediately after the keyword section. Rules types that apply to logical models are: [Add Element](#addelement-rules), [Assignment](#assignment-rules), [Binding](#binding-rules), [Cardinality](#cardinality-rules), [Flag](#flag-rules), [Insert](#insert-rules), [Obeys](#obeys-rules), [Path](#path-rules), and [Type](#type-rules). The following limitations apply:

* Binding, cardinality, and type rules can be applied only to elements defined by the item (not inherited elements).
* Flag rules cannot include MS flags.
* Assignment rules can only be used to set certain metadata via caret rules.  

The latter restrictions stem from FHIR's [interpretation of ElementDefinition for type definitions](http://hl7.org/fhir/R4/elementdefinition.html#interpretation). Assignments MUST NOT set elements listed as prohibited in that table. For example, the table indicates that assigning maxLength and mustSupport is prohibited.

**Example:**

* Define a logical model for a human and their family members:

  ```
  Logical:        Human
  Title:          "Human Being"
  Description:    "A member of the Homo sapien species."
  * name 0..* SU HumanName "Name(s) of the human" "The names by which the human is or has been known"
  * birthDate 0..1 SU dateTime "The date of birth, if known"
      "The date on which the person was born. Approximations may be used if exact date is unknown."
  * deceased[x] 0..1 SU boolean or dateTime or Age "Indication if the human is deceased"
      "An indication if the human has died. Boolean should not be used if date or age at death are known."
  * family 0..1 BackboneElement "Family" "Members of the human's immediate family."
    * mother 0..2 FamilyMember "Mother" "Biological mother, current adoptive mother, or both."
    * father 0..2 FamilyMember "Father" "Biological father, current adoptive father, or both."
    * sibling 0..* FamilyMember "Sibling" "Other children of the human's mother and/or father."

  Logical:        FamilyMember
  Title:          "Family Member"
  Description:    "A reference to a human's family member."
  * human 1..1 SU Reference(Human) "Family member" "A reference to the human family member"
  * biological 0..1 boolean "Biologically related?"
      "A family member may not be biologically related due to adoption, blended families, etc."
  ```

</div>

#### Defining Mappings

[Mappings](https://www.hl7.org/fhir/R4/mappings.html) are an optional part of a StructureDefinition, intended to help implementers understand the StructureDefinition in relation to other standards. While it is possible to define mappings using escape (caret) syntax, FSH provides a more concise approach. These mappings are informative and are not to be confused with the computable mappings provided by [FHIR Mapping Language](https://www.hl7.org/fhir/R4/mapping-language.html) and the [StructureMap resource](https://www.hl7.org/fhir/R4/structuremap.html).

To create a mapping, the keywords `Mapping`, `Source`, and `Target` are required, and `Title` and `Description` are OPTIONAL.

| Keyword | Usage | StructureDefinition element |
|-------|------------|--------------|
| Mapping | Appears first and provides a unique name for the mapping | n/a |
| Source | The name or id of the profile the mapping applies to | n/a |
| Target | The URL, URI, or OID for the specification being mapped to | mapping.uri |
| Id | An internal identifier for the target specification | mapping.identity |
| Title | A human-readable name for the target specification | mapping.name  |
| Description | Additional information such as version notes, issues, or scope limitations. | mapping.comment |
{: .grid }

The mappings themselves are declared in rules with the following syntaxes:

<pre><code>* -> "{map string}" <span class="optional">"{comment string}" #{mime-type code}</span>

* &lt;element&gt; -> "{map string}" <span class="optional">"{comment string}" #{mime-type code}</span>
</code></pre>

The first type of rule applies to mapping the profile as a whole to the target specification. The second type of rule maps a specific element to the target. No other types of rules are allowed.

The `map`, `comment`, and `mime-type` are as defined in FHIR and correspond to elements in [StructureDefinition.mapping](http://www.hl7.org/fhir/structuredefinition.html) and [ElementDefinition.mapping](https://www.hl7.org/fhir/R4/elementdefinition.html) (map corresponds to mapping.map, mime-type to mapping.language, and comment to mapping.comment). The mime type code MUST come from FHIR's [MimeType value set](https://www.hl7.org/fhir/R4/valueset-mimetypes.html). For further information, the reader is referred to the FHIR definitions of these elements.

>**Note:** Unlike setting the mapping.map directly in the StructureDefinition, mapping rules within a Mapping item do not include the name of the resource in the path on the left hand side.

A mapping can also have [insert rules](#insert-rules) and [path rules](#path-rules) applied to it.

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

To define a profile, the keywords `Profile` and `Parent` are required, and `Id`, `Title`, and `Description` are OPTIONAL. Rules defining the profile follow immediately after the keyword section.

Rules types that apply to Profiles are: [Assignment](#assignment-rules), [Binding](#binding-rules), [Cardinality](#cardinality-rules), [Contains (standalone extensions)](#contains-rules-for-extensions), [Contains (slicing)](#contains-rules-for-slicing), [Flag](#flag-rules), [Insert](#insert-rules), [Obeys](#obeys-rules), [Path](#path-rules), and [Type](#type-rules). Note that [inline extensions](#contains-rules-for-extensions) are not permitted in profiles.

**Example:**

* Define a profile for exposure to a pathogen:

  ```
  Profile:        KnownExposureSetting
  Parent:         Observation
  Id:             known-exposure-setting
  Title:          "Known Exposure Setting Profile"
  Description:    "The setting where an individual was exposed to a contagion."
  * code = $LNC#81267-7 // Setting of exposure to illness
  * value[x] only CodeableConcept
  * valueCodeableConcept from https://loinc.org/vs/LL3991-8 (extensible)
  ```

#### Defining Resources

{%include tu-div.html%}

Custom resources allow authors to define new structures representing arbitrary content. Resources are defined similar to [logical models](#defining-logical-models), but are intended to support data exchange using FHIR's RESTful API mechanisms. The capability to define resources may be used by HL7 to define core FHIR resources or by other organizations to define proprietary resources for their own internal use. Potentially, they also can be used to represent and maintain existing core FHIR resources.

Custom (non-HL7) resources should not be used for formal exchange between organizations; only standard FHIR resources and profiles should be used for inter-organizational exchange of health data. As such, the the FHIR IG publisher does not support including custom resources in implementation guides.

Resources are defined in FSH using the keyword `Resource`. The keywords `Parent`, `Id`, `Title`, and `Description` are OPTIONAL.

Only [DomainResource](http://hl7.org/fhir/R4/domainresource.html) and [Resource](http://hl7.org/fhir/R4/resource.html) are allowed as parents of a resource. If no `Parent` is specified, DomainResource is used as the default parent.

Rules defining the resource follow immediately after the keyword section. Rules types that apply to resources are: [Add Element](#addelement-rules), [Assignment](#assignment-rules), [Binding](#binding-rules), [Cardinality](#cardinality-rules), [Flag](#flag-rules), [Insert](#insert-rules), [Obeys](#obeys-rules), [Path](#path-rules), and [Type](#type-rules). The following limitations apply:

* Binding, cardinality, and type rules can be applied only to elements defined by the item (not inherited elements).
* Flag rules cannot include MS flags.
* Assignment rules can only be used to set certain metadata via caret rules.  

The latter restrictions stem from FHIR's [interpretation of ElementDefinition for type definitions](http://hl7.org/fhir/R4/elementdefinition.html#interpretation). Assignments MUST NOT set elements that are prohibited in that table. For example, the table indicates that setting maxLength or mustSupport is prohibited.

**Example:**

* Define a resource representing an emergency vehicle, using line spacing to make the definition easier to read:

  ```
  Resource:       EmergencyVehicle
  Title:          "Emergency Vehicle"
  Description:    "An emergency vehicle, such as an ambulance or fire truck."
  * identifier 0..* SU Identifier
      "Identifier(s) of the vehicle"
      "Vehicle identifiers may include VINs and serial numbers."
  * make 0..1 SU Coding
      "The vehicle make"
      "The vehicle make, e.g., Chevrolet."
  * make from EmergencyVehicleMake (extensible)
  * model 0..1 SU Coding
      "The vehicle model"
      "The vehicle model, e.g., G4500."
  * model from EmergencyVehicleModel (extensible)
  * year 0..1 SU positiveInt
      "Year of manufacture"
      "The year the vehicle was manufactured"
  * servicePeriod 0..1 Period
      "When the vehicle was in service"
      "Start date and end date (if applicable) when the vehicle operated."
  * operator 0..* Reference(Organization or Practitioner or PractitionerRole)
      "The operator"
      "The organization or persons repsonsible for operating the vehicle"
  * device 0..* Reference(Device)
      "Devices on board"
      "Devices on board the vehicle."
  ```

</div>

#### Defining Rule Sets

Rule sets provide the ability to define a group rules as an independent entity. Through [insert rules](#insert-rules), they can be incorporated into a compatible target. FSH behaves as if the rules in a rule set are copied into the target. As such, the inserted rules have to make sense where they are inserted. Once defined, a single rule set can be used in multiple places. If rules within a rule set are [indented](#indented-rules), the full paths are resolved from the indentation before the rule set is applied. Therefore, the indentation used in the rule set will not have any meaning in the target.

All types of rules can be used in rule sets, including [insert rules](#insert-rules), enabling the nesting of rule sets in other rule sets. However, circular dependencies are not allowed.

##### Simple Rule Sets

Simple rule sets are defined by using the keyword `RuleSet` and do not include parameters:

```
RuleSet: {name}
{rule1}
{rule2}
// More rules
```

**Example:**

* Define a rule set for metadata to be used in multiple profiles:

  ```
  RuleSet: RuleSet1
  * ^status = #draft
  * ^experimental = true
  * ^publisher = "Elbonian Medical Society"
  ```

##### Parameterized Rule Sets

{%include tu-div.html%}

Rule sets can also specify one or more parameters as part of their definition. Parameterized rule sets are defined by using the keyword `RuleSet` and include a comma-separated list of parameters enclosed in parentheses:

<pre><code>RuleSet: {name}(parameter1<span class="optional">, parameter2, parameter3...</span>)
{rule1}
{rule2}
// More rules
</code></pre>

Each parameter represents a value that can be substituted into the rules when the rule set is inserted. See the [insert rules](#insert-rules) section for details on how to pass parameter values when inserting a rule set. In the rules, the places where substitutions should occur are indicated by enclosing a parameter name in curly braces `{}`. Spaces are allowed inside the curly braces: `{parameter1}` and `{ parameter1 }` are both valid substitution sequences for a parameter named `parameter1`. A parameter may occur more than once in the rule set definition.

**Examples:**

* Define a rule set that contains the syntax for setting the context of an extension. This example also demonstrates the use of [soft indexing](#array-paths-using-soft-indexing). Note that the curly brackets in this example are literal, not syntax expressions:

  ```
  RuleSet: SetContext(path)
  * ^context[+].type = #element
  * ^context[=].expression = "{path}"
  ```

  This rule set can be applied to indicate an extension can only be applied to certain resources, for example:

  ```
  * insert SetContext(Procedure)
  * insert SetContext(MedicationRequest)
  * insert SetContext(MedicationAdministration)
  ```

  When the rule set is expanded, it translates to:

  ```
  * ^context[+].type = #element
  * ^context[=].expression = "Procedure"
  * ^context[+].type = #element
  * ^context[=].expression = "MedicationRequest"
  * ^context[+].type = #element
  * ^context[=].expression = "MedicationAdministration"
  ```

  Interpreting the soft indices, this is equivalent to:

   ```
  * ^context[0].type = #element
  * ^context[0].expression = "Procedure"
  * ^context[1].type = #element
  * ^context[1].expression = "MedicationRequest"
  * ^context[2].type = #element
  * ^context[2].expression = "MedicationAdministration"
  ``` 

* Define a parameterized rule set to define items in a Questionnaire:

  ```
  RuleSet: Question(linkId, text, type, repeats)
  * item[+].linkId = "{linkId}"
  * item[=].text = "{text}"
  * item[=].type = #{type}
  * item[=].repeats = {repeats}
  ```

  Apply the rule set to populate a Questionnaire:

  ```
  Instance: TravelRecord
  InstanceOf: Questionnaire
  // skip some
  * insert Question(tr1, When did you leave?, date, false)
  * insert Question(tr2, When did you return?, date, false)
  * insert Question(tr3, What countries did you visit?, code, true)
  ```

</div>

#### Defining Value Sets

A value set is a group of coded values representing acceptable values for a FHIR element whose datatype is code, Coding, CodeableConcept, Quantity, string, or url.

Value sets are defined using the declarative keyword `ValueSet`, with OPTIONAL keywords `Id`, `Title` and `Description`.

Codes MUST be taken from one or more terminology systems (also called code systems or vocabularies). Codes cannot be defined inside a value set. If necessary, [you can define your own code system](#defining-code-systems).

The contents of a value set are defined by a set of rules. There are four types of rules to populate a value set:

> **Note:** In value set rules, the word `include` is OPTIONAL.

| To include... | Syntax | Example |
|-------|---------|----------|
| A single code | <code>* <span class="optional">include</span> {Coding}</code> | `* $SCT#961000205106 "Wearing street clothes, no shoes"` |
| All codes from another value set | <code>* <span class="optional">include</span> codes from valueset {ValueSet}</code> | `* include codes from valueset http://hl7.org/fhir/ValueSet/data-absent-reason` |
| All codes from a code system | <code>* <span class="optional">include</span> codes from system {CodeSystem}</code> | `* include codes from system http://snomed.info/sct` |
| Filtered codes from a code system | <code>* <span class="optional">include</span> codes from system {CodeSystem} where {filter1} <span class="optional">and {filter2}...</span></code> | `* include codes from system $SCT where concept is-a #254837009` |
{: .grid }

> **Note:** Filters are code system dependent. See [below](#filters) for further discussion.

Analogous rules can be used to leave out certain codes, with the word `exclude` replacing the word `include`:

| To exclude... | Syntax | Example |
|-------|---------|----------|
| A single code | `* exclude {Coding}` | `* exclude $SCT#961000205106 "Wearing street clothes, no shoes"` |
| All codes from another value set | `* exclude codes from valueset {ValueSet}` | `* exclude codes from valueset http://hl7.org/fhir/ValueSet/data-absent-reason` |
| All codes from a code system | `* exclude codes from system {CodeSystem}` | `* exclude codes from system http://snomed.info/sct` |
| Filtered codes from a code system | `* exclude codes from system {CodeSystem} where {filter}` | `* exclude codes from system $SCT where concept is-a #254837009` |
{: .grid }

In addition, [assignment rules](#assignment-rules) can be applied to value sets, but only in the context of caret paths (to set metadata).

##### Filters

A filter is a logical statement in the form `{property} {operator} {value}`, where operator is chosen from the [FilterOperator value set](http://hl7.org/fhir/ValueSet/filter-operator). Not all operators in that value set are valid for all code systems. The `property` and `value` are dependent on the code system. For choices for the most common code systems, see the [FHIR documentation on filters]( http://hl7.org/fhir/valueset.html#csnote).

**Examples** 

* Define a value set using [extensional](https://www.hl7.org/fhir/R4/valueset.html#int-ext) rules. This example demonstrates the optionality of the word `include`:

  ```
  ValueSet: BodyWeightPreconditionVS
  Title: "Body weight preconditions."
  Description:  "Circumstances for body weight measurement."
  * $SCT#971000205103 "Wearing street clothes with shoes"
  * $SCT#961000205106 "Wearing street clothes, no shoes"
  * $SCT#951000205108 "Wearing underwear or less"
  ```

* Define a value set using [intensional](https://blog.healthlanguage.com/the-difference-between-intensional-and-extensional-value-sets) rules:

  ```
  ValueSet: HistologyMorphologyBehaviorVS
  Id: mcode-histology-morphology-behavior-vs
  Title: "Histology Morphology Behavior Value Set"
  Description: "Codes representing the structure, arrangement, and behavioral characteristics of malignant neoplasms, and cancer cells.
  * include codes from system $SCT where concept is-a #367651003 "Malignant neoplasm of primary, secondary, or uncertain origin (morphologic abnormality)"
  * include codes from system $SCT where concept is-a #399919001 "Carcinoma in situ - category (morphologic abnormality)"
  * include codes from system $SCT where concept is-a #399983006 "In situ adenomatous neoplasm - category (morphologic abnormality)"
  * exclude codes from system $SCT where concept is-a #450893003 "Papillary neoplasm, pancreatobiliary-type, with high grade intraepithelial neoplasia (morphologic abnormality)"
  * exclude codes from system $SCT where concept is-a #128640002 "Glandular intraepithelial neoplasia, grade III (morphologic abnormality)"
  * exclude codes from system $SCT where concept is-a #450890000 "Glandular intraepithelial neoplasia, low grade (morphologic abnormality)"
  * exclude codes from system $SCT where concept is-a #703548001 "Endometrioid intraepithelial neoplasia (morphologic abnormality)"
  ```

> **Note:** Intensional and extensional forms can be used together in a single value set definition.

### FSH Rules

Rules are the mechanism in FSH for populating and constraining items by setting cardinality, applying flags, binding value sets, defining extensions, and more. Rules in FSH are distinguished by a leading asterisk (`*`) symbol:

```
* {rule statement}
```

The following restrictions apply to rules:

* All rules must begin on a new line.
* The asterisk symbol must be followed by at least one space.
* The asterisk cannot be preceded by non-whitespace characters on a line.
* The asterisk cannot be preceded by whitespace characters, <span style="background-color: #fff5e6;">unless using [indented rule syntax](#indented-rules).</span>

The following table is a summary of the rule syntax.

<div class = "shadeRow1 shadeRow15 unshadeHead">

| Rule Type | Syntax |
| --- | --- |
| {%include tu.html%} [Add Element](#addelement-rules) |<code>* &lt;element&gt; {card} <span class="optional">{flag(s)}</span> {dataype(s)} "{short}" <span class="optional">"{definition}"</span></code> |
| [Assignment](#assignment-rules) |<code>* &lt;element&gt; = {value} <span class="optional">(exactly)</span></code> |
| [Binding](#binding-rules) |<code>* &lt;bindable&gt; from {ValueSet} <span class="optional">({strength})</span></code> |
| [Cardinality](#cardinality-rules) |<code>* &lt;element&gt; <span class="optional">{min}</span>..<span class="optional">{max}</span> // min, max, or both must be present </code> |
| [Contains (inline extensions)](#contains-rules-for-extensions) | <code>* &lt;extension&gt; contains {Extension} {card} <span class="optional">{flag(s)} <br/>   and {Extension2} {card} {flag(s)}  <br/>   and {Extension3} {card} {flag(s)}...</span></code> |
| [Contains (standalone extensions)](#contains-rules-for-extensions) | <code>* &lt;extension&gt; contains {Extension} named {name} {card} <span class="optional">{flag(s)} <br/>   and {Extension2} named {name2} {card} {flag(s)}  <br/>   and {Extension3} named {name3} {card} {flag(s)}...</span></code> |
| [Contains (slicing)](#contains-rules-for-extensions) | <code>* &lt;array&gt; contains {name} {card} <span class="optional">{flag(s)} <br/>   and {name2} {card} {flag2} <br/>   and {name3} {card} {flag(s)}...</span></code> |
| [Exclude](#exclude-rules) |`* exclude {Coding}`<br/>`* exclude codes from valueset {ValueSet}`<br/><code>* exclude codes from system {CodeSystem} <span class="optional">where {filter1} and {filter2} and ...</span></code>|
| [Flag](#flag-rules) |`* <element(s)> {flag(s)}` |
| [Include](#include-rules) |<code>* <span class="optional">include</span> {Coding} <br/> * <span class="optional">include</span> codes from valueset {ValueSet} <br/> * <span class="optional">include</span> codes from system {CodeSystem} <span class="optional">where {filter1} and {filter2} and ...</span></code> |
| [Insert](#insert-rules)|<code>* insert {RuleSet}<span class="optional">({parameter1}, {parameter2}, ...)</span><br/>{%include tu.html%}* &lt;element&gt; insert {RuleSet}<span class="optional">({parameter1}, {parameter2}, ...)</span></code> |
| [Local Code](#local-code-rules) |<code>* #{code} "{display string}" <span class="optional">"{definition string}"</span></code> |
| [Mapping](#mapping-rules)|<code>* <span class="optional">&lt;element&gt;</span> -> "{map string}" <span class="optional">"{comment string}" #{mime-type code}</span></code> |
| [Obeys](#obeys-rules) | <code>* <span class="optional">&lt;element&gt;</span> obeys {Invariant} <span class="optional">and {Invariant2} and {Invariant3}...</span></code> |
| {%include tu.html%} [Path](#path-rules)  | `* <element>`|
| [Type](#type-rules) | <code>* &lt;element&gt; only {datatype(s)} |
{: .grid }

</div>

##### Rule Order

Rules SHALL be interpreted logically in a top-down manner. In many cases, the order of rules is flexible. However, there are some situations where FSH requires rules to appear in a certain order. For example, [slicing rules](#contains-rules-for-slicing) require that a slice MUST first be defined by a `contains` rule before the slice is referenced. Implementations MUST enforce rule-order requirements where they are specified in FSH.

Logical order dependencies can also arise. For example, in setting properties of a choice element (an element involving FHIR's `[x]` syntax), this order is problematic:

```
* value[x].unit 0..0
* value[x] only Quantity
```

but this order is acceptable:

```
* value[x] only Quantity
* value[x].unit 0..0
```

In the first approach, `value[x]` is not yet known to be restricted to a Quantity, so `value[x].unit` is ambiguous. In the second approach, `value[x]` is known to be a Quantity, so `value[x].unit` is unambiguous.

In cases with no explicit or logical restrictions on rule ordering, users MAY list rules in any order, bearing in mind that [insert rules](#insert-rules) expand into other rules that could have order constraints or logical ordering requirements.

It is possible for a user to specify contradictory rules, for example, two rules constraining the cardinality of an element to different values, or constraining an element to different datatypes. Implementations SHOULD detect such contradictions and issue appropriate warning or error messages.

#### Indented Rules

{%include tu-div.html%}

Indentation before a rule is used to set a context for the [path](#fsh-paths) on that rule. When one rule is indented below another, the full path of the indented rule or rules is obtained by pre-pending the path from the previous less-indented rule or rules. The level of indentation can be reduced to indicate that a rule should not use the context of the preceding rule. The full path of all rules is resolved from the context specified by indentation before any rules are applied.

Two spaces represent one level of indentation. This is not configurable. Rules can only be indented in increments of two spaces. They can be un-indented by any multiple of two spaces.

[Path rules](#path-rules) are rules containing only a path. They can be used to set a path as context for subsequent rules, without any other effect.

Some types of rules, for example [flag rules](#flag-rules), can involve multiple paths. If multiple paths are specified in a rule that sets context for subsequent rules (such as a flag rule with multiple targets), the last path is used as context. When multiple paths are specified in an indented rule, context is applied to all paths. See examples below for details.

There are some limitations on where indented rules can be used. Indented rules cannot appear below rules that do not specify a path. Rules that may omit an element path include top-level [obeys rules](#obeys-rules), top-level [caret paths](#caret-paths), [mapping rules](#defining-mappings), and [insert rules](#insert-rules).

When indented rules are combined with [soft indexing](#array-paths-using-soft-indexing) and a rule containing the increment operator `[+]` sets the path context for multiple subsequent rules, the index is only incremented once. On subsequent rules, the `[+]` is effectively replaced with `[=]`. See examples below for details.

**Examples:**

* Use indented rules to set cardinalities on name.family and name.given in a Patient resource:

  ```
  * name 1..1
    * family 1..1
    * given 1..1
  ```

  is equivalent to:

  ```
  * name 1..1
  * name.family 1..1
  * name.given 1..1
  ```

* Use a [path-only rule](#path-rules) to set context for subsequent rules:

  ```
  * name
    * family 1..1
    * given 1..1
  ```

  is equivalent to:

  ```
  * name.family 1..1
  * name.given 1..1
  ```

* Example of multi-level indented rules:

  ```
  * name MS
    * family MS
      * id MS
  ```

  is equivalent to:

  ```
  * name MS
  * name.family MS
  * name.family.id MS
  ```

* Example of multiple paths in an indented rule, with the context applied to all paths:

  ```
  * name
    * family and given MS
  ```

  is equivalent to:

  ```
  * name.family and name.given MS
  ```

* Example of multiple paths in a rule that sets context for subsequent rules, where the last path sets the context:

  ```
  * birthDate and name MS
    * family 1..1
  ```

  is equivalent to:

  ```
  * birthDate and name MS
  * name.family 1..1
  ```

* Example of reducing the level of indentation to remove the context of a preceding rule:

  ```
  * item[0]
    * linkId = "title"
    * type = #display
    * item[0]
      * linkId = "uniquearv_number"
      * type = #string
    * item[1]
      * linkId = "personal_info"
      * type = #group
  * status = #active
  ```

  is equivalent to:

  ```
  * item[0].linkId = "title"
  * item[0].type = #display
  * item[0].item[0].linkId = "uniquearv_number"
  * item[0].item[0].type = #string
  * item[0].item[1].linkId = "personal_info"
  * item[0].item[1].type = #group
  * status = #active
  ```

* Example of combining soft indexing with [indented rules](#indented-rules), where a rule with the increment operator `[+]` is used to set the context:

  ```
  * item[+]
    * linkId = "title"
    * type = #display
  ```

  is **not** equivalent to:

  ```
  * item[+].linkId = "title"
  * item[+].type = #display
  ```

  but is instead equivalent to:

  ```
  * item[+].linkId = "title"
  * item[=].type = #display
  ``` 

* Another example of soft indexing combined with indented paths, illustrating that when a rule containing `[+]` is used to set the context of multiple subsequent rules, the index is incremented only once:

  ```
  * rest.resource[+]
    * type = #Organization
    * interaction[+].code = #create
    * interaction[+].code = #update
    * interaction[+].code = #delete
  * rest.resource[+]
    * type = #Condition
    * interaction[+].code = #create
    * interaction[+].code = #update
  ```

  is equivalent to:

  ```
  * rest.resource[+].type = #Organization
  * rest.resource[=].interaction[+].code = #create
  * rest.resource[=].interaction[+].code = #update
  * rest.resource[=].interaction[+].code = #delete
  * rest.resource[+].type = #Condition
  * rest.resource[=].interaction[+].code = #create
  * rest.resource[=].interaction[+].code = #update
  ```

  is equivalent to:

  ```
  * rest.resource[0].type = #Organization
  * rest.resource[0].interaction[0].code = #create
  * rest.resource[0].interaction[1].code = #update
  * rest.resource[0].interaction[2].code = #delete
  * rest.resource[1].type = #Condition
  * rest.resource[1].interaction[0].code = #create
  * rest.resource[1].interaction[1].code = #update
  ```

* An error, attempting to use a rule without a path as context for an indented rule, since "obeys" does not imply a path:
  
  ```
  * obeys inv-1
    * family 1..1
  ```

</div>

#### AddElement Rules

{%include tu-div.html%}

Authors define logical models and resources by adding new elements to their definitions. The AddElement rule is only applicable for logical models and resources. It cannot be used when defining profiles or extensions.

The syntax of the rules to add a new element are as follows:

<pre><code>* &lt;element&gt; {min}..{max} <span class="optional">{flag(s)}</span> {datatype(s)} "{short}" <span class="optional">"{definition}"</span>
</code></pre>

where `{datatype(s)}` can be one of the following:

* A primitive or complex datatype name, or multiple datatypes, separated with `or`,
* References to one or more resources or profiles, `Reference({ResourceOrProfile(s)})`, separated with `or`
* Canonicals for one or more resources or profiles, `Canonical({ResourceOrProfile(s)})`, separated with `or`

Note the following:

* An AddElement rule **at minimum** must specify an element path, cardinality, type, and short description.
* Flags and longer definition are optional.
* The longer definition can also be a multi-line (triple quoted) string.
* If a longer definition is not specified, the element's definition will be set to the same text as the specified short description.
* When multiple types are specified, the element path must end with \[x] unless all types are References.

**Examples:**

* Add a string-typed element:

  ```
  * email 0..* string "The person's email addresses"
  ```

* Add a string-typed element with a summary flag and longer definition:

  ```
  * email 0..* SU string "The person's email addresses" "Email addresses by which the person may be contacted."
  ```

* Add a reference-typed element with a longer definition:

  ```
  * primaryClinicians 0..* Reference(Organization or Practitioner or PractitionerRole) "Primary clinicians"
      "The person's primary clinical organizations and practitioners"
  ```

* Add a choice element with a multi-line description using markdown syntax:

  ```
  * preferredName[x] 0..1 string or HumanName "The person's preferred name" """
      Sometimes patients prefer to be called by a name other than their _formal_ name. This may be:
      * their nickname
      * their middle name
      * their maiden name
      * etc.
      """
  ```

* Add a BackboneElement element to provide a structured set of elements in a logical model:

  ```
  * serviceAnimal 0..* BackboneElement "Service animals" "Animals trained to assist the person by performing certain tasks."
  * serviceAnimal.name 0..1 string "Name of service animal" "The name by which the service animal responds."
  * serviceAnimal.breed 1..* CodeableConcept "Breed of service animal" "The dominant breed or breeds of the service animal."
  * serviceAnimal.startDate 0..1 date "Date the service animal began work" "The date on which the service animal began working for the person."
  ```
  or the same set of rules using indentation to maintain the path context:
  ```
  * serviceAnimal 0..* BackboneElement "Service animals" "Animals trained to assist the person by performing certain tasks."
    * name 0..1 string "Name of service animal" "The name by which the service animal responds."
    * breed 1..* CodeableConcept "Breed of service animal" "The dominant breed or breeds of the service animal."
    * startDate 0..1 date "Date the service animal began work" "The date on which the service animal began working for the person."
  ```

</div>

#### Assignment Rules

Assignment rules follow this syntax:

```
* <element> = {value}
```

The left side of this expression follows the [FSH path grammar](#fsh-paths). The datatype on the right side MUST align with the datatype of the final element in the path. An assignment replaces any existing value assigned to the element.

##### Assigning Values versus Specifying Constraints

Assignment rules have two very different interpretations, depending on context:

* In instances, assignment rules set the **value** of the target element. Note that whenever an element is accessed via a [caret path](#caret-paths), it is actually accessing the definitional instance (for example, the StructureDefinition of the profile). Therefore, assignments involving caret paths also set the **value** of the target element.
* Assignment rules in profiles and extensions establish **constraints** on instances conforming to the profile or extension. The requirement is expressed as a pattern of values that must be present in the instance. In this context, and assignment rule does not set the value of the element, but instead, establishes a **constraint** on that value.

This is best illustrated by example. Consider the following assignment (assuming code is a CodeableConcept):

```
* code = https://loinc.org#69548-6
```

If this statement appears in an instance of an Observation, then the values of code.coding[0].system and code.coding[0].code will be set to https://loinc.org and 69548-6, respectively, in that Observation.

If the identical statement appears in a profile on Observation, it signals that the StructureDefinition should be configured such that the code element of a conformant instance must have a Coding with the system http://loinc.org and the code 69548-6. (In fact, the StructureDefinition does not even *have* a code element to populate.)

> **Note**: In the profiling context, typically only the system and code are important conformance criteria. If a display text is included, it will be part of the conformance criteria.

In the latter case of establishing a constraint in a profile, the constraint pattern considered "open" by default, in the sense that the element in question might have content in addition to the prescribed value, such as alternative codes in a CodeableConcept. If conformance to a profile requires a precise match to the pattern (which is rare), then the following syntax can be used:

```
* <element> = {value} (exactly)
```

Adding `(exactly)` indicates no additional values or extensions are allowed on the element. In general, using `(exactly)` is not the best option for interoperability because it creates conformance criteria that could be too tight, risking the rejection of valid, useful data. FSH offers this option primarily because exact value matching is used in some current IGs and profiles. For example, in a profile,

```
* code = $LNC#69548-6 (exactly)
```

means that a conforming instance must have the system http://loinc.org, the code 69548-6, and *must not have* a display text, additional codes, or extensions on the code element.

When assigning values to an instance, the `(exactly)` modifier has no meaning and SHOULD NOT be used. Implementations may ignore the modifier or signal an error.

##### Assignments with Primitive Data Types

**Examples:**

* Assignment of a code datatype:

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

* Assignment of a dateTime:

  ```
  * recordedDate = "2013-06-08T09:57:34.2112Z"
  ```

{%include tu-div.html%}

* Assignment of an integer64 (note: this datatype was introduced in FHIR v4.2.0): 

  ```
  * extension[my-extension].valueInteger64 = 1234567890
  ```

</div>

##### Assignments with the Coding Data Type

A FHIR Coding has five attributes (system, version, code, display, and userSelected). The first four of these can be set with a single assignment statement. The syntax is:

<pre><code>&lt;Coding&gt; = <span class="optional">{CodeSystem}|{version string}</span>#{code} <span class="optional">"{display string}"</span></code></pre>

The only required part of this statement is the code (including the # sign), although every Coding SHOULD have a code system. The version string cannot appear without a code system.

Whenever this type of rule is applied, whatever is on the right side **entirely replaces** the previous value of the Coding on the left side. For example, if a Coding has a value that includes a display string, and a subsequent assignment replaces the system and code but has no display string, the result is a Coding without a display string.

**Examples:**

* Assign a Coding that includes an explicit code system version:

  ```
  myCoding = http://hl7.org/fhir/CodeSystem/example-supplement|201801103#chol-mmol
  ```

* As an alternative to the bar syntax for version, set the code system version only:

  ```
  * myCoding.version = "201801103"
  ```

* Set the userSelected property of a Coding (one of the lesser-used attributes of Codings):

  ```
  * myCoding.userSelected = true
  ```
  
* In an instance of a Signature, set Signature.type (a Coding datatype):

  ```
  * type = urn:iso-astm:E1762-95:2013#1.2.840.10065.1.12.1.2 "Coauthor's Signature"
  ```

* Example of what happens when a second assignment replaces an existing value:

  ```
  * myCoding = $SCT#363346000 "Malignant neoplastic disease (disorder)"
  * myCoding = $ICD#C80.1
  ```
  Because the second assignment pre-clears the previous value of myCoding, the result is:

  * myCoding.system is http://hl7.org/fhir/sid/icd-10-cm (assuming the $ICD alias maps to this URL)
  * myCoding.code is "C80.1"
  * myCoding.display **has no value**
  * myCoding.version **has no value**

* Example of how **incorrectly** ordered rules can lead to loss of a previously-assigned value, because myCoding is cleared as part of the second assignment:

  ```
  * myCoding.userSelected = true
  * myCoding = $SCT#363346000 "Malignant neoplastic disease (disorder)"
  ```
  The result is:
  * system is http://snomed.info/sct
  * code is "363346000"
  * display is "Malignant neoplastic disease (disorder)"
  * userSelected **has no value**

* The correct way to approach the previous example is to reverse the order of the assignments:

  ```
  * myCoding = $SCT#363346000 "Malignant neoplastic disease (disorder)"
  * myCoding.userSelected = true
  ```

##### Assignments with the CodeableConcept Data Type

A CodeableConcept consists of an array of Codings and a text. To populate the array, array indices, denoted by brackets, are used. The shorthand is:

<pre><code>* &lt;CodeableConcept&gt;.coding[{index}] = <span class="optional">{CodeSystem}|{version string}</span>#{code} <span class="optional">"{display string}"</span></code></pre>

This is precisely like setting a Coding, as discussed directly above.

To set the first Coding in a CodeableConcept, FSH offers the following shortcut:

<pre><code>* &lt;CodeableConcept&gt; = <span class="optional">{CodeSystem}|{version string}</span>#{code} <span class="optional">"{display string}"</span></code></pre>

Whenever the shortcut rule is applied, the value on the right side **entirely replaces** any previous value of the CodeableConcept on the left side. Any previous value(s) in the CodeableConcept are cleared.

Assignment rules can be used to set any part of a CodeableConcept. For example, to set the top-level text of a CodeableConcept, the FSH expression is:

```
* <CodeableConcept>.text = "{string}"
```

**Examples:**

* Set the first Coding myCodeableConcept:

  ```
  * myCodeableConcept = $SCT#363346000 "Malignant neoplastic disease (disorder)"
  ```
    
* An equivalent representation, using explicit array index on the coding array:

  ```
  * myCodeableConcept.coding[0] = $SCT#363346000 "Malignant neoplastic disease (disorder)"
  ```
    
* Another equivalent representation, using the shorthand that allows dropping the [0] index:

  ```
  * myCodeableConcept.coding = $SCT#363346000 "Malignant neoplastic disease (disorder)"
  ```
    
* Add a second value to the array of Codings:

  ```
  * myCodeableConcept.coding[1] = $ICD#C80.1 "Malignant (primary) neoplasm, unspecified"
  ```
    
* Set the top-level text:

  ```
  * myCodeableConcept.text = "Diagnosis of malignant neoplasm left breast."
  ```

* Example of **incorrect** ordering rules that leads to loss of a previously-assigned value, because the last assignment pre-clears the existing value of myCodeableConcept before apply new values:

  ```
  * myCodeableConcept.coding[0].userSelected = true
  * myCodeableConcept.text = "Metastatic Cancer"
  * myCodeableConcept = $SCT#363346000 "Malignant neoplastic disease (disorder)"
  ```
  The result is:
  
  * coding[0].system is http://snomed.info/sct
  * coding[0].code is "363346000"
  * display is "Malignant neoplastic disease (disorder)"
  * coding[0].userSelected **has no value**
  * text **has no value**

* The correct way to approach the previous example is to set the values of userSelected and text **after** setting the coding, since those assignments only change the specific subelements on the left side of those assignments:

  ```
  * myCodeableConcept = $SCT#363346000 "Malignant neoplastic disease (disorder)"
  * myCodeableConcept.coding[0].userSelected = true
  * myCodeableConcept.text = "Metastatic Cancer"
  ```

##### Assignments with the Quantity Data Type

FSH provides a shorthand that allows quantities, units of measure, and display string for the units of measure to be specified simultaneously, provided the units of measure are [Unified Code for Units of Measure](http://unitsofmeasure.org/) (UCUM) codes:

<pre><code>&lt;Quantity&gt; = {decimal} '{UCUM code}' <span class="optional">"{units display string}"</span></code></pre>

A similar shorthand can be used for other code systems by specifying the unit using the standard FSH code syntax:

<pre><code>&lt;Quantity&gt; = {decimal} {CodeSystem}|{version string}#{code} <span class="optional">"{units display string}"</span></code></pre>

Alternatively, the value and units can also be set independently. To assign a value, use the Quantity.value property:

```
* <Quantity>.value = {decimal}
```

The units of measure can be set by assigning a coded value to a Quantity:

<pre><code>* &lt;Quantity&gt; = <span class="optional">{CodeSystem}|{version string}</span>#{code} <span class="optional">"{units display string}"</span></code></pre>

A Quantity can also be bound to a value set:

<pre><code>* &lt;Quantity&gt; from {ValueSet}
</code></pre>

> **Note:** The ability to assign a coded value or bind a value set directly to a Quantity is a consequence of FHIR oddly treating Quantity as a coded datatype.

**Examples:**

* Set the valueQuantity of an Observation to 55 millimeters using UCUM units:

  ```
  * valueQuantity = 55.0 'mm'
  ```

* Set the numerical value of Observation.valueQuantity to 55.0 without setting the units:

  ```
  * valueQuantity.value = 55.0
  ```

* Express a weight in pounds, using the UMLS code for units (not recommended), and displaying "pounds":

  ```
  * valueQuantity = 155.0 http://terminology.hl7.org/CodeSystem/umls#C0439219 "pounds"
  ```

* Set the units of the same valueQuantity to millimeters, without setting the value (assuming $UCUM has been defined as an alias for http://unitsofmeasure.org):

  ```
  * valueQuantity = $UCUM#mm "millimeters"
  ```

* Bind a value set to a Quantity, constraining the units of that Quantity:

  ```
  * valueQuantity from http://hl7.org/fhir/ValueSet/distance-units
  ```

* Example of how **incorrect** ordering of rules can result in the loss of a previously assigned value:

  ```
  * valueQuantity.unit = "millimeters"
  * valueQuantity = 55.0 'mm'
  ```
  Note that the second rule **pre-clears** valueQuantity in its entirety before applying the specified values, so the result is:

  * value is 55.0
  * system is http://unitsofmeasure.org
  * code is "mm"
  * unit **has no value**

* The correct way to approach the previous example, so unit has the desired value, is simply to reverse the order of rules:

  ```
  * valueQuantity = 55.0 'mm'
  * valueQuantity.unit = "millimeters"
  ```

* Another way to approach this example (with the correct result) is:

  ```
  * valueQuantity = $UCUM#mm "millimeters"
  * valueQuantity.value = 55.0
  ```

##### Assignments Involving References

Resource instances can refer to other resource instances. The referred resources can either exist independently or be contained inline in the DomainResource.contained array. Less commonly, the value of an element can be a resource, rather than a reference to a resource.

A resource reference is assigned using this grammar:

```
* <Reference> = Reference({Resource id|url})
```

For assignment of a resource to the value of an element directly:

```
* <Resource> = {Resource id|url}
```

As [advised in FHIR](https://www.hl7.org/fhir/R4/references.html#canonical), the URL is the preferred way to reference an instance for the resource types on which it is defined. One advantage is that the URL can include a version. For an internal FSH-defined instance, referring to an instance by its id (as defined in the `Instance` declaration) is more typical (see examples).

**Examples:**

* Assignment of a reference to an example of a Patient resource to Observation.subject:

  ```
  * subject = Reference(EveAnyperson)
  ```

  where, for example:

  ```
  Instance: EveAnyperson   // this is the id of the example instance
  InstanceOf: Patient
  Usage: #example
  * name.given = "Eve"
  * name.family = "Anyperson"
  ```

* Assignment of the same instance in Bundle.entry.resource, whose datatype is Resource (not Reference(Resource)):

  ```
  * entry[0].resource = EveAnyperson
  ```

##### Assignments with the CodeableReference Data Type

{%include tu-div.html%}

The [CodeableReference](https://hl7.org/fhir/2020Feb/references.html#codeablereference) datatype was introduced as part of FHIR R5 release sequence. This type allows for a concept, a reference, or both. FSH supports applying bindings directly to CodeableReferences and directly constraining types on CodeableReferences. Making use of CodeableReference involves no new FSH syntax.

**Examples:**

* Constrain Substance.code, which is datatype `CodeableReference(SubstanceDefinition)`:

  ```
  Profile: LatexSubstance
  Parent: Substance
  // restrict the CodeableConcept aspect to a code in the LatexCodeVS value set:
  * code from LatexCodeVS (required)
  // restrict Reference aspect to an instance of SubstanceDefinition conforming to the LatexSubstanceDefinition profile:
  * code only Reference(LatexSubstanceDefinition)
  ```

* Assign the concept and reference aspects of a CodeableReference:

  ```
  Instance:   LatexSubstanceExample
  InstanceOf: LatexSubstance
  * code.concept = $SCT#1003754000 "Natural rubber latex (substance)"
  * code.reference = Reference(NaturalLatexSubstanceDefinitionExample)
  ```

</div>

#### Binding Rules

Binding is the process of associating a coded element with a set of possible values. The syntaxes to bind a value set, or alter an inherited binding, use the reserved word `from`:

<pre><code>* &lt;bindable&gt; from {ValueSet} <span class="optional">({strength})</span></code></pre>

The bindable types in FHIR are [code, Coding, CodeableConcept, Quantity, string, and uri](http://hl7.org/fhir/R4/terminologies.html#4.1).

The strengths are the same as the [binding strengths defined in FHIR](https://www.hl7.org/fhir/R4/valueset-binding-strength.html), namely: example, preferred, extensible, and required. If strength is not specified, a required binding is assumed.

The [binding rules defined in FHIR](https://www.hl7.org/fhir/R4/profiling.html#binding) are applicable to FSH. In particular:

* When constraining an existing binding, the binding strength can only stay the same or be strengthened (e.g., a preferred binding can be replaced with an extensible or required binding).
* A required value set can be replaced by another required value set if the codes in the new value set are a subset of the codes in the original value set.
* For extensible bindings, the new value set can contain codes not in the existing value set, but additional codes MUST NOT have meanings covered by codes in the base value set.

**Examples:**

* Bind to an externally-defined value set using its canonical URL:

  ```
  * telecom.system from http://hl7.org/fhir/ValueSet/contact-point-system (required)
  ```

* Bind to an externally-defined value set with required binding by default:

  ```
  * gender from http://hl7.org/fhir/ValueSet/administrative-gender
  ```

* Bind to a value set using an alias name, assuming $AdGen is an alias for http://hl7.org/fhir/ValueSet/administrative-gender:

  ```
  * gender from $AdGen
  ```

#### Cardinality Rules

Cardinality rules constrain (narrow) the number of repetitions of an element. Every element has a cardinality inherited from its parent resource or profile. If the inheriting profile does not alter the cardinality, no cardinality rule is required.

To change the cardinality, the grammar is:

```
* <element> {min}..{max}

* <element> {min}..   // leave max as-is

* <element> ..{max}   // leave min as-is
```

As in FHIR, min and max are non-negative integers, and max can also be *, representing unbounded. It is valid to include both the min and max, even if one of them remains the same as in the original cardinality. In this case, FSH implementations SHOULD only generate constraints for the changed values.

Cardinalities MUST follow [rules of FHIR profiling](https://www.hl7.org/fhir/R4/conformance-rules.html#cardinality), namely that the min and max cardinalities comply within the constraints of the parent.

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

Extensions are created by adding elements to extension arrays. Extension arrays are found at the root level of every resource, nested inside every element, and recursively inside each extension. The structure of extensions is defined by FHIR (see [Extension element](https://www.hl7.org/fhir/R4/extensibility.html#extension)). Profiling extensions is discussed in [Defining Extensions](#defining-extensions).

Extensions are specified using the `contains` keyword. There are two types of extensions, *standalone* and *inline*:

* Standalone extensions have their own SDs, and can be reused. They can be defined internally (in the same FSH project), or externally in core FHIR or an external IG. Only standalone extensions can be used directly in profiles.
* Inline extensions do not have separate SDs, and cannot be reused in other profiles. Inline extensions can only be used to specify sub-extensions in a complex (nested) extension.

The syntaxes to specify standalone extension(s) are:

<pre><code>* &lt;extension&gt; contains {Extension} named {name} {card} <span class="optional">{flag(s)}</span>

* &lt;extension&gt; contains
    {Extension1} named {name1} {card} <span class="optional">{flag(s)}</span> and 
    {Extension2} named {name2} {card} <span class="optional">{flag(s)}</span> and
    {Extension3} named {name3} {card} <span class="optional">{flag(s)}</span> ...
</code></pre>

The syntaxes to define inline extension(s) are:

<pre><code>* &lt;extension&gt; contains {name} {card} <span class="optional">{flag(s)}</span>

* &lt;extension&gt; contains
    {name1} {card} <span class="optional">{flag(s)}</span> and
    {name2} {card} <span class="optional">{flag(s)}</span> and
    {name3} {card} <span class="optional">{flag(s)}</span> ...</code></pre>

In these expressions, the names (`name`, `name1`, `name2`, etc.) are new local names created by the rule author. They are used to refer to that extension in later rules. By convention, the local names SHOULD be [lower camelCase](https://wiki.c2.com/?CamelCase).

> **Note:** Contains rules can also be applied to modifierExtension arrays; simply replace `extension` with `modifierExtension`.

**Examples:**

* Add standalone FHIR extensions [patient-disability](http://hl7.org/fhir/R4/extension-patient-disability.html) and [patient-genderIdentity](http://hl7.org/fhir/StructureDefinition/patient-genderIdentity) to a profile of the Patient resource, using the canonical URLs for the extensions:

  ```
  * extension contains http://hl7.org/fhir/StructureDefinition/patient-disability named disability 0..1 MS and http://hl7.org/fhir/StructureDefinition/patient-genderIdentity named genderIdentity 0..1 MS
  ```

* The same statement, using aliases and whitespace flexibility for better readability:

  ```
  Alias: $Disability = http://hl7.org/fhir/StructureDefinition/patient-disability
  Alias: $GenderIdentity = http://hl7.org/fhir/StructureDefinition/patient-genderIdentity
  
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

* Show how the inline extensions defined in the [US Core Race](https://www.hl7.org/fhir/us/core/StructureDefinition-us-core-race.html) extension would be defined using FSH:

  ```
  * extension contains
      ombCategory 0..5 MS and
      detailed 0..* and
      text 1..1 MS
  // rules defining the inline extensions would typically follow:
  * extension[ombCategory].value[x] only Coding
  * extension[ombCategory].valueCoding from http://hl7.org/fhir/us/core/ValueSet/omb-race-category (required)
  * extension[text].value[x] only string
  // etc.
  ```

#### Contains Rules for Slicing

Slicing is an advanced, but necessary, feature of FHIR. It is helpful to have a basic understanding of [slicing](http://hl7.org/fhir/R4/profiling.html#slicing) and [discriminators](http://hl7.org/fhir/R4/profiling.html#discriminator) before attempting slicing in FSH.

In FSH, slicing is addressed in three steps: (1) specify the slicing logic, (2) define the slices, and (3) constrain each slice's contents.

> **Note:** The rules from each step MUST be sequentially ordered, i.e., step (1) slicing logic rules before step (2) slice definition rules before step (3) slice content rules.

##### Step 1. Specify the Slicing Logic

Slicing in FHIR requires authors to specify a [discriminator path, type, and rules](http://www.hl7.org/fhir/R4/profiling.html#discriminator). In addition, authors can optionally declare the slice as ordered or unordered (default: unordered), and/or provide a description. The meaning and allowable values are exactly [as defined in FHIR](http://www.hl7.org/fhir/R4/profiling.html#discriminator).

The slicing logic parameters are specified using [caret paths](#caret-paths). The discriminator path identifies the element to be sliced, which is typically a multi-cardinality (array) element. The discriminator type determines how the slices are differentiated, e.g., by value, pattern, existence of the sliced element, datatype of sliced element, or profile conformance.

**Example:**

* Provide slicing logic for slices on Observation.component that are be distinguished by their code:

  ```
  * component ^slicing.discriminator.type = #pattern
  * component ^slicing.discriminator.path = "code"
  * component ^slicing.rules = #open
  * component ^slicing.ordered = false   // can be omitted, since false is the default
  * component ^slicing.description = "Slice based on the component.code pattern"
  ```

##### Step 2. Define the Slices

The second step in slicing is to populate the array that is to be sliced, using the `contains` keyword. The syntaxes are very similar to [contains rules for inline extensions](#contains-rules-for-extensions):

<pre><code>* &lt;array&gt; contains {name} {card} <span class="optional">{flag(s)}</span>

* &lt;array&gt; contains
    {name1} {card} <span class="optional">{flag(s)}</span> and
    {name2} {card} <span class="optional">{flag(s)}</span> and
    {name3} {card} <span class="optional">{flag(s)}</span> ...
</code></pre>

In this pattern, `<array>` is a path to the element that is to be sliced and to which the slicing rules defined in step (1) will applied. The names (`name`, `name1`, etc.) are created by the rule author to describe the slice in the context of the profile. These names are used to refer to the slice in later rules. By convention, the slice names SHOULD be [lower camelCase](https://wiki.c2.com/?CamelCase).

Each slice will match or constrain the datatype of the array it slices. In particular:

* If an array is a one of the FHIR datatypes, each slice will be the same datatype or a profile of it. For example, if Observation.identifier is sliced, each slice will have type Identifier or be constrained to a profile of the Identifier datatype.
* If the sliced array is a backbone element, each slice "inherits" the sub-elements of the backbone. For example, the slices of Observation.component possess all the elements of Observation.component (code, value[x], dataAbsentReason, etc.). Constraints can be applied to the slices.
* If the array to be sliced is a Reference, then each slice MUST be a reference to one or more of the allowed Reference types. For example, if the element to be sliced is Reference(Observation or Condition), then each slice must either be Reference(Observation or Condition), Reference(Observation), Reference(Condition), or a profiled version of those resources.

**Examples:**

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

<pre><code>* &lt;array[{slice name}]&gt; contains {name} {card} <span class="optional">{flag(s)}</span>

* &lt;array[{slice name}]&gt; contains
    {name1} {card} <span class="optional">{flag(s)}</span> and
    {name2} {card} <span class="optional">{flag(s)}</span> and
    {name3} {card} <span class="optional">{flag(s)}</span> ...
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

##### Step 3. Constrain the Slice Contents

The final step is to define the properties of each slice. FSH requires slice contents to be defined inline. The rule syntax is the same as constraining any other element, but the [slice path syntax](#sliced-array-paths) is used to specify the path:

```
* <array>[{slice name}].<element> {constraint}
```

The slice content rules MUST appear *after* the contains rule that creates the slices.

**Examples:**

* Constrain the content of the systolicBP and diastolicBP slices:

  ```
  * component[systolicBP].code = $LNC#8480-6 // Systolic blood pressure
  * component[systolicBP].value[x] only Quantity
  * component[systolicBP].valueQuantity = $UCUM#mm[Hg] "mmHg"
  * component[diastolicBP].code = $LNC#8462-4 // Diastolic blood pressure
  * component[diastolicBP].value[x] only Quantity
  * component[diastolicBP].valueQuantity = $UCUM#mm[Hg] "mmHg"
  ```

At minimum, each slice MUST be constrained such that it can be uniquely identified via the discriminator (see Step 1). For example, if the discriminator path points to an element that is a CodeableConcept, and it discriminates by value or pattern, then each slice must constrain that CodeableConcept using an assignment rule or binding rule that uniquely distinguishes it from the other slices.

#### Exclude Rules

Exclude rules are used to remove codes from value sets. Exclude rules appear only in ValueSet items. For more details on exclude rules, see [Defining Value Sets](#defining-value-sets).

#### Flag Rules

Flags are a set of information about the element that impacts how implementers handle them. The [flags defined in FHIR](http://hl7.org/fhir/R4/formats.html#table), and the symbols used to describe them, are as follows:

| FHIR Flag | FSH Flag | Meaning |
|------|-----|----|
| S | `MS`  | Must Support |
| &#931;  | `SU`  | Include in summary |
| ?! | `?!` | Modifier |
| N | `N` | Normative element |
| TU | `TU` | Trial use element |
| D | `D` | Draft element |
{: .grid }

FHIR also defines the flags I and NE, representing elements affected by constraints, and elements that cannot have extensions, respectively. These flags are not supported in flag syntax, since the I flag is determined by the presence of [invariants](#obeys-rules), and NE flags apply only to infrastructural elements in base resources.

The following syntaxes can be used to assign flags:

```
* <element> {flag}

* <element> {flag1} {flag2}...

* <element1> and <element2> and <element3> ... {flag}

* <element1> and <element2> and <element3> ... {flag1} {flag2}...
```

> **Note:** When multiple flags are specified, they are separated with whitespace(s). When multiple element paths are specified, they are separated by `and`.

**Examples:**

* Declare communication to be a Must Support and Summary element:

  ```
  * communication MS SU
  ```

* Declare a list of elements and nested elements to be Must Support:

  ```
  * identifier and identifier.system and identifier.value and name and name.family MS
  ```

#### Include Rules

Include rules are used to add codes to value sets. Include rules appear only in ValueSet items. For more details on include rules, see [Defining Value Sets](#defining-value-sets).

#### Insert Rules

[Rule sets](#defining-rule-sets) are reusable groups of rules that are defined independently of other items. An insert rule is used to add the contents of a rule set to an item:

<pre><code>* insert {RuleSet}<span class="optional">({parameters})</span>
</code></pre>

The rules in the named rule set are interpreted as if they were copied and pasted in the designated location.

Each rule in the rule set should be compatible with the item where the rule set is inserted, in the sense that all the rules defined in the rule set apply to elements actually present in the target. Implementations SHOULD check the legality of a rule set at compile time. If a particular rule from a rule set does not match an element in the target, that rule will not be applied, and an error SHOULD be emitted. It is up to implementations if other valid rules from the rule set are applied.

##### Inserting Simple (Non-Parameterized) Rule Sets

Insert a simple rule set by using the name of the rule set:

```
* insert {RuleSet}
```

**Examples:**

* Insert the rule set named [RuleSet1](#simple-rule-sets) into a profile:

  ```
  Profile: MyPatientProfile
  Parent: Patient
  * insert RuleSet1
  * deceased[x] only boolean
  // More profile rules
  ```

  This is equivalent to the following:

  ```
  Profile: MyPatientProfile
  Parent: Patient
  * ^status = #draft
  * ^experimental = true
  * ^publisher = "Elbonian Medical Society"
  * deceased[x] only boolean
  // More profile rules
  ```

* Use rule sets to define two different national profiles, using a common clinical profile:

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

##### Inserting Parameterized Rule Sets

To insert a parameterized rule set, use the rule set name with a list of one or more parameter values:

<pre><code>* insert {RuleSet}<span class="optional">(value1, value2, value3...)</span>
</code></pre>

As indicated, the list of values is enclosed with parentheses `()` and separated by commas `,`. If you need to put literal `)` or `,` characters inside values, escape them with a backslash: `\)` and `\,`, respectively. White space separating values is optional, and removed before the value is applied to the rule set definition.

The values provided are substituted into the named rule set to create the rules that will be applied. The number of values provided must match the number of parameters specified in the rule set definition.

Any FSH syntax errors that arise as a result of the value substitution are handled the same way as FSH syntax errors in the declaration of a rule set without parameters. The value substitution is performed without checking the types of the values being substituted or the semantic validity of the resulting rules. Any invalid rules resulting from inserting a parameterized rule set will be detected at the same time as invalid rules resulting from inserting a simple rule set.

**Examples:**

* Use the parameterized rule set, Name, to populate an instance of Patient with multiple names (note that the curly brackets in this example are literal, not syntax expressions):

  ```
  RuleSet: Name(first, last)
  * name[+].given = "{first}"
  * name[=].family = "{last}"
  ```

  ```
  Instance: MrSmith
  InstanceOf: Patient
  // some rules
  * insert Name(Robert, Smith)
  * insert Name(Rob, Smith)
  * insert Name(Bob, Smith)
  // more rules
  ```

  When the rule set is expanded and soft indices are resolved, this is equivalent to:

  ```
  Instance: MrSmith
  InstanceOf: Patient
  // some rules
  * name[0].given = "Robert"
  * name[0].family = "Smith"
  * name[1].given = "Rob"
  * name[1].family = "Smith"
  * name[2].given = "Bob"
  * name[2].family = "Smith"
  // more rules
  ```

##### Inserting Rule Sets with Path Context

{%include tu-div.html%}

Rule sets can be inserted in the context of a path. The context is specified by giving the path prior to the insert rule:

<pre><code>* &lt;element&gt; insert {RuleSet}<span class="optional">(value1, value2, value3...)</span>
</code></pre>

Alternately, the context can be given by indenting the insert rule under another rule that provides a path context (see [indented rules](#indented-rules)).

When the rule set is expanded, the path of the element is pre-pended to the path of all rules in the rule set.

**Examples:**

* Insert a rule set into a profile specifying an element:

  ```
  RuleSet: NameRules
  * family MS
  * given MS

  Profile: MyPatientProfile
  Parent: Patient
  * name insert NameRules
  * deceased[x] only boolean
  // More profile rules
  ```
  
  An equivalent way to write the profile is:

  ```
  Profile: MyPatientProfile
  Parent: Patient
  * name 
    * insert NameRules
  * deceased[x] only boolean
  // More profile rules
  ```

  Both of the above are equivalent to:

  ```
  Profile: MyPatientProfile
  Parent: Patient
  * name.family MS
  * name.given MS
  * deceased[x] only boolean
  // More profile rules
  ```

</div>

#### Local Code Rules

Local codes rules are used to define codes in code systems. Local code rules appear only in CodeSystem items. For more details on local code rules, see [Defining Code Systems](#defining-code-systems).

#### Mapping Rules

Mapping rules are used to define relationships between different specifications. Mapping rules appear only in Mapping items. For more details on mapping rules, see [Defining Mappings](#defining-mappings).

#### Obeys Rules

[Invariants](https://www.hl7.org/fhir/R4/conformance-rules.html#constraints) are constraints that apply to one or more values in instances, expressed as [FHIRPath](https://www.hl7.org/fhir/R4/fhirpath.html) or [XPath](https://developer.mozilla.org/en-US/docs/Web/XPath) expressions. An invariant can apply to an instance as a whole or a single element. Multiple invariants can be applied to an instance as a whole or to a single element. The syntax for applying invariants in profiles is:

```
* obeys {Invariant}

* obeys {Invariant1} and {Invariant2}...

* <element> obeys {Invariant}

* <element> obeys {Invariant1} and {Invariant2}...
```

The first case applies the invariant to the profile as a whole. The second case applies the invariant to a single element. The third case applies multiple invariants to the profile as a whole, and the fourth case applies multiple invariants to a single element.

The referenced invariant and its properties MUST be declared somewhere within the same FSH project, using the `Invariant` keyword. See [Defining Invariants](#defining-invariants).

**Examples:**

* Assign invariant to US Core Implantable Device (invariant applies to profile as a whole):

  ```
  * obeys us-core-9
  ```

* Assign invariant to Patient.name in US Core Patient:

  ```
  * name obeys us-core-8
  ```

#### Path Rules

{%include tu-div.html%}

Path rules are only used to set the context for subsequent [indented rules](#indented-rules).

```
* <element>
```

A path rule has no impact on the element it refers to. The only purpose of the path rule is to set context.

**Examples:**

* Set a context of `name` for subsequent rules:

  ```
  * name
    * given MS
    * family MS
  ```

</div>

#### Type Rules

FSH rules can be used to restrict the datatype(s) of an element. The syntaxes are:

```
* <element> only {datatype}

* <element> only {datatype1} or {datatype2} or {datatype3}...

* <element> only Reference({ResourceOrProfile})

* <element> only Reference({ResourceOrProfile1} or {ResourceOrProfile2} or {ResourceOrProfile3}...)

* <element> only Canonical({ResourceOrProfile})

* <element> only Canonical({ResourceOrProfile1} or {ResourceOrProfile2} or {ResourceOrProfile3}...)
```

Certain elements in FHIR offer a choice of datatypes using the [x] syntax. Choices also frequently appear in references. For example, Condition.recorder has the choice Reference(Practitioner or PractitionerRole or Patient or RelatedPerson). In both cases, choices can be restricted in two ways: reducing the number or choices, and/or substituting a more restrictive datatype or profile for one of the choices appearing in the parent profile or resource.

Following [standard profiling rules established in FHIR](https://www.hl7.org/fhir/R4/profiling.html), the datatype(s) in a type rule MUST always be more restrictive than the original datatype. For example, if the parent datatype is Quantity, it can be replaced by SimpleQuantity, since SimpleQuantity is a profile on Quantity (hence more restrictive than Quantity itself), but cannot be replaced with Ratio, because Ratio is not a type of Quantity. Similarly, Condition.subject, defined as Reference(Patient or Group), can be constrained to Reference(Patient), Reference(Group), or Reference(us-core-patient), but cannot be restricted to Reference(RelatedPerson), since that is neither a Patient nor a Group.

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

{%include tu-div.html%}

* Restrict value[x] to the integer64 type (note: this datatype was introduced in FHIR v4.2.0):

  ```
  * value[x] only integer64
  ```

</div>

* Restrict Observation.performer (nominally Reference(Practitioner | PractitionerRole | Organization | CareTeam | Patient | RelatedPerson) to allow only Practitioner:

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

* Restrict the Practitioner choice of performer to a PrimaryCarePhysician, without restricting other choices. Because the path specifically calls out the Practitioner choice, the result is that performer can reference a Practitioner resource that validates against the PrimaryCareProvider profile or any of the other choices (PractitionerRole, Organization, CareTeam, Patient, and RelatedPerson):

  ```
  * performer[Practitioner] only Reference(PrimaryCareProvider)
  ```

* Restrict PlanDefinition.action.definition[x], nominally a choice of uri or canonical(ActivityDefinition | PlanDefinition | Questionnaire), to allow only the canonical of an ActivityDefinition:

  ```
  * action.definition[x] only Canonical(ActivityDefinition)
  ```

* Restrict action.definition[x] to a canonical of either an ActivityDefinition or a PlanDefinition:

  ```
  * action.definition[x] only Canonical(ActivityDefinition or PlanDefinition)
  ```

### Appendix: Abbreviations

| Abbreviation | Description |
|-----|----|
| ANTLR4  | ANother Tool for Language Recognition, version 4
| D  | Flag denoting draft status
| FHIR  | Fast Healthcare Interoperability Resources
| FSH   | FHIR Shorthand
| IG | Implementation Guide
| JSON   | JavaScript Object Notation
| $LNC | Common FSH alias for LOINC code system (http://loinc.org)
| LOINC | Logical Observation Identifiers Names and Codes
| NPI   | National Provider Identifier (US)
| N   |  Flag denoting normative element
| MS  | Flag denoting a Must Support element
|  OID   | Object Identifier
| $SCT | Common FSH alias for SNOMED Clinical Terms
|  SU  | Flag denoting "include in summary"
|  TU  | Flag denoting trial use element
| UCUM  | Unified Code for Units of Measure
| URL    | Uniform Resource Locator
| XML   | Extensible Markup Language
{: .grid }

### Appendix: Formal Grammar

The following is the grammar of FSH described in [ANTLR4](https://www.antlr.org/). The following parser and lexer includes elements of the FSH language marked as {%include tu.html%}.

#### Parser Grammar

```
grammar FSH;

options { tokenVocab = FSHLexer; }

doc:                entity* EOF;
entity:             alias | profile | extension | invariant | instance | valueSet | codeSystem | ruleSet | paramRuleSet | mapping | logical | resource;

alias:              KW_ALIAS SEQUENCE EQUAL SEQUENCE;

profile:            KW_PROFILE name sdMetadata+ sdRule*;
extension:          KW_EXTENSION name sdMetadata* sdRule*;
logical:            KW_LOGICAL name sdMetadata* lrRule*;
resource:           KW_RESOURCE name sdMetadata* lrRule*;
sdMetadata:         parent | id | title | description;
sdRule:             cardRule | flagRule | valueSetRule | fixedValueRule | containsRule | onlyRule | obeysRule | caretValueRule | insertRule | pathRule;
lrRule:             sdRule | addElementRule;

instance:           KW_INSTANCE name instanceMetadata* instanceRule*;
instanceMetadata:   instanceOf | title | description | usage;
instanceRule:       fixedValueRule | insertRule | pathRule;

invariant:          KW_INVARIANT name invariantMetadata+;
invariantMetadata:  description | expression | xpath | severity;

valueSet:           KW_VALUESET name vsMetadata* vsRule*;
vsMetadata:         id | title | description;
vsRule:             vsComponent | caretValueRule | insertRule;
codeSystem:         KW_CODESYSTEM name csMetadata* csRule*;
csMetadata:         id | title | description;
csRule:             concept | codeCaretValueRule | insertRule;

ruleSet:            KW_RULESET RULESET_REFERENCE ruleSetRule+;
ruleSetRule:        sdRule | addElementRule | concept | codeCaretValueRule | vsComponent;

paramRuleSet:       KW_RULESET PARAM_RULESET_REFERENCE paramRuleSetContent;
paramRuleSetContent:   STAR
                    ~(KW_PROFILE
                    | KW_ALIAS
                    | KW_EXTENSION
                    | KW_INSTANCE
                    | KW_INVARIANT
                    | KW_VALUESET
                    | KW_CODESYSTEM
                    | KW_RULESET
                    | KW_MAPPING)*;

mapping:            KW_MAPPING name mappingMetadata* mappingEntityRule*;
mappingMetadata:    id | source | target | description | title;
mappingEntityRule:  mappingRule | insertRule | pathRule;

// METADATA FIELDS
parent:             KW_PARENT name;
id:                 KW_ID name;
title:              KW_TITLE STRING;
description:        KW_DESCRIPTION (STRING | MULTILINE_STRING);
expression:         KW_EXPRESSION STRING;
xpath:              KW_XPATH STRING;
severity:           KW_SEVERITY CODE;
instanceOf:         KW_INSTANCEOF name;
usage:              KW_USAGE CODE;
source:             KW_SOURCE name;
target:             KW_TARGET STRING;


// RULES
cardRule:           STAR path CARD flag*;
flagRule:           STAR path (KW_AND path)* flag+;
valueSetRule:       STAR path KW_FROM name strength?;
fixedValueRule:     STAR path EQUAL value KW_EXACTLY?;
containsRule:       STAR path KW_CONTAINS item (KW_AND item)*;
onlyRule:           STAR path KW_ONLY targetType (KW_OR targetType)*;
obeysRule:          STAR path? KW_OBEYS name (KW_AND name)*;
caretValueRule:     STAR path? caretPath EQUAL value;
codeCaretValueRule: STAR CODE* caretPath EQUAL value;
mappingRule:        STAR path? ARROW STRING STRING? CODE?;
insertRule:         STAR path? KW_INSERT (RULESET_REFERENCE | PARAM_RULESET_REFERENCE);
addElementRule:     STAR path CARD flag* targetType (KW_OR targetType)* STRING (STRING | MULTILINE_STRING)?;
pathRule:           STAR path;

// VALUESET COMPONENTS
vsComponent:        STAR ( KW_INCLUDE | KW_EXCLUDE )? ( vsConceptComponent | vsFilterComponent );
vsConceptComponent: code vsComponentFrom?
                    | (code KW_AND)+ code vsComponentFrom;
vsFilterComponent:  KW_CODES vsComponentFrom (KW_WHERE vsFilterList)?;
vsComponentFrom:    KW_FROM (vsFromSystem (KW_AND vsFromValueset)? | vsFromValueset (KW_AND vsFromSystem)?);
vsFromSystem:       KW_SYSTEM name;
vsFromValueset:     KW_VSREFERENCE name (KW_AND name)*;
vsFilterList:       vsFilterDefinition (KW_AND vsFilterDefinition)*;
vsFilterDefinition: name vsFilterOperator vsFilterValue?;
vsFilterOperator:   EQUAL | SEQUENCE;
vsFilterValue:      code | KW_TRUE | KW_FALSE | REGEX | STRING;

// MISC
name:               SEQUENCE | NUMBER | KW_MS | KW_SU | KW_TU | KW_NORMATIVE | KW_DRAFT | KW_CODES | KW_VSREFERENCE | KW_SYSTEM;
path:               SEQUENCE | KW_SYSTEM;
caretPath:          CARET_SEQUENCE;
flag:               KW_MOD | KW_MS | KW_SU | KW_TU | KW_NORMATIVE | KW_DRAFT;
strength:           KW_EXAMPLE | KW_PREFERRED | KW_EXTENSIBLE | KW_REQUIRED;
value:              STRING | MULTILINE_STRING | NUMBER | DATETIME | TIME | reference | canonical | code | quantity | ratio | bool | name;
item:               name (KW_NAMED name)? CARD flag*;
code:               CODE STRING?;
concept:            STAR CODE+ STRING? (STRING | MULTILINE_STRING)?;
quantity:           NUMBER (UNIT | CODE) STRING?;
ratio:              ratioPart COLON ratioPart;
reference:          REFERENCE STRING?;
referenceType:      REFERENCE;
canonical:          CANONICAL;
ratioPart:          NUMBER | quantity;
bool:               KW_TRUE | KW_FALSE;
targetType:         name | referenceType | canonical;
```

#### Lexer Grammar
```
lexer grammar FSHLexer;

// KEYWORDS
KW_ALIAS:           'Alias' WS* ':';
KW_PROFILE:         'Profile' WS* ':';
KW_EXTENSION:       'Extension' WS* ':';
KW_INSTANCE:        'Instance' WS* ':';
KW_INSTANCEOF:      'InstanceOf' WS* ':';
KW_INVARIANT:       'Invariant' WS* ':';
KW_VALUESET:        'ValueSet' WS* ':';
KW_CODESYSTEM:      'CodeSystem' WS* ':';
KW_RULESET:         'RuleSet' WS* ':' -> pushMode(RULESET_OR_INSERT);
KW_MAPPING:         'Mapping' WS* ':';
KW_LOGICAL:         'Logical' WS* ':';
KW_RESOURCE:        'Resource' WS* ':';
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
KW_INCLUDE:         'include';
KW_EXCLUDE:         'exclude';
KW_CODES:           'codes';
KW_WHERE:           'where';
KW_VSREFERENCE:     'valueset';
KW_SYSTEM:          'system';
KW_EXACTLY:         '(' WS* 'exactly' WS* ')';
KW_INSERT:          'insert' -> pushMode(RULESET_OR_INSERT);

// SYMBOLS
EQUAL:              '=';
STAR:               ([\r\n] | LINE_COMMENT) WS* '*' [ \u00A0];
COLON:              ':';
COMMA:              ',';
ARROW:              '->';

// PATTERNS

                 //  "    CHARS    "
STRING:             '"' (~[\\"] | '\\r' | '\\n' | '\\t' | '\\"' | '\\\\')* '"';

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
REFERENCE:       'Reference' WS* '(' WS* SEQUENCE WS* (WS 'or' WS+ SEQUENCE WS*)* ')';

                 // Canonical       (              URL|VERSION               or              URL|VERSION             )
CANONICAL     :    'Canonical' WS* '(' WS* SEQUENCE ('|' SEQUENCE)? WS* (WS 'or' WS+ SEQUENCE ('|' SEQUENCE)? WS*)* ')';

                 //  ^  NON-WHITESPACE
CARET_SEQUENCE:     '^' NONWS+;

                 // '/' EXPRESSION '/'
REGEX:              '/' ('\\/' | ~[*/\r\n])('\\/' | ~[/\r\n])* '/';

PARAMETER_DEF_LIST: '(' (SEQUENCE WS* COMMA WS*)* SEQUENCE ')';

// BLOCK_COMMENT must precede SEQUENCE so that a block comment without whitespace does not become a SEQUENCE
BLOCK_COMMENT:      '/*' .*? '*/' -> skip;
                 // NON-WHITESPACE
SEQUENCE:           NONWS+;



// FRAGMENTS
fragment WS: [ \t\r\n\f\u00A0];
fragment NONWS: ~[ \t\r\n\f\u00A0];
fragment NONWS_STR: ~[ \t\r\n\f\u00A0\\"];

// IGNORED TOKENS
WHITESPACE:         WS -> channel(HIDDEN);
LINE_COMMENT:       '//' ~[\r\n]* [\r\n] -> skip;

mode RULESET_OR_INSERT;
PARAM_RULESET_REFERENCE:      WS* NONWS+ (WS* ('(' ('\\)' | '\\\\' | ~[)])+ ')')) -> popMode;
RULESET_REFERENCE:            WS* NONWS+ -> popMode;
```
