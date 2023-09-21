import CoreGraphics
import UIKit

enum MontserratFontType: String {
    case regular = "Montserrat"
    case bold = "Montserrat-Bold"
    case semibold = "Montserrat-SemiBold"
}

class MontserratFont {
    static func makefont(name: MontserratFontType, size: CGFloat)  -> UIFont {
        return UIFont(name: name.rawValue, size: size)!
    }
}
