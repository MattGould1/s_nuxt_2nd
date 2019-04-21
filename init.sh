#!/bin/bash
set -e

S_BASE_ROOT="$(cd "$(dirname "$0")" && cd .. && pwd)"
cd $S_BASE_ROOT

if [ "$(basename $(echo $S_BASE_ROOT))" != "s_base" ]; then
  echo "Can't run from this directory."
  exit 1
fi

function base_fetch {
  NAME=$1
  VERSION=$2
  # UNCOMMENT AND CORRECT FOR LOCAL SETUP (development)
  # LOCAL_PATH=../../../s_bases

  rm -rf ./${NAME}
  rm -rf ./${NAME}_cache

  # UNCOMMENT FOR REMOTE SETUP (default)
  git clone --single-branch -b $VERSION https://github.com/saavuio/$NAME
  # UNCOMMENT FOR LOCAL SETUP (development)
  # cp -a ${LOCAL_PATH}/${NAME}/ ./$NAME

  # UNCOMMENT FOR REMOTE SETUP (default)
  git clone --single-branch -b $VERSION https://github.com/saavuio/${NAME}_cache
  # UNCOMMENT FOR LOCAL SETUP (development)
  # mv ./$NAME/base/node_modules_cache ${NAME}_cache

  cp ${NAME}_cache/node_modules.tar.bz2 ${NAME}/base

  S_BASE_NAME=$NAME S_BASE_VERSION=$VERSION PROJECT_ROOT_PATH=.. \
    ./$NAME/scripts/after_base_fetch.sh
}

function base_build {
  NAME=$1
  VERSION=$2
  S_BASE_NAME=$NAME S_BASE_VERSION=$VERSION PROJECT_ROOT_PATH=.. \
    ./$NAME/scripts/base_build.sh
  S_BASE_NAME=$NAME S_BASE_VERSION=$VERSION PROJECT_ROOT_PATH=.. \
    ./$NAME/scripts/after_base_build.sh
}

# -- s_nuxt_2nd
if [ ! -d s_nuxt_2nd ] || [ -z $OBF ]; then
  base_fetch "s_nuxt_2nd" "v1"
  base_build "s_nuxt_2nd" "v1"
fi

