import Foundation

// MARK: - Enums for Gan-Zhi

/// 天干
public enum HeavenlyStem: String, CaseIterable {
  case jia = "甲"
  case yi = "乙"
  case bing = "丙"
  case ding = "丁"
  case wu = "戊"
  case
    ji = "己"
  case geng = "庚"
  case xin = "辛"
  case ren = "壬"
  case gui = "癸"

  var index: Int {
    return HeavenlyStem.allCases.firstIndex(of: self)!
  }
}

/// 地支
public enum EarthlyBranch: String, CaseIterable {
  case zi = "子"
  case chou = "丑"
  case yin = "寅"
  case mao = "卯"
  case chen = "辰"
  case si = "巳"
  case
    wu = "午"
  case wei = "未"
  case shen = "申"
  case you = "酉"
  case xu = "戌"
  case hai = "亥"

  var index: Int {
    return EarthlyBranch.allCases.firstIndex(of: self)!
  }

  /// 地支六冲（月破）
  var opposite: EarthlyBranch {
    let idx = self.index
    let oppositeIdx = (idx + 6) % 12
    return EarthlyBranch.allCases[oppositeIdx]
  }

  /// 三合局 (用于月德、劫煞等)
  /// 寅午戌合火 -> 丙
  /// 申子辰合水 -> 壬
  /// 亥卯未合木 -> 甲
  /// 巳酉丑合金 -> 庚
  var sanHeGroup: (stem: HeavenlyStem, element: String) {
    switch self {
    case .yin, .wu, .xu: return (.bing, "Fire")
    case .shen, .zi, .chen: return (.ren, "Water")
    case .hai, .mao, .wei: return (.jia, "Wood")
    case .si, .you, .chou: return (.geng, "Metal")
    }
  }

  /// 劫煞方位 (Based on SanHe)
  /// Shen-Zi-Chen (Water) -> JieSha at Si
  /// Hai-Mao-Wei (Wood) -> JieSha at Shen
  /// Yin-Wu-Xu (Fire) -> JieSha at Hai
  /// Si-You-Chou (Metal) -> JieSha at Yin
  var jieShaBranch: EarthlyBranch {
    switch self {
    case .shen, .zi, .chen: return .si
    case .hai, .mao, .wei: return .shen
    case .yin, .wu, .xu: return .hai
    case .si, .you, .chou: return .yin
    }
  }
}

// MARK: - Shen Sha & Actions

/// 黄历事项
public enum HuangliAction: String, CaseIterable, CustomStringConvertible {
  case wedding = "嫁娶"
  case engagement = "纳采"
  case travel = "出行"
  case opening = "开市"
  case trading = "交易"
  case houseConst = "修造"  // Renovation
  case groundBreaking = "动土"
  case moveIn = "入宅"
  case moving = "移徙"
  case funeral = "安葬"
  case sacrifice = "祭祀"
  case prayer = "祈福"
  case medical = "求医"
  case haircut = "理发"
  case everything = "诸事"  // Special case

  public var description: String { return self.rawValue }
}

/// 神煞类型 (Simplified List of Common ShenSha)
public enum ShenShaType {
  // --- Auspicious (吉神) ---
  case tianDe  // 天德
  case yueDe  // 月德
  case tianYi  // 天乙贵人
  case yueEn  // 月恩
  case sanHe  // 三合
  case liuHe  // 六合

  // --- Inauspicious (凶煞) ---
  case yuePo  // 月破 (Most severe)
  case daHao  // 大耗
  case zhuQue  // 朱雀 (Black dog/mouth dispute)
  case riPo  // 日破 (Same as Yue Po usually)
  case jieSha  // 劫煞 (Robbery Star)
  case wuGui  // 五鬼 (Five Ghosts)
  case wangWang  // 往亡 (Going to death)
  case zhongRi  // 重日

  var isAuspicious: Bool {
    switch self {
    case .tianDe, .yueDe, .tianYi, .yueEn, .sanHe, .liuHe: return true
    default: return false
    }
  }

