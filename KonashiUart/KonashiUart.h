//
//  KonashiUartUtil.h
//  KonashiUart
//
//  Created by 古川信行 on 2015/03/29.
//  Copyright (c) 2015年 古川信行. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Konashi.h"

@protocol KonashiUartDelegate

//konashi 初期化が完了
-(void) ready;

//UART からデータを受信した
- (void)uartRead:(NSString*) data;

@end

@interface KonashiUartUtil : NSObject

//インスタンス取得
+ (KonashiUartUtil *) shared;

//名前してい無しで検索して接続
- (void) find:(id<KonashiUartDelegate>) delegate baudrate:(KonashiUartBaudrate)baudrate;

//指定した名前の neconote を検索して接続する
- (void) findWithName:(NSString*)name delegate:(id<KonashiUartDelegate>) delegate baudrate:(KonashiUartBaudrate)baudrate;

//切断
- (void) disconnect;

//送信
-(void) send:(NSString*) data;

@end
