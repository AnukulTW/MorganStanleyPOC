//
//  TradeViewModel.swift
//  MorganStanleyTradingPOC
//
//  Created by Shrey Shrivastava on 07/07/25.
//

class TradeViewModel: NSObject, ObservableObject, SymbolsHandler {
    @Published var assetList: [String] = []
    @Published var livePrices: [String: AssetPriceModel] = [:]
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
            livePrices[asset] = priceModel
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
                    for symbol in self.assetList {
                        let priceModel = self.controller.fetchPrice(symbol)
                        self.livePrices[symbol] = priceModel
                    }
                }
                self.isLoading = false
            }
        }
    }
}
