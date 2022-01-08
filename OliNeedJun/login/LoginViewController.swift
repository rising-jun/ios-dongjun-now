//
//  LoginViewController.swift
//  OliNeedJun
//
//  Created by 김동준 on 2022/01/08.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxViewController

class LoginViewController: BaseViewController{
    
    lazy var v = LoginView(frame: view.frame)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private let disposeBag: DisposeBag = DisposeBag()
    private let viewModel = LoginViewModel()
    private lazy var input = LoginViewModel.Input(viewState: self.rx.viewDidLoad.map{ViewState.viewDidLoad}.asObservable(),
                                                  priceValChanged: v.oilPriceSlider.rx.value.map{(Int($0) / 5) * 5}.distinctUntilChanged().asObservable())
    private lazy var output = viewModel.bind(input: input)
    
    private let spaceThumb = PublishSubject<Float>()
    
    
    override func bindViewModel() {
        super.bindViewModel()
        
        output.state?.map{$0.viewLogic}
        .filter{$0 == .setUpView}
        .distinctUntilChanged()
        .drive(onNext: { [weak self] logic in
            self?.setUpView()
            
            
            DispatchQueue.main.async {
                UIView.animate(withDuration: 1) {
                    self?.v.oilPriceSlider.setValue(8, animated: true)
                } completion: { done in
                    if done{
                        UIView.animate(withDuration: 1) {
                            self?.v.oilPriceSlider.setValue(0, animated: true)
                        }
                    }
                }

                
            }
            

            self?.v.layoutIfNeeded()

           
        }).disposed(by: disposeBag)
        
        output.state?.map{$0.price ?? 5}
        .distinctUntilChanged()
        .map{$0 == 50 ? "\($0)만원 이상" : "\($0)만원"}
        .drive(v.priceLabel.rx.text)
        .disposed(by: disposeBag)
        
    }
    
}

extension LoginViewController{
    func setUpView(){
        view = v
        v.oilPriceSlider.spaceThumbAnimation = spaceThumb
        v.oilPriceSlider.subscribeSpaceValue()
    }
}
