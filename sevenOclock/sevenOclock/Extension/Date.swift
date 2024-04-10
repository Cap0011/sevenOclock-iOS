//
//  Date.swift
//  sevenOclock
//
//  Created by Jiyoung Park on 2024/03/27.
//

import Foundation

extension Date {
    // MARK: 원하는 format만 주입하면 string 반환
    func formattedString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }
    
    // MARK: "일" 단위 까지만 비교하여 날짜 간격 계산
    func daysLeft(from start: Date = Date()) -> Int {
        let timeInterval = Int(self.timeIntervalSince1970 / 86400)
        let startTimeInterval = Int(start.timeIntervalSince1970 / 86400)
        
        return timeInterval - startTimeInterval
    }
    
    // MARK: 캘린더의 컴포넌트를 가져오는 extension(eg. Date().get(.month) -> 오늘 날짜에 해당하는 월 반환)
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }
    
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}
