//
//  DateFormatter+Extensions.swift
//  almost-real
//
//  Created by Jason Lobo on 11/3/22.
//

import Foundation

extension DateFormatter {
    static var postFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }()
}
