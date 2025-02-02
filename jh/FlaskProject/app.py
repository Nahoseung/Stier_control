import os
import signal
import atexit
import webbrowser
from threading import Timer
from flask import Flask, request, jsonify, render_template
import pandas as pd
import utm

app = Flask(__name__)

# 창 닫을 때 자동 종료하는 함수
def cleanup():
    print("Flask 서버 종료 중...")
    os.kill(os.getpid(), signal.SIGTERM)  # 현재 프로세스를 종료

# 프로그램 종료 시 cleanup 함수 실행
atexit.register(cleanup)

# ✅ 올바른 파일 경로 설정 (사용할 RDDF 파일)
FILE_PATH = '1_5_Waypoint_UTM.txt'

# ✅ UTM -> 위도/경도 변환 함수 (파일 형식 자동 감지)
def load_rddf():
    df = pd.read_csv(FILE_PATH, delim_whitespace=True, header=None)  # ✅ 모든 파일을 동일하게 읽음

    # ✅ 파일이 "ID X Y" 형식인지 확인 (컬럼이 3개라면 ID 포함)
    if df.shape[1] == 3:
        df.columns = ['ID', 'X', 'Y']
    elif df.shape[1] == 2:
        df.columns = ['X', 'Y']  # ID가 없으면 XY 값만 처리
        df.insert(0, 'ID', range(len(df)))  # ID 자동 생성

    # ✅ UTM -> 위도/경도 변환 (Zone 52N을 가정, 필요하면 조정)
    lat_lon = df.apply(lambda row: utm.to_latlon(row['X'], row['Y'], 52, 'N'), axis=1)
    df[['Latitude', 'Longitude']] = pd.DataFrame(lat_lon.tolist(), index=df.index)
    
    return df[['ID', 'Latitude', 'Longitude']].to_dict(orient='records')

# ✅ HTML 지도 페이지 렌더링
@app.route('/')
def map_page():
    return render_template('map.html')

# ✅ 항상 최신 데이터를 반환하도록 수정
@app.route('/get_waypoints', methods=['GET'])
def get_waypoints():
    return jsonify(load_rddf())  # ✅ 항상 최신 데이터 불러오기

# ✅ 마커 이동 시 업데이트되는 데이터도 변경된 파일에서 불러오도록 수정
@app.route('/update_rddf', methods=['POST'])
def update_rddf():
    df = pd.read_csv(FILE_PATH, delim_whitespace=True, header=None)  # ✅ 변경된 파일 로드

    # ✅ 파일이 "ID X Y" 형식인지 확인
    if df.shape[1] == 3:
        df.columns = ['ID', 'X', 'Y']
    elif df.shape[1] == 2:
        df.columns = ['X', 'Y']  # ID가 없으면 자동 생성
        df.insert(0, 'ID', range(len(df)))

    # 요청으로부터 데이터 가져오기
    point_id = int(request.form['id'])
    new_lat = float(request.form['lat'])
    new_lng = float(request.form['lng'])

    # ✅ 위도/경도를 UTM 좌표로 변환
    new_x, new_y, _, _ = utm.from_latlon(new_lat, new_lng)

    # ✅ 데이터 업데이트
    df.loc[df['ID'] == point_id, ['X', 'Y']] = new_x, new_y
    df.to_csv(FILE_PATH, sep=' ', index=False, header=False)  # ✅ 변경된 데이터 저장

    return jsonify({'status': 'success', 'message': f'Point {point_id} updated'})

# ✅ Flask 실행 후 자동으로 웹 브라우저 열기
def open_browser():
    webbrowser.open("http://127.0.0.1:5000")

if __name__ == '__main__':
    Timer(1, open_browser).start()  # ✅ 1초 후 브라우저 열기
    app.run(debug=True)

