//
//  Date+Extension.swift
//  AutodocTest
//
//  Created by Вадим Кузьмин on 09.10.2026.
//

import Foundation

extension Date.ISO8601FormatStyle {
    static let serverStyle = Date.ISO8601FormatStyle(timeZone: .gmt)
        .year().month().day()
        .dateSeparator(.dash)
        .time(includingFractionalSeconds: false)
        .timeSeparator(.colon)

}
