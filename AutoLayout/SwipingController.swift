//
//  SwipingController.swift
//  AutoLayout
//
//  Created by Effrafax Bulwer on 8/6/21.
//  Copyright © 2021 Effrafax Bulwer. All rights reserved.
//

import UIKit

private enum Constants {
    static let cellId = "cellId"
}

class SwipingController: UICollectionViewController {
 
// MARK: UI
    
    // Сделали такую структуру для поддержания MVC
    let pages = [
        Page(imageName: "bear_first", headerText: "Join use today in our fun and games!", bodyText: "Are you ready for loads and loads of fun? Don't wait any longer! We hope to see you in our stores soon."),
        Page(imageName: "heart_second", headerText: "Subscribe and get coupons on our daily events", bodyText: "Get notified of the savings immediately when we announce them on our website. Make sure to also give us any feedback you have."),
        Page(imageName: "leaf_third", headerText: "VIP members special services", bodyText: ""),
        Page(imageName: "bear_first", headerText: "Join use today in our fun and games!", bodyText: "Are you ready for loads and loads of fun? Don't wait any longer! We hope to see you in our stores soon."),
        Page(imageName: "heart_second", headerText: "Subscribe and get coupons on our daily events", bodyText: "Get notified of the savings immediately when we announce them on our website. Make sure to also give us any feedback you have."),
        Page(imageName: "leaf_third", headerText: "VIP members special services", bodyText: "")
    ]
 
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("NEXT", for: .normal)
        button.setTitleColor(.mainPink, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        return button
    }()
    
    @objc private func handleNext() {
        
        // min возвращает меньшее из двух входных значений
        let nextIndex = min(pageControl.currentPage + 1, pages.count - 1)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        pageControl.currentPage = nextIndex
        
        // Прокручивает содержимое коллекции, пока не станет виден указанный элемент
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    private let prevButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("PREV", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(habldePrev), for: .touchUpInside)
        return button
    }()
    
    @objc private func habldePrev() {
        let nextIndex = max(pageControl.currentPage - 1, 0)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        pageControl.currentPage = nextIndex
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    // Делаем lazy для использования pages.count
    private lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        
        // Динамически высчитывает кол-во страниц
        pc.numberOfPages = pages.count
        pc.pageIndicatorTintColor = UIColor(red: 249/255, green: 207/255, blue: 224/255, alpha: 1)
        pc.currentPageIndicatorTintColor = .mainPink
        return pc
    }()
    

// MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBottomControls()
        
        // Регаем ячейку
        collectionView?.backgroundColor = .white
        collectionView?.register(PageCell.self, forCellWithReuseIdentifier: Constants.cellId)
        
        // Разрешен ли скроллинг
        collectionView?.isPagingEnabled = true
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellId, for: indexPath) as! PageCell
        
        cell.page = pages[indexPath.item]
        
        return cell
    }
    
    fileprivate func setupBottomControls() {
        let bottomStackView = UIStackView(arrangedSubviews: [prevButton, pageControl, nextButton])
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.distribution = .fillEqually
        bottomStackView.axis = .horizontal
        view.addSubview(bottomStackView)
        
        NSLayoutConstraint.activate([
            bottomStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bottomStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bottomStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomStackView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

extension SwipingController: UICollectionViewDelegateFlowLayout {
    
    // Запрашивает у делегата размер ячейки указанного элемента
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    // Минимальное расстояние между строками или столбцами в секции
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK: Scroll Delegate

extension SwipingController {
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        // x показывает ОБЩЕЕ смещение при прокрутке по оси "x" относительно САМОГО НАЧАЛА (с 1 стр)
        let x = targetContentOffset.pointee.x
        
        // Данная логика позволит нам высчитать номер текущей страницы
        // Общее смещение по x поделенное на ширину экрана
        let currentPage = Int(x / view.frame.width)
        
        pageControl.currentPage = currentPage
    }
}
