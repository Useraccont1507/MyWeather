//
//  Model.swift
//  MyWeather
//
//  Created by Illia Verezei on 19.11.2024.
//

import Foundation

//MARK: - For decoding
struct CityElement: Codable {
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

struct WeatherNow: Decodable {
  let coord: Coord
  let weather: [Weather]
  let base: String
  let main: Main
  let visibility: Int
  let wind: Wind
  let clouds: Clouds
  let dt: Int
  let sys: Sys
  let timezone: Int
  let id: Int
  let name: String
  let cod: Int
  
  enum CodingKeys: String, CodingKey {
    case coord, weather, base, main, visibility, wind, clouds, dt, sys, timezone, id, name, cod
  }
}

struct Coord: Decodable {
  let lon: Double
  let lat: Double
}

struct Weather: Decodable {
  let id: Int
  let main: String
  let description: String
  let icon: String
  
  enum CodingKeys: String, CodingKey {
    case id, main, icon
    case description = "description"
  }
}

struct Main: Decodable {
  let temp: Double
  let feelsLike: Double?
  let tempMin: Double?
  let tempMax: Double?
  let pressure: Int
  let humidity: Int
  let seaLevel: Int?
  let grndLevel: Int?
}

struct Wind: Decodable {
  let speed: Double
  let deg: Int
  let gust: Double
}

struct Clouds: Decodable {
  let all: Int
}

struct Sys: Decodable {
  let country: String
  let sunrise: Int
  let sunset: Int
}

//MARK: - For model
struct CityCoordinates: Equatable {
  var name: String
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
    coordinates.append(CityCoordinates(name: cityElement.name, lat: cityElement.lat, lon: cityElement.lon))
    Storage.shared.saveCityCoordinates(coordinates)
  }
  
  func deleteCityCoordinates(_ index: Int) {
    coordinates.remove(at: index)
    Storage.shared.saveCityCoordinates(coordinates)
  }
}
