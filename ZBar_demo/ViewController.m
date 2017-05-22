//
//  ViewController.m
//  ZBar_demo
//
//  Created by shaoting on 16/2/3.
//  Copyright © 2016年 9elephas. All rights reserved.
//

#import "ViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#define ScreenFrame [[UIScreen mainScreen]bounds]
@interface ViewController ()<AVCaptureMetadataOutputObjectsDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

{
    ZBarReaderController *imagePicker;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 50, 50);
    [btn setTitle:@"扫描" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark------扫描相册 二维码
-(void)rightBtnClick:(UIButton *)btn
{
    
    imagePicker = [ZBarReaderController new];
    
    imagePicker.allowsEditing = NO   ;
    
    imagePicker.showsHelpOnFail = NO;
    
    imagePicker.readerDelegate = self;
    
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}
#pragma mark - ZBarReaderController ReadDelegate
//相册选取图片后的代理方法对应ZBarReaderController
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    id<NSFastEnumeration> results = [info objectForKey:ZBarReaderControllerResults];
    
    ZBarSymbol *symbol = nil;
    
    for(symbol in results) {
        NSLog(@"symbol:%@", symbol);
        break;
    }
    
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
    
    
    //二维码字符串
//    NSString *QRCodeString =  symbol.data;
    //处理二维码图片信息
//    [self getTicketDetailInfo:QRCodeString];
    
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"消息" message:symbol.data delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:@"OK1", nil];
    [alert show];
    
}
//选择图片没有二维码信息的代理方法
-(void)readerControllerDidFailToRead:(ZBarReaderController *)reader withRetry:(BOOL)retry
{
    if (retry) {
        //retry == 1 选择图片为非二维码。
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"没有识别到图片中二维码" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        
        [alert show];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    return;
}

-(void)erweima:(UIButton *)btn{
    ZBarReaderViewController * reader = [ZBarReaderViewController new];//初始化相机控制器
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;//基本适配
    reader.showsHelpOnFail = YES;
    reader.scanCrop = CGRectMake(0, 0, 1, 1);
    ZBarImageScanner * scanner = reader.scanner;
    [scanner setSymbology:25 config:0 to:0];
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, ScreenFrame.size.height)];
    reader.cameraOverlayView = view;
    [self presentViewController:reader animated:YES completion:^{
        
    }];
    
}
//- (void) imagePickerController: (UIImagePickerController*) reader
// didFinishPickingMediaWithInfo: (NSDictionary*) info{
//    id<NSFastEnumeration> results =
//    [info objectForKey: ZBarReaderControllerResults];
//    ZBarSymbol *symbol = nil;
//    for(symbol in results)
//        break;
//    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"消息" message:symbol.data delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:@"OK1", nil];
//    [alert show];
//    
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
