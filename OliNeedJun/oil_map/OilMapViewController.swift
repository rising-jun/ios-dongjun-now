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
import SnapKit

class OilMapViewController: BaseViewController{
    
    
    lazy var v = OilMapView(frame: view.frame)
    
    private var permissionCheck: PermissionCheck!
    private var locationManager = CLLocationManager()
    private let overlayDataSource = CustomOverlayDataSource()
    private let infoCVDelegate = InfoCollectionDelegate()
    private let mapDelegate = NaverMapDelegate()
    private var gasStationList: [GasStationInfo] = []
    private var detailMarkerArr: [NMFMarker] = []
    private var iconMarkerArr: [NMFMarker] = []
    
    
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
    private let markerTouched = BehaviorSubject<Int>(value: -1)
    private let mapTouched = PublishSubject<Void>()
    private let clusterMode = PublishSubject<ClusterLevel>()
    private let infoPage = PublishSubject<Int>()
    
    lazy var viewModel = OilMapViewModel()
    lazy var input = OilMapViewModel.Input(viewState: rx.viewDidLoad.map{ViewState.viewDidLoad},
                                           locState: locStatusSubject.distinctUntilChanged().asObservable().observe(on:MainScheduler.asyncInstance),
                                           coorState: coordiSubject.filter{$0.latitude != 0.0}.asObservable().observe(on:MainScheduler.asyncInstance),
                                           userPosAction: v.userLocationView.rx.tap.asObservable(),
                                           touchedGasStation: markerTouched.asObserver(),
                                           mapTouched: mapTouched.asObservable(),
                                           clusterMode: clusterMode.distinctUntilChanged().asObservable(),
                                           infoPageInput: infoPage.distinctUntilChanged().asObservable().observe(on: MainScheduler.asyncInstance))
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
                if let loc = self.locationManager.location{
                    self.initMap(coor: loc.coordinate)
                }
                
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
            self.gasStationList = list
            self.setGasStations()
            self.infoCVDelegate.gasStationList = list
            self.v.infoCV.register(InfoViewCell.self, forCellWithReuseIdentifier: "InfoViewCell")
            self.v.infoCV.delegate = self.infoCVDelegate
            self.v.infoCV.dataSource = self.infoCVDelegate
            self.infoCVDelegate.infoPage = self.infoPage
            self.v.infoCV.reloadData()
        }).disposed(by: disposeBag)
        
        output.state?.map{$0.gsTouchedIndex ?? -1}
        .filter{$0 > -1}
        .distinctUntilChanged()
        .drive(onNext: { [weak self] index in
            guard let self = self else { return }
            self.infoPage.onNext(index)
            self.v.infoCV.scrollToItem(at: IndexPath(row: index, section: 0), at: .bottom, animated: true)
            self.v.layoutIfNeeded()
        }).disposed(by: disposeBag)
        
        output.state?.map{$0.mapViewMode}
        .drive(onNext: { [weak self] mode in
            guard let self = self else { return }
            if mode == .viewGasStation{
                UIView.animate(withDuration: 0.3) { [weak self] in
                    guard let self = self else { return }
                    self.v.gasInfoViewMode()
                    self.view.layoutIfNeeded()
                }
            }else if mode == .viewMap{
                UIView.animate(withDuration: 0.3) { [weak self] in
                    guard let self = self else { return }
                    self.v.mapViewMode()
                    self.view.layoutIfNeeded()
                    
                }
            }
        }).disposed(by: disposeBag)
        
        output.state?.map{$0.coordi}
        .drive(onNext: { [weak self] coordi in
            guard let self = self else { return }
            if let coor = coordi{
                
            }
            
        }).disposed(by: disposeBag)
        
        output.state?.map{$0.clusterMode}
        .drive(onNext: { [weak self] clusterMode in
            guard let self = self else { return }
            if clusterMode == .DetailGasStation{
                self.showDetailMarker()
                self.hideIconMarker()
            }else if clusterMode == .onlyIcon{
                self.showIconMarker()
                self.hideDetailMarker()
            }
        })
        
        output.state?.map{$0.pageInfo}.filter{$0 > -1}
        .distinctUntilChanged()
        .drive(onNext: { [weak self] page in
            guard let self = self else { return }
            self.setGasStationCamera(index: page)
            self.v.infoCV.scrollToItem(at: IndexPath(row: page, section: 0), at: .bottom, animated: true)
        }).disposed(by: disposeBag)
        
    }
    
    
    
}

extension OilMapViewController{
    func setUpView(){
        view = v
        locationManager.delegate = permissionCheck
        permissionCheck.getLocationPermission()
        v.mapView.mapView.touchDelegate = mapDelegate
        v.mapView.mapView.addCameraDelegate(delegate: mapDelegate)
        mapDelegate.mapDidTap = mapTouched
        mapDelegate.clusterMode = clusterMode
        
    }
    
    func initMap(coor: CLLocationCoordinate2D){
        
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: coor.latitude ?? 0, lng: coor.longitude ?? 0))
        cameraUpdate.animation = .easeIn
        v.mapView.mapView.moveCamera(cameraUpdate)
    }
    
    
    func setGasStations(){
        var markImage = GasStationMarker()
        for i in 0 ..< gasStationList.count{
            let info = gasStationList[i]
            var marker = NMFMarker()
            markImage.markerKind = .DetailGasStation
            marker.position = NMGLatLng(lat: info.lat, lng: info.long)
            marker.mapView = v.mapView.mapView
            markImage.setDatas(image: info.gasIcon, text: info.price.withComma)
            marker.iconImage = NMFOverlayImage(image: markImage.makeMarker())
            marker.touchHandler = { [weak self] (overlay: NMFOverlay) -> Bool in
                self?.markerTouched.onNext(i)
                return true
            };
            detailMarkerArr.append(marker)
        }
        
        var markIcon = GasStationMarker()
        for i in 0 ..< gasStationList.count{
            let info = gasStationList[i]
            var marker = NMFMarker()
            markIcon.markerKind = .onlyIcon
            marker.position = NMGLatLng(lat: info.lat, lng: info.long)
            marker.mapView = v.mapView.mapView
            markIcon.setDatas(image: info.gasIcon, text: info.price.withComma)
            marker.iconImage = NMFOverlayImage(image: markIcon.makeMarker())
            marker.touchHandler = { [weak self] (overlay: NMFOverlay) -> Bool in
                self?.markerTouched.onNext(i)
                return true
            };
            iconMarkerArr.append(marker)
        }
        
        if gasStationList.count > 0{
            print("checking")
            setGasStationCamera(index: 0)
        }
        
    }
    
    
    func setGasStationCamera(index: Int){
        print("index selected \(index)")
        let info: GasStationInfo = gasStationList[index]
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: info.lat ?? 0, lng: info.long ?? 0))
        cameraUpdate.animation = .easeIn
        v.mapView.mapView.moveCamera(cameraUpdate)
    }
    
    func hideDetailMarker(){
        for marker in detailMarkerArr{
            marker.hidden = true
        }
    }
    
    func hideIconMarker(){
        for marker in iconMarkerArr{
            marker.hidden = true
        }
    }
    
    func showDetailMarker(){
        for marker in detailMarkerArr{
            marker.hidden = false
        }
    }
    
    func showIconMarker(){
        for marker in iconMarkerArr{
            marker.hidden = false
        }
    }
    
    
}

extension OilMapViewController: LocationPermissionCallback{
    func getPermission(status: CLAuthorizationStatus) {
        locStatusSubject.onNext(status)
    }
    
    func getPoint(coordinate: CLLocationCoordinate2D) {
        
    }
    
    
}
