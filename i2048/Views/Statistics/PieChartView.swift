//
//  PieChartView.swift
//  i2048
//
//  Created by Rishi Singh on 03/01/25.
//

import SwiftUI
import Charts

struct PieChartView: View {
    var data: [(String, Int)]
    
    var body: some View {
        Chart(data, id: \.0) { (status, value) in
            SectorMark(
                angle: .value("Value", value),
                innerRadius: .ratio(0.5),
                angularInset: 2.0
            )
            .foregroundStyle(by: .value("Status", status))
        }
        .chartLegend(position: .bottom)
    }
}

#Preview {
    PieChartView(data: [("Name", 23)])
}
