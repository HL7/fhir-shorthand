FHIR Shorthand (FSH) is a domain-specific language for defining FHIR artifacts involved in creation of FHIR Implementation Guides (IG). The goal of FSH is to allow profiler creators to more directly express their intent with fewer concerns about underlying FHIR mechanics. FSH can be created and updated using any text editor, and because it is text, it enables distributed, team-based development using source code control tools such as GitHub.

The FHIR Shorthand (FSH) implementation guide includes the following information:

1. [FHIR Shorthand Overview](index.html) -- Introduction to FSH and SUSHI (the reference implementation of a FSH compiler) _(informative content)_.
1. [FHIR Shorthand Language Reference](reference.html) -- The syntax and usage of the FHIR Shorthand language _(formal content)_.
1. A [Quick Reference Sheet](FSHQuickReference.pdf) under the Downloads menu.

The following material, essential to applying FHIR Shorthand but not part of the language specification, is found on [FSHSchool.org](https://fshschool.org/):

1. [SUSHI User Guide](https://fshschool.org/docs/sushi/) -- A guide to producing an IG from FSH files using SUSHI compiler and the HL7 IG Publishing tool.
1. [FHIR Shorthand Tutorials](https://fshschool.org/docs/tutorials/) -- A step-by-step hands-on introduction to producing an Implementation Guide (IG) with FHIR Shorthand and SUSHI.


### Notational Conventions

This IG uses the following conventions:

| Style | Explanation | Example |
|:------------|:------|:---------|
| `Code` | Code fragments, such as commands, FSH statements, and FSH syntax expressions  | `* status = #open` |
| `{curly braces}` | An item to be substituted in a syntax expression | `{display string}` |
| `<datatype>` | An element or path to an element with the given data type, to be substituted in the syntax expression | `<CodeableConcept>`
| _italics_ | An optional item in a syntax expression | <code><i>"{string}"</i></code> |
| ellipsis (...) | Indicates a pattern that can be repeated | <code>{flag1} {flag2} {flag3}&nbsp;...</code>
| **bold** | A directory path or file name | **example-1.fsh** |
{: .grid }

### Relationships to Other Standards, Tools, and Guidelines

There are already several existing methods for IG creation. Each of these methods have certain advantages as well as drawbacks:

1. Hand-editing the conformance artifacts such as StructureDefinitions and ValueSet resources is unwieldy, but authors get full control over every aspect of the resulting FHIR profiles and definitions.
1. The [Excel spreadsheet method](https://confluence.hl7.org/display/FHIR/FHIR+Spreadsheet+Profile+Authoring) has existed since before FHIR 1.0 and has been used to produce sophisticated IGs such as [US Core](https://github.com/HL7/US-Core-R4). A significant downside is that version management is difficult; either the files are saved in binary form (.xslx) or as XML files, with the content mixed with formatting directives.
1. [Simplifier/Forge](https://fire.ly/products/simplifier-net/) and [Trifolia-on-FHIR](https://trifolia-fhir.lantanagroup.com) provide graphical and form-based interfaces that help guide users through common tasks. The potential downside is the need to navigate multiple screens visit different items and make cross-cutting changes.

As a language designed for the job of profiling and IG creation, FSH unique among these methods. It provides a fast, scalable, and user-friendly path to IG creation and maintenance. Because it is text-based, FSH brings a degree of editing agility not found in graphical tools (including cutting and pasting, global search and replace, spell checking, etc.) Because it is a HL7 FHIR standard, tooling can be built around FSH with confidence in its stability and continuity. The most notable FSH tool currently is [SUSHI](https://fshschool.org/docs/sushi/), a reference implementation for transforming FSH into FHIR artifacts that are directly integrated with the [HL7 FHIR Implementation Guide Publishing tool](https://confluence.hl7.org/display/FHIR/IG+Publisher+Documentation). SUSHI has a number of features to seamlessly go from FSH to an IG.

### Ballot Status

This Implementation Guide has been balloted as Standard for Trial Use (STU) with the intention to go normative in a subsequent ballot cycle.

### Authors and Contributors

| Role | Name | Organization | Contact |
|----|----|----|----|
| Author | Mark A. Kramer | MITRE Corporation | mkramer@mitre.org |
| Author | Chris Moesel | MITRE Corporation | cmoesel@mitre.org |
| Contributor | Julia K. Afeltra | MITRE Corporation | jafeltra@mitre.org |
| Contributor | Nick Freiter | MITRE Corporation | nfreiter@mitre.org |
| Contributor | Mint N. Thompson | MITRE Corporation | mathompson@mitre.org |
| FHIR Infrastructure Co-chair | Rick Geimer | Lantana Consulting Group | rick.geimer@lantanagroup.com |
| FHIR Infrastructure Co-chair | Josh Mandel | SMART Health IT | jmandel@gmail.com |
| FHIR Infrastructure Co-chair | Lloyd McKenzie | HL7 Canada/Gevity | lloyd@lmckenzie.com |
| FHIR Infrastructure Co-chair | Yunwei Wang | MITRE Corporation | yunweiw@mitre.org |
{: .grid }

The authors gratefully acknowledge the many contributions from numerous users and facilitators who helped shape, mature, debug, and advance the FSH specification, including:

Reece Adamson,
Kurt Allen,
Carl Anderson,
Keith Boone,
Giorgio Cangioli,
Gino Canessa,
Etienne Cantineau,
Sam Citron,
Sheila Connelly,
Carmela Couderc,
Noemi Deppenwiese,
Mark Discenza,
Jean Duteau,
Richard Esmond,
Nick George,
Andy Gregorowicz,
Eric Haas,
Torben M. Hagensen,
David Hay,
Sarah Gaunt,
Grahame Grieve,
John Grimes,
Brian Kaney,
Daniel Karlsson,
Richard Kavanagh,
Ewout Kramer,
Saul Kravitz,
Halina Labikova,
Michael Lawley,
Dylan Mahalingam,
Rute Martins Baptista,
Bob Milius,
John Moehrke,
Muthu Muthuraj,
Craig Newman,
Joe Paquette,
Tom Parker-Shemilt,
Vassil Peytchev,
Caroline Potteiger,
David Pyke,
Andre Quina,
Joshua Reynolds,
Rob Reynolds,
Bryn Rhodes,
Shovan Roy,
Michael Sauer,
John Silva,
Elliot Silver,
Igor Sirkovich,
Bill Sorensen,
Lee Surprenant,
Jose Costa Teixeira,
May Terry,
Pétur Valdimarsson,
Bas van den Heuvel,
Bence Vass,
Jens Villadsen,
Ward Weistra,
Rien Wertheim,
and
David Winters.

The authors apologize if they have omitted any contributor from this list.
