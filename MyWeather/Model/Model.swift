//
//  Model.swift
//  MyWeather
//
//  Created by Illia Verezei on 19.11.2024.
//

import Foundation

//MARK: - City geocoding
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
// MARK: - WeatherNow
struct WeatherNow: Decodable {
  let coord: Coord?
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
  let gust: Double?
}

struct Clouds: Decodable {
  let all: Int
}

struct Sys: Decodable {
  let country: String
  let sunrise: Int
  let sunset: Int
}

// MARK: - WeatherHourly
struct WeatherHourly: Decodable {
    let cod: String
    let message, cnt: Int
    let list: [List]
    let city: City
}

struct City: Decodable {
    let id: Int
    let name: String
    let coord: Coord
    let country: String
    let population, timezone, sunrise, sunset: Int
}


struct List: Decodable {
    let dt: Int
    let main: MainClass
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    let visibility: Int?
    let pop: Double
    let snow: Rain?
    let sys: Sys
    let dtTxt: String
    let rain: Rain?

    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, visibility, pop, snow, sys
        case dtTxt = "dt_txt"
        case rain
    }
}

struct MainClass: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, seaLevel, grndLevel, humidity: Int
    let tempKf: Double

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}

struct Rain: Codable {
    let the3H: Double

    enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }
}

enum Pod: String, Codable {
    case d = "d"
    case n = "n"
}


enum Description: String, Codable {
    case легкийДощ = "легкий дощ"
    case легкийСніг = "легкий сніг"
    case рваніХмари = "рвані хмари"
    case хмарно = "хмарно"
}

enum Icon: String, Codable {
    case the04D = "04d"
    case the04N = "04n"
    case the10N = "10n"
    case the13N = "13n"
}

enum MainEnum: String, Codable {
    case clouds = "Clouds"
    case rain = "Rain"
    case snow = "Snow"
}


//MARK: - Model
struct CityCoordinates: Equatable {
  var name: String
  var lat: String
  var lon: String
}

class CitiesCoordinatesModel {
  private var coordinates: [CityCoordinates] = []
  
  static let shared = CitiesCoordinatesModel()
  
  func loadCitiesCoordinatesFromStorage(coordinates: [CityCoordinates]) {
    self.coordinates = coordinates
  }
  
  func getAllCitiesCoordinates() -> [CityCoordinates] {
    coordinates
  }
  
  func addCityCoordinatesToArray(_ cityElement: CityElement) {
    coordinates.append(CityCoordinates(name: cityElement.name, lat: cityElement.lat, lon: cityElement.lon))
  }
  
  func deleteCityCoordinates(_ index: Int) {
    coordinates.remove(at: index)
  }
}
