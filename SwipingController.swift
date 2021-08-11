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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Регаем ячейку
        collectionView?.backgroundColor = .white
        collectionView?.register(PageCell.self, forCellWithReuseIdentifier: Constants.cellId)
        
        // Разрешен ли скроллинг
        collectionView?.isPagingEnabled = true
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellId, for: indexPath)
        return cell
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
