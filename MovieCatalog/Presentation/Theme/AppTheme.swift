//
//  AppTheme.swift
//  MovieCatalog
//
//  Created by Ayaz Memmedov on 13.09.26.
//
import SwiftUI

enum AppTheme {
    
    // Assets olmadan bele yazmaqda olur
    
    static let background = Color(
        light: Color(hex: "F5F5F7"),
        dark: Color(hex: "14141F")
    )
    static let cardBackground = Color(
        light: Color(hex: "FFFFFF"),
        dark: Color(hex: "1E1E2C")
    )
    static let primaryText = Color(
        light: Color(hex: "1A1A1E"),
        dark: Color(hex: "FFFFFF")
    )

    static let secondaryBackground = Color(
        light: Color(hex: "ECECEE"),
        dark: Color(hex: "2A2A3A")
    )
    
    static let starColor = Color(hex: "FFA726")
    
    static let accent = Color(hex: "2E6BFF")
    
    static let secondaryText = Color(
        light: Color(hex: "6E6E76"),
        dark: Color(hex: "9B9BA8")
    )
    
    static let cornerRadius: CGFloat = 14
    static let spacing: CGFloat = 16
}
