from flask import Flask, request, jsonify, render_template
import pandas as pd
import utm

app = Flask(__name__)

# 파일 경로
FILE_PATH = '1_5_Waypoint_UTM.txt'

# UTM -> 위도/경도 변환 함수
def load_rddf():
    df = pd.read_csv(FILE_PATH, delim_whitespace=True, header=None, names=['ID', 'X', 'Y'])

    # UTM -> 위도/경도 변환 (Zone 52N을 가정, 필요하면 조정)
    lat_lon = df.apply(lambda row: utm.to_latlon(row['X'], row['Y'], 52, 'N'), axis=1)
    df[['Latitude', 'Longitude']] = pd.DataFrame(lat_lon.tolist(), index=df.index)
    
    return df[['ID', 'Latitude', 'Longitude']].to_dict(orient='records')

# HTML 지도 페이지 렌더링
@app.route('/')
def map_page():
    return render_template('map.html')

# 지도에서 사용할 JSON 데이터 API
@app.route('/get_waypoints', methods=['GET'])
def get_waypoints():
    return jsonify(load_rddf())

# 마커 이동 시 `1_5_Waypoint_UTM.txt` 데이터 업데이트 API
@app.route('/update_rddf', methods=['POST'])
def update_rddf():
    df = pd.read_csv(FILE_PATH, delim_whitespace=True, header=None, names=['ID', 'X', 'Y'])

    # 요청으로부터 데이터 가져오기
    point_id = int(request.form['id'])
    new_lat = float(request.form['lat'])
    new_lng = float(request.form['lng'])

    # 위도/경도를 UTM 좌표로 변환
    new_x, new_y, _, _ = utm.from_latlon(new_lat, new_lng)

    # 데이터 업데이트
    df.loc[df['ID'] == point_id, ['X', 'Y']] = new_x, new_y
    df.to_csv(FILE_PATH, sep=' ', index=False, header=False)

    return jsonify({'status': 'success', 'message': f'Point {point_id} updated'})

if __name__ == '__main__':
    app.run(debug=True)

