//
//  AddCabinView.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-26.
//

import SwiftUI

struct AddCabinView: View {
    @State private var iName = ""
    @State private var senior = "null null"
    @State private var junior = "null null"
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Form {
            TextField("Name:",text: $iName)
                .padding([.top,.horizontal])
            Picker("Senior", selection: $senior) {
                ForEach(zip(fooLeaders.filter{$0.senior}.map(\.fName),fooLeaders.filter{$0.senior}.map(\.lName)).map {$0+" "+$1}, id: \.self){
                    Text($0).tag($0)
                }
            }
            .padding([.top,.horizontal])
            Picker("Junior", selection: $junior) {
                ForEach(zip(fooLeaders.filter{!$0.senior}.map(\.fName),fooLeaders.filter{!$0.senior}.map(\.lName)).map {$0+" "+$1}, id: \.self){
                    Text($0).tag($0)
                }
            }
                .padding([.horizontal])
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                Button("Create Cabin"){
                    dismiss()
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.vertical,.trailing])
        }
    }
}

struct AddCabinView_Previews: PreviewProvider {
    static var previews: some View {
        AddCabinView()
    }
}
