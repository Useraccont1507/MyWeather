//
//  CityViewController.swift
//  MyWeather
//
//  Created by Illia Verezei on 22.12.2024.
//

import UIKit

class CityViewController: UIViewController {
  
  private var city: CityCoordinates?
  private var timezone: TimeZone?
  
  private var loadingView: LoadingView?
  lazy private var scrollView = UIScrollView()
  lazy private var contentView = UIView()
  lazy private var cityLabel = UILabel()
  lazy private var timeLabel = UILabel()
  lazy private var weatherDescriptionView = WeatherDescriprionView()
  lazy private var hourlyForecastView = HourlyForecastView()
  lazy private var visibilityView = VisibilityView()
  lazy private var windView = WindView()
  lazy private var pressureView = PressureAndHumidityReusableView()
  lazy private var humidityView = PressureAndHumidityReusableView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupBackground()
    setupScrollView(scrollView)
    setupContentView(contentView)
    setupCityLabel(cityLabel)
    getData {
      self.setupTimeLabel(self.timeLabel)
      self.setupWeatherDescription(self.weatherDescriptionView)
      self.setupHourlyForecastView(self.hourlyForecastView)
      self.setupVisibilityView(self.visibilityView)
      self.setupWindView(self.windView)
      self.setupPressureView(self.pressureView)
      self.setupHumidityView(self.humidityView)
    }
  }
  
  func setupBackground() {
    let layer = BackgroundManager().getBackground(for: nil, sunrise: nil, sunset: nil, frame: self.view.bounds)
    self.view.layer.insertSublayer(layer!, at: 0)
  }
  
  private func getData(_ completion: @escaping () -> Void) {
    guard let city = city else { return }
    
    showLoadingView()
    
    WebManager.shared.fetchTempNow(for: city) { result in
      DispatchQueue.main.async {
        switch result {
        case .success(let success):
          self.view.layer.sublayers?.forEach { layer in
            if layer is CAGradientLayer {
              layer.removeFromSuperlayer()
            }
          }
          
          let layer = BackgroundManager().getBackground(for: success.weather.first?.id, sunrise: success.sys.sunrise, sunset: success.sys.sunset, frame: self.view.bounds)
          self.view.layer.insertSublayer(layer!, at: 0)
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "MMM d, HH:mm"
          let timezone = TimeZone(secondsFromGMT: success.timezone)
          self.timezone = timezone
          
          dateFormatter.timeZone = timezone
          let text = dateFormatter.string(from: Date.now)
          self.timeLabel.text = text
          
          self.weatherDescriptionView.configure(icon: success.weather.first!.icon, description: success.weather.first!.description, temp: success.main.temp, timezone: success.timezone, sunrise: success.sys.sunrise, sunset: success.sys.sunset)
          self.visibilityView.configure(visibility: success.visibility)
          self.windView.configure(wind: success.wind)
          self.pressureView.configure(value: success.main.pressure, image: UIImage(systemName: "aqi.medium"), title: "pressure".localized)
          self.humidityView.configure(value: success.main.humidity, image: UIImage(systemName: "humidity.fill"), title: "humidity".localized)
          completion()
          self.dismissLoadingView()
        case .failure(let failure):
          print(failure)
        }
      }
    }
  }
  
  private func getDataHourly(completion: @escaping ()->()) {
    guard let city = city else { return }
    WebManager.shared.fetchTempHourly(for: city) { result in
      switch result {
      case .success(let success):
        DispatchQueue.main.async {
          self.hourlyForecastView.configure(list: success.list, timezone: self.timezone)
          completion()
        }
      case .failure(let failure):
        print(failure)
      }
    }
  }
  
  private func setupScrollView(_ view: UIScrollView) {
    view.bouncesZoom = false
    view.alwaysBounceVertical = true
    view.showsVerticalScrollIndicator = false
    view.isUserInteractionEnabled = NetworkMonitor.shared.isConnected
    
    NetworkMonitor.shared.onStatusChange = { [weak self] isConnected in
      self?.handleNetworkChange(isConnected: isConnected)
    }
    
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
      contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
    ])
  }
  
  private func setupCityLabel(_ label: UILabel) {
    label.text = city?.name ?? "-"
    label.font = .systemFont(ofSize: 28, weight: .semibold)
    label.textColor = .white
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(label)
    
    NSLayoutConstraint.activate([
      label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 48),
      label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
    ])
  }
  
  private func setupTimeLabel(_ label: UILabel) {
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
  
  private func setupWeatherDescription(_ view: WeatherDescriprionView) {
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
      self.contentView.bringSubviewToFront(view)
      view.translatesAutoresizingMaskIntoConstraints = false
      self.contentView.addSubview(view)
      
      NSLayoutConstraint.activate([
        view.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
        view.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
        view.topAnchor.constraint(equalTo: self.weatherDescriptionView.bottomAnchor, constant: 16),
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
      view.topAnchor.constraint(equalTo: weatherDescriptionView.bottomAnchor, constant: 186),
      view.heightAnchor.constraint(equalToConstant: 114)
    ])
  }
  
  private func setupWindView(_ view: WindView) {
    view.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(view)
    
    NSLayoutConstraint.activate([
      view.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
      view.leadingAnchor.constraint(equalTo: self.contentView.centerXAnchor, constant: 8),
      view.topAnchor.constraint(equalTo: weatherDescriptionView.bottomAnchor, constant: 186),
      view.heightAnchor.constraint(equalToConstant: 114)
    ])
  }
  
  private func setupPressureView(_ view: PressureAndHumidityReusableView) {
    view.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(view)
    
    NSLayoutConstraint.activate([
      view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      view.trailingAnchor.constraint(equalTo: self.contentView.centerXAnchor, constant: -8),
      view.topAnchor.constraint(equalTo: windView.bottomAnchor, constant: 16),
      view.heightAnchor.constraint(equalToConstant: 114)
    ])
  }
  
  private func setupHumidityView(_ view: PressureAndHumidityReusableView) {
    view.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(view)
    
    NSLayoutConstraint.activate([
      view.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
      view.leadingAnchor.constraint(equalTo: self.contentView.centerXAnchor, constant: 8),
      view.topAnchor.constraint(equalTo: windView.bottomAnchor, constant: 16),
      view.heightAnchor.constraint(equalToConstant: 114),
      view.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor)
    ])
  }
  
  func configure(_ city: CityCoordinates) {
    self.city = city
  }
  
  private func handleNetworkChange(isConnected: Bool) {
    if isConnected {
      self.getData {
        self.setupTimeLabel(self.timeLabel)
        self.setupWeatherDescription(self.weatherDescriptionView)
        self.setupHourlyForecastView(self.hourlyForecastView)
        self.setupVisibilityView(self.visibilityView)
        self.setupWindView(self.windView)
        self.setupPressureView(self.pressureView)
        self.setupHumidityView(self.humidityView)
      }
      self.view.layoutIfNeeded()
    }
  }
}

extension CityViewController {
  func showLoadingView() {
    if loadingView == nil {
      let loading = LoadingView(frame: view.bounds)
      view.addSubview(loading)
      loading.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
        loading.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        loading.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        loading.topAnchor.constraint(equalTo: view.topAnchor),
        loading.bottomAnchor.constraint(equalTo: view.bottomAnchor)
      ])
      loadingView = loading
    }
  }
  
  func dismissLoadingView() {
    loadingView?.removeFromSuperview()
    loadingView = nil
  }
}
