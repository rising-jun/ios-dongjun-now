//
//  HomeViewController.swift
//  OliNeedJun
//
//  Created by 김동준 on 2022/01/15.
//

import Foundation
import UIKit
import RxSwift
import RxViewController
import RxCocoa

class HomeViewController: BaseViewController{
    
    lazy var v = HomeView(frame: view.frame)
    lazy var vcArray: [PresentVC: BaseViewController] = [.oilMap: OilMapViewController()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private let disposeBag = DisposeBag()
    private let viewModel = HomeViewModel()
    private lazy var input = HomeViewModel.Input(viewState: self.rx.viewDidLoad.map{ViewState.viewDidLoad}.asObservable(),
                                                 touchedPushScreen: touchPublish.distinctUntilChanged().asObservable())
    private lazy var output = viewModel.bind(input: input)
    private let touchPublish = PublishSubject<PresentVC>()
    private let menuDelegate = MenuCollectionDelegate()
    
    override func bindViewModel() {
        super.bindViewModel()
        
        output.state?.map{$0.viewLogic}
        .distinctUntilChanged()
        .filter{$0 == .setUpView}
        .drive(onNext: { [weak self] logic in
            guard let self = self else { return }
            self.setUpView()
        }).disposed(by: disposeBag)

        output.state?.map{$0.presentVC ?? .home}
        .distinctUntilChanged()
        .drive(onNext: { [weak self] presentVC in
            guard let self = self else { return }
            self.presentViewController(presentVC: presentVC)
        }).disposed(by: disposeBag)
        
        
    }
    

}

extension HomeViewController{
    
    func setUpView(){
        view = v
        menuDelegate.setTouchPublish(touchPublish: self.touchPublish)
        v.menuCV.delegate = menuDelegate
        v.menuCV.dataSource = menuDelegate
        v.menuCV.register(MenuViewCell.self, forCellWithReuseIdentifier: "MenuViewCell")
    }
    
    func presentViewController(presentVC: PresentVC){
        guard let vc = vcArray[presentVC] else {
            return
        }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
}
