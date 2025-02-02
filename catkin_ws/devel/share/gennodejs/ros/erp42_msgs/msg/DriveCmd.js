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

class DriveCmd {
  constructor(initObj={}) {
    if (initObj === null) {
      // initObj === null is a special case for deserialization where we don't initialize fields
      this.KPH = null;
      this.Deg = null;
      this.brake = null;
    }
    else {
      if (initObj.hasOwnProperty('KPH')) {
        this.KPH = initObj.KPH
      }
      else {
        this.KPH = 0;
      }
      if (initObj.hasOwnProperty('Deg')) {
        this.Deg = initObj.Deg
      }
      else {
        this.Deg = 0;
      }
      if (initObj.hasOwnProperty('brake')) {
        this.brake = initObj.brake
      }
      else {
        this.brake = 0;
      }
    }
  }

  static serialize(obj, buffer, bufferOffset) {
    // Serializes a message object of type DriveCmd
    // Serialize message field [KPH]
    bufferOffset = _serializer.uint16(obj.KPH, buffer, bufferOffset);
    // Serialize message field [Deg]
    bufferOffset = _serializer.int16(obj.Deg, buffer, bufferOffset);
    // Serialize message field [brake]
    bufferOffset = _serializer.uint8(obj.brake, buffer, bufferOffset);
    return bufferOffset;
  }

  static deserialize(buffer, bufferOffset=[0]) {
    //deserializes a message object of type DriveCmd
    let len;
    let data = new DriveCmd(null);
    // Deserialize message field [KPH]
    data.KPH = _deserializer.uint16(buffer, bufferOffset);
    // Deserialize message field [Deg]
    data.Deg = _deserializer.int16(buffer, bufferOffset);
    // Deserialize message field [brake]
    data.brake = _deserializer.uint8(buffer, bufferOffset);
    return data;
  }

  static getMessageSize(object) {
    return 5;
  }

  static datatype() {
    // Returns string type for a message object
    return 'erp42_msgs/DriveCmd';
  }

  static md5sum() {
    //Returns md5sum for a message object
    return '69a82c1e3ba067908d8fabb7e7d8716a';
  }

  static messageDefinition() {
    // Returns full string definition for message
    return `
    ########################################
    # Messages
    ########################################
    uint16 KPH
    int16 Deg
    uint8 brake
    
    `;
  }

  static Resolve(msg) {
    // deep-construct a valid message object instance of whatever was passed in
    if (typeof msg !== 'object' || msg === null) {
      msg = {};
    }
    const resolved = new DriveCmd(null);
    if (msg.KPH !== undefined) {
      resolved.KPH = msg.KPH;
    }
    else {
      resolved.KPH = 0
    }

    if (msg.Deg !== undefined) {
      resolved.Deg = msg.Deg;
    }
    else {
      resolved.Deg = 0
    }

    if (msg.brake !== undefined) {
      resolved.brake = msg.brake;
    }
    else {
      resolved.brake = 0
    }

    return resolved;
    }
};

module.exports = DriveCmd;
