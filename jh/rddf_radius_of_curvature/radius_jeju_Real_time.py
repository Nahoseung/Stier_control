import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.patches import Circle
from matplotlib.animation import FuncAnimation

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

# ---------------------------
# 1) RDDF 경로 (UTM) 불러오기
# ---------------------------
file_path = "1_5_Waypoint_UTM (2).txt"  # 파일 경로
df = pd.read_csv(file_path, sep=r"\s+", header=None, names=["idx","Easting","Northing"])
x_arr = df["Easting"].values
y_arr = df["Northing"].values

# 전체 경로의 min/max 구해서 축 범위 고정
min_x, max_x = x_arr.min(), x_arr.max()
min_y, max_y = y_arr.min(), y_arr.max()
margin = 10  # 조금의 여백

# ---------------------------
# 2) Figure / Axis 설정
# ---------------------------
fig, ax = plt.subplots(figsize=(8,8))
ax.set_xlim(min_x - margin, max_x + margin)
ax.set_ylim(min_y - margin, max_y + margin)
ax.set_aspect('equal', adjustable='box')
ax.set_xlabel("Easting (m)")
ax.set_ylabel("Northing (m)")
ax.set_title("Real-time RDDF Path & Curvature Radius")

# ---------------------------
# 3) '전체 경로'와 '애니메이션 경로'를 구분해서 그림
# ---------------------------
# (a) 전체 경로(배경용) - 연한 회색으로 한 번에 그리기
line_all, = ax.plot(x_arr, y_arr, color='lightgray', linewidth=2, label='Entire RDD Path (background)')

# (b) 실시간으로 업데이트할 '현재까지의 경로' - 검정색
line_path, = ax.plot([], [], color='black', linewidth=2, label='Animated RDD Path')

# (c) 곡률 원 (처음엔 반경=0)
circle_patch = Circle((0,0), 0, color='red', fill=False, linewidth=2, label='Curvature Circle')
ax.add_patch(circle_patch)

# (d) 텍스트 (현재 곡률/반경, 최대 곡률/반경)
text_curvature = ax.text(0.02, 0.95, '', transform=ax.transAxes, fontsize=12, color='red')
text_max_curv = ax.text(0.02, 0.90, '', transform=ax.transAxes, fontsize=12, color='blue')

# 범례
ax.legend(loc='upper right')

# ---------------------------
# 4) 지금까지 최대 곡률(최소 반경) 추적
# ---------------------------
max_curvature_so_far = 0.0
min_radius_so_far = float('inf')

# ---------------------------
# 5) 초기화 함수
# ---------------------------
def init():
    line_path.set_data([], [])
    circle_patch.set_center((0,0))
    circle_patch.set_radius(0)
    text_curvature.set_text('')
    text_max_curv.set_text('')
    return line_path, circle_patch, text_curvature, text_max_curv

# ---------------------------
# 6) 프레임 업데이트 함수
# ---------------------------
def update(i):
    global max_curvature_so_far, min_radius_so_far

    # (a) i번째까지 경로
    line_path.set_data(x_arr[:i+1], y_arr[:i+1])

    # (b) 곡률 원 계산
    if 1 <= i < len(x_arr)-1:
        x1, y1 = x_arr[i-1], y_arr[i-1]
        x2, y2 = x_arr[i],   y_arr[i]
        x3, y3 = x_arr[i+1], y_arr[i+1]

        cx, cy, r = circle_from_3pts(x1, y1, x2, y2, x3, y3)
        if r is not None:
            kappa = 1.0 / r
            circle_patch.set_center((cx, cy))
            circle_patch.set_radius(r)
            text_curvature.set_text(f"Curvature={kappa:.4f} (Radius={r:.2f} m)")

            # 최대 곡률 갱신
            if kappa > max_curvature_so_far:
                max_curvature_so_far = kappa
                min_radius_so_far = r
        else:
            circle_patch.set_center((x2, y2))
            circle_patch.set_radius(0)
            text_curvature.set_text("Curvature=0 (Straight)")
    else:
        circle_patch.set_center((x_arr[i], y_arr[i]))
        circle_patch.set_radius(0)
        text_curvature.set_text("")

    # (c) 지금까지의 최대 곡률 / 최소 반경
    if max_curvature_so_far > 0:
        text_max_curv.set_text(
            f"Max Curv so far={max_curvature_so_far:.4f} (Radius={min_radius_so_far:.2f} m)"
        )
    else:
        text_max_curv.set_text("Max Curv so far=0 (Radius=∞)")

    return line_path, circle_patch, text_curvature, text_max_curv

# ---------------------------
# 7) 애니메이션 실행
# ---------------------------
frames_count = len(x_arr)
from matplotlib.animation import FuncAnimation
ani = FuncAnimation(fig, update, frames=range(frames_count),
                    init_func=init, blit=False, interval=100, repeat=False)

plt.show()

