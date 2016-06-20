import UIKit
import Foundation

class DeckSelectViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var cvwDeckCollection: UICollectionView!
    
    var amountSelected = 0
    
    var decks = [Deck]()
    var selectedDecks = [Deck]()
    
    override func viewDidLoad() {
        
        jsonload()
        checkIfReady()
        
        self.performSegueWithIdentifier("popoverDecksTutorial1", sender: self)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return decks.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("DeckCollectionViewCell", forIndexPath: indexPath) as! DeckCollectionViewCell
        
        let currentRow = indexPath.row
        let currentDeck = self.decks[currentRow]
        cell.imvBackgroundImage.image = UIImage(named: currentDeck.image)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        
        amountSelected = 0
        
        let cell : DeckCollectionViewCell = collectionView.cellForItemAtIndexPath(indexPath) as! DeckCollectionViewCell
        
        if (cell.selectedToggle == false) {
            
            selectedDecks.append(decks[indexPath.row])
            
            
            cell.imvCheckedOverlay.image = UIImage(named: "deck_overlay-checked")
            cell.selectedToggle = true
            
            
        } else {
            
            cell.imvCheckedOverlay.image = nil
            cell.selectedToggle = false
            var i = 0
            
            for object in selectedDecks {
                
                if (object.id == indexPath.row + 1){
                    selectedDecks.removeAtIndex(i)
                }
                
                i += 1
            }
        }
        
        for cell in cvwDeckCollection.visibleCells() as! [DeckCollectionViewCell] {
            
            if (cell.selectedToggle == true) {
                amountSelected += 1
            }
        }
        
        self.navigationItem.title = String(amountSelected) + " GESELECTEERD"
        
        checkIfReady()
    }
    
    func checkIfReady() {
        if (amountSelected == 0) {
            navigationItem.rightBarButtonItem?.enabled = false;
        } else {
            navigationItem.rightBarButtonItem?.enabled = true;
        }
    }
    
    func jsonload(){
        let requestURL: NSURL = NSURL(string: "http://webd3v.nl/PHP/jsoncat.php")!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                do{
                    
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
                    
                    let results: NSArray = json as! NSArray
                    var i = 0
                    
                    for item in results {
                        
                        let newDeck = Deck(id: Int(item["CatId"] as! String)!, name: item["Naam"] as! String, color: item["Kleur"] as! String, image: item["Image"] as! String)
                        
                        self.decks.append(newDeck)
                        
                        i = 1 + i
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.cvwDeckCollection.reloadData()
                        })
                    }
                    
                }catch {
                    print("Error with Json: \(error)")
                }
            }
        }
        task.resume()
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "popoverDecksTutorial1" {
            if let controller = segue.destinationViewController as? UIViewController {
                controller.popoverPresentationController!.delegate = self
                controller.preferredContentSize = CGSize(width: 195, height: 110)
            }
        }
        
        if (segue.identifier == "GoToCardSelect") {
            var urlstring = "http://webd3v.nl/PHP/updatecat.php?userid=1&catid="
            
            
            var i = 0
            
            for item in selectedDecks {
                
                if (i == 0) {
                    urlstring = urlstring + String(item.id)
                } else {
                    urlstring = urlstring + "-" + String(item.id)
                }
                
                i += 1
            }
            
            
            let url = NSURL(string: urlstring)
            let request = NSURLRequest(URL: url!)
            
            let connection = NSURLConnection(request: request, delegate: nil, startImmediately: true)
            
            let controller = segue.destinationViewController as! CardSelectViewController
            controller.selectedDecks = selectedDecks
        }
    }
    
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    
    func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController) {
        if (popoverPresentationController == )
    }
}
