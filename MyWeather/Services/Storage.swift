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
    var arrayToSave: [[String: String]] = []
    for citiesCoordinate in citiesCoordinates {
      var dict: [String: String] = [:]
      dict["name"] = citiesCoordinate.name
      dict["lat"] = citiesCoordinate.lat
      dict["lon"] = citiesCoordinate.lon
      arrayToSave.append(dict)
    }
    storage.set(arrayToSave, forKey: Keys.cityCoordinates.rawValue)
  }
  
  func loadCityCoordinates() -> [SharedCityCoordinates] {
    guard let arrayFromStorage = storage.array(forKey: Keys.cityCoordinates.rawValue) as? [[String: String]] else { return [] }
    var arrayToReturn: [SharedCityCoordinates] = []
    for dict in arrayFromStorage {
      if let name = dict["name"], let lat = dict["lat"], let lon = dict["lon"] {
        arrayToReturn.append(SharedCityCoordinates(name: name, lat: lat, lon: lon))
      }
    }
    return arrayToReturn
  }
}
