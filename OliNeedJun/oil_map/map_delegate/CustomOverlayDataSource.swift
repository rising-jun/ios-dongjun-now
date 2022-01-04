//
//  UserMarker.swift
//  OliNeedJun
//
//  Created by 김동준 on 2021/12/26.
//

import Foundation
import UIKit
import NMapsMap
import SnapKit

class CustomOverlayDataSource: NSObject{
    let imageView = UIImageView()
    let priceLabel = UILabel()
    var clusterLevel: ClusterLevel = .DetailGasStation
    var markerKind: ClusterLevel = .DetailGasStation
    var selected: Bool = false
}

extension CustomOverlayDataSource: NMFOverlayImageDataSource{
    
    
    func view(with overlay: NMFOverlay) -> UIView {
        
        if markerKind == .DetailGasStation{
            var v = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: 30))
            v.addSubViews(imageView, priceLabel)
            
            v.alpha = 0.9
            v.layer.cornerRadius = 3
            imageView.frame = CGRect(x: 5, y: 5, width: 20, height: 20)
            imageView.contentMode = .scaleAspectFit
            priceLabel.frame = CGRect(x: 30, y: 5, width: 40, height: 20)
            priceLabel.textColor = .black
            priceLabel.font = UIFont.boldSystemFont(ofSize: 12)
            
            if selected == true{
                v.backgroundColor = .systemBlue
            }else{
                v.backgroundColor = .white
            }
            
            return v
        }else if markerKind == .onlyIcon{
            var v = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            v.addSubViews(imageView)
            imageView.frame = CGRect(x: 5, y: 5, width: 20, height: 20)
            imageView.contentMode = .scaleAspectFit
        }
        
        return UIView()
        
    }
    
    
    
    
    
    
}


