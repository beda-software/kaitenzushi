import * as fs from 'fs';
import * as path from 'path';
import { sushiClient } from 'fsh-sushi';
import * as yaml from 'js-yaml';
import yargs from 'yargs';

async function convertFSHtoJSON(file: string, outputDir: string, resourceType: string, extension: string) {
    const fshDir = path.join(__dirname, '../fsh');
    let fshContent = fs.readFileSync(path.join(file), 'utf-8');
    const ruleSetContent = fs.readFileSync(path.join(fshDir, 'RuleSet.fsh'), 'utf-8');
    fshContent = `${fshContent}\n\n${ruleSetContent}`;
    const aliasesContent = fs.readFileSync(path.join(fshDir, 'Aliases.fsh'), 'utf-8');
    fshContent = `${fshContent}\n\n${aliasesContent}`;

    const { fhir } = await sushiClient.fshToFhir(fshContent);

    const result = fhir.find((resource) => resource.resourceType === resourceType);
    const fileNameWithoutExtension = path.basename(file, path.extname(file));
    const outputPath = path.join(outputDir, `${fileNameWithoutExtension}.${extension}`);
    if (extension === 'yaml') {
        const yamlContent = yaml.dump(result);
        fs.writeFileSync(outputPath, yamlContent, 'utf-8');
    } else {
        fs.writeFileSync(outputPath, JSON.stringify(result, null, 2), 'utf-8');
    }

    console.log(`Result saved to ${outputPath}`);
}

async function getArgs() {
    const argv = yargs.options({
        inputPath: { type: 'string', demandOption: true, alias: 'i', description: 'Path to folder or single file' },
        outputPath: { type: 'string', demandOption: false, alias: 'o', description: 'Place to keep results (by default is artifacts)' },
        resourceType: { type: 'string', demandOption: false, alias: 'r', description: 'Target resource to translate (by default is TestScript' },
        extension: { type: 'string', demandOption: false, alias: 'e', description: 'Extension of the result. Can be yaml or json. (by default is json)' },
    }).argv;

    return argv
}

getArgs().then(argv => {
    const inputPath = argv.inputPath;
    const outputDir = argv.outputPath ?? 'artifacts';
    const resourceType = argv.resourceType ?? 'TestScript';
    const extension = argv.extension ?? 'yaml';

    if (!inputPath || !outputDir) {
        console.error('Please provide both the path to the file or directory and the output directory as arguments.');
        process.exit(1);
    }

    if (!fs.existsSync(outputDir)) {
        fs.mkdirSync(outputDir, { recursive: true });
    }

    const stats = fs.statSync(inputPath);

    if (stats.isDirectory()) {
        const files = fs.readdirSync(inputPath);
        for (const file of files) {
            if (path.extname(file) !== '.fsh') {
                continue;
            }
            const filePath = path.join(inputPath, file);
            convertFSHtoJSON(filePath, outputDir, resourceType, extension).catch(error => {
                console.error(`Error processing ${file}:`, error);
            });
        }
    } else if (stats.isFile()) {
        if (path.extname(inputPath) === '.fsh') {
            convertFSHtoJSON(inputPath, outputDir, resourceType, extension).catch(error => {
                console.error('Error:', error);
                process.exit(1);
            });
        } else {
            console.error('The provided file does not have a .fsh extension.');
            process.exit(1);
        }
    } else {
        console.error('The provided path is neither a file nor a directory.');
        process.exit(1);
    }
})
