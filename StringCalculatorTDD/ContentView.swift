
//  ContentView.swift
//  StringCalculatorTDD
//
//  Created by Varun on 6/21/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var calculator = StringCalculator()
    @State private var inputText = "1,2,3"
    @State private var result = 0
    @State private var errorMessage = ""
    @State private var hasError = false
    @State private var isAnimating = false
    @State private var shake = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    // Header Section
                    headerSection
                    
                    // Input Section
                    inputSection
                    
                    // Calculate Button
                    calculateButton
                    
                    // Result Section
                    resultSection
                    
                    // Examples Section
                    examplesSection
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            .navigationTitle("String Calculator")
            .navigationBarTitleDisplayMode(.large)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        }
    }
    
    // MARK: - UI Components
    private var headerSection: some View {
        VStack(spacing: 15) {
            Image(systemName: "function")
                .font(.system(size: 50))
                .foregroundColor(.blue)
                .scaleEffect(isAnimating ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: isAnimating)
                .onAppear { isAnimating = true }
            
            Text("TDD String Calculator")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text("Enter comma-separated numbers or use custom delimiters")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }
    
    private var inputSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "keyboard")
                    .foregroundColor(.blue)
                Text("Input")
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            
            TextEditor(text: $inputText)
                .frame(height: 120)
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(hasError ? Color.red : Color.blue.opacity(0.3), lineWidth: 2)
                )
                .font(.system(size: 16))
        }
    }
    
    private var calculateButton: some View {
        Button(action: calculateResult) {
            HStack {
                Image(systemName: "equal.circle.fill")
                    .font(.title2)
                Text("Calculate")
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 55)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue, Color.purple]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(15)
            .shadow(color: .blue.opacity(0.3), radius: 5, x: 0, y: 3)
        }
        .scaleEffect(shake ? 0.95 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: shake)
        .disabled(inputText.isEmpty)
    }
    
    private var resultSection: some View {
        VStack(spacing: 15) {
            HStack {
                Image(systemName: hasError ? "exclamationmark.triangle.fill" : "checkmark.circle.fill")
                    .foregroundColor(hasError ? .red : .green)
                Text("Result")
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            
            VStack(spacing: 10) {
                Text("\(result)")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(hasError ? .red : .green)
                    .scaleEffect(isAnimating ? 1.05 : 1.0)
                
                if hasError && !errorMessage.isEmpty {
                    Text(errorMessage)
                        .font(.subheadline)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(8)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(hasError ? Color.red.opacity(0.05) : Color.green.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(hasError ? Color.red.opacity(0.3) : Color.green.opacity(0.3), lineWidth: 1)
                    )
            )
        }
    }
    
    private var examplesSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(.orange)
                Text("Examples")
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            
            VStack(spacing: 12) {
                ExampleRow(input: "\"\"", output: "0", description: "Empty string")
                ExampleRow(input: "\"1\"", output: "1", description: "Single number")
                ExampleRow(input: "\"1,2,3\"", output: "6", description: "Multiple numbers")
                ExampleRow(input: "\"1\\n2,3\"", output: "6", description: "Newline delimiter")
                ExampleRow(input: "\"//;\\n1;2\"", output: "3", description: "Custom delimiter")
                ExampleRow(input: "\"-1,2\"", output: "Error", description: "Negative numbers")
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
    
    // MARK: - Actions
    private func calculateResult() {
        do {
            result = try calculator.add(inputText)
            hasError = false
            errorMessage = ""
            animateSuccess()
        } catch {
            result = 0
            hasError = true
            errorMessage = error.localizedDescription
            animateError()
        }
    }
    
    // MARK: - Animations
    private func animateSuccess() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            isAnimating.toggle()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.easeOut(duration: 0.2)) {
                isAnimating.toggle()
            }
        }
    }
    
    private func animateError() {
        withAnimation(.easeInOut(duration: 0.1).repeatCount(6, autoreverses: true)) {
            shake.toggle()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            shake = false
        }
    }
}
