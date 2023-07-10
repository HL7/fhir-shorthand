### FHIR Shorthand 3.0.0-ballot (HL7 Mixed Normative / Trial Use Ballot 1)

The FHIR Shorthand 3.0.0 Mixed Normative / Trial Use Ballot (September 2023) promoted the following features to **[NORMATIVE](https://hl7.org/fhir/versions.html#std-process)** status. These features have been thoroughly tested by the community after being introduced as trial use in FHIR Shorthand 2.0.0 and are expected to remain stable in the future.

* Parameterized rule sets ([3.5.11.2](reference.html#parameterized-rule-sets), [3.6.11.2](reference.html#inserting-parameterized-rule-sets))
* Indented rules ([3.6.1](reference.html#indented-rules))
* Path rules ([3.6.15](reference.html#path-rules))
* Logical models ([3.5.7](reference.html#defining-logical-models), [3.6.2](reference.html#add-element-rules))
* Custom resources ([3.5.10](reference.html#defining-resources), [3.6.2](reference.html#add-element-rules))
* Hierarchical code systems ([3.5.3.1](reference.html#defining-code-systems-with-hierarchical-codes))
* Concept-specific caret rules ([3.5.3.2](reference.html#code-metadata))
* Inserting rule sets with path context ([3.6.11.3](reference.html#inserting-rule-sets-with-path-context))

The FHIR Shorthand 3.0.0 Mixed Normative / Trial Use Ballot (September 2023) introduced the following substantive changes as **[TRIAL USE](https://hl7.org/fhir/versions.html#std-process)** features. Many of these features have been tested by the community, but some may undergo changes in the future.

* Specifying Extension context using the Context keyword ([3.5.4](reference.html#defining-extensions))
* Authors may define instances of logical models ([3.5.5](reference.html#defining-instances))
* Using rules in Invariant definitions ([3.5.6](reference.html#defining-invariants))
* Assigning metadata values for concepts in value sets [3.5.12.2](reference.html#concept-metadata)
* Logical model definitions may now use assignment rules and constrain inherited elements ([3.5.7](reference.html#defining-logical-models))
* Inserting parameterized rule sets with values in double square brackets ([3.6.11.2](reference.html#inserting-parameterized-rule-sets))
* Path rules can be used to add optional fixed values and set slice order on Instances ([3.6.15](reference.html#path-rules))
* CodeableReference keyword can be used in add element rules ([3.6.2](reference.html#add-element-rules)) and type rules ([3.6.16](reference.html#type-rules))
* Specifying type characteristics of Logical models using the Characteristics keyword ([3.5.7](reference.html#defining-logical-models))

Additional minor changes and clarifications to the specification include the following:

* Insert rules in the context of a concept ([3.6.11.3](reference.html#inserting-rule-sets-with-path-context))
* Add element rules with content references ([3.6.2](reference.html#add-element-rules))
* Minor correction to indicate Path Rules may be used on Mappings (Table 7 in [3.5.1.3](reference.html#rule-statements))
* Additional explanation and examples for using `include` ([3.5.12](reference.html#defining-value-sets))
* Include Reference and Canonical in the reserved words list ([3.3.2](reference.html#reserved-words))
* Indicate that R5 removed support for xpath invariants ([3.5.6](reference.html#defining-invariants))
* Indicate that slices can be discriminated by position in R5 ([3.6.7.1](reference.html#step-1-specify-the-slicing-logic))
* Provide example of constraining Reference datatype and its targets ([3.6.16](reference.html#type-rules))
* Clarify that extension paths may also have bracketed indices ([3.4.8](reference.html#extension-paths))
* Clarify correct and incorrect definition and use of aliases ([3.5.2](reference.html#defining-aliases))
* Clarify that `Usage: #definition` can be used to define any formal item in an IG ([3.5.5](reference.html#defining-instances))
* Clarify value set rules syntax for versions code systems and value sets ([3.5.12](reference.html#defining-value-sets))
* Clarify allowed value types in value set filter expressions ([3.5.12.1](reference.html#filters))
* Update all links for core FHIR to point to FHIR R5

### FHIR Shorthand 2.0.0 (HL7 Mixed Normative / Trial Use Release 1)

There were no substantive changes in FHIR Shorthand 2.0.0 compared to the balloted FHIR Shorthand 1.2.0 version.

### FHIR Shorthand 1.2.0 (HL7 Mixed Normative / Trial Use Ballot 1)

The FHIR Shorthand Mixed Normative / Trial Use Ballot (September 2021) introduced the following substantive changes as **[NORMATIVE](https://hl7.org/fhir/versions.html#std-process)** features. These features have been thoroughly tested by the community and are not expected to change in the future.

* Soft indexing for array paths ([3.4.6](reference.html#array-paths-using-soft-indexing))
* Extended Quantity syntax ([3.3.9](reference.html#quantities))

The FHIR Shorthand Mixed Normative / Trial Use Ballot (September 2021) introduced the following substantive changes as **[TRIAL USE](https://hl7.org/fhir/versions.html#std-process)** features. Many of these features have been tested by the community, but some may undergo changes in the future.

* Parameterized rule sets ([3.5.11.2](reference.html#parameterized-rule-sets), [3.6.11.2](reference.html#inserting-parameterized-rule-sets))
* Indented rules ([3.6.1](reference.html#indented-rules))
* Path rules ([3.6.15](reference.html#path-rules))
* Logical models ([3.5.7](reference.html#defining-logical-models), [3.6.2](reference.html#add-element-rules))
* Custom resources ([3.5.10](reference.html#defining-resources), [3.6.2](reference.html#add-element-rules))
* Hierarchical code systems ([3.5.3.1](reference.html#defining-code-systems-with-hierarchical-codes))
* Concept-specific caret rules ([3.5.3.2](reference.html#code-metadata))
* Inserting rule sets with path context ([3.6.11.3](reference.html#indented-rules))
* Support for integer64 and CodeableReference ([3.2.3](reference.html#fhir-version), [3.6.3.2](reference.html#assignments-with-primitive-data-types), [3.6.3.7](reference.html#assignments-with-the-codeablereference-data-type), [3.6.4](reference.html#binding-rules), [3.6.16](reference.html#type-rules))

All other existing features originally introduced in FHIR Shorthand 1.0.0 were promoted to **[NORMATIVE](https://hl7.org/fhir/versions.html#std-process)** status.

### FHIR Shorthand 1.0.0 (HL7 Standard for Trial Use Release 1)

Initial Standard for Trial Use release.