  var name: String {
    switch self {
    case .tianDe: return "天德"
    case .yueDe: return "月德"
    case .tianYi: return "天乙贵人"
    case .yueEn: return "月恩"
    case .sanHe: return "三合"
    case .liuHe: return "六合"
    case .yuePo: return "月破"
    case .daHao: return "大耗"
    case .zhuQue: return "朱雀"
    case .riPo: return "日破"
    case .jieSha: return "劫煞"
    case .wuGui: return "五鬼"
    case .wangWang: return "往亡"
    case .zhongRi: return "重日"
    }
  }
}

// MARK: - Twelve Day Officers (建除)

public enum JianChu: String, CaseIterable {
  case jian = "建"
  case chu = "除"
  case man = "满"
  case ping = "平"
  case ding = "定"
  case zhi = "执"
  case po = "破"
  case wei = "危"
  case cheng = "成"
  case shou = "收"
  case kai = "开"
  case bi = "闭"

  var index: Int {
    return JianChu.allCases.firstIndex(of: self)!
  }

  /// General Yi/Ji for the officer
  var yiJi: (yi: [HuangliAction], ji: [HuangliAction]) {
    switch self {
    case .jian:
      return (
        yi: [.travel, .trading, .opening],
        ji: [.groundBreaking, .funeral]
      )
    case .chu:
      return (
        yi: [.medical, .sacrifice, .houseConst],  // Remove bad things
        ji: [.wedding, .travel]
      )
    case .man:
      return (
        yi: [.opening, .trading, .wedding, .prayer],
        ji: [.funeral, .medical]  // Full usually implies no more space for med
      )
    case .ping:
      return (
        yi: [.wedding, .travel, .houseConst],
        ji: [.groundBreaking, .funeral]  // Balanced
      )
    case .ding:
      return (
        yi: [.wedding, .sacrifice, .prayer, .opening, .trading],
        ji: [.legal, .travel, .moving]  // Stable/Fixed
      )
    case .zhi:
      return (
        yi: [.houseConst, .planting, .wedding],
        ji: [.travel, .moving, .opening]  // Holding means keeping status quo
      )
    case .po:
      return (
        yi: [.medical, .houseConst],  // Breaking helps destroy disease/old
        ji: [.wedding, .opening, .trading, .travel]  // Breakage is bad for new
      )
    case .wei:
      return (
        yi: [.worship, .sacrifice],  // Danger
        ji: [.climbing, .travel, .wedding, .houseConst]
      )
    case .cheng:
      return (
        yi: [.wedding, .opening, .trading, .travel, .moving, .houseConst],  // Success
        ji: [.legal]
      )
    case .shou:
      return (
        yi: [.trading, .sacrifice, .houseConst],  // Receive/Harvest
        ji: [.funeral, .medical, .travel]
      )
    case .kai:
      return (
        yi: [.wedding, .opening, .trading, .travel, .moving],  // Open
        ji: [.funeral, .groundBreaking]
      )
    case .bi:
      return (
        yi: [.sacrifice, .houseConst, .funeral],  // Close/Hide
        ji: [.opening, .trading, .travel, .medical]
      )
    }
  }
}

extension HuangliAction {
  static let legal = HuangliAction(rawValue: "诉讼") ?? .everything  // Fallback/Placeholder
  static let planting = HuangliAction(rawValue: "栽种") ?? .everything
  static let worship = HuangliAction(rawValue: "安香") ?? .everything
  static let climbing = HuangliAction(rawValue: "登高") ?? .everything
}

// MARK: - Calculator

public class CongChenCalculator {

  // MARK: - Core Calculation

