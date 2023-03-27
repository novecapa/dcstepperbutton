//
//  DCButtonsView.swift
//  DCButton
//
//  Created by Josep Cerdà Penadés on 15/6/22.
//

import Foundation
import UIKit

public protocol DCButtonsViewProtocol {
    func longDecrease()
    func singleDecrease()
    func longIncrease()
    func singleIncrease()
}

extension DCButtonsViewProtocol {
    func longDecrease() { }
    func singleDecrease() { }
    func longIncrease() { }
    func singleIncrease() { }
}

public class DCButtonsView: UIView {
    
    public static let identifier = "DCButtonsView"
    
    public var delegate: DCButtonsViewProtocol?

    // MARK: Button decrease
    @IBOutlet weak var dcButtonDecrease: UIButton!
    private var timerDecrease: Timer?
    // MARK: Button increase
    @IBOutlet weak var dcButtonIncrease: UIButton!
    private var timerIncrease: Timer?
    private var currentValue = 0
    // MARK: Configurable values
    public var timeInterval = 0.5 // In ms
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed(DCButtonsView.identifier,
                                 owner: self,
                                 options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        // MARK: Add gesture decrease
        let longPressDecrease = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressDecrease(gesture:)))
        longPressDecrease.minimumPressDuration = 1
        self.dcButtonDecrease.addGestureRecognizer(longPressDecrease)
        // MARK: Add gesture increase
        let longPressIncrease = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressIncrease(gesture:)))
        longPressIncrease.minimumPressDuration = 1
        self.dcButtonIncrease.addGestureRecognizer(longPressIncrease)
    }

    // MARK: Decrease gesture action
    @objc func longPressDecrease(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            // print("long Decrease action")
            timerDecrease = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { (_) in
                guard let _ = self.timerDecrease else { return }
                self.currentValue -= 1
                // print("\(self.currentValue)")
                self.delegate?.longDecrease()
            }
        }
        if gesture.state == .ended {
            timerDecrease?.invalidate()
        }
    }
    // MARK: Increase gesture action
    @objc func longPressIncrease(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            // print("long Increase action")
            timerIncrease = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { (_) in
                guard let _ = self.timerIncrease else { return }
                self.currentValue += 1
                // print("\(self.currentValue)")
                self.delegate?.longIncrease()
            }
        }
        if gesture.state == .ended {
            timerIncrease?.invalidate()
        }
    }
    // MARK: Single tap decrease
    @IBAction func dcButtonDecreaseTap(sender: UIButton) {
        // print("Decrease tapped")
        delegate?.singleDecrease()
    }
    // MARK: Single tap increase
    @IBAction func dcButtonIncrease(sender: UIButton) {
        // print("Increase tapped")
        delegate?.singleIncrease()
    }
}
