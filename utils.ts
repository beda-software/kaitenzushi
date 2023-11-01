import { fetchGHFile, getFSHFileList } from "./scripts/fetchDeps"

export async function getDependencyFSH(dependencyUrl: string, token?: string): Promise<string[]> {
    const response = await getFSHFileList(dependencyUrl, token)
    console.info(`Found files ${response.join(', ')} from ${dependencyUrl}. Starting to fetch...`)

    return await Promise.all(response.map(async (filePath) => await fetchGHFile(dependencyUrl, filePath, token)))
}

export function mergeFSHContent(toString: string, fromStringArr: string[]){
    return [toString, ...fromStringArr].join('\n\n');
}