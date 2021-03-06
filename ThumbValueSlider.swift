//
//  ThumbView.swift
//  
//
//  Created by Clive on 08/08/2020.
//
import SwiftUI
import Foundation

struct ThumbValueSlider: View {
    @Binding var value: CGFloat
    @State var currentPosition: CGSize = .zero
    @State var newPosition: CGSize = .zero
    @State var changing : Bool = false
    
    let range : ClosedRange<Double>
    var step : Double = 0.01
    var textColor : Color? = Color.black
    var accentColor: Color? = Color.red
    var unselectedColor: Color? = Color(UIColor(white: 0.85, alpha: 1.0))
    var label : String? = nil
    
    var asInteger : Bool = false
    let thumbRadius : CGFloat = 13
    let thumbDiameter : CGFloat = 26
    let frameHeight : CGFloat =  32
    
    var body: some View {
        VStack {
            if   label != nil {
                Text(label!).foregroundColor(textColor)
            }
            HStack {
                HStack {
                    Text(formatStr(for: range.lowerBound, asInteger: asInteger)).foregroundColor(textColor)
                    GeometryReader { geometry in
                        ZStack {
                            HStack (spacing: 0) {
                                ThumbValueSliderBar(color: self.accentColor! )
                                    .frame(width: self.horizontalValue(for: self.value, given: geometry) )
                                ThumbValueSliderBar(color: self.unselectedColor!)
                                    .frame(width: self.horizontalValue(for: CGFloat(self.range.lowerBound + self.range.upperBound) - self.value, given: geometry) )
                            }
                            
                            Text(self.formatStr(for: Double(self.value), asInteger: self.asInteger))
                                .frame(width: self.thumbDiameter, height: self.thumbDiameter, alignment: .center)
                                .background(Color.white)
                                .clipShape(Circle()).shadow(color: .gray, radius: 3, x: 0, y: 2)
                                .font(.system(size: 10))
                                .foregroundColor(self.textColor)
                                .position(CGPoint(x: self.horizontalValue(for: self.value, given: geometry),y: geometry.size.height/2))
                                .gesture(DragGesture(minimumDistance: 0 , coordinateSpace: .local)
                                    .onChanged { value  in
                                        let position = value.location
                                        self.value =  CGFloat(self.value(for: position, given: geometry))
                                        self.currentPosition = CGSize(width: value.translation.width + self.newPosition.width, height: self.currentPosition.height)
                                        self.changing = true
                                }
                                .onEnded{value in
                                    self.changing = false
                                    }
                                    )
                            
                        }
                        
                    }
                    .frame( height: frameHeight, alignment: .center)
                    .padding([.leading,.trailing ],CGFloat(thumbRadius) )
                    Text(formatStr(for: range.upperBound, asInteger: asInteger))
                        .foregroundColor(textColor)
                }
            }
        }
    }
    
    private func formatStr(for value: Double, asInteger: Bool) -> String {
        if asInteger {
            return String( Int ( value ))
        }
        return String(value)
    }
    
    private func horizontalValue(for value: CGFloat, given geometry: GeometryProxy ) -> CGFloat {
        geometry.size.width * CGFloat(value - CGFloat(range.lowerBound))/CGFloat(range.upperBound-range.lowerBound) //+ thumbRadius
    }
    
    private func value(for position: CGPoint, given geometry: GeometryProxy ) -> Double {
        var out =  range.lowerBound +  Double(position.x/geometry.size.width) * (range.upperBound-range.lowerBound)
        if (step == step) {
            out = out - out.remainder(dividingBy: step ) + range.lowerBound
        }
        
        return max(min(out,range.upperBound),range.lowerBound)
    }
    
}
