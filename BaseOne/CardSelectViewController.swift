import UIKit

class CardSelectViewController: UIViewController {
    
    var selectedDecks = [Deck]()
    
    var availableCards = [Card]()
    
    var selectedCard: Card!
    
    
    var cardView: UIView!
    var back: UIImageView!
    var front: UIImageView!
    
    var cardView2: UIView!
    var back2: UIImageView!
    var front2: UIImageView!
    
    var cardView3: UIView!
    var back3: UIImageView!
    var front3: UIImageView!
    
    var showingBack = true
    var showingBack2 = true
    var showingBack3 = true
    
    var seen1: UIView!
    var seen2: UIView!
    var seen3: UIView!
    
    var hided1: UIImageView!
    var hided2: UIImageView!
    var hided3: UIImageView!
    
    var nothided1: UIImageView!
    var nothided2: UIImageView!
    var nothided3: UIImageView!
    
    var cardvalue: Int!
    var cardvalue2: Int!
    var cardvalue3: Int!
    
    var run: Int!
    var count = 0
    var count2 = 0
    var count3 = 0
    var opened = 0
    
    var timer : NSTimer = NSTimer()
    var kaart: String!
    var logoImages: [UIImage] = []
    var imagename: [String] = []
    
    func randomimage(){
        var i: Int
        var ir: Int
        run = 0
        var random: Int
        let backimage: UIImage = (UIImage(named: "card_backside")!)
        sleep(1)
        
        i = logoImages.count
        
        
        random = Int(arc4random_uniform(UInt32(i)))
        cardvalue = random
        front = UIImageView(image: logoImages[random])
        random = Int(arc4random_uniform(UInt32(i)))
        cardvalue2 = random
        while(cardvalue == cardvalue2){
            random = Int(arc4random_uniform(UInt32(i)))
            cardvalue2 = random
        }
        front2 = UIImageView(image: logoImages[random])
        random = Int(arc4random_uniform(UInt32(i)))
        cardvalue3 = random
        while(cardvalue == cardvalue3 || cardvalue2 == cardvalue3){
            random = Int(arc4random_uniform(UInt32(i)))
            cardvalue3 = random
        }
        front3 = UIImageView(image: logoImages[random])
        
        back = UIImageView(image: backimage)
        back2 = UIImageView(image: backimage)
        back3 = UIImageView(image: backimage)
    }
    
    override func viewWillAppear(animated: Bool) {
        jsonaandebeurt()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        timer = NSTimer.scheduledTimerWithTimeInterval(8, target: self, selector: "update", userInfo: nil, repeats: true)
        sleep(1)
        jsonload()
        randomimage()
        cards()
        
        print(selectedDecks)
        
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
                        
                        if (Int(item["Aanzet"] as! String)! == 0){
                            self.run = self.run + 1
                            if(self.run == 1){
                                self.timer.invalidate()
                                dispatch_async(dispatch_get_main_queue(),{
                                    self.performSegueWithIdentifier("GoToDisabledCardScreen", sender: nil)
                                })
                            }
                        }
                        
                        if (item["Kaart"] as! String != "" && Int(item["Aanzet"] as! String) == 1){
                            self.run = self.run + 1
                            if(self.run == 1){
                                dispatch_async(dispatch_get_main_queue(),{
                                    self.timer.invalidate()
                                    self.kaart = item["Kaart"] as! String!
                                    self.jsongetcard()
                                })
                                
                            }
                            print(item["Aanzet"])
                            i = 1 + i
                        }
                    }
                }catch {
                    print("Error with Json: \(error)")
                }
            }
        }
        task.resume()
    }
    
    func cards() {
        // Kaart1
        let singleTap = UITapGestureRecognizer(target: self, action: Selector("tapped"))
        singleTap.numberOfTapsRequired = 1
        
        let rect = CGRectMake(10, 140, back.image!.size.width, back.image!.size.height)
        
        cardView = UIView(frame: rect)
        cardView.addGestureRecognizer(singleTap)
        cardView.userInteractionEnabled = true
        cardView.addSubview(back)
        
        view.addSubview(cardView)
        //Kaart2
        let singleTap2 = UITapGestureRecognizer(target: self, action: Selector("tapped2"))
        singleTap2.numberOfTapsRequired = 1
        
        let rect2 = CGRectMake(190, 140, back2.image!.size.width, back2.image!.size.height)
        
        cardView2 = UIView(frame: rect2)
        cardView2.addGestureRecognizer(singleTap2)
        cardView2.userInteractionEnabled = true
        cardView2.addSubview(back2)
        
        view.addSubview(cardView2)
        //Kaart3
        let singleTap3 = UITapGestureRecognizer(target: self, action: Selector("tapped3"))
        singleTap3.numberOfTapsRequired = 1
        
        let rect3 = CGRectMake(110, 405, back3.image!.size.width, back3.image!.size.height)
        
        cardView3 = UIView(frame: rect3)
        cardView3.addGestureRecognizer(singleTap3)
        cardView3.userInteractionEnabled = true
        cardView3.addSubview(back3)
        
        view.addSubview(cardView3)
        previewed()
    }
    
    func previewed() {
        let nietgezien: UIImage = (UIImage(named: "hide")!)
        let gezien: UIImage = (UIImage(named: "eye")!)
        
        hided1 = UIImageView(image: nietgezien)
        hided2 = UIImageView(image: nietgezien)
        hided3 = UIImageView(image: nietgezien)
        nothided1 = UIImageView(image: gezien)
        nothided2 = UIImageView(image: gezien)
        nothided3 = UIImageView(image: gezien)
        
        let rectp1 = CGRectMake(30, 160, 15, 15)
        seen1 = UIView(frame: rectp1)
        seen1.addSubview(hided1)
        view.addSubview(seen1)
        
        let rectp2 = CGRectMake(210, 160, 15, 15)
        seen2 = UIView(frame: rectp2)
        seen2.addSubview(hided2)
        view.addSubview(seen2)
        
        let rectp3 = CGRectMake(135, 425, 15, 15)
        seen3 = UIView(frame: rectp3)
        seen3.addSubview(hided3)
        
        view.addSubview(seen3)
    }
    
    func tapped() {
        if (showingBack) {
            count = count + 1
            if (count == 1){
                UIView.transitionFromView(hided1, toView: nothided1, duration: 0, options: [], completion: nil )
                UIView.transitionFromView(back, toView: front, duration: 1, options: UIViewAnimationOptions.TransitionCurlDown, completion: nil )
                showingBack = false
                let triggerTime = (Int64(NSEC_PER_SEC) * 1)
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
                    //UIView.transitionFromView(self.front, toView: self.back, duration: 1, options: .Autoreverse, completion: nil)
                    UIView.transitionFromView(self.front, toView: self.back, duration: 1 , options: .TransitionCurlUp, completion: nil)
                    self.showingBack = true
                })}
            else{
                opened = opened + 1
                if(opened == 1){
                    seen1.hidden = true
                    UIView.transitionFromView(back, toView: front, duration: 2, options: UIViewAnimationOptions.TransitionFlipFromLeft, completion: nil)
                    showingBack = false
                    print(self.imagename[self.cardvalue])
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 12), dispatch_get_main_queue(), { () -> Void in
                        sleep(3)
                        UIView.animateWithDuration(0.5, animations: {
                            var newCenter = self.front.center
                            newCenter.y -= 400
                            self.front.center = newCenter
                            }, completion: { finished in
                                for object in self.availableCards {
                                    
                                    if(object.image == self.imagename[self.cardvalue])
                                    {
                                        self.selectedCard = Card(id: object.id, name: object.name, image: object.image, description: object.description, catId: object.catId)
                                        self.postcardtodb(object.image)
                                    }
                                }
                                
                                self.performSegueWithIdentifier("GoToStatusDetailScreen", sender: nil)
                        })
                    })
                }
            }
        }
    }
    
    func tapped2() {
        if (showingBack2) {
            count2 = count2 + 1
            if (count2 == 1){
                UIView.transitionFromView(hided2, toView: nothided2, duration: 0, options: [], completion: nil )
                UIView.transitionFromView(back2, toView: front2, duration: 1, options: UIViewAnimationOptions.TransitionCurlDown, completion: nil)
                showingBack2 = false
                let triggerTime = (Int64(NSEC_PER_SEC) * 1)
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
                    //UIView.transitionFromView(self.front2, toView: self.back2, duration: 1, options: .Autoreverse, completion: nil)
                    UIView.transitionFromView(self.front2, toView: self.back2, duration: 1 , options: .TransitionCurlUp, completion: nil)
                    self.showingBack2 = true
                })}
            else{
                opened = opened + 1
                if(opened == 1){
                    seen2.hidden = true
                    UIView.transitionFromView(back2, toView: front2, duration: 2, options: UIViewAnimationOptions.TransitionFlipFromLeft, completion: nil)
                    showingBack2 = false
                    print(self.imagename[self.cardvalue2])
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 12), dispatch_get_main_queue(), { () -> Void in
                        sleep(3)
                        UIView.animateWithDuration(0.5, animations: {
                            var newCenter = self.front2.center
                            newCenter.y -= 400
                            self.front2.center = newCenter
                            }, completion: { finished in
                                for object in self.availableCards {
                                    
                                    if(object.image == self.imagename[self.cardvalue2])
                                    {
                                        self.selectedCard = Card(id: object.id, name: object.name, image: object.image, description: object.description, catId: object.catId)
                                        self.postcardtodb(object.image)
                                    }
                                }
                                
                                self.performSegueWithIdentifier("GoToStatusDetailScreen", sender: nil)
                        })
                    })
                }
            }
        }
    }
    
    func tapped3() {
        if (showingBack3) {
            count3 = count3 + 1
            if (count3 == 1){
                UIView.transitionFromView(hided3, toView: nothided3, duration: 0, options: [], completion: nil )
                UIView.transitionFromView(back3, toView: front3, duration: 1, options: UIViewAnimationOptions.TransitionCurlDown , completion: nil)
                showingBack3 = false
                let triggerTime = (Int64(NSEC_PER_SEC) * 1)
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
                    UIView.transitionFromView(self.front3, toView: self.back3, duration: 1 , options: .TransitionCurlUp, completion: nil)
                    
                    self.showingBack3 = true
                })}
            else{
                
                opened = opened + 1
                if(opened == 1){
                    seen3.hidden = true
                    UIView.transitionFromView(back3, toView: front3, duration: 2, options: UIViewAnimationOptions.TransitionFlipFromLeft, completion: nil)
                    showingBack3 = false
                    print(self.imagename[self.cardvalue3])
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 12), dispatch_get_main_queue(), { () -> Void in
                        sleep(3)
                        UIView.animateWithDuration(0.5, animations: {
                            var newCenter = self.front3.center
                            newCenter.y -= 700
                            self.front3.center = newCenter
                            }, completion: { finished in
                                for object in self.availableCards {
                                    
                                    if(object.image == self.imagename[self.cardvalue3])
                                    {
                                        self.selectedCard = Card(id: object.id, name: object.name, image: object.image, description: object.description, catId: object.catId)
                                        self.postcardtodb(object.image)
                                    }
                                }
                                self.performSegueWithIdentifier("GoToStatusDetailScreen", sender: nil)
                        })
                    })
                }
            }
        }
    }
    
    func jsonload(){
        
        let requestURL: NSURL = NSURL(string: "http://webd3v.nl/PHP/jsoncards.php?userid=1")!
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
                        
                        var newCard = Card(id: Int(item["KaartId"] as! String)!, name: item["Naam"] as! String, image: item["Afbeelding"] as! String, description: item["Omschrijving"] as! String, catId: Int(item["CatId"] as! String)!)
                        
                        self.availableCards.append(newCard)
                        
                        i = 1 + i
                    }
                }catch {
                    print("Error with Json: \(error)")
                }
            }
            for object in self.availableCards {
                
                self.logoImages.append(UIImage(named: object.image)!)
                self.imagename.append(String(UTF8String: object.image)!)
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
                            self.performSegueWithIdentifier("GoToStatusDetailScreen", sender: nil)
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
    
    func postcardtodb (cards: String){
        var urlstring = "http://webd3v.nl/PHP/jsonsetcard.php?userid=1&card=" + cards
        let url = NSURL(string: urlstring)
        let request = NSURLRequest(URL: url!)
        
        let connection = NSURLConnection(request: request, delegate: nil, startImmediately: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "GoToStatusDetailScreen") {
            self.timer.invalidate()
            let controller = segue.destinationViewController as! CardDetailViewController
            controller.selectedCard = selectedCard
        }
    }
    
}