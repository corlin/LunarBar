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
    
    static func getGanzhiYear(for date: Date) -> String {
        return yearFormatter.string(from: date)
    }
    
    static func getZodiac(for date: Date) -> String {
        let ganzhiYear = getGanzhiYear(for: date)
        guard ganzhiYear.count >= 2 else { return "" }
        let branchCharacter = String(ganzhiYear[ganzhiYear.index(ganzhiYear.startIndex, offsetBy: 1)])
        if let branchIndex = earthlyBranches.firstIndex(of: branchCharacter) {
            return zodiacSymbols[branchIndex]
        }
        return ""
    }
    
    static func getMonthGanZhi(yearGanzhi: String, lunarMonth: Int) -> String {
        guard yearGanzhi.count >= 1 else { return "" }
        let yearStemChar = String(yearGanzhi.prefix(1))
        guard let yearStemIndex = heavenlyStems.firstIndex(of: yearStemChar) else { return "" }
        let monthStemIndexBase = (yearStemIndex % 5) * 2 + 2
        let monthStemIndex = (monthStemIndexBase + (lunarMonth - 1)) % 10
        let monthBranchIndex = (2 + (lunarMonth - 1)) % 12
        return heavenlyStems[monthStemIndex] + earthlyBranches[monthBranchIndex]
    }
    
    static func getDayGanZhi(for date: Date) -> String {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Shanghai") ?? .current
        var anchorComponents = DateComponents()
        anchorComponents.year = 2000
        anchorComponents.month = 1
        anchorComponents.day = 1
        guard let anchorDate = calendar.date(from: anchorComponents) else { return "" }
        let days = calendar.dateComponents([.day], from: anchorDate, to: date).day ?? 0
        let anchorStem = 4 
        let anchorBranch = 6
        let stemIndex = (anchorStem + days) % 10
        let finalStemIndex = (stemIndex + 10) % 10
        let branchIndex = (anchorBranch + days) % 12
        let finalBranchIndex = (branchIndex + 12) % 12
        return heavenlyStems[finalStemIndex] + earthlyBranches[finalBranchIndex]
    }
}

let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "yyyy-MM-dd"
dateFormatter.timeZone = TimeZone(identifier: "Asia/Shanghai") 

func testDate(_ dateString: String, expectedDayGanZhi: String, expectedMonthGanZhi: String? = nil, lunarMonth: Int? = nil, yearGanZhi: String? = nil) {
    let date = dateFormatter.date(from: dateString)!
    let dayGanZhi = LunarDateHelper.getDayGanZhi(for: date)
    print("Date: \(dateString)")
    print("  Actual Day GanZhi: \(dayGanZhi) | Expected: \(expectedDayGanZhi)")
    
    if dayGanZhi != expectedDayGanZhi {
        print("  ❌ FAILED Day")
    } else {
        print("  ✅ PASSED Day")
    }
    
    if let expectedMonth = expectedMonthGanZhi, let lMonth = lunarMonth, let yGanZhi = yearGanZhi {
        let monthGanZhi = LunarDateHelper.getMonthGanZhi(yearGanzhi: yGanZhi, lunarMonth: lMonth)
        print("  Actual Month GanZhi: \(monthGanZhi) | Expected: \(expectedMonth)")
        if monthGanZhi != expectedMonth {
            print("  ❌ FAILED Month")
        } else {
            print("  ✅ PASSED Month")
        }
    }
    print("--------------------------------------------------")
}

print("Running Gan-Zhi Verification...\n")

// Test Cases
testDate("2023-01-01", expectedDayGanZhi: "癸未")
testDate("2024-02-10", expectedDayGanZhi: "甲辰", expectedMonthGanZhi: "丙寅", lunarMonth: 1, yearGanZhi: "甲辰")
testDate("2024-03-10", expectedDayGanZhi: "癸酉", expectedMonthGanZhi: "丁卯", lunarMonth: 2, yearGanZhi: "甲辰")
