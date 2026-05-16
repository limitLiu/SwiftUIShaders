import UIKit
import SwiftUI

public struct UIKitEx<T> {
  public let t: T
  public init(_ t: T) {
    self.t = t
  }
}

public protocol UIKitExCompatible {
  associatedtype E
  static var ex: UIKitEx<E>.Type { get set }
  var ex: UIKitEx<E> { get set }
}

public extension UIKitExCompatible {
  static var ex: UIKitEx<Self>.Type {
    get { UIKitEx<Self>.self }
    set {}
  }
  var ex: UIKitEx<Self> {
    get { UIKitEx(self) }
    set {}
  }
}

extension UIImage: UIKitExCompatible {}

extension UIKitEx where T == UIImage {
  var img: Image { Image(uiImage: t) }
}
