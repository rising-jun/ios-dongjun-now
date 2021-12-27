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
import NMapsMap
import RxGesture

class OilMapViewController: BaseViewController{
    
    
    lazy var v = OilMapView(frame: view.frame)
    
    private var permissionCheck: PermissionCheck!
    private var locationManager = CLLocationManager()
    private let overlayDelegate = CustomMapDelegatge()
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
                                           coorState: coordiSubject.filter{$0.latitude != 0.0}.asObservable().observe(on:MainScheduler.asyncInstance),
                                           userPosAction: v.userLocationView.rx.tap.asObservable())
    lazy var output = viewModel.bind(input: input)
    
    override func bindViewModel() {
        super.bindViewModel()
        
        v.userLocationView.rx.tap.bind { _ in
            print("hi")
        }.disposed(by: disposeBag)
        
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
                self.initMap(coor: self.locationManager.location!.coordinate)
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
        
        output.state?.map{$0.userLocationMode}
        .distinctUntilChanged()
        .drive(onNext: { [weak self] positionMode in
            guard let self = self else { return }
            print("position \(positionMode)")
            if positionMode == .direction{
                self.v.mapView.mapView.positionMode = .direction
            }else{
                self.v.mapView.mapView.positionMode = .compass
            }
        }).disposed(by: disposeBag)
        
        output.state?.map{$0.gsList ?? []}
        .filter{$0.count > 0}
        .drive(onNext: { [weak self] list in
            guard let self = self else { return }
            print("viewController gasStation Info \(list.count)")
            for i in list{
                let infoWindow = NMFInfoWindow()
                infoWindow.dataSource = self.overlayDelegate
                self.overlayDelegate.imageView.image = i.gasIcon
                self.overlayDelegate.priceLabel.text = i.price.withComma
                infoWindow.position = NMGLatLng(lat: i.lat, lng: i.long)
                infoWindow.globalZIndex = 20001
                infoWindow.open(with: self.v.mapView.mapView)
            }
            
        }).disposed(by: disposeBag)
        
        output.state?.map{$0.coordi}
        .drive(onNext: { [weak self] coordi in
            guard let self = self else { return }
            if let coor = coordi{
                
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
    
    func initMap(coor: CLLocationCoordinate2D){
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: coor.latitude ?? 0, lng: coor.longitude ?? 0))
        cameraUpdate.animation = .easeIn
        v.mapView.mapView.moveCamera(cameraUpdate)
        v.mapView.mapView.positionMode = .direction
        
        
    }
    
}

extension OilMapViewController: LocationPermissionCallback{
    func getPermission(status: CLAuthorizationStatus) {
        locStatusSubject.onNext(status)
    }
    
    func getPoint(coordinate: CLLocationCoordinate2D) {
        //print("getpoint!! \(coordinate.latitude)")
        coordiSubject.onNext(coordinate)
    }
    
    
}
