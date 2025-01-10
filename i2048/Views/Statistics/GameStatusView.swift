//
//  GameStatusView.swift
//  i2048
//
//  Created by Rishi Singh on 03/01/25.
//

import SwiftUI
import Charts

struct GameStatusView: View {
    var totalGames: Int
    var wonGames: Int
    var lostGames: Int
    var activeGames: Int
    
    var body: some View {
        HStack {
            Chart {
                SectorMark(
                    angle: .value("Value", wonGames),
                    innerRadius: .ratio(0.5),
                    angularInset: 2.0
                )
                .foregroundStyle(.green)
                .cornerRadius(2)
                SectorMark(
                    angle: .value("Value", activeGames),
                    innerRadius: .ratio(0.5),
                    angularInset: 2.0
                )
                .foregroundStyle(.orange)
                .cornerRadius(2)
                SectorMark(
                    angle: .value("Value", lostGames),
                    innerRadius: .ratio(0.5),
                    angularInset: 2.0
                )
                .foregroundStyle(.red)
                .cornerRadius(2)
            }
            VStack(alignment: .leading, spacing: 5) {
                Text("\(totalGames)")
                    .font(.title.bold())
                Text("TOTAL")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                Divider()
                    .foregroundStyle(.secondary)
                    .padding(.trailing)
                HStack {
                    Circle()
                        .frame(width: 8, height: 8)
                        .foregroundStyle(.green)
                        .padding(.leading, 5)
                    Text("\(wonGames)")
                        .font(.headline.bold())
//                        .frame(width: 20)
                    Text(": WON")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                HStack {
                    Circle()
                        .frame(width: 8, height: 8)
                        .foregroundStyle(.orange)
                        .padding(.leading, 5)
                    Text("\(activeGames)")
                        .font(.headline.bold())
//                        .frame(width: 20)
                    Text(": ACTIVE")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                HStack {
                    Circle()
                        .frame(width: 8, height: 8)
                        .foregroundStyle(.red)
                        .padding(.leading, 5)
                    Text("\(lostGames)")
                        .font(.headline.bold())
//                        .frame(width: 20)
                    Text(": LOST")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.leading)
            .frame(width: 130)
        }
        .padding(.vertical)
    }
}

#Preview {
    GameStatusView(
        totalGames: 35, wonGames: 14, lostGames: 18, activeGames: 3
    )
}
