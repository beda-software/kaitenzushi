Instance: complete-encounter-questionnaire-ts-test
InstanceOf: TestScript
Usage: #example
* url = "https://beda.software/TestScript/vitals"
* name = "complete-encounter-questionnaire-sc-test"
* status = #draft
* date = "2023-03-21"
* publisher = "Beda Software"
* contact.name = "Support"
* insert AddTelecom("email", "ilya@beda.software", "work")
* insert AddTelecom("email", "pavel.r@beda.software", "work")
* insert AddFixtureFile("patient", patient1.yaml)
* insert AddFixtureFile("appointment", appointment.yaml)
* insert AddFixtureFile("launched-encounter", encounter.yaml)
* insert AddFixtureFile("complete-encounter-questionnaire-response", complete-encounter-questionnaire-response.yaml)
* insert AddFixtureFile("complete-encounter-extract-parameters-fixture", complete-encounter-extract-request-body.yaml)
* insert AddFixtureResource("complete-encounter-questionnaire-fixture", Questionnaire, complete-encounter)
* insert AddFixtureResource("launch-context-params", Parameters, complete-encounter-populate-launch-context-params)

* insert AddVariable("launched-encounter-id", "launched-encounter", "Encounter.id")
* insert AddVariable("launched-encounter-class-code", "launched-encounter", "Encounter.class.code")
* insert AddVariable("launched-encounter-class-display", "launched-encounter", "Encounter.class.display")

* insert SetupActionOperationSuccess("create", "Patient", "patient", "create-test-patient", "Create Patient")
* insert SetupActionOperationSuccess("create", "Appointment", "appointment", "create-test-appointment", "Create Appointment")
* insert SetupActionOperationSuccess("create", "Encounter", "launched-encounter", "create-test-encounter", "Create Encounter")

* insert CreateTest("complete-encounter-populate", "Run SDC $populate against the vitals questionnaire and check populated fields\n")
* insert TSTestOperationGlobal("populate", "Questionnaire", "Questionnaire population", "json", "post", "complete-encounter-questionnaire-fixture", "launch-context-params", "populate-response")
* insert TSTestAssertWithProp("check populated encounter ID", "QuestionnaireResponse", "populate-response", "encounter1", "equals")
* test[=].action[=].assert.expression = "QuestionnaireResponse.repeat(item).where(linkId='current-encounter-id').answer.value.string"
* insert TSTestAssertWithProp("check populated service code", "QuestionnaireResponse", "populate-response", "consultation", "equals")
* test[=].action[=].assert.expression = "QuestionnaireResponse.repeat(item).where(linkId='healthcare-service-code').answer.value.string"
* insert TSTestAssertWithProp("check populated service name", "QuestionnaireResponse", "populate-response", "The first appointment", "equals")
* test[=].action[=].assert.expression = "QuestionnaireResponse.repeat(item).where(linkId='healthcare-service-name').answer.value.string"

* insert CreateTest("complete-encounter-extract", "Run SDC $extract against the vitals questionnaire and check created resources\n")
* insert TSTestOperationGlobal("extract", "Questionnaire", "Questionnaire data extract", "json", "post", "complete-encounter-questionnaire-fixture", "complete-encounter-extract-parameters-fixture", "extract-response")
* insert TSTestAssertSuccessResponse
* insert TSTestOperationSearch("Get invoices created during the extract", "search", "Invoice", "?subject=patient3", "searched-invoices")
* insert TSTestAssertWithPropEmptySourceId("Check the total number of returned invoices", "Bundle", "1", "equals")
* test[=].action[=].assert.expression = "Bundle.total"
* insert TSTestAssertWithPropEmptySourceId("Check the subject id of returned Invoice", "Bundle", "patient3", "equals")
* test[=].action[=].assert.expression = "Bundle.entry.resource.subject.id"
* insert TSTestAssertWithPropEmptySourceId("Check the subject id of returned Invoice", "Bundle", "practitioner1", "equals")
* test[=].action[=].assert.expression = "Bundle.entry.resource.participant.actor.id"
* insert TSTestAssertWithPropEmptySourceId("Check the length of line items", "Bundle", "1", "equals")
* test[=].action[=].assert.expression = "Bundle.entry.resource.lineItem.count()"
* insert TSTestAssertWithPropEmptySourceId("Check the price component base data", "Bundle", "50", "equals")
* test[=].action[=].assert.expression = "Bundle.entry.resource.lineItem.priceComponent.where(type='base').amount.value"
* insert TSTestAssertWithPropEmptySourceId("Check the price component tax data", "Bundle", "10", "equals")
* test[=].action[=].assert.expression = "Bundle.entry.resource.lineItem.priceComponent.where(type='tax').amount.value"
* insert TSTestOperationSearch("Get charge items created during the extract", "search", "ChargeItem", "?subject=patient3", "searched-charge-items")
* insert TSTestAssertWithPropEmptySourceId("Check number of charge items", "Bundle", "1", "equals")
* test[=].action[=].assert.expression = "Bundle.total"
* insert TSTestAssertWithPropEmptySourceId("Check the subject of charge item", "Bundle", "patient3", "equals")
* test[=].action[=].assert.expression = "Bundle.entry.resource.subject.id"
* insert TSTestAssertWithPropEmptySourceId("ChargeItem code is equal to encounter class code", "Bundle", "${launched-encounter-class-code}", "equals")
* test[=].action[=].assert.expression = "Bundle.entry.resource.code.coding.code"
* insert TSTestAssertWithPropEmptySourceId("ChargeItem code is equal to encounter class display", "Bundle", "${launched-encounter-class-display}", "equals")
* test[=].action[=].assert.expression = "Bundle.entry.resource.code.coding.display"

* insert TeardownWithTargetId("delete", "Patient", "create-test-patient", "Delete test patient resource")
* insert TeardownWithTargetId("delete", "Encounter", "create-test-encounter", "Delete test encounter resource")
* insert TeardownWithTargetId("delete", "Appointment", "create-test-appointment", "Delete test appointment resource")
* insert TeardownWithParams("delete", "Invoice", "?subject=patient3", "Delete test invoice resource")
* insert TeardownWithParams("delete", "ChargeItem", "?subject=patient3", "Delete test chargeitem resource")
