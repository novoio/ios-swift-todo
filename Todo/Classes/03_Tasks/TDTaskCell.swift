//
//  TDTaskCell.swift
//  Todo
//
//  Created by Donovan on 11/22/14.
//  Copyright (c) 2014 Donovan. All rights reserved.
//

import UIKit
    
protocol TDTaskCellDelegate
{
    func taskCellDidClickDone(cell: TDTaskCell)
}

class TDTaskCell: UITableViewCell
{
    var delegate: TDTaskCellDelegate?
    
    @IBOutlet weak var labelTitle:    UILabel!
    @IBOutlet weak var btnDone:       UIButton!
    
    // MARK: - Basic Functions
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Configuration Functions
    
    func configureCellWithTask(task: TDTask)
    {
        labelTitle.text = task.title
        
        updateStatusWitTask(task)
    }
    
    // MARK: - UI Functions
    
    func updateStatusWitTask(task: TDTask)
    {
        if task.completed == true
        {
            btnDone.hidden = true
            self.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        else
        {
            btnDone.hidden = false;
            self.accessoryType = UITableViewCellAccessoryType.None
        }
    }
    
    // MARK: - Button Events
    
    @IBAction func onBtnDone(sender: AnyObject)
    {
        delegate?.taskCellDidClickDone(self)
    }
}
