//
//  ContentView.swift
//  SwitUIColorPicker
//
//  Created by Alex Chase on 6/3/19.
//  Copyright © 2019 AlexChase. All rights reserved.
//

import SwiftUI

struct ContentView : View {
    @EnvironmentObject var colorPickerData: ColorPickerData
    var image:UIImage = UIImage(named: "colors")! 
    var body: some View {
        ColorPickerView(imageView: ImageView(image: image))
    }
}
