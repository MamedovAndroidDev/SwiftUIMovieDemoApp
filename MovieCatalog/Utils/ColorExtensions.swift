//
//  Color.swift
//  MovieCatalog
//
//  Created by Ayaz Memmedov on 13.09.26.
//
import SwiftUI

extension Color {
    // Bunu bir yerden goturdum. Sadece maraqli idiki assets olmadan ancaq kodla sisteme tanitmaq olar
    // Burda Double((rgb >> 16) & 0xFF) hisse anlamdim. Arasdirma edecem. Onu bilirem say sistemi elaqeli emeliyyat gedir.
    //reng kodu 16-liqdadir oda 255 bolub yeqin  onluq kecirdi ve rgb deyerler olaraq arxada oz konstruktoruna oturur.
    init(hex: String) {
        let scanner = Scanner(string: hex.trimmingCharacters(in: .init(charactersIn: "#")))
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)

        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255

        self.init(red: r, green: g, blue: b)
    }
    
    // Burda constructor overload extension olaraq yazilib gelen rengle syste  interfaceStyle gore set edir.
    init(light: Color, dark: Color) {
        self.init(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(dark)
                : UIColor(light)
        })
    }
}
