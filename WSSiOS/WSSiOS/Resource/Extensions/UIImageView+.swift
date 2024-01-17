//
<<<<<<< HEAD
//  UIImageView+.swift
=======
//  UIImageView_.swift
>>>>>>> 2000d92d38aa26e179b7f58dd8d5c2c9c37ffc5e
//  WSSiOS
//
//  Created by 신지원 on 1/16/24.
//

import UIKit

import Kingfisher

<<<<<<< HEAD
extension UIImageView{
=======
extension UIImageView {
>>>>>>> 2000d92d38aa26e179b7f58dd8d5c2c9c37ffc5e
    func kfSetImage(url : String?){
        
        guard let url = url else { return }
        
        if let url = URL(string: url) {
            kf.indicatorType = .activity
            kf.setImage(with: url,
                        placeholder: nil,
                        options: [.transition(.fade(1.0))],
                        progressBlock: nil)
        }
    }
}
