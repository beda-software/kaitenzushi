import * as fs from 'fs';
import * as path from 'path';
import { sushiClient } from 'fsh-sushi';

describe('FSH to FHIR Translation', () => {
    const fshDir = path.join(__dirname, '../fsh');
    const fshFiles = fs.readdirSync(fshDir);

    test.each(fshFiles.filter((file) => !['RuleSet.fsh', 'Aliases.fsh'].includes(file)))('translates %s to FHIR correctly', async (file) => {
        let fshContent = fs.readFileSync(path.join(fshDir, file), 'utf-8');
        const ruleSetContent = fs.readFileSync(path.join(fshDir, 'RuleSet.fsh'), 'utf-8');
        fshContent = `${fshContent}\n\n${ruleSetContent}`;
        const aliasesContent = fs.readFileSync(path.join(fshDir, 'Aliases.fsh'), 'utf-8');
        fshContent = `${fshContent}\n\n${aliasesContent}`;

        const { fhir } = await sushiClient.fshToFhir(fshContent)

        expect(
            fhir.find((resource) => resource.resourceType === file.split('_')?.[0])
        ).toEqual(
            JSON.parse(
                fs.readFileSync(path.join(__dirname, `../fhir/${file.replace('.fsh', '.json')}`), 'utf-8')
            )
        )
    });
});
