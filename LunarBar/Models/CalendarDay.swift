//
//  CalendarDay.swift
//  LunarBar
//
//  Created by ruihelin on 2025/9/28.
//

import SwiftUI

struct CalendarDay: Hashable {
  /// 是否周数
  let is_weekNumber: Bool
  /// 周数
  let weekNumber: Int?
  /// 是否今日
  let is_today: Bool
  /// 是否本月
  let is_currentMonth: Bool
  /// 日期
  let date: Date?
  /// 简单农历
  let short_lunar: String?
  /// 完整农历
  let full_lunar: String?
  /// 月干支
  let ganzhi_month: String?
  /// 日干支
  let ganzhi_day: String?
  /// 年干支
  let ganzhi_year: String?
  /// 生肖
  let zodiac: String?
  /// 节假日
  let holidays: [String]
  /// 节气
  let solar_term: String?
  /// 放假
  let offday: Bool?
  /// 事件
  let events: [CalendarEvent]
  /// 宜
  let yi: [String]
  /// 忌
  let ji: [String]
  /// 喜神
  let lucky_joy: String?
  /// 财神
  let lucky_wealth: String?
  /// 福神
  let lucky_fortune: String?

  init(
    is_weekNumber: Bool = false,
    weekNumber: Int? = nil,
    is_today: Bool = false,
    is_currentMonth: Bool = false,
    date: Date? = nil,
    short_lunar: String? = nil,
    full_lunar: String? = nil,
    ganzhi_month: String? = nil,
    ganzhi_day: String? = nil,
    ganzhi_year: String? = nil,
    zodiac: String? = nil,
    holidays: [String] = [],
    solar_term: String? = nil,
    offday: Bool? = nil,
    events: [CalendarEvent] = [],
    yi: [String] = [],
    ji: [String] = [],
    lucky_joy: String? = nil,
    lucky_wealth: String? = nil,
    lucky_fortune: String? = nil
  ) {
    self.is_weekNumber = is_weekNumber
    self.weekNumber = weekNumber
    self.is_today = is_today
    self.is_currentMonth = is_currentMonth
    self.date = date
    self.short_lunar = short_lunar
    self.full_lunar = full_lunar
    self.ganzhi_month = ganzhi_month
    self.ganzhi_day = ganzhi_day
    self.ganzhi_year = ganzhi_year
    self.zodiac = zodiac
    self.holidays = holidays
    self.solar_term = solar_term
    self.offday = offday
    self.events = events
    self.yi = yi
    self.ji = ji
    self.lucky_joy = lucky_joy
    self.lucky_wealth = lucky_wealth
    self.lucky_fortune = lucky_fortune
  }
}
