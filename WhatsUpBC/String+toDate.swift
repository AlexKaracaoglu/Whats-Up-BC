//
//  String+toDate.swift
//  WhatsUpBC
//
//  Created by Alex Karacaoglu on 4/11/19.
//  Copyright © 2019 Alex Karacaoglu. All rights reserved.
//

import Foundation

extension String {
    func toDate() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "EE, MMM d, yyyy 'at' hh:mm aaa"
        return formatter.date(from: self)!
    }
}
