import Foundation

class Card {
    
    var id = 0
    var name = ""
    var image = ""
    var description = ""
    var catId = 0
    
    init(id:Int, name:String, image:String, description:String, catId:Int)
    {
        self.id = id
        self.name = name
        self.image = image
        self.description = description
        self.catId = catId
    }
    

}