//
//  ContentView.swift
//  TicTacToe
//
//  Created by Loy Yee Ko on 22/6/2023.
//

import SwiftUI

struct ContentView: View {

	@StateObject private var contentViewModel = ContentViewModel()
	@State private var isShowAlert = false

	var body: some View {

		LazyVGrid(columns: contentViewModel.columns) {
			ForEach(0..<9, id: \.self) { index in

				ZStack {

					Circle()
						.stroke(.blue, lineWidth: 5)
					Image(systemName: contentViewModel.moves[index]?.indicator ?? "" )
						.resizable()
						.scaledToFit()
						.frame(width: 40, height: 40)
				}
				.onTapGesture {

					if contentViewModel.checkSpaceAvailable(in: contentViewModel.moves, with: index) { return }

					contentViewModel.moves[index] = Move(player: contentViewModel.isHomeTurn ? .home : .visitor, boardIndex: index)

					if contentViewModel.checkWinCondition(for: contentViewModel.isHomeTurn ? .home : .visitor, in: contentViewModel.moves) {
						
						contentViewModel.alertItem = contentViewModel.isHomeTurn ? AlertContext.homeWin : AlertContext.visitorWin
						return
					}

					if contentViewModel.checkDrawCondition(in: contentViewModel.moves) {
						contentViewModel.alertItem = AlertContext.draw
						return
					}

					contentViewModel.isHomeTurn.toggle()

				}

			}

			.padding()
			.alert(item: $contentViewModel.alertItem, content: { alertItem in
				Alert(title: alertItem.title,
							message: alertItem.message,
							dismissButton:
						.default(
							alertItem.buttonText,
							action: {contentViewModel.resetGame()})
							)

			})

		}
	
	}
}

#Preview {
	ContentView()
}
