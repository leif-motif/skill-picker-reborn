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

@main
struct Skill_Picker_RebornApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var campData = CampData()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(campData)
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
                            campData.c = decoded
                            campData.objectWillChange.send()
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
