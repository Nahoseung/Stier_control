# route.py
import numpy as np

def generate_route():
    # 간단한 원형 경로 생성
    t = np.linspace(0, 2 * np.pi, 100)
    x = 10 * np.cos(t)
    y = 10 * np.sin(t)

    # 경로를 파일에 저장
    with open("path.txt", "w") as f:
        for xi, yi in zip(x, y):
            f.write(f"{xi},{yi}\n")

if __name__ == "__main__":
    generate_route()
    print("Route has been generated and saved to path.txt.")
