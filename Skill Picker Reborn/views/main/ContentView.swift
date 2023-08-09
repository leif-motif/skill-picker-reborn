/*
 * ContentView.swift
 * This file is part of Skill Picker Reborn
 *
 * Copyright (C) 2023 Ranger Lake Bible Camp
 *
 * Skill Picker Reborn is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
 * Skill Picker Reborn is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Skill Picker Reborn; if not, see <https://www.gnu.org/licenses/>.
 */

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
            StartView()
                .padding(.bottom, 20)
        }
        .frame(minWidth: 850,
               idealWidth: 850,
               minHeight: 270,
               idealHeight: 600)
    }
}

struct StartView: View {
    @EnvironmentObject private var data: CampData
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Copyright © 2023 Ranger Lake Bible Camp")
                .font(.title)
            Text("This program is free software: you can redistribute it and/or modify\nit under the terms of the GNU General Public License as published by\nthe Free Software Foundation, either version 3 of the License, or\n(at your option) any later version.")
                .font(.body)
            Text("This program is distributed in the hope that it will be useful,\nbut WITHOUT ANY WARRANTY; without even the implied warranty of\nMERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\nGNU General Public License for more details.")
                .font(.body)
            Text("You should have received a copy of the GNU General Public License\nalong with this program.  If not, see [https://www.gnu.org/licenses/](https://www.gnu.org/licenses/).")
                .font(.body)
        }
        .toolbar {
            Button {
                if let url = URL(string: "https://github.com/leif-motif/skill-picker-reborn") {
                    NSWorkspace.shared.open(url)
                }
            } label: {
                Image(systemName: "filemenu.and.cursorarrow")
                    .foregroundColor(Color(.systemBlue))
                
            }
            .help("View Software Repository")
            Button {
                if let url = URL(string: "https://www.gnu.org/licenses/gpl-3.0.html") {
                    NSWorkspace.shared.open(url)
                }
            } label: {
                Image(systemName: "chart.bar.doc.horizontal")
                    .foregroundColor(Color(.systemPink))
                    
            }
            .help("View Software License")
            Button {
                createTestingDataPlus(data: data)
            } label: {
                Image(systemName: "testtube.2")
                    .foregroundColor(Color(.systemCyan))
            }
            .help("Create Testing Data")
            //Text("")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
