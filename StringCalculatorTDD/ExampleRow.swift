//
//  ExampleRow.swift
//  StringCalculatorTDD
//
//  Created by Varun on 6/21/25.
//


import SwiftUI

struct ExampleRow: View {
    let input: String
    let output: String
    let description: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(input)
                    .font(.system(size: 14).monospaced())
                    .foregroundColor(.blue)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "arrow.right")
                .foregroundColor(.gray)
            
            Text(output)
                .font(.system(size: 14, weight: .semibold, design: .monospaced))
                .foregroundColor(output == "Error" ? .red : .green)
        }
        .padding(.vertical, 4)
    }
}
