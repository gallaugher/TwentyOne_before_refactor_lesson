//
//  ContentView.swift
//  TwentyOne
//
//  Created by John Gallaugher on 11/9/26.
//

import SwiftUI

struct ContentView: View {
    
    enum Suit: String, CaseIterable {
        case spade = "♠️"
        case heart = "❤️"
        case diamond = "♦️"
        case club = "♣️"
    }
    
    enum Rank: Int, CaseIterable {
        case ace = 1, two, three, four, five, six, seven, eight, nine, ten, jack, queen, king
        
        var label: String {
            switch self {
            case .ace: return "A"
            case .jack: return "J"
            case .queen: return "Q"
            case .king: return "K"
            default:
                return "\(self.rawValue)"
            }
        }
        
        var value: Int {// Twenty One: Face cards J, Q, K are 10
            switch self {
            case .jack, .queen, .king:
                return 10
            default:
                return self.rawValue
            }
        }
    }
    
    struct Card: Identifiable {
        let id = UUID().uuidString
        var suit: Suit
        var rank: Rank
    }
    
    @State private var cards: [Card] = []
    @State private var dealerHand: [Card] = []
    @State private var playerHand: [Card] = []
    
    var body: some View {
        VStack {
            Text("Twenty One:")
                .font(.largeTitle)
                .fontWeight(.black)
            
            Text("Dealer Hand: \(total(of: dealerHand))")
            ScrollView(.horizontal){
                HStack {
                    ForEach(dealerHand) { card in
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(.white)
                                .stroke(.black, lineWidth: 1)
                            
                            Text("\(card.rank.label)\(card.suit.rawValue)")
                                .font(.largeTitle)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                        }
                        .frame(width: 70, height: 90)
                    }
                }
            }
            
            Text("Player Hand: \(total(of: playerHand))")
            ScrollView(.horizontal){
                HStack {
                    ForEach(playerHand) { card in
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(.white)
                                .stroke(.black, lineWidth: 1)
                            
                            Text("\(card.rank.label)\(card.suit.rawValue)")
                                .font(.largeTitle)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                        }
                        .frame(width: 70, height: 90)
                    }
                }
            }
            
            Spacer()
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 70))]) {
                    ForEach(cards) { card in
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(.white)
                                .stroke(.black, lineWidth: 1)
                            
                            Text("\(card.rank.label)\(card.suit.rawValue)")
                                .font(.largeTitle)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                        }
                        .frame(width: 70, height: 90)
                    }
                }
            }
            
            Spacer()
        }
        .padding()
        .onAppear {
            for rank in Rank.allCases { // Loops through all Ranks
                for suit in Suit.allCases { // Loop through all Suits
                    cards.append(Card(suit: suit, rank: rank))
                }
            }
            cards.shuffle()
            deal()
        }
    }
    
    func deal() {
        repeat { // deal cards to dealer until we reach 17 or more
            dealerHand.append(cards.removeFirst())
        } while total(of: dealerHand) < 17
        playerHand.append(cards.removeFirst())
        playerHand.append(cards.removeFirst())
    }
    
    func total(of cards: [Card]) -> Int {
        var total = 0
        for card in cards {
            total += card.rank.value
        }
        return total
    }
}

#Preview {
    ContentView()
}

