//
//  TimeManager.swift
//  MyWeather
//
//  Created by Illia Verezei on 24.12.2024.
//

import Foundation

protocol TimeManagerProtocol {
  func decodeUnixToGMTTime(_ date: Int) -> Date
}

final class TimeManager: TimeManagerProtocol {
  func decodeUnixToGMTTime(_ date: Int) -> Date {
    let unixTimestamp: TimeInterval = TimeInterval(date)
    let date = Date(timeIntervalSince1970: unixTimestamp)
    return date
  }
}
