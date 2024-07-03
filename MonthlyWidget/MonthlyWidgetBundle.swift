//
//  MonthlyWidgetBundle.swift
//  MonthlyWidget
//
//  Created by Temple on 2024-07-03.
//

import WidgetKit
import SwiftUI

@main
struct MonthlyWidgetBundle: WidgetBundle {
    var body: some Widget {
        MonthlyWidget()
        MonthlyWidgetLiveActivity()
    }
}
