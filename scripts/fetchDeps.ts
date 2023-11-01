import axios from 'axios';

export async function getFSHFileList(repoUrl: string, token?: string): Promise<string[]> {
    const [owner, repo] = getOwnerRepo(repoUrl);

    async function fetchPath(path: string): Promise<string[]> {
        const filePaths: string[] = [];
        const headers = token ? { Authorization: `token ${token}` } : undefined;

        try {
            const response = await axios.get(getUrl(owner, repo, path), { headers });
            const jsonData = response.data;

            if (Array.isArray(jsonData)) {
                const promises: Promise<string[]>[] = jsonData.map(item => {
                    if (item.type === 'file' && item.name.endsWith("fsh")) {
                        filePaths.push(item.path);
                        return Promise.resolve([]);
                    } else if (item.type === 'dir') {
                        return fetchPath(item.path);
                    }
                    return Promise.resolve([]);
                });

                const nestedPaths = await Promise.all(promises);
                nestedPaths.forEach(paths => filePaths.push(...paths));
            }

            return filePaths;
        } catch (error) {
            throw new Error(`Got error: ${error}`);
        }
    }

    return fetchPath('');
}

export async function fetchGHFile(repoUrl: string, path: string, token?: string): Promise<string> {
    const [owner, repo] = getOwnerRepo(repoUrl);
    const headers = token ? { Authorization: `token ${token}` } : undefined;

    try {
        const response = await axios.get(getUrl(owner, repo, path), { headers, responseType: 'json' });
        const content = Buffer.from(response.data.content, 'base64').toString('utf-8');
        return content;
    } catch (error) {
        throw new Error(`Error fetching file: ${error}`);
    }
}

function getOwnerRepo(repoUrl: string): string[] {
    return repoUrl.split('/').slice(-2);
}

function getUrl(owner: string, repo: string, path: string): string {
    return `https://api.github.com/repos/${owner}/${repo}/contents/${path}`;
}
