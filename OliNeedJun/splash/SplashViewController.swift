//
//  ViewController.swift
//  OliNeedJun
//
//  Created by 김동준 on 2021/12/26.
//

import UIKit
import RxSwift
import RxViewController

class SplashViewController: BaseViewController {
    
    lazy var v = SplashView(frame: view.frame)
    let oilMapViewController = OilMapViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    lazy var viewModel = SplashViewModel()
    private let disposeBag = DisposeBag()
    lazy var input = SplashViewModel.Input(timeOver: Observable<Int>
                                                .interval(.seconds(2), scheduler: MainScheduler.instance)
                                                .take(1)
                                                .map{_ in return true},
                                            viewState: rx.viewDidLoad.map{ViewState.viewDidLoad})
    lazy var output = viewModel.bind(input: input)
    
    override func bindViewModel() {
        super.bindViewModel()
        
        output.state?.map{$0.viewLogic}
            .filter{$0 == .setUpView}
            .distinctUntilChanged()
            .drive(onNext: { [weak self] logic in
            self?.setUpView()
        }).disposed(by: disposeBag)
        
        output.state?.map{$0.presentVC ?? .splash}
            .distinctUntilChanged()
            .drive(onNext: { [weak self] presentVC in
            self?.presentVC(vcName: presentVC)
        }).disposed(by: disposeBag)
        
    }


}

extension SplashViewController{
    func setUpView(){
        view = v
    }
    
    func presentVC(vcName: PresentVC){
        if vcName == .oilMap{
            
            oilMapViewController.modalPresentationStyle = .fullScreen
            self.present(oilMapViewController, animated: true, completion: nil)
        }
    }
    
}


