//
//  ReadGasStation.swift
//  OliNeedJun
//
//  Created by 김동준 on 2021/12/27.
//

import Foundation
import RxSwift

class ReadGasStation{
    // katec좌표구하기, https://www.opinet.co.kr/api/aroundAll.do?code=&x=375335.4&y=127146&radius=5000&sort=2&prodcd=B027&out=json
    
    var gasListSubject: PublishSubject<[GasStationInfo]>!
    
    func makeGasStationList(){
        var list: [GasStationInfo] = []
        var locList: [[Double]] = [[37.533429, 127.141159],[37.536452, 127.149333],[37.540382, 127.140599],[37.532318, 127.133420],[37.541461, 127.124048],[37.533031, 127.121943],[37.531136, 127.120954]]
        for i in 0 ..< 7{
            var gsInfo = GasStationInfo()
            gsInfo.price = Int.random(in: 1600 ..< 1801)
            gsInfo.name = "제\(i)주유소"
            gsInfo.score = Double.random(in: 3.0 ..< 5.0)
            gsInfo.score *= 10
            gsInfo.score = round(gsInfo.score)
            gsInfo.score /= 10
            gsInfo.lat = locList[i][0]
            gsInfo.long = locList[i][1]
            if(i % 3 == 0){
                gsInfo.gasIcon = UIImage(named: "gs_image")
            }else if(i % 3 == 1){
                gsInfo.gasIcon = UIImage(named: "hd_image")
            }else{
                gsInfo.gasIcon = UIImage(named: "sk_image")
            }
            
            list.append(gsInfo)
        }
        gasListSubject.onNext(list)
    }
    
}
