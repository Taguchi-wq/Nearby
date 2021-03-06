//
//  UIImageView+Extension.swift
//  Nearby
//
//  Created by cmStudent on 2021/04/10.
//

import UIKit
import Nuke

extension UIImageView {
    
    /// 画像をimageViewにセットする
    /// - Parameter imageURL: 画像のURLの文字列
    func setupImage(imageURL: String) {
        guard let url = URL(string: imageURL) else { return }
        Nuke.loadImage(with: url, into: self)
    }
    
    /// 画像を読み込み中の時、灰色にする
    func loadingImage() {
        layer.cornerRadius = 10
        layer.borderWidth  = 1
        layer.borderColor  = UIColor.imageGray.cgColor
        backgroundColor    = UIColor.imageGray
    }
    
}
