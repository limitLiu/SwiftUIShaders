import Foundation

nonisolated extension Double {
  public var radians: Self {
    Self.π * self / 180
  }

  public static var π: Self { pi }

  public nonisolated func rounded(to places: Int) -> Double {
    let multiplier = 10.0 ** Double(places)
    return (self * multiplier).rounded() / multiplier
  }
}

nonisolated extension [UInt8] {
  public subscript(substring range: Range<Int>, encoding: String.Encoding = .ascii) -> String? {
    guard range.lowerBound >= 0, range.upperBound <= count else { return .none }
    return String(bytes: self[range], encoding: encoding)
  }

  public subscript(on range: ClosedRange<Int>) -> ArraySlice<UInt8>? {
    guard range.lowerBound >= 0, range.upperBound < count else { return .none }
    return self[range]
  }

  public subscript(on range: Range<Int>) -> ArraySlice<UInt8>? {
    guard range.lowerBound >= 0, range.upperBound <= count else { return .none }
    return self[range]
  }

  public subscript(on range: PartialRangeFrom<Int>) -> ArraySlice<UInt8>? {
    guard range.lowerBound >= 0, range.lowerBound < count else { return .none }
    return self[range]
  }
}

nonisolated extension Collection<UInt8> {
  public var u16: UInt16 {
    prefix(2).reduce(0) { $0 << 8 | UInt16($1) }
  }

  public var u32: UInt32 {
    prefix(4).reduce(0) { $0 << 8 | UInt32($1) }
  }

  public var u64: UInt64 {
    prefix(8).reduce(0) { $0 << 8 | UInt64($1) }
  }

  public var date: Date {
    Date(timeIntervalSince1970: TimeInterval(u32))
  }
}

nonisolated extension Optional {
  public var isSome: Bool {
    self != nil
  }

  public var isNone: Bool {
    !isSome
  }
}

nonisolated extension Array {
  public subscript(at index: Index) -> Element? {
    indices.contains(index) ? self[index] : .none
  }

  public var tail: Int {
    count - 1
  }
}
