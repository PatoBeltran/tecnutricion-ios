//
//  SlidingContainerSliderView.swift
//  SlidingContainerViewController
//
//  Created by Cem Olcay on 10/04/15.
//  Copyright (c) 2015 Cem Olcay. All rights reserved.
//

import UIKit

struct SlidingContainerSliderViewAppearance {
    
    var backgroundColor: UIColor
    
    var font: UIFont
    var selectedFont: UIFont
    
    var textColor: UIColor
    var selectedTextColor: UIColor
    
    var outerPadding: CGFloat
    var innerPadding: CGFloat
    
    var selectorColor: UIColor
    var selectorHeight: CGFloat
}

protocol SlidingContainerSliderViewDelegate {
    func slidingContainerSliderViewDidPressed (slidingtContainerSliderView: SlidingContainerSliderView, atIndex: Int)
}

class SlidingContainerSliderView: UIScrollView, UIScrollViewDelegate {
   
    // MARK: Properties
    
    var appearance: SlidingContainerSliderViewAppearance! {
        didSet {
            draw()
        }
    }
    
    var shouldSlide: Bool = true
    
    let sliderHeight: CGFloat = 65
    var titles: [String]!
    var icons: [UIImage]!
    
    var labels: [UILabel] = []
    var labelViews: [UIView] = []
    var labelWidth: CGFloat = 0
    var selector: UIView!

    var sliderDelegate: SlidingContainerSliderViewDelegate?
    
    
    // MARK: Init
    
    init (width: CGFloat, titles: [String], icons: [UIImage]) {
        super.init(frame: CGRect (x: 0, y: 0, width: width, height: sliderHeight))
        self.titles = titles
        self.icons = icons
        self.labelWidth = width/3
        
        delegate = self
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        scrollsToTop = false
        
        appearance = SlidingContainerSliderViewAppearance (
            backgroundColor: UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1),
            
            font: UIFont (name: "HelveticaNeue-Light", size: 18)!,
            selectedFont: UIFont.systemFontOfSize(18),
            
            textColor: UIColor(red: 65/255, green: 65/255, blue: 65/255, alpha: 1),
            selectedTextColor: UIColor.whiteColor(),
            
            outerPadding: 20,
            innerPadding: 20,
            
            selectorColor: UIColor(red: 221/255, green: 207/255, blue: 138/255, alpha: 1),
            selectorHeight: sliderHeight)
        
        draw()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    // MARK: Draw
    
    func draw () {
        
        // clean
        if labels.count > 0 {
            for label in labels {
                label.removeFromSuperview()
            }
        }
        if labelViews.count > 0 {
            for labelView in labelViews {
                labelView.removeFromSuperview()
                
                if selector != nil {
                    selector.removeFromSuperview()
                    selector = nil
                }
            }
        }
        
        labelViews = []
        labels = []
        backgroundColor = appearance.backgroundColor
        
        var labelTag = 0
        var currentX = CGFloat()
        
        for title in titles {
            let labelView = labelViewWithTitle(title, icon: self.icons[labelTag])
            labelView.frame.origin.x = currentX
            labelView.center.y = frame.size.height/2
            labelView.tag = labelTag++
            
            labelViews.append(labelView)
            addSubview(labelView)
            currentX += self.labelWidth
        }
        
        let selectorH = appearance.selectorHeight
        selector = UIView (frame: CGRect (x: 0, y: frame.size.height - selectorH, width: self.labelWidth, height: selectorH))
        selector.backgroundColor = appearance.selectorColor
        addSubview(selector)
        contentSize = CGSize (width: currentX, height: frame.size.height)
    }
    
    func labelViewWithTitle (title: String, icon: UIImage) -> UIView {
        
        let labelView = UIView (frame: CGRect(x: 0, y: 0, width: self.labelWidth, height: 65))
        labelView.addGestureRecognizer(UITapGestureRecognizer (target: self, action: "didTap:"))
        labelView.userInteractionEnabled = true
        labelView.clipsToBounds = true
        
//        let iconView = UIImageView (image: icon)
//        iconView.center = labelView.center
//        iconView.center.x -= 30
//        
//        labelView.addSubview(iconView)
        
        let label = UILabel (frame: CGRect (x: 0, y: (sliderHeight - 11)/2, width: self.labelWidth, height: 22))
        label.text = title
        label.font = appearance.font
        label.textColor = appearance.textColor
        label.textAlignment = .Center
        label.sizeToFit()
        
        label.frame.size.width += appearance.innerPadding * 2
        labels.append(label)
        
        labelView.addSubview(label)
        return labelView
    }
    
    
    // MARK: Actions
    
    func didTap (tap: UITapGestureRecognizer) {
        self.sliderDelegate?.slidingContainerSliderViewDidPressed(self, atIndex: tap.view!.tag)
    }
    
    
    // MARK: Menu
    
    func selectItemAtIndex (index: Int) {
        
        // Set Labels
        
        for i in 0..<self.labelViews.count {
            let labelView = labelViews[i]
            let label = labels[i]
            
            if i == index {
                bringSubviewToFront(labelView)
                label.textColor = appearance.selectedTextColor
                label.font = appearance.selectedFont
                label.sizeToFit()
                label.frame.size.width += appearance.innerPadding * 2

                // Set selector
                
                UIView.animateWithDuration(0.3, animations: {
                    [unowned self] in
                    self.selector.frame = CGRect (
                        x: labelView.frame.origin.x,
                        y: self.selector.frame.origin.y,
                        width: labelView.frame.size.width,
                        height: self.appearance.selectorHeight)
                })
                
            } else {
                
                label.textColor = appearance.textColor
                label.font = appearance.font
                
                label.sizeToFit()
                label.frame.size.width += appearance.innerPadding * 2
            }
        }
    }

}

