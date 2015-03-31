//
//  ViewController.m
//  KonashiUart
//
//  Created by 古川信行 on 2015/03/29.
//  Copyright (c) 2015年 古川信行. All rights reserved.
//

#import "ViewController.h"
#import "KonashiUart.h"

@interface ViewController ()<KonashiUartDelegate>{
    KonashiUartUtil * konashiUartUtil;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //konashi 初期化
    konashiUartUtil = [KonashiUartUtil shared];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//検索
- (IBAction)clickBtnFind:(id)sender {
    
    //名前指定無しで 検索してから接続する場合
    [konashiUartUtil find:self baudrate:KonashiUartBaudrateRate9K6];
    
    //名前指定で接続する場合
    //[konashiUartUtil findWithName:@"konashi2-f01268" delegate:self baudrate:KonashiUartBaudrateRate9K6];
}

//送信
- (IBAction)clickBtnSend:(id)sender {
    //文字列を送信
    NSString* json = @"{\"cmd\":\"led\",\"r\":255,\"g\":255,\"b\":255}";
    [konashiUartUtil send:json];
}

//切断
- (IBAction)clickBtnDisconnect:(id)sender{
    [konashiUartUtil disconnect];
}

#pragma mark KonashiUartDelegate -----

//konashi 初期化が完了
-(void) ready{
    NSLog(@"KonashiUartUtilDelegate READY");
}

//UART からデータを受信した
- (void)uartRead:(NSString*) data{
    NSLog(@"KonashiUartUtilDelegate UART READ");
    NSLog(@"data:%@",data);
    //TODO 複数分まとめて届く場合があるので 改行コードで分割するなど旨いこと処理する必要がある
    /* json として処理する例
    if(data){
        NSData *tmp = [data dataUsingEncoding:NSUTF8StringEncoding];
        id jsonObj = [NSJSONSerialization JSONObjectWithData:tmp options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"jsonObj:%@",jsonObj);
    }
    */
}

@end
