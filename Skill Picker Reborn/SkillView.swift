//
//  SkillView.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-25.
//

import SwiftUI



struct SkillView: View {
    @State private var selectedFlavor: Flavor = .chocolate
    @State private var sortOrder = [KeyPathComparator(\Camper.lName)]
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("This is SkillView.")
            Table(campers, sortOrder: $sortOrder){
                TableColumn("First Name",value: \.fName)
                TableColumn("Last Name",value: \.lName)
                TableColumn("Cabin",value: \.cabin)
            }
        }
        .toolbar {
            Button {
                
            } label: {
                Image(systemName: "rectangle.stack.badge.plus")
            }
            .help("Add Skill")
            Button {
                
            } label: {
                Image(systemName: "rectangle.badge.plus")
            }
            .help("Add Fanatic")
            Picker("Flavor", selection: $selectedFlavor) {
                Text("Chocolate").tag(Flavor.chocolate)
                Text("Vanilla").tag(Flavor.vanilla)
                Text("Strawberry").tag(Flavor.strawberry)
            }
            TextField("Search", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
        }
    }
}

struct SkillView_Previews: PreviewProvider {
    static var previews: some View {
        SkillView()
    }
}
