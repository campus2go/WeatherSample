//
//  ViewController.swift
//  Monolog
//
//  Created by Hermann on 08.04.16.
//  Copyright © 2016 Hermann Klecker. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    /*
        If the View would contain nothing but a table view, wich is proably true for about 90% of all table views
        then you would just inherit from UITableViewController. UITableViewController already implements the 
        protocols UITableViewDataSource and UITableViewDelegate and reacts with default return values in a way
        that an empty but fully functional table would be displayed. 
        That enables you to overwrite only those mehtods of both protocols that need to be overwritten. 
        Eg. numberOfSectionsInTableView does not need to be overwritten when there is one section only. 

        Doing so, self.view refers to the one and only UITableView (-Subclass) in the view which as well
        is referred by self.tableView automatically. 

        However, in this view we have got an additional UITextField and UIButton. In the final implementation 
        you may need a UIScrollView as well when you aim to change the order of the messages or to position the 
        text field at the bottom. 
        As this cannot be achieved with a UITableViewController, we just inherit from a plain UIViewController
        and implement both protocols on our own */


    @IBOutlet weak var tableView : UITableView?
    @IBOutlet weak var sendButton : UIButton?
    @IBOutlet weak var newMessage : UITextField?
    
	override func viewDidLoad() {
		super.viewDidLoad()
        
        // The following line is not required as the related prototype cell in the story board 
        // has set its identifier property accordingly.
        // tableView!.registerClass(UITableViewCell.self, forCellReuseIdentifier: "MessageCell")
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
    // MARK:- Table Data Source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // As there is just one section, we just return 1.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // The number of rows equals the number of messages available.
        return MessageManager.getNumberOfMessages()
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Fetch a cell from the table's pool of reusable cells. The table view will instanticate a cell of the type that 
        // is associated with the identifer "MessageCell". This identifier should match the identifier as configured 
        // within IB for the related protype cell. 
        // If it is not configured within IB, then we should have called registerClass within viewDidLoad (or loadView respectively).
        let cell = tableView.dequeueReusableCellWithIdentifier("MessageCell") as! MessageCell
        
        // Here we set the contents of the cell. As this is the actual binding process between the ui and its data, it is a nice 
        // pattern to implement a 'bind' method within the custom cell.
        cell.bind(MessageManager.getMessage(atIndex: indexPath.row)!)
        
        // However, for most standard usages, the standard UITableViewCell provides a number of UI elements such as an image to the left (start),
        // a title, a lable for detail information and an accessory button on the right (end). The title and deatil will match the left (start) frame
        // if there is no image set. For a huge number of usages this standard cell is quite sufficient. In that case we do not need to subclass
        // UITableViewCell and tehrefore do not implement a bind() method but set its properties directly from here.
        
        return cell
    }
    
    // Mark: - Table delegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        // This is where the myracle happens. 
        // As each table cell has a different height depending on the height of the lable that holds the message itself which will 
        // adjust its size depending on the message text length (and font and font size of course). 
        // In order to enable the table view to layout itself, we need to send the height of the related cell to the table view. 
        
        // First, we get the message.
        let message = MessageManager.getMessage(atIndex: indexPath.row)?.message
        
        // Then we calculate the size of the horzontal borders. This must match the constraints in IB
        let horizontalBorders : CGFloat = 2 * 12.0
        // Then we calculate the size consumed by vertical borders. Must match labels' top and bottom constraints within the cell.
        var verticalBorders : CGFloat = 0.0 + 1.0
        // Now we add the height of the date label and the margin between
        verticalBorders += 10.0 + 1.0
        
        // The width available for the UILabel that holds the message is the total width of the table view minus the space 
        // that is occupied by the borders.
        let width = tableView.frame.size.width - horizontalBorders
        
        // The font used is an important input to the calculation of the actual size.
        let font = UIFont.systemFontOfSize(14.0)
        // or if font is different from system font:
        // let font2 = UIFont("Helvetica", 14.0)
        
        // Upon return we can now call the method that does the calculation of the height of the message as displayed on screen.
        return heightForView(message!, font: font, width: width) + verticalBorders
        
    }

    // Utility method to determine the height actually requied for any UILabel
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        
        // The trick is to create a label just for the sake of letting it calculate its required size.
        // There are alternative methods provided by the String class and by the Core String framework.
        // However, this ist a most convenient one and it is always accurate, because any other mehtod
        // would have to simulate the calculations as UILable does it anyway.
        
        // We set all the properties that influcence the size of the text within a UILabel object. 
        // It is important to set the accurate width but give the UILable enough room to expand vertically. 
        // This prevents the Label to squeeze or cut the text and to return wrong results as a consequence.
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max)) // max length by given width
        label.numberOfLines = 0 // unlimited number of lines
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping // must match real lable property value (interface builder)
        label.font = font // must match real lable property value (interface builde
        label.text = text // Well, must match the text to be displayed, obviously.
        label.sizeToFit() // this one does all the magic.
        return label.frame.height // Now the label's frame has its correct height.
    }
    
    // Mark:- Text Field Delegate
    // Called upon pressing return key within a text field.
    // This view controller must be set as the text field's delegate, either programmatically or in IB.
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        sendButtonPressed() // react to the return key in the same way as if the user pressed the "send" or "ok" button respectively. 
        
        return false  // return true would cause the text field to process the return key and add a new line.
    }
    
    // Mark:- Actions
    // Must be set as the button's action.
    @IBAction func sendButtonPressed () {
        MessageManager.addMessage(newMessage!.text!)
        newMessage?.text = ""
        tableView?.reloadData()
    }

}

