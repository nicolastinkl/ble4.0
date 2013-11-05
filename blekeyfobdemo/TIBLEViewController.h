//
//  TIBLEViewController.h
//  TI-BLE-Demo
//
//  Created by Ole Andreas Torvmark on 10/29/11.
//  Copyright (c) 2011 ST alliance AS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TIBLECBKeyfob.h"

@interface TIBLEViewController : UIViewController <TIBLECBKeyfobDelegate> { 
    TIBLECBKeyfob *t; //TI keyfob class (private)
}

// UI elements actions
- (IBAction)TIBLEUIScanForPeripheralsButton:(id)sender;
- (IBAction)TIBLEUISoundBuzzerButton:(id)sender;


// UI elements outlets
@property (weak, nonatomic) IBOutlet UITextView *TIBLEUILog;
@property (weak, nonatomic) IBOutlet UILabel *TIBLEUIRSSILabel;
@property (weak, nonatomic) IBOutlet UIProgressView *TIBLEUIBatteryBar;
@property (weak, nonatomic) IBOutlet UILabel *TIBLEUIBatteryBarLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *TIBLEUIAccelXBar;
@property (weak, nonatomic) IBOutlet UIProgressView *TIBLEUIAccelYBar;
@property (weak, nonatomic) IBOutlet UIProgressView *TIBLEUIAccelZBar;
@property (weak, nonatomic) IBOutlet UISwitch *TIBLEUILeftButton;
@property (weak, nonatomic) IBOutlet UISwitch *TIBLEUIRightButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *TIBLEUISpinner;
@property (weak, nonatomic) IBOutlet UIButton *TIBLEUIConnBtn;


//Timer methods
- (void) batteryIndicatorTimer:(NSTimer *)timer;
- (void) connectionTimer:(NSTimer *)timer;

@end
