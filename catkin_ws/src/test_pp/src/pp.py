import rospy
import math
import numpy as np
from geometry_msgs.msg import PoseStamped
from std_msgs.msg import Int32, Float32, Bool
from erp42_msgs.msg import DriveCmd
from ublox_msgs.msg import NavPVT
from datetime import datetime
import time
import pyproj

############################
# UTIL
############################
def rotate_2d(vector, theta):
    rotation_matrix = np.array([
        [np.cos(theta), -np.sin(theta)],
        [np.sin(theta), np.cos(theta)]
    ])
    return rotation_matrix @ vector

def closest_point_to_segment(px, py, x1, y1, x2, y2):
    """
    점 (px, py)와 선분 (x1, y1) -> (x2, y2) 사이의 최소 거리를 계산.
    
    px, py: 점의 좌표
    x1, y1: 선분의 시작점 좌표
    x2, y2: 선분의 끝점 좌표
    
    return: 최소 거리
    """
    # 선분의 길이를 제곱으로 계산
    segment_length_squared = (x2 - x1)**2 + (y2 - y1)**2

    if segment_length_squared == 0:
        # 선분의 길이가 0인 경우 (점)
        return math.hypot(px - x1, py - y1)

    # 선분 상의 점과 가장 가까운 점을 찾기 위한 t 값 계산
    t = ((px - x1) * (x2 - x1) + (py - y1) * (y2 - y1)) / segment_length_squared
    t = max(0, min(1, t))  # t는 [0, 1] 범위로 제한 (선분 내부의 점)

    # 선분 상의 가장 가까운 점의 좌표 계산
    closest_x = x1 + t * (x2 - x1)
    closest_y = y1 + t * (y2 - y1)
    
    return closest_x, closest_y

def find_circle_line_intersections(circle_center, radius, point1, point2):
    """
    원과 선분의 교점을 계산합니다.

    Parameters:
    - circle_center: 원의 중심 좌표 (x, y) 형태의 튜플
    - radius: 원의 반지름 (float)
    - point1: 선분의 한 끝점 좌표 (x, y) 형태의 튜플
    - point2: 선분의 다른 끝점 좌표 (x, y) 형태의 튜플

    Returns:
    - 교점 좌표 리스트 [(x1, y1), (x2, y2)], 없으면 빈 리스트
    """
    cx, cy = circle_center
    x1, y1 = point1
    x2, y2 = point2

    # 선분의 방정식: (x, y) = (x1, y1) + t * ((x2 - x1), (y2 - y1))
    dx, dy = x2 - x1, y2 - y1

    # 이차 방정식의 계수 계산
    a = dx**2 + dy**2
    b = 2 * (dx * (x1 - cx) + dy * (y1 - cy))
    c = (x1 - cx)**2 + (y1 - cy)**2 - radius**2

    # 판별식 계산
    discriminant = b**2 - 4 * a * c

    if discriminant < 0:
        # 교점이 없음
        return []
    elif discriminant == 0:
        # 교점이 하나 (접점)
        t = -b / (2 * a)
        if 0 <= t <= 1:
            # t가 [0, 1] 범위에 있어야 선분 위의 점
            ix = x1 + t * dx
            iy = y1 + t * dy
            return [(ix, iy)]
        else:
            return []
    else:
        # 교점이 두 개
        sqrt_discriminant = math.sqrt(discriminant)
        t1 = (-b + sqrt_discriminant) / (2 * a)
        t2 = (-b - sqrt_discriminant) / (2 * a)

        intersections = []
        for t in [t1, t2]:
            if 0 <= t <= 1:
                ix = x1 + t * dx
                iy = y1 + t * dy
                intersections.append((ix, iy))

        return intersections
    
def find_nearest_point(reference_point, points):
    """
    기준 점에서 가장 가까운 점을 찾습니다.

    Parameters:
    - reference_point: 기준 점 좌표 (x, y) 형태의 튜플
    - points: 점들의 리스트 [(x1, y1), (x2, y2), ...] 형태

    Returns:
    - 가장 가까운 점의 좌표 (x, y) 형태의 튜플
    """
    if not points:
        return None  # 점 리스트가 비어 있는 경우 처리
    
    # 유클리드 거리 계산 함수
    def euclidean_distance(p1, p2):
        return math.sqrt((p1[0] - p2[0])**2 + (p1[1] - p2[1])**2)
    
    # 거리 계산 후 가장 짧은 거리의 점 반환
    nearest_point = min(points, key=lambda point: euclidean_distance(reference_point, point))
    return nearest_point

# 반원형 경로 추가 함수
def add_semi_circular_path(path, center, radius, start_angle, end_angle, step):
    """
    반원형 경로를 생성하여 기존 경로에 추가합니다.

    Parameters:
    - path: 기존 경로 리스트 [(x, y), ...]
    - center: 반원의 중심 좌표 (cx, cy)
    - radius: 반원의 반지름
    - start_angle: 시작 각도 (라디안)
    - end_angle: 끝 각도 (라디안)
    - step: 각도 간격 (라디안)
    
    Returns:
    - 업데이트된 경로 리스트 [(x, y), ...]
    """
    cx, cy = center
    angles = np.arange(start_angle, end_angle, step)
    new_points = [(cx + radius * np.cos(angle), cy + radius * np.sin(angle)) for angle in angles]
    path.extend(new_points)
    return path



