import SwiftUI
import DevStorageCore

struct RiskBadgeView: View {
    let riskLevel: RiskLevel

    var body: some View {
        Label(label, systemImage: icon)
            .font(.caption)
            .foregroundStyle(color)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(color.opacity(0.1), in: Capsule())
    }

    private var label: String {
        switch riskLevel {
        case .low:          return "Low"
        case .medium:       return "Medium"
        case .high:         return "High"
        case .manualReview: return "Manual"
        case .protected:    return "Protected"
        case .unsupported:  return "N/A"
        }
    }

    private var icon: String {
        switch riskLevel {
        case .low:          return "checkmark.circle"
        case .medium:       return "exclamationmark.circle"
        case .high:         return "exclamationmark.triangle"
        case .manualReview: return "hand.raised"
        case .protected:    return "lock"
        case .unsupported:  return "minus.circle"
        }
    }

    private var color: Color {
        switch riskLevel {
        case .low:          return .riskLow
        case .medium:       return .riskMedium
        case .high:         return .riskHigh
        case .manualReview: return .riskManual
        case .protected:    return .riskProtected
        case .unsupported:  return .riskUnsupported
        }
    }
}
