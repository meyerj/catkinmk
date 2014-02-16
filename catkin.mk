PARENT_WORKSPACE ?= /opt/ros/hydro
SOURCE_DIR ?= src
ISOLATED ?= 0
FORCE_CMAKE ?= 0
CMAKE_EXTRA_ARGS ?=
MAKE_EXTRA_ARGS ?=

ifeq ($(ISOLATED),1)
_ISOLATED := _isolated
else
_ISOLATED := _default
endif

ifeq ($(FORCE_CMAKE),1)
_FORCE_CMAKE := --force-cmake
endif

ifeq ($(prefix),)
DEFAULT_PREFIX := install
DEFAULT_PREFIX_isolated := install_isolated
prefix := $(DEFAULT_PREFIX$(_ISOLATED))
endif

# Start with a clean catkin environment
unexport CMAKE_PREFIX_PATH
unexport ROS_PACKAGE_PATH
unexport PKG_CONFIG_PATH
unexport PYTHONPATH
unexport CPATH

build: build_catkin_make$(_ISOLATED)
install: install_catkin_make$(_ISOLATED)
uninstall: uninstall$(_ISOLATED)

prepare:

build_catkin_make_default: prepare
	$(PARENT_WORKSPACE)/env.sh catkin_make $(_FORCE_CMAKE) --source $(SOURCE_DIR) --cmake-args $(CMAKE_EXTRA_ARGS) --make-args $(MAKE_EXTRA_ARGS)

install_catkin_make_default: prepare
	$(PARENT_WORKSPACE)/env.sh catkin_make $(_FORCE_CMAKE) install --source $(SOURCE_DIR) -DCMAKE_INSTALL_PREFIX=$(prefix) --cmake-args $(CMAKE_EXTRA_ARGS) --make-args $(MAKE_EXTRA_ARGS)

build_catkin_make_isolated: prepare
	$(PARENT_WORKSPACE)/env.sh catkin_make_isolated $(_FORCE_CMAKE) --source $(SOURCE_DIR) --cmake-args $(CMAKE_EXTRA_ARGS) --make-args $(MAKE_EXTRA_ARGS)
	
install_catkin_make_isolated: prepare
	$(PARENT_WORKSPACE)/env.sh catkin_make_isolated $(_FORCE_CMAKE) --source $(SOURCE_DIR) --install --install-space $(prefix) --cmake-args $(CMAKE_EXTRA_ARGS) --make-args $(MAKE_EXTRA_ARGS)

clean:
	rm -rf build devel build_isolated devel_isolated

uninstall_default:
	cd $(prefix) && rm -rf bin/ etc/ include/ lib/ share/ .catkin .rosinstall _setup_util.py env.sh setup.*

uninstall_isolated:
	cd $(prefix) && rm -rf bin/ etc/ include/ lib/ share/ .catkin .rosinstall _setup_util.py env.sh setup.*
	
deb:
	dpkg-buildpackage -b -nc -us -uc
