import numpy as np
import matplotlib.pyplot as plt

# 데이터 로드 (x, y 좌표 배열)
data = np.loadtxt('2025-2-14_17-36_25-02-11_test-009_pp-simple_add-stop.txt')
x_data, y_data = data[:, 0], data[:, 1]

# 선택한 점 저장 리스트
selected_points = []

# 그래프 설정
fig, ax = plt.subplots()
ax.scatter(x_data, y_data, s=10, c='blue', label='Data Points')
selected_plot, = ax.plot([], [], 'ro', markersize=8, label='Selected Points')
circle_plot, = ax.plot([], [], 'g-', label='Fitted Circle')
ax.legend()

# 원 계산 함수
def calculate_circle(p1, p2, p3):
    x1, y1 = p1
    x2, y2 = p2
    x3, y3 = p3
    
    A = np.array([
        [x1, y1, 1],
        [x2, y2, 1],
        [x3, y3, 1]
    ])
    
    B = np.array([
        [x1**2 + y1**2, y1, 1],
        [x2**2 + y2**2, y2, 1],
        [x3**2 + y3**2, y3, 1]
    ])
    
    C = np.array([
        [x1**2 + y1**2, x1, 1],
        [x2**2 + y2**2, x2, 1],
        [x3**2 + y3**2, x3, 1]
    ])
    
    D = np.array([
        [x1**2 + y1**2, x1, y1],
        [x2**2 + y2**2, x2, y2],
        [x3**2 + y3**2, x3, y3]
    ])
    
    detA = np.linalg.det(A)
    if abs(detA) < 1e-10:
        return None, None, None, None  # 세 점이 일직선인 경우
    
    x0 = 0.5 * np.linalg.det(B) / detA
    y0 = -0.5 * np.linalg.det(C) / detA
    r = np.sqrt((x0 - x1)**2 + (y0 - y1)**2)
    curvature = 1 / r  # 곡률 계산
    
    return x0, y0, r, curvature

# 마우스 클릭 이벤트 핸들러
def on_click(event):
    global selected_points
    if event.xdata is None or event.ydata is None:
        return  # 그래프 범위 밖 클릭 방지
    
    if len(selected_points) >= 3:
        selected_points.pop(0)  # 가장 오래된 점 제거
    
    selected_points.append((event.xdata, event.ydata))
    selected_plot.set_data(*zip(*selected_points))
    
    if len(selected_points) == 3:
        draw_circle()
    
    fig.canvas.draw()

# 원 그리기 함수
def draw_circle():
    if len(selected_points) == 3:
        x0, y0, r, curvature = calculate_circle(*selected_points)
        if x0 is None:
            print("올바른 세 점을 선택하세요!")
            return
        
        theta = np.linspace(0, 2*np.pi, 100)
        x_circle = x0 + r * np.cos(theta)
        y_circle = y0 + r * np.sin(theta)
        circle_plot.set_data(x_circle, y_circle)
        
        print(f"반지름: {r:.3f}, 곡률: {curvature:.3f}")
        fig.canvas.draw()

# 마우스 이벤트 연결
fig.canvas.mpl_connect('button_press_event', on_click)

plt.show()
