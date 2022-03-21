//
//  IndicatorViewCell.swift
//  Pine
//
//  Created by Nikita Gavrikov on 07.03.2022.
//

import UIKit

final class MainIndicatorViewCell: UICollectionViewCell {
    var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        return indicator
    }()

    var labelNoConnection: UILabel = {
        let label = UILabel()
        label.text = Strings.cellLabelNoConnection
        label.font = UIFont.proTextFontMedium(ofSize: 14 * Layout.scaleFactorW)
        label.textAlignment = .center
        label.textColor = .black
        label.isHidden = true
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        activityIndicator.frame = .init(
            x: 0,
            y: 0,
            width: 24 * Layout.scaleFactorW,
            height: 24 * Layout.scaleFactorW
        )
        activityIndicator.center = contentView.center
        labelNoConnection.frame = .init(
            x: 0,
            y: activityIndicator.center.y + (15 * Layout.scaleFactorW),
            width: contentView.bounds.width,
            height: 16 * Layout.scaleFactorW
        )
    }
    
    private func setup() {
        contentView.addSubview(activityIndicator)
        contentView.addSubview(labelNoConnection)
        activityIndicator.startAnimating()
    }
}
