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
        self.colorPickerData.selectedColor = image.getPixelColor(point: value, alpha: true)!
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
    var imageView: ImageView
    var body: some View {
        VStack {
            imageView
            PickerView(color: self.colorPickerData.selectedColor)
                .frame(height:300)
        }
    }
}
