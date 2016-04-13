//
//  MessageCell.swift
//  Monolog
//
//  Created by Hermann Klecker on 08/04/16.
//  Copyright © 2016 Hermann Klecker. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    // Must be linked accrodingly with the prototype cell witin IB.
    @IBOutlet weak var timeLabel : UILabel?
    @IBOutlet weak var messageLabel : UILabel?
    
    // lazy bewirkt, dass das Property nicht zur Instanziierung der Klasse initializiert wird sondern erst beim ersten Zugriff. 
    // Wenn zur Initializierung aufwendige Prozesse wie Instanziierungen durchgeführt werden, dann kann ein lazy initializer "gefühlte"
    // Performance-Vorteile aus Sicht des Anwenders haben.
    private lazy var df : NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .ShortStyle  // Weitere Stile stehen zur Verfügung. Ebenso können die Stile auch customized werden.
        dateFormatter.timeStyle = .ShortStyle
        return dateFormatter
    }()
    
    func bind (message: Message) {
        // das Message-Objekt letzenendes darstellen. 
        messageLabel?.text = message.message
        timeLabel?.text = df.stringFromDate(message.timestamp!)
    }
    
}
