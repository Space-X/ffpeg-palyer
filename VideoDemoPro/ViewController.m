//
//  ViewController.m
//  VideoDemoPro
//
//  Created by gsq on 17/9/26.
//  Copyright © 2017年 zhidao. All rights reserved.
//

#import "ViewController.h"
#import "FFVideoViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (IBAction)buttonClicked:(id)sender {
    
    NSString *url = nil;
    
    url = @"http://192.168.1.66:8088/WebFiles/24c87890d28e42d08766474b304ada0a/LearnKJ/2181867b97ca4b16b4287b922fc80c66.mp4";

    url = @"http://edu.cnshipping.com/WebFiles/1/LearnKJ/39732894e0ac4014ad7ac1674c56c829.mp4";
    
    //url = @"http://devimages.apple.com.edgekey.net/streaming/examples/bipbop_4x3/gear2/prog_index.m3u8";
    
    //url = @"rtmp://live.hkstv.hk.lxdns.com/live/hks";
    
    //url = @"rtmp://123.57.214.22/WebFiles/mp4/24c87890d28e42d08766474b304ada0a/LearnKJ/ada973b773564af6a93a075bd2d5fa46.mp4";

    FFVideoViewController *ffVideoVC = [[FFVideoViewController alloc] initWithVideoAddress:url];
    [self.navigationController pushViewController:ffVideoVC animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.title = @"will playing";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
