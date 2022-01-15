//
//  MenuCollectionData.swift
//  OliNeedJun
//
//  Created by 김동준 on 2022/01/15.
//

import Foundation
import UIKit


class MenuCollectionDelegate: NSObject{
    var menuTitleArr: [String] = ["맵", "유가동향", "기름가계부"]
    var menuSubTitleArr: [String] = ["주변주유소를 찾고\n가격을 비교해보세요!", "유가동향을 한눈에 보여드릴게요!", "기름값을 더 아껴보아요!"]
}

extension MenuCollectionDelegate: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("hi  \(menuTitleArr.count) ^^")
        return menuTitleArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuViewCell", for: indexPath) as! MenuViewCell
        cell.infoLabel.text = menuTitleArr[indexPath.row]
        cell.subLabel.text = menuSubTitleArr[indexPath.row]
        cell.awakeFromNib()
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.bounds
        return CGSize(width: 150, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}


