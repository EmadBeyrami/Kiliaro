//
//  Date+Extensions.swift
//  kiliaro
//
//  Created by Emad Bayramy on 12/8/21.
//

import Foundation

extension Date {
    init(dateString: String) {
        self = Date.iso8601Formatter.date(from: dateString)!
    }

    static let iso8601Formatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate,
                                   .withTime,
                                   .withDashSeparatorInDate,
                                   .withColonSeparatorInTime]
        return formatter
    }()
}

extension String {
    func toDate() -> String {
        let date = Date(dateString: self)
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate,
                                   .withTime,
                                   .withDashSeparatorInDate,
                                   .withSpaceBetweenDateAndTime,
                                   .withColonSeparatorInTime]
        return formatter.string(from: date)
    }
}
