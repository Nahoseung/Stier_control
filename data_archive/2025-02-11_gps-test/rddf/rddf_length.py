import numpy as np

def calculate_total_distance(file_path):
    # 파일에서 좌표 데이터 읽기
    coordinates = np.loadtxt(file_path)
    
    # 각 점 사이의 거리 계산
    distances = np.sqrt(np.sum(np.diff(coordinates, axis=0) ** 2, axis=1))
    
    # 총 거리 계산
    total_distance = np.sum(distances)
    return total_distance

if __name__ == "__main__":
    file_path = "filtered_waypoints_jeju.txt"  # 사용자가 업로드한 파일명
    total_distance = calculate_total_distance(file_path)
    print(f"총 경로 길이: {total_distance:.2f} m")