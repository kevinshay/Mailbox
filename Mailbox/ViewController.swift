//
//  ViewController.swift
//  Mailbox
//
//  Created by Kevin Shay on 2/17/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var messageImage: UIImageView!
    var startingMessageCenter: CGPoint!
    var state: String!
    var iconState: String!
    var startingIconCenter: CGPoint!
    @IBOutlet weak var emailsImage: UIImageView!
    @IBOutlet weak var scheduleImage: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var swipeLeftIcon: UIImageView!
    @IBOutlet weak var swipeRightIcon: UIImageView!
    @IBOutlet weak var mainInboxView: UIView!
    @IBOutlet var regularPanGestureRecognizer: UIPanGestureRecognizer!
    var startingMainInboxViewCenter: CGPoint!
 


    @IBOutlet weak var colorBackgroundImage: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        self.view.bringSubviewToFront(emailsImage)
        var edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: "edgeDidPan:")
        edgeGesture.edges = UIRectEdge.Left
        mainInboxView.addGestureRecognizer(edgeGesture)
        mainInboxView.removeGestureRecognizer(self.regularPanGestureRecognizer)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
    
        super.viewDidAppear(animated)
        
        self.view.bringSubviewToFront(messageImage)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    

    @IBAction func didPanMessage(sender: AnyObject) {
        
        var translation = sender.translationInView(view)
        var location = sender.locationInView(view)
        
        
        if (sender.state == UIGestureRecognizerState.Began){
            startingMessageCenter = messageImage.center
            startingIconCenter = swipeLeftIcon.center
 
            
               // This block is to show background color and to drag the icon
        } else if (sender.state == UIGestureRecognizerState.Changed) {
            messageImage.center = CGPoint(x: startingMessageCenter.x + translation.x, y: messageImage.center.y)
            swipeLeftIcon.center = CGPoint(x: messageImage.frame.width + messageImage.frame.origin.x + 35 , y: swipeLeftIcon.center.y)
            swipeRightIcon.center = CGPoint(x:messageImage.frame.origin.x - 35, y: swipeRightIcon.center.y)
         
            if(messageImage.frame.origin.x < -100 && messageImage.frame.origin.x > -160) {
                state = "Yellow"
                colorBackgroundImage.backgroundColor = UIColor(red: 249/255, green: 210/255, blue: 70/255, alpha: 1)
                
            }
            
            if (messageImage.frame.origin.x < -160 ) {
                state = "Brown"
                colorBackgroundImage.backgroundColor = UIColor(red: 215/255, green: 166/255, blue: 120/255, alpha: 1)

            
            } else if (messageImage.frame.origin.x > 100 && messageImage.frame.origin.x < 160) {
                state = "Green"
                colorBackgroundImage.backgroundColor = UIColor(red: 116/255, green: 215/255, blue: 104/255, alpha: 1)

            } else if (messageImage.frame.origin.x > 160) {
                state = "Red"
                colorBackgroundImage.backgroundColor = UIColor(red: 233/255, green: 85/255, blue: 59/255, alpha: 1)
                

            } else if(messageImage.frame.origin.x  > -60 && messageImage.frame.origin.x < 60) {
                state = "Gray"
                colorBackgroundImage.backgroundColor = UIColor(red: 227/255, green: 227/255, blue: 227/255, alpha: 1)
                swipeLeftIcon.frame.origin.x = 275
                swipeRightIcon.frame.origin.x = 5
                
            }
            
            
            // This block is to animate in the corresponding SwipeLeftIcons
            self.swipeLeftIcon.alpha = self.messageImage.frame.origin.x / -50.0
            self.swipeRightIcon.alpha = self.messageImage.frame.origin.x / 50.0
        
            if (messageImage.frame.origin.x > -160 && messageImage.frame.origin.x < 0) {
                
                    self.iconState = "later icon"
                    self.swipeLeftIcon.image = UIImage(named:"later_icon")
            }
            
             if (messageImage.frame.origin.x < -160){
                iconState = "list icon"
                swipeLeftIcon.alpha = 1
                swipeLeftIcon.image = UIImage(named: "list_icon")
            }
            
            if (messageImage.frame.origin.x > 50 ){
                iconState = "Archive icon"
                swipeLeftIcon.alpha = 1
                swipeLeftIcon.image = UIImage(named: "archive_icon")
            }
            
            if (state == "Green"){
            swipeRightIcon.image = UIImage(named: "archive_icon")
            }
            
            if (state == "Red"){
                swipeRightIcon.image = UIImage(named: "delete_icon")
            }
            
            
            println(messageImage.frame.origin.x)
            
            
            NSLog("State: %@", state)
            
        } else if (sender.state == UIGestureRecognizerState.Ended) {
           
            //This animates the messageImage either back to 0 or out of the frame
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                if (self.state == "Gray") {
                    self.messageImage.frame.origin.x = 0
                    
                } else if ( self.state == "Yellow"){
                    self.swipeLeftIcon.alpha = 0
                    self.messageImage.frame.origin.x = -320
                    self.delay(0.5, closure: { () -> () in
                        self.scheduleImage.alpha = 1
                        
                        
        
                    })
                }
            })
            
        
        }
    }
    
    @IBAction func scheduleDidTap(sender: AnyObject) {
    
        
        
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.scheduleImage.alpha = 0
                self.scrollView.frame.origin.y = self.scrollView.frame.origin.y - self.messageImage.frame.height
            }) { (Finished) -> Void in
              UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.messageImage.frame.origin.x = 0
              }, completion: { (Finished) -> Void in
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.scrollView.frame.origin.y = self.scrollView.frame.origin.y + self.messageImage.frame.height
                    
                }, completion: nil)
              })
        }
        
        
       
    
    }
    
    @IBAction func edgeDidPan(sender: UIScreenEdgePanGestureRecognizer) {
        var translation = sender.translationInView(view)
        var location = sender.locationInView(view)
        var threshold1 = self.mainInboxView.frame.size.width / 2.0
        var threshold2 = threshold1 + 300
        
        if (sender.state == UIGestureRecognizerState.Began){
            startingMainInboxViewCenter = mainInboxView.center
        } else if (sender.state == UIGestureRecognizerState.Changed) {
            var newX = startingMainInboxViewCenter.x + translation.x
            if (newX > threshold1 && newX < threshold2) {
                mainInboxView.center = CGPoint(x:  newX, y: mainInboxView.center.y)
            } else if (newX < threshold1) {
                mainInboxView.center = CGPoint(x: threshold1, y: mainInboxView.center.y)
            } else if (newX > threshold2) {
                mainInboxView.center = CGPoint(x: threshold2, y: mainInboxView.center.y)
            }

            
        } else if (sender.state == UIGestureRecognizerState.Ended) {
            self.mainInboxView .addGestureRecognizer(self.regularPanGestureRecognizer)
            UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.3, options: nil, animations: { () -> Void in
                if (self.mainInboxView.frame.origin.x < 100) {
                    self.mainInboxView.frame.origin.x = 0
                }
                else {
                    self.mainInboxView.frame.origin.x = threshold2 - threshold1
                }
            }, completion: nil)
        }
        
    }

    @IBAction func mainInboxViewDidPanBack(sender: UIPanGestureRecognizer) {
        var translation = sender.translationInView(view)
        var location = sender.locationInView(view)
        
        var threshold1 = self.mainInboxView.frame.size.width / 2.0
        var threshold2 = threshold1 + 300
        
        if (sender.state == UIGestureRecognizerState.Began){
            startingMainInboxViewCenter = mainInboxView.center
        } else if (sender.state == UIGestureRecognizerState.Changed) {
            var newX = startingMainInboxViewCenter.x + translation.x

            if (newX > threshold1 && newX < threshold2) {
                mainInboxView.center = CGPoint(x:newX, y: mainInboxView.center.y)
            } else if (newX < threshold1) {
                self.mainInboxView.removeGestureRecognizer(self.regularPanGestureRecognizer)
                mainInboxView.center = CGPoint(x: threshold1, y: mainInboxView.center.y)
            } else if (newX > threshold2) {
                mainInboxView.center = CGPoint(x: threshold2, y: mainInboxView.center.y)
            }
            
        } else if (sender.state == UIGestureRecognizerState.Ended) {
            UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.3, options: nil, animations: { () -> Void in
                    if (self.mainInboxView.frame.origin.x < 100) {
                        self.mainInboxView.frame.origin.x = 0
                    }
                    else {
                        self.mainInboxView.frame.origin.x = threshold2 - threshold1
                    }
                }, completion: nil)
            }
        }
}





