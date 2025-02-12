#include <SoftwareSerial.h> // 상위 제어기와 통신하기 위한 라이브러리 
#include <ros.h>
#include <std_msgs/String.h>
#include <std_msgs/Empty.h>
#include <erp42_msgs/DriveCmd.h>
#include <std_msgs/Int32.h>
#include <std_msgs/Int16.h>
#include <std_msgs/UInt16.h>
#include <std_msgs/UInt8.h>
#include <std_msgs/Float64.h>
#include <std_msgs/Bool.h>

SoftwareSerial BTSerial(0, 1); // 소프트웨어 시리얼 (TX,RX)

int potential_pot = A4;    // 조향모터 가변저항 및 조향모터의 PID제어를 위한 변수
int val; 
int potential_val;
float kp = 0.3;
float ki = 0.0001 ;
float kd = 2.00;
float Theta, Theta_d;
int dt;
unsigned long t;
unsigned long t_prev = 0;
int val_prev =0;
float e, e_prev = 0, inte, inte_prev = 0;
float Vmax = 24;
float Vmin = -24;
float V = 0.1;
int St_M = 500;// 직진 조향값

const byte interruptPinA = 2;  // 구동모터의 엔코더센서 핀번호
const byte interruptPinB = 3;
volatile long EncoderCount = 0; // 엔코더 값 변수

const byte PWMPin = 6; // 조향 모터의 모터드라이브 PWM,DIR 핀번호 
const byte DirPin1 = 5;

int PWMone = 10; // 구동 모터의 모터드라이브 PWM1,PWM2,DIR1,DIR2 핀번호
int Dirone = 9;

float Speed = 0;
int tmpSpeed = 0;
int Steer = St_M;
int HSteer,HSpeed; // 상위 제어기와 통신을 위한 변수 
byte State, ESTOP, Mode,HGear;
byte ALIVE = 0;

/*
int Thro,Aux,Gear,ALIE,T,A,G,AL; // 조종기를 위한 변수
int tempAux2 = 0;
int tempAux1 = 0; // 튀는 값으로 인한 Auto Mode 전환 방
*/

int target_speed = 0;
int target_angle = 0;

void SteerCon(float Q) { // 조향모터의 제어를 위한 함수, Q = 조향 목표값  
    val = Q;                           
    if(val>St_M+500){  // 조향 최대값 제한
      val=St_M+500;
    }
    else if(val<St_M-500){ // 조향 최소값 제한 
      val= St_M-500;
    }
    potential_val = analogRead(potential_pot);               // Read V_out from Feedback Pot
    t = millis();
    dt = (t - t_prev);                                  // Time step
    Theta = val;                                        // Theta= Actual Angular Position of the Motor
    Theta_d = potential_val;                              // Theta_d= Desired Angular Position of the Motor

    e = Theta_d - Theta;                                // Error
    inte = inte_prev + (dt * (e + e_prev) / 2);         // Integration of Error
    V = kp * e + ki * inte + (kd * (e - e_prev) / dt) ; // Controlling Function

    if (V > Vmax) {
        V = Vmax;
       inte = inte_prev;
     }
    if (V < Vmin) {
      V = Vmin;
      inte = inte_prev;
      val_prev= val;
     }
    int PWMval = int(255 * abs(V) / Vmax);
    if (PWMval > 200) {
      PWMval = 200;
    }
    if (V > 0.8) {
      digitalWrite(DirPin1, LOW);
      analogWrite(PWMPin, PWMval);
    }
    else if (V < -0.8) {
      digitalWrite(DirPin1, HIGH);
      analogWrite(PWMPin, PWMval);
    }
    else {
      digitalWrite(DirPin1, LOW);
      analogWrite(PWMPin, 0);
    }
    t_prev = t;
    inte_prev = inte;
    e_prev = e;
}

void Mdrive(int q){ //구동모터의 제어를 위한 함수, q = Speed, w = 정,역방향 지정
  if(q >= 10){
    digitalWrite(Dirone,1);
    analogWrite(PWMone,q);
    
  }
  else if(q <= -10){
    digitalWrite(Dirone,0);
    analogWrite(PWMone,abs(q));
  }
  else {
    digitalWrite(Dirone,0);
    analogWrite(PWMone,0);
  }
}

void ISR_EncoderA() { // 엔코더 값을 저장하기 위한 내부 인터럽트 서비스 함수
  bool PinB = digitalRead(interruptPinB);
  bool PinA = digitalRead(interruptPinA);

  if (PinB == LOW) {
    if (PinA == HIGH) {
      EncoderCount++;
    }
    else {
      EncoderCount--;
    }
  }

  else {
    if (PinA == HIGH) {
      EncoderCount--;
    }
    else {
      EncoderCount++;
    }
  }
}
void ISR_EncoderB() { // 엔코더 값을 저장하기 위한 내부 인터럽트 서비스 함수
  bool PinB = digitalRead(interruptPinA);
  bool PinA = digitalRead(interruptPinB);

  if (PinA == LOW) {
    if (PinB == HIGH) {
      EncoderCount--;
    }
    else {
      EncoderCount++;
    }
  }

  else {
    if (PinB == HIGH) {
      EncoderCount++;
    }
    else {
      EncoderCount--;
    }
  }
}

