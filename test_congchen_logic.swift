import Foundation

// Hack to allow "import" of file in script mode or just include source
// Since we are running single file scripts, we might need to copy the logic or compile together.
// Easier to just include the logic file content OR (better) use swiftc.
// But valid approach via tool is to `swiftc` them together.

// For this script, I will instantiate and test.
// I assume I will run `swiftc CongChenLogic.swift test_congchen_logic.swift && ./test_congchen_logic` or similar.

// Helpers
func test(
  monthS: HeavenlyStem, monthB: EarthlyBranch, dayS: HeavenlyStem, dayB: EarthlyBranch,
  expect: [ShenShaType]
) {
  let result = CongChenCalculator.calculateShenSha(
    monthStem: monthS, monthBranch: monthB,
    dayStem: dayS, dayBranch: dayB
  )

  let resultNames = result.map { $0.name }
  let expectNames = expect.map { $0.name }

  // Check intersection
  let hasAll = expect.allSatisfy { result.contains($0) }

  print("Month: \(monthB.rawValue) | Day: \(dayS.rawValue)\(dayB.rawValue)")
  print("  Got: \(resultNames)")
  print("  Exp: \(expectNames)")

  if hasAll {
    print("  ✅ PASS")
  } else {
    print("  ❌ FAIL")
  }

  // Yi/Ji
  let (yi, ji) = CongChenCalculator.getYiJi(shenShas: result)
  print("  Yi: \(yi)")
  print("  Ji: \(ji)")
  print("\n")
}

@main
struct TestRunner {
  static func main() {
    print("--- Testing CongChenLogic ---")

    // Case 1: Tian De (天德)
    // Month Yin (1), Rule: Ding.
    // Day: Ding Mao
    test(monthS: .bing, monthB: .yin, dayS: .ding, dayB: .mao, expect: [.tianDe])

    // Case 2: Yue De (月德)
    // Month Yin (1), Rule: Bing.
    // Day: Bing Zi
    test(monthS: .bing, monthB: .yin, dayS: .bing, dayB: .zi, expect: [.yueDe])

    // Case 3: Yue Po (月破)
    // Month Yin (1), Opposite: Shen.
    // Day: Gen Shen
    test(monthS: .bing, monthB: .yin, dayS: .geng, dayB: .shen, expect: [.yuePo, .daHao])

    // Case 4: Tian Yi (天乙贵人)
    // Day Stem: Jia. Rule: Chou/Wei.
    // Day: Jia Zi (No), Jia Wei (Yes)
    test(monthS: .bing, monthB: .yin, dayS: .jia, dayB: .wei, expect: [.tianYi])

    // Case 5: Liu He (六合)
    // Month Yin. Rule: Hai.
    // Day: Yi Hai
    test(monthS: .bing, monthB: .yin, dayS: .yi, dayB: .hai, expect: [.liuHe])
  }
}
