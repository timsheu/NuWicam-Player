//
//  CustomTableViewCell.m
//  NuWicam
//
//  Created by CCHSU20 on 10/5/16.
//  Copyright © 2016 Nuvoton. All rights reserved.
//

#import "CustomTableViewCell.h"
#import "ModbusControl.h"
@implementation CustomTableViewCell{
    ModbusControl *modbusControl;
    int lightValue;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    modbusControl = [ModbusControl sharedInstance];
    modbusControl.delegate = self;
    isConnectedToModbus = NO;
    lightValue = 0;
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(pollingGetTemperature) userInfo:nil repeats:YES];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)click:(id)sender {
    UIButton *button = (UIButton *)sender;
    DDLogDebug(@"light on value: %d", lightValue);
    uint8_t lightStatus[6] = {  (lightValue >> 5 ) & 0x1,
        (lightValue >> 4 ) & 0x1,
        (lightValue >> 3 ) & 0x1,
        (lightValue >> 2 ) & 0x1,
        (lightValue >> 1 ) & 0x1,
        lightValue & 0x1};
    lightStatus[button.tag-101] = !lightStatus[button.tag-101];
    int finalValue=0;
    for (int i=0; i<6; i++) {
        finalValue = finalValue | (lightStatus[i] << (5-i));
    }
    lightValue = finalValue;
    DDLogDebug(@"final light value: %d, %d", finalValue, lightValue);
    [modbusControl writeRegister:4 to:finalValue];
}

- (void)pollingGetTemperature{
    if (isConnectedToModbus == YES) {
        [modbusControl readRegister:3 count:5];
    }
}

#pragma mark Modbus Delegation functions

- (void)modbusConnectSuccess{
    DDLogDebug(@"Modbus connect success");
    isConnectedToModbus = YES;
    [modbusControl readRegister:3 count:5];
}

- (void)modbusWriteSuccess{
    DDLogDebug(@"modbusWriteSuccess");
}

- (void)modbusReadSuccess:(NSArray *)dataArray{
    NSNumber *temp = [dataArray objectAtIndex:4];
    NSNumber *light = [dataArray objectAtIndex:1];
    _temperatureLabel.text = [NSString stringWithFormat:@"%@\u2103", temp];
    
    lightValue = light.intValue;
    UIButton *button;
    for (int i=0; i<6; i++) {
        button = (UIButton *)[self viewWithTag:i+101];
        uint8_t temp = (lightValue >> (5-i));
        if ((temp & 0x1) == 1) {
            if (i == 0 || i == 1) {
                [button.imageView setImage:[UIImage imageNamed:@"lightOff"]];
            }else if( i == 2 || i == 3){
                [button.imageView setImage:[UIImage imageNamed:@"yellowOff"]];
            }else{
                [button.imageView setImage:[UIImage imageNamed:@"flashOff"]];
            }
        }else{
            if (i == 0 || i == 1) {
                [button.imageView setImage:[UIImage imageNamed:@"lightOn"]];
            }else if( i == 2 || i == 3){
                [button.imageView setImage:[UIImage imageNamed:@"yellowOn"]];
            }else{
                [button.imageView setImage:[UIImage imageNamed:@"flashOn"]];
            }
        }
    }
}

- (void)modbusConnectFail{
    isConnectedToModbus = NO;
    modbusControl.count++;
    if (modbusControl.count < 3) {
        [modbusControl connect];
    }else{
        [_temperatureLabel setEnabled:NO];
        _temperatureLabel.text = @"N/A\u2103";
        UIButton *button;
        for (int i=0; i<6; i++) {
            button = (UIButton *)[self viewWithTag:i+101];
            [button setEnabled:NO];
        }
    }
}

@end
