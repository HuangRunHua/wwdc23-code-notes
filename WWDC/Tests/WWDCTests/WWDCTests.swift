import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import WWDCMacros

//let testMacros: [String: Macro.Type] = [
//    "stringify": StringifyMacro.self,
//]
//
//final class WWDCTests: XCTestCase {
//    func testMacro() {
//        assertMacroExpansion(
//            """
//            #stringify(a + b)
//            """,
//            expandedSource: """
//            (a + b, "a + b")
//            """,
//            macros: testMacros
//        )
//    }
//
//    func testMacroWithStringLiteral() {
//        assertMacroExpansion(
//            #"""
//            #stringify("Hello, \(name)")
//            """#,
//            expandedSource: #"""
//            ("Hello, \(name)", #""Hello, \(name)""#)
//            """#,
//            macros: testMacros
//        )
//    }
//}

let testMacros: [String: Macro.Type] = [
    "SlopeSubset": SlopeSubsetMacro.self
]

final class WWDCTests: XCTestCase {
    func testSlopesubset() {
        assertMacroExpansion(
            """
            @SlopeSubset
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
}


