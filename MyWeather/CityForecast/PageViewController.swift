//
//  PageViewController.swift
//  MyWeather
//
//  Created by Illia Verezei on 22.12.2024.
//

import UIKit

class PageViewController: UIPageViewController {
  
  private var pages: [CityViewController] = []
  private var currentPageIndex: Int = 0
  
  lazy private var moveToListButton = UIButton()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupMoveToListButton(moveToListButton)
    self.dataSource = self
    navigationController?.setNavigationBarHidden(true, animated: true)
  }
  
  func setupMoveToListButton(_ button: UIButton) {
    button.setImage(UIImage(systemName: "list.bullet"), for: .normal)
    button.contentVerticalAlignment = .fill
    button.contentHorizontalAlignment = .fill
    button.tintColor = .white
    button.addTarget(self, action: #selector(moveToList), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(button)
    
    NSLayoutConstraint.activate([
      button.widthAnchor.constraint(equalToConstant: 28),
      button.heightAnchor.constraint(equalToConstant: 16),
      button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
      button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
    ])
  }
  
  @objc private func moveToList() {
    navigationController?.popViewController(animated: true)
    navigationController?.setNavigationBarHidden(false, animated: true)
  }
  
  func transferCities(_ cities: [CityCoordinates], pageIndex: Int) {
    cities.forEach { city in
      let vc = CityViewController()
      vc.configure(city)
      pages.append(vc)
    }
    
    setInitialPage(index: pageIndex)
  }
  
  private func setInitialPage(index: Int) {
     guard index >= 0, index < pages.count else { return }
     currentPageIndex = index
     let initialPage = pages[index]
     setViewControllers([initialPage], direction: .forward, animated: false, completion: nil)
   }
}

extension PageViewController: UIPageViewControllerDataSource {
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let contentViewController = viewController as? CityViewController,
          let currentIndex = pages.firstIndex(of: contentViewController),
          currentIndex > 0 else { return nil }
    return pages[currentIndex - 1]
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let contentViewController = viewController as? CityViewController,
          let currentIndex = pages.firstIndex(of: contentViewController),
          currentIndex < pages.count - 1 else { return nil }
    return pages[currentIndex + 1]
  }
}
