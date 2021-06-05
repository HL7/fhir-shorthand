FHIR Shorthand (FSH) is a domain-specific language for defining FHIR artifacts involved in creation of FHIR Implementation Guides (IG). The goal of FSH is to allow profiler creators to more directly express their intent with fewer concerns about underlying FHIR mechanics. FSH can be created and updated using any text editor, and because it is text, it enables distributed, team-based development using source code control tools such as GitHub.

The FHIR Shorthand (FSH) implementation guide includes the following information:

1. [FHIR Shorthand Overview](overview.html) -- Introduction to FSH and SUSHI (the reference implementation of a FSH compiler) _(informative content)_.
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

1. Hand-editing FHIR conformance artifacts such as StructureDefinition and ValueSet resources is unwieldy, but authors get full control over every aspect of the resulting FHIR profiles and definitions.
1. The [Excel spreadsheet method](https://confluence.hl7.org/display/FHIR/FHIR+Spreadsheet+Profile+Authoring) has existed since before FHIR 1.0 and has been used to produce sophisticated IGs such as [US Core](https://github.com/HL7/US-Core-R4). A downside is that version management is difficult; either the files are saved in binary form (.xslx) or as XML files, with the content mixed with formatting directives.
1. [Simplifier/Forge](https://fire.ly/products/simplifier-net/) and [Trifolia-on-FHIR](https://trifolia-fhir.lantanagroup.com) provide graphical and form-based interfaces that help guide users through common profiling tasks. The potential downside is the need to navigate multiple screens visit different items and make cross-cutting changes.

As the only language designed for profiling and IG creation, FSH is unique among these methods. It provides a fast, scalable, and user-friendly path to IG creation and maintenance. Because it is text-based, FSH brings a degree of editing agility not found in graphical tools (such as cutting and pasting, global search and replace, spell checking, etc.) Because it is a HL7 FHIR standard, tooling can be built around FSH with confidence in its stability and continuity. The most notable FSH tool currently is [SUSHI](https://fshschool.org/docs/sushi/), a reference implementation for transforming FSH into FHIR artifacts that are directly integrated with the [HL7 FHIR Implementation Guide Publishing tool](https://confluence.hl7.org/display/FHIR/IG+Publisher+Documentation). SUSHI has a number of features to go seamlessly from FSH to IG.

### Ballot Status

This Implementation Guide has been balloted as Standard for Trial Use (STU) with the intention to go normative in a subsequent ballot cycle.

### Authors and Contributors

| Role | Name | Organization | Contact |
|----|----|----|----|
| Author | Mark A. Kramer | MITRE Corporation | mkramer@mitre.org |
| Author | Chris Moesel | MITRE Corporation | cmoesel@mitre.org |
| Contributor | Joe Paquette | **athena**health | |
| Contributor | Julia K. Afeltra | MITRE Corporation | jafeltra@mitre.org |
| Contributor | Nick Freiter | MITRE Corporation | nfreiter@mitre.org |
| Contributor | Mint N. Thompson | MITRE Corporation | mathompson@mitre.org |
| Contributor | Julian Alexander Carter | MITRE Corporation | jacarter@mitre.org |
| Contributor | Samantha Citron | MITRE Corporation | scitron@mitre.org |
| FHIR Infrastructure Co-chair | Rick Geimer | Lantana Consulting Group | rick.geimer@lantanagroup.com |
| FHIR Infrastructure Co-chair | Josh Mandel | SMART Health IT | jmandel@gmail.com |
| FHIR Infrastructure Co-chair | Lloyd McKenzie | HL7 Canada/Gevity | lloyd@lmckenzie.com |
| FHIR Infrastructure Co-chair | Yunwei Wang | MITRE Corporation | yunweiw@mitre.org |
{: .grid }

The authors gratefully acknowledge the many contributions from numerous users and facilitators who helped shape, mature, debug, and advance the FSH specification. The authors want to thank all those who participate on the [shorthand channel via chat.fhir.org](https://chat.fhir.org/#narrow/stream/215610-shorthand). While every discussion helps build the FSH knowledge base and strengthen the community of FSH, we especially appreciate those who provide answers and participate in design discussions. We therefore recognize:

Reece Adamson,
Kurt Allen,
Carl Anderson,
Keith Boone,
Giorgio Cangioli,
Gino Canessa,
Etienne Cantineau,
Juan Manuel Caputo,
Sam Citron,
Sheila Connelly,
Carmela Couderc,
Stuart Cox,
Nathan Davis,
Noemi Deppenwiese,
Mark Discenza,
Jean Duteau,
Oliver Egger,
Brett Esler,
Richard Esmond,
Michael Faughn,
Sarah Gaunt,
Nick George,
Hugh Glover,
Andy Gregorowicz,
Grahame Grieve,
Alex Goel,
Nick Goupinets,
John Grimes,
Eric Haas,
Torben Hagensen,
Bill Harty,
Rob Hausam,
David Hay,
Simone Heckmann,
Martin Höcker,
Mark Iantorno,
Brian Kaney,
Daniel Karlsson,
Richard Kavanagh,
John Keyes,
Max Körlinge,
Ewout Kramer,
Saul Kravitz,
Halina Labikova,
Patrick Langford,
Michael Lawley,
Carl Leitner,
Geoff Low,
Dylan Mahalingam,
Rute Martins Baptista,
Josh Mandel,
Max Masnick,
Lloyd McKenzie,
Bob Milius,
John Moehrke,
Ryan Moehrke,
Jabeen Mohammed,
Sean Muir,
Dipanjan Mukherjee,
Muthu Muthuraj,
Christian Nau,
Craig Newman,
Diana Ovelgoenne,
Joe Paquette,
Tom Parker-Shemilt,
Vassil Peytchev,
Janaka Peiris,
Caroline Potteiger,
David Pyke,
Andre Quina,
Joshua Reynolds,
Rob Reynolds,
Bryn Rhodes,
Andy Richardson,
Peter Robinson,
Kirstine Rosenbeck Gøeg,
Thomas Tveit Rosenlund,
Shovan Roy,
Julian Sass,
Michael Sauer,
Mark Scrimshire,
Larry Shields,
John Silva,
Elliot Silver,
Igor Sirkovich,
Bill Sorensen,
Richard Stanley,
Lee Surprenant,
Jose Costa Teixeira,
May Terry,
Arvid Thunholm,
Eric Torstenson,
Richard Townley-O'Neill,
Pétur Valdimarsson,
Bas van den Heuvel,
Bence Vass,
Barbro Vessman,
Jens Villadsen,
Ward Weistra,
Patrick Werner,
Rien Wertheim,
David Winters,
and
Michaela Ziegler.

The authors apologize if they have omitted any contributor from this list.

**[Continue to Overview ->](overview.html)**
