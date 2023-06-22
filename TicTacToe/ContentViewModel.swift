//
//  ContentViewModel.swift
//  TicTacToe
//
//  Created by Loy Yee Ko on 22/6/2023.
//

import Foundation
import SwiftUI


enum Player {
	case home, visitor
}

struct Move {
	let player: Player
	let boardIndex: Int

	// computed property
	var indicator: String {
		return player == .home ? "circle" : "xmark"
	}
}

struct AlertItem: Identifiable {
	let id = UUID()
	var title : Text
	var message : Text
	var buttonText : Text
}

struct AlertContext {
	static let homeWin = AlertItem(title: Text("Home Has WON!🎉"), message: Text("Great Job! That's was tough, eh?🔥"), buttonText: Text("OK, Next?"))
	static let visitorWin = AlertItem(title: Text("Visitor Has WON!🎉") , message: Text("Home play needs work harder!🤔"), buttonText: Text("Beat this guy"))
	static let draw = AlertItem(title: Text("Got No Win 🙈"), message: Text("Great Defence🛡️"), buttonText: Text("Don't be so defensive alright?"))
}

final class ContentViewModel: ObservableObject {

	let columns: [GridItem] = [
		GridItem(.flexible()),
		GridItem(.flexible()),
		GridItem(.flexible()),
	]

	let winPatterns: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]



	@Published var gameRounds = 9
	@Published var moves: [Move?] = Array(repeating: nil, count: 9)
	@Published var isHomeTurn = true
	@Published var alertItem: AlertItem?

	var isGameBoardDisabled = false

	// game logic
	func checkSpaceAvailable(in moves: [Move?], with index: Int) -> Bool {
		return moves.contains( where: { $0?.boardIndex == index })
	}
	
	func checkWinCondition(for player: Player , in moves: [Move?]) -> Bool {
		/// remove all nil and only the right player
		let playerMoves = moves.compactMap{ $0 }.filter { $0.player == player }
		/// extract the boardIndex
		let playerPositions = Set(playerMoves.map{ $0.boardIndex })

		for pattern in winPatterns where pattern.isSubset(of: playerPositions) { return true }
		return false
	}

	func checkDrawCondition(in moves : [Move?]) -> Bool {
		return moves.compactMap { $0 }.count == 9
	}

	func determineVisitorMove(for moves: [Move?]) -> Int {
		var randomBoardIndex = Int.random(in: 0..<9)
		while checkSpaceAvailable(in: moves, with: randomBoardIndex) {
			randomBoardIndex = Int.random(in: 0..<9)
		}
		return randomBoardIndex
	}
	func resetGame() {
		moves = Array(repeating: nil, count: 9)
	}
}
