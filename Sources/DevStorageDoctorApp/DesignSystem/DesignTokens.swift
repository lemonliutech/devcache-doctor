import SwiftUI

// MARK: - Spacing

enum Spacing {
    static let micro:  CGFloat = 2
    static let tight:  CGFloat = 4
    static let small:  CGFloat = 8
    static let base:   CGFloat = 12
    static let medium: CGFloat = 16
    static let large:  CGFloat = 20
    static let xl:     CGFloat = 24
    static let xxl:    CGFloat = 32
}

// MARK: - Risk Colors (semantic, not theme-specific)

extension Color {
    static let riskLow        = Color.green
    static let riskMedium     = Color.orange
    static let riskHigh       = Color.red
    static let riskManual     = Color.purple
    static let riskProtected  = Color.secondary
    static let riskUnsupported = Color(nsColor: .tertiaryLabelColor)
}

// MARK: - Animation

extension Animation {
    static let snappy  = Animation.easeOut(duration: 0.15)
    static let standard = Animation.easeInOut(duration: 0.2)
}
