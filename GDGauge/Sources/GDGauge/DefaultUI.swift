//
//  DefaultUI.swift
//  
//
//  Created by Saeid on 2022-08-07.
//

import UIKit

public enum DefaultUI {
    public enum Container {
        public static let color = UIColor(
            red: 0 / 255,
            green: 72 / 255,
            blue: 67 / 255,
            alpha: 1
        )

        public static let handleColor = UIColor(
            red: 0 / 255,
            green: 98 / 255,
            blue: 91 / 255,
            alpha: 1
        )

        public static let indicatorsColor = UIColor(
            red: 0 / 255,
            green: 174 / 255,
            blue: 162 / 255,
            alpha: 1
        )

        public static let indicatorValuesColor = UIColor(
            red: 0 / 255,
            green: 0 / 255,
            blue: 0 / 255,
            alpha: 1
        )

        public static let indicatorsFont = UIFont.preferredFont(forTextStyle: .caption1)
    }

    public enum Unit {
        public static let imageTint = UIColor.black
        public static let imageSize = 20.0
        public static let font = UIFont.preferredFont(forTextStyle: .footnote)
    }
}
