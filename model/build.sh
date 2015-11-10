#!/bin/bash
cd "`dirname "$0"`"

quitIfError() {
  if [ $? -ne 0 ]; then
    echo 'An error has occurred, aborting compilation!'
    exit 1
  fi
}

# Get time and date without independent of locale
SNAPSHOT=`date '+%Y%m%d-%H%M%S'`
HEAD_PACKAGE=fpdemo
PACKAGE="$HEAD_PACKAGE"

MODEL_JAR="fpdemo-model-$SNAPSHOT.jar"
MODEL_SRC="fpdemo-model-$SNAPSHOT-sources.jar"

# Cache compiler download
COMPILER_DOWNLOADED=
if [ -f temp/compile/dsl-compiler.exe ]
then
  mv temp/compile/dsl-compiler.exe temp/dsl-compiler.exe
  COMPILER_DOWNLOADED==temp/dsl-compiler.exe
fi

# Remove old compilation results
echo 'Cleaning old compilation ...'
rm -f temp/output/*.jar
mkdir -p temp/output

rm -rf temp/compile
mkdir -p temp/compile

rm -rf temp/source/revenj.java
mkdir -p temp/source/revenj.java

# Create model jar, apply migration
echo "Compiling model to temp/output/$MODEL_JAR ..."
java -jar dsl-clc.jar \
  dsl=dsl \
  temp=temp/compile \
  "compiler$COMPILER_DOWNLOADED" \
  download \
  "namespace=$PACKAGE" \
  sql=sql \
  dependencies:revenj.java=temp/dependencies/revenj.java \
  "revenj.java=temp/output/$MODEL_JAR" \
  migration \
  'postgres=fpdemo-postgres:5432/fpdb?user=fpuser&password=fppass' \
  apply
quitIfError

# Copy sources so that we can archive them
mv "temp/compile/REVENJ_JAVA/$HEAD_PACKAGE" temp/source/revenj.java

# Format SQL script and Java sources
# This also "fixes" the paths in database_migration scripts
echo 'Running code formatter ...'
java -jar dsl-clc-formatter-0.2.1.jar \
  sql \
  temp/source
quitIfError

# Creates the source package
echo "Archiving sources to temp/output/$MODEL_SRC ..."
jar cfM "temp/output/$MODEL_SRC" -C temp/source/revenj.java/ .
quitIfError

deploy() {
  rm -f $2
  if [ -f $2 ]; then
    echo "WARNING: Could not remove $2 - is it being used?"
    read -p 'Press enter to try again!'
    rm -f $2
    if [ -f $2 ]; then
      echo "ERROR: You should deploy $1 manually!"
      echo "ERROR: Could not remove $2 - it is still being used!"
      return
    fi
  fi
  cp $1 $2
}

# Try to clean old libraries, copy output to lib
deploy "temp/output/$MODEL_JAR" "../code/lib/fpdemo-model.jar"
deploy "temp/output/$MODEL_SRC" "../code/lib/fpdemo-model-sources.jar"

exit 0
