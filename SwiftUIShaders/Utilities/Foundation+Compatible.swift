import Foundation

public nonisolated struct FoundationEx<T> {
  public let t: T
  public init(_ t: T) {
    self.t = t
  }
}

extension FoundationEx: Sendable where T: Sendable {}

public nonisolated protocol FoundationExCompatible {
  associatedtype E
  static var ex: FoundationEx<E>.Type { get set }
  var ex: FoundationEx<E> { get set }
}

public extension FoundationExCompatible {
  nonisolated static var ex: FoundationEx<Self>.Type {
    get { FoundationEx<Self>.self }
    set {}
  }

  nonisolated var ex: FoundationEx<Self> {
    get { FoundationEx(self) }
    set {}
  }
}

extension String: FoundationExCompatible {}
extension Double: FoundationExCompatible {}
extension Int: FoundationExCompatible {}
extension UInt8: FoundationExCompatible {}
extension UInt16: FoundationExCompatible {}
nonisolated extension Date: FoundationExCompatible {}
extension Data: FoundationExCompatible {}
extension Array: FoundationExCompatible {}

public extension FoundationEx where T == Int {
  nonisolated func fromRawValue<R: RawRepresentable>(for type: R.Type) -> R? where T == R.RawValue {
    R(rawValue: t)
  }
}

public extension FoundationEx where T == UInt8 {
  nonisolated var hex: String {
    String(format: "%02X", t)
  }
}

public extension FoundationEx where T == String {
  nonisolated var date: Date? {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM/dd"
    return formatter.date(from: t)
  }

  nonisolated func time(dateFormat: String = "yyyy/MM/dd") -> Date? {
    let formatter = DateFormatter()
    formatter.dateFormat = dateFormat
    return formatter.date(from: t)
  }

  nonisolated var chunk: [UInt8]? {
    if t.count % 2 == 0 {
      var current = t.startIndex
      var result: [UInt8] = []
      while current < t.endIndex {
        let next = t.index(current, offsetBy: 2)
        let pair = String(t[current ..< next])
        if let byte = UInt8(pair, radix: 16) {
          result.append(byte)
        } else {
          return .none
        }
        current = next
      }
      return result
    } else {
      return .none
    }
  }
}

public nonisolated enum TimeKind {
  case year(Int)
  case month(Int)
  case day(Int)
  case hour(Int)
  case minute(Int)
  case second(Int)
}

