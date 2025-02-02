//
//  PageViewController.swift
//  MyWeather
//
//  Created by Illia Verezei on 22.12.2024.
//

import UIKit

class PageViewController: UIPageViewController {
  
  private var presenter: CityForecastPresenter?
  private let pageControl = UIPageControl()
  private let moveToListButton = UIButton()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupMoveToListButton(moveToListButton)
    setupPageControl(pageControl)
    self.dataSource = self
    self.delegate = self
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
  
  func setupPageControl(_ control: UIPageControl) {
    control.isUserInteractionEnabled = false
    control.backgroundColor = .gray.withAlphaComponent(0.3)
    control.layer.cornerRadius = 12
    control.pageIndicatorTintColor = .lightGray
    control.currentPageIndicatorTintColor = .white
    control.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(control)
    
    NSLayoutConstraint.activate([
      pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
      pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
    ])
  }
  
  @objc private func moveToList() {
    presenter?.moveToRootView()
  }
  
  @objc private func change() {
    presenter?.changePage(newPageIndex: pageControl.currentPage)
  }
}

extension PageViewController: CityViewControlProtocol {
  
  func setPresenter(presenter: CityForecastPresenter) {
    self.presenter = presenter
  }
  
  func preparePageControl(initialPage: UIViewController?, numberOfPages: Int, currentPage: Int) {
    guard let initialPage = initialPage else { return }
    pageControl.numberOfPages = numberOfPages
    pageControl.currentPage = currentPage
    setViewControllers([initialPage], direction: .forward, animated: true)
  }
  
  func changeCurrentPage(pages: [UIViewController], direction: UIPageViewController.NavigationDirection ) {
    setViewControllers(pages, direction: direction, animated: true)
  }
}

extension PageViewController: UIPageViewControllerDataSource {
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    presenter?.showViewConrollerBefore(viewControllerBefore: viewController)
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    presenter?.showViewConrollerAfter(viewControllerAfter: viewController)
  }
}

extension PageViewController: UIPageViewControllerDelegate {
  func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    if completed, let visibleViewController = viewControllers?.first as? CityViewController, let index = presenter?.getPages().firstIndex(of: visibleViewController) {
      presenter?.changePageIndex(index: index)
      pageControl.currentPage = index
    }
  }
}
