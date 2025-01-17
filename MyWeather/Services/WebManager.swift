//
//  WebManager.swift
//  MyWeather
//
//  Created by Illia Verezei on 19.11.2024.
//

import Foundation

protocol WebManagerProtocol {
  func getUnits() -> Units
  func switchToFahrenheitUnits()
  func switchToCelsiusUnits()
  func fetchCityCoordinates(for text: String, completion: @escaping (Result<[CityElement], Error>) -> ())
  func fetchTempNow(for coordinates: CityCoordinates, completion: @escaping (Result<WeatherNow, Error>) -> ())
  func fetchTempHourly(for coordinates: CityCoordinates, completion: @escaping (Result<WeatherHourly, Error>) -> ())
}

enum Units: String {
  case imperial
  case metric
}

final class WebManager: WebManagerProtocol {
  
  static let shared = WebManager()
  
  private var apiKey = "5d1d2171badb0afc3302079f35efb3e6"
  
  private var units = Units.metric
  
  func getUnits() -> Units {
    units
  }
  
  func switchToFahrenheitUnits() {
    units = .imperial
  }
  
  func switchToCelsiusUnits() {
    units = .metric
  }
  
  func fetchCityCoordinates(for text: String, completion: @escaping (Result<[CityElement], Error>) -> ()) {
    if let url = URL(string: "https://nominatim.openstreetmap.org/search?addressdetails=1&featureType=city&q=" + text + "&format=json&limit=5") {
      
      URLSession.shared.dataTask(with: url) { data, _, error in
        if let error = error {
          completion(.failure(error))
          
          return
        }
        
        if let data = data {
          do {
            let cities = try JSONDecoder().decode([CityElement].self, from: data)
            completion(.success(cities))
          } catch {
            completion(.failure(error))
          }
        }
      }.resume()
    }
  }
  
  func fetchTempNow(for coordinates: CityCoordinates, completion: @escaping (Result<WeatherNow, Error>) -> ()) {
    let currentLocale = Locale.current
    var lang = "en"
    if currentLocale.languageCode == "uk" {
      lang = "ua"
    }
    
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = "api.openweathermap.org"
    urlComponents.path = "/data/2.5/weather"
    urlComponents.queryItems = [
      URLQueryItem(name: "lat", value: coordinates.lat),
      URLQueryItem(name: "lon", value: coordinates.lon),
      URLQueryItem(name: "lang", value: lang),
      URLQueryItem(name: "appid", value: apiKey),
      URLQueryItem(name: "units", value: units.rawValue)
    ]
    
    if let url = urlComponents.url {
      URLSession.shared.dataTask(with: url) { data, _, error in
        if let error = error {
          completion(.failure(error))
          return
        }
        if let respData = data {
          do {
            let weatherNow = try JSONDecoder().decode(WeatherNow.self, from: respData)
            completion(.success(weatherNow))
          } catch {
            completion(.failure(error))
          }
        }
      }.resume()
    }
  }
  
  func fetchTempHourly(for coordinates: CityCoordinates, completion: @escaping (Result<WeatherHourly, Error>) -> ()) {
    let currentLocale = Locale.current
    var lang = "en"
    if currentLocale.languageCode == "uk" {
      lang = "ua"
    }
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = "api.openweathermap.org"
    urlComponents.path = "/data/2.5/forecast"
    urlComponents.queryItems = [
      URLQueryItem(name: "lat", value: coordinates.lat),
      URLQueryItem(name: "lon", value: coordinates.lon),
      URLQueryItem(name: "lang", value: lang),
      URLQueryItem(name: "appid", value: apiKey),
      URLQueryItem(name: "units", value: units.rawValue)
    ]
    
    if let url = urlComponents.url {
      URLSession.shared.dataTask(with: url) { data, _, error in
        if let error = error {
          completion(.failure(error))
          return
        }
        if let respData = data {
          do {
            let weatherHourly = try JSONDecoder().decode(WeatherHourly.self, from: respData)
            completion(.success(weatherHourly))
          } catch {
            completion(.failure(error))
          }
        }
      }.resume()
    }
  }
}
