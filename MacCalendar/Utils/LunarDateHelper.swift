//
//  LunarDateHelper.swift
//  MacCalendar
//
//  Created by ruihelin on 2025/10/12.
//

import Foundation

struct LunarDateHelper {

  static let heavenlyStems = ["甲", "乙", "丙", "丁", "戊", "己", "庚", "辛", "壬", "癸"]
  static let earthlyBranches = ["子", "丑", "寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌", "亥"]
  static let zodiacSymbols = ["鼠", "牛", "虎", "兔", "龍", "蛇", "馬", "羊", "猴", "雞", "狗", "豬"]

  private static let yearFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .chinese)
    formatter.dateFormat = "U"
    return formatter
  }()

  /**
   根据公历日期，准确获取其对应的天干地支纪年
   - Parameter date: 公历日期
   - Returns: 天干地支字符串，例如 "甲辰年"
   */
  static func getGanzhiYear(for date: Date) -> String {
    return yearFormatter.string(from: date)
  }

  /**
   根据公历日期，准确获取其对应的生肖
   - Parameter date: 公历日期
   - Returns: 生肖字符串，例如 "龍"
   */
  static func getZodiac(for date: Date) -> String {
    let ganzhiYear = getGanzhiYear(for: date)

    guard ganzhiYear.count >= 2 else { return "" }
    let branchCharacter = String(ganzhiYear[ganzhiYear.index(ganzhiYear.startIndex, offsetBy: 1)])

    if let branchIndex = earthlyBranches.firstIndex(of: branchCharacter) {
      return zodiacSymbols[branchIndex]
    }

    return ""
  }

  /**
   获取月干支 (基于农历月份 approximation)
   - Parameter yearGanzhi: 年干支字符 (如 "乙巳")
   - Parameter lunarMonth: 农历月份 (1-12)
   - Returns: 月干支 (如 "丙寅")
   */
  static func getMonthGanZhi(yearGanzhi: String, lunarMonth: Int) -> String {
    guard yearGanzhi.count >= 1 else { return "" }
    let yearStemChar = String(yearGanzhi.prefix(1))

    guard let yearStemIndex = heavenlyStems.firstIndex(of: yearStemChar) else { return "" }

    // 五虎遁年起月诀
    // 甲己之年丙作首 -> 甲(0), 己(5) => 丙(2)
    // (0 % 5) * 2 + 2 = 2
    // (5 % 5) * 2 + 2 = 2
    let monthStemIndexBase = (yearStemIndex % 5) * 2 + 2

    // 农历一月通常对应 寅月 (Tiger) -> Index 2
    // month 1 -> stemIndexBase + 0
    // month n -> stemIndexBase + (n-1)

    let monthStemIndex = (monthStemIndexBase + (lunarMonth - 1)) % 10
    let monthBranchIndex = (2 + (lunarMonth - 1)) % 12

    return heavenlyStems[monthStemIndex] + earthlyBranches[monthBranchIndex]
  }

  /**
   获取日干支
   - Parameter date: 公历日期
   - Returns: 日干支 (如 "甲子")
   */
  static func getDayGanZhi(for date: Date) -> String {
    // 基准日: 2000-01-01 -> 戊午 (4, 6)
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = TimeZone(identifier: "Asia/Shanghai") ?? .current

    var anchorComponents = DateComponents()
    anchorComponents.year = 2000
    anchorComponents.month = 1
    anchorComponents.day = 1
    guard let anchorDate = calendar.date(from: anchorComponents) else { return "" }

    let days = calendar.dateComponents([.day], from: anchorDate, to: date).day ?? 0

    let anchorStem = 4  // 戊
    let anchorBranch = 6  // 午

    // days 可以是负数，使用 (% 10 + 10) % 10 确保正数
    let stemIndex = (anchorStem + days) % 10
    let finalStemIndex = (stemIndex + 10) % 10

    let branchIndex = (anchorBranch + days) % 12
    let finalBranchIndex = (branchIndex + 12) % 12

    return heavenlyStems[finalStemIndex] + earthlyBranches[finalBranchIndex]
  }
}
