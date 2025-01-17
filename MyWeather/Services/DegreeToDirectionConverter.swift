//
//  DegreeToDirectionConverter.swift
//  MyWeather
//
//  Created by Illia Verezei on 25.12.2024.
//

import Foundation

protocol DegreeToDirectionConverterProtocol {
  func degreesToDirection(degrees: Int) -> String
}

final class DegreeToDirectionConverter: DegreeToDirectionConverterProtocol {
  private let directions = [
    "N", "NNE", "NE", "ENE",
    "E", "ESE", "SE", "SSE",
    "S", "SSW", "SW", "WSW",
    "W", "WNW", "NW", "NNW"
  ]
  
  func degreesToDirection(degrees: Int) -> String {
    let index = Int((Double(degrees) + 11.25).truncatingRemainder(dividingBy: 360) / 22.5)
    return directions[index % 16]
  }
  
}
