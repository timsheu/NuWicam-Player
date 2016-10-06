//
//  CustomTableViewCell.h
//  NuWicam
//
//  Created by CCHSU20 on 10/5/16.
//  Copyright © 2016 Nuvoton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModbusControl.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
#import "Constants.h"

@interface CustomTableViewCell : UITableViewCell <ModbusControlDelegate>{
    BOOL isConnectedToModbus;
    NSTimer *timer;
}
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
- (IBAction)click:(id)sender;

@end
