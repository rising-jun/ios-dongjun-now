//
//  OilMapView.swift
//  OliNeedJun
//
//  Created by 김동준 on 2021/12/26.
//

import Foundation
import NMapsMap
import SnapKit
import Then


class OilMapView: BaseView{
    let mapView = NMFNaverMapView().then{
        $0.showLocationButton = false
        $0.showZoomControls = false
        $0.mapView.minZoomLevel = 8.0
        $0.mapView.maxZoomLevel = 18.0
    }
    
    lazy var userLocationView = NMFLocationButton()
    
    let infoView = UIView().then{
        $0.backgroundColor = .white
    }
    
    let infoIcon = UIImageView().then{
        $0.contentMode = .scaleAspectFit
    }
    
    let starIcon = UIImageView().then{
        $0.image = UIImage(named: "star_image")
        $0.contentMode = .scaleAspectFit
    }
    
    let infoScore = UILabel().then{
        $0.textColor = .black
        $0.font = UIFont.boldSystemFont(ofSize: 20)
        $0.text = "0.0"
    }
    
    let infoName = UILabel().then{
        $0.textColor = .black
        $0.font = UIFont.boldSystemFont(ofSize: 28)
        $0.text = "주유소 이름"
    }
    
    let gasKindsLabel = UILabel().then{
        $0.text = "휘발유"
        $0.font = UIFont.systemFont(ofSize: 22)
        $0.textColor = .gray
        $0.textAlignment = .right
    }
    
    let gasPriceLabel = UILabel().then{
        $0.text = "1,000"
        $0.font = UIFont.boldSystemFont(ofSize: 30)
        $0.textColor = .black
        $0.textAlignment = .right
    }
    
    override func setup() {
        super.setup()
        
        addSubViews(mapView, userLocationView, infoView)
        
        userLocationView.mapView = mapView.mapView
        
        mapView.snp.remakeConstraints { make in
            make.height.width.equalTo(self)
        }
        
        infoView.snp.remakeConstraints { make in
            make.bottom.equalTo(self)
            make.height.equalTo(130)
            make.width.equalTo(self)
        }
        
        infoView.addSubViews(infoIcon, infoName, starIcon, infoScore, gasKindsLabel, gasPriceLabel)
        infoIcon.snp.remakeConstraints { make in
            make.top.equalTo(infoView.snp.top).offset(20)
            make.leading.equalTo(infoView).offset(25)
            make.width.height.equalTo(25)
        }
        
        infoName.snp.remakeConstraints { make in
            make.leading.equalTo(infoIcon.snp.trailing).offset(15)
            make.width.equalTo(240)
            make.height.equalTo(50)
            make.centerY.equalTo(infoIcon)
        }
        
        starIcon.snp.remakeConstraints { make in
            make.top.equalTo(infoName.snp.bottom).offset(5)
            make.leading.equalTo(infoView).offset(25)
            make.height.width.equalTo(15)
            
        }
        
        infoScore.snp.remakeConstraints { make in
            make.centerY.equalTo(starIcon.snp.centerY)
            make.height.equalTo(25)
            make.width.equalTo(40)
            make.leading.equalTo(starIcon.snp.trailing).offset(5)
        }
        
        gasKindsLabel.snp.remakeConstraints { make in
            make.trailing.equalTo(infoView.snp.trailing).offset(-15)
            make.top.equalTo(infoView.snp.top).offset(15)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        
        gasPriceLabel.snp.remakeConstraints { make in
            make.top.equalTo(gasKindsLabel.snp.bottom)
            make.centerX.equalTo(gasKindsLabel)
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
        
        userLocationView.snp.remakeConstraints { make in
            make.bottom.equalTo(infoView.snp.top).offset(10)
            make.trailing.equalTo(self)
            make.width.height.equalTo(80)
        }
        
        
        
        
    }

    func gasInfoViewMode(){
        
        infoView.snp.remakeConstraints { make in
            make.bottom.equalTo(self)
            make.height.equalTo(130)
            make.width.equalTo(self)
        }
        
        userLocationView.snp.remakeConstraints { make in
            make.bottom.equalTo(infoView.snp.top).offset(10)
            make.trailing.equalTo(self)
            make.width.height.equalTo(80)
        }
        
        
    }
    
    func mapViewMode(){
        
        infoView.snp.remakeConstraints { make in
            make.top.equalTo(self.snp.bottom)
            make.height.equalTo(130)
            make.width.equalToSuperview()
        }
        
        userLocationView.snp.remakeConstraints { make in
            make.bottom.equalTo(self.snp.bottom).offset(-25)
            make.trailing.equalToSuperview()
            make.width.height.equalTo(80)
        }
    }
    
}
