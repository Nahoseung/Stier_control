// ROS 관련 라이브러리
#include <ros.h>
#include <erp42_msgs/DriveCmd.h>
#include <erp42_msgs/SerialFeedBack.h>
#include <std_msgs/String.h>
#include <std_msgs/Empty.h>
#include <std_msgs/Int32.h>
#include <std_msgs/Int16.h>
#include <std_msgs/UInt16.h>
#include <std_msgs/UInt8.h>
#include <std_msgs/Float64.h>
#include <std_msgs/Bool.h>

// 잔여 RAM 용량 확인을 위한 라이브러리
extern "C" {
  #include <avr/io.h>
  #include <avr/pgmspace.h>
}

/////////////////
// PIN DEFINES //
/////////////////

#define PIN_ENCODER_A 2
#define PIN_ENCODER_B 3

#define PIN_STEER_DIR 5
#define PIN_STEER_PWM 6

#define PIN_DRIVE_DIR 9
#define PIN_DRIVE_PWM 10

#define PIN_LED 13

#define PIN_RC_STR A0
#define PIN_RC_THR A1
#define PIN_RC_AUX A2

#define PIN_STEER_SENSOR A3

////////////////////
// CONFIG DEFINES //
////////////////////

#define PWM_WAIT_TIME 15000

#define STEER_ANGLE_MAX 20
#define STEER_ANGLE_MIN -20

// original setup
// kp = 0.3
// ki = 0.0001
// kd = 2.00
#define STEER_PID_KP 0.3
#define STEER_PID_KI 0.0001
#define STEER_PID_KD 2.00



//////////////////////
// GLOBAL VARIABLES //
//////////////////////

volatile long encoder_count = 0; // 엔코더 값 변수

enum ControlMode {
  RC = 0,
  ROS = 1
};

struct ControlCmd {
  int speed;
  int steer;
  ControlMode mode;
  unsigned long timestamp;
};

ControlCmd cmd_ros;

////////////////////
// UTIL FUNCTIONS //
////////////////////

float map_float(float x, float in_min, float in_max, float out_min, float out_max) {
  return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
}



///////////////////////////
// check free ram memory //
///////////////////////////

int freeMemory() {
  extern int __heap_start, *__brkval;
  int v;
  return (int) &v - (__brkval == 0 ? (int) &__heap_start : (int) __brkval);
}



//////////////////////
// command updaters //
//////////////////////

void update_cmd_ros(const erp42_msgs::DriveCmd &msg){
  cmd_ros.speed = msg.KPH;
  cmd_ros.steer = msg.Deg;
  cmd_ros.timestamp = millis();
}

void update_cmd_rc(ControlCmd* cmd) {
  // 아날로그 핀의 pwm입력신호가 LOW로 바뀐 순간부터 HIGH로 바뀌는 순간까지의 경과시간을 마이크로초 단위로 Aux변수에 저장.
  // 만약, 50ms시간동안 펄스의 변화가 없다면, 0값이 Aux변수에 저장된다.
  int str = pulseIn(A0, HIGH, PWM_WAIT_TIME);
  int thr = pulseIn(A1, HIGH, PWM_WAIT_TIME);
  int aux = pulseIn(A2, HIGH, PWM_WAIT_TIME);

  // 신호 안정화를 위해 50단위로 신호를 자름.
  str = (str/50)*50;
  thr = (thr/50)*50;
  aux = (aux/50)*50;

  // debug print
  Serial.print(" str="); Serial.print(str); Serial.print(" thr="); Serial.print(thr); Serial.print(" aux="); Serial.print(aux);

  // str 신호를 기반으로 steer값 결정.
  static int str_min = 1000;
  static int str_max = 1900;
  str = constrain(str, str_min, str_max);
  // TODO : steer 값의 범위에 대한 config 값을 중앙 관리화
  static int steer_min = 200;
  static int steer_max = 800;
  int steer = map(str, str_min, str_max, steer_min, steer_max);

  // thr 신호를 기반으로 speed값 결정.
  static int thr_max = 1850;
  static int thr_mid = 1450;
  static int thr_min = 1050;
  thr = constrain(thr, thr_min, thr_max);
  static int speed_min = 0;
  static int speed_forward_max = 255;
  static int speed_backward_max = 150;
  int speed = map(thr, thr_mid, thr_max, speed_min, speed_forward_max);
  if(thr < thr_mid) {
    speed = -1 * speed;
  }

  // aux 신호를 기반으로 mode값 결정.
  static int filtered_aux = 1450;
  static float alpha = 0.1;
  filtered_aux = alpha * aux + (1 - alpha) * filtered_aux;
  static ControlMode mode = RC;
  if(filtered_aux < 1200) {
    mode = ROS;
  }
  if(filtered_aux > 1600) {
    mode = RC;
  }

  // 최종 명령값을 반환
  cmd->speed = speed;
  cmd->steer = steer;
  cmd->mode = mode;
}



