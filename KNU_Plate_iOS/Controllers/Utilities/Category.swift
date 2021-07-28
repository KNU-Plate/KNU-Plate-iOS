import Foundation

struct Category {
    var gate: String?
    var foodCategory: String?
    init(gate: String? = nil, foodCategory: String? = nil) {
        self.gate = gate
        self.foodCategory = foodCategory
    }
}

func gateKoreanToEnglish(gate: String) -> String {
    switch gate {
    case "북문":
        return "NORTH"
    case "정문":
        return "MAIN"
    case "동문":
        return "EAST"
    case "서문":
        return "WEST"
    default:
        return ""
    }
}
