//
//  DurationPacketTableCellView.swift
//  Bagel
//
//  Created by Ahmed Ramy on 04/07/2021.
//  Copyright © 2021 Yagiz Lab. All rights reserved.
//

import Cocoa
import macOSThemeKit



class DurationPacketTableCellView: NSTableCellView {
  
  
  @IBOutlet private weak var titleTextField: NSTextField!
  
  var model: BagelPacket? {
    didSet{
      guard let packet = model else { return }
      refresh(with: packet)
    }
  }
  
  func refresh(with model: BagelPacket) {
    if let startDate = model.requestInfo?.startDate, let endDate = model.requestInfo?.endDate {
      titleTextField.textColor = severityColor(startDate: startDate, endDate: endDate)
      titleTextField.stringValue = display(startDate: startDate, endDate: endDate)
    } else {
      titleTextField.textColor = ThemeColor.statusRedColor
      titleTextField.stringValue = "N/A"
    }
  }
  
  func display(startDate: Date, endDate: Date) -> String {
    getReadableRequestDuration(endDate: endDate, startDate: startDate)
  }
  
  func severityColor(startDate: Date, endDate: Date) -> ThemeColor {
    let (_, differenceInSeconds, differenceInMilliSeconds) = getTimeOfDuration(endDate: endDate, startDate: startDate)
    
    if differenceInSeconds > 0 {
      return (differenceInSeconds < 5) ? .statusOrangeColor : .statusRedColor
    } else {
      return (differenceInMilliSeconds < 1000.0) ? .statusGreenColor : .statusOrangeColor
    }
  }
  
}
