# 운영체제에 설치된 cmake의 최소 요구 버전
cmake_minimum_required(VERSION 3.0.2)

# 패키지의 이름으로, package.xml에서 입력한 패키지 이름을 그대로 사용
project(test_pp)

find_package(catkin REQUIRED COMPONENTS
  rospy
  std_msgs
  erp42_msgs
  geometry_msgs
  ublox_msgs
  erp42_msgs
)

catkin_package(
  CATKIN_DEPENDS rospy std_msgs geometry_msgs ublox_msgs erp42_msgs
)

include_directories(
  ${catkin_INCLUDE_DIRS}
)

add_executable(pp src/pp.py)
target_link_libraries(pp
  ${catkin_LIBRARIES}
)

add_dependencies(pp ${${PROJECT_NAME}_EXPORTED_TARGETS} ${catkin_EXPORTED_TARGETS})
