//
//  AttendeesView.swift
//  TourMate
//
//  Created by Terence Ho on 25/3/22.
//

import SwiftUI

struct AttendeesView: View {

    // The VM binds to Database. Will not need to fetch
    @ObservedObject var viewModel: TripViewModel

    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(viewModel.attendees, id: \.id) { user in
                        UserIconView(imageUrl: user.imageUrl, name: user.name)
                    }
                    Spacer()
                }
            }
        }
    }
}

// struct AttendeesView_Previews: PreviewProvider {
//    static var previews: some View {
//        AttendeesView()
//    }
// }