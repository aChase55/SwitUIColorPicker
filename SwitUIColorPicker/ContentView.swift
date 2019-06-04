//
//  ContentView.swift
//  SwitUIColorPicker
//
//  Created by Alex Chase on 6/3/19.
//  Copyright © 2019 AlexChase. All rights reserved.
//

import SwiftUI
import Combine

struct ContentView : View {
    @EnvironmentObject var colorPickerData: ColorPickerData
    var body: some View {
        ColorPickerView(image: UIImage(named: "colors")!)
    }
}
