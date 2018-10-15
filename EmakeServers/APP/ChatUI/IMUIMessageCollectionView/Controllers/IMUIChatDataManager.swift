//
//  IMUIChatDataManager.swift
//  IMUIChat
//
//  Created by oshumini on 2017/2/27.
//  Copyright © 2017年 HXHG. All rights reserved.
//

import UIKit

var needShowTimeInterval = Double.greatestFiniteMagnitude


class IMUIChatDataManager: NSObject {
  var allMsgidArr = [String]()
  var allMessageDic = [String:IMUIMessageProtocol]()
  var allMsgSelectArr = [Bool]()
  var count: Int {
    return allMsgidArr.count
  }
  
  subscript(index: Int) -> IMUIMessageProtocol {
    let msgId = allMsgidArr[index]
    return allMessageDic[msgId]!
  }
  
  subscript(msgId: String) -> IMUIMessageProtocol? {
    return allMessageDic[msgId]
  }
  
  var endIndex: Int {
    return allMsgidArr.endIndex
  }
  
  func cleanCache() {
    allMsgidArr.removeAll()
    allMessageDic.removeAll()
    allMsgSelectArr.removeAll()
  }
  
  func index(of message: IMUIMessageProtocol) -> Int? {
    return allMsgidArr.index(of: message.msgId)
  }
  
  open func appendMessage(with message: IMUIMessageProtocol) {
    self.allMsgidArr.append(message.msgId)
    self.allMessageDic[message.msgId] = message
    self.allMsgSelectArr.append(false)
  }
  
    open func addMessage(with message: IMUIMessageProtocol) {
        var messgaIDOrderArray : [String] = [String]()
        for i in 0..<self.allMsgidArr.count{
            let msgID = self.allMsgidArr[i]
            if msgID.characters.count != 36{
                messgaIDOrderArray.append(msgID)
            }
        }
        if messgaIDOrderArray.count >= 2 {
            for i in 0..<messgaIDOrderArray.count-1 {
                if (Int(message.msgId)! < Int(messgaIDOrderArray[0])!){
                    self.allMsgidArr.insert(message.msgId , at: 0)
                    self.allMessageDic[message.msgId] = message
                    self.allMsgSelectArr.insert(false , at: 0)
                    return;
                }
                if (Int(message.msgId)! > Int(messgaIDOrderArray[messgaIDOrderArray.count-1])!){
                    self.allMsgidArr.append(message.msgId)
                    self.allMessageDic[message.msgId] = message
                    self.allMsgSelectArr.append(false)
                    return;
                }
                if (Int(message.msgId)! > Int(messgaIDOrderArray[i])!) && (Int(message.msgId)! < Int(messgaIDOrderArray[i+1])!){
                    self.allMsgidArr.insert(message.msgId , at: i+1)
                    self.allMessageDic[message.msgId] = message
                    self.allMsgSelectArr.insert(false , at: i+1)
                }
            }
        }else{
            if messgaIDOrderArray.count == 0{
                self.allMsgidArr.insert(message.msgId , at: 0)
                self.allMessageDic[message.msgId] = message
                self.allMsgSelectArr.insert(false , at: 0)
            }else if messgaIDOrderArray.count == 1{
                if (Int(message.msgId)! < Int(messgaIDOrderArray[0])!) {
                    self.allMsgidArr.insert(message.msgId , at: 0)
                    self.allMessageDic[message.msgId] = message
                    self.allMsgSelectArr.insert(false , at: 0)
                }else{
                    self.allMsgidArr.append(message.msgId)
                    self.allMessageDic[message.msgId] = message
                    self.allMsgSelectArr.append(false)
                }
            }
        }
    }
  func updateMessage(with message: IMUIMessageProtocol) {
    if message.msgId == "" {
      print("the msgId is empty, cann't update message")
      return
    }
    allMessageDic[message.msgId] = message
  }
  
  func removeMessage(with messageId: String) {
    if messageId == "" {
      print("the msgId is empty, cann't update message")
      return
    }
    allMessageDic.removeValue(forKey: messageId)
    if let index = allMsgidArr.index(of: messageId) {
      allMsgidArr.remove(at: index)
    
    }
  }
  
  
  func insertMessage(with message: IMUIMessageProtocol) {
    if message.msgId == "" {
      print("the msgId is empty, cann't insert message")
      return
    }
    
    self.allMsgidArr.insert(message.msgId, at: 0)
    self.allMsgSelectArr.insert(false, at: 0)
    self.allMessageDic[message.msgId] = message
  }
  
  open func insertMessages(with messages:[IMUIMessageProtocol]) {
    for element in messages {
      self.insertMessage(with: element)
    }
  }
}
