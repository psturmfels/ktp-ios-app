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
    
    private var completedBackground : UIView = UIView();
    private var meetingLabel : UILabel = UILabel();
    
    // Meeting variable represented in the cell:
    var meeting : KTPPledgeMeeting? {
        didSet {
            loadLabelValues();
        }
    }
    
    // Changes background depending on if the meeting has been completed or not:
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier);
        
        contentView.addSubview(meetingLabel);
        contentView.addSubview(completedBackground);
        self.completedBackground.backgroundColor = UIColor(white: 1, alpha: 0.5);
        contentView.bringSubviewToFront(completedBackground);
        autoLayout();
    }

    convenience required init(coder aDecoder: NSCoder) {
        self.init(style: .Default, reuseIdentifier: "Cell");
    }
    
    // MARK: - Overridden setters/getters
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated);
        self.completedBackground.hidden = editing || !(meeting?.complete ?? false);
    }
    
    // MARK: - Loading subviews
    
    func loadLabelValues() {
        // Load name of pledge or active
        meetingLabel.text = KTPSUser.currentUserIsPledge() ? meeting!.active.firstName + " " + meeting!.active.lastName
                                                           : meeting!.pledge.firstName + " " + meeting!.pledge.lastName;
        
        // Load some sort of boolean indicator for "have they met"
        accessoryType = meeting!.complete ? .Checkmark : .None;
        self.completedBackground.hidden = !(meeting!.complete);
    }
    
    private func autoLayout() {
        completedBackground.setTranslatesAutoresizingMaskIntoConstraints(false);
        meetingLabel.setTranslatesAutoresizingMaskIntoConstraints(false);
        
        let views = [
            "meetingLabel" : meetingLabel,
            "completedBackground" : completedBackground
        ];
        
        // Auto Layout for text and graying out:
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(separatorInset.left)-[meetingLabel]-0-|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: views));
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[meetingLabel]-0-|", options: NSLayoutFormatOptions(0), metrics: nil, views: views));
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[completedBackground]-0-|", options:NSLayoutFormatOptions(0), metrics: nil, views: views));
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[completedBackground]-0-|", options:NSLayoutFormatOptions(0), metrics: nil, views: views));
    }
}









