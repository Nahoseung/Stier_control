// Auto-generated. Do not edit!

// (in-package erp42_msgs.msg)


"use strict";

const _serializer = _ros_msg_utils.Serialize;
const _arraySerializer = _serializer.Array;
const _deserializer = _ros_msg_utils.Deserialize;
const _arrayDeserializer = _deserializer.Array;
const _finder = _ros_msg_utils.Find;
const _getByteLength = _ros_msg_utils.getByteLength;

//-----------------------------------------------------------

class CANFeedBack {
  constructor(initObj={}) {
    if (initObj === null) {
      // initObj === null is a special case for deserialization where we don't initialize fields
      this.MorA = null;
      this.EStop = null;
      this.Gear = null;
      this.speed = null;
      this.steer = null;
      this.brake = null;
      this.alive = null;
      this.encoder = null;
      this.brake_cmd_raw = null;
      this.brake_raw = null;
      this.brake_echo = null;
      this.brake_init_max = null;
    }
    else {
      if (initObj.hasOwnProperty('MorA')) {
        this.MorA = initObj.MorA
      }
      else {
        this.MorA = 0;
      }
      if (initObj.hasOwnProperty('EStop')) {
        this.EStop = initObj.EStop
      }
      else {
        this.EStop = 0;
      }
      if (initObj.hasOwnProperty('Gear')) {
        this.Gear = initObj.Gear
      }
      else {
        this.Gear = 0;
      }
      if (initObj.hasOwnProperty('speed')) {
        this.speed = initObj.speed
      }
      else {
        this.speed = 0.0;
      }
      if (initObj.hasOwnProperty('steer')) {
        this.steer = initObj.steer
      }
      else {
        this.steer = 0.0;
      }
      if (initObj.hasOwnProperty('brake')) {
        this.brake = initObj.brake
      }
      else {
        this.brake = 0;
      }
      if (initObj.hasOwnProperty('alive')) {
        this.alive = initObj.alive
      }
      else {
        this.alive = 0;
      }
      if (initObj.hasOwnProperty('encoder')) {
        this.encoder = initObj.encoder
      }
      else {
        this.encoder = 0;
      }
      if (initObj.hasOwnProperty('brake_cmd_raw')) {
        this.brake_cmd_raw = initObj.brake_cmd_raw
      }
      else {
        this.brake_cmd_raw = 0;
      }
      if (initObj.hasOwnProperty('brake_raw')) {
        this.brake_raw = initObj.brake_raw
      }
      else {
        this.brake_raw = 0;
      }
      if (initObj.hasOwnProperty('brake_echo')) {
        this.brake_echo = initObj.brake_echo
      }
      else {
        this.brake_echo = 0;
      }
      if (initObj.hasOwnProperty('brake_init_max')) {
        this.brake_init_max = initObj.brake_init_max
      }
      else {
        this.brake_init_max = 0;
      }
    }
  }

  static serialize(obj, buffer, bufferOffset) {
    // Serializes a message object of type CANFeedBack
    // Serialize message field [MorA]
    bufferOffset = _serializer.uint8(obj.MorA, buffer, bufferOffset);
    // Serialize message field [EStop]
    bufferOffset = _serializer.uint8(obj.EStop, buffer, bufferOffset);
    // Serialize message field [Gear]
    bufferOffset = _serializer.uint8(obj.Gear, buffer, bufferOffset);
    // Serialize message field [speed]
    bufferOffset = _serializer.float64(obj.speed, buffer, bufferOffset);
    // Serialize message field [steer]
    bufferOffset = _serializer.float64(obj.steer, buffer, bufferOffset);
    // Serialize message field [brake]
    bufferOffset = _serializer.uint8(obj.brake, buffer, bufferOffset);
    // Serialize message field [alive]
    bufferOffset = _serializer.uint8(obj.alive, buffer, bufferOffset);
    // Serialize message field [encoder]
    bufferOffset = _serializer.int32(obj.encoder, buffer, bufferOffset);
    // Serialize message field [brake_cmd_raw]
    bufferOffset = _serializer.uint8(obj.brake_cmd_raw, buffer, bufferOffset);
    // Serialize message field [brake_raw]
    bufferOffset = _serializer.uint8(obj.brake_raw, buffer, bufferOffset);
    // Serialize message field [brake_echo]
    bufferOffset = _serializer.uint8(obj.brake_echo, buffer, bufferOffset);
    // Serialize message field [brake_init_max]
    bufferOffset = _serializer.uint8(obj.brake_init_max, buffer, bufferOffset);
    return bufferOffset;
  }

