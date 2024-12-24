//
//  WeatherIconService.swift
//  MyWeather
//
//  Created by Illia Verezei on 23.12.2024.
//

import Foundation
import UIKit

class WeatherIconManager {
  
  func getIcon(with weatherCode: String, completion: @escaping (Result<UIImage, Error>) -> ()) {
    
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
