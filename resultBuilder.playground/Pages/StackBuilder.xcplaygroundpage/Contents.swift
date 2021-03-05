import UIKit
import PlaygroundSupport

protocol ViewComponent {
  var view: UIView { get }
  func tintColor(_: UIColor) -> Self
  func huggingPriority(horizontal: UILayoutPriority, vertical: UILayoutPriority) -> Self
  func huggingPriority(vertical: UILayoutPriority) -> Self
  func huggingPriority(horizontal: UILayoutPriority) -> Self
  func compressionResistancePriority(horizontal: UILayoutPriority, vertical: UILayoutPriority) -> Self
  func compressionResistancePriority(vertical: UILayoutPriority) -> Self
  func compressionResistancePriority(horizontal: UILayoutPriority) -> Self
  func backgroundColor(_: UIColor) -> Self
}

extension ViewComponent {
  func tintColor(_ color: UIColor) -> Self {
    view.tintColor = color
    return self
  }
  func huggingPriority(horizontal: UILayoutPriority, vertical: UILayoutPriority) -> Self {
    huggingPriority(horizontal: horizontal, vertical: vertical)
  }
  func huggingPriority(vertical: UILayoutPriority) -> Self {
    huggingPriority(horizontal: nil, vertical: vertical)
  }
  func huggingPriority(horizontal: UILayoutPriority) -> Self {
    huggingPriority(horizontal: horizontal, vertical: nil)
  }
  func compressionResistancePriority(horizontal: UILayoutPriority, vertical: UILayoutPriority) -> Self {
    compressionResistancePriority(horizontal: horizontal, vertical: vertical)
  }
  func compressionResistancePriority(vertical: UILayoutPriority) -> Self {
    compressionResistancePriority(horizontal: nil, vertical: vertical)
  }
  func compressionResistancePriority(horizontal: UILayoutPriority) -> Self {
    compressionResistancePriority(horizontal: horizontal, vertical: nil)
  }
  func backgroundColor(_ color: UIColor) -> Self {
    view.backgroundColor = color
    return self
  }
  private func huggingPriority(horizontal: UILayoutPriority? = nil, vertical: UILayoutPriority? = nil) -> Self {
    if let horizontal = horizontal {
      view.setContentHuggingPriority(horizontal, for: .horizontal)
    }
    if let vertical = vertical {
      view.setContentHuggingPriority(vertical, for: .vertical)
    }
    return self
  }
  private func compressionResistancePriority(horizontal: UILayoutPriority? = nil, vertical: UILayoutPriority? = nil) -> Self {
    if let horizontal = horizontal {
      view.setContentCompressionResistancePriority(horizontal, for: .horizontal)
    }
    if let vertical = vertical {
      view.setContentCompressionResistancePriority(vertical, for: .vertical)
    }
    return self
  }
}

struct WrapperView: ViewComponent {
  var view: UIView
}

struct Label: ViewComponent {
  var view: UIView { label }
  private let label = UILabel()
  init(_ text: String) {
    label.text = text
  }
  func fontSize(_ points: CGFloat) -> Self {
    label.font = UIFont.systemFont(ofSize: points)
    return self
  }
  func foregroundColor(_ color: UIColor) -> Self {
    label.textColor = color
    return self
  }
}

struct Image: ViewComponent {
  var view: UIView { imageView }
  private let imageView = UIImageView()
  init(_ image: UIImage) {
    imageView.image = image
  }
  init(systemName: String) {
    imageView.image = UIImage(systemName: systemName)
  }
}

@resultBuilder
struct StackViewBuilder {

  typealias Expression = ViewComponent
  typealias Component = [ViewComponent]
  typealias FinalResult = UIStackView


  static func buildBlock(_ components: Component...) -> Component {
    components.flatMap { $0 }
  }

  static func buildExpression(_ expression: Expression) -> Component {
    [expression]
  }

  static func buildOptional(_ component: Component?) -> Component {
    component.map { $0 } ?? []
  }

  static func buildEither(first component: Component) -> Component {
    component
  }

  static func buildEither(second component: Component) -> Component {
    component
  }

  static func buildArray(_ components: [Component]) -> Component {
    components.flatMap { $0 }
  }

  static func buildFinalResult(_ component: Component) -> FinalResult {
    let stack = UIStackView(arrangedSubviews: component.map(\.view))
    stack.translatesAutoresizingMaskIntoConstraints = false
    return stack
  }
}

struct Color: ViewComponent {
  private(set) var view: UIView
  init(_ color: UIColor) {
    view = UIView()
    view.backgroundColor = color
    view.setContentHuggingPriority(.init(1), for: .vertical)
    view.setContentHuggingPriority(.init(1), for: .horizontal)
    view.setContentCompressionResistancePriority(.init(1), for: .vertical)
    view.setContentCompressionResistancePriority(.init(1), for: .horizontal)
  }
  func size(minWidth: CGFloat?, minHeight: CGFloat?) -> Self {
    if let minWidth = minWidth {
      let constraint = view.widthAnchor.constraint(greaterThanOrEqualToConstant:  minWidth)
      view.addConstraint(constraint)
    }
    if let minHeight = minHeight {
      let constraint = view.heightAnchor.constraint(greaterThanOrEqualToConstant: minHeight)
      view.addConstraint(constraint)
    }
    return self
  }
}

struct HStack: ViewComponent {
  var view: UIView { stack }
  private let stack: UIStackView
  init(
    alignment: UIStackView.Alignment = .center,
    spacing: CGFloat = 0,
    @StackViewBuilder content: () -> UIStackView
  ) {
    stack = UIView.Stack(axis: .horizontal, alignment: alignment, spacing: spacing, content: content)
  }
}

struct VStack: ViewComponent {
  var view: UIView { stack }
  private let stack: UIStackView
  init(
    alignment: UIStackView.Alignment = .center,
    spacing: CGFloat = 0,
    @StackViewBuilder content: () -> UIStackView
  ) {
    stack = UIView.Stack(axis: .vertical, alignment: alignment, spacing: spacing, content: content)
  }
}

extension UIView {
  static func Stack(
    axis: NSLayoutConstraint.Axis = .horizontal,
    alignment: UIStackView.Alignment = .center,
    distribution: UIStackView.Distribution = .equalSpacing,
    spacing: CGFloat = 0,
    @StackViewBuilder content: () -> UIStackView
  ) -> UIStackView {
    let stack = content()
    stack.alignment = alignment
    stack.spacing = spacing
    stack.axis = axis
    stack.distribution = distribution
    return stack
  }
}


final class ViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    let colors = [#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1), #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1), #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1), #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)]
    let symbols = ["thermometer.snowflake", "gift.circle.fill", "star.circle.fill", "message.circle.fill", "folder.circle.fill", "link.circle.fill"]
    let stack = VStack(alignment: .leading, spacing: 10) {
       Label("This is a heading")
         .fontSize(24)
         .foregroundColor(.gray)
         .backgroundColor(.black)
      for element in zip(colors, symbols) {
        let (color, symbol) = element
        HStack {
          Color(color)
            .size(minWidth: 24, minHeight: 24)
          Image(systemName: symbol)
          Label(symbol)
            .fontSize(24)
            .foregroundColor(color)
        }
      }
    }
    .view
    view.addSubview(stack)
    NSLayoutConstraint.activate([
      stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
    ])
  }
}

PlaygroundPage.current.liveView = ViewController()

