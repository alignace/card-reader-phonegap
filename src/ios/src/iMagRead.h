//
//  iMagRead.h
//  iMagRead
//
//  Created by wwq on 13-6-10.
//  Copyright (c) 2013年 QunHua. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * CARREAD_MSG_ByteUpdate ; //通知应用更新
extern NSString * CARREAD_MSG_BitUpdate  ; //通知应用更新
extern NSString * CARREAD_MSG_Err ;


//请将下面的3行放到 m 文件中，并打开注释
//NSString * CARREAD_MSG_ByteUpdate = @"CARREAD_MSG_ByteUpdate";
//NSString * CARREAD_MSG_BitUpdate  = @"CARREAD_MSG_BitUpdate";
//NSString * CARREAD_MSG_Err  = @"CARREAD_MSG_Err";


@interface iMagRead : NSObject

-(void) Start;
-(void) Stop;
@end

