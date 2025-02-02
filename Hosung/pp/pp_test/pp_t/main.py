import subprocess
import os

def clean_files():
    """path.txt와 result.txt 파일을 초기화합니다."""
    print("Cleaning path.txt and result.txt...")
    # path.txt 초기화
    with open("path.txt", "w") as path_file:
        pass  # 파일을 비우기 위해 pass 사용

    # result.txt 초기화
    with open("result.txt", "w") as result_file:
        pass

def run_script():
    try:
        # Step 1: path.txt와 result.txt 초기화
        clean_files()

        # Step 2: route.py 실행 (경로 생성)
        print("Running route.py to generate path...")
        subprocess.run(["python", "route.py"], check=True)

        # Step 3: pp.cpp 컴파일 및 실행 (Pure Pursuit 알고리즘 수행)
        print("Compiling and running pp.cpp...")
        subprocess.run(["g++", "pp.cpp", "-o", "pp"], check=True)
        subprocess.run(["./pp"], check=True)

        # Step 4: result.py 실행 (결과 시뮬레이션 및 시각화)
        print("Running result.py to simulate vehicle motion...")
        subprocess.run(["python", "result.py"], check=True)

    except subprocess.CalledProcessError as e:
        print(f"Error occurred: {e}")
        exit(1)

if __name__ == "__main__":
    run_script()
