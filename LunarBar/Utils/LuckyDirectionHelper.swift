//
//  LuckyDirectionHelper.swift
//  LunarBar
//
//  Created by Antigravity on 2025/12/26.
//

import Foundation

struct LuckyDirections {
  let joy: String  // 喜神
  let wealth: String  // 财神
  let fortune: String  // 福神
}

struct LuckyDirectionHelper {

  private static let directions: [String: String] = [
    "north": "正北",
    "northeast": "东北",
    "east": "正东",
    "southeast": "东南",
    "south": "正南",
    "southwest": "西南",
    "west": "正西",
    "northwest": "西北",
  ]

  /// Get Lucky Spirit Directions based on Day Column (GanZhi)
  /// - Parameter dayGanZhi: Day GanZhi string (e.g. "甲子")
  /// - Returns: LuckyDirections struct containing directions for Joy, Wealth, and Fortune spirits
  static func getDirections(dayGanZhi: String) -> LuckyDirections? {
    guard let stemChar = dayGanZhi.first else { return nil }
    let stem = String(stemChar)

    return LuckyDirections(
      joy: getJoyDirection(stem: stem),
      wealth: getWealthDirection(stem: stem),
      fortune: getFortuneDirection(stem: stem)
    )
  }

  // MARK: - Private Calculation Logic

  /// Calculate Joy Spirit Direction (喜神)
  /// "甲己在艮乙庚乾，丙辛坤位喜神安。丁壬只向离宫坐，戊癸原来在巽间。"
  private static func getJoyDirection(stem: String) -> String {
    switch stem {
    case "甲", "己": return directions["northeast"]!
    case "乙", "庚": return directions["northwest"]!
    case "丙", "辛": return directions["southwest"]!
    case "丁", "壬": return directions["south"]!
    case "戊", "癸": return directions["southeast"]!
    default: return ""
    }
  }

  /// Calculate Wealth Spirit Direction (财神)
  /// "甲乙艮方丙丁坤，戊己财神坐坎位。庚辛正东壬癸南，此是财神正方位。"
  private static func getWealthDirection(stem: String) -> String {
    switch stem {
    case "甲", "乙": return directions["northeast"]!
    case "丙", "丁": return directions["southwest"]!
    case "戊", "己": return directions["north"]!
    case "庚", "辛": return directions["east"]!
    case "壬", "癸": return directions["south"]!
    default: return ""
    }
  }

  /// Calculate Fortune Spirit Direction (福神)
  /// "甲己正北是福神，丙辛西北乾宫存。乙庚坤位戊癸艮，丁壬巽上好追寻。"
  private static func getFortuneDirection(stem: String) -> String {
    switch stem {
    case "甲", "己": return directions["north"]!  // Note: Differs from Joy
    case "乙", "庚": return directions["southwest"]!
    case "丙", "辛": return directions["northwest"]!
    case "丁", "壬": return directions["southeast"]!
    case "戊", "癸": return directions["northeast"]!
    default: return ""
    }
  }
}
