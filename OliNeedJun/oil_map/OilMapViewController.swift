//
//  OilMapViewController.swift
//  OliNeedJun
//
//  Created by 김동준 on 2021/12/26.
//

import Foundation
import RxSwift
import RxCocoa
import CoreLocation
import RxViewController

class OilMapViewController: BaseViewController{
    
    
    lazy var v = OilMapView(frame: view.frame)
    
    private var permissionCheck: PermissionCheck!
    private var locationManager = CLLocationManager()
    
    override func setup() {
        super.setup()
        permissionCheck = PermissionCheck(locationCb: self)
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private let disposeBag = DisposeBag()
    
    private let locStatusSubject = BehaviorSubject<CLAuthorizationStatus>(value: .notDetermined)
    private let coordiSubject = BehaviorSubject<CLLocationCoordinate2D>(value: CLLocationCoordinate2D())
    
    lazy var viewModel = OilMapViewModel()
    lazy var input = OilMapViewModel.Input(viewState: rx.viewDidLoad.map{ViewState.viewDidLoad},
                                           locState: locStatusSubject.distinctUntilChanged().asObservable().observe(on:MainScheduler.asyncInstance),
                                           coorState: coordiSubject.filter{$0.latitude != 0.0}.asObservable().observe(on:MainScheduler.asyncInstance))
    lazy var output = viewModel.bind(input: input)
    
    override func bindViewModel() {
        super.bindViewModel()
        
        output.state?.map{$0.viewLogic}
            .filter{$0 == .setUpView}
            .distinctUntilChanged()
            .drive(onNext: { [weak self] logic in
            self?.setUpView()
        }).disposed(by: disposeBag)
     
        output.state?.map{$0.locationPermission ?? .none}
        .filter{$0 != .none}
        .distinctUntilChanged()
        .drive(onNext: { [weak self] status in
            guard let self = self else { return }
            switch status{
            case .gotPermission:
                // map to marking my location
                print(" already have permission ")
                self.locationManager.startUpdatingLocation()
                break
            case .requestPermission:
                self.locationManager.requestWhenInUseAuthorization()
                print(" request to get permission")
                // request Permission
                break
            case .presentSetting:
                // present to setting app
                break
            case .none:
                // nothing to do
                break
            }
        }).disposed(by: disposeBag)
        
        output.state?.map{$0.coordi}
        .drive(onNext: { [weak self] coordi in
            guard let self = self else { return }
            if let coor = coordi{
                // map init 
                
            }
        }).disposed(by: disposeBag)
        
        
    }
    
    
}

extension OilMapViewController{
    func setUpView(){
        view = v
        locationManager.delegate = permissionCheck
        permissionCheck.getLocationPermission()
    }
}

extension OilMapViewController: LocationPermissionCallback{
    func getPermission(status: CLAuthorizationStatus) {
        locStatusSubject.onNext(status)
    }
    
    func getPoint(coordinate: CLLocationCoordinate2D) {
        print("getpoint!! \(coordinate.latitude)")
        coordiSubject.onNext(coordinate)
    }
    
    
}
