//
//  BarView.swift
//  
//
//  Created by Clive on 08/08/2020.
//
import Foundation
import SwiftUI

struct ThumbValueSliderBar : View {
    var color : Color
    var body: some View {
        RoundedRectangle(cornerRadius: 2, style: .continuous)
            .fill(color)
            .frame( height: 3)
    }
}
