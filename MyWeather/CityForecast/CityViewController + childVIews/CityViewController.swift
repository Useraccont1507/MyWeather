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
  
  lazy private var scrollView = UIScrollView()
  lazy private var contentView = UIView()
  lazy private var cityLabel = UILabel()
  lazy private var timeLabel = UILabel()
  lazy private var weatherDescriprionView = WeatherDescriprionView()
  lazy private var hourlyForecastView = HourlyForecastView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupBackground()
    setupScrollView(scrollView)
    setupContentView(contentView)
    setupCityLabel(cityLabel)
    setupTimeLabel(timeLabel)
    configureTime()
    setupWeatherDescriprion(weatherDescriprionView)
    setupHourlyForecastView(hourlyForecastView)
  }
  
  private func setupBackground() {
    guard let city = city else { return }
    WebManager.shared.fetchTempNow(for: city) { result in
      switch result {
      case .success(let success):
        DispatchQueue.main.async {
          let layer = BackgroundManager().getBackground(for: success.weather.first!.id, sunrise: success.sys.sunrise ?? 0, sunset: success.sys.sunset ?? 0, frame: self.view.bounds)
          self.view.layer.insertSublayer(layer!, at: 0)
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
    view.configure(city)
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
    view.configure(city: city, timezone: timeZone) {
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
  
  func configure(_ city: CityCoordinates) {
    self.city = city
  }
  
  func configureTime() {
    guard let city = city else { return }
    WebManager.shared.fetchTempNow(for: city) { result in
      switch result {
      case .success(let success):
        DispatchQueue.main.async {
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "MMM d, HH:mm"
          let timeManager = TimeManager()
          let timezone = TimeZone(identifier: timeManager.getTimeZoneIdentifier(for: success.sys.country!))
          self.timeZone = timezone
          dateFormatter.timeZone = timezone
          let text = dateFormatter.string(from: Date.now)
          self.timeLabel.text = text
        }
      case .failure(let failure):
        print(failure)
      }
    }
  }
}
