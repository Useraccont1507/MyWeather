//
//  CityPagePresenter.swift
//  MyWeather
//
//  Created by Illia Verezei on 02.02.2025.
//

import UIKit

protocol CityViewProtocol: AnyObject {
  func setPresenter(presenter: CityViewPresenterProtocol)
  func handleNetworkChange(isConnected: Bool)
  func prepareDataForView(
    background: CAGradientLayer?,
    cityName: String,
    dateString: String,
    weatherIcon: String,
    description: String,
    temp: Double,
    sunrise: Int?,
    sunset: Int?,
    timezone: Int
  )
  func prepareDataForCollectionView(hourlyWeahterList: [List], timezone: TimeZone?)
  func reloadCollectionView()
  func startLoadingView()
  func stopLoadingView()
  
  func prepareDataForOtherViews(
    visibility: Int,
    wind: Wind,
    pressure: Int,
    humidity: Int
  )
}

protocol CityViewPresenterProtocol {
  func startNetworkMonitor()
  func fetchForecastNow(viewFrame: CGRect)
  func fetchForecastHourly(completion: @escaping () -> Void)
}

class CityViewPresenter: CityViewPresenterProtocol {
  weak var view: CityViewProtocol?
  var city: SharedCityCoordinates
  var webManager: WebManagerProtocol
  var backgroundManager: BackgroundManager
  var viewSize: CGRect
  private var timeZone: TimeZone?
  
  init(view: CityViewProtocol, city: SharedCityCoordinates, webManager: WebManagerProtocol, backgroundManager: BackgroundManager, viewSize: CGRect) {
    self.view = view
    self.view?.startLoadingView()
    self.city = city
    self.webManager = webManager
    self.backgroundManager = backgroundManager
    self.viewSize = viewSize
    fetchForecastNow(viewFrame: viewSize)
    fetchForecastHourly {
      view.reloadCollectionView()
    }
  }
  
  func startNetworkMonitor() {
    NetworkMonitor.shared.onStatusChange = { [weak self] isConnected in
      self?.view?.handleNetworkChange(isConnected: isConnected)
    }
  }
  
  private func getRightDate(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM d, HH:mm"
    let timezoneSecondary = TimeZone(secondsFromGMT: timezone)
    dateFormatter.timeZone = timezoneSecondary
    let dateString = dateFormatter.string(from: date)
    return dateString
  }
  
  func fetchForecastNow(viewFrame: CGRect) {
    webManager.fetchTempNow(for: city) { result in
      DispatchQueue.main.async {
        switch result {
        case .success(let success):
          let background = self.backgroundManager.getBackground(
            for: success.weather.first?.id,
            sunrise: success.sys.sunrise,
            sunset: success.sys.sunset,
            frame: viewFrame
          )
          
          self.view?.prepareDataForView(
            background: background,
            cityName: self.city.name,
            dateString: self.getRightDate(date: Date.now),
            weatherIcon: success.weather.first!.icon,
            description: success.weather.first!.description,
            temp: success.main.temp,
            sunrise: success.sys.sunrise,
            sunset: success.sys.sunset,
            timezone: success.timezone
          )
          self.timeZone = TimeZone(secondsFromGMT: success.timezone)
          
          self.view?.prepareDataForOtherViews(
            visibility: success.visibility,
            wind: success.wind,
            pressure: success.main.pressure,
            humidity: success.main.humidity
          )
        case .failure(let failure):
          print(failure)
        }
      }
    }
  }
  
  func fetchForecastHourly(completion: @escaping () -> Void) {
    webManager.fetchTempHourly(for: city) { result in
      DispatchQueue.main.async {
        switch result {
        case .success(let success):
          self.view?.prepareDataForCollectionView(hourlyWeahterList: success.list, timezone: self.timeZone)
          self.view?.stopLoadingView()
          completion()
        case .failure(let failure):
          print(failure)
        }
      }
    }
  }
}
