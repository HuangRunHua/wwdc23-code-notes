import WWDC

enum Slope {
    case beginnersParadise
    case practiceRun
    case livingRoom
    case olympicRun
    case blackBeauty
}

@EnumSubset<Slope>
enum EasySlope {
    case beginnersParadise
    case practiceRun
    
    var slope: Slope {
        switch self {
        case .beginnersParadise:
            return .beginnersParadise
        case .practiceRun:
            return .practiceRun
        }
    }
}

//@EnumSubset
//struct Skier {}
