//
//  NaverMapDelegate.swift
//  OliNeedJun
//
//  Created by 김동준 on 2021/12/28.
//

import Foundation
import NMapsMap
import RxSwift

class NaverMapDelegate: NSObject{
    var mapDidTap: PublishSubject<Void>!
    var clusterMode: PublishSubject<ClusterLevel>!
    private var cluster: ClusterLevel = .DetailGasStation
    
}

extension NaverMapDelegate: NMFMapViewTouchDelegate, NMFMapViewCameraDelegate{
    
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        mapDidTap.onNext(())
    
    }
    
    
    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
        if mapView.zoomLevel > 12{
            if cluster == .onlyIcon{
                cluster = .DetailGasStation
                clusterMode.onNext(cluster)
            }
        }else{
            if cluster == .DetailGasStation{
                cluster = .onlyIcon
                clusterMode.onNext(cluster)
            }
        }
    }
    
}
