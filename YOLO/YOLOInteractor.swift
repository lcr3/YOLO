//
//  YOLOInteractor.swift
//  YOLO
//
//  Created by lcr on 2021/11/15.
//

import Foundation
import UIKit

class YOLOInteractor {
    let yoloCore: YOLOCore

    init() {
        yoloCore = YOLOCore()
    }

    func request(image: UIImage) {
        yoloCore.request(image: image) { result in
            switch result {
            case .success(let identifier):
                print(identifier)
            case .failure(let error):
                print(error)
            }
        }
    }
}