float alpha = 0.90;

float rawAux = 1450;
float rawThro = 1450;
float rawALIE = 1450;

float Aux  = 1450;
float Thro = 1450;
float ALIE = 1450;


void controller() {
  rawAux = pulseIn(A2, HIGH, 50000);   //  아날로그2번 핀의 pwm입력신호가 LOW로 바뀐 순간부터 HIGH로 바뀌는 순간까지의 경과시간을 마이크로초 단위로 Aux변수에 저장. 만약, 50ms시간동안 펄스의 변화가 없다면, 0값이 Aux변수에 저장된다.
  rawThro = pulseIn(A1, HIGH, 50000);  //  아날로그1번 핀의 pwm입력신호가 LOW로 바뀐 순간부터 HIGH로 바뀌는 순간까지의 경과시간을 마이크로초 단위로 Thro변수에 저장. 만약, 50ms시간동안 펄스의 변화가 없다면, 0값이 Thro변수에 저장된다.
  rawALIE = pulseIn(A0, HIGH, 50000);  //  아날로그0번 핀의 pwm입력신호가 LOW로 바뀐 순간부터 HIGH로 바뀌는 순간까지의 경과시간을 마이크로초 단위로 Rudd변수에 저장. 만약, 50ms시간동안 펄스의 변화가 없다면, 0값이 Rudd변수에 저장된다.

  if(rawThro >= 1900) {rawThro = 1900;}
  if(rawThro <= 1330) {rawThro = 1330;}
  //if(abs(Thro-rawThro) > 50) {rawThro = Thro;}
  
  Aux  = alpha * Aux  + (1.0 - alpha) * rawAux;
  Thro = alpha * Thro + (1.0 - alpha) * rawThro;
  ALIE = alpha * ALIE + (1.0 - alpha) * rawALIE;

  /*
  T = Thro/50; Thro = T*50; A = Aux/50; Aux = A*50; G = Gear/50; Gear = G*50; AL = ALIE/50; ALIE = AL*50; // 조종기 신호 안정화
  
  if(ALIE>1700){ ALIE=1700; } else if(ALIE<100){ALIE=1450;} else if(ALIE<1100){ ALIE = 1100; } // 조종기 ALIE(조향) 신호 최대 최소값 제한
  if(Thro>1850){ Thro=1850; }  else if(Thro<1050){ ESTOP = 1;} else{ESTOP=0;} // 조종기 THRO(구동) 신호 최대값 제한, Throttle Cut할때 ESTOP신호 주도록 설정 
  if(Thro >= 1450) {
    tmpSpeed = map(Thro, 1450, 1850, 0, 255); // 조종기 THRO 신호를 Speed값으로 변환 
    Speed = tmpSpeed;
  }
  else if(Thro < 1400){
    tmpSpeed = map(Thro, 1400, 1300, 0, 150);
    Speed = -tmpSpeed;
  }
  if(Speed>255){ Speed = 255; } else if(abs(Speed)<10 or ESTOP == 1 ){ Speed = 0; } // Speed값 최대 최소값 제한 및 ESTOP상황에서 멈추도록 설정
  Steer = map(ALIE, 1200, 1700, St_M-500, St_M+500); // 조종기 ALIE 신호를 Steer값으로 변환
  if(Steer>St_M+300){ Steer = St_M+300; } else if(Steer<St_M-300){ Steer = St_M-300; } // Steer값 최대 최소값 제한
  else if(Steer>St_M-20 and Steer<St_M+20){ Steer = St_M;} // 조향 유지를 위한 DeadZone
  if(Aux != 1800 && Aux != 1050) {Aux = 1450;} 
  if(((tempAux1+tempAux2+Aux)/3) == 1800){ State = 0;} else if(((tempAux1+tempAux2+Aux)/3) == 1050){ State = 1; } // A : Auto, B : Manual
  tempAux2 = tempAux1;
  tempAux1 = Aux;
  */
}

void manual_mode() {
  if (BTSerial.available()) { // 블루투스 데이터가 수신됐는지 확인
    int incomingByte = BTSerial.read(); // 데이터 읽기
    if (incomingByte != 10) {      
      // 'F' (70)를 입력받으면 spd를 양수로 설정
      if (incomingByte == 'F') {
        Steer = St_M; // 직진
      }
      // 'B' (66)를 입력받으면 spd를 음수로 설정
      else if (incomingByte == 'B') {
        float tempspeed = Speed;
        Speed = 0;
        delay(500);
        digitalWrite(Dirone,LOW); // spd 값을 음수로 만듦;
     }
      // ASCII '0'은 48, '9'는 57이므로 숫자 데이터만 처리
      else if (incomingByte >= 48 && incomingByte <= 57) {
        Speed = (incomingByte - 48)*25;
     }

      // 'R' 입력 처리
      if (incomingByte == 'R') {
        Steer = St_M+500;
      } 
      // 'L' 입력 처리
      else if (incomingByte == 'L') {
        Steer = St_M-500;
      }
      
      if (incomingByte == 77) {
       if(State == 0) {
        State = 1; // 오토 모드
       }
       else {
        State = 0; // 메뉴얼 모
       }  
      }
    }   
  } 
}

