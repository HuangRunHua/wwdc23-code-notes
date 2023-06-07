import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

enum SlopeSubsetError: CustomStringConvertible, Error {
    case onlyApplicableToEnum
    
    var description: String {
        switch self {
        case .onlyApplicableToEnum: return "@EnumSubset can only be applied to an enum"
        }
    }
}

public struct SlopeSubsetMacro: MemberMacro {
    public static func expansion(
        of attribute: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        /// 如果`@SlopeSubset`关键字不是在`enum`前面添加则无效
        guard let enumDel = declaration.as(EnumDeclSyntax.self) else {
            throw SlopeSubsetError.onlyApplicableToEnum
        }
        
        guard let supersetType = attribute
            .attributeName.as(SimpleTypeIdentifierSyntax.self)?
            .genericArgumentClause?
            .arguments.first?
            .argumentType else {
            return []
        }
        
        let members = enumDel.memberBlock.members
        let caseDecls = members.compactMap { $0.decl.as(EnumCaseDeclSyntax.self)}
        let elements = caseDecls.flatMap { $0.elements }
        let initializer = try InitializerDeclSyntax("init?(_ slope: \(supersetType))") {
            try SwitchExprSyntax("switch slope") {
                for element in elements {
                    SwitchCaseSyntax(
                        """
                        case .\(element.identifier):
                            self = .\(element.identifier)
                        """
                    )
                }
                SwitchCaseSyntax("default: return nil")
            }
        }
        
        return [DeclSyntax(initializer)]
    }
}

@main
struct WWDCPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        SlopeSubsetMacro.self
    ]
}
