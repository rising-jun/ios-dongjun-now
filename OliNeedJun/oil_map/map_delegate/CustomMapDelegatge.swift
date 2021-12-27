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

class CustomMapDelegatge: NSObject{
    let imageView = UIImageView()
    let priceLabel = UILabel()
}

extension CustomMapDelegatge: NMFOverlayImageDataSource{
    
    
    func view(with overlay: NMFOverlay) -> UIView {
        var v = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: 30))
        v.addSubViews(imageView, priceLabel)
        v.backgroundColor = .white
        v.alpha = 0.9
        v.layer.cornerRadius = 3
        imageView.frame = CGRect(x: 5, y: 5, width: 20, height: 20)
        imageView.contentMode = .scaleAspectFit
        
        priceLabel.frame = CGRect(x: 30, y: 5, width: 40, height: 20)
        priceLabel.textColor = .black
        priceLabel.font = UIFont.boldSystemFont(ofSize: 12)
        
        print("called \(priceLabel.frame)")
        return v
    }
    
    
    
    
    
    
}
