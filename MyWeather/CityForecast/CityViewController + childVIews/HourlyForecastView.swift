//
//  HorlyForecastView.swift
//  MyWeather
//
//  Created by Illia Verezei on 22.12.2024.
//

import UIKit

class HourlyForecastView: UIView {
  
  private var weatherList: [List] = []
  private var timezone: TimeZone?
  
  lazy private var imageView = UIImageView()
  lazy private var headerLabel = UILabel()
  lazy private var separatorView = UIView()
  lazy private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: CollectionViewLayout())
  
  init() {
    super.init(frame: .zero)
    setupHeaderLabel(headerLabel)
    setupImageView(imageView)
    setupSeparatorView(separatorView)
    setupCollectionView(collectionView)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupHeaderLabel(_ label: UILabel) {
    label.text = "Hourly forecast"
    label.font = .systemFont(ofSize: 22, weight: .regular)
    label.textColor = .white
    label.textAlignment = .left
    label.translatesAutoresizingMaskIntoConstraints = false
    addSubview(label)
    
    NSLayoutConstraint.activate([
      label.topAnchor.constraint(equalTo: topAnchor),
      label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28)
    ])
  }
  
  private func setupImageView(_ imageView: UIImageView) {
    let boldConfiguration = UIImage.SymbolConfiguration(weight: .medium)
    
    imageView.image = UIImage(systemName: "clock", withConfiguration: boldConfiguration)
    imageView.tintColor = .white
    imageView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(imageView)
    
    NSLayoutConstraint.activate([
      imageView.widthAnchor.constraint(equalToConstant: 20),
      imageView.heightAnchor.constraint(equalToConstant: 20),
      imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
      imageView.centerYAnchor.constraint(equalTo: headerLabel.centerYAnchor)
    ])
  }
  
  private func setupSeparatorView(_ separator: UIView) {
    separator.backgroundColor = .lightGray
    separator.translatesAutoresizingMaskIntoConstraints = false
    addSubview(separator)
    
    NSLayoutConstraint.activate([
      separator.leadingAnchor.constraint(equalTo: leadingAnchor),
      separator.trailingAnchor.constraint(equalTo: trailingAnchor),
      separator.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 8),
      separator.heightAnchor.constraint(equalToConstant: 2)
    ])
  }
  
  private func setupCollectionView(_ collection: UICollectionView) {
    collection.backgroundColor = .clear
    collection.alwaysBounceHorizontal = true
    collection.showsHorizontalScrollIndicator = false
    collection.register(CollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    collection.dataSource = self
    collection.delegate = self
    collection.translatesAutoresizingMaskIntoConstraints = false
    addSubview(collection)
    
    NSLayoutConstraint.activate([
      collection.leadingAnchor.constraint(equalTo: leadingAnchor),
      collection.trailingAnchor.constraint(equalTo: trailingAnchor),
      collection.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 8),
      collection.heightAnchor.constraint(equalToConstant: 110)
    ])
  }
  
  func configure(city: CityCoordinates?, timezone: TimeZone?, completion: @escaping () -> ()) {
    self.timezone = timezone
    guard let city = city else { return }
    WebManager.shared.fetchTempHourly(for: city) { result in
      switch result {
      case .success(let success):
        DispatchQueue.main.async {
          self.weatherList = success.list
          completion()
        }
      case .failure(let failure):
        print(failure)
      }
    }
  }
}

extension HourlyForecastView: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return weatherList.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CollectionViewCell else {
      fatalError("Expected CollectionViewCell")
    }
    let item = self.weatherList[indexPath.row]
    cell.configure(time: item.dt, timezone: self.timezone, weatherIcon: item.weather.first!.icon, temp: item.main.temp)
    
    return cell
  }
}

extension HourlyForecastView: UICollectionViewDelegate {
  
}