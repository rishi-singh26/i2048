//
//  BarChartView.swift
//  i2048
//
//  Created by Rishi Singh on 03/01/25.
//

import SwiftData
import SwiftUI
import Charts

// MARK: - BarChartView with Game Status Representation
struct BarChartView: View {
    var data: [Game]
    @State private var selectedPeriod: TimePeriod = .day
    @State private var selectedDate: Date = Date()
    
    var filteredData: [(String, [GameStatus: Int])] {
        switch selectedPeriod {
        case .day:
            return aggregateDataByDayPeriod(for: selectedDate)
        case .week:
            return aggregateDataByWeek(for: selectedDate)
        case .month:
            return aggregateDataByMonth(for: selectedDate)
        }
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                // Time Period Picker
                Picker("Time Period", selection: $selectedPeriod) {
                    ForEach(TimePeriod.allCases) { period in
                        Text(period.rawValue).tag(period)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.bottom, 16)
                
                // Current Selected Date
                Text(currentDateLabel)
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 4)
                
                // Bar Chart
                Chart {
                    ForEach(filteredData, id: \.0) { (label, statusCounts) in
                        ForEach(GameStatus.allCases, id: \.self) { status in
                            if let count = statusCounts[status], count > 0 {
                                BarMark(
                                    x: .value("Time", label),
                                    y: .value("Games", count)
                                )
                                .foregroundStyle(by: .value("Status", status.rawValue))
                                .annotation {
                                    Text("\(count)")
                                        .font(.caption)
                                        .foregroundColor(.primary)
                                }
                            }
                        }
                    }
                }
                .chartForegroundStyleScale([
                    "Won": .green,
                    "Lost": .red,
                    "Running": .orange
                ])
                .frame(height: 300)
                .gesture(
                    DragGesture()
                        .onEnded { value in
                            withAnimation {
                                if value.translation.width < -50 {
                                    navigateToNext()
                                } else if value.translation.width > 50 {
                                    navigateToPrevious()
                                }
                            }
                        }
                )
            }
            .padding(6)
            
#if os(macOS)
            MacOSControlls()
#endif
        }
    }
    
    @ViewBuilder
    func MacOSControlls() -> some View {
        HStack {
            Button(action: {
                withAnimation {
                    withAnimation {
                        navigateToPrevious()
                    }
                }
            }) {
                Image(systemName: "chevron.compact.left")
                    .font(.largeTitle.bold())
                    .padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 5, style: .continuous))
            }
            .buttonStyle(PlainButtonStyle())
//                        .disabled(currentIndex == 0) // Disable if at the beginning
            
            Spacer()
            
            Button(action: {
                withAnimation {
                    withAnimation {
                        navigateToNext()
                    }
                }
            }) {
                Image(systemName: "chevron.compact.right")
                    .font(.largeTitle.bold())
                    .padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 5, style: .continuous))
            }
            .buttonStyle(PlainButtonStyle())
//                        .disabled(currentIndex == cardsCount - 1) // Disable if at the end
        }
    }
}

// MARK: - Date Navigation
extension BarChartView {
    var currentDateLabel: String {
        let formatter = DateFormatter()
        switch selectedPeriod {
        case .day:
            formatter.dateStyle = .full
        case .week:
            formatter.dateFormat = "yyyy 'Week' w"
        case .month:
            formatter.dateFormat = "MMMM yyyy"
        }
        return formatter.string(from: selectedDate)
    }
    
    func navigateToPrevious() {
        switch selectedPeriod {
        case .day:
            selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate) ?? selectedDate
        case .week:
            selectedDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: selectedDate) ?? selectedDate
        case .month:
            selectedDate = Calendar.current.date(byAdding: .month, value: -1, to: selectedDate) ?? selectedDate
        }
    }
    
    func navigateToNext() {
        let calendar = Calendar.current
        let today = Date()
        
        switch selectedPeriod {
        case .day:
            if let nextDate = calendar.date(byAdding: .day, value: 1, to: selectedDate),
               calendar.compare(nextDate, to: today, toGranularity: .day) != .orderedDescending {
                selectedDate = nextDate
            }
        case .week:
            if let nextWeek = calendar.date(byAdding: .weekOfYear, value: 1, to: selectedDate),
               calendar.compare(nextWeek, to: today, toGranularity: .weekOfYear) != .orderedDescending {
                selectedDate = nextWeek
            }
        case .month:
            if let nextMonth = calendar.date(byAdding: .month, value: 1, to: selectedDate),
               calendar.compare(nextMonth, to: today, toGranularity: .month) != .orderedDescending {
                selectedDate = nextMonth
            }
        }
    }
}

// MARK: - Data Aggregation with Status Breakdown
extension BarChartView {
    func aggregateDataByDayPeriod(for date: Date) -> [(String, [GameStatus: Int])] {
        let timeSlots = [
            (0, 6),
            (6, 12),
            (12, 18),
            (18, 24)
        ]
        
        var result: [(String, [GameStatus: Int])] = []
        let calendar = Calendar.current
        
        for (start, end) in timeSlots {
            let label = formatTimeRange(start: start, end: end)
            var statusCounts: [GameStatus: Int] = [:]
            
            let filteredGames = data.filter {
                calendar.isDate($0.createdAt, inSameDayAs: date) &&
                (start..<end).contains(calendar.component(.hour, from: $0.createdAt))
            }
            
            for game in filteredGames {
                statusCounts[game.status, default: 0] += 1
            }
            
            result.append((label, statusCounts))
        }
        
        return result
    }
    
    func aggregateDataByWeek(for date: Date) -> [(String, [GameStatus: Int])] {
        let calendar = Calendar.current
        guard let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: date)?.start else { return [] }
        
        let weekDays = calendar.shortWeekdaySymbols
        var result = [(String, [GameStatus: Int])]()
        
        for i in 0..<7 {
            if let day = calendar.date(byAdding: .day, value: i, to: startOfWeek) {
                let label = weekDays[i]
                let filteredGames = data.filter { calendar.isDate($0.createdAt, inSameDayAs: day) }
                var statusCounts: [GameStatus: Int] = [:]
                
                for game in filteredGames {
                    statusCounts[game.status, default: 0] += 1
                }
                
                result.append((label, statusCounts))
            }
        }
        
        return result
    }
    
    func aggregateDataByMonth(for date: Date) -> [(String, [GameStatus: Int])] {
        let calendar = Calendar.current
            
        // Get the range of days in the month
        guard let range = calendar.range(of: .day, in: .month, for: date) else { return [] }
        
        // Extract year and month components
        let components = calendar.dateComponents([.year, .month], from: date)
        
        // Generate all dates in the month
        var allDates: [Date] = []
        for day in range {
            var dayComponent = components
            dayComponent.day = day
            if let date = calendar.date(from: dayComponent) {
                allDates.append(date)
            }
        }
        
        var result = [(String, [GameStatus: Int])]()
        
        for date in allDates {
            let label = "\(calendar.component(.day, from: date))"
            let filteredGames = data.filter { calendar.isDate($0.createdAt, inSameDayAs: date) }
            var statusCounts: [GameStatus: Int] = [:]
            
            for game in filteredGames {
                statusCounts[game.status, default: 0] += 1
            }
            
            result.append((label, statusCounts))
        }
        
        return result
    }
    
    // MARK: - Time Formatting Helpers
    private func formatTimeRange(start: Int, end: Int) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: Locale.current)
        
        let startTime = Calendar.current.date(bySettingHour: start, minute: 0, second: 0, of: Date())!
        let endTime = Calendar.current.date(bySettingHour: end == 24 ? 0 : end, minute: 0, second: 0, of: Date())!
        
        let startStr = formatter.string(from: startTime)
        let endStr = formatter.string(from: endTime)
        
        return "\(startStr) - \(endStr)"
    }
    
    private func formatHour(hour: Int) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: Locale.current)
        
        let date = Calendar.current.date(bySettingHour: hour, minute: 0, second: 0, of: Date())!
        return formatter.string(from: date)
    }
}


struct BarchartView_Previews: PreviewProvider {
    static var previews: some View {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Game.self, configurations: config)
        
        let _ = (1...30).map { i in
            let game = Game(name: "Game \(i)", gridSize: 4)
            game.score = Int.random(in: 0...1000)
            game.hasWon = Bool.random()
            game.createdAt = Calendar.current.date(byAdding: .day, value: -Int.random(in: 0...30), to: Date())!
            container.mainContext.insert(game)
        }
        
        return StatisticsView()
            .modelContainer(container)

    }
}