///////////////////
// motor control //
///////////////////

// TODO : 여기 정리
void control_motor_steer(int steer) {
    static unsigned long t_prev = 0;
    int dt = millis() - t_prev;
    t_prev = t_prev + dt;

    static float theta_prev = 500;
    float theta = constrain(steer, 200, 800);
    theta_prev = theta;

    float theta_d = analogRead(PIN_STEER_SENSOR);

    static float e_prev = 0;
    float e = theta_d - theta;
    e_prev = e;

    static float inte_prev = 0;
    float inte = inte_prev + (dt * (e + e_prev) / 2);
    inte_prev = inte;

    static float V = 0.1;
    static float kp = 0.3;
    static float ki = 0.0001;
    static float kd = 2.00;
    V = kp * e + ki * inte + (kd * (e - e_prev) / dt);

    static float Vmax = 24;
    static float Vmin = -24;
    if (V > Vmax) {
        V = Vmax;
       inte = inte_prev;
     }
    if (V < Vmin) {
      V = Vmin;
      inte = inte_prev;
      theta_prev= theta;
     }
    int PWMval = int(255 * abs(V) / Vmax);
    if (PWMval > 200) {
      PWMval = 200;
    }
    if (V > 0.8) {
      digitalWrite(PIN_STEER_DIR, LOW);
      analogWrite(PIN_STEER_PWM, PWMval);
    }
    else if (V < -0.8) {
      digitalWrite(PIN_STEER_DIR, HIGH);
      analogWrite(PIN_STEER_PWM, PWMval);
    }
    else {
      digitalWrite(PIN_STEER_DIR, LOW);
      analogWrite(PIN_STEER_PWM, 0);
    }
}

void control_motor_drive(int speed){
  if(speed >= 10){
    digitalWrite(PIN_DRIVE_DIR, HIGH);
    analogWrite(PIN_DRIVE_PWM, speed);
  }
  else if(speed <= -10){
    digitalWrite(PIN_DRIVE_DIR, LOW);
    analogWrite(PIN_DRIVE_PWM, abs(speed));
  }
  else {
    digitalWrite(PIN_DRIVE_DIR, LOW);
    analogWrite(PIN_DRIVE_PWM, 0);
  }
}

void control_motor(int speed, int steer) {
  control_motor_drive(speed);
  control_motor_steer(steer);
}



/////////////
// encoder //
/////////////

void interrupt_handler_encoder_a() {
  bool b = digitalRead(PIN_ENCODER_B);
  bool a = digitalRead(PIN_ENCODER_A);
  if (b == LOW) {
    if (a == HIGH) encoder_count++;
    else encoder_count--;
  }
  else {
    if (a == HIGH) encoder_count--;
    else encoder_count++;
  }
}

void interrupt_handler_encoder_b() {
  bool b = digitalRead(PIN_ENCODER_A);
  bool a = digitalRead(PIN_ENCODER_B);
  if (a == LOW) {
    if (b == HIGH) encoder_count--;
    else encoder_count++;
  }
  else {
    if (b == HIGH) encoder_count++;
    else encoder_count--;
  }
}



///////////////
// ROS SETUP //
///////////////

ros::NodeHandle nh;
ros::Subscriber<erp42_msgs::DriveCmd> drive_sub("/erp42_serial/drive", &update_cmd_ros);

