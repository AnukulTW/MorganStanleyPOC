//
//  TradeView.swift
//  MorganStanleyTradingPOC
//
//  Created by Shrey Shrivastava on 07/07/25.
//


import SwiftUI
import Combine

/*
struct TradeView: View {
    @ObservedObject private var viewModel: TradeViewModel
    
    init(viewModel: TradeViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView {
            List(viewModel.assetList, id: \.symbol) { asset in
                AssetRow(asset: asset, livePrice: viewModel.livePrices[asset.symbol] ?? "--")
                    .padding(.vertical, 4)
            }
            .navigationTitle("Market Watch")
            .onAppear {
                viewModel.fetchAssets()
                viewModel.fetchLastQuotes()
            }
        }
    }
}

struct AssetRow: View {
    let asset: AssetModel
    let livePrice: String

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(asset.name)
                    .font(.headline)
                    .foregroundColor(.primary)

                Text(asset.symbol)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Text(livePrice)
                .font(.title3)
                .bold()
                .foregroundColor(.green)
        }
        .padding(.vertical, 8)
    }
}
*/

import SwiftUI

@MainActor


struct TradeView: View {
    @ObservedObject private var viewModel: TradeViewModel
    
    init(viewModel: TradeViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading…")
                } else {
                    List(viewModel.assetList, id: \ .self) { symbol in
                        AssetRow(symbol: symbol,
                                 price: viewModel.livePrices[symbol] ?? "--")
                    }
                }
            }
            .navigationTitle("Market Watch")
            .onAppear {
                viewModel.start()
            }
        }
    }
}

struct AssetRow: View {
    let symbol: String
    let price: String

    var body: some View {
        HStack(spacing: 12) {
            Text(symbol)
                .font(.headline)
                .foregroundColor(.primary)
            Spacer()
            Text(price)
                .font(.body)
                .foregroundColor(.green)
        }
        .padding(.vertical, 8)
    }
}

#if DEBUG
struct TradeView_Previews: PreviewProvider {
    static var previews: some View {
        TradeView()
    }
}
#endif



