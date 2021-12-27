//
//  OilMapViewModel.swift
//  OliNeedJun
//
//  Created by 김동준 on 2021/12/26.
//

import Foundation
import RxSwift
import RxCocoa
import CoreLocation


final class OilMapViewModel: ViewModelType{
    var input: Input?
    var output: Output?
    
    private let state = BehaviorRelay<OilMapState>(value: OilMapState())
    private let readGasStation = ReadGasStation()
    
    struct Input{
        let viewState: Observable<ViewState>?
        let locState: Observable<CLAuthorizationStatus>?
        let coorState: Observable<CLLocationCoordinate2D>?
        let userPosAction: Observable<Void>?
    }
    
    struct Output{
        var state: Driver<OilMapState>?
    }
    
    private let disposeBag = DisposeBag()
    private let gasStationList = PublishSubject<[GasStationInfo]>()
    
    func bind(input: Input) -> Output{
        self.input = input

        input.viewState?
            .filter{$0 == .viewDidLoad}
            .withLatestFrom(state){ [weak self] viewState, state -> OilMapState in
                
                var newState = state
                newState.viewLogic = .setUpView
                
                self!.readGasStation.gasListSubject = self!.gasStationList
                self!.readGasStation.makeGasStationList()
                
                return newState
            }.bind(to: self.state)
            .disposed(by: disposeBag)
        
        input.locState?
            .withLatestFrom(state){ locStatus, state -> OilMapState in
                var newState = state
                switch locStatus{
                case .authorizedAlways, .authorizedWhenInUse: // 권한 있음
                    newState.locationPermission = .gotPermission
                case .restricted, .notDetermined:
                    newState.locationPermission = .requestPermission // 아직 선택하지 않음
                case .denied:
                    newState.locationPermission = .presentSetting // 권한없음
                default:
                    newState.locationPermission = .none
                }
                return newState
            }
            .bind(to: self.state)
            .disposed(by: disposeBag)
        
        input.coorState?
            .withLatestFrom(state){ coor, state -> OilMapState in
                var newState = state
                newState.coordi = coor
                return newState
            }.bind(to: self.state)
            .disposed(by: disposeBag)
        
        input.userPosAction?
            .withLatestFrom(state)
            .map{ state in
                print("hi")
                var newState = state
                if newState.userLocationMode == .direction{
                    newState.userLocationMode = .compass
                }else{
                    newState.userLocationMode = .direction
                }
                return newState
            }
            .bind(to: self.state)
            .disposed(by: disposeBag)
        
        gasStationList
            .withLatestFrom(state){ list, state -> OilMapState in
                var newState = state
                newState.gsList = list
                return newState
            }.bind(to: self.state)
            .disposed(by: disposeBag)
        
        output = Output(state: state.asDriver())
        return output!
    }
    
    
}



struct OilMapState{
    var presentVC: PresentVC?
    var timeOver: Bool?
    var viewLogic: ViewLogic?
    var locationPermission: PermissionState?
    var coordi: CLLocationCoordinate2D?
    
    var userLocationMode: UserPositionMode? = .direction
    var gsList: [GasStationInfo] = []
}

enum PossibleCheck{
    case possible
    case impossible
}

enum UserPositionMode{
    case direction
    case compass
}
