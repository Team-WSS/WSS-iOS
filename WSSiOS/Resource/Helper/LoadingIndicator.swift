//
//  LoadingIndicator.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 2/4/26.
//

import UIKit

final class LoadingIndicator {
    
    private static var overlayTag = 999_999
    
    private static var keyWindow: UIWindow? {
        UIApplication.shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
    
    static func showLoading() {
        DispatchQueue.main.async {
            guard let window = keyWindow else { return }
            
            if window.viewWithTag(overlayTag) != nil { return }
            
            let overlay = UIView(frame: window.bounds)
            overlay.tag = overlayTag
            
            let indicator = UIActivityIndicatorView(style: .large)
            indicator.color = .wssPrimary100
            indicator.center = overlay.center
            indicator.startAnimating()
            
            overlay.addSubview(indicator)
            window.addSubview(overlay)
        }
    }
    
    static func hideLoading() {
        DispatchQueue.main.async {
            guard let window = keyWindow else { return }
            window.viewWithTag(overlayTag)?.removeFromSuperview()
        }
    }
}
