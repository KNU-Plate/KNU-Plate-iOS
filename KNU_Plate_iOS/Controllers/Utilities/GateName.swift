import Foundation

enum Gate: String {
    case northGate = "NORTH"
    case mainGate = "MAIN"
    case eastGate = "EAST"
    case westGate = "WEST"
    
    static func gateFromInt(number: Int) -> Gate? {
        switch number {
        case 0:
            return .northGate
        case 1:
            return .mainGate
        case 2:
            return .eastGate
        case 3:
            return .westGate
        default:
            return nil
        }
    }
}
