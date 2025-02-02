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

class SerialFeedBack {
  constructor(initObj={}) {
    if (initObj === null) {
      // initObj === null is a special case for deserialization where we don't initialize fields
      this.MorA = null;
      this.EStop = null;
      this.Gear = null;
      this.speed = null;
      this.steer = null;
      this.brake = null;
      this.encoder = null;
      this.alive = null;
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
      if (initObj.hasOwnProperty('encoder')) {
        this.encoder = initObj.encoder
      }
      else {
        this.encoder = 0;
      }
      if (initObj.hasOwnProperty('alive')) {
        this.alive = initObj.alive
      }
      else {
        this.alive = 0;
      }
    }
  }

  static serialize(obj, buffer, bufferOffset) {
    // Serializes a message object of type SerialFeedBack
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
    bufferOffset = _serializer.int16(obj.brake, buffer, bufferOffset);
    // Serialize message field [encoder]
    bufferOffset = _serializer.int32(obj.encoder, buffer, bufferOffset);
    // Serialize message field [alive]
    bufferOffset = _serializer.uint8(obj.alive, buffer, bufferOffset);
    return bufferOffset;
  }

  static deserialize(buffer, bufferOffset=[0]) {
    //deserializes a message object of type SerialFeedBack
    let len;
    let data = new SerialFeedBack(null);
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
    data.brake = _deserializer.int16(buffer, bufferOffset);
    // Deserialize message field [encoder]
    data.encoder = _deserializer.int32(buffer, bufferOffset);
    // Deserialize message field [alive]
    data.alive = _deserializer.uint8(buffer, bufferOffset);
    return data;
  }

  static getMessageSize(object) {
    return 26;
  }

  static datatype() {
    // Returns string type for a message object
    return 'erp42_msgs/SerialFeedBack';
  }

  static md5sum() {
    //Returns md5sum for a message object
    return '977be1b73fb4d99913310d68e9241255';
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
    int16 brake
    int32 encoder
    uint8 alive
    
    `;
  }

  static Resolve(msg) {
    // deep-construct a valid message object instance of whatever was passed in
    if (typeof msg !== 'object' || msg === null) {
      msg = {};
    }
    const resolved = new SerialFeedBack(null);
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

    if (msg.encoder !== undefined) {
      resolved.encoder = msg.encoder;
    }
    else {
      resolved.encoder = 0
    }

    if (msg.alive !== undefined) {
      resolved.alive = msg.alive;
    }
    else {
      resolved.alive = 0
    }

    return resolved;
    }
};

module.exports = SerialFeedBack;
