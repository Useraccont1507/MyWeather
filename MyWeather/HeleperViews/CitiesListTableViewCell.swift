//
//  CitiesListTableViewCell.swift
//  MyWeather
//
//  Created by Illia Verezei on 20.11.2024.
//

import UIKit

class CitiesListTableViewCell: UITableViewCell {
  
  private var coordinates: CityCoordinates?
  
  lazy private var roundedRectangleView = UIView()
  lazy private var cityLabel = UILabel()
  lazy private var weahterDescpitionLabel = UILabel()
  lazy private var tempLabel = UILabel()
  lazy private var feelsLikeTempLabel = UILabel()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupRoundedRectangleView(roundedRectangleView)
    setupTempLabel(tempLabel)
    setupCityLabel(cityLabel)
    setupWeahterDescpitionLabel(weahterDescpitionLabel)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  private func setupRoundedRectangleView(_ rectangle: UIView) {
    rectangle.backgroundColor = .blue
    rectangle.layer.cornerRadius = 24
    rectangle.layer.shadowColor = UIColor.black.cgColor
    rectangle.layer.shadowOpacity = 0.25
    rectangle.layer.shadowOffset = CGSize(width: 0, height: 10)
    rectangle.layer.shadowRadius = 10
    rectangle.translatesAutoresizingMaskIntoConstraints = false
    
    contentView.addSubview(rectangle)
    
    NSLayoutConstraint.activate([
      rectangle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      rectangle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
      rectangle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
      rectangle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
    ])
  }
  
  private func setupCityLabel(_ label: UILabel) {
    label.text = "--"
    label.font = .systemFont(ofSize: 40, weight: .regular)
    label.textColor = .systemBackground
    label.textAlignment = .left
    label.translatesAutoresizingMaskIntoConstraints = false
    
    contentView.addSubview(label)
    
    NSLayoutConstraint.activate([
      label.leadingAnchor.constraint(equalTo: roundedRectangleView.leadingAnchor, constant: 16),
      label.topAnchor.constraint(equalTo: roundedRectangleView.topAnchor, constant: 26),
      label.trailingAnchor.constraint(equalTo: tempLabel.leadingAnchor, constant: -4)
    ])
  }
  
  private func setupTempLabel(_ label: UILabel) {
    label.text = "15°"
    label.font = .systemFont(ofSize: 40, weight: .regular)
    label.textColor = .systemBackground
    label.textAlignment = .right
    label.translatesAutoresizingMaskIntoConstraints = false
    
    contentView.addSubview(label)
    
    NSLayoutConstraint.activate([
      label.leadingAnchor.constraint(equalTo: roundedRectangleView.centerXAnchor, constant: 80),
      label.topAnchor.constraint(equalTo: roundedRectangleView.topAnchor, constant: 20),
      label.trailingAnchor.constraint(equalTo: roundedRectangleView.trailingAnchor, constant: -16),
    ])
  }
  
  private func setupWeahterDescpitionLabel(_ label: UILabel) {
    label.text = "Хмарно"
    label.font = .systemFont(ofSize: 13, weight: .regular)
    label.textColor = .systemBackground
    label.textAlignment = .right
    label.translatesAutoresizingMaskIntoConstraints = false
    
    contentView.addSubview(label)
    
    NSLayoutConstraint.activate([
      label.trailingAnchor.constraint(equalTo: roundedRectangleView.trailingAnchor, constant: -16),
      label.topAnchor.constraint(equalTo: tempLabel.bottomAnchor),
      label.leadingAnchor.constraint(equalTo: tempLabel.leadingAnchor, constant: 28),
    ])
  }
  
  func configure(coordinates: CityCoordinates) {
    self.coordinates = coordinates
    if coordinates.name.count >= 10 {
      cityLabel.font = .systemFont(ofSize: 32, weight: .regular)
      cityLabel.text = coordinates.name
    } else {
      cityLabel.text = coordinates.name
    }
    WebManager().fetchTempNow(for: coordinates) { result in
      if coordinates.lat == self.coordinates?.lat {
        DispatchQueue.main.async {
          switch result {
          case .success(let success):
            self.tempLabel.text = String(Int(success.main.temp.rounded())) + "°"
            self.feelsLikeTempLabel.text = String(success.main.feelsLike ?? 0) + "°"
            self.weahterDescpitionLabel.text = success.weather.first?.description
          case .failure(let failure):
            print(failure)
          }
        }
      }
    }
  }
}
