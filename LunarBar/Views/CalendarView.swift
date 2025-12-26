//
//  CalendarView.swift
//  LunarBar
//
//  Created by ruihelin on 2025/9/28.
//

import SwiftUI

struct CalendarView: View {
  @ObservedObject var calendarManager: CalendarManager

  var columns: [GridItem] {
    let count = SettingsManager.weekNumberDisplayMode == .show ? 8 : 7
    return Array(repeating: GridItem(.flexible(), spacing: 0), count: count)
  }

  let calendar = Calendar.Based

  var body: some View {
    VStack(spacing: 0) {
      // 1. Compact Header
      HStack {
        // Year/Month
        HStack(spacing: 4) {
          Text(calendarManager.selectedMonth, format: .dateTime.year())
            .font(.system(size: 14, weight: .medium))
          Text(calendarManager.selectedMonth, format: .dateTime.month())
            .font(.system(size: 14, weight: .medium))
        }
        .foregroundColor(.white)
        .onTapGesture {
          // Simple logic to reset to current month for now, or expand picker later
          calendarManager.goToCurrentMonth()
        }

        Spacer()

        // Navigation
        HStack(spacing: 16) {
          Button(action: { calendarManager.goToPreviousMonth() }) {
            Image(systemName: "chevron.left")
              .font(.system(size: 12, weight: .bold))
              .foregroundColor(.white.opacity(0.8))
          }
          .buttonStyle(.plain)

          Button(action: { calendarManager.goToNextMonth() }) {
            Image(systemName: "chevron.right")
              .font(.system(size: 12, weight: .bold))
              .foregroundColor(.white.opacity(0.8))
          }
          .buttonStyle(.plain)
        }

        Spacer()

        // Today Button
        Button("今天") {
          calendarManager.resetToToday()
        }
        .font(.system(size: 12))
        .foregroundColor(.white)
        .padding(.horizontal, 8)
        .padding(.vertical, 2)
        .background(Color.white.opacity(0.2))
        .cornerRadius(4)
        .buttonStyle(.plain)
      }
      .padding(.horizontal, 12)
      .frame(height: 36)
      .background(
        LinearGradient(
          gradient: Gradient(colors: [Color.red.opacity(0.9), Color.orange.opacity(0.8)]),
          startPoint: .leading, endPoint: .trailing)
      )

      // 2. Info Panel
      HStack(alignment: .center, spacing: 0) {
        // Left: Big Date
        VStack(alignment: .leading, spacing: 0) {
          HStack(alignment: .firstTextBaseline, spacing: 6) {
            Text("\(calendar.component(.day, from: calendarManager.selectedDay))")
              .font(.system(size: 32, weight: .bold, design: .rounded))
              .foregroundColor(.primary)

            Text(weekdayString(from: calendarManager.selectedDay))
              .font(.system(size: 14, weight: .medium))
              .foregroundColor(.secondary)
          }

          Text(calendarManager.selectedDayLunar)  // Using existing property for now, potentially update logic
            .font(.system(size: 12))
            .foregroundColor(.gray)
        }
        .padding(.leading, 12)
        .frame(maxWidth: .infinity, alignment: .leading)

        // Right: Detailed Info (Ganzhi, Solar Term)
        VStack(alignment: .trailing, spacing: 4) {
          if let day = getSelectedCalendarDay() {
            if let ganzhiYear = day.ganzhi_year, let zodiac = day.zodiac {
              Text("\(ganzhiYear)(\(zodiac))年")
                .font(.system(size: 12))
                .foregroundColor(.secondary)
            }

            Text("\(day.ganzhi_month ?? "")月 \(day.ganzhi_day ?? "")日")
              .font(.system(size: 12))
              .foregroundColor(.secondary)

            if let solarTerm = day.solar_term {
              Text(solarTerm)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.red)
            }

            // Yi/Ji
            if !day.yi.isEmpty {
              Text("宜: " + day.yi.prefix(3).joined(separator: " "))
                .font(.system(size: 10))
                .foregroundColor(.green.opacity(0.8))
                .fixedSize(horizontal: true, vertical: false)
            }
            if !day.ji.isEmpty {
              Text("忌: " + day.ji.prefix(3).joined(separator: " "))
                .font(.system(size: 10))
                .foregroundColor(.red.opacity(0.8))
                .fixedSize(horizontal: true, vertical: false)
            }

            // Lucky Spirits
            if let joy = day.lucky_joy, let wealth = day.lucky_wealth,
              let fortune = day.lucky_fortune
            {
              Text("喜神\(joy) 财神\(wealth) 福神\(fortune)")
                .font(.system(size: 10))
                .foregroundColor(.orange)
                .fixedSize(horizontal: true, vertical: false)
            }
          }
        }
        .padding(.trailing, 12)
      }
      .frame(height: 90)
      .background(Color.clear)  // Translucent/Glass effect provided by window/parent usually

      Divider()
        .opacity(0.5)

      // 3. Grid Section
      VStack(spacing: 0) {
        // Weekday Headers
        HStack(spacing: 0) {
          ForEach(calendarManager.weekdays, id: \.self) { day in
            Text(day)
              .font(.system(size: 10, weight: .medium))
              .foregroundColor(.gray)
              .frame(maxWidth: .infinity)
          }
        }
        .frame(height: 24)
        .background(Color.gray.opacity(0.05))

        // Calendar Grid
        LazyVGrid(columns: columns, spacing: 0) {
          ForEach(calendarManager.calendarDays, id: \.self) { day in
            if day.is_weekNumber == true {
              Text("\(day.weekNumber!)")
                .font(.system(size: 10))
                .frame(maxWidth: .infinity, minHeight: 30)
                .foregroundColor(.gray.opacity(0.4))
            } else {
              DayCell(
                day: day,
                isSelected: calendar.isDate(
                  day.date!, equalTo: calendarManager.selectedDay, toGranularity: .day),
                calendarManager: calendarManager)
            }
          }
        }
      }
      .padding(.bottom, 8)
    }
    .frame(width: 320)  // Set a fixed width for compact menu bar size
  }

  private func weekdayString(from date: Date) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "zh_CN")
    formatter.dateFormat = "EEEE"
    return formatter.string(from: date)
  }

  private func getSelectedCalendarDay() -> CalendarDay? {
    return calendarManager.calendarDays.first { day in
      guard let date = day.date else { return false }
      return calendar.isDate(date, equalTo: calendarManager.selectedDay, toGranularity: .day)
    }
  }
}

