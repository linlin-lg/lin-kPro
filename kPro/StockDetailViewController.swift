//
//  StockDetailViewController.swift
//  kPro
//
//  Created by KPLiOS on 2025/7/22.
//

import UIKit

class StockDetailViewController: UIViewController {

    var stock: Stock? {
        didSet {
            updateUI()
        }
    }

    private let priceLineView = PriceLineView()
    private let nameLabel = UILabel()
    private let symbolLabel = UILabel()
    private let priceLabel = UILabel()
    
    private let playButton = UIButton(type: .system)
    private let speedSelector = UISegmentedControl(items: ["3s", "10s", "30s"])
    
    private var playbackTimer: Timer?
    private var fullTimeSeries: [Stock.TimeData] = []
    private var playbackIndex = 0
    private var isPlaying = false
    private var playbackDuration: TimeInterval = 3.0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchStockData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        nameLabel.frame = CGRect(x: 20, y: view.safeAreaInsets.top + 20, width: view.bounds.width - 40, height: 30)
        symbolLabel.frame = CGRect(x: 20, y: nameLabel.frame.maxY + 8, width: view.bounds.width - 40, height: 22)
        priceLabel.frame = CGRect(x: 20, y: symbolLabel.frame.maxY + 20, width: view.bounds.width - 40, height: 26)
        priceLineView.frame = CGRect(x: 20, y: priceLabel.frame.maxY + 20, width: view.bounds.width - 40, height: 200)
        
