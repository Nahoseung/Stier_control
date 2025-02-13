import matplotlib.pyplot as plt
import pandas as pd
import numpy as np

# 파일 경로 설정
file_path = "1_5_Waypoint_UTM (2).txt"  # 파일 경로를 적절히 변경하세요.

# 파일을 판다스로 읽기 (공백 기준 자동 분리)
try:
    df = pd.read_csv(file_path, sep="\s+", header=None, names=["Index", "Easting", "Northing"])
except Exception as e:
    print("파일을 읽는 중 오류 발생:", e)
    exit()

# 데이터 변환 및 검증
if df.isnull().values.any():
    print("데이터에 결측값(NaN)이 포함되어 있습니다. 데이터 파일을 확인하세요.")
    exit()

# 경로 시각화
plt.figure(figsize=(10, 10))
plt.plot(df["Easting"].to_numpy(), df["Northing"].to_numpy(), marker="o", linestyle="-", markersize=2, label="RDDP Path")
plt.xlabel("Easting (m)")
plt.ylabel("Northing (m)")
plt.title("RDDP Path in Jeju, South Korea")
plt.legend()
plt.grid()

# 그래프 출력
plt.show()

