Alias: $v2-0203 = http://terminology.hl7.org/CodeSystem/v2-0203
Alias: $v2-0131 = http://terminology.hl7.org/CodeSystem/v2-0131

Instance: example
InstanceOf: Patient
Usage: #example
* identifier.use = #usual
* identifier.type = $v2-0203#MR "Medical record number"
* identifier.type.text = "Medical record number"
* identifier.system = "http://hospital.example.org"
* identifier.value = "123456"
* active = true
* name.use = #official
* name.family = "Doe"
* name.given = "John"
* gender = #male
* birthDate = "1990-03-03"
* address.use = #home
* address.line = "123 Main St"
* address.city = "Anytown"
* address.state = "CA"
* address.postalCode = "12345"
* address.country = "USA"
* contact.relationship = $v2-0131#N "Emergency Contact"
* contact.name.family = "Doe"
* contact.name.given = "Jane"
* contact.telecom.system = #phone
* contact.telecom.value = "555-555-5555"
* contact.telecom.use = #mobile