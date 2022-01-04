//
//  GasStationMarker.swift
//  OliNeedJun
//
//  Created by 김동준 on 2022/01/01.
//

import Foundation
import UIKit
import NMapsMap
import SnapKit

class GasStationMarker{
    
    lazy var markView = UIView()
    let imageView = UIImageView()
    let priceLabel = UILabel()
    var clusterLevel: ClusterLevel = .DetailGasStation
    var selected: Bool = false
    var markerKind: ClusterLevel = .DetailGasStation
    
    
    func makeMarker() -> UIImage {
        markView.backgroundColor = .white
        markView.alpha = 0.9
        
        if markerKind == .DetailGasStation{
        markView.frame = CGRect(x: 0, y: 0, width: 70, height: 30)
        markView.addSubViews(imageView, priceLabel)
        
        markView.layer.cornerRadius = 3
        imageView.contentMode = .scaleAspectFit
        priceLabel.textColor = .black
        priceLabel.font = UIFont.boldSystemFont(ofSize: 12)

        
        imageView.backgroundColor = .white
        imageView.frame = CGRect(x: 5, y: 5, width: 20, height: 20)
        priceLabel.frame = CGRect(x: 30, y: 5, width: 40, height: 20)
        }else if markerKind == .onlyIcon{
            markView.frame =  CGRect(x: 0, y: 0, width: 30, height: 30)
            markView.addSubViews(imageView)
            imageView.frame = CGRect(x: 5, y: 5, width: 20, height: 20)
            imageView.contentMode = .scaleAspectFit
            markView.layer.cornerRadius = 20
        }
        return markView.asImage()
    }
    
    func setDatas(image: UIImage, text: String){
        self.imageView.image = image
        self.priceLabel.text = text
    }
    
}
