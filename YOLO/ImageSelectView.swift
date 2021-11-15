//
//  ImageSelectView.swift
//  YOLO
//
//  Created by lcr on 2021/11/15.
//

import PhotosUI
import SwiftUI

struct ImageSelectView: View {
    // Pickerの表示/非表示フラグ
    @State private var isPresented = false
    // Imageを格納
    @State var pickerResult: UIImage?
    // PHPickerの設定
    var config: PHPickerConfiguration {
       var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        config.filter = .images
        config.selectionLimit = 1
        return config
    }

    let interactor: YOLOInteractor

    init() {
        interactor = YOLOInteractor()
    }

    var body: some View {
        VStack(alignment: .leading) {
            Button("Image Picker") {
                isPresented.toggle()
            }.sheet(isPresented: $isPresented, onDismiss: {
                guard let pickImage = pickerResult else {
                    print("no select image")
                    return
                }
                interactor.request(image: pickImage)

            }, content: {
                PhotoPicker(configuration: self.config,
                            pickerResult: $pickerResult,
                            isPresented: $isPresented)
            })
            if let pickerResult = pickerResult {
                Image.init(uiImage: pickerResult)
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .onAppear {
                        interactor.request(image: pickerResult)
                    }
            }
        }
    }
}
