//
//  TradeViewModel.swift
//  MorganStanleyTradingPOC
//
//  Created by Shrey Shrivastava on 07/07/25.
//

/*
final class TradeViewModel: NSObject, ObservableObject {
    @Published var assetList: [AssetQuoteModel] = []
    @Published var livePrices: [String: String] = [:]
    
    private let socket: SocketConnectionEnabler
    private let assetClient: MarketAssetClient
    private let tradeController = TradeController()
    private let requiredSymbols = ["AMZN", "AAPL", "MLGO", "INTC", "AMTM", "ARCA", "ANAB", "ABNB"]

    init(socketConnectionEnabler: SocketConnectionEnabler) {
            let manager = NetworkConnectionManager(apiKey: Constants.apiKey,
                                                   apiSecret: Constants.apiSecret)
            self.socket = socketConnectionEnabler
            self.tradeController.handler = self
            self.assetClient = MarketAssetClient(networkManager: manager)
            super.init()
            self.assetClient.requiredSymbol = requiredSymbols
        }
    

    func fetchAssets() {
        assetClient.fetchMarketAsset { [weak self] result, list, error in
            DispatchQueue.main.async {
                self?.assetList = result ?? []
                self?.socket.subscribeAssets(list ?? [])
            }
        }
    }

    func fetchLastQuotes() {
        assetClient.fetchLastQuote(forAsset: requiredSymbols) { [weak self] quotes, error in
            DispatchQueue.main.async {
                self?.tradeController.updateAssetLastQuote(quotes ?? [])
            }
        }
    }
}

extension TradeViewModel: SymbolsHandler {
    func connectionEstablishSuccess() {
        <#code#>
    }
    
    func didReceivePrice(_ priceModel: AssetPriceModel, forAsset asset: String) {
        DispatchQueue.main.async {
            self.tradeController.
        }
    }
}
*/

class TradeViewModel: NSObject, ObservableObject, SymbolsHandler {
    @Published var assetList: [String] = []
    @Published var livePrices: [String: String] = [:]
    @Published var isLoading = true

    private let controller: TradeController
    private let assetClient: MarketAssetClient
    private let requiredSymbols: [String]

    override init() {
        // Initialize networking client
        let manager = NetworkConnectionManager(apiKey: Constants.apiKey,
                                               apiSecret: Constants.apiSecret)
        self.assetClient = MarketAssetClient(networkManager: manager)
        self.requiredSymbols = Constants.assetList // Array<String>
        self.assetClient.requiredSymbol = requiredSymbols

        // Initialize trade controller with socket enabler
        self.controller = TradeController(socketEnabler: SocketConnectionManager())
        super.init()

        // Wire up delegate for socket events
        self.controller.handler = self
    }

    func start() {
        assetList = requiredSymbols
        livePrices = [:]
        isLoading = true
        // Subscribe and connect socket
        controller.subscribeAssets(requiredSymbols)
        controller.startSocket()
    }

    // MARK: - SymbolsHandler
    func connectionEstablishSuccess() {
        fetchLastQuotes()
    }

    func didReceivePrice(_ priceModel: AssetPriceModel, forAsset asset: String) {
        Task { @MainActor in
            // Convert price to string; adjust formatting as needed
            livePrices[asset] = "\(priceModel.bidPrice)"
        }
    }

    // MARK: - Private
    private func fetchLastQuotes() {
        assetClient.fetchLastQuote(forAsset: requiredSymbols) { [weak self] result, error in
            guard let self = self else { return }
            Task { @MainActor in
                if let quotes = result {
                    // Update controller and UI data
                    self.controller.updateAssetLastQuote(quotes)
                    for quote in quotes {
                        self.livePrices[quote.assetName] = "\(quote.askPrice)"
                    }
                }
                self.isLoading = false
            }
        }
    }
}
