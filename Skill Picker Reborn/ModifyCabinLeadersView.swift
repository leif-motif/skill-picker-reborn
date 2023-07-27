//
//  ModifyCabinLeadersView.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-27.
//

import SwiftUI

struct ModifyCabinLeadersView: View {
    @State private var seniorSelection = "null null"
    @State private var juniorSelection = "null null"
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Form {
            Picker("Senior", selection: $seniorSelection) {
                ForEach(zip(fooLeaders.filter{$0.senior}.map(\.fName),fooLeaders.filter{$0.senior}.map(\.lName)).map {$0+" "+$1}, id: \.self){
                    Text($0).tag($0)
                }
            }
            .padding([.top,.horizontal])
            Picker("Junior", selection: $juniorSelection) {
                ForEach(zip(fooLeaders.filter{!$0.senior}.map(\.fName),fooLeaders.filter{!$0.senior}.map(\.lName)).map {$0+" "+$1}, id: \.self){
                    Text($0).tag($0)
                }
            }
            .padding([.bottom,.horizontal])
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                Button("Change Cabin Leaders") {
                    //modify the cabin's leaders
                    dismiss()
                }
            }
            .padding([.bottom,.trailing])
        }
    }
}

struct ModifyCabinLeadersView_Previews: PreviewProvider {
    static var previews: some View {
        ModifyCabinLeadersView()
    }
}
