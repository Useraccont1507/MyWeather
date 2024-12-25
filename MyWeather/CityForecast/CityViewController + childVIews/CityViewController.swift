//
//  CityViewController.swift
//  MyWeather
//
//  Created by Illia Verezei on 22.12.2024.
//

import UIKit

class CityViewController: UIViewController {
  
  private var city: CityCoordinates?
  private var timeZone: TimeZone?
  private var visibility: Int?
  
  lazy private var scrollView = UIScrollView()
  lazy private var contentView = UIView()
  lazy private var cityLabel = UILabel()
  lazy private var timeLabel = UILabel()
  lazy private var weatherDescriprionView = WeatherDescriprionView()
  lazy private var hourlyForecastView = HourlyForecastView()
  lazy private var visibilityView = VisibilityView()
  lazy private var windView = WindView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    getData()
    setupScrollView(scrollView)
    setupContentView(contentView)
    setupCityLabel(cityLabel)
    setupTimeLabel(timeLabel)
    setupWeatherDescriprion(weatherDescriprionView)
    setupHourlyForecastView(hourlyForecastView)
    setupVisibilityView(visibilityView)
    setupWindView(windView)
  }
  
  private func getData() {
    guard let city = city else { return }
    WebManager.shared.fetchTempNow(for: city) { result in
      switch result {
      case .success(let success):
        DispatchQueue.main.async {
          let layer = BackgroundManager().getBackground(for: success.weather.first!.id, sunrise: success.sys.sunrise ?? 0, sunset: success.sys.sunset ?? 0, frame: self.view.bounds)
          self.view.layer.insertSublayer(layer!, at: 0)
          self.visibility = success.visibility
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "MMM d, HH:mm"
          let timezone = TimeZone(secondsFromGMT: success.timezone)
          
          self.timeZone = timezone
          dateFormatter.timeZone = timezone
          let text = dateFormatter.string(from: Date.now)
          self.timeLabel.text = text
          
          self.weatherDescriprionView.configure(icon: success.weather.first!.icon, description: success.weather.first!.description, temp: success.main.temp, timezone: success.timezone, sunrise: success.sys.sunrise, sunset: success.sys.sunset)
          self.visibilityView.configure(visibility: success.visibility)
          self.windView.configure(wind: success.wind)
        }
      case .failure(let failure):
        print(failure)
      }
    }
  }
  
  private func getDataHourly(completion: @escaping ()->()) {
    guard let city = city else { return }
    WebManager.shared.fetchTempHourly(for: city) { result in
      switch result {
      case .success(let success):
        DispatchQueue.main.async {
          self.hourlyForecastView.configure(list: success.list)
          completion()
        }
      case .failure(let failure):
        print(failure)
      }
    }
  }
  
  private func setupScrollView(_ view: UIScrollView) {
    view.alwaysBounceVertical = true
    view.showsVerticalScrollIndicator = false
    view.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(view)
    
    NSLayoutConstraint.activate([
      view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
      view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
      view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
      view.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
    ])
  }
  
  private func setupContentView(_ contentView: UIView) {
    contentView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.addSubview(contentView)
    
    NSLayoutConstraint.activate([
      contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
      contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
      contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
      contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
      contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
    ])
  }
  
  private func setupCityLabel(_ label: UILabel) {
    label.text = city?.name ?? "--"
    label.font = .systemFont(ofSize: 28, weight: .semibold)
    label.textColor = .white
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(label)
    
    NSLayoutConstraint.activate([
      label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
      label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
    ])
  }
  
  private func setupTimeLabel(_ label: UILabel) {
    label.text = "--- -, --:--"
    label.font = .systemFont(ofSize: 18, weight: .light)
    label.textColor = .white
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(label)
    
    NSLayoutConstraint.activate([
      label.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 2),
      label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
    ])
  }
  
  private func setupWeatherDescriprion(_ view: WeatherDescriprionView) {
    view.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(view)
    
    NSLayoutConstraint.activate([
      view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      view.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 32),
      view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
      view.heightAnchor.constraint(equalToConstant: 180)
    ])
  }
  
  private func setupHourlyForecastView(_ view: HourlyForecastView) {
    getDataHourly {
      view.translatesAutoresizingMaskIntoConstraints = false
      self.contentView.addSubview(view)
      
      NSLayoutConstraint.activate([
        view.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
        view.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
        view.topAnchor.constraint(equalTo: self.weatherDescriprionView.bottomAnchor, constant: 16),
        view.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
        view.heightAnchor.constraint(equalToConstant: 154)
      ])
    }
  }
  
  private func setupVisibilityView(_ view: VisibilityView) {
    view.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(view)
    
    NSLayoutConstraint.activate([
      view.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
      view.trailingAnchor.constraint(equalTo: self.contentView.centerXAnchor, constant: -8),
      view.topAnchor.constraint(equalTo: weatherDescriprionView.bottomAnchor, constant: 186)
    ])
  }
  
  private func setupWindView(_ view: WindView) {
    view.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(view)
    
    NSLayoutConstraint.activate([
      view.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
      view.leadingAnchor.constraint(equalTo: self.contentView.centerXAnchor, constant: 8),
      view.topAnchor.constraint(equalTo: weatherDescriprionView.bottomAnchor, constant: 186)
    ])
  }
  
  func configure(_ city: CityCoordinates) {
    self.city = city
  }
}
