//
//  BNRHypnosisViewController.h
//  HypnoNerd
//
//  Created by manit on 15/1/2558.
//  Copyright (c) พ.ศ. 2558 golf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNRHypnosisView.h"

@interface BNRHypnosisViewController : UIViewController

@property (nonatomic, weak) IBOutlet BNRHypnosisView * hypnosisView;

-(IBAction)changeColor:(UISegmentedControl * )sender;

@end
