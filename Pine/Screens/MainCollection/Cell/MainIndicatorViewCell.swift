//
//  IndicatorViewCell.swift
//  Pine
//
//  Created by Nikita Gavrikov on 07.03.2022.
//

import UIKit

class MainIndicatorViewCell: UICollectionViewCell {
    var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        return indicator
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        contentView.addSubview(activityIndicator)
        activityIndicator.center = contentView.center
        activityIndicator.startAnimating()
    }
}
