# result.py
import matplotlib.pyplot as plt
import numpy as np

class Vehicle:
    def __init__(self, x, y, theta):
        self.x = x
        self.y = y
        self.theta = theta  # 방향(라디안)

    def move(self, steering_angle, speed, dt=0.1):
        # 이동 로직
        self.theta += steering_angle * dt  # 조향각 반영
        self.x += speed * np.cos(self.theta) * dt
        self.y += speed * np.sin(self.theta) * dt

def plot_vehicle(vehicle, path):
    plt.plot([p[0] for p in path], [p[1] for p in path], 'r--', label="Path")
    plt.plot(vehicle.x, vehicle.y, 'bo', label="Vehicle")
    plt.legend()
    plt.axis("equal")
    plt.xlabel("X")
    plt.ylabel("Y")
    plt.title("Vehicle Simulation")
    plt.grid()

if __name__ == "__main__":
    # 경로 읽기
    path = []
    with open("path.txt", "r") as f:
        for line in f:
            x, y = map(float, line.strip().split(","))
            path.append((x, y))

    # 차량 초기화
    vehicle = Vehicle(0.0, -10.0, 0.0)

    # 결과 읽기
    with open("result.txt", "r") as f:
        steering_angle, speed = map(float, f.readline().strip().split(","))

    # 차량 이동
    vehicle.move(steering_angle, speed)

    # 시각화
    plt.figure()
    plot_vehicle(vehicle, path)
    plt.show()
