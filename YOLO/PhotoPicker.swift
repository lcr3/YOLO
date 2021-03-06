//
//  PhotoPicker.swift
//  YOLO
//
//  Created by lcr on 2021/11/15.
//

import SwiftUI
import PhotosUI
import Foundation

struct PhotoPicker: UIViewControllerRepresentable {
    let configuration: PHPickerConfiguration
    @Binding var pickerResult: UIImage?
    @Binding var isPresented: Bool

    func makeUIViewController(context: Context) -> PHPickerViewController {
            let controller = PHPickerViewController(configuration: configuration)
            controller.delegate = context.coordinator
            return controller
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    /// PHPickerViewControllerDelegate => Coordinator
    class Coordinator: PHPickerViewControllerDelegate {
        private let parent: PhotoPicker

        init(_ parent: PhotoPicker) {
            self.parent = parent
        }
        // PHPickerViewControllerDelegateの設定
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            for image in results {
                image.itemProvider.loadObject(ofClass: UIImage.self) { (selectedImage, error) in
                    if let error = error {
                        print("error: \(error.localizedDescription)")
                        return
                    }
                    guard let wrapImage = selectedImage as? UIImage else {
                        print("wrap error")
                        return
                    }
                    // 選択したImageをpickerResultに格納
                    self.parent.pickerResult = wrapImage
                }
            }
            // 閉じる
            parent.isPresented = false
        }
    }
}
