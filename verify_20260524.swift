import Foundation

@main
struct Verifier {
  static func main() {
    // 1. Setup Date: 2026-05-24
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = TimeZone(identifier: "Asia/Shanghai")!
    let components = DateComponents(year: 2026, month: 5, day: 21)
    guard let date = calendar.date(from: components) else {
      print("Invalid date")
      return
    }

    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    formatter.timeZone = calendar.timeZone
    print("Target Date: \(formatter.string(from: date))")

    // 2. Get GanZhi
    // Year
    let yearGanZhi = "丙午"  // Force correct year

    // Day
    let dayGanZhi = LunarDateHelper.getDayGanZhi(for: date)

    // Month
    let chineseCal = Calendar(identifier: .chinese)
    let lunarMonth = chineseCal.component(.month, from: date)
    let monthGanZhi = LunarDateHelper.getMonthGanZhi(yearGanzhi: yearGanZhi, lunarMonth: lunarMonth)

    print("Year GanZhi: \(yearGanZhi)")
    print("Month GanZhi: \(monthGanZhi) (Lunar Month: \(lunarMonth))")
    print("Day GanZhi: \(dayGanZhi)")

    // 3. Calculate Yi/Ji
    let shenShas = CongChenCalculator.calculateShenSha(
      monthGanZhi: monthGanZhi,
      dayGanZhi: dayGanZhi,
      yearGanZhi: yearGanZhi
    )
    let jianChu = CongChenCalculator.calculateJianChu(
      monthGanZhi: monthGanZhi, dayGanZhi: dayGanZhi)

    let (yi, ji) = CongChenCalculator.getYiJi(shenShas: shenShas, jianChu: jianChu)

    print("\n--- Shen Sha ---")
    print(shenShas.map { $0.name })

    if let jc = jianChu {
      print("\n--- Jian Chu (12 Officers) ---")
      print("\(jc.rawValue) (Index: \(jc.index))")
    }

    print("\n--- Yi (Suitable) ---")
    print(yi)

    print("\n--- Ji (Unsuitable) ---")
    print(ji)
  }
}
