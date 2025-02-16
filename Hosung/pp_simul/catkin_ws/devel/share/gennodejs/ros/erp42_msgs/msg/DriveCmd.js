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
    }
    else {
      if (initObj.hasOwnProperty('KPH')) {
        this.KPH = initObj.KPH
      }
      else {
        this.KPH = 0.0;
      }
      if (initObj.hasOwnProperty('Deg')) {
        this.Deg = initObj.Deg
      }
      else {
        this.Deg = 0.0;
      }
    }
  }

  static serialize(obj, buffer, bufferOffset) {
    // Serializes a message object of type DriveCmd
    // Serialize message field [KPH]
    bufferOffset = _serializer.float32(obj.KPH, buffer, bufferOffset);
    // Serialize message field [Deg]
    bufferOffset = _serializer.float32(obj.Deg, buffer, bufferOffset);
    return bufferOffset;
  }

  static deserialize(buffer, bufferOffset=[0]) {
    //deserializes a message object of type DriveCmd
    let len;
    let data = new DriveCmd(null);
    // Deserialize message field [KPH]
    data.KPH = _deserializer.float32(buffer, bufferOffset);
    // Deserialize message field [Deg]
    data.Deg = _deserializer.float32(buffer, bufferOffset);
    return data;
  }

  static getMessageSize(object) {
    return 8;
  }

  static datatype() {
    // Returns string type for a message object
    return 'erp42_msgs/DriveCmd';
  }

  static md5sum() {
    //Returns md5sum for a message object
    return '53c3fce15cc38e7376d7cdb3768313e0';
  }

  static messageDefinition() {
    // Returns full string definition for message
    return `
    ########################################
    # Messages
    ########################################
    float32 KPH
    float32 Deg
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
      resolved.KPH = 0.0
    }

    if (msg.Deg !== undefined) {
      resolved.Deg = msg.Deg;
    }
    else {
      resolved.Deg = 0.0
    }

    return resolved;
    }
};

module.exports = DriveCmd;
