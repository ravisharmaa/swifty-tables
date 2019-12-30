import Foundation

struct Todo: Codable {
    
    var user_id: Int
    var id: Int
    var title: String
    var completed: Bool
    
    
    
    enum CodingKeys: String, CodingKey {
        
        case user_id = "userId"
        case id = "id"
        case title = "title"
        case completed = "completed"
    }
    
    
}
