//
//  ExtensionDate.swift
//  EdApp4182
//
//  Created by NikoS on 29.08.2022.
//

import Foundation

extension Date {
    func convertToTimeZone(initTimeZone: TimeZone, timeZone: TimeZone) -> Date {
         let delta = TimeInterval(timeZone.secondsFromGMT(for: self) - initTimeZone.secondsFromGMT(for: self))
         return addingTimeInterval(delta)
    }
}
