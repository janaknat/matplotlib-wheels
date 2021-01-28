export REPO_DIR=matplotlib
export BUILD_COMMIT=v3.2.1
export MB_PYTHON_VERSION=3.7
export PLAT=aarch64
export MB_ML_VER=2014
export DOCKER_TEST_IMAGE=multibuild/xenial_aarch64
export NP_BUILD_DEP=1.19
export NP_TEST_DEP=1.19
export CONTAINER=pre-release
export BUILD_DEPENDS="numpy==$NP_BUILD_DEP"
source multibuild/common_utils.sh
source multibuild/travis_steps.sh
before_install
clean_code $REPO_DIR $BUILD_COMMIT
build_wheel $REPO_DIR $PLAT
pip install delocate
python rm_test_images.py wheelhouse/*.whl
export TEST_DEPENDS="numpy==$NP_TEST_DEP sphinx pytest pytest-timeout pytest-xdist pytest-faulthandler pytest-rerunfailures requests[security]"
ulimit -n 4096
install_run $PLAT
ANACONDA_ORG="multibuild-wheels-staging"
pip install git+https://github.com/Anaconda-Server/anaconda-client;
anaconda -t ${MULTIBUILD_WHEELS_STAGING_ACCESS} upload --force -u ${ANACONDA_ORG} ${TRAVIS_BUILD_DIR}/wheelhouse/*.whl
