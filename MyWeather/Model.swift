//
//  Model.swift
//  MyWeather
//
//  Created by Illia Verezei on 19.11.2024.
//

import Foundation

struct CityElement: Decodable {
    let placeID: Int
    let licence, osmType: String
    let osmID: Int
    let lat, lon, cityClass, type: String
    let placeRank: Int
    let importance: Double
    let addresstype, name, displayName: String
    let boundingbox: [String]

    enum CodingKeys: String, CodingKey {
        case placeID = "place_id"
        case licence
        case osmType = "osm_type"
        case osmID = "osm_id"
        case lat, lon
        case cityClass = "class"
        case type
        case placeRank = "place_rank"
        case importance, addresstype, name
        case displayName = "display_name"
        case boundingbox
    }
}

struct CityCoordinates {
  var lat: String
  var lon: String
}

class CitiesCoordinatesModel {
  private var coordinates: [CityCoordinates] = []
  
  static let shared = CitiesCoordinatesModel()
  
  func loadCitiesCoordinatesFromStorage() {
    coordinates = Storage.shared.loadCityCoordinates()
  }
  
  func getAllCitiesCoordinates() -> [CityCoordinates] {
    coordinates
  }
  
  func addCityCoordinatesToArray(_ cityElement: CityElement) {
    coordinates.append(CityCoordinates(lat: cityElement.lat, lon: cityElement.lon))
    Storage.shared.saveCityCoordinates(coordinates)
  }
  
  func deleteCityCoordinates(_ index: Int) {
    coordinates.remove(at: index)
    Storage.shared.saveCityCoordinates(coordinates)
  }
}
