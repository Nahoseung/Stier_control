#include <ros/ros.h>
#include <visualization_msgs/Marker.h>
#include <geometry_msgs/Point.h>
#include <fstream>
#include <string>
#include <sstream>
#include <ros/package.h>

using namespace std;

string ROS_HOME;
ros::Publisher marker_pub;

void loadAndPublishPath(const string& file_path)
{
    ifstream file(file_path);
    if (!file.is_open()) {
        ROS_ERROR("파일을 열 수 없습니다: %s", file_path.c_str());
        return;
    }

    visualization_msgs::Marker line_strip;
    line_strip.header.frame_id = "map";  // RViz에서 사용할 좌표계 설정
    line_strip.header.stamp = ros::Time::now();
    line_strip.ns = "rddf_path";
    line_strip.id = 0;
    line_strip.type = visualization_msgs::Marker::LINE_STRIP;
    line_strip.action = visualization_msgs::Marker::ADD;
    
    // 선의 속성 설정
    line_strip.scale.x = 0.1;  // 선의 두께
    line_strip.color.r = 1.0;   // 빨간색
    line_strip.color.g = 0.0;
    line_strip.color.b = 0.0;
    line_strip.color.a = 1.0;   // 불투명도

    // 좌표 읽기
    string line;
    while (getline(file, line)) {
        stringstream ss(line);
        double x, y;
        if (!(ss >> x >> y)) {
            continue;  // 유효한 데이터가 아니면 건너뜀
        }

        geometry_msgs::Point p;
        p.x = x;
        p.y = y;
        p.z = 0.0;
        line_strip.points.push_back(p);
    }
    file.close();

    // 경로를 RViz에 퍼블리시
    marker_pub.publish(line_strip);
    ROS_INFO("RDDF 경로가 RViz에 표시되었습니다.");
}

int main(int argc, char** argv)
{
    ros::init(argc, argv, "rddf_visualizer");
    ros::NodeHandle nh;
    marker_pub = nh.advertise<visualization_msgs::Marker>("rddf_path_marker", 1);

    ROS_HOME = ros::package::getPath("rddf");
    
    if (argc < 2) {
        ROS_ERROR("경로 파일명을 인자로 입력하세요.");
        return -1;
    }

    string file_name = argv[1];  // 인자로 받은 RDDF 경로 파일명
    string file_path = ROS_HOME + "/paths/" + file_name;

    ros::Rate rate(1);  // 1Hz로 주기적으로 퍼블리시
    while (ros::ok()) {
        loadAndPublishPath(file_path);
        ros::spinOnce();
        rate.sleep();
    }

    return 0;
}

