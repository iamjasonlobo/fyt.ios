//
//  fytNavBarButtonItem.swift
//  fyt
//
//  Created by Jason Lobo on 4/25/23.
//

import UIKit

class fytNavBarButtonItem: UIBarButtonItem {
    override func awakeFromNib() {
        super.awakeFromNib()
        if let font = UIFont(name: "HelveticaNeue-Bold", size: 17) {
            let attributes = [NSAttributedString.Key.font: font]
            self.setTitleTextAttributes(attributes, for: .normal)
        }
    }
}
