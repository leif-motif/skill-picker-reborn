//
//  ContentView.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                Label("Campers", systemImage: "figure.stand")
                Label("Skills", systemImage: "figure.run")
                Label("Cabins", systemImage: "house")
                Label("Leaders", systemImage: "figure.and.child.holdinghands")
            }
            CamperView()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
