import UIKit

class CardDetailViewController: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tvwDescription: UITextView!
    @IBOutlet weak var lblSubtitle: UILabel!
    @IBOutlet weak var ivwCardImage: UIImageView!
    
    @IBOutlet weak var ainLoadingTurn: UIActivityIndicatorView!
    @IBOutlet weak var vwRateContainer: UIView!
    @IBOutlet weak var vwStatusContainer: UIView!
    @IBOutlet weak var btnDislike: RedBaseOneRateButton!
    @IBOutlet weak var btnLike: GreenBaseOneRateButton!
    
    var selectedCard: Card!
    var timer : NSTimer = NSTimer()
    var deckName: String = ""
    var deckColor: String = ""
    var run:Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.setHidesBackButton(true, animated:true);
        timer = NSTimer.scheduledTimerWithTimeInterval(8, target: self, selector: "voted", userInfo: nil, repeats: true)
        ainLoadingTurn.startAnimating()
        vwRateContainer.hidden = true
        vwStatusContainer.hidden = true
        jsonaandebeurt()
        jsonload()
    }
    
    func voted(){
        let requestURL: NSURL = NSURL(string: "http://webd3v.nl/PHP/jsonbeurt.php?userid=1")!
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
                    
                    for item in results {
                        if(item["Kaart"] as! String == ""){
                            dispatch_async(dispatch_get_main_queue(), {
                                
                                self.timer.invalidate()
                                self.performSegueWithIdentifier("GoToCardSelect", sender: self)
                                
                            })
                        }
                    }
                }catch {
                    print("Error with Json: \(error)")
                }
            }
        }
        task.resume()
    }
    
    func jsonaandebeurt(){
        let requestURL: NSURL = NSURL(string: "http://webd3v.nl/PHP/jsonbeurt.php?userid=2")!
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
                        if (Int(item["Aanzet"] as! String)! == 0){
                            dispatch_async(dispatch_get_main_queue(), {
                                self.ainLoadingTurn.hidden = true
                                self.vwStatusContainer.hidden = false
                            })
                            
                        }
                        else {
                            dispatch_async(dispatch_get_main_queue(), {
                                self.ainLoadingTurn.hidden = true
                                
                                self.vwRateContainer.frame = CGRect(x: 0, y: 667, width: 375, height: 124)
                                self.vwRateContainer.hidden = !self.vwRateContainer.hidden
                                
                                //fly in buttons
                                
                                UIView.animateWithDuration(0.7, delay: 0.2, options: .CurveEaseOut, animations: {
                                    
                                    self.vwRateContainer.frame = CGRect(x: 0, y: 543, width: 375, height: 124)
                                    
                                    }, completion: nil)
                            })
                            
                        }
                        
                        i = 1 + i
                    }
                }catch {
                    print("Error with Json: \(error)")
                }
            }
        }
        task.resume()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnLikeClicked(sender: AnyObject) {
        jsonpostvote()
    }
    
    @IBAction func btnDislikeClicked(sender: AnyObject) {
        jsonpostvote()
    }
    
    func jsonpostvote(){
        var urlstring = "http://webd3v.nl/PHP/jsonbeurtwijzigen.php?userid=2"
        let url = NSURL(string: urlstring)
        let request = NSURLRequest(URL: url!)
        
        let connection = NSURLConnection(request: request, delegate: nil, startImmediately: true)
        
        self.run = self.run + 1
        if(self.run == 1){
            dispatch_async(dispatch_get_main_queue(), {
                self.performSegueWithIdentifier("GoToCardSelect", sender: self)
            })
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
                    
                    for item in results {
                        
                        if (self.selectedCard.catId == Int(item["CatId"] as! String)) {
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                self.deckName = String(item["Naam"] as! String)
                                
                                self.deckColor = String(item["Kleur"] as! String)
                                
                                let deckColorArr = self.deckColor.characters.split{$0 == "/"}.map(String.init)
                                
                                self.lblTitle.text = self.selectedCard.name
                                self.lblSubtitle.text = self.deckName
                                self.lblSubtitle.textColor = UIColor(red: CGFloat((deckColorArr[0] as NSString).floatValue)/255.0, green: CGFloat((deckColorArr[1] as NSString).floatValue)/255.0, blue: CGFloat((deckColorArr[2] as NSString).floatValue)/255.0, alpha: 1.0)
                                self.tvwDescription.text = self.selectedCard.description
                                
                                let range = self.selectedCard.image.startIndex.advancedBy(4)..<self.selectedCard.image.endIndex
                                let substr = self.selectedCard.image[range]
                                let newImage = "rect" + String(substr)
                                
                                let image : UIImage = UIImage(named: newImage)!
                                self.ivwCardImage.image = image
                                self.ivwCardImage.backgroundColor = UIColor(red: CGFloat((deckColorArr[0] as NSString).floatValue)/255.0, green: CGFloat((deckColorArr[1] as NSString).floatValue)/255.0, blue: CGFloat((deckColorArr[2] as NSString).floatValue)/255.0, alpha: 1.0)
                            })
                        }
                    }
                    
                }catch {
                    print("Error with Json: \(error)")
                }
            }
        }
        task.resume()
    }
}

