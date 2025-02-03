//
//  Storage.swift
//  MyWeather
//
//  Created by Illia Verezei on 18.11.2024.
//

import Foundation

protocol StorageProtocol {
  func isFirstEnter() -> Bool
  func saveCityCoordinates(_ citiesCoordinates: [SharedCityCoordinates])
  func loadCityCoordinates() -> [SharedCityCoordinates]
}

final class Storage: StorageProtocol {
  
  private var storage = UserDefaults.standard
  
  private enum Keys: String {
    case isFirstEnter = "storage_key_enter_12589459492348927489"
    case cityCoordinates = "storage_key_cities_12384454445348428481"
  }
  
  func isFirstEnter() -> Bool {
    if storage.value(forKey: Keys.isFirstEnter.rawValue) == nil {
      storage.set(true, forKey: Keys.isFirstEnter.rawValue)
      return true
    }
    return false
  }
  
  func saveCityCoordinates(_ citiesCoordinates: [SharedCityCoordinates]) {
    do {
      let data = try JSONEncoder().encode(citiesCoordinates)
      storage.set(data, forKey: Keys.cityCoordinates.rawValue)
    } catch {
      print("encoding error form storage")
    }
  }
  
  func loadCityCoordinates() -> [SharedCityCoordinates] {
    guard let dataFromStorage = storage.data(forKey: Keys.cityCoordinates.rawValue) else {
      let arrayToReturn: [SharedCityCoordinates] = []
      return arrayToReturn
    }
    
    do {
      let array = try JSONDecoder().decode([SharedCityCoordinates].self, from: dataFromStorage)
      return array
    } catch {
      print("decoding error form storage")
      let arrayToReturn: [SharedCityCoordinates] = []
      return arrayToReturn
    }
  }
}
