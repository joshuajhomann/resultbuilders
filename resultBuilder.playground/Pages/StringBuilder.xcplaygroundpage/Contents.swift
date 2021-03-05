import Foundation

@resultBuilder
struct AttributedStringBuilder {

  typealias Expression = CustomStringConvertible
  typealias Component = String
  typealias FinalResult = NSAttributedString

  static func buildBlock(_ components: Component...) -> Component {
    components.joined()
  }

  static func buildExpression(_ expression: Expression) -> Component {
    String(describing: expression)
  }

  static func buildOptional(_ component: Component?) -> Component {
    component ?? ""
  }

  static func buildEither(first component: Component) -> Component {
    component
  }

  static func buildEither(second component: Component) -> Component {
    component
  }

  static func buildArray(_ components: [Component]) -> Component {
    components.joined()
  }

  static func buildFinalResult(_ component: Component) -> FinalResult {
    NSAttributedString(string: component)
  }

}

struct Space: CustomStringConvertible {
  var description: String { " " }
}

struct LineBreak: CustomStringConvertible {
  var description: String {  "\n" }
}

extension NSAttributedString {
  convenience init(@AttributedStringBuilder content: () -> NSAttributedString) {
    self.init(attributedString: content())
  }
}

var b = Int(Date().timeIntervalSince1970) % 2 == 0
var c = Int(Date().timeIntervalSince1970) % 2 == 0 ? 1 : nil
var d = [1,2,3,4,5]

let a = NSAttributedString {
  "hello"
  Space()
  42
  LineBreak()
  "I am a String"
  LineBreak()
  if b {
    "the date is even:"
  } else {
    "the date is odd:"
  }
  Space()
  b
  LineBreak()
  if let value = c {
    "C has a value"
  }
  LineBreak()
  for item in d {
    item
    Space()
  }
}

print(a)
