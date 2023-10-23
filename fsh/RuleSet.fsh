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

RuleSet: SetupActionOperationSuccess(type, resource, sourceId, responseId, description)
* insert SetupActionOperation({type}, {resource}, {sourceId}, {responseId}, {description})
* insert AssertCreated

RuleSet: CreateTest(name, description)
* test[+].name = {name}
* test[=].description = {description}

RuleSet: AddFixtureFile(id, fileName)
* insert AddFixture({id}, file://tests/resources/{fileName})

RuleSet: AddFixtureResource(id, resourceType, resourceId)
* insert AddFixture({id}, {resourceType}/{resourceId})

RuleSet: AddFixture(id, path)
* fixture[+].id = {id}
* fixture[=].resource = Reference({path})
* fixture[=].autocreate = false
* fixture[=].autodelete = false

RuleSet: TeardownWithParams(code, resource, params, description)
* teardown.action[+].operation.type = $testscript-operation-codes#{code}
* teardown.action[=].operation.resource = #{resource}
* teardown.action[=].operation.description = {description}
* teardown.action[=].operation.params = {params}
* teardown.action[=].operation.encodeRequestUrl = true

RuleSet: TeardownWithTargetId(code, resource, targetId, description)
* teardown.action[+].operation.type = $testscript-operation-codes#{code}
* teardown.action[=].operation.resource = #{resource}
* teardown.action[=].operation.description = {description}
* teardown.action[=].operation.targetId = {targetId}
* teardown.action[=].operation.encodeRequestUrl = true

RuleSet: TSTestOperationGlobal(type, resource, description, accept, method, targetId, sourceId, responseId)
* test[=].action[+].operation
  * type = $testscript-operation-codes#{type}
  * resource = #{resource}
  * description = {description}
  * accept = #{accept}
  * method = #{method}
  * targetId = {targetId}
  * sourceId = {sourceId}
  * responseId = {responseId}
  * encodeRequestUrl = false

RuleSet: TSTestOperationSearch(description, type, resource, params, responseId)
* test[=].action[+].operation
  * description = {description}
  * type = $QuestionnaireResponse-extract#{type}
  * resource = #{resource}
  * encodeRequestUrl = true
  * params = {params}
  * responseId = {responseId}
  * encodeRequestUrl = false

RuleSet: TSTestAssertWithProp(description, resource, sourceId, value, operator)
* test[=].action[+].assert
  * description = {description}
  * resource = #{resource}
  * sourceId = {sourceId}
  * value = {value}
  * operator = #{operator}
  * warningOnly = false

RuleSet: TSTestAssertWithPropEmptySourceId(description, resource, value, operator)
* test[=].action[+].assert
  * description = {description}
  * resource = #{resource}
  * value = {value}
  * operator = #{operator}
  * warningOnly = false

RuleSet: TSTestAssertSuccessResponse
* test[=].action[+].assert
  * description = "Confirm that the extract returned HTTP status is 200(OK)."
  * direction = #response
  * response = #okay
  * warningOnly = false