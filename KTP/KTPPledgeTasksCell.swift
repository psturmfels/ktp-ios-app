//
//  KTPPledgeTasksCell.swift
//  KTP
//
//  Created by Owen Yang on 2/7/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

import UIKit

class KTPPledgeTasksCell: UITableViewCell {
    
    var task: KTPPledgeTask? {
        didSet {
            loadLabelValues();
        }
    }
    
    private var titleLabel: UILabel = UILabel();
    private var pointsLabel: UILabel = UILabel();
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier);
        
        accessoryType = .DisclosureIndicator;
        loadLabels();
        autoLayoutLabels();
    }

    convenience required init(coder aDecoder: NSCoder) {
        self.init(style: .Default, reuseIdentifier: "");
    }

    func autoLayoutLabels() {
        titleLabel.setTranslatesAutoresizingMaskIntoConstraints(false);
        pointsLabel.setTranslatesAutoresizingMaskIntoConstraints(false);
        
        let views = [
            "titleLabel"  : titleLabel,
            "pointsLabel" : pointsLabel
        ];
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(separatorInset.left)-[titleLabel]-10-[pointsLabel(40)]-0-|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: views));
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[titleLabel]-0-|", options: NSLayoutFormatOptions(0), metrics: nil, views: views));
    }
    
    func loadLabels() {
        pointsLabel.textAlignment = .Right;
        contentView.addSubview(titleLabel);
        contentView.addSubview(pointsLabel);
    }
    
    func loadLabelValues() {
        titleLabel.text = task!.taskTitle;
        pointsLabel.text = "\(Int(task!.points))";
    }
    
}