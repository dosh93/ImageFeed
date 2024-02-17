//
//  DateHelper.swift
//  ImageFeed
//
//  Created by Dosh on 03.02.2024.
//

import Foundation

class DateMapper {
    static let shared = DateMapper()

    private let iso8601Formatter: ISO8601DateFormatter

    private init() {
        iso8601Formatter = ISO8601DateFormatter()
    }

    func convertISO8601StringToDate(iso8601String: String?) -> Date? {
        guard let validString = iso8601String else { return nil }
        return iso8601Formatter.date(from: validString)
    }
}
