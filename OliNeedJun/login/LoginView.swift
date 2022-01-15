//
//  LoginView.swift
//  OliNeedJun
//
//  Created by 김동준 on 2022/01/08.
//

import Foundation
import UIKit
import Then
import SnapKit

class LoginView: BaseView{
    
    let introLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = .black
        $0.font = UIFont.boldSystemFont(ofSize: 28)
        $0.text = "한달 기름값\n 얼마나 사용하시나요?"
        $0.numberOfLines = 2
        $0.sizeToFit()
    }
    
    let priceLabel = UILabel().then{
        $0.textAlignment = .center
        $0.textColor = CustomColor.oilBlue()
        $0.font = UIFont.boldSystemFont(ofSize: 28)
        $0.text = "5만원"
        $0.sizeToFit()
    }
    
    let oilPriceSlider = UISlider().then{
        $0.backgroundColor = .white
        $0.maximumValue = 100
        $0.minimumValue = 0
        $0.thumbTintColor = CustomColor.oilBlue()
        $0.tintColor = CustomColor.oilBlue()
        
        
    }
    
    let makePriceLabel = UILabel().then{
        $0.textAlignment = .center
        $0.textColor = CustomColor.oilBlue()
        $0.font = UIFont.boldSystemFont(ofSize: 42)
        $0.sizeToFit()
        $0.isHidden = true
        $0.alpha = 0.0
        
        $0.text = "10만원"
    }
    
    let blueView = UIView().then{
        $0.backgroundColor = CustomColor.oilBlue()
        $0.layer.cornerRadius = 25
    }

    let loginBtn = UIButton().then{
        $0.backgroundColor = .systemYellow
        $0.layer.cornerRadius = 15
        $0.setTitle("카카오로 로그인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
    }
    
    
    override func setup() {
        super.setup()
        backgroundColor = .white
        addSubViews(introLabel, priceLabel, oilPriceSlider, makePriceLabel, blueView)
        
        introLabel.backgroundColor = .white
        introLabel.snp.makeConstraints { make in
            make.bottom.equalTo(self.snp.centerY)
            make.centerX.equalTo(self.snp.centerX)
            make.width.equalTo(300)
            make.height.equalTo(100)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(introLabel.snp.bottom).offset(20)
            make.centerX.equalTo(self.snp.centerX)
            make.width.equalTo(300)
            make.height.equalTo(50)
        }
        
        oilPriceSlider.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(20)
            make.trailing.equalTo(self).offset(-50)
            make.left.equalTo(self).offset(50)
            make.height.equalTo(40)
        }
        
        makePriceLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom)
            make.centerX.equalTo(self)
            make.width.equalTo(300)
            make.height.equalTo(70)
        }
    
        blueView.snp.makeConstraints { make in
            make.top.equalTo(oilPriceSlider.snp.bottom).offset(20)
            make.bottom.equalTo(self.snp.bottom)
            make.width.equalTo(self)
        }
        
        blueView.addSubview(loginBtn)
        loginBtn.snp.makeConstraints { make in
            make.top.equalTo(blueView.snp.top).offset(40)
            make.leading.equalTo(self.snp.leading).offset(30)
            make.trailing.equalTo(self.snp.trailing).offset(-30)
            make.height.equalTo(50)
        }
        
        
    }
    
}

extension LoginView{
    func showMakePrice(){
        oilPriceSlider.isHidden = true
        priceLabel.textColor = .systemGray
        makePriceLabel.isHidden = false
        introLabel.alpha = 1.0
        introLabel.text = "이만큼까지 줄여드릴게요!"
    }
    
}
//rgb(75, 118, 186)
