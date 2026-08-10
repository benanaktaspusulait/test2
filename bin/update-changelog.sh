#!/bin/sh

# Assign the Maven project version to a variable
PROJECT_VERSION=`mvn org.apache.maven.plugins:maven-help-plugin:3.2.0:evaluate \
    -Dexpression=project.version -q -DforceStdout`

# Use the variable
echo "The project version is: $PROJECT_VERSION"

if echo "$PROJECT_VERSION" | grep -q "\-SNAPSHOT"; then
    echo "This is a snapshot version. No changes will be commited"
    echo "Updating Changelog"
    mvn -q install -DskipTests=true
    echo "Update complete"
else
    echo "This is a release version."
    echo "Updating Changelog"

    echo "Temporarily adding tag ${PROJECT_VERSION}"
    git tag $PROJECT_VERSION

    echo "Building CHANGELOG.md"
    mvn -q install -DskipTests=true
    git tag -d $PROJECT_VERSION

    echo "Commiting changes"
    git add .
    git commit -m "update changelog"
    git push
fi