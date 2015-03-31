//
//  KonashiUartUtil.m
//  KonashiUart
//
//  Created by 古川信行 on 2015/03/29.
//  Copyright (c) 2015年 古川信行. All rights reserved.
//

#import "KonashiUart.h"

@interface KonashiUartUtil(){
    //UART ボーレート
    KonashiUartBaudrate _baudrate;
    
    //読み込み完了時のデリゲート
    id<KonashiUartDelegate> _delegate;
    
    //UART で受信した文字列
    NSString* uartStr;
}
@end

@implementation KonashiUartUtil


//インスタンス取得
+ (KonashiUartUtil *) shared
{
    static KonashiUartUtil *_konashiUartUtil = nil;
    
    @synchronized (self){
        static dispatch_once_t pred;
        dispatch_once(&pred, ^{
            _konashiUartUtil = [[[KonashiUartUtil alloc] init] initialize];
        });
    }
    
    return _konashiUartUtil;
}

//初期化
- (id) initialize {
    [Konashi initialize];
    
    [Konashi addObserver:self selector:@selector(connected) name:KonashiEventConnectedNotification];
    [Konashi addObserver:self selector:@selector(ready) name:KonashiEventReadyToUseNotification];
    [Konashi addObserver:self selector:@selector(uartRead) name:KonashiEventUartRxCompleteNotification];
    
    return self;
}

//切断
- (void) disconnect{
    NSLog(@"disconnect");
    [Konashi disconnect];
}

//名前指定無しで検索
- (void) find:(id<KonashiUartDelegate>)delegate baudrate:(KonashiUartBaudrate)baudrate{
    [self findWithName:nil delegate:delegate baudrate:baudrate];
}

//指定した名前の konashi を検索して接続する
- (void) findWithName:(NSString*)name delegate:(id<KonashiUartDelegate>) delegate baudrate:(KonashiUartBaudrate)baudrate{
    NSLog(@"findWithName name:%@",name);
    _baudrate = baudrate;
    _delegate = delegate;
    
    if(name == nil){
        //名前指定無し
        [Konashi find];
    }
    else{
        //名前指定アリで接続
        NSLog(@"name:%@ konashiName:%@",name,name);
        [Konashi findWithName:name];
    }
}

// Konashi デリゲート -------------

//Konashiと接続
-(void) connected {
    NSLog(@"CONNECTED");
}

//操作できるようになった
-(void) ready{
    NSLog(@"READY");
    NSLog(@"peripheralName:%@",[Konashi peripheralName]);
    
    //UART設定を初期化
    [Konashi uartMode:KonashiUartModeEnable baudrate:_baudrate];
    
    //設定が終わったのでコールバックする
    if(_delegate != nil){
        [_delegate ready];
    }
}

- (void)uartRead{
    //UART から文字列を読み込む
    NSData *data = [Konashi readUartData];
    
    //読み込んだ データを 文字列に変換
    NSString *str= [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    //追加
    uartStr = [uartStr stringByAppendingString:str];
    
    //改行コードがあったら コールバックして クリア
    if([@"\n" isEqualToString:str]){
        if(_delegate != nil){
            [_delegate uartRead:uartStr];
        }
        uartStr = @"";
    }
}

//送信
-(void) send:(NSString*) data{
    [Konashi uartWriteString:data];
}

@end