struct DayCell: View {
  let day: CalendarDay
  let isSelected: Bool
  let calendarManager: CalendarManager
  let calendar = Calendar.Based

  var body: some View {
    ZStack {
      // Selection Background
      if isSelected {
        Circle()
          .fill(Color.red.opacity(0.8))
          .frame(width: 28, height: 28)
      } else if day.is_today {
        Circle()
          .frame(width: 28, height: 28)
          .foregroundColor(.clear)
          .overlay(
            Circle()
              .stroke(Color.red, lineWidth: 1)
          )
      }

      // Content
      VStack(spacing: -1) {
        Text("\(calendar.component(.day, from: day.date!))")
          .font(.system(size: 14))
          .foregroundColor(textColor)

        Text(subtitleText)
          .font(.system(size: 8))
          .foregroundColor(subtitleColor)
          .scaleEffect(0.9)
      }

      // Badges
      if day.offday != nil {
        Text(day.offday == true ? "休" : "班")
          .font(.system(size: 8))
          .foregroundColor(.white)
          .padding(1)
          .background(day.offday == true ? Color.green.opacity(0.8) : Color.brown.opacity(0.8))
          .cornerRadius(2)
          .offset(x: 10, y: -10)
      }

      // Event Dot
      if !day.events.isEmpty {
        Circle()
          .fill(day.events.first?.color.color ?? .gray)
          .frame(width: 3, height: 3)
          .offset(y: 12)
      }
    }
    .frame(height: 36)  // Compact cell height
    .contentShape(Rectangle())
    .onTapGesture {
      if let date = day.date {
        calendarManager.getSelectedDayEvents(date: date)
      }
    }
  }

  var textColor: Color {
    if isSelected { return .white }
    if !day.is_currentMonth { return .gray.opacity(0.4) }
    if day.is_today { return .red }
    if isWeekend { return .secondary }
    return .primary
  }

  var subtitleColor: Color {
    if isSelected { return .white.opacity(0.8) }
    if !day.is_currentMonth { return .gray.opacity(0.3) }
    return .gray
  }

  var subtitleText: String {
    if !day.holidays.isEmpty { return day.holidays[0] }
    return day.solar_term ?? day.short_lunar ?? ""
  }

  var isWeekend: Bool {
    guard let date = day.date else { return false }
    let weekday = calendar.component(.weekday, from: date)
    return weekday == 1 || weekday == 7
  }
}
