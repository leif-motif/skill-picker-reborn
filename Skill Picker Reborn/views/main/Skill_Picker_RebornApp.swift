/*
 * Skill_Picker_RebornApp.swift
 * This file is part of Skill Picker Reborn
 *
 * Copyright (C) 2025 Ranger Lake Bible Camp
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

let supportedVersions = ["0.1","1.1.0","1.2.0","1.2.1","1.2.1a","1.2.2"]

@main
struct Skill_Picker_RebornApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var data = CampData()
    @State private var campThatShouldNotBeLoaded = Camp()
    @State private var jsonWarningConfirm = false
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(data)
                .sheet(isPresented: $data.addCamperSheet) {
                } content: {
                    AddCamperView()
                        .environmentObject(data)
                }
                .sheet(isPresented: $data.addLeaderSheet) {
                } content: {
                    AddLeaderView()
                        .environmentObject(data)
                }
                .sheet(isPresented: $data.addCabinSheet, onDismiss: {
                    data.objectWillChange.send()
                }, content: {
                    ModifyCabinView()
                        .environmentObject(data)
                })
                .sheet(isPresented: $data.addSkillSheet){
                } content: {
                    try! ModifySkillView()
                        .environmentObject(data)
                }
                .sheet(isPresented: $data.addFanaticSheet){
                } content: {
                    ModifyFanaticView()
                        .environmentObject(data)
                }
                .sheet(isPresented: $data.importSkillSheet, onDismiss: {
                    if(data.isImporting){
                        data.cabinsFromCSV(csv: data.csvInput)
                        try! data.campersFromCSV(csv: data.csvInput)
                        data.isImporting = false
                    }
                    data.objectWillChange.send()
                }, content: {
                    try! ImportSkillView(data: data)
                })
                .confirmationDialog("WARNING!", isPresented: $jsonWarningConfirm, presenting: campThatShouldNotBeLoaded){ c in
                    Button(role: .cancel){
                    } label: {
                        Text("Stop")
                    }
                    Button(role: .destructive){
                        data.c = campThatShouldNotBeLoaded
                    } label: {
                        Text("Load Anyway")
                    }
                } message: { c in
                    Text("You are attempting to load the same file or version of a file over itself! This WILL cause errors in viewing data in this session. If you want to reload your file, restart the app and load the camp once more. If you still wish to load the same file over itself, select \"Load Anyway\" AT YOUR OWN RISK.")
                }
                .confirmationDialog("Warning!", isPresented: $data.ignoreIdiotsConfirm){
                    Button(role: .cancel){
                    } label: {
                        Text("Stop")
                    }
                    Button(role: .destructive){
                        data.importSkillSheet.toggle()
                    } label: {
                        Text("Import Anyway")
                    }
                } message: {
                    if(data.majorIdiots.isEmpty){
                        Text("Some campers have incorrectly filled out entries! You may import the CSV anyway and let the app attempt to interpret any erronous data, or stop.\n\nThe following campers have minor errors:\n\(data.idiots)")
                    } else if(data.idiots.isEmpty){
                        Text("Some campers have incorrectly filled out entries! You may import the CSV anyway and let the app attempt to interpret any erronous data, or stop.\n\nThe following campers have major errors:\n\(data.majorIdiots)")
                    } else {
                        Text("Some campers have incorrectly filled out entries! You may import the CSV anyway and let the app attempt to interpret any erronous data, or stop.\n\nThe following campers have major errors:\n\(data.majorIdiots)\n\nThe following campers have minor errors:\n\(data.idiots)")
                    }
                }
                .confirmationDialog("Warning!", isPresented: $data.clearSkillsConfirm){
                    Button(role: .cancel){
                    } label: {
                        Text("Stop")
                    }
                    Button(role: .destructive){
                        try! data.clearAllCamperSkills()
                    } label: {
                        Text("Clear All Skills")
                    }
                } message: {
                    Text("Are you sure to wish to clear all of the campers' skills?")
                }
                .alert("Error!", isPresented: $data.genericErrorAlert, presenting: data.genericErrorDesc){ _ in
                    Button(){
                    } label: {
                        Text("Dismiss")
                    }
                } message: { e in
                    Text(e)
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
                            let encoded = try encoder.encode(data.c)
                            try encoded.write(to: url)
                        } catch {
                            data.genericErrorDesc = "Failed to save app state: \(error.localizedDescription)"
                            data.genericErrorAlert.toggle()
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
                            let urlData = try Data(contentsOf: url)
                            let decoder = JSONDecoder()
                            let decoded = try decoder.decode(Camp.self, from: urlData)
                            #warning("TODO: clear undo history")
                            if(data.c.id == decoded.id){
                                campThatShouldNotBeLoaded = decoded
                                jsonWarningConfirm.toggle()
                            } else {
                                data.c = decoded
                                data.objectWillChange.send()
                            }
                        } catch SPRError.UnsupportedVersion(let e){
                            data.genericErrorDesc = "The current app version (\((Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String)!)) is incompatable with the selected JSON's version (\(e))."
                            data.genericErrorAlert.toggle()
                        } catch {
                            data.genericErrorDesc = "Failed to load app state: \(error.localizedDescription)"
                            data.genericErrorAlert.toggle()
                        }
                    }
                }
                .keyboardShortcut("O", modifiers: [.command])
            }
            CommandGroup(before: .importExport){
                Button("Import CSV..."){
                    data.importFromCSV()
                }
                .keyboardShortcut("I", modifiers: [.command])
            }
            CommandGroup(replacing: .undoRedo){
                //nothing... for now!
            }
            CommandGroup(before: .pasteboard){
                Menu("New"){
                    Button("New Camper..."){
                        data.addCamperSheet.toggle()
                    }
                    Button("New Leader..."){
                        data.addLeaderSheet.toggle()
                    }
                    Button("New Cabin..."){
                        data.addCabinSheet.toggle()
                    }
                    Button("New Skill..."){
                        data.addSkillSheet.toggle()
                    }
                    Button("New Fanatic..."){
                        data.addFanaticSheet.toggle()
                    }
                }
                Button("Assign Preferred Skills"){
                    do {
                        try data.processPreferredSkills()
                    } catch SPRError.NoSkills {
                        data.genericErrorDesc = "There are no skills to assign campers to!"
                        data.genericErrorAlert.toggle()
                    } catch SPRError.NotEnoughSkillSpace {
                        data.genericErrorDesc = "There is not enough space in the skills to accomodate all campers."
                        data.genericErrorAlert.toggle()
                    } catch {
                        data.genericErrorDesc = "Failed to process skills: \(error.localizedDescription)"
                        data.genericErrorAlert.toggle()
                    }
                }
                Button("Clear All Skills..."){
                    data.clearSkillsConfirm.toggle()
                }
                Divider()
            }
        }
    }
}
