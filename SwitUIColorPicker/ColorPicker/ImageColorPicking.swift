//
//  ImageColorPicking.swift
//  SwitUIColorPicker
//
//  Created by Alex Chase on 6/3/19.
//  Copyright © 2019 AlexChase. All rights reserved.
//

import UIKit
import SwiftUI
import Combine

final class ColorPickerData: BindableObject {
    let didChange = PassthroughSubject<ColorPickerData, Never>()
    var selectedColor:UIColor = UIColor.white {
        didSet {
            didChange.send(self)
        }
    }
}

struct PickerView: UIViewRepresentable {
    var view: UIView = UIView(frame: .zero)
    var color: UIColor?
    
    func makeUIView(context: Context) -> UIView { view }
    func updateUIView(_ view: UIView, context: Context) {
        view.backgroundColor = color
    }
}

struct ImageView: View {
    @EnvironmentObject var colorPickerData: ColorPickerData
    var image: UIImage
    
    func getColorAtPoint(_ value:CGPoint) {
        self.colorPickerData.selectedColor = image.getPixelColor(from: value)!
    }
    
    var body:some View {
        return Image(uiImage: image)
            .aspectRatio(1.0, contentMode: .fill)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        self.getColorAtPoint(value.location)
            }
        )
    }
}

struct ColorPickerView: View {
    @EnvironmentObject var colorPickerData: ColorPickerData
    var image:UIImage
    var body: some View {
        VStack {
            ImageView(image: image)
            PickerView(color: self.colorPickerData.selectedColor)
                .frame(height:300)
        }
    }
}
