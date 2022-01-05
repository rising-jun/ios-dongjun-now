//
//  InfoCollectionDelegate.swift
//  OliNeedJun
//
//  Created by 김동준 on 2022/01/04.
//

import Foundation
import UIKit
import RxSwift

class InfoCollectionDelegate: NSObject{
    var gasStationList: [GasStationInfo] = []
    var infoPage: PublishSubject<Int>!
}
extension InfoCollectionDelegate: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("hi  \(gasStationList.count) ^^")
        return gasStationList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InfoViewCell", for: indexPath) as! InfoViewCell
        var info = gasStationList[indexPath.row]
        cell.gasPriceLabel.text = info.price.withComma
        cell.infoIcon.image = info.gasIcon
        cell.infoName.text = info.name
        cell.infoScore.text = "\(info.score)"
        cell.awakeFromNib()
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let w = scrollView.bounds.size.width
        let currentPage = Int(ceil(x/w))
        
        infoPage.onNext(currentPage)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.bounds
        return CGSize(width: size.width, height: size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}


