import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import WWDCMacros

let testMacros: [String: Macro.Type] = [
    "EnumSubset": SlopeSubsetMacro.self
]

final class WWDCTests: XCTestCase {
    func testSlopesubset() {
        assertMacroExpansion(
            """
            @EnumSubset<Slope>
            enum Easyslope {
                case beginnersParadise
                case practiceRun
            }
            """, expandedSource:
            """
            
            enum Easyslope {
                case beginnersParadise
                case practiceRun
                init?(_ slope: Slope) {
                    switch slope {
                    case .beginnersParadise:
                        self = .beginnersParadise
                    case .practiceRun:
                        self = .practiceRun
                    default:
                        return nil
                    }
                }
            }
            """, macros: testMacros)
    }
    
    func testSlopesubsetOnStruct() {
        assertMacroExpansion(
            """
            @EnumSubset<Slope>
            struct skier {
            }
            """, expandedSource:
            """
            
            struct skier {
            }
            """,
            diagnostics: [
                DiagnosticSpec(message: "@EnumSubset can only be applied to an enum", line: 1, column: 1)
            ],
            macros: testMacros)
    }
    
    
}


