//
//  CollectionViewLayout.swift
//  MyWeather
//
//  Created by Illia Verezei on 22.12.2024.
//

import UIKit

class CollectionViewLayout: UICollectionViewFlowLayout {
  override init() {
    super.init()
    scrollDirection = .horizontal
    itemSize = CGSize(width: 70, height: 200)
    minimumLineSpacing = 0
    minimumInteritemSpacing = 50
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
