//
//  Maps.swift
//  MyWeather
//
//  Created by Illia Verezei on 25.12.2024.
//

import UIKit
import MapKit

class Maps: UIView {
  var mapView: MKMapView!
  
  init() {
    super.init(frame: .zero)
    
    // Ініціалізація MapView
    mapView = MKMapView(frame: frame)
    addSubview(mapView)
    
    // Центрування карти
    let coordinate = CLLocationCoordinate2D(latitude: 50.4501, longitude: 30.5234) // Київ
    let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000000, longitudinalMeters: 1000000)
    mapView.setRegion(region, animated: true)
    
    // Додавання тайлів OpenWeather
    if let template = "https://tile.openweathermap.org/map/temp_new/1/0/1.png?appid=5d1d2171badb0afc3302079f35efb3e6".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
      let overlay = MKTileOverlay(urlTemplate: template)
      overlay.canReplaceMapContent = false // Накладення поверх карти
      mapView.addOverlay(overlay)
    }
    
    // Налаштування рендера для тайлів
    mapView.delegate = self
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension Maps: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    if let tileOverlay = overlay as? MKTileOverlay {
      return MKTileOverlayRenderer(tileOverlay: tileOverlay)
    }
    return MKOverlayRenderer(overlay: overlay)
  }
}
