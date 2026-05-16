import Foundation

precedencegroup SingleForwardPipe {
  associativity: left
  higherThan: BitwiseShiftPrecedence
}

infix operator |>: SingleForwardPipe

public nonisolated func |> <T, U>(_ value: T, _ fn: (T) -> U) -> U {
  fn(value)
}

public nonisolated func ignore(_ value: some Any) {}

infix operator **: MultiplicationPrecedence

public nonisolated func ** (_ x: Decimal, y: Int) -> Decimal {
  pow(x, y)
}

public nonisolated func ** (_ x: Float, y: Float) -> Float {
  powf(x, y)
}

public nonisolated func ** (_ x: Double, y: Double) -> Double {
  pow(x, y)
}

/// 左开右闭
infix operator .~: MultiplicationPrecedence

public nonisolated struct LeftOpenRightClosedRange<Bound: Comparable>: RangeExpression {
  let lowerBound: Bound
  let upperBound: Bound

  init(_ lowerBound: Bound, _ upperBound: Bound) {
    self.lowerBound = lowerBound
    self.upperBound = upperBound
  }

  public func contains(_ value: Bound) -> Bool {
    value > lowerBound && value <= upperBound
  }

  public func relative<C: Collection>(to collection: C) -> Range<C.Index> where C.Index == Bound {
    let startIndex = collection.index(after: collection.startIndex)
    let endIndex = collection.endIndex
    return startIndex ..< endIndex
  }
}

public nonisolated func .~ <T: Comparable>(lhs: T, rhs: T) -> LeftOpenRightClosedRange<T> {
  LeftOpenRightClosedRange(lhs, rhs)
}

/// 左开右开
infix operator .~<: MultiplicationPrecedence

public nonisolated struct LeftOpenRightOpenRange<Bound: Comparable>: RangeExpression {
  let lowerBound: Bound
  let upperBound: Bound

  init(_ lowerBound: Bound, _ upperBound: Bound) {
    self.lowerBound = lowerBound
    self.upperBound = upperBound
  }

  public func contains(_ value: Bound) -> Bool {
    value > lowerBound && value < upperBound
  }

  public func relative<C: Collection>(to collection: C) -> Range<C.Index> where C.Index == Bound {
    let start = collection.index(after: lowerBound)
    let end = upperBound
    return start ..< end
  }
}

public nonisolated func .~< <T: Comparable>(lhs: T, rhs: T) -> LeftOpenRightOpenRange<T> {
  LeftOpenRightOpenRange(lhs, rhs)
}

infix operator =~: ComparisonPrecedence

public nonisolated func =~ (a: Float, b: Float) -> Bool {
  fabsf(a - b) < Float.ulpOfOne
}

public nonisolated func =~ (a: CGFloat, b: CGFloat) -> Bool {
  abs(a - b) < CGFloat.ulpOfOne
}

public nonisolated func =~ (a: Double, b: Double) -> Bool {
  fabs(a - b) < Double.ulpOfOne
}

infix operator !=~: ComparisonPrecedence

public nonisolated func !=~ (a: Float, b: Float) -> Bool {
  !(a =~ b)
}

public nonisolated func !=~ (a: CGFloat, b: CGFloat) -> Bool {
  !(a =~ b)
}

public nonisolated func !=~ (a: Double, b: Double) -> Bool {
  !(a =~ b)
}

infix operator <=~: ComparisonPrecedence

public nonisolated func <=~ (a: Float, b: Float) -> Bool {
  a =~ b || a < b
}

public nonisolated func <=~ (a: CGFloat, b: CGFloat) -> Bool {
  a =~ b || a < b
}

public nonisolated func <=~ (a: Double, b: Double) -> Bool {
  a =~ b || a < b
}

infix operator >=~: ComparisonPrecedence

public nonisolated func >=~ (a: Float, b: Float) -> Bool {
  a =~ b || a > b
}

public nonisolated func >=~ (a: CGFloat, b: CGFloat) -> Bool {
  a =~ b || a > b
}

public nonisolated func >=~ (a: Double, b: Double) -> Bool {
  a =~ b || a > b
}
