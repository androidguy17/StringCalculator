//
//  StringCalculator.swift
//  StringCalculatorTDD
//
//  Created by Varun on 6/21/25.
//
import Foundation

class StringCalculator: ObservableObject {
    enum CalculatorError: Error, LocalizedError {
        case negativeNumbers([Int])
        
        var errorDescription: String? {
            switch self {
            case .negativeNumbers(let numbers):
                return "negative numbers not allowed \(numbers.map(String.init).joined(separator: ","))"
            }
        }
    }
    
    func add(_ numbers: String) throws -> Int {
        // Step 1: Handle empty string
        guard !numbers.isEmpty else { return 0 }
        
        // Step 2: Parse delimiter and extract numbers string
        let (delimiter, numbersString) = parseDelimiterAndNumbers(from: numbers)
        
        // Step 3: Split by delimiter and newlines
        let components = numbersString.components(separatedBy: CharacterSet(charactersIn: delimiter + "\n"))
        
        // Step 4: Convert to integers and validate
        let integers = try components.compactMap { component -> Int? in
            let trimmed = component.trimmingCharacters(in: .whitespaces)
            return trimmed.isEmpty ? nil : Int(trimmed)
        }
        
        // Step 5: Chec k for negative numbers
        let negativeNumbers = integers.filter { $0 < 0 }
        if !negativeNumbers.isEmpty {
            throw CalculatorError.negativeNumbers(negativeNumbers)
        }
        
        // Step 6: Return sum
        return integers.reduce(0, +)
    }
    
    private func parseDelimiterAndNumbers(from input: String) -> (delimiter: String, numbers: String) {
        // Check if custom delimiter is specified
        if input.hasPrefix("//") {
            let lines = input.components(separatedBy: "\n")
            if lines.count >= 2 {
                let delimiterLine = lines[0]
                let delimiter = String(delimiterLine.dropFirst(2)) // Remove "//"
                let numbersString = lines.dropFirst().joined(separator: "\n")
                return (delimiter, numbersString)
            }
        }
        return (",", input) // Default delimiter
    }
}
