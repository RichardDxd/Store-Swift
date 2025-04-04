import Foundation

struct Category : Codable, Identifiable, Hashable {
    let id : Int
    let nombre : String
}

struct Store : Codable, Identifiable, Hashable {
    let id : Int
    let nombre : String
}