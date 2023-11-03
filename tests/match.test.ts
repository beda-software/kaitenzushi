import * as fs from 'fs';
import * as path from 'path';
import { sushiClient } from 'fsh-sushi';
import { getDependencyFSH, mergeFSHContent } from '../utils';

describe('FSH to FHIR Translation', () => {
    const fshDir = path.join(__dirname, '../fsh');
    const fshFiles = fs.readdirSync(fshDir);

    test.each(fshFiles)('translates %s to FHIR correctly', async (file) => {
        const fshContent = fs.readFileSync(path.join(fshDir, file), 'utf-8');
        const externalFSH = await getDependencyFSH('https://github.com/beda-software/beda-emr-core', '.tmp')

        const { fhir } = await sushiClient.fshToFhir(mergeFSHContent(fshContent, externalFSH))

        expect(
            fhir.find((resource) => resource.resourceType === file.split('_')?.[0])
        ).toEqual(
            JSON.parse(
                fs.readFileSync(path.join(__dirname, `../fhir/${file.replace('.fsh', '.json')}`), 'utf-8')
            )
        )
    });
});
