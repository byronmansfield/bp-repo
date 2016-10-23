# Boilerplate Repo

A simple repo to store some common new repo setup config files. I started this repository to have a solution to initializing new git projects. I'm lazy, and hate trying to keep track or all these things or forget to add something, etc. Most of these boilerplate files will have a full list of things that will more than likely not be needed by most projects. It's just easier to delete what you don't need, rather than search around for the things (over and over) that you need but don't bother to computer to memory.

It is possible this project might spawn into something project type specific and maybe store those versions in a specific branch.

# Usage

Basic idea/workflow.

1. Create new repo in github then local
  1. `mkdir <name> && cd $_`
  2. `git init`
2. Pull this repo
  1. `git remote add origin git@github.com:byronmansfield/bp-repo.git`
  2. `git pull origin master`
  3. If you need a specific branch, check that one out `git checkout golang`
3. Make changes to whatever files you would like (e.g. README.md, .gitignore, etc)
4. Reassign remote origin `git remote set-url origin git@github.com:USERNAME/OTHERREPOSITORY.git`
... Don't forget to double check remote url `git remote -v`
5. Push your new repository `git push origin master`

Thats basically it. Enjoy.
