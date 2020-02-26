//
//  MainControllerViewModel.swift
//  Corona
//
//  Created by HANG GAO on 2020/02/26.
//  Copyright © 2020 HANG GAO. All rights reserved.
//

import Foundation
import Alamofire
import Kanna
import RxSwift
import RxCocoa

class MainVCViewModel {
    let patientNumberSubject = PublishSubject<Int>()
    let newPatientNumberSubject = PublishSubject<Int>()
    
    func fetch() {
        AF.request("https://covid19-jp.com/").responseString { [weak self] response in
            switch response.result {
            case .success:
                self?.parseHtml(html: response.value!)
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func parseHtml(html: String) {
        if let doc = try? Kanna.HTML(html: html, encoding: .utf8) {
            for node in doc.body!.css("div"){
                if node.innerHTML!.contains("全感染報告数") {
                    guard let subNode = node.at_css("p") else { return }
                    subNode.removeChild(subNode.at_css("span")!)
                    guard let number = Int(subNode.text ?? "0") else { return }
                    patientNumberSubject.onNext(number)
                }
                
                if node.innerHTML!.contains("今日の感染") {
                    guard let subNode = node.at_css("p") else { return }
                    subNode.removeChild(subNode.at_css("span")!)
                    guard let number = Int(subNode.text ?? "0") else { return }
                    newPatientNumberSubject.onNext(number)
                }
            }
        }
    }
}