        speedSelector.frame = CGRect(x: 20, y: priceLineView.frame.maxY + 20, width: 120, height: 30)
        playButton.frame = CGRect(x: speedSelector.frame.maxX + 20, y: speedSelector.frame.minY, width: 60, height: 30)

    }

    private func setupUI() {
        view.backgroundColor = .white

        nameLabel.font = .systemFont(ofSize: 24, weight: .bold)
        symbolLabel.font = .systemFont(ofSize: 18, weight: .medium)
        priceLabel.font = .systemFont(ofSize: 22, weight: .semibold)
        
        view.addSubview(nameLabel)
        view.addSubview(symbolLabel)
        view.addSubview(priceLabel)
        view.addSubview(priceLineView)

        priceLineView.backgroundColor = .lightGray.withAlphaComponent(0.2)
        
        playButton.setTitle("Play", for: .normal)
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        view.addSubview(playButton)
        
        speedSelector.selectedSegmentIndex = 0
        speedSelector.addTarget(self, action: #selector(speedChanged), for: .valueChanged)
        view.addSubview(speedSelector)
    }

    private func updateUI() {
        guard let stock = stock else { return }
        nameLabel.text = stock.name
        symbolLabel.text = stock.symbol
        priceLabel.text = "$\(stock.price)"
    }

    private func fetchStockData() {
        guard let stock = stock else { return }
        StockService.shared.fetchStockDetail(symbol: stock.symbol) { [weak self] data in
            DispatchQueue.main.async {
                self?.fullTimeSeries = data?.timeData ?? []
                self?.processAndDisplayData(timeSeries: self?.fullTimeSeries ?? [])
            }
        }
    }

    private func processAndDisplayData(timeSeries: [Stock.TimeData]) {
        guard !timeSeries.isEmpty else { return }
        
        let prices = timeSeries.map { $0.price }
        guard let maxPrice = prices.max(), let minPrice = prices.min() else { return }
        
        let closePrice = stock?.price ?? 0.0

        let points = calculatePoints(for: timeSeries, maxPrice: maxPrice, minPrice: minPrice)
        let avgPoints = calculateAveragePoints(for: timeSeries, maxPrice: maxPrice, minPrice: minPrice)
        
        priceLineView.setupData(priceLineArr: points, avgPriceLineArr: avgPoints, maxPrice: maxPrice, minPrice: minPrice, closePrice: closePrice)
    }
    
    @objc private func playButtonTapped() {
        if isPlaying {
            stopPlayback()
        } else {
            startPlayback()
        }
    }
    
    @objc private func speedChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            playbackDuration = 3.0
        case 1:
            playbackDuration = 10.0
        case 2:
            playbackDuration = 30.0
        default:
            playbackDuration = 3.0
        }
        
        if isPlaying {
            stopPlayback()
            startPlayback()
        }
    }
    
    private func startPlayback() {
        guard !fullTimeSeries.isEmpty else { return }
        
        if playbackIndex >= fullTimeSeries.count - 1 {
            playbackIndex = 0
            priceLineView.reset()
        }
        
        isPlaying = true
        playButton.setTitle("Pause", for: .normal)
        
        let timeInterval = playbackDuration / TimeInterval(fullTimeSeries.count)
        playbackTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(timerTick), userInfo: nil, repeats: true)
    }
    
    private func stopPlayback() {
        isPlaying = false
        playButton.setTitle("Play", for: .normal)
        playbackTimer?.invalidate()
        playbackTimer = nil
    }
    
    @objc private func timerTick() {
        playbackIndex += 1
        
        if playbackIndex >= fullTimeSeries.count {
            stopPlayback()
            playbackIndex = 0
            playButton.setTitle("Replay", for: .normal)
            return
        }
        
        let currentData = Array(fullTimeSeries.prefix(playbackIndex + 1))
        updateChartForPlayback(timeSeries: currentData)
    }

    private func updateChartForPlayback(timeSeries: [Stock.TimeData]) {
        guard !fullTimeSeries.isEmpty else { return }
        
        let allPrices = fullTimeSeries.map { $0.price }
        guard let maxPrice = allPrices.max(), let minPrice = allPrices.min() else { return }
        
        let closePrice = stock?.price ?? 0.0
        
        let points = calculatePoints(for: timeSeries, maxPrice: maxPrice, minPrice: minPrice)
        let avgPoints = calculateAveragePoints(for: timeSeries, maxPrice: maxPrice, minPrice: minPrice)
        
        priceLineView.setupData(priceLineArr: points, avgPriceLineArr: avgPoints, maxPrice: maxPrice, minPrice: minPrice, closePrice: closePrice)
    }
    
    private func calculatePoints(for timeSeries: [Stock.TimeData], maxPrice: Double, minPrice: Double) -> [CGPoint] {
        let width = priceLineView.bounds.width
        let height = priceLineView.bounds.height
        let count = timeSeries.count
        
        guard count > 1, width > 0, height > 0 else { return [] }
        
        let xSpacing = width / CGFloat(fullTimeSeries.count - 1)
        let priceRange = maxPrice - minPrice
        
        return timeSeries.enumerated().map { (index, data) -> CGPoint in
            let x = CGFloat(index) * xSpacing
            let yPosition = priceRange == 0 ? 0.5 : ((data.price - minPrice) / priceRange)
            let y = height - yPosition * Double(height)
            return CGPoint(x: x, y: y)
        }
    }
    
    private func calculateAveragePoints(for timeSeries: [Stock.TimeData], maxPrice: Double, minPrice: Double) -> [CGPoint] {
        let width = priceLineView.bounds.width
        let height = priceLineView.bounds.height
        let count = timeSeries.count
        
        guard count > 1, width > 0, height > 0 else { return [] }
        
        let xSpacing = width / CGFloat(fullTimeSeries.count - 1)
        let priceRange = maxPrice - minPrice
        var cumulativePrice = 0.0
        
        return timeSeries.enumerated().map { (index, data) -> CGPoint in
            cumulativePrice += data.price
            let avgPrice = cumulativePrice / Double(index + 1)
            let x = CGFloat(index) * xSpacing
            let yPosition = priceRange == 0 ? 0.5 : ((avgPrice - minPrice) / priceRange)
            let y = height - yPosition * Double(height)
            return CGPoint(x: x, y: y)
        }
    }
} 