erp42_msgs::SerialFeedBack feedback_msg;
ros::Publisher feedback_pub("/erp42_serial/feedback", &feedback_msg); 
/*
std_msgs::Int16 steer_msg;  // 퍼블리시할 메시지 객체 생성
ros::Publisher steer_pub("steer_topic", &steer_msg); 
*/

//////////////////
// setup & loop //
//////////////////

void setup() {
  // 시리얼 통신을 위한 Baudrate 
  Serial.begin(57600);

  // Setup Pin Modes
  pinMode(PIN_STEER_DIR, OUTPUT);
  pinMode(PIN_STEER_PWM, OUTPUT);
  pinMode(PIN_DRIVE_DIR,OUTPUT);
  pinMode(PIN_DRIVE_PWM,OUTPUT);
  pinMode(PIN_ENCODER_A, INPUT_PULLUP);
  pinMode(PIN_ENCODER_B, INPUT_PULLUP);
  pinMode(PIN_LED, OUTPUT); // LED for indicate control mode

  // 엔코더 값을 읽기 위한 인터럽트 서비스 루틴 
  attachInterrupt(digitalPinToInterrupt(PIN_ENCODER_A), interrupt_handler_encoder_a, CHANGE); 
  attachInterrupt(digitalPinToInterrupt(PIN_ENCODER_B), interrupt_handler_encoder_b, CHANGE);

  // Steup for ROS
  nh.initNode();
  nh.subscribe(drive_sub);
  nh.advertise(feedback_pub);
}

void loop() {
  // calculate loop time
  static unsigned long loop_start_time = 0;
  static unsigned long loop_duration = 0;
  loop_duration = micros() - loop_start_time;
  loop_start_time = loop_start_time + loop_duration;

  // update rc controller input
  static ControlCmd cmd_rc;
  update_cmd_rc(&cmd_rc);
  ControlMode control_mode = cmd_rc.mode;

  // update ros controller input
  nh.spinOnce();
  // stop car if ros input is not updated in 1 seconds
  if((cmd_ros.timestamp-millis()) > 1000) {
    cmd_ros.speed = 0;
    cmd_ros.steer = 0;
  }
  
  // main control logic
  switch (control_mode) {
    case ROS:
      digitalWrite(PIN_LED, HIGH);
      int speed = map(cmd_ros.speed, STEER_ANGLE_MIN, STEER_ANGLE_MAX, -255, 255);
      int steer = map(cmd_ros.steer, STEER_ANGLE_MIN, STEER_ANGLE_MAX, 200, 800);
      control_motor(speed, steer);
      break;

    case RC:
      digitalWrite(PIN_LED, LOW);
      control_motor(cmd_rc.speed, cmd_rc.steer);
      break;
  }

  // publish feedback msg
  int pot = analogRead(PIN_STEER_SENSOR);
  feedback_msg.steer = map_float((float)pot, 200, 800, STEER_ANGLE_MIN, STEER_ANGLE_MAX);
  float revs = (float)encoder_count / 144;
  float dt = (float)loop_duration / 1000;
  feedback_msg.speed = 0.7226 * revs / dt * 1000; // 2 * pi * r(=0.115)
  feedback_pub.publish(&feedback_msg);
    
  // debug messages
  Serial.print(" rc_spd=");
  Serial.print(cmd_rc.speed);
  Serial.print(" rc_str=");
  Serial.print(cmd_rc.steer);
  Serial.print(" cur_ang=");
  Serial.print(pot);

  Serial.print(" ros_spd=");
  Serial.print(cmd_ros.speed);
  Serial.print(" ros_str=");
  Serial.print(cmd_ros.steer);
  Serial.print(" mode=");
  Serial.print(control_mode);

  Serial.print(" feedback_speed=");
  Serial.print(feedback_msg.speed);
  Serial.print(" feedback_steer=");
  Serial.print(feedback_msg.steer);

  Serial.print(" free_ram=");
  Serial.print(freeMemory());
  Serial.print(" loop_time="); 
  Serial.print(loop_duration);
  Serial.print(" loop_hz="); 
  Serial.print(1000000/(float)loop_duration);
  Serial.println();
}