//
//  CamperInfoView.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-08-01.
//

import SwiftUI

struct CamperInfoView: View {
    private var camperSelection: Set<Camper.ID>
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Form {
            Button("Dismiss") {
                dismiss()
            }
        }
    }
    init(camperSelection: Set<Camper.ID>) throws {
        if(camperSelection.count == 0){
            throw SPRError.EmptySelection
        }
        self.camperSelection = camperSelection
    }
}

/*
struct CamperInfoView_Previews: PreviewProvider {
    static var previews: some View {
        CamperInfoView()
    }
}*/
