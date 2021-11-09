{%include styles.html%}

<br/>
<span style="background-color: LightYellow;">NOTE: Information on this page is [informative content](https://www.hl7.org/fhir/versions.html#std-process).</span>
<br/>

<img src="FHIR-Shorthand-Logo.png" alt="FHIR Shorthand Logo" width="300px" style="float:none; margin: 0px 0px 0px 0px;" />

### Background

FHIR Shorthand (FSH) is a domain-specific language for defining FHIR artifacts involved in creation of FHIR Implementation Guides (IG). The goal of FSH is to allow Implementation Guide (IG) creators to more directly express their intent with fewer concerns about underlying FHIR mechanics, and efficiently produce high-quality FHIR IGs.

Conceived in September 2019 with the first version of the specification released in March 2020, FSH has been rapidly adopted by the FHIR community. The [FSH Finder](https://fshschool.org/fsh-finder/) tool reports well over 100 IG-development projects using FSH. The [#shorthand channel on chat.fhir.org](https://chat.fhir.org/#narrow/stream/215610-shorthand) has 270 subscribers and participation is very active. FSH and related tools have been tested at three HL7 Connectathons. Several significant tools for processing FSH have been developed, including [SUSHI](https://fshschool.org/docs/sushi/), a reference implementation and _de facto_ standard compiler for transforming FSH into FHIR artifacts. The site [npm-stat](https://npm-stat.com/charts.html?package=fsh-sushi&from=2020-02-12&to=2021-07-12) shows that the *fsh-sushi* [npm](https://www.npmjs.com/) package has had over 45,000 downloads as of July 2021. [GoFSH](https://fshschool.org/docs/gofsh/), a tool for transforming FHIR artifacts to FSH, enables lossless round-tripping from FHIR JSON to FSH and back. FSH and SUSHI have been integrated with the [HL7 FHIR Implementation Guide Publishing tool](https://confluence.hl7.org/display/FHIR/IG+Publisher+Documentation), allowing seamless processing from FSH to a complete IG.

FSH was approved as a Standard for Trial Use (STU 1) in May 2020. In the ensuing period, vigorous activity around FSH has driven improvements, new features, and rapid maturation of FSH and related tools. The majority of language features of FSH are normative, including some post-STU 1 features that have benefited from significant user testing. Certain newer language features, such as defining logical models, are proposed as Trial Use. Trial use features are clearly marked in the [language specification](reference.html) with the {%include tu.html%} symbol.

Designation as a normative standard does not mean that the FSH language will cease to evolve, only that any future changes must be compatible with the normative portions of the specification.

#### Motivations for FHIR Shorthand

FSH was created in response to the need in the FHIR community for scalable, fast, user-friendly tools for IG creation and maintenance. IG authors often struggle to implement profiling projects with efficiency, consistency, and quality. Project teams iterate over the formal definitions and examples many times during the IG development process. As such, an agile approach to refactoring and revision is invaluable.

Before exploring the FSH approach, consider the alternative methods for IG development:

1. Hand-editing FHIR conformance artifacts such as StructureDefinition and ValueSet resources gives authors full control over every aspect of the resulting FHIR profiles and definitions, but is unwieldy and prone to errors, and suitable only for FHIR experts.
1. The [Excel spreadsheet method](https://confluence.hl7.org/display/FHIR/FHIR+Spreadsheet+Profile+Authoring) has existed since before FHIR 1.0 and has been used to produce sophisticated IGs such as [US Core](https://github.com/HL7/US-Core-R4). A downside is that version management is difficult; either the files are saved in binary form (.xslx) or as XML files, with the content mixed with formatting directives. According to [HL7 Confluence](https://confluence.hl7.org/display/FHIR/FHIR+Spreadsheet+Authoring), the spreadsheet method "is expected to be a near term solution with more sophisticated (and user-friendly) tooling currently under development," implying eventual deprecation of this approach.
1. [Simplifier/Forge](https://fire.ly/products/simplifier-net/) and [Trifolia-on-FHIR](https://trifolia-fhir.lantanagroup.com) provide graphical, form-based interfaces that help guide users through common profiling tasks. The upside is that the tools provide guidance to authors, while the potential downside is the need to navigate through many screens, and difficulty making cross-cutting changes. Trifolia is fully browser-based, with no software to install locally. Both are commercially-supported products.

While recognizing there is no single "best" approach to IG development, experience across many domains has shown that complex software projects are typically approached with textual languages. As a language designed for the job of profiling and IG creation, FSH is concise, understandable, and aligned to user intentions. Users may find that the FSH language representation is a good way to understand a set of profiles or logical models. Because it is text-based, FSH brings a degree of editing agility not typically found in graphical tools (cutting and pasting, search and replace, spell checking, etc.) FSH is ideal for distributed development under source code control, providing meaningful version-to-version differentials, support for merging and conflict resolution, and nimble refactoring. These features allow FSH to scale in ways that other approaches cannot. Any text editor can be used to create or modify FSH, but advanced text editor plugins may also be used to further aid authoring.

### About this IG

The FSH IG includes the following information:

1. This page, providing introductory material  _(informative content)_.
1. [FHIR Shorthand Overview](overview.html) -- Introduction to FSH language and SUSHI (a reference implementation and _de facto_ standard FSH compiler) _(informative content)_.
1. [FHIR Shorthand Language Reference](reference.html) -- The syntax and usage of the FHIR Shorthand language _(formal content)_.
1. A [Quick Reference Sheet](FSHQuickReference.pdf) under the Downloads menu _(informative content)_.

The following material, useful for learning and applying FHIR Shorthand but not part of the language specification, is found on [FSHSchool.org](https://fshschool.org/):

1. [SUSHI User Guide](https://fshschool.org/docs/sushi/) -- SUSHI ("SUSHI Unshortens ShortHand Inputs") is a reference implementation and _de facto_ standard interpreter/compiler for FHIR Shorthand. SUSHI produces [Health Level Seven (HL7®) Fast Healthcare Interoperability Resources (FHIR®)](https://www.hl7.org/fhir/R4/overview.html) profiles, extensions, and other artifacts needed to create FHIR Implementation Guides (IG).
1. [GoFSH User Guide](https://fshschool.org/docs/gofsh/) -- GoFSH is a tool that turns FHIR artifacts into FSH. Using GoFSH, existing FHIR artifacts or complete Implementation Guides can be transformed into FSH, automatically.
1. [FHIR Shorthand Tutorials](https://fshschool.org/docs/tutorials/) -- A step-by-step hands-on introduction to producing an Implementation Guide (IG) with FHIR Shorthand and SUSHI.
1. [FSH Online](https://fshschool.org/FSHOnline/#/) -- A coding playground for FSH, an online environment that allows you to write FSH and convert it to FHIR artifacts, convert FHIR artifacts to FSH, access examples, and share FSH code with others.
1. [FSH Finder](https://fshschool.org/fsh-finder/) -- A list of public GitHub repositories that contain FSH code, refreshed daily.

Note that the [Language Reference](reference.html) is the formal specification, and if there is any conflict between that and any other written or programmatic materials, the former is considered the source of truth.

#### Version Number

The sequence of releases of this specification is expressed in terms of three integers, x.y.z. An increment in z indicates minor, backward-compatible updates. An increment in y indicates new or modified language features, and potentially, non-backward-compatible changes. By HL7 convention, the major version number x typically does not increment until the release of a new balloted version. Implementations SHOULD indicate what version or versions of the FSH specification they implement.

### Issue Reporting and Contributions

* FSH language issues and suggestions can be made [in the HL7 Jira](https://jira.hl7.org/issues/?jql=project%20%3D%20FHIR%20AND%20Specification%20%3D%20%22Shorthand%20(FHIR)%20%5BFHIR-shorthand%5D%22). When filing FSH language or IG issues, use project="FHIR" AND Specification = "Shorthand (FHIR) [FHIR-shorthand]".

* SUSHI bugs, issues, and suggestions can be made [here](https://github.com/FHIR/sushi/issues).

* GoFSH bugs, issues, and suggestions can be made [here](https://github.com/FHIR/GoFSH).

* If your FSH project is not listed in FSH Finder, log an issue [here](https://github.com/FSHSchool/fsh-finder/issues) or submit a pull request on the list of organizations in [settings.yml](https://github.com/FSHSchool/fsh-finder/tree/v1.1).

* FSH examples for inclusion in FSH Online can be contributed [here](https://github.com/FSHSchool/FSHOnline-Examples).


### Authors and Contributors

| Role | Name | Organization | Contact |
|----|----|----|----|
| Author | Mark A. Kramer | MITRE Corporation | mkramer@mitre.org |
| Author | Chris Moesel | MITRE Corporation | cmoesel@mitre.org |
| Contributor | Julia K. Afeltra | MITRE Corporation | jafeltra@mitre.org |
| Contributor | Julian A. Carter | MITRE Corporation | jacarter@mitre.org |
| Contributor | Samantha Citron | MITRE Corporation | scitron@mitre.org |
| Contributor | Nick Freiter | MITRE Corporation | nfreiter@mitre.org |
| Contributor | Joe Paquette | athenahealth | jpaquette@athenahealth.com |
| Contributor | Mint N. Thompson | MITRE Corporation | mathompson@mitre.org |
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
