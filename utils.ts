import fs from 'fs';
import path from 'path';
import simpleGit from 'simple-git';

const git = simpleGit();

export async function getDependencyFSH(dependencyUrl: string, targetFolder: string) {
    await cloneDepsRepo(dependencyUrl, targetFolder)
    const fileList = scanDepsFile(targetFolder)
    console.log(`FSH deps found: ${fileList.join(', ')}`)
    const result = fileList.map((filePath) => getFileContent(filePath))

    return result
}

export function mergeFSHContent(toString: string, fromStringArr: string[]){
    return [toString, ...fromStringArr].join('\n\n');
}

async function cloneDepsRepo(repoUrl: string, targetFolder: string) {
    try {
        await git.clone(repoUrl, `./${targetFolder}/${repoUrl}`);
        console.log('Repository cloned successfully.');
    } catch (err) {
        console.error('An error occurred:', err);
    }
}

function scanDepsFile(folderPath: string, fileList: string[] = []) {
    const files = fs.readdirSync(folderPath);

    files.forEach(file => {
        const filePath = path.join(folderPath, file);
        const stat = fs.statSync(filePath);

        if (stat.isDirectory()) {
            scanDepsFile(filePath, fileList);
        } else if (path.extname(file) === '.fsh') {
            fileList.push(filePath);
        }
    });

    return fileList;
}

function getFileContent(filePath: string): string {
    try {
        const data = fs.readFileSync(filePath, { encoding: 'utf-8' });
        return data;
    } catch (err) {
        console.error('Error reading file:', err);
        return '';
    }
}
