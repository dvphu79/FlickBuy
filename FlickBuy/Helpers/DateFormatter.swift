//
//  DateFormatter.swift
//  FlickBuy
//
//  Created by Phu DO on 3/7/25.
//

import Foundation

extension Int {
    func formattedDate() -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        return date.formatted(date: .abbreviated, time: .omitted)
    }
}