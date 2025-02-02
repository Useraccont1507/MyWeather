//
//  CityViewController.swift
//  MyWeather
//
//  Created by Illia Verezei on 22.12.2024.
//

import UIKit

class CityViewController: UIViewController {
  
  private var presenter: CityPagePresenterProtocol?
  
  private var loadingView: LoadingView?
  private let scrollView = UIScrollView()
  private let contentView = UIView()
  private let cityLabel = UILabel()
  private let timeLabel = UILabel()
  private let weatherDescriptionView = WeatherDescriprionView()
  private let hourlyForecastView = HourlyForecastView()
  private let visibilityView = VisibilityView()
  private let windView = WindView()
  private let pressureView = PressureAndHumidityReusableView()
  private let humidityView = PressureAndHumidityReusableView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupBackground()
    setupScrollView(scrollView)
    setupContentView(contentView)
    setupCityLabel(cityLabel)
    setupTimeLabel(timeLabel)
    setupWeatherDescription(weatherDescriptionView)
    setupHourlyForecastView(hourlyForecastView)
    setupVisibilityView(visibilityView)
    setupWindView(windView)
    setupPressureView(pressureView)
    setupHumidityView(humidityView)
  }
  
  func setupBackground() {
      let layer = BackgroundManager().getBackground(for: nil, sunrise: nil, sunset: nil, frame: self.view.bounds)
      self.view.layer.insertSublayer(layer!, at: 0)
    }
  
  private func setupScrollView(_ view: UIScrollView) {
    view.bouncesZoom = false
    view.alwaysBounceVertical = true
    view.showsVerticalScrollIndicator = false
    view.isUserInteractionEnabled = NetworkMonitor.shared.isConnected
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
}

extension CityViewController: CityViewProtocol {
  func reloadCollectionView() {
    hourlyForecastView.reloadCollection()
  }
  
  func startLoadingView() {
    showLoadingView()
  }
  
  func stopLoadingView() {
    dismissLoadingView()
  }
  
  
  func setPresenter(presenter: any CityPagePresenterProtocol) {
    self.presenter = presenter
  }
  
  func handleNetworkChange(isConnected: Bool) {
    if isConnected {
      presenter?.fetchForecastNow(viewFrame: view.bounds)
      presenter?.fetchForecastHourly { [unowned self] in
        self.setupHourlyForecastView(self.hourlyForecastView)
      }
      view.layoutIfNeeded()
    }
  }
  
  func prepareDataForCollectionView(hourlyWeahterList: [List], timezone: TimeZone?) {
    hourlyForecastView.configure(list: hourlyWeahterList, timezone: timezone)
  }
  
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
  ) {
    self.view.layer.sublayers?.forEach { layer in
      if layer is CAGradientLayer {
        layer.removeFromSuperlayer()
      }
    }
    self.view.layer.insertSublayer(background!, at: 0)
    cityLabel.text = cityName
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM d, HH:mm"
    let timezoneSecondary = TimeZone(secondsFromGMT: timezone)
    dateFormatter.timeZone = timezoneSecondary
    let text = dateFormatter.string(from: Date.now)
    self.timeLabel.text = text
    
    weatherDescriptionView.configure(
      icon: weatherIcon,
      description: description,
      temp: temp,
      timezone: timezone,
      sunrise: sunrise,
      sunset: sunset
    )
  }
  
  func prepareDataForOtherViews(visibility: Int, wind: Wind, pressure: Int, humidity: Int) {
    self.visibilityView.configure(visibility: visibility)
    self.windView.configure(wind: wind)
    self.pressureView.configure(value: pressure, image: UIImage(systemName: "aqi.medium"), title: "pressure".localized)
    self.humidityView.configure(value: humidity, image: UIImage(systemName: "humidity.fill"), title: "humidity".localized)
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
