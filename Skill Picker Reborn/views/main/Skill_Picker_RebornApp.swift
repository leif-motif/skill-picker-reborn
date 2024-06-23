/*
 * Skill_Picker_RebornApp.swift
 * This file is part of Skill Picker Reborn
 *
 * Copyright (C) 2024 Ranger Lake Bible Camp
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

let supportedVersions = ["0.1","1.1.0"]

@main
struct Skill_Picker_RebornApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var campData = CampData()
    @State private var jsonWarningConfirm = false
    @State private var campThatShouldNotBeLoaded = Camp()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(campData)
                .confirmationDialog("WARNING", isPresented: $jsonWarningConfirm, presenting: campThatShouldNotBeLoaded){ c in
                    Button(role: .cancel){
                    } label: {
                        Text("Stop")
                    }
                    Button(role: .destructive){
                        campData.c = campThatShouldNotBeLoaded
                    } label: {
                        Text("Continue")
                    }
                } message: { c in
                    Text("You are attempting to load the same file or version of a file over itself! This WILL cause errors in viewing data in this session. If you want to reload your file, restart the app and load the camp once more. If you still wish to load the same file over itself, select \"Continue\" AT YOUR OWN RISK.")
                }
        }
        .commands {
            CommandGroup(replacing: CommandGroupPlacement.newItem){
                //nothing!
            }
            CommandGroup(replacing: CommandGroupPlacement.saveItem){
                Button("Save...") {
                    let panel = NSSavePanel()
                    panel.allowedContentTypes = [.json]
                    panel.canCreateDirectories = true
                    panel.isExtensionHidden = false
                    panel.title = "Save your camp"
                    panel.message = "Choose a location to save your camp to"
                    
                    if panel.runModal() == .OK, let url = panel.url {
                        let encoder = JSONEncoder()
                        do {
                            let encoded = try encoder.encode(campData.c)
                            try encoded.write(to: url)
                        } catch {
                            print("Failed to save app state: \(error.localizedDescription)")
                        }
                    }
                }
                .keyboardShortcut("S", modifiers: [.command])
                Button("Load...") {
                    let panel = NSOpenPanel()
                    panel.allowedContentTypes = [.json]
                    panel.allowsMultipleSelection = false
                    panel.canChooseDirectories = false
                    panel.canChooseFiles = true
                    panel.title = "Load your camp"
                    panel.message = "Choose a file to load your camp from"
                    
                    if panel.runModal() == .OK, let url = panel.url {
                        do {
                            let data = try Data(contentsOf: url)
                            let decoder = JSONDecoder()
                            let decoded = try decoder.decode(Camp.self, from: data)
                            #warning("TODO: clear undo history")
                            if(campData.c.id == decoded.id){
                                campThatShouldNotBeLoaded = decoded
                                jsonWarningConfirm.toggle()
                            } else {
                                campData.c = decoded
                                campData.objectWillChange.send()
                            }
                        } catch {
                            print("Failed to load app state: \(error)")
                        }
                    }
                }
                .keyboardShortcut("O", modifiers: [.command])
            }
        }
    }
}
