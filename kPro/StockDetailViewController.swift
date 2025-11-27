//
//  StockDetailViewController.swift
//  kPro
//
//  Created by KPLiOS on 2025/7/22.
//

import UIKit
import SnapKit

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
    
    // 时间轴相关
    private let timelineView = UIView()
    private let timelineSlider = UISlider()
    private let currentTimeLabel = UILabel()
    private let totalTimeLabel = UILabel()
    private let timelineContainer = UIView()
    
    private var playbackTimer: Timer?
    private var fullTimeSeries: [Stock.TimeData] = []
    private var playbackIndex = 0
    private var isPlaying = false
    private var playbackDuration: TimeInterval = 3.0
    private var isDraggingTimeline = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchStockData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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
        
        // 设置时间轴
        setupTimeline()

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(30)
        }
        
        symbolLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(22)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(symbolLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(26)
        }
        
        priceLineView.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(200)
        }
        
        speedSelector.snp.makeConstraints { make in
            make.top.equalTo(priceLineView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(120)
            make.height.equalTo(30)
        }
        
        playButton.snp.makeConstraints { make in
            make.leading.equalTo(speedSelector.snp.trailing).offset(20)
            make.centerY.equalTo(speedSelector.snp.centerY)
            make.width.equalTo(60)
            make.height.equalTo(30)
        }
        
        timelineContainer.snp.makeConstraints { make in
            make.top.equalTo(speedSelector.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
    }
    
    private func setupTimeline() {
        view.addSubview(timelineContainer)
        view.addSubview(timelineSlider)
        view.addSubview(currentTimeLabel)
        view.addSubview(totalTimeLabel)
        
        // 时间轴容器
        timelineContainer.backgroundColor = .gray
//        timelineContainer.layer.cornerRadius = 8
        // 时间轴滑块
        timelineSlider.minimumValue = 0
        timelineSlider.maximumValue = 1
        timelineSlider.value = 0
        timelineSlider.minimumTrackTintColor = .red
        timelineSlider.maximumTrackTintColor = .gray
        timelineSlider.thumbTintColor = .red
        
        // 设置滑块大小
        timelineSlider.setThumbImage(createThumbImage(size: CGSize(width: 12, height: 12)), for: .normal)
        timelineSlider.setThumbImage(createThumbImage(size: CGSize(width: 12, height: 12)), for: .highlighted)
        
        timelineSlider.addTarget(self, action: #selector(timelineSliderChanged), for: .valueChanged)
        timelineSlider.addTarget(self, action: #selector(timelineSliderBegan), for: .touchDown)
        timelineSlider.addTarget(self, action: #selector(timelineSliderEnded), for: [.touchUpInside, .touchUpOutside])
        
        // 当前时间标签
        currentTimeLabel.text = "00:00"
        currentTimeLabel.font = .systemFont(ofSize: 12)
        currentTimeLabel.textColor = .systemGray
        currentTimeLabel.textAlignment = .left
        
        // 总时间标签
        totalTimeLabel.text = "00:00"
        totalTimeLabel.font = .systemFont(ofSize: 12)
        totalTimeLabel.textColor = .systemGray
        totalTimeLabel.textAlignment = .right
        
        // 约束设置
        timelineSlider.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(10)
        }
        
        currentTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(timelineSlider.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(50)
            make.height.equalTo(16)
        }
        
        totalTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(timelineSlider.snp.bottom).offset(8)
            make.trailing.equalToSuperview().offset(-20)
            make.width.equalTo(50)
            make.height.equalTo(16)
        }
        }
    
    // MARK: - 辅助方法
    
    private func createThumbImage(size: CGSize) -> UIImage {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        
        // 绘制圆形滑块
        context?.setFillColor(UIColor.red.cgColor)
        context?.fillEllipse(in: rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image ?? UIImage()
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
                self?.updateTimelineLabels()
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
    
    // MARK: - 时间轴相关方法
    
    private func updateTimelineLabels() {
        guard !fullTimeSeries.isEmpty else { return }
        
        let totalDuration = getTotalDuration()
        totalTimeLabel.text = formatTime(totalDuration)
        currentTimeLabel.text = "00:00"
        
        // 重置滑块
        timelineSlider.value = 0
        playbackIndex = 0
    }
    
    private func getTotalDuration() -> TimeInterval {
        guard !fullTimeSeries.isEmpty else { return 0 }
        
        if fullTimeSeries.count > 1 {
            let firstTime = fullTimeSeries.first!.timestamp
            let lastTime = fullTimeSeries.last!.timestamp
            return lastTime - firstTime
        }
        return 0
    }
    
    private func formatTime(_ timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func updateTimelineProgress() {
        guard !fullTimeSeries.isEmpty else { return }
        
        if !isDraggingTimeline {
            let progress = Float(playbackIndex) / Float(max(1, fullTimeSeries.count - 1))
            timelineSlider.value = progress
            
            // 更新当前时间标签
            if playbackIndex < fullTimeSeries.count {
                let currentTime = fullTimeSeries[playbackIndex].timestamp
                let firstTime = fullTimeSeries.first!.timestamp
                let elapsed = currentTime - firstTime
                currentTimeLabel.text = formatTime(elapsed)
            }
        }
    }
    
    @objc private func timelineSliderChanged(_ sender: UISlider) {
        guard !fullTimeSeries.isEmpty else { return }
        
        let progress = sender.value
        let newIndex = Int(progress * Float(fullTimeSeries.count - 1))
        
        if newIndex != playbackIndex && newIndex < fullTimeSeries.count {
            playbackIndex = newIndex
            
            // 更新分时图显示
            let currentData = Array(fullTimeSeries.prefix(playbackIndex + 1))
            updateChartForPlayback(timeSeries: currentData)
            
            // 更新当前时间标签
            if playbackIndex < fullTimeSeries.count {
                let currentTime = fullTimeSeries[playbackIndex].timestamp
                let firstTime = fullTimeSeries.first!.timestamp
                let elapsed = currentTime - firstTime
                currentTimeLabel.text = formatTime(elapsed)
            }
        }
    }
    
    @objc private func timelineSliderBegan() {
        isDraggingTimeline = true
        if isPlaying {
            stopPlayback()
        }
    }
    
    @objc private func timelineSliderEnded() {
        isDraggingTimeline = false
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
            timelineSlider.value = 0
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
            timelineSlider.value = 0
            currentTimeLabel.text = "00:00"
            return
        }
        
        let currentData = Array(fullTimeSeries.prefix(playbackIndex + 1))
        updateChartForPlayback(timeSeries: currentData)
        
        // 更新时间轴进度
        updateTimelineProgress()
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