############################
# DYNAMIC MODEL
############################
class BicycleModel:
    """
    자전거 모델을 이용하여 차량의 다음 상태를 예측하는 클래스.
    - wheelbase: 차량의 축간거리
    - max_steer: 최대 조향각(라디안)
    """
    def __init__(self, wheelbase=1.5, max_steer=math.radians(30)):
        self.wheelbase = wheelbase
        self.max_steer = max_steer

    def update(self, x, y, heading, velocity, speed_cmd, curvature_cmd, dt):
        """
        자전거 모델 공식에 따라 차량 상태를 갱신한다.
        :param x, y: 현재 위치
        :param heading: 현재 차량의 각도(라디안)
        :param velocity: 현재 속도
        :param speed_cmd: 제어기로부터의 목표 속도
        :param curvature_cmd: 제어기로부터의 목표 곡률(= 1/회전반경)
        :param dt: 시간 간격
        :return: (new_x, new_y, new_heading, new_velocity)
        """

        # 속도는 제어 명령을 그대로 따른다고 가정(단순 모델)
        new_velocity = speed_cmd

        # 곡률(curvature) → 실제 조향각(steering angle) 변환
        steer = math.atan(curvature_cmd * self.wheelbase)

        """
        # 조향각 saturate (최대 조향각 제한)
        desired_steer = max(-self.max_steer, min(self.max_steer, desired_steer))
        """

        # 자전거 모델에 따른 각속도, 위치 변화 적용
        heading_rate = new_velocity * curvature_cmd
        new_x = x + new_velocity * math.cos(heading) * dt
        new_y = y + new_velocity * math.sin(heading) * dt
        new_heading = heading + heading_rate * dt

        return new_x, new_y, new_heading, new_velocity
    
    def get_control(self, speed_cmd, curvature_cmd):
        steer_cmd = math.atan(curvature_cmd * self.wheelbase)
        return speed_cmd, steer_cmd


############################
# CONTROLLER
############################

class PurePursuit:

    def __init__(self, path, lookahead_distance=30.0, constant_speed=10.0,
                 alpha_filter_gain=0.5, reach_threshold=25.0):
        self.path = path
        self.max_idx = len(path)-1
        self.lookahead_distance = lookahead_distance
        self.constant_speed = constant_speed

        self.last_closest_index = 0  # 뒤로 가지 않는 히스테리시스 인덱스
        self.last_alpha = None       # 조향각(heading 차이) 필터링용
        self.alpha_filter_gain = alpha_filter_gain
        self.reach_threshold = lookahead_distance


        self.reached_idx = -1
        self.next_idx = 0
        self.lx, self.ly = 0,0

    def has_reached_waypoint(self, x, y, waypoint):
        """
        (x, y)가 주어진 waypoint에 reach_threshold 이하로 가까워지면 True
        """
        px, py = waypoint
        dist = math.hypot(px - x, py - y)
        return dist < self.reach_threshold

    def get_closest_next_path_idx(self, x, y):
        if not self.path:
            return 0
        for idx in range(self.next_idx, self.max_idx+1):
            px, py = self.path[idx]
            dist = math.hypot(px - x, py - y)
            if dist >= self.lookahead_distance:
                self.next_idx = idx
                return idx
        return self.max_idx

    def get_lookahead_point(self, x, y):
        """
        멀리 떨어진 경로 지점 사이를 보간하는 기능을 구현
        실제 차량엔 이렇게 안해도 될 것 같음음
        """
        lookahead_dist = self.lookahead_distance
        closest_next_path_idx = self.get_closest_next_path_idx(x, y)
        px, py = self.path[closest_next_path_idx]
        dist = math.hypot(px - x, py - y)
        cur_x, cur_y = x, y
        max_idx = len(self.path)-1

        idx = closest_next_path_idx
        while(dist < lookahead_dist):
            cur_x, cur_y = px, py
            idx +=1
            if idx > max_idx:
                return px, py
            px, py = self.path[idx]
            dist = math.hypot(px - cur_x, py - cur_y)

        if idx > 0:
            cur_x, cur_y = self.path[idx-1]

        print(f"idx : {idx}")
        intersections = find_circle_line_intersections((x,y), lookahead_dist, (cur_x, cur_y), (px, py))
        intersection = find_nearest_point((px, py), intersections)
        return intersection

    def control(self, x, y, heading, velocity):
        """
        퓨어 퍼슈잇 제어 알고리즘
        차량의 위치와 각도를 기반으로 차량이 이동해야할 경로의 곡률을 계산
        """

        # 지나간 경로 포인트 인덱스값 저장
        print(f"self.reached_idx : {self.reached_idx}, self.max_idx : {self.max_idx}")
        if self.reached_idx == self.max_idx:
            if math.hypot(self.lx-x, self.ly-y) < 1.0:
                return 0, 0
        elif self.has_reached_waypoint(x, y, self.path[self.reached_idx+1]):
            self.reached_idx = self.reached_idx +1

        # curvature 계산
        lx, ly = self.get_lookahead_point(x, y)
        rx, ry= self.relative_position((x,y), heading, (lx,ly))
        dist = math.hypot(lx - x, ly - y)
        curvature = 2 * ry / math.pow(dist, 2)
        self.lx, self.ly = lx, ly

        # speed 계산
        speed = self.constant_speed

        return speed, curvature
    
    def relative_position(self, car_position, heading, absolute_position):
        """
        절대 좌표를 차량 기준의 상대 좌표로 변환.

        absolute_position: 절대 좌표 (x, y)
        return: 상대 좌표 (x', y')
        """
        car_x, car_y = car_position
        car_heading_rad = heading
        target_x, target_y = absolute_position

        # 차량 기준으로 변환 (상대 위치)
        dx = target_x - car_x
        dy = target_y - car_y

        # 회전 변환 (global -> local)
        relative_x = math.cos(-car_heading_rad) * dx - math.sin(-car_heading_rad) * dy
        relative_y = math.sin(-car_heading_rad) * dx + math.cos(-car_heading_rad) * dy

        return relative_x, relative_y
    
    
