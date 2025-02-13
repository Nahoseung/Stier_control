import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.patches import Circle

def circle_from_3pts(x1, y1, x2, y2, x3, y3):
    """
    세 점 (x1, y1), (x2, y2), (x3, y3)를 지나는 원의
    중심(cx, cy)과 반경 r을 구하는 함수.
    (3점이 거의 일직선이면 None 반환)
    """
    A = x2 - x1
    B = y2 - y1
    C = x3 - x1
    D = y3 - y1

    E = A*(x1 + x2) + B*(y1 + y2)
    F = C*(x1 + x3) + D*(y1 + y3)
    G = 2.0 * (A*(y3 - y2) - B*(x3 - x2))

    if abs(G) < 1e-14:
        return None, None, None

    cx = (D*E - B*F) / G
    cy = (A*F - C*E) / G
    r = np.sqrt((x1 - cx)**2 + (y1 - cy)**2)
    return cx, cy, r

# 1) 데이터 읽기
file_path = "1_5_Waypoint_UTM (2).txt"
df = pd.read_csv(file_path, sep=r"\s+", header=None, names=["idx","Easting","Northing"])

x_arr = df["Easting"].values
y_arr = df["Northing"].values

# 2) 각 점에서 곡률(=1/반경) 계산
curvatures = []
centers = []
radii = []

for i in range(1, len(x_arr)-1):
    x1, y1 = x_arr[i-1], y_arr[i-1]
    x2, y2 = x_arr[i],   y_arr[i]
    x3, y3 = x_arr[i+1], y_arr[i+1]

    cx, cy, r = circle_from_3pts(x1, y1, x2, y2, x3, y3)
    if r is not None:
        kappa = 1.0 / r  # 곡률
        curvatures.append(kappa)
        centers.append((cx, cy))
        radii.append(r)
    else:
        curvatures.append(0.0)
        centers.append((np.nan, np.nan))
        radii.append(np.nan)

# 3) 곡률이 가장 큰 지점 상위 3개 찾기
top_n = 3
sorted_indices = np.argsort(curvatures)[::-1]  # 곡률 큰 순으로 정렬
top_indices = sorted_indices[:top_n]

# 4) 시각화
plt.figure(figsize=(8, 8))

# RDDF 경로를 검정색으로
plt.plot(x_arr, y_arr, color='black', linewidth=2, label='RDD Path')

# 원 색상 배열 (상위 3개를 각각 빨강, 초록, 파랑)
circle_colors = ['red', 'green', 'blue']

for i, idx in enumerate(top_indices):
    cx, cy = centers[idx]
    r = radii[idx]

    # (a) 곡률 원 추가
    circle = Circle((cx, cy), r, color=circle_colors[i], fill=False, linewidth=2)
    plt.gca().add_patch(circle)

    # (b) 반경 텍스트 표시 (원 오른쪽에 살짝 띄워서)
    offset = 1.0  # 텍스트를 원 밖으로 조금 띄우는 거리
    text_x = cx + r + offset
    text_y = cy
    plt.text(text_x, text_y,
             f"R={r:.2f}m",
             color=circle_colors[i],
             fontsize=10,
             ha='left', va='center')  # 글자 정렬

plt.xlabel("Easting (m)")
plt.ylabel("Northing (m)")
plt.title("RDD Path with 3 Curvature Circles (with radius text)")
plt.grid(True)
plt.legend()
plt.axis('equal')  # x, y 축 비율을 동일하게 설정
plt.show()

