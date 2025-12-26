import Foundation

// Mocking the structure since we are running as a script and can't easily import the module without workspace
struct LuckyDirections {
  let joy: String
  let wealth: String
  let fortune: String
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

  static func getDirections(dayGanZhi: String) -> LuckyDirections? {
    guard let stemChar = dayGanZhi.first else { return nil }
    let stem = String(stemChar)

    return LuckyDirections(
      joy: getJoyDirection(stem: stem),
      wealth: getWealthDirection(stem: stem),
      fortune: getFortuneDirection(stem: stem)
    )
  }

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

  private static func getFortuneDirection(stem: String) -> String {
    switch stem {
    case "甲", "己": return directions["north"]!
    case "乙", "庚": return directions["southwest"]!
    case "丙", "辛": return directions["northwest"]!
    case "丁", "壬": return directions["southeast"]!
    case "戊", "癸": return directions["northeast"]!
    default: return ""
    }
  }
}

// Test Case: 2025-12-26 is 己巳 day
// Day Stem: 己 (Ji)
// Expected:
// Joy: Northeast (艮)
// Wealth: North (坎)
// Fortune: North (坎)

let testDay = "己巳"
print("Testing with Day GanZhi: \(testDay)")

if let directions = LuckyDirectionHelper.getDirections(dayGanZhi: testDay) {
  print("Joy Spirit: \(directions.joy)")
  print("Wealth Spirit: \(directions.wealth)")
  print("Fortune Spirit: \(directions.fortune)")

  if directions.joy == "东北" && directions.wealth == "正北" && directions.fortune == "正北" {
    print("✅ TEST PASSED")
  } else {
    print("❌ TEST FAILED")
    print("Expected Joy: 东北, Got: \(directions.joy)")
    print("Expected Wealth: 正北, Got: \(directions.wealth)")
    print("Expected Fortune: 正北, Got: \(directions.fortune)")
  }
} else {
  print("❌ TEST FAILED: Could not calculate")
}