  /// Calculate Shen Sha for a specific Day given the Month and Day GanZhi
  /// - Parameters:
  ///   - monthStem: Month Heavenly Stem
  ///   - monthBranch: Month Earthly Branch (Key determinant for most ShenSha)
  ///   - dayStem: Day Heavenly Stem
  ///   - dayBranch: Day Earthly Branch
  ///   - yearBranch: Year Branch (Optional, defaults to nil, if nil some year-based stars like JieSha might be inaccurate if not inferred)
  public static func calculateShenSha(
    monthStem: HeavenlyStem,
    monthBranch: EarthlyBranch,
    dayStem: HeavenlyStem,
    dayBranch: EarthlyBranch,
    yearBranch: EarthlyBranch? = nil
  ) -> [ShenShaType] {
    var result: [ShenShaType] = []

    // 1. 月破 (Yue Po): Day Branch clashes with Month Branch
    // "正山七水午兼子..." -> Simply: Month Branch opposite Day Branch
    if dayBranch == monthBranch.opposite {
      result.append(.yuePo)
      result.append(.daHao)  // Usually Da Hao accompanies Yue Po
      result.append(.riPo)
    }

    // Logic for JianChu (Po Day) overlap check not needed here, stored in JianChu enum

    // 2. 天德 (Tian De) - Based on Month Branch
    // "正丁二坤三壬四辛..."
    // Month(Zhi) -> Required Day Stem or Branch
    let tianDeMatch: Bool
    switch monthBranch {
    case .yin: tianDeMatch = (dayStem == .ding)
    case .mao: tianDeMatch = (dayBranch == .shen)  // Kun is Shen
    case .chen: tianDeMatch = (dayStem == .ren)
    case .si: tianDeMatch = (dayStem == .xin)
    case .wu: tianDeMatch = (dayBranch == .hai)  // Qian is Hai
    case .wei: tianDeMatch = (dayStem == .jia)
    case .shen: tianDeMatch = (dayStem == .gui)
    case .you: tianDeMatch = (dayBranch == .yin)  // Gen is Yin
    case .xu: tianDeMatch = (dayStem == .bing)
    case .hai: tianDeMatch = (dayStem == .yi)
    case .zi: tianDeMatch = (dayBranch == .si)  // Xun is Si
    case .chou: tianDeMatch = (dayStem == .geng)
    }
    if tianDeMatch { result.append(.tianDe) }

    // 3. 月德 (Yue De) - Based on Lunar Month Triple Harmony
    // Yin/Wu/Xu -> Bing, etc.
    if dayStem == monthBranch.sanHeGroup.stem {
      result.append(.yueDe)
    }

    // 4. 天乙贵人 (Tian Yi) - Based on Day Stem (Strictly speaking Year Stem or Day Stem)
    // "甲戊并牛羊, 乙己鼠猴乡..."
    // Use Day Stem for Daily Yi/Ji
    let isTianYi: Bool
    switch dayStem {
    case .jia, .wu: isTianYi = (dayBranch == .chou || dayBranch == .wei)
    case .yi, .ji: isTianYi = (dayBranch == .zi || dayBranch == .shen)
    case .bing, .ding: isTianYi = (dayBranch == .hai || dayBranch == .you)
    case .geng, .xin: isTianYi = (dayBranch == .wu || dayBranch == .yin)
    case .ren, .gui: isTianYi = (dayBranch == .mao || dayBranch == .si)
    }
    if isTianYi { result.append(.tianYi) }

    // 5. 三合 (San He) - Day Branch matches Month Branch Trine
    // This is a simplified check for compatibility
    let mIdx = monthBranch.index
    let dIdx = dayBranch.index
    if (dIdx == (mIdx + 4) % 12) || (dIdx == (mIdx + 8) % 12) {
      result.append(.sanHe)
    }

    // 6. 六合 (Liu He) - Day Branch combines with Month Branch
    // Zi-Chou, Yin-Hai, Mao-Xu, Chen-You, Si-Shen, Wu-Wei
    let isLiuHe: Bool
    switch monthBranch {
    case .zi: isLiuHe = (dayBranch == .chou)
    case .chou: isLiuHe = (dayBranch == .zi)
    case .yin: isLiuHe = (dayBranch == .hai)
    case .hai: isLiuHe = (dayBranch == .yin)
    case .mao: isLiuHe = (dayBranch == .xu)
    case .xu: isLiuHe = (dayBranch == .mao)
    case .chen: isLiuHe = (dayBranch == .you)
    case .you: isLiuHe = (dayBranch == .chen)
    case .si: isLiuHe = (dayBranch == .shen)
    case .shen: isLiuHe = (dayBranch == .si)
    case .wu: isLiuHe = (dayBranch == .wei)
    case .wei: isLiuHe = (dayBranch == .wu)
    }
    if isLiuHe { result.append(.liuHe) }

    // 7. 劫煞 (Jie Sha) - Based on Year Branch (or Day/Month SanHe interaction)
    // Usually: Year Branch -> Day Branch for "Year Jie Sha".
    if let yBranch = yearBranch {
      if dayBranch == yBranch.jieShaBranch {
        result.append(.jieSha)
      }
    }

    // 8. 五鬼 (Wu Gui) - Month Branch -> Day Stem/Branch
    // Song: "Zi-Ren, Chou-Yi, Yin-Wu..."
    // 子人丑乙寅午长，卯庚辰亥巳辛方，午戌未癸申丙上，酉丁戌巳亥甲当
    let isWuGui: Bool
    switch monthBranch {
    case .zi: isWuGui = (dayStem == .ren)
    case .chou: isWuGui = (dayStem == .yi)
    case .yin: isWuGui = (dayBranch == .wu)
    case .mao: isWuGui = (dayStem == .geng)
    case .chen: isWuGui = (dayBranch == .hai)
    case .si: isWuGui = (dayStem == .xin)
    case .wu: isWuGui = (dayBranch == .xu)
    case .wei: isWuGui = (dayStem == .gui)
    case .shen: isWuGui = (dayStem == .bing)
    case .you: isWuGui = (dayStem == .ding)
    case .xu: isWuGui = (dayBranch == .si)
    case .hai: isWuGui = (dayStem == .jia)
    }
    if isWuGui { result.append(.wuGui) }

    return result
  }

