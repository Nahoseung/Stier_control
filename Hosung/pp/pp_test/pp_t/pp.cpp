// pp.cpp
#include <iostream>
#include <fstream>
#include <vector>
#include <cmath>
#include <tuple>

struct Point {
    double x;
    double y;
};

// 경로를 파일에서 읽어오는 함수
std::vector<Point> loadPath(const std::string& filename) {
    std::vector<Point> path;
    std::ifstream file(filename);
    std::string line;

    while (std::getline(file, line)) {
        double x, y;
        sscanf(line.c_str(), "%lf,%lf", &x, &y);
        path.push_back({x, y});
    }

    return path;
}
/*
1.path를 읽어와 while문에서 path 경로를 추종 pp()
2. 추종 경로를 route list에 저장
3. route list를 result.txt에 저장
*/


// 목표점을 찾는 함수
Point findGoalPoint(const std::vector<Point>& path, const Point& current_position, double lookahead_distance) {
    for (const auto& point : path) {
        double distance = std::sqrt(std::pow(point.x - current_position.x, 2) +
                                    std::pow(point.y - current_position.y, 2));
        if (distance >= lookahead_distance) {
            return point;
        }
    }
    return path.back(); // 마지막 점 반환 (경로 끝)
}

// 조향각 계산 함수
double calculateSteeringAngle(const Point& current_position, const Point& goal_point) {
    double angle = std::atan2(goal_point.y - current_position.y, goal_point.x - current_position.x);
    return angle;
}

int main() {
    // 경로 읽기
    auto path = loadPath("path.txt");

    // 차량 초기 상태
    Point current_position = {0.0, -10.0};
    double lookahead_distance = 2.0;
    double speed = 5.0;

    // 목표점 찾기
    Point goal_point = findGoalPoint(path, current_position, lookahead_distance);

    // 조향각 계산
    double steering_angle = calculateSteeringAngle(current_position, goal_point);

    // 결과 저장
    std::ofstream result_file("result.txt");
    result_file << steering_angle << "," << speed << "\n";
    result_file.close();

    std::cout << "Steering angle and speed have been saved to result.txt." << std::endl;
    return 0;
}
