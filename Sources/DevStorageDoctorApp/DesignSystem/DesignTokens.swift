import SwiftUI

// MARK: - Colors

extension Color {
    // Backgrounds
    static let bgBase      = Color(hex: 0x0F172A)
    static let bgSurface   = Color(hex: 0x1E293B)
    static let bgElevated  = Color(hex: 0x293548)
    static let bgOverlay   = Color(hex: 0x334155)

    // Text
    static let textPrimary   = Color(hex: 0xF8FAFC)
    static let textSecondary = Color(hex: 0x94A3B8)
    static let textMuted     = Color(hex: 0x64748B)

    // Borders
    static let borderSubtle  = Color(hex: 0x1E293B)
    static let borderDefault = Color(hex: 0x334155)
    static let borderStrong  = Color(hex: 0x475569)

    // Risk
    static let riskLow       = Color(hex: 0x22C55E)
    static let riskMedium    = Color(hex: 0xF59E0B)
    static let riskHigh      = Color(hex: 0xEF4444)
    static let riskManual    = Color(hex: 0xA78BFA)
    static let riskProtected = Color(hex: 0x64748B)
    static let riskUnsupported = Color(hex: 0x475569)

    // Accent
    static let accentPrimary = Color(hex: 0x22C55E)
    static let accentHover   = Color(hex: 0x16A34A)

    init(hex: UInt32) {
        let r = Double((hex >> 16) & 0xFF) / 255
        let g = Double((hex >> 8)  & 0xFF) / 255
        let b = Double( hex        & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

// MARK: - Typography

extension Font {
    static let displayLarge  = Font.system(size: 32, weight: .bold,   design: .default)
    static let displayMedium = Font.system(size: 22, weight: .semibold, design: .default)
    static let headingSmall  = Font.system(size: 17, weight: .semibold, design: .default)
    static let bodyBase      = Font.system(size: 15, weight: .regular, design: .default)
    static let bodySmall     = Font.system(size: 13, weight: .regular, design: .default)
    static let caption       = Font.system(size: 11, weight: .regular, design: .default)
    static let mono          = Font.system(size: 12, weight: .regular, design: .monospaced)
    static let monoBold      = Font.system(size: 12, weight: .medium,  design: .monospaced)
}

// MARK: - Spacing

enum Spacing {
    static let micro:   CGFloat = 2
    static let tight:   CGFloat = 4
    static let small:   CGFloat = 8
    static let base:    CGFloat = 12
    static let medium:  CGFloat = 16
    static let large:   CGFloat = 20
    static let xl:      CGFloat = 24
    static let xxl:     CGFloat = 32
}

// MARK: - Animation

extension Animation {
    static let micro    = Animation.easeOut(duration: 0.1)
    static let short    = Animation.easeOut(duration: 0.15)
    static let standard = Animation.easeOut(duration: 0.2)
    static let long     = Animation.easeInOut(duration: 0.3)
}
