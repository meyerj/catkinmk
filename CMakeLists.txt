cmake_minimum_required(VERSION 2.8.3)
project(catkinmk)
find_package(catkin REQUIRED)
catkin_package()

#############
## Install ##
#############

## Mark other files for installation (e.g. launch and bag files, etc.)
install(FILES
  catkin.mk
  DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}
)

