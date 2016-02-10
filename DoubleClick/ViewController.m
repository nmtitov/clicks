//
//  ViewController.m
//  DoubleClick
//
//  Created by Nikita on 08/02/16.
//  Copyright © 2016 Nikita Mikhailovich Titov. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveCocoa.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    RAC(self.label, text) = [[[[
    [self.button rac_signalForControlEvents:UIControlEventTouchUpInside]
    scanWithStart:[NSArray new] reduce:^id(NSArray *xs, id x) {
        return [xs arrayByAddingObject:x];
    }]
    map:^id(NSArray *xs) {
        return [NSString stringWithFormat:@"Clicks: %d", (int)xs.count];
    }]
    takeUntil:[[self.button rac_signalForControlEvents:UIControlEventTouchUpInside] throttle:0.25]]
    repeat];
}

@end
