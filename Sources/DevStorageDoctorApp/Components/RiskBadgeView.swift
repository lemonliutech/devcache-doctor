import SwiftUI
import DevStorageCore

struct RiskBadgeView: View {
    let riskLevel: RiskLevel

    var body: some View {
        HStack(spacing: Spacing.tight) {
            if riskLevel == .high {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.caption)
                    .foregroundStyle(color)
            } else {
                Circle()
                    .fill(color)
                    .frame(width: 6, height: 6)
            }
            Text(label)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(color)
        }
        .padding(.horizontal, Spacing.small)
        .padding(.vertical, 3)
        .background(color.opacity(0.12))
        .clipShape(Capsule())
    }

    private var label: String {
        switch riskLevel {
        case .low:          return "Low Risk"
        case .medium:       return "Medium Risk"
        case .high:         return "High Risk"
        case .manualReview: return "Manual Review"
        case .protected:    return "Protected"
        case .unsupported:  return "Unsupported"
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
