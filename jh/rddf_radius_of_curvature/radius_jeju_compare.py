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

def read_rddf_file(file_path):
    # 파일의 첫 줄을 읽어 열 개수를 확인
    with open(file_path, 'r') as f:
        first_line = f.readline().strip()
    tokens = first_line.split()
    n_cols = len(tokens)
    if n_cols == 3:
        df = pd.read_csv(file_path, sep=r"\s+", header=None, names=["idx", "Easting", "Northing"])
    elif n_cols == 2:
        df = pd.read_csv(file_path, sep=r"\s+", header=None, names=["Easting", "Northing"])
    else:
        raise ValueError("파일 형식이 예상과 다릅니다. 2개 또는 3개의 열이 있어야 합니다.")
    return df

# 사용할 RDDF 경로 파일 (예시 4개)
file_paths = [
    "2025-2-11_17-24_rddf-01.txt",
    "pp-old_speed-10.0_ld-3.0.txt",
    "pp-old_speed-10.0_ld-2.0.txt",
    "pp-old_speed-10.0_ld-1.0.txt"
]

# 각 경로에 원하는 이름을 직접 지정
path_labels = [
    "2025-2-11_17-24_rddf-01.txt",
    "pp-old_speed-10.0_ld-3.0",
    "pp-old_speed-10.0_ld-2.0",
    "pp-old_speed-10.0_ld-1.0"
]

# 최소 반경 원의 이름도 따로 지정
circle_labels = [
    "Min Radius",
    "ld-3.0 Min Radius",
    "ld-2.0 Min Radius",
    "ld-1.0 Min Radius"
]

# 경로 색상 (검정, 빨강, 초록, 파랑)
path_colors = ['black', 'red', 'green', 'blue']

all_x, all_y = [], []

plt.figure(figsize=(10, 10))
ax = plt.gca()

for i, file_path in enumerate(file_paths):
    try:
        df = read_rddf_file(file_path)
    except Exception as e:
        print(f"파일 {file_path} 읽기 실패: {e}")
        continue

    x_arr = df["Easting"].values
    y_arr = df["Northing"].values
    all_x.extend(x_arr)
    all_y.extend(y_arr)

    # 곡률(=1/반경) 계산
    curvatures = []
    centers = []
    radii = []
    for j in range(1, len(x_arr)-1):
        x1, y1 = x_arr[j-1], y_arr[j-1]
        x2, y2 = x_arr[j],   y_arr[j]
        x3, y3 = x_arr[j+1], y_arr[j+1]
        cx, cy, r = circle_from_3pts(x1, y1, x2, y2, x3, y3)
        if r is not None:
            kappa = 1.0 / r
            curvatures.append(kappa)
            centers.append((cx, cy))
            radii.append(r)
        else:
            curvatures.append(0.0)
            centers.append((np.nan, np.nan))
            radii.append(np.nan)

    if len(curvatures) == 0:
        continue
    # 최대 곡률(=최소 반경) 인덱스
    max_index = np.argmax(curvatures)
    min_radius = radii[max_index]
    circle_center = centers[max_index]

    # (1) 경로를 지정된 색상과 라벨로 그림
    ax.plot(x_arr, y_arr, color=path_colors[i], linewidth=2,
            label=path_labels[i])

    # (2) 최소 반경 원(점선) 추가
    if not np.isnan(circle_center[0]):
        circ = Circle(circle_center, min_radius,
                      edgecolor=path_colors[i],
                      facecolor='none',
                      linestyle='dashed',
                      linewidth=2,
                      label=circle_labels[i])
        ax.add_patch(circ)

        # 원에 반경 텍스트 표시
        offset = 1.0
        text_x = circle_center[0] + min_radius + offset
        text_y = circle_center[1]
        ax.text(text_x, text_y,
                f"R={min_radius:.2f}m",
                color=path_colors[i],
                fontsize=10,
                ha='left', va='center')

# 전체 범위를 고려해 축 고정
if all_x and all_y:
    margin = 10
    ax.set_xlim(min(all_x) - margin, max(all_x) + margin)
    ax.set_ylim(min(all_y) - margin, max(all_y) + margin)

ax.set_xlabel("Easting (m)")
ax.set_ylabel("Northing (m)")
ax.set_title("Multiple RDD Paths with Custom Names & Min Curvature Circles")
ax.grid(True)
ax.set_aspect('equal', adjustable='box')
ax.legend()
plt.show()

