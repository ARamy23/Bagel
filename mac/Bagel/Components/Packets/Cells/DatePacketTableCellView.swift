//
//  DatePacketTableCellView.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 22.10.2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa
import macOSThemeKit



class DatePacketTableCellView: NSTableCellView {
  
  struct Model {
    var packet: BagelPacket
    var mode: DatePacketTableCellView.Mode
  }
    
    @IBOutlet private weak var titleTextField: NSTextField!
    
    var model: Model? {
        didSet{
          guard let packet = model else { return }
            refresh(with: packet)
        }
    }
  
    func refresh(with model: Model) {
      guard let requestInfo = model.packet.requestInfo else { return }
      titleTextField.textColor = model.mode.severityColor(requestInfo: requestInfo)
      titleTextField.stringValue = model.mode.display(requestInfo: requestInfo)
    }
    
}

extension DatePacketTableCellView {
  enum Mode {
    case date
    case duration
    
    func display(requestInfo: BagelRequestInfo) -> String {
      switch self {
      case .date:
        return requestInfo.startDate?.readable ?? ""
      case .duration:
        return getReadableRequestDuration(endDate: requestInfo.endDate ?? Date(), startDate: requestInfo.startDate ?? Date())
      }
    }
    
    func severityColor(requestInfo: BagelRequestInfo) -> ThemeColor {
      switch self {
      case .date:
        return .secondaryLabelColor
      case .duration:
        let (_, differenceInSeconds, differenceInMilliSeconds) = getTimeOfDuration(endDate: requestInfo.endDate ?? Date(), startDate: requestInfo.startDate ?? Date())
        
        if differenceInSeconds > 0 {
          return (differenceInSeconds < 5) ? .statusOrangeColor : .statusRedColor
        } else {
          return (0.0..<1000.0).contains(differenceInMilliSeconds) ? .statusGreenColor : .statusOrangeColor
        }
      }
    }
  }
}

func getTimeOfDuration(endDate: Date, startDate: Date) -> (mins: Int, seconds: Int, milliseconds: Double) {
  let timeDifference = endDate.timeIntervalSince(startDate)
  let readableDifference = Int(timeDifference)
  
  let differenceInMilliSeconds: Double = (timeDifference * 1000)
  let differenceInSeconds: Int = readableDifference % 60
  let differenceInMinutes: Int = (readableDifference / 60) % 60
  
  return (differenceInMinutes, differenceInSeconds, differenceInMilliSeconds)
}

func getReadableRequestDuration(endDate: Date, startDate: Date) -> String {
  let (differenceInMinutes, differenceInSeconds, differenceInMilliSeconds) = getTimeOfDuration(endDate: endDate, startDate: startDate)
  
  switch (differenceInMinutes > 0, differenceInSeconds > 0) {
  case (true, true):
    return "\(differenceInMinutes) mins, \(differenceInSeconds) sec"
  case (false, true):
    return "\(differenceInSeconds) sec"
  default:
    return "\(format(timeDifference: differenceInMilliSeconds)) ms"
  }
}

func format(timeDifference: Double, withDigits digits: Int = 2) -> String {
  let formatter = NumberFormatter()
  formatter.minimumFractionDigits = digits
  return formatter.string(from: NSNumber(value: timeDifference)) ?? "0.00"
}
