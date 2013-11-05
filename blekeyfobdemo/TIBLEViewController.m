//
//  TIBLEViewController.m
//  TI-BLE-Demo
//
//  Created by Ole Andreas Torvmark on 10/29/11.
//  Copyright (c) 2011 ST alliance AS. All rights reserved.
//

#import "TIBLEViewController.h"

@implementation TIBLEViewController
@synthesize TIBLEUIBatteryBar;
@synthesize TIBLEUIBatteryBarLabel;
@synthesize TIBLEUIAccelXBar;
@synthesize TIBLEUIAccelYBar;
@synthesize TIBLEUIAccelZBar;
@synthesize TIBLEUILeftButton;
@synthesize TIBLEUIRightButton;
@synthesize TIBLEUISpinner;
@synthesize TIBLEUIConnBtn;


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    t = [[TIBLECBKeyfob alloc] init];   // Init TIBLECBKeyfob class.
    [t controlSetup:1];                 // Do initial setup of TIBLECBKeyfob class.
    t.delegate = self;                  // Set TIBLECBKeyfob delegate class to point at methods implemented in this class.
    t.TIBLEConnectBtn = self.TIBLEUIConnBtn;
    [self TIBLEUIScanForPeripheralsButton:nil];
    [NSTimer scheduledTimerWithTimeInterval:(float)1.0 target:self selector:@selector(connectionRSSITimer:) userInfo:nil repeats:YES];
}

-(void) connectionRSSITimer:(NSTimer *) timer
{
    [[t activePeripheral] readRSSI];
    NSLog(@"%@",[t activePeripheral].RSSI);
    //peripheral.RSSI
    self.TIBLEUIRSSILabel.text = [NSString stringWithFormat:@"%@", [t activePeripheral].RSSI];
}

- (void)viewDidUnload
{
    [self setTIBLEUIBatteryBar:nil];
    [self setTIBLEUIBatteryBarLabel:nil];
    [self setTIBLEUIAccelXBar:nil];
    [self setTIBLEUIAccelYBar:nil];
    [self setTIBLEUIAccelZBar:nil];
    [self setTIBLEUILeftButton:nil];
    [self setTIBLEUIRightButton:nil];
    [self setTIBLEUISpinner:nil];
    [self setTIBLEUIConnBtn:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
        switch(interfaceOrientation)
        {
            case UIInterfaceOrientationLandscapeLeft:
                return NO;
            case UIInterfaceOrientationLandscapeRight:
                return NO;
            default:
                return YES;
        }
}

- (IBAction)TIBLEUIScanForPeripheralsButton:(id)sender {
    if (t.activePeripheral) {
        if(t.activePeripheral.isConnected) {
            [[t CM] cancelPeripheralConnection:[t activePeripheral]];
            [TIBLEUIConnBtn setTitle:@"扫描并连接 KeyFob" forState:UIControlStateNormal];
            t.activePeripheral = nil;
        }
    } else {
        if (t.peripherals) t.peripherals = nil;
        [t findBLEPeripherals:5];   
//        [NSTimer scheduledTimerWithTimeInterval:(float)5.0 target:self selector:@selector(connectionTimer:) userInfo:nil repeats:NO];
        [TIBLEUISpinner startAnimating];
        [TIBLEUIConnBtn setTitle:@"扫描" forState:UIControlStateNormal];
    }
}

- (void) batteryIndicatorTimer:(NSTimer *)timer {
    TIBLEUIBatteryBar.progress = t.batteryLevel / 100;  
    [t readBattery:[t activePeripheral]];               // Read battery value of keyfob again
    
}

// Method from TIBLECBKeyfobDelegate, called when accelerometer values are updated
-(void) accelerometerValuesUpdated:(char)x y:(char)y z:(char)z {
    TIBLEUIAccelXBar.progress = (float)(x + 50) / 100;
    TIBLEUIAccelYBar.progress = (float)(y + 50) / 100;
    TIBLEUIAccelZBar.progress = (float)(z + 50) / 100;
}
// Method from TIBLECBKeyfobDelegate, called when key values are updated
-(void) keyValuesUpdated:(char)sw {
    printf("Key values updated ! \r\n");
    if (sw & 0x1) [TIBLEUILeftButton setOn:TRUE];
    else [TIBLEUILeftButton setOn: FALSE];
    if (sw & 0x2) [TIBLEUIRightButton setOn: TRUE];
    else [TIBLEUIRightButton setOn: FALSE];
    
}

//Method from TIBLECBKeyfobDelegate, called when keyfob has been found and all services have been discovered
-(void) keyfobReady {
    [TIBLEUIConnBtn setTitle:@"断开连接" forState:UIControlStateNormal];
    // Start battery indicator timer, calls batteryIndicatorTimer method every 2 seconds
    [NSTimer scheduledTimerWithTimeInterval:(float)2.0 target:self selector:@selector(batteryIndicatorTimer:) userInfo:nil repeats:YES]; 
    [t enableAccelerometer:[t activePeripheral]];   // Enable accelerometer (if found)
    [t enableButtons:[t activePeripheral]];         // Enable button service (if found)
    [t enableTXPower:[t activePeripheral]];         // Enable TX power service (if found)
    [TIBLEUISpinner stopAnimating];             
}

//Method from TIBLECBKeyfobDelegate, called when TX powerlevel values are updated
-(void) TXPwrLevelUpdated:(char)TXPwr {
    NSLog(@"电量:%c",TXPwr);
}

-(void) TXUploadLog:(NSString *) strLog
{
    self.TIBLEUILog.text = [NSString stringWithFormat:@"%@ \n %@", self.TIBLEUILog.text,strLog] ;
}

-(void) TXUploadRSSI:(NSNumber *) number
{
    self.TIBLEUIRSSILabel.text = [NSString stringWithFormat:@"%@",number];
}
// Called when scan period is over to connect to the first found peripheral
-(void) connectionTimer:(NSTimer *)timer {
/*    if(t.peripherals.count > 0)
    {
        for (CBPeripheral *p in t.peripherals) {
            if ([p.name rangeOfString:@"Keyfob"].location != NSNotFound) {
                [t connectPeripheral:p];
                printf("Equal\n");
            } else {
                printf("Not equal\n");
            }
        }
        //[t connectPeripheral:[t.peripherals objectAtIndex:0]];

    }
    else 
 */
 [TIBLEUISpinner stopAnimating];
 [TIBLEUIConnBtn setTitle:@"扫描并连接KeyFob" forState:UIControlStateNormal];
}

- (IBAction)TIBLEUISoundBuzzerButton:(id)sender {
    [t soundBuzzer:0x02 p:[t activePeripheral]]; //Sound buzzer with 0x02 as data value
}

@end
