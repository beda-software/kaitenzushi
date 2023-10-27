RuleSet: AddTelecom(system, value, use)
* contact.telecom[+]
  * system = #{system}
  * value = {value}
  * use = #{use}

RuleSet: AddVariable(name, sourceId, expression)
* variable[+].name = {name}
* variable[=].sourceId = {sourceId}
* variable[=].expression = {expression}

RuleSet: AssertCreated
* setup.action[+].assert.description = "Confirm that the returned HTTP status is 201(created)."
* setup.action[=].assert.direction = #response
* setup.action[=].assert.response = #created
* setup.action[=].assert.warningOnly = false

RuleSet: SetupActionOperation(type, resource, sourceId, responseId, description)
* setup.action[+].operation.type = $testscript-operation-codes#{type}
* setup.action[=].operation.resource = #{resource}
* setup.action[=].operation.sourceId = {sourceId}
* setup.action[=].operation.responseId = {responseId}
* setup.action[=].operation.description = {description}
* setup.action[=].operation.encodeRequestUrl = false

RuleSet: CreateFixtureResource(responseId, resource, sourceId)
* insert SetupActionOperation("create", {resource}, {sourceId}, {responseId}, "Create fixture resource")
* insert AssertCreated

RuleSet: CreateTest(name, description)
* test[+].name = {name}
* test[=].description = {description}

RuleSet: AddFixtureFile(id, fileName)
* insert AddFixture({id}, file://tests/resources/{fileName})

RuleSet: AddFixtureResource(id, reference)
* insert AddFixture({id}, {reference})

RuleSet: AddFixture(id, path)
* fixture[+].id = {id}
* fixture[=].resource.reference = "{path}"
* fixture[=].autocreate = false
* fixture[=].autodelete = false

RuleSet: TeardownWithParams(code, resource, params, description)
* teardown.action[+].operation.type = $testscript-operation-codes#{code}
* teardown.action[=].operation.resource = #{resource}
* teardown.action[=].operation.description = {description}
* teardown.action[=].operation.params = {params}
* teardown.action[=].operation.encodeRequestUrl = true

RuleSet: TeardownParams(resource, params)
* insert TeardownWithParams("delete", {resource}, {params}, "Delete test resources")

RuleSet: TeardownTargetId(resource, targetId)
* insert TeardownWithTargetId("delete", {resource}, {targetId}, "Delete test resources")

RuleSet: TeardownWithTargetId(code, resource, targetId, description)
* teardown.action[+].operation.type = $testscript-operation-codes#{code}
* teardown.action[=].operation.resource = #{resource}
* teardown.action[=].operation.description = {description}
* teardown.action[=].operation.targetId = {targetId}
* teardown.action[=].operation.encodeRequestUrl = true

RuleSet: ExtractQuestionnaire(targetId, sourceId)
* insert TSTestOperationGlobal("extract", "Questionnaire", "Questionnaire data extract", "json", "post", {targetId}, {sourceId})
* insert TSTestAssertSuccessResponse

RuleSet: PopulateQuestionnaire(targetId, sourceId)
* insert TSTestOperationGlobal("populate", "Questionnaire", "Questionnaire population", "json", "post", {targetId}, {sourceId})

RuleSet: TSTestOperationGlobal(type, resource, description, accept, method, targetId, sourceId)
* test[=].action[+].operation
  * type = $testscript-operation-codes#{type}
  * resource = #{resource}
  * description = {description}
  * accept = #{accept}
  * method = #{method}
  * targetId = {targetId}
  * sourceId = {sourceId}
  * encodeRequestUrl = false

RuleSet: SearchFHIRResources(resourceType, params)
* insert TSTestOperationSearch("Search FHIR resources", "search", {resourceType}, {params})

RuleSet: TSTestOperationSearch(description, type, resource, params)
* test[=].action[+].operation
  * description = {description}
  * type = $QuestionnaireResponse-extract#{type}
  * resource = #{resource}
  * encodeRequestUrl = true
  * params = {params}
  * encodeRequestUrl = false

RuleSet: AssertEqualTo(resource, expression, value)
* insert TSTestAssertWithPropEmptySourceIdExpression("Check is equal", {resource}, {value}, "equals", {expression})

RuleSet: TSTestAssertWithPropEmptySourceIdExpression(description, resource, value, operator, expression)
* test[=].action[+].assert
  * description = {description}
  * resource = #{resource}
  * value = {value}
  * operator = #{operator}
  * warningOnly = false
  * expression = {expression}

RuleSet: TSTestAssertSuccessResponse
* test[=].action[+].assert
  * description = "Confirm that the extract returned HTTP status is 200(OK)."
  * direction = #response
  * response = #okay
  * warningOnly = false