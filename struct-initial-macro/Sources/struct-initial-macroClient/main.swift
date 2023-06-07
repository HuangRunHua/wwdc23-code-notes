import struct_initial_macro
import Foundation

@StructInit
struct Book {
    var id: Int
    var title: String
    var subtitle: String
    var description: String
    var author: String
}
