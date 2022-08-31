# bashScripts

1. Add any or all of the bash files to your $HOME directory.
2. Modify .bashrc to include the following condition for each file:

```
# include repoRestart.bash if it exists
if [ -f $HOME/fileName.bash ]; then
    . $HOME/fileName.bash
fi
```
3. Source the newly modified .bashrc file by running `source ~/.bashrc`
4. You're ready to start running the scripts!


# repoRestart

Prereqs:
1. Modify `app.server.USERNAME.properties` to include the key `base.branch` witht he value of the base branch of the repo (master, 7.3.x, etc)
2. (Optional) Modify `app.server.USERNAME.properties` to include the key `db.name` with the value being the name of the schema which your deployed bundle runs on (MySQL only!)
3. `repoRestart.bash` added to `.bashrc` and sourced

Usage:
Run the `repoRestart` command from the root directory of your local Liferay repo.

Details:
When ran inside a given local Liferay repo, the repo is cleaned, reset to the base branch, fetched from upstream, merged, cleaned (again), compiled, and (optionally) schema dropped and recreated.
This script is a good way of starting your work week while checking emails, or better yet on a Sunday night.  Just run the `repoRestart` command, and come back an hour later to a fresh bundle.

ToDo:
1. Make the script run across all versions, so we run one command for all specified branches.
2. Incorperate @holatuwol's IntelliJ script to also regenerate all the IML files, library descriptors, and the modules.xml file.


# pr

Prereqs
1. `pr.bash` added to `.bashrc` and sourced

Usage:
Run `pr [<githubId>] [<branchName>] [<newBranchName>] [-ee]