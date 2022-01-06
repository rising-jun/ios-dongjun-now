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
    
    var infoCV: UICollectionView!
    
    override func setup() {
        super.setup()
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        infoCV = UICollectionView(frame: .zero, collectionViewLayout: layout)
        addSubViews(mapView, userLocationView, infoCV)
        
        userLocationView.mapView = mapView.mapView
        
        mapView.snp.remakeConstraints { make in
            make.height.width.equalTo(self)
        }
        
        infoCV.backgroundColor = .white
        infoCV.isPagingEnabled = true
        infoCV.snp.makeConstraints { make in
            make.bottom.equalTo(self)
            make.height.equalTo(130)
            make.width.equalTo(self)
        }
        
        userLocationView.snp.remakeConstraints { make in
            make.bottom.equalTo(infoCV.snp.top).offset(10)
            make.trailing.equalTo(self)
            make.width.height.equalTo(80)
        }
        
        
        
        
    }

    func gasInfoViewMode(){
        
        infoCV.snp.remakeConstraints { make in
            make.bottom.equalTo(self)
            make.height.equalTo(140)
            make.width.equalTo(self)
        }
        
        userLocationView.snp.remakeConstraints { make in
            make.bottom.equalTo(infoCV.snp.top).offset(10)
            make.trailing.equalTo(self)
            make.width.height.equalTo(80)
        }
        
        
    }
    
    func mapViewMode(){
        
        infoCV.snp.remakeConstraints { make in
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