  static deserialize(buffer, bufferOffset=[0]) {
    //deserializes a message object of type CANFeedBack
    let len;
    let data = new CANFeedBack(null);
    // Deserialize message field [MorA]
    data.MorA = _deserializer.uint8(buffer, bufferOffset);
    // Deserialize message field [EStop]
    data.EStop = _deserializer.uint8(buffer, bufferOffset);
    // Deserialize message field [Gear]
    data.Gear = _deserializer.uint8(buffer, bufferOffset);
    // Deserialize message field [speed]
    data.speed = _deserializer.float64(buffer, bufferOffset);
    // Deserialize message field [steer]
    data.steer = _deserializer.float64(buffer, bufferOffset);
    // Deserialize message field [brake]
    data.brake = _deserializer.uint8(buffer, bufferOffset);
    // Deserialize message field [alive]
    data.alive = _deserializer.uint8(buffer, bufferOffset);
    // Deserialize message field [encoder]
    data.encoder = _deserializer.int32(buffer, bufferOffset);
    // Deserialize message field [brake_cmd_raw]
    data.brake_cmd_raw = _deserializer.uint8(buffer, bufferOffset);
    // Deserialize message field [brake_raw]
    data.brake_raw = _deserializer.uint8(buffer, bufferOffset);
    // Deserialize message field [brake_echo]
    data.brake_echo = _deserializer.uint8(buffer, bufferOffset);
    // Deserialize message field [brake_init_max]
    data.brake_init_max = _deserializer.uint8(buffer, bufferOffset);
    return data;
  }

  static getMessageSize(object) {
    return 29;
  }

  static datatype() {
    // Returns string type for a message object
    return 'erp42_msgs/CANFeedBack';
  }

  static md5sum() {
    //Returns md5sum for a message object
    return '8d74d0371fb1f42def9619b2296ec65d';
  }

  static messageDefinition() {
    // Returns full string definition for message
    return `
    ########################################
    # Messages
    ########################################
    uint8 MorA
    uint8 EStop
    uint8 Gear
    float64 speed
    float64 steer
    uint8 brake
    uint8 alive
    
    int32 encoder
    uint8 brake_cmd_raw
    uint8 brake_raw
    uint8 brake_echo
    uint8 brake_init_max
    
    
    `;
  }

  static Resolve(msg) {
    // deep-construct a valid message object instance of whatever was passed in
    if (typeof msg !== 'object' || msg === null) {
      msg = {};
    }
    const resolved = new CANFeedBack(null);
    if (msg.MorA !== undefined) {
      resolved.MorA = msg.MorA;
    }
    else {
      resolved.MorA = 0
    }

    if (msg.EStop !== undefined) {
      resolved.EStop = msg.EStop;
    }
    else {
      resolved.EStop = 0
    }

    if (msg.Gear !== undefined) {
      resolved.Gear = msg.Gear;
    }
    else {
      resolved.Gear = 0
    }

    if (msg.speed !== undefined) {
      resolved.speed = msg.speed;
    }
    else {
      resolved.speed = 0.0
    }

    if (msg.steer !== undefined) {
      resolved.steer = msg.steer;
    }
    else {
      resolved.steer = 0.0
    }

    if (msg.brake !== undefined) {
      resolved.brake = msg.brake;
    }
    else {
      resolved.brake = 0
    }

    if (msg.alive !== undefined) {
      resolved.alive = msg.alive;
    }
    else {
      resolved.alive = 0
    }

    if (msg.encoder !== undefined) {
      resolved.encoder = msg.encoder;
    }
    else {
      resolved.encoder = 0
    }

    if (msg.brake_cmd_raw !== undefined) {
      resolved.brake_cmd_raw = msg.brake_cmd_raw;
    }
    else {
      resolved.brake_cmd_raw = 0
    }

    if (msg.brake_raw !== undefined) {
      resolved.brake_raw = msg.brake_raw;
    }
    else {
      resolved.brake_raw = 0
    }

    if (msg.brake_echo !== undefined) {
      resolved.brake_echo = msg.brake_echo;
    }
    else {
      resolved.brake_echo = 0
    }

    if (msg.brake_init_max !== undefined) {
      resolved.brake_init_max = msg.brake_init_max;
    }
    else {
      resolved.brake_init_max = 0
    }

    return resolved;
    }
};

module.exports = CANFeedBack;
