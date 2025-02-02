//
//  VisibilityView.swift
//  MyWeather
//
//  Created by Illia Verezei on 25.12.2024.
//

import UIKit

class VisibilityView: UIView {
  
  lazy private var imageView = UIImageView()
  lazy private var headerLabel = UILabel()
  lazy private var separatorView = UIView()
  lazy private var visibilityLabel = UILabel()
  lazy private var arrowView = UIImageView()
  
  init() {
    super.init(frame: .zero)
    setupImageView(imageView)
    setupHeaderLabel(headerLabel)
    setupSeparatorView(separatorView)
    setupVisibilityLabel(visibilityLabel)
    setupArrowView(arrowView)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupImageView(_ imageView: UIImageView) {
    imageView.image = UIImage(systemName: "water.waves")
    imageView.tintColor = .white
    imageView.contentMode = .scaleAspectFill
    imageView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(imageView)
    
    NSLayoutConstraint.activate([
      imageView.widthAnchor.constraint(equalToConstant: 20),
      imageView.heightAnchor.constraint(equalToConstant: 20),
      imageView.topAnchor.constraint(equalTo: topAnchor),
      imageView.leadingAnchor.constraint(equalTo: leadingAnchor)
    ])
  }
  
  private func setupHeaderLabel(_ label: UILabel) {
    label.text = "visibility".localized
    label.textColor = .white
    label.font = .systemFont(ofSize: 22, weight: .regular)
    label.textAlignment = .left
    label.translatesAutoresizingMaskIntoConstraints = false
    addSubview(label)
    
    NSLayoutConstraint.activate([
      label.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
      label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8)
    ])
  }
  
  private func setupSeparatorView(_ separator: UIView) {
    separator.backgroundColor = .white
    separator.translatesAutoresizingMaskIntoConstraints = false
    addSubview(separator)
    
    NSLayoutConstraint.activate([
      separator.leadingAnchor.constraint(equalTo: leadingAnchor),
      separator.trailingAnchor.constraint(equalTo: trailingAnchor),
      separator.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
      separator.heightAnchor.constraint(equalToConstant: 2)
    ])
  }
  
  private func setupVisibilityLabel(_ label: UILabel) {
    label.textColor = .white
    label.font = .systemFont(ofSize: 18, weight: .medium)
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    addSubview(label)
    
    NSLayoutConstraint.activate([
      label.centerXAnchor.constraint(equalTo: centerXAnchor),
      label.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 16)
    ])
  }
  
  private func setupArrowView(_ imageView: UIImageView) {
    let thinConfiguration = UIImage.SymbolConfiguration(weight: .ultraLight)
    imageView.image = UIImage(systemName: "arrow.right", withConfiguration: thinConfiguration)
    imageView.tintColor = .white
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(imageView)
    
    NSLayoutConstraint.activate([
      imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
      imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
      imageView.topAnchor.constraint(equalTo: visibilityLabel.bottomAnchor, constant: -8),
      imageView.heightAnchor.constraint(equalToConstant: 44)
    ])
  }
  
  func configure(visibility: Int) {
    self.visibilityLabel.text = String(Int((Double(visibility) / 1000.0).rounded())) + " " + "km".localized
  }
}
