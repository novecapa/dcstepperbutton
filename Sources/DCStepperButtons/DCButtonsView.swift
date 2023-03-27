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
    public override func awakeFromNib() {
        super.awakeFromNib()
        
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
    private static func getBundle() -> Bundle   {
        let matches = Bundle.allFrameworks.filter { (aBundle) -> Bool in
             if let identifier = aBundle.bundleIdentifier {
                return identifier.contains("dcbuttonlp") && aBundle.isLoaded
             } else {
                 return false
             }
        }
        if matches.count == 0 {
            return Bundle(for: DCButtonsView.self)
        } else {
            return matches.last!
        }
    }
    public static func getDCButtonsView() -> DCButtonsView? {
        return UIView.fromNib(named: DCButtonsView.identifier, bundle: getBundle()) as? DCButtonsView
    }
}
// MARK: - UIView
public extension UIView {
    class func fromNib(named: String? = nil, bundle: Bundle) -> Self {
        let name = named ?? "\(Self.self)"
        guard
            let nib = bundle.loadNibNamed(name, owner: nil, options: nil)
        else { fatalError("missing expected nib named: \(name)") }
        guard
            // we're using `first` here because compact map chokes compiler on
            // optimized release, so you can't use two views in one nib if you wanted to
            // and are now looking at this
            let view = nib.first as? Self
        else { fatalError("view of type \(Self.self) not found in \(nib)") }
        return view
    }
}
