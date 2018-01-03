//
//  ViewController.m
//  TestVideo
//
//  Created by Admin on 12/21/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import "FFVideoViewController.h"
#import "RTSPPlayer.h"

@interface FFVideoViewController ()

{
    UIButton *time;
    
}
@property (nonatomic, assign) BOOL bplaying;
@property (nonatomic, assign) BOOL bKillThread;
@property (nonatomic, assign) int  missingPackets;  //丢失包数量

@property (nonatomic, copy) NSString *videoAddress;
@property (nonatomic, strong) UIImageView *secrondView;

@end

@implementation FFVideoViewController

@synthesize video;


- (instancetype)initWithVideoAddress:(NSString *)videoAddress{
    if (self = [super init]) {
        self.videoAddress = videoAddress;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bplaying = false;
    self.bKillThread = false;
    self.missingPackets = 0;
    
    time = [[UIButton alloc] init];
    [time setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [time setTitle:@"播放时间" forState:UIControlStateNormal];
    time.frame = CGRectMake(200, 64, 200, 50);
    time.backgroundColor = [UIColor redColor];
    [self.view addSubview:time];
    
    
    UIButton *_btn = [[UIButton alloc] init];
    [_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_btn setTitle:@"开始/暂停" forState:UIControlStateNormal];
    _btn.frame = CGRectMake(0, 64, 200, 50);
    _btn.backgroundColor = [UIColor redColor];
    [self.view addSubview:_btn];
    [_btn addTarget:self action:@selector(pauseBtn) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *_btn1 = [[UIButton alloc] init];
    [_btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_btn1 setTitle:@"取消播放" forState:UIControlStateNormal];
    _btn1.frame = CGRectMake(0, 114, 200, 50);
    _btn1.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:_btn1];
    [_btn1 addTarget:self action:@selector(stopBtn) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *_btn2 = [[UIButton alloc] init];
    [_btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_btn2 setTitle:@"重新播放" forState:UIControlStateNormal];
    _btn2.frame = CGRectMake(0, 164, 200, 50);
    _btn2.backgroundColor = [UIColor greenColor];
    [self.view addSubview:_btn2];
    [_btn2 addTarget:self action:@selector(replayBtn) forControlEvents:UIControlEventTouchUpInside];
    
    

    
 
    CGRect bounds = [[UIScreen mainScreen] bounds];

    // 视屏1
    _secrondView = [[UIImageView alloc] init];
    _secrondView.image = [UIImage imageNamed:@"plan"];
    _secrondView.contentMode = UIViewContentModeScaleAspectFit;
    _secrondView.backgroundColor = [UIColor yellowColor];
    _secrondView.frame = CGRectMake(0, 300, bounds.size.width, 180);
    [self.view addSubview:_secrondView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.bKillThread = true;
    self.bplaying = false;
}



// 开辟新线程 进行视频播放
- (void)imageThreadProc
{
    while (true) {
 
        if (self.bKillThread) {
            [NSThread exit];
        }
        
        if (self.bplaying == NO) {
            
            NSLog(@"self.bPlaying = NO");
            [NSThread sleepForTimeInterval:1.0f];
            
        }else{
            
            if (video !=nil && [video stepFrame]) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    _secrondView.image = video.currentImage;
                    [time setTitle:[self tranformTime:video.currentTime] forState:UIControlStateNormal];
                });
                
            }else{
                
                self.missingPackets += 1;
                if (self.missingPackets == 3) {
                    [self initPlayer];
                    self.missingPackets = 0;
                }
            }
            
            [NSThread sleepForTimeInterval:0.02f];
        }
    }
}



- (void)playOrPausePlayer {
    
    if (self.bKillThread) return;
    self.bplaying = !self.bplaying;
}

- (void)resetPlayer {
    
    video = nil;
    self.bKillThread = true;
    self.bplaying = NO;
    _secrondView.image = [UIImage imageNamed:@"plan"];
}

- (void)initPlayer {
    
    if (self.video) {
        self.video = nil;
    }
    
    self.bplaying = FALSE;
    
    if (self.bplaying == FALSE) {
        video = [[RTSPPlayer alloc] initWithVideo:self.videoAddress usesTcp:NO];
        
        if(video != nil){
            video.outputWidth = 600;
            video.outputHeight = 400;
            [video seekTime:30.00];
            [video closeAudio];
            self.bplaying = TRUE;
        }
    }
}


- (void)pauseBtn {
    
    [self playOrPausePlayer];
}

- (void)stopBtn {
    
    [video seekTime:335];
//    [self resetPlayer];
}

- (void)replayBtn{
    
    if (!self.bKillThread) {
        self.bKillThread = YES;

        [self resetPlayer];
        
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0* NSEC_PER_SEC));

        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            self.bKillThread = false;
            self.bplaying = true;
            [NSThread detachNewThreadSelector:@selector(imageThreadProc) toTarget:self withObject:nil];
        });
    }else{
        
        self.bKillThread = false;
        self.bplaying = true;
        [NSThread detachNewThreadSelector:@selector(imageThreadProc) toTarget:self withObject:nil];
    }

}


- (NSString *)tranformTime:(double)curTime {
    
    NSInteger cur = (NSInteger)curTime;
    
    NSInteger curHour = cur /3600;//当前小时
    NSInteger curMin = cur / 60;//当前分钟
    NSInteger curSec = cur % 60;//当前秒
    
    NSString *time = [NSString stringWithFormat:@"%02zd:%02zd:%02zd", curHour,curMin, curSec];;
    return time;
}



@end
