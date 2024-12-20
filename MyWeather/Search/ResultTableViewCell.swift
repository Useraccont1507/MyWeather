//
//  SearchResultTableCellTableViewCell.swift
//  MyWeather
//
//  Created by Illia Verezei on 19.11.2024.
//

import UIKit

class ResultTableViewCell: UITableViewCell {
  
  lazy private var mainLabel = UILabel()
  lazy private var secondaryLabel = UILabel()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupMainLabel(mainLabel)
    setupSecondaryLabel(secondaryLabel)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupMainLabel(_ label: UILabel) {
    label.font = .systemFont(ofSize: 17, weight: .regular)
    label.textColor = .black
    label.textAlignment = .left
    label.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(label)
    
    NSLayoutConstraint.activate([
      label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
      label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
    ])
  }
  
  private func setupSecondaryLabel(_ label: UILabel) {
    label.font = .systemFont(ofSize: 13, weight: .regular)
    label.textColor = .black
    label.textAlignment = .left
    label.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(label)
    
    NSLayoutConstraint.activate([
      label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      label.topAnchor.constraint(equalTo: mainLabel.bottomAnchor),
      label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
    ])
  }
  
  func configureLabels(mainText: String, secondaryText: String) {
    self.mainLabel.text = mainText
    self.secondaryLabel.text = secondaryText
  }
}
