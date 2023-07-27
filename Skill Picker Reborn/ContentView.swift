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
                NavigationLink(destination: CabinView()){
                    Label("Cabins", systemImage: "house")
                }
                NavigationLink(destination: CamperView()){
                    Label("Campers", systemImage: "figure.stand")
                }
                NavigationLink(destination: LeaderView()){
                    Label("Leaders", systemImage: "figure.and.child.holdinghands")
                }
                NavigationLink(destination: SkillView()){
                    Label("Skills", systemImage: "figure.run")
                }
            }
            NullView()
        }
    }
}

struct NullView: View {
    var body: some View {
        Text("This app is from [this repository.](https://github.com/leif-motif/skill-picker-reborn)")
        Text("Check it out, or begin working.")
        .toolbar {
            Text("")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
