//
//  SearchTitleView.swift
//  MyWeather
//
//  Created by Illia Verezei on 18.11.2024.
//

import UIKit

class SearchTitleView: UIView {
  
  lazy private var titleLabel = UILabel()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupTitleLabel(titleLabel)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupTitleLabel(_ label: UILabel) {
    label.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
    label.center = center
    label.text = "searchVC_title".localized
    label.font = .preferredFont(forTextStyle: .headline)
    label.textColor = .black
    label.textAlignment = .center
    addSubview(label)
  }
}