############################
# CAR CLASS
############################
class Car:
    """
    차량 전체를 나타내는 클래스.
    - position(x, y), heading, velocity 상태를 가지고 있음
    - dynamic_model(예: BicycleModel)과 controller(예: PurePursuit)를 포함
    """
    def __init__(self, dynamic_model, controller,
                 x=None, y=None, heading=None, velocity=None):
        self.x = x
        self.y = y
        self.heading = heading
        self.velocity = velocity
        self.dynamic_model = dynamic_model
        self.controller = controller

    def update_position(self, dt):
        """
        1) (x, y, heading, velocity)를 컨트롤러에 전달해
           속도, 곡률 명령을 구한다.
        2) 동역학 모델로부터 새로운 상태를 업데이트한다.
        3) (x, y)를 리턴한다.
        """

        speed_cmd, curvature_cmd = self.controller.control(
            self.x, self.y, self.heading, self.velocity
        )

        self.x, self.y, self.heading, self.velocity = \
            self.dynamic_model.update(
                self.x, self.y, self.heading, self.velocity,
                speed_cmd, curvature_cmd, dt
            )

        return (self.x, self.y)
    
    def get_control(self):
        if self.x == None or self.y == None or self.heading == None:
            print("waiting...")
            return 0, 0
        return self.dynamic_model.get_control()

############################
# MAIN LOGIC
############################

def read_rddf_to_array(file_path):
    coordinates = []
    
    with open(file_path, 'r') as file:
        for line in file:
            parts = line.strip().split()
            if len(parts) == 2:
                try:
                    x, y = float(parts[0]), float(parts[1])
                    coordinates.append((x, y))
                except ValueError:
                    continue
    
    return np.array(coordinates)

drive_msg = DriveCmd()
CONTROL_FREQUENCY = 10

file_path = "2025-2-1_18-39_test-walk.txt"
rddf = read_rddf_to_array(file_path)
car = Car(
        dynamic_model=BicycleModel(),
        controller=PurePursuit(path=rddf, lookahead_distance=2.5, constant_speed=20.0),
        x=None, y=None, heading=None
    )


def callback(coordinate: PoseStamped):
    global car
    car.x = coordinate.pose.position.x
    car.y = coordinate.pose.position.y

def gps_callback(msg: NavPVT):
    true_heading = msg.heading * 1e-5
    """
    # WGS84 타원체 기준 지구 좌표계 설정
    geod = pyproj.Geod(ellps="WGS84")
    # UTM 중앙 자오선 계산
    utm_central_meridian = (52 - 1) * 6 - 180 + 3  # 예: UTM Zone 52 → 129°E
    # Grid Convergence (γ) 계산
    _, _, grid_convergence = geod.fwd(utm_central_meridian, lat, 90, 1)
    # Grid North 기준 헤딩 변환
    grid_heading = true_heading - grid_convergence
    # 0~360 범위로 보정
    grid_heading = (grid_heading + 360) % 360
    """
    global car
    car.heading = true_heading-90

def main_ros():
    rospy.init_node("pp")  # 노드 초기화
    nh = rospy.Rate(10)  # 루프 속도 설정 (예제: 10Hz)

    rospy.Subscriber("utm", PoseStamped, callback)
    rospy.Subscriber("/ublox_position_receiver/navpvt", NavPVT, gps_callback)

    drive_pub = rospy.Publisher("/erp42_serial/drive", DriveCmd, queue_size=1)
    
    rate = rospy.Rate(CONTROL_FREQUENCY)
    while not rospy.is_shutdown():
        rospy.spinOnce()
        speed, steer = car.get_control()
        drive_msg.KPH = speed
        drive_msg.Deg = steer
        drive_pub.publish(drive_msg)
        rate.sleep()

if __name__ == "__main__":
    main_ros()

    
