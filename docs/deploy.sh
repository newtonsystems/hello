#/bin/bash

#
# Created using version: COOKIECUTTER V1
#


# Gratitiously stolen from:
# https://github.com/Villanuevand/deployment-circleci-gh-pages/blob/master/scripts/deploy.sh
################################################################################
# Script used from: https://github.com/eldarlabs/ghpages-deploy-script
#!/bin/sh
# ideas used from https://gist.github.com/motemen/8595451

# abort the script if there is a non-zero error
set -e

# show where we are on the machine
pwd

remote=git@github.com:newtonsystems/hello.git

siteSource="$1"

if [ ! -d "$siteSource" ]
then
    echo "Usage: $0 app"
    exit 1
fi

# make a directory to put the gh-pages branch
mkdir -p _build
cd _build
# now lets setup a new repo so we can update the gh-pages branch
git config --global user.email "james.tarball@gmail.com" > /dev/null 2>&1
git config --global user.name "JTarball" > /dev/null 2>&1
git init
git remote add --fetch origin "$remote"

# switch into the the gh-pages branch
if git rev-parse --verify origin/gh-pages > /dev/null 2>&1
then
    git checkout gh-pages
    # delete any old site as we are going to replace it
    # Note: this explodes if there aren't any, so moving it here for now
    if [ "$(ls)" ];
    then
        git rm -rf .
    fi
else
    git checkout --orphan gh-pages
fi

# If not built - build the docs
if [ ! -d ../docs/build ];
then
    make html
fi

# copy over or recompile the new site
cp -a "../${siteSource}/." .

# stage any changes and new files
git add -A

# now commit, ignoring branch gh-pages doesn't seem to work, so trying skip
git commit --allow-empty -m "Deploy to GitHub pages [ci skip] for `git log -1 --pretty=short --abbrev-commit`"

# and push, but send any output to /dev/null to hide anything sensitive
git push --force origin gh-pages

# go back to where we started and remove the gh-pages git repo we made and used
# for deployment
cd ..
rm -rf _build

echo "Finished Deployment of docs!"
echo "You can view it at: https://newtonsystems.github.io/hello/"
