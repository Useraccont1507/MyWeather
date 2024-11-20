//
//  WebManager.swift
//  MyWeather
//
//  Created by Illia Verezei on 19.11.2024.
//

import Foundation

class WebManager {
  
  private var apiKey = "5d1d2171badb0afc3302079f35efb3e6"
  
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
    
    if let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=" + coordinates.lat + "&lon=" + coordinates.lon + "&lang=" + lang + "&appid=" + apiKey + "&units=metric") {
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
}
