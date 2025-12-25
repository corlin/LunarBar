import Foundation

let calendar = Calendar(identifier: .chinese)
let date = Date()

let formatter = DateFormatter()
formatter.calendar = calendar
formatter.locale = Locale(identifier: "zh_CN")

print("--- Testing Standard Formats ---")
formatter.dateFormat = "U"
print("Year Cycle (U): \(formatter.string(from: date))")

formatter.dateStyle = .full
print("Full Date Style: \(formatter.string(from: date))")

formatter.dateStyle = .long
print("Long Date Style: \(formatter.string(from: date))")

formatter.dateStyle = .medium
print("Medium Date Style: \(formatter.string(from: date))")

formatter.dateStyle = .short
print("Short Date Style: \(formatter.string(from: date))")

print("\n--- Testing Custom Formats ---")
// Trying various patterns that might reveal cyclic month/day
let patterns = ["yyyy", "MM", "dd", "UU", "uu", "g", "G", "r", "q"]
for p in patterns {
  formatter.dateFormat = p
  print("Pattern '\(p)': \(formatter.string(from: date))")
}
