//
//  WSSRangeSlider.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 4/29/26.
//

import UIKit

final class WSSRangeSlider: UIControl {

    //MARK: - Properties

    var minimumValue: CGFloat = 0.0 { didSet { updateLayerFrames() } }
    var maximumValue: CGFloat = 5.0 { didSet { updateLayerFrames() } }

    private(set) var lowerValue: CGFloat = 0.0 { didSet { updateLayerFrames() } }
    private(set) var upperValue: CGFloat = 5.0 { didSet { updateLayerFrames() } }

    var step: CGFloat = 0.5

    private let thumbSize: CGFloat = 16
    private let trackHeight: CGFloat = 4

    private var isDraggingLower = false
    private var isDraggingUpper = false

    private let tickSize = CGSize(width: 1, height: 2)

    //MARK: - UI Components

    private let trackLayer = CALayer()
    private var tickLayers: [CALayer] = []
    private let rangeLayer = CALayer()
    private let lowerThumbView = UIView()
    private let upperThumbView = UIView()

    //MARK: - Life Cycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        setUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: thumbSize)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateLayerFrames()
    }

    //MARK: - UI

    private func setUI() {
        trackLayer.do {
            $0.backgroundColor = UIColor.wssPrimary50.cgColor
            $0.cornerRadius = trackHeight / 2
        }
        layer.addSublayer(trackLayer)

        let tickCount = Int((maximumValue - minimumValue) / step) + 1
        for _ in 0..<tickCount {
            let tick = CALayer()
            tick.backgroundColor = UIColor.wssPrimary100.cgColor
            tickLayers.append(tick)
            layer.addSublayer(tick)
        }

        rangeLayer.do {
            $0.backgroundColor = UIColor.wssPrimary100.cgColor
            $0.cornerRadius = trackHeight / 2
        }
        layer.addSublayer(rangeLayer)

        [lowerThumbView, upperThumbView].forEach {
            $0.backgroundColor = .wssWhite
            $0.layer.cornerRadius = thumbSize / 2
            $0.layer.shadowColor = UIColor.wssBlack.cgColor
            $0.layer.shadowOffset = CGSize(width: 0, height: 2)
            $0.layer.shadowOpacity = 0.2
            $0.layer.shadowRadius = 8
            $0.isUserInteractionEnabled = false
            addSubview($0)
        }
    }

    //MARK: - Layout

    private func updateLayerFrames() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)

        let trackY = (bounds.height - trackHeight) / 2
        trackLayer.frame = CGRect(x: thumbSize / 2,
                                  y: trackY,
                                  width: bounds.width - thumbSize,
                                  height: trackHeight)

        let tickY = (bounds.height - tickSize.height) / 2
        for (index, tick) in tickLayers.enumerated() {
            let value = minimumValue + CGFloat(index) * step
            let x = positionForValue(value) - tickSize.width / 2
            tick.frame = CGRect(x: x, y: tickY, width: tickSize.width, height: tickSize.height)
        }

        let lowerX = positionForValue(lowerValue)
        let upperX = positionForValue(upperValue)

        rangeLayer.frame = CGRect(x: lowerX,
                                  y: trackY,
                                  width: upperX - lowerX,
                                  height: trackHeight)

        lowerThumbView.frame = CGRect(x: lowerX - thumbSize / 2,
                                      y: (bounds.height - thumbSize) / 2,
                                      width: thumbSize,
                                      height: thumbSize)

        upperThumbView.frame = CGRect(x: upperX - thumbSize / 2,
                                      y: (bounds.height - thumbSize) / 2,
                                      width: thumbSize,
                                      height: thumbSize)

        CATransaction.commit()
    }

    private func positionForValue(_ value: CGFloat) -> CGFloat {
        let trackWidth = bounds.width - thumbSize
        return thumbSize / 2 + trackWidth * (value - minimumValue) / (maximumValue - minimumValue)
    }

    private func valueForPosition(_ position: CGFloat) -> CGFloat {
        let trackWidth = bounds.width - thumbSize
        let ratio = (position - thumbSize / 2) / trackWidth
        return minimumValue + (maximumValue - minimumValue) * max(0, min(1, ratio))
    }

    private func snapToStep(_ value: CGFloat) -> CGFloat {
        (value / step).rounded() * step
    }

    //MARK: - Touch Handling

    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)

        let lowerDistance = abs(location.x - lowerThumbView.center.x)
        let upperDistance = abs(location.x - upperThumbView.center.x)
        let threshold = thumbSize * 1.5

        if lowerValue == upperValue && lowerDistance < threshold {
            if location.x >= lowerThumbView.center.x {
                isDraggingUpper = true
            } else {
                isDraggingLower = true
            }
        } else if lowerDistance < upperDistance && lowerDistance < threshold {
            isDraggingLower = true
        } else if upperDistance < threshold {
            isDraggingUpper = true
        }

        return isDraggingLower || isDraggingUpper
    }

    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        let rawValue = valueForPosition(location.x)
        let snappedValue = snapToStep(rawValue)

        if isDraggingLower {
            lowerValue = min(snappedValue, upperValue)
        } else if isDraggingUpper {
            upperValue = max(snappedValue, lowerValue)
        }

        sendActions(for: .valueChanged)
        return true
    }

    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        isDraggingLower = false
        isDraggingUpper = false
    }

    //MARK: - Custom Method

    func setValues(lower: CGFloat, upper: CGFloat) {
        lowerValue = max(minimumValue, min(lower, maximumValue))
        upperValue = max(minimumValue, min(upper, maximumValue))
    }
}