void target_input() {
  // 시리얼 데이터가 있는지 확인
  if (Serial.available() > 0) {
    // 시리얼 포트로부터 한 줄을 읽어옴
    String receivedData = Serial.readStringUntil('\n');
    
    // 쉼표를 기준으로 데이터를 분리
    int commaIndex = receivedData.indexOf(',');
    if (commaIndex != -1) {
      // 첫 번째 정수 값(목표 각도)을 파싱
      Steer = receivedData.substring(0, commaIndex).toInt();
      
      // 두 번째 정수 값(목표 속도)을 파싱
      Speed = receivedData.substring(commaIndex + 1).toInt();
    }
  }
}

ros::NodeHandle  nh;

void drive(const erp42_msgs::DriveCmd &msg){
  target_speed = msg.KPH;
  target_angle = msg.Deg;
}

ros::Subscriber<erp42_msgs::DriveCmd> sub("/erp42_serial/drive", &drive );

/*
std_msgs::Int16 steer_msg;  // 퍼블리시할 메시지 객체 생성
ros::Publisher steer_pub("steer_topic", &steer_msg); 
*/

void setup() {
  Serial.begin(57600); // 시리얼 통신을 위한 Baudrate 
  pinMode(PWMPin, OUTPUT);
  pinMode(DirPin1, OUTPUT); // 조향 모터 
  pinMode(PWMone,OUTPUT);
  pinMode(Dirone,OUTPUT); // 구동 모터
  pinMode(interruptPinA, INPUT_PULLUP); // 엔코더 핀 
  pinMode(interruptPinB, INPUT_PULLUP);
  attachInterrupt(digitalPinToInterrupt(interruptPinA), ISR_EncoderA, CHANGE); // 엔코더 값을 읽기 위한 인터럽트 서비스 루틴 
  attachInterrupt(digitalPinToInterrupt(interruptPinB), ISR_EncoderB, CHANGE);  
  nh.initNode();
  nh.subscribe(sub);
  //nh.advertise(steer_pub);
  //Serial.println("\nSTART\n");
}


void loop() {
  controller();  // 조종기 명령값 수신 
  //manual_mode(); // 블루투스 모듈로 명령값 수신, ros와 동시 동작 X
  //target_input(); // 시리얼창에서 명령값 수신
  if(State == 1){ //AUTO상태일때 State == 1
    nh.spinOnce();
    HSpeed = target_speed;
    HSpeed = map(HSpeed, -20, 20, -255, 255);
    HSteer = target_angle; //상위 제어기에서 STEER값 저장 
    HSteer = map(HSteer, -20, 20, St_M+500, St_M-500);
    Mdrive(HSpeed);    //SPEED값 제어
    SteerCon(HSteer);    //STEER값 제어
  }
  else { // MANUAL상태일때 플랫폼 제어
    //Mdrive(Speed); //SPEED값 제어
    //SteerCon(Steer); //STEER값 제어
  }
  //steer_msg.data = potential_val;
  //steer_pub.publish(&steer_msg);  // 메시지 퍼블리시

  delay(1);
  
  
  /*
  Serial.print("AUX : ");
  Serial.print(Aux);
  Serial.print(" // Thro : ");
  Serial.print(Thro);
  Serial.print(" // ALIE : ");
  Serial.print(ALIE);
  Serial.print(" // State : ");
  Serial.print(State);
  Serial.print(" // ros_spd : ");
  Serial.print(target_speed);
  Serial.print(" // ros_ang : ");
  Serial.print(target_angle);
  Serial.print(" // PWM_spd : ");
  Serial.print(HSpeed);
  Serial.print(" // target_ang :");
  Serial.print(HSteer);
  Serial.print(" // manual_spd : ");
  Serial.print(Speed);
  Serial.print(" // manual_ang : ");
  Serial.print(Steer);
  Serial.print(" // current_ang : ");
  Serial.println(potential_val);
  */
  Serial.print("rawAux:");
  Serial.print(rawAux);
  Serial.print(",");
  Serial.print("rawThro:");
  Serial.print(rawThro);
  Serial.print(",");
  Serial.print("rawALIE:");
  Serial.print(rawALIE);
  Serial.print(",");
  
  Serial.print("Aux:");
  Serial.print(Aux);
  Serial.print(",");
  Serial.print("Thro:");
  Serial.print(Thro);
  Serial.print(",");
  Serial.print("ALIE:");
  Serial.println(ALIE);
  
  
  //Serial.println(EncoderCount);
}
