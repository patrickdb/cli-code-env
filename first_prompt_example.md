Maak in de huidige map (/workspaces/cli-code-env/sandbox/REST-Test) een minimaal, clean Spring Boot project met precies één REST endpoint.

Project
- Maven (met wrapper, ./mvnw), Spring Boot 4.1.1, Java 21
- groupId `nl.example`, artifactId `rest-test`, package `nl.example.resttest`
- Dependencies: alleen `spring-boot-starter-webmvc` en `spring-boot-starter-webmvc-test` (test scope). Geen andere dependencies.
- Hoofdklasse: `RestTestApplication`
- `application.properties`: alleen `spring.application.name=rest-test`

Endpoint
- Eén controller, `HelloController`, met precies één endpoint: `GET /hello`
- Response: de tekst `Hello World` (content type `text/plain`)
- Geen POST, geen state, geen andere endpoints

Tests (JUnit 5 + MockMvc, `@SpringBootTest` + `@AutoConfigureMockMvc`)
- `HelloControllerTests`: GET /hello geeft status 200 en body `Hello World`; POST /hello geeft status 405
- `RestTestApplicationTests`: `contextLoads`

Stijl
- Tabs voor inspringing, standaard Spring Boot-indeling (src/main/java, src/test/java)
- Geen overbodige bestanden of code, geen commentaar dat het voor de hand liggende uitlegt

Klaar als
- `./mvnw test` , alle testen slagen. Lees de surefire-rapporten in target/surefire-reports om dat te bevestigen.
- Niet committen en niets pushen
- Sluit af met een korte samenvatting van wat er staat