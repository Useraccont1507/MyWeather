//
//  WeatherIconService.swift
//  MyWeather
//
//  Created by Illia Verezei on 23.12.2024.
//

import Foundation
import UIKit

class WeatherIconManager {
  private func decodeUnixToGMTTime(_ date: Int) -> Date {
    let unixTimestamp: TimeInterval = TimeInterval(date)
    let date = Date(timeIntervalSince1970: unixTimestamp)
    return date
  }
  
  func getIcon(with weatherCode: String, sunrise: Int, sunset: Int, completion: @escaping (Result<UIImage, Error>) -> ()) {
    
    let timeOfDay = Date.now
    let sunriseGMT = decodeUnixToGMTTime(sunrise)
    let sunsetGMT = decodeUnixToGMTTime(sunset)
    let isDay = timeOfDay > sunriseGMT.addingTimeInterval(-1800) && timeOfDay < sunsetGMT.addingTimeInterval(1800)
    
    let url = URL(string: "https://openweathermap.org/img/wn/" + weatherCode + "@2x.png")
    
    if let url = url {
      URLSession.shared.dataTask(with: url) { data, _, error in
        if let error = error {
          completion(.failure(error))
          return
        }
        if let data = data {
          if let image = UIImage(data: data) {
            completion(.success(image))
          } else {
            print("no image from data")
          }
        }
      }.resume()
    }
  }
}
