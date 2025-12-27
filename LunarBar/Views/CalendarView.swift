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
      // 1. New Header Section
      HStack {
        // Left: Previous Month
        Button(action: { calendarManager.goToPreviousMonth() }) {
          Image(systemName: "chevron.left")
            .font(.system(size: 14, weight: .bold))
            .foregroundColor(.white)
            .frame(width: 32, height: 32)
            .background(Color.white.opacity(0.2))
            .cornerRadius(8)
        }
        .buttonStyle(.plain)

        Spacer()

        // Center: Year & Month
        Text(
          "\(calendarManager.selectedMonth, format: .dateTime.year())年 \(calendarManager.selectedMonth, format: .dateTime.month())"
        )
        .font(.system(size: 18, weight: .bold))
        .foregroundColor(.white)

        Spacer()

        // Right: Next Month & Today
        HStack(spacing: 8) {
          Button(action: { calendarManager.goToNextMonth() }) {
            Image(systemName: "chevron.right")
              .font(.system(size: 14, weight: .bold))
              .foregroundColor(.white)
              .frame(width: 32, height: 32)
              .background(Color.white.opacity(0.2))
              .cornerRadius(8)
          }
          .buttonStyle(.plain)

          Button("今天") {
            calendarManager.resetToToday()
          }
          .font(.system(size: 12, weight: .medium))
          .foregroundColor(.white)
          .padding(.horizontal, 10)
          .padding(.vertical, 6)
          .background(Color.white.opacity(0.2))
          .cornerRadius(8)
          .buttonStyle(.plain)
        }
      }
      .padding(.horizontal, 16)
      .padding(.vertical, 12)
      .background(
        LinearGradient(
          gradient: Gradient(colors: [Color.red, Color.orange]),
          startPoint: .leading, endPoint: .trailing)
      )

      // 2. Info Cards (Card Style)
      if let day = getSelectedCalendarDay() {
        VStack(spacing: 12) {

          // A. Date Info Card
          HStack(spacing: 16) {
            // Big Date Number
            Text("\(calendar.component(.day, from: day.date!))")
              .font(.system(size: 64, weight: .bold, design: .rounded))
              .foregroundColor(Color(hex: "C62828"))  // Dark Red

            VStack(alignment: .leading, spacing: 4) {
              Text(weekdayString(from: day.date!))
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.orange)

              HStack(spacing: 4) {
                Text(day.full_lunar ?? "")
                  .font(.system(size: 12))
                  .foregroundColor(.secondary)
              }

              if let solarTerm = day.solar_term {
                HStack(spacing: 4) {
                  Image(systemName: "bolt.fill")
                    .font(.system(size: 10))
                    .foregroundColor(.orange)
                  Text("\(solarTerm) \(day.ganzhi_month ?? "") \(day.ganzhi_day ?? "")")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(Color(hex: "B71C1C"))
                }
                .padding(.top, 2)
              }
            }
            Spacer()
          }
          .padding(16)
          .background(Color(hex: "FFF9E8"))
          .cornerRadius(12)
          .overlay(
            RoundedRectangle(cornerRadius: 12)
              .stroke(Color(hex: "E6DABf"), lineWidth: 1)
          )
          .padding(.horizontal, 16)

          // B. Yi / Ji Row Cards
          HStack(spacing: 12) {
            // Yi Card
            HStack(alignment: .top, spacing: 8) {
              Text("宜")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
                .padding(6)
                .background(Circle().fill(Color(hex: "4CAF50")))

              Text(day.yi.joined(separator: " "))
                .font(.system(size: 11))
                .foregroundColor(.primary)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(hex: "E8F5E9"))
            .cornerRadius(8)
            .overlay(
              RoundedRectangle(cornerRadius: 8)
                .stroke(Color(hex: "C8E6C9"), lineWidth: 1)
            )

            // Ji Card
            HStack(alignment: .top, spacing: 8) {
              Text("忌")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
                .padding(6)
                .background(Circle().fill(Color(hex: "D32F2F")))

              Text(day.ji.isEmpty ? "诸事不宜" : day.ji.joined(separator: " "))
                .font(.system(size: 11))
                .foregroundColor(.primary)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(hex: "FFEBEE"))
            .cornerRadius(8)
            .overlay(
              RoundedRectangle(cornerRadius: 8)
                .stroke(Color(hex: "FFCDD2"), lineWidth: 1)
            )
          }
          .padding(.horizontal, 16)

          // C. Lucky Spirits Card
          HStack(spacing: 0) {
            // Joy
            VStack(spacing: 4) {
              Text("喜神")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.gray)
              Text(day.lucky_joy ?? "-")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.orange)
            }
            .frame(maxWidth: .infinity)

            // Wealth
            VStack(spacing: 4) {
              Text("财神")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.gray)
              Text(day.lucky_wealth ?? "-")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.orange)
            }
            .frame(maxWidth: .infinity)

            // Fortune
            VStack(spacing: 4) {
              Text("福神")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.gray)
              Text(day.lucky_fortune ?? "-")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.orange)
            }
            .frame(maxWidth: .infinity)
          }
          .padding(.vertical, 12)
          .background(Color(hex: "FFF8E1"))
          .cornerRadius(12)
          .overlay(
            RoundedRectangle(cornerRadius: 12)
              .stroke(Color(hex: "FFE0B2"), lineWidth: 1)
          )
          .padding(.horizontal, 16)
          .padding(.bottom, 8)

        }
      } else {
        // Fallback placeholders
        VStack {
          Text("Select a date")
        }.frame(height: 120)
      }

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
        .padding(.horizontal, 12)
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
        .padding(.horizontal, 12)
      }
      .padding(.bottom, 8)
    }
    .frame(width: 320)  // Set a fixed width for compact menu bar size
  }

  private func isHoliday(_ day: CalendarDay) -> Bool {
    return !day.holidays.isEmpty
  }

  private func isWeekend(_ day: CalendarDay) -> Bool {
    guard let date = day.date else { return false }
    let weekday = calendar.component(.weekday, from: date)
    return weekday == 1 || weekday == 7
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
