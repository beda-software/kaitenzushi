# sushi-sandbox
The simple way to check the transformation of your FSH files into the FHIR JSON.

## Motivation
For research purposes...

As developers of healthcare applications, we manipulate FHIR resources every day, which often have a large number of rows. FSH allows us to reduce the amount of code and thanks to tools such as RuleSet, we can create reusable pieces in FHIR-first applications. We want to find a way to write simple, maintainable FHIR resources for our projects.

**The current main goal is to understand how FSH could help us to create comfortable for developers TestScript resources.**

## How to use
0. ⚙️ Install dependencies
   ```bash
   yarn install
   ```
2. 🐟 Add your FSH file to the /fsh folder;
3. 🔥 Add your FHIR file in JSON format to the /fhir folder (the expected result of the transform from FSH to FHIR);
4. 🧪 Run tests
   ```bash
   yarn test
   ```
## Dictionary
1. **FSH**: FHIR Shorthand (FSH) is a domain-specific language for defining the contents of FHIR Implementation Guides (IG). FSH can be created and updated using any text editor. Because it is text, it enables distributed, team-based development using source code control tools such as GitHub.
2. **RuleSet**: Rule sets provide the ability to define a group of rules as an independent entity.
3. **SUSHI**: SUSHI (SUSHI Unshortens ShortHand Inputs) is a FSH compiler. SUSHI converts FSH language to FHIR artifacts.
4. **TestScript**: A structured set of tests against a FHIR server or client implementation to determine compliance against the FHIR specification.

## References
1. [FSHschool](https://fshschool.org/docs/);
2. [TestScript resource FHIR documentation](https://build.fhir.org/testscript.html);
3. [RuleSet description FHIR documentation](https://build.fhir.org/ig/HL7/fhir-shorthand/reference.html#defining-rule-sets).
