//
//  Storage.swift
//  MyWeather
//
//  Created by Illia Verezei on 18.11.2024.
//

import Foundation

class Storage {
  static let shared = Storage()
  
  private var storage = UserDefaults.standard
  
  private enum Keys: String {
    case isFirstEnter = "storage_key_enter_12589459492348927489"
  }
  
  private init() {}
  
  func isFirstEnter() -> Bool {
    if storage.value(forKey: Keys.isFirstEnter.rawValue) == nil {
      storage.set(true, forKey: Keys.isFirstEnter.rawValue)
      return true
    }
    return false
  }
}
