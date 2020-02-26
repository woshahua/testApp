//
//  ViewController.swift
//  Corona
//
//  Created by HANG GAO on 2020/02/25.
//  Copyright © 2020 HANG GAO. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController {
    private let viewModel = MainVCViewModel()
    @IBOutlet weak var newPatientNumberLabel: UILabel!
    @IBOutlet weak var patientNumberLabel: UILabel!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel.fetch()
        
        viewModel.patientNumberSubject.subscribe(onNext: { [weak self] number in
            self?.patientNumberLabel.text = String(number) + "人"
        }).disposed(by: disposeBag)
        
        viewModel.newPatientNumberSubject.subscribe(onNext: { [weak self] number in
            self?.newPatientNumberLabel.text = String(number) + "人"
        }).disposed(by: disposeBag)
    }
}
