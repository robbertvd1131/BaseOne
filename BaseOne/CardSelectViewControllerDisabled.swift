import UIKit

class CardSelectViewControllerDisabled: UIViewController {

    var cardView: UIView!
    var back: UIImageView!
    
    var cardView2: UIView!
    var back2: UIImageView!
    
    var cardView3: UIView!
    var back3: UIImageView!
    
    var cardview4: UIView!
    var back4: UIImageView!
    
    var timer : NSTimer = NSTimer()
     var selectedCard: Card!
    var kaart: String!
    var run:Int!
    
    func cards() {
        
        // Kaart1
        let rect = CGRectMake(10, 140, back.image!.size.width, back2.image!.size.height)
        
        cardView = UIView(frame: rect)
        cardView.addSubview(back)
        
        view.addSubview(cardView)
        //Kaart2
        let rect2 = CGRectMake(190, 140, back2.image!.size.width, back2.image!.size.height)
        
        cardView2 = UIView(frame: rect2)
        cardView2.addSubview(back2)
        
        view.addSubview(cardView2)
        //Kaart3
        let rect3 = CGRectMake(110, 405, back3.image!.size.width, back3.image!.size.height)
        
        cardView3 = UIView(frame: rect3)
        cardView3.addSubview(back3)
        
        view.addSubview(cardView3)
        
        //Overlay
        let rect4 = CGRectMake(0, 65, 3000, 3000)
        
        cardview4 = UIView(frame: rect4)
        cardview4.contentMode = UIViewContentMode.ScaleAspectFit
        cardview4.addSubview(back4)
        
        view.addSubview(cardview4)
    }
    
    func image(){
        let backimage: UIImage = (UIImage(named: "card_backside")!)
        let overlay: UIImage = (UIImage(named: "overlay-disabled")!)
        back = UIImageView(image: backimage)
        back2 = UIImageView(image: backimage)
        back3 = UIImageView(image: backimage)
        back4 = UIImageView(image: overlay)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        run = 0
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        timer = NSTimer.scheduledTimerWithTimeInterval(8, target: self, selector: "update", userInfo: nil, repeats: true)
        image()
        cards()
    }
    
    func update() {
        jsonaandebeurt()
    }
    
    func jsonaandebeurt(){
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
                    var i = 0
                    
                    for item in results {
                        
                        if (Int(item["Aanzet"] as! String)! == 0 && item["Kaart"] as! String != ""){
                            self.timer.invalidate()
                            dispatch_async(dispatch_get_main_queue(),{
                                self.timer.invalidate()

                                self.kaart = item["Kaart"] as! String!
                                self.jsongetcard()
                                
                            })
                        }
                        print(item["Aanzet"])
                        i = 1 + i
                    }
                }catch {
                    print("Error with Json: \(error)")
                }
            }
        }
        task.resume()
    }
    
    func jsongetcard(){
        let requestURL: NSURL = NSURL(string: "http://webd3v.nl/PHP/json.php?kaart=" + kaart)!
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
                        

                            dispatch_async(dispatch_get_main_queue(),{
                                self.selectedCard = Card(id: Int(item["KaartId"] as! String)!, name: item["Naam"] as! String, image: item["Afbeelding"] as! String, description: item["Omschrijving"] as! String, catId: Int(item["CatId"] as! String)!)
                                //print(item["Afbeelding"] as! String)
                                self.run = self.run + 1
                                if(self.run == 1){
                                self.performSegueWithIdentifier("GoToStatusDetailScreen2", sender: nil)
                                }
                            })

                        print(item["KaartId"])
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
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "GoToStatusDetailScreen2") {
            
            self.timer.invalidate()
            let controller = segue.destinationViewController as! CardDetailViewController
            controller.selectedCard = selectedCard
        }
    }
    
}