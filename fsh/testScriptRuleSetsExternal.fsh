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
* insert AddFixtureResource("complete-encounter-questionnaire-fixture", Questionnaire/complete-encounter)
* insert AddFixtureResource("launch-context-params", Parameters/complete-encounter-populate-launch-context-params)

* insert AddVariable("launched-encounter-id", "launched-encounter", "Encounter.id")
* insert AddVariable("launched-encounter-class-code", "launched-encounter", "Encounter.class.code")
* insert AddVariable("launched-encounter-class-display", "launched-encounter", "Encounter.class.display")

* insert CreateFixtureResource("Patient", "patient", "create-test-patient")
* insert CreateFixtureResource("Appointment", "appointment", "create-test-appointment")
* insert CreateFixtureResource("Encounter", "launched-encounter", "create-test-encounter")

* insert CreateTest("complete-encounter-populate", "Check populated fields")
* insert PopulateQuestionnaire("complete-encounter-questionnaire-fixture", "launch-context-params", "populate-response")
* insert AssertQRFieldEqualTo("populate-response", "encounter1", [["QuestionnaireResponse.repeat(item\).where(linkId='current-encounter-id'\).answer.value.string"]])
* insert AssertQRFieldEqualTo("populate-response", "consultation", [["QuestionnaireResponse.repeat(item\).where(linkId='healthcare-service-code'\).answer.value.string"]])
* insert AssertQRFieldEqualTo("populate-response", "The first appointment", [["QuestionnaireResponse.repeat(item\).where(linkId='healthcare-service-name'\).answer.value.string"]])

* insert CreateTest("complete-encounter-extract", "Check extract")
* insert ExtractQuestionnaire("complete-encounter-questionnaire-fixture", "complete-encounter-extract-parameters-fixture", "extract-response")
* insert SearchFHIRResources("Invoice", "?subject=patient3", "searched-invoices")
* insert AssertEqualTo("Bundle", "1", "Bundle.total")
* insert AssertEqualTo("Bundle", "patient3", "Bundle.entry.resource.subject.id")
* insert AssertEqualTo("Bundle", "practitioner1", "Bundle.entry.resource.participant.actor.id")
* insert AssertEqualTo("Bundle", "1", [["Bundle.entry.resource.lineItem.count(\)"]])
* insert AssertEqualTo("Bundle", "50", [["Bundle.entry.resource.lineItem.priceComponent.where(type='base'\).amount.value"]])
* insert AssertEqualTo("Bundle", "10", [["Bundle.entry.resource.lineItem.priceComponent.where(type='tax'\).amount.value"]])
* insert SearchFHIRResources("ChargeItem", "?subject=patient3", "searched-charge-items")
* insert AssertEqualTo("Bundle", "1", "Bundle.total")
* insert AssertEqualTo("Bundle", "patient3", "Bundle.entry.resource.subject.id")
* insert AssertEqualTo("Bundle", "${launched-encounter-class-code}", "Bundle.entry.resource.code.coding.code")
* insert AssertEqualTo("Bundle", "${launched-encounter-class-display}", "Bundle.entry.resource.code.coding.display")

* insert TeardownTargetId("Patient", "create-test-patient")
* insert TeardownTargetId("Encounter", "create-test-encounter")
* insert TeardownTargetId("Appointment", "create-test-appointment")
* insert TeardownParams("Invoice", "?subject=patient3")
* insert TeardownParams("ChargeItem", "?subject=patient3")
