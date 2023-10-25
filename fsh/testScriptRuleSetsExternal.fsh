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
* insert PopulateQuestionnaire("complete-encounter-questionnaire-fixture", "launch-context-params")
* insert AssertEqualTo(
    "QuestionnaireResponse",
    [["QuestionnaireResponse.repeat(item\).where(linkId='current-encounter-id'\).answer.value.string"]],
    "encounter1")
* insert AssertEqualTo(
    "QuestionnaireResponse",
    [["QuestionnaireResponse.repeat(item\).where(linkId='healthcare-service-code'\).answer.value.string"]],
    "consultation")
* insert AssertEqualTo(
    "QuestionnaireResponse",
    [["QuestionnaireResponse.repeat(item\).where(linkId='healthcare-service-name'\).answer.value.string"]],
    "The first appointment")

* insert CreateTest("complete-encounter-extract", "Check extract")
* insert ExtractQuestionnaire("complete-encounter-questionnaire-fixture", "complete-encounter-extract-parameters-fixture")
* insert SearchFHIRResources("Invoice", "?subject=patient3")
* insert AssertEqualTo("Bundle", "Bundle.total", "1")
* insert AssertEqualTo("Bundle", "Bundle.entry.resource.subject.id", "patient3")
* insert AssertEqualTo("Bundle", "Bundle.entry.resource.participant.actor.id", "practitioner1")
* insert AssertEqualTo("Bundle", [["Bundle.entry.resource.lineItem.count(\)"]], "1")
* insert AssertEqualTo("Bundle", [["Bundle.entry.resource.lineItem.priceComponent.where(type='base'\).amount.value"]], "50")
* insert AssertEqualTo("Bundle", [["Bundle.entry.resource.lineItem.priceComponent.where(type='tax'\).amount.value"]], "10")
* insert SearchFHIRResources("ChargeItem", "?subject=patient3")
* insert AssertEqualTo("Bundle", "Bundle.total", "1")
* insert AssertEqualTo("Bundle", "Bundle.entry.resource.subject.id", "patient3")
* insert AssertEqualTo("Bundle", "Bundle.entry.resource.code.coding.code", "${launched-encounter-class-code}")
* insert AssertEqualTo("Bundle", "Bundle.entry.resource.code.coding.display", "${launched-encounter-class-display}")

* insert TeardownTargetId("Patient", "create-test-patient")
* insert TeardownTargetId("Encounter", "create-test-encounter")
* insert TeardownTargetId("Appointment", "create-test-appointment")
* insert TeardownParams("Invoice", "?subject=patient3")
* insert TeardownParams("ChargeItem", "?subject=patient3")
