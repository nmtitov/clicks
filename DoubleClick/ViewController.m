//
//  ViewController.m
//  DoubleClick
//
//  Created by Nikita on 08/02/16.
//  Copyright © 2016 Nikita Mikhailovich Titov. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveCocoa.h>

@interface NSNumber (NT)

- (instancetype)numberByAddingOne__nt;
- (instancetype)numberByAddingNumber__nt:(NSNumber *)r;

@end

@implementation NSNumber (NT)

- (instancetype)numberByAddingOne__nt {
    return [self numberByAddingNumber__nt:@1];
}

- (instancetype)numberByAddingNumber__nt:(NSNumber *)r {
    return @(self.doubleValue + r.doubleValue);
}

@end

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    RAC(self.label, text) = [[[[
    [self.button rac_signalForControlEvents:UIControlEventTouchUpInside]
    scanWithStart:@0 reduce:^id(NSNumber *x, id _) {
        return [x numberByAddingOne__nt];
    }]
    map:^id(id x) {
        return [NSString stringWithFormat:@"Clicks: %@", x];
    }]
    takeUntil:[[self.button rac_signalForControlEvents:UIControlEventTouchUpInside] throttle:0.25]]
    repeat];
}

@end
