//
//  SplashView.swift
//  OliNeedJun
//
//  Created by 김동준 on 2021/12/26.
//

import Foundation
import UIKit
import Then
import SnapKit

class SplashView: BaseView{
    
    let nameLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = .white
        $0.font = UIFont.boldSystemFont(ofSize: 28)
        $0.text = "오일나우"
    }
    
    let iconImage = UIImageView().then{
        let image = UIImage(named: "oilnow")
        $0.image = image
        $0.contentMode = .scaleAspectFit
    }
    
    override func setup() {
        super.setup()
        backgroundColor = UIColor(red: 75/255, green: 118/255, blue: 186/255, alpha: 1)
        addSubViews(iconImage, nameLabel)
        
        iconImage.backgroundColor = .yellow
        iconImage.snp.makeConstraints { make in
            make.center.equalTo(self)
            make.height.width.equalTo(80)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImage.snp.bottom)
            make.centerX.equalTo(self)
        }
    }
}
//rgb(75, 118, 186)
