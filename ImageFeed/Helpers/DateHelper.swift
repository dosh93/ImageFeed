//
//  DateHelper.swift
//  ImageFeed
//
//  Created by Dosh on 03.02.2024.
//

import Foundation

func convertISO8601StringToDate(iso8601String: String) -> Date? {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    return formatter.date(from: iso8601String)
}
