//
//  Date+Extensions.swift
//  VoxPopuli
//
//  Created by Stanislav Kasprik on 12/03/2018.
//  Copyright © 2018 Stanislav Kasprik. All rights reserved.
//

import Foundation

extension Date {
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
}
