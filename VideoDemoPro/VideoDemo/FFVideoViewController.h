//
//  FFVideoViewController.h
//  UAVGSBMAP
//
//  Created by fly on 16/1/11.
//  Copyright © 2016年 liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RTSPPlayer;

@interface FFVideoViewController : UIViewController

@property (nonatomic, strong) RTSPPlayer *video;


-(instancetype)initWithVideoAddress:(NSString *)videoAddress;

-(void)playWithAddress:(NSString *)address;


@end
