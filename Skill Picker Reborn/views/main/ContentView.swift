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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(CampData())
    }
}
