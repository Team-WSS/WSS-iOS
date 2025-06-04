//
//  PhotoPickerManager.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/12/25.
//

import PhotosUI

final class PhotoPickerManager: NSObject {
    private weak var presentingViewController: UIViewController?
    var didSelectImages: (([UIImage]) -> Void)?
    let maximumImageCount = FeedEdit.imageMaxCount
    
    init(presentingViewController: UIViewController) {
        self.presentingViewController = presentingViewController
    }

    func presentPicker() {
        var config = PHPickerConfiguration()
        config.selectionLimit = self.maximumImageCount
        config.filter = .images

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        presentingViewController?.present(picker, animated: true)
    }
}

extension PhotoPickerManager: PHPickerViewControllerDelegate {
    // 사용자가 사진을 선택한 후 실행되는 델리게이트 메소드
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        let itemProviders = results.map { $0.itemProvider }

        var images: [UIImage] = []
        let group = DispatchGroup()

        for provider in itemProviders {
            if provider.canLoadObject(ofClass: UIImage.self) {
                group.enter()
                provider.loadObject(ofClass: UIImage.self) { object, _ in
                    if let image = object as? UIImage {
                        images.append(image)
                    }
                    group.leave()
                }
            }
        }

        group.notify(queue: .main) { [weak self] in
            self?.didSelectImages?(images)
        }
    }
}
