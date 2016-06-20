import Foundation

class Deck {
    
    var id = 0
    var name = ""
    var color = ""
    var cards = [Card]()
    var image = ""
    
    init(id:Int, name:String, color:String, image:String)
    {
        self.id = id
        self.name = name
        self.color = color
        self.image = image
    }
    
    func getCards(id: Int) -> [Card] {
        
        return cards
    }
}