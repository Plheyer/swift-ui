//
//  DateFormatterExtensions.swift
//  C4
//
//  Created by etudiant on 24/05/2025.
//

import Foundation

public extension DateFormatter {
    func defaultFormat(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }
}
