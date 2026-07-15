

import Foundation

struct MockProfile: Identifiable, Equatable {
    let id = UUID()

    let name: String
    let age: Int
    let profession: String
    let location: String
    let image: String
}
