//
//  KTPPledgeMeetingsCell.swift
//  KTP
//
//  Created by Owen Yang on 2/15/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

import Foundation
import UIKit


class KTPPledgeMeetingsCell : UITableViewCell {

    var meeting : KTPPledgeMeeting? {
        didSet {
            loadLabelValues();
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier);
    }

    convenience required init(coder aDecoder: NSCoder) {
        self.init(style: .Default, reuseIdentifier: "");
    }
    
    func loadLabelValues() {
        
        // Load a list of pledges or actives depending on current user:
        
        if (KTPSUser.currentUser().member.status == "Pledge") {
            self.textLabel!.text = meeting!.active.firstName + " " + meeting!.active.lastName;
        }
        
        else {
            self.textLabel!.text = meeting!.pledge.firstName + " " + meeting!.pledge.lastName;
        }
        
        // Load some sort of boolean indicator for "have they met"
        
        if (meeting!.complete) {
            accessoryType = .Checkmark;
        } else {
            accessoryType = .None;
        }
        
    }
}