  // MARK: - Jian Chu Calculation

  public static func calculateJianChu(monthBranch: EarthlyBranch, dayBranch: EarthlyBranch)
    -> JianChu
  {
    // Jian Day is when Day Branch == Month Branch
    // Index difference.
    // If m = 2 (Yin), d = 2 (Yin) -> 0 -> Jian.
    // If m = 2, d = 3 (Mao) -> 1 -> Chu.
    let diff = (dayBranch.index - monthBranch.index + 12) % 12
    return JianChu.allCases[diff]
  }

  // MARK: - Yi/Ji Derivation

  /// Get Yi/Ji actions for a list of Shen Sha AND Jian Chu
  public static func getYiJi(
    shenShas: [ShenShaType],
    jianChu: JianChu? = nil
  ) -> (yi: [String], ji: [String]) {
    var yiSet = Set<HuangliAction>()
    var jiSet = Set<HuangliAction>()

    // 1. Incorporate Jian Chu if present
    if let jc = jianChu {
      let jcYiJi = jc.yiJi
      for action in jcYiJi.yi { yiSet.insert(action) }
      for action in jcYiJi.ji { jiSet.insert(action) }
    }

    // 2. Rules Mapping for Shen Sha
    for shen in shenShas {
      switch shen {
      case .tianDe, .yueDe:
        // 天德/月德: “百事吉”, can mitigate evils.
        yiSet.insert(.sacrifice)
        yiSet.insert(.prayer)
        yiSet.insert(.houseConst)
        yiSet.insert(.wedding)
        yiSet.insert(.travel)
        yiSet.insert(.moving)

      case .tianYi:
        // 天乙贵人: Good for meeting people, travel, general luck
        yiSet.insert(.travel)
        yiSet.insert(.trading)
        yiSet.insert(.wedding)

      case .sanHe, .liuHe:
        // Harmony: Good for Wedding, Trading, Cooperation
        yiSet.insert(.wedding)
        yiSet.insert(.trading)
        yiSet.insert(.engagement)

      case .yuePo, .daHao, .riPo:
        // 月破: "大事勿用"
        jiSet.insert(.everything)  // In practice this means almost all major events
        jiSet.insert(.wedding)
        jiSet.insert(.opening)
        jiSet.insert(.travel)

      case .zhuQue:
        // Disputes
        jiSet.insert(.trading)
        jiSet.insert(.engagement)

      case .jieSha:
        // Robbery: Avoid travel, moving, large money
        jiSet.insert(.travel)
        jiSet.insert(.moving)
        jiSet.insert(.trading)

      case .wuGui:
        // Five Ghosts: Avoid travel, sacrifice
        jiSet.insert(.travel)
        jiSet.insert(.sacrifice)
        jiSet.insert(.prayer)

      case .wangWang:
        jiSet.insert(.travel)
        jiSet.insert(.wedding)

      case .zhongRi:
        jiSet.insert(.funeral)  // Repeated sad events

      default:
        break
      }
    }

    // Logic Processing
    // If "Yue Po" is present, it crushes most "Yi".
    if shenShas.contains(.yuePo) || shenShas.contains(.riPo) {
      // Force major Ji
      return (
        yi: ["祭祀", "沐浴", "破屋", "坏垣"],  // Only minor cleaning/destructive things allowed
        ji: ["诸事不宜"]
      )
    }

    // Convert to sorted strings
    // Remove Ji from Yi if explicit
    for jiItem in jiSet {
      if jiItem == .everything {
        yiSet.removeAll()
        break
      }
      if yiSet.contains(jiItem) {
        // Conflict: Usually Ji prevails for safety
        yiSet.remove(jiItem)
      }
    }

    let yiStrings = yiSet.map { $0.rawValue }.sorted()
    let jiStrings = jiSet.map { $0.rawValue }.sorted()

    var finalYi = yiStrings
    var finalJi = jiStrings

    if finalYi.isEmpty { finalYi = ["平"] }
    if finalJi.isEmpty { finalJi = ["无"] }

    return (finalYi, finalJi)
  }

