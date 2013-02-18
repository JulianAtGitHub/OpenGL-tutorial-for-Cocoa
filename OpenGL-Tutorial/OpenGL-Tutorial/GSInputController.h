//
//  GSInputController.h
//  OpenGL-Tutorial
//
//  Created by 朱 巍 on 18/2/13.
//  Copyright (c) 2013 Juicer. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GSInputDelegate <NSObject>

@optional
- (void)keyDown:(unichar)key;
- (void)keyUp:(unichar)key;

@end

@interface GSInputController : NSObject

+ (GSInputController *)sharedInputController;

- (void)addKeyEventDelegate:(id<GSInputDelegate>)delegate;
- (void)removeKeyEventDelegate:(id<GSInputDelegate>)delegate;

- (void)keysDown:(NSString *)keys;
- (void)keysUp:(NSString *)keys;

@end
