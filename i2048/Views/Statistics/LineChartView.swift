//
//  LineChartView.swift
//  i2048
//
//  Created by Rishi Singh on 03/01/25.
//

import SwiftUI
import Charts

struct LineChartView: View {
    var data: [Date: Int]
    
    var body: some View {
        Chart {
            ForEach(data.keys.sorted(), id: \.self) { date in
                LineMark(
                    x: .value("Date", date, unit: .day),
                    y: .value("Games", data[date]!)
                )
                .interpolationMethod(.monotone)
            }
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: .day)) { _ in
                AxisGridLine()
                AxisTick()
                AxisValueLabel(format: .dateTime.day(.defaultDigits))
            }
        }
    }
}
//
//#Preview {
//    LineChartView(data: [Date.now : 40])
//}