public extension FoundationEx where T == Date {
  nonisolated func stringify(
    _ dateFormat: String = "yyyy/MM/dd",
    locale: Locale = Locale(identifier: "en_US"),
  ) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = dateFormat
    formatter.locale = locale
    return formatter.string(from: t)
  }

  nonisolated func age(_ components: Set<Calendar.Component>? = [.year]) -> String {
    let calendar = Calendar.current
    let d = calendar.dateComponents(components!, from: t, to: Date())
    if let year = d.year {
      if year == 0, let month = d.month {
        return "\(month) 个月"
      } else {
        return "\(year) 岁"
      }
    }
    return ""
  }

  nonisolated func isSameDay(_ other: Date) -> Bool {
    Calendar.current.isDate(t, inSameDayAs: other)
  }

  nonisolated func add(_ kind: TimeKind) -> Date {
    let (component, value): (Calendar.Component, Int) =
      switch kind {
      case let .year(value): (.year, value)
      case let .month(value): (.month, value)
      case let .day(value): (.day, value)
      case let .hour(value): (.hour, value)
      case let .minute(value): (.minute, value)
      case let .second(value): (.second, value)
      }
    return Calendar.current
      .date(byAdding: component, value: value, to: t)!
  }

  nonisolated func subtract(_ kind: TimeKind) -> Date {
    let (component, value): (Calendar.Component, Int) =
      switch kind {
      case let .year(value): (.year, value)
      case let .month(value): (.month, value)
      case let .day(value): (.day, value)
      case let .hour(value): (.hour, value)
      case let .minute(value): (.minute, value)
      case let .second(value): (.second, value)
      }
    return Calendar.current
      .date(byAdding: component, value: -value, to: t)!
  }

  nonisolated func numberAge(_ components: Set<Calendar.Component>? = [.year]) -> String {
    let calendar = Calendar.current
    let d = calendar.dateComponents(components!, from: t, to: Date())
    if let year = d.year {
      return String(year)
    }
    return ""
  }

  nonisolated func from(hm: (Int, Int)) -> Date? {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month, .day], from: t)
    var dateComponents = components
    dateComponents.hour = hm.0
    dateComponents.minute = hm.1
    return calendar.date(from: dateComponents)
  }

  nonisolated var diffDays: Int {
    let calendar = Calendar.current
    let d = calendar.dateComponents([.day], from: t, to: Date())
    return d.day ?? 0
  }

  nonisolated var months: Int {
    let now = Date()
    return t.ex.year == now.ex.year
      ? now.ex.month
      : Calendar.current.range(of: .month, in: .year, for: t)!.count
  }

  nonisolated var days: Int {
    let now = Date()
    return (t.ex.year, t.ex.month) == (now.ex.year, now.ex.month)
      ? now.ex.day
      : Calendar.current.range(of: .day, in: .month, for: t)!.count
  }

  nonisolated var dayList: [Date] {
    let calendar = Calendar.current
    let range = calendar.range(of: .day, in: .month, for: t)!
    return range.map {
      calendar.date(
        byAdding: .day,
        value: $0 - 1,
        to: calendar.date(from: calendar.dateComponents([.year, .month], from: t))!,
      )!
    }
  }

  nonisolated var ymd: (Int, Int, Int) {
    let calendar = Calendar.current
    let dateComponents = calendar.dateComponents([.year, .month, .day], from: t)
    guard let year = dateComponents.year, let month = dateComponents.month, let day = dateComponents.day else {
      fatalError("Failed to get ymd")
    }
    return (year, month, day)
  }

  nonisolated var hm: (Int, Int) {
    (t.ex.hms.0, t.ex.hms.1)
  }

  nonisolated var hms: (Int, Int, Int) {
    let calendar = Calendar.current
    let dateComponents = calendar.dateComponents([.hour, .minute, .second], from: t)
    guard let hour = dateComponents.hour, let minute = dateComponents.minute, let second = dateComponents.second else {
      fatalError("Failed to get hms")
    }
    return (hour, minute, second)
  }

  nonisolated var year: Int {
    t.ex.ymd.0
  }

  nonisolated var month: Int {
    t.ex.ymd.1
  }

  nonisolated var day: Int {
    t.ex.ymd.2
  }

  nonisolated var hour: Int {
    t.ex.hms.0
  }

  nonisolated var minute: Int {
    t.ex.hms.1
  }

  nonisolated var second: Int {
    t.ex.hms.2
  }

  nonisolated var startOfDay: Date {
    Calendar.current.startOfDay(for: t)
  }

  nonisolated var startOfMonth: Date {
    let calendar = Calendar.current
    let dateComponents = calendar.dateComponents([.year, .month], from: t)
    return calendar.date(from: dateComponents)!
  }

  nonisolated var endOfMonth: Date {
    let calendar = Calendar.current
    var dateComponents = calendar.dateComponents([.year, .month], from: t)
    dateComponents.day = 0
    dateComponents.month! += 1
    return calendar.date(from: dateComponents)!
  }

  nonisolated static func from(ymd: (Int, Int, Int)) -> Date? {
    var dateComponents = DateComponents()
    dateComponents.year = ymd.0
    dateComponents.month = ymd.1
    dateComponents.day = ymd.2
    return Calendar.current.date(from: dateComponents)
  }

  nonisolated static func from(hms: (Int, Int, Int)) -> Date? {
    let now = Date.now
    var dateComponents = DateComponents()
    dateComponents.year = now.ex.year
    dateComponents.month = now.ex.month
    dateComponents.day = now.ex.day
    dateComponents.hour = hms.0
    dateComponents.minute = hms.1
    dateComponents.second = hms.2
    return Calendar.current.date(from: dateComponents)
  }

  nonisolated static func from(hm: (Int, Int)) -> Date? {
    var dateComponents = DateComponents()
    dateComponents.hour = hm.0
    dateComponents.minute = hm.1
    return Calendar.current.date(from: dateComponents)
  }

  nonisolated var dayRange: (Date, Date) {
    let calendar = Calendar.current
    let start = calendar.startOfDay(for: t)
    let end = calendar.date(byAdding: .day, value: 1, to: start)!
    return (start, end)
  }

  nonisolated var timeIntervalSinceStartOfDay: TimeInterval {
    t.timeIntervalSince(Calendar.current.startOfDay(for: t))
  }

  nonisolated static var tomorrow: Date {
    Date().ex.dayRange.1
  }

  nonisolated var weekday: Int {
    Calendar.current.component(.weekday, from: t)
  }
}

public extension FoundationEx where T == Data {
  nonisolated func toMap() -> [UInt16: [UInt8]]? {
    guard t.count >= 1 else { return .none }
    return [UInt16(t[0]) | UInt16(t[1]) << 8: t.dropFirst(2).map(\.self)]
  }

  nonisolated struct HexEncodingOptions: OptionSet, Sendable {
    nonisolated static let upperCase = HexEncodingOptions(rawValue: 1)
    nonisolated static let reverseEndianness = HexEncodingOptions(rawValue: 2)

    public let rawValue: Int

    public init(rawValue: Int) {
      self.rawValue = rawValue << 0
    }
  }

  nonisolated func hexEncodedString(
    options: HexEncodingOptions = [],
    separator: String = "",
  )
    -> String {
    let format = options.contains(.upperCase) ? "%02hhX" : "%02hhx"

    var bytes = t
    if options.contains(.reverseEndianness) {
      bytes.reverse()
    }
    return
      bytes
        .map { String(format: format, $0) }
        .joined(separator: separator)
  }
}

public extension FoundationEx where T == Double {
  nonisolated var hex: [UInt8] {
    var this = Int64(t)
    var hexSequence: [UInt8] = []
    while this > 0 {
      let remainder = this % 256
      hexSequence.insert(UInt8(remainder), at: 0)
      this /= 256
    }
    return hexSequence
  }

  nonisolated var fahrenheit: Double {
    t * 9 / 5 + 32
  }

  nonisolated var celsius: Double {
    (t - 32) * 5 / 9
  }

  nonisolated var date: Date {
    Date(timeIntervalSince1970: t)
  }
}

nonisolated protocol Binary {
  var bin: [UInt8] { get }
}

extension UInt16: Binary {
  public nonisolated var bin: [UInt8] {
    [
      UInt8((self >> 8) & 0xFF),
      UInt8(self & 0xFF),
    ]
  }
}

extension UInt32: Binary {
  public nonisolated var bin: [UInt8] {
    [
      UInt8((self >> 24) & 0xFF),
      UInt8((self >> 16) & 0xFF),
      UInt8((self >> 8) & 0xFF),
      UInt8(self & 0xFF),
    ]
  }
}
