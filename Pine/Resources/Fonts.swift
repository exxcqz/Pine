//
//  Fonts.swift
//  Pine
//
//  Created by Nikita Gavrikov on 12.04.2022.
//

import UIKit

extension UIFont {

    static func proTextFontMedium(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "SFProText-Medium", size: size) ?? UIFont.systemFont(ofSize: size)
    }

    static func proTextFontRegular(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "SFProText-Regular", size: size) ?? UIFont.systemFont(ofSize: size)
    }

    static func latoFontBold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Lato-Bold", size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