  // MARK: - Helpers

  /// Calculate by String (e.g. "甲子")
  /// - Parameters:
  ///   - monthGanZhi: e.g. "丙寅"
  ///   - dayGanZhi: e.g. "甲子"
  ///   - yearGanZhi: e.g. "丙午" (Optional, needed for JieSha)
  public static func calculateShenSha(
    monthGanZhi: String,
    dayGanZhi: String,
    yearGanZhi: String? = nil
  ) -> [ShenShaType] {
    guard monthGanZhi.count >= 2, dayGanZhi.count >= 2 else { return [] }

    let mStemChar = String(monthGanZhi.prefix(1))
    let mBranchChar = String(monthGanZhi.suffix(1))
    let dStemChar = String(dayGanZhi.prefix(1))
    let dBranchChar = String(dayGanZhi.suffix(1))

    var yBranch: EarthlyBranch? = nil
    if let yGZ = yearGanZhi, yGZ.count >= 2 {
      let yBranchChar = String(yGZ.suffix(1))
      yBranch = EarthlyBranch(rawValue: yBranchChar)
    }

    guard let mStem = HeavenlyStem(rawValue: mStemChar),
      let mBranch = EarthlyBranch(rawValue: mBranchChar),
      let dStem = HeavenlyStem(rawValue: dStemChar),
      let dBranch = EarthlyBranch(rawValue: dBranchChar)
    else {
      return []
    }

    return calculateShenSha(
      monthStem: mStem,
      monthBranch: mBranch,
      dayStem: dStem,
      dayBranch: dBranch,
      yearBranch: yBranch
    )
  }

  public static func calculateJianChu(monthGanZhi: String, dayGanZhi: String) -> JianChu? {
    guard monthGanZhi.count >= 2, dayGanZhi.count >= 2 else { return nil }
    let mBranchChar = String(monthGanZhi.suffix(1))
    let dBranchChar = String(dayGanZhi.suffix(1))
    guard let mBranch = EarthlyBranch(rawValue: mBranchChar),
      let dBranch = EarthlyBranch(rawValue: dBranchChar)
    else { return nil }
    return calculateJianChu(monthBranch: mBranch, dayBranch: dBranch)
  }
}
