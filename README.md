# sushi-sandbox
The simple way to check the transformation of your FSH files into the FHIR JSON.

## Motivation
For research purposes...

As developers of healthcare applications, we manipulate FHIR resources every day, which often have a large number of rows. FSH allows us to reduce the amount of code and thanks to tools such as RuleSet, we can create reusable pieces in FHIR-first applications. We want to find a way to write simple, maintainable FHIR resources for our projects.

**The current main goal is to understand how FSH could help us to create comfortable for developers TestScript resources.**

## How to use
### General
0. ⚙️ Install dependencies
   ```bash
   yarn install
   ```
### For the test you implementation FSH -> JSON
0. 🐟 Add your FSH file to the /fsh folder;
1. 🔥 Add your FHIR file in JSON format to the /fhir folder (the expected result of the transform from FSH to FHIR);
2. 🧪 Run tests
   ```bash
   yarn test
   ```
### To convert files FSH -> YAML/JSON
0. Base translate
  ```bash
  yarn convert -i path/to/source/or/single/file
  ```
1. Translate with all parameters
  ```bash
  yarn convert -i path/to/source/or/single/file -o path/to/output/folder -r TestScript -e yaml
  ```
### Notes
1. The FSH file should have a similar name to the JSON file (ex: ./fsh/TestScript_test.fsh => ./fhir/TestScript_test.json);
2. File names should include a prefix with target resourceType (Because in some cases to generate an FHIR resource you should create a few FHIR artifacts and the SUSHI compilator will return back a list of the resources. We should mark a target resource for test purposes);
3. You can use ./fsh/Aliases.fsh to share your aliases between any *.fsh file;
4. You can use ./fsh.RuleSet.fsh to share your rule sets between any *.fsh file;
## Dictionary
1. **FSH**: FHIR Shorthand (FSH) is a domain-specific language for defining the contents of FHIR Implementation Guides (IG). FSH can be created and updated using any text editor. Because it is text, it enables distributed, team-based development using source code control tools such as GitHub.
2. **RuleSet**: Rule sets provide the ability to define a group of rules as an independent entity.
3. **SUSHI**: SUSHI (SUSHI Unshortens ShortHand Inputs) is a FSH compiler. SUSHI converts FSH language to FHIR artifacts.
4. **TestScript**: A structured set of tests against a FHIR server or client implementation to determine compliance against the FHIR specification.

## References
1. [FSHschool](https://fshschool.org/docs/);
2. [TestScript resource FHIR documentation](https://build.fhir.org/testscript.html);
3. [RuleSet description FHIR documentation](https://build.fhir.org/ig/HL7/fhir-shorthand/reference.html#defining-rule-sets).
