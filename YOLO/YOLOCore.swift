//
//  YOLOCore.swift
//  YOLO
//
//  Created by lcr on 2021/11/15.
//

import Vision
import UIKit

class YOLOCore {
    enum YOLOCoreError: Error {
        case failureImageConversion
        case notFound
        case other(Error)
    }

    let model: YOLOv3
    let mlModel: VNCoreMLModel
    init() {
        model = {
            do {
                let config = MLModelConfiguration()
                return try YOLOv3(configuration: config)
            } catch {
                fatalError(error.localizedDescription)
            }
        }()
        do {
            mlModel = try VNCoreMLModel(for: model.model)
        } catch {
            fatalError("Faild init")
        }
    }

    func request(image: UIImage, completion: @escaping (Result<[Object], YOLOCoreError>) -> Void) {
        print("Receive request!")
        guard let ciImage = CIImage(image: image) else {
            completion(.failure(.failureImageConversion))
            return
        }

        let request = VNCoreMLRequest(model: mlModel) { (request, error) in
            if let error = error {
                completion(.failure(.other(error)))
            }
            // 解析結果を分類情報として保存
            print(request.results?.count)

            guard let objects = request.results as? [VNRecognizedObjectObservation] else {
                completion(.failure(.failureImageConversion))
                return
            }
            var resultObjects: [Object] = []
            objects.forEach { object in
                resultObjects.append(Object(identifier: object.labels.first!.identifier, confidence: object.confidence))
            }
            completion(.success(resultObjects))
        }
        // 画像解析をリクエスト
        let handler = VNImageRequestHandler(ciImage: ciImage)

        // リクエストを実行
        do {
            print("Start analysis")
            try handler.perform([request])
        } catch {
            completion(.failure(.other(error)))
            print(error)
        }
    }
}

struct Object {
    let identifier: String
    let confidence: Float
//    let
}
