//
//  MenuScreenCustomButton.swift
//  Gridy
//
//  Created by Ahmed Chishti on 3/1/21.
//

import Foundation
import UIKit

class MenuScreenCustomButton: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = CGFloat(15)
        let imageViewSize = imageView?.frame.size
        let titleLabelSize = titleLabel?.frame.size
        let padding = CGFloat(5.0)
        let totalHeight = imageViewSize!.height + titleLabelSize!.height + padding
        self.titleEdgeInsets = UIEdgeInsets (
            top: 20.0,
            left: -imageViewSize!.width,
            bottom: -(totalHeight - titleLabelSize!.height),
            right: 0.0
        )
        self.imageEdgeInsets = UIEdgeInsets (
            top: -(totalHeight - imageViewSize!.height),
            left: 0.0,
            bottom: 0.0,
            right: -titleLabelSize!.width
        )
    }
}
