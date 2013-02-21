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
- (void)updateInput:(NSTimeInterval)timeInterval;
- (void)keyDown:(unichar)key;
- (void)keyUp:(unichar)key;
- (void)mouseLeftDown:(NSPoint)locationInWindow;
- (void)mouseLeftUp:(NSPoint)locationInWindow;
- (void)mouseRightDown:(NSPoint)locationInWindow;
- (void)mouseRightUp:(NSPoint)locationInWindow;
- (void)mouseMoveWithX:(CGFloat)x andY:(CGFloat)y;
- (void)mouseLeftDragWithX:(CGFloat)x andY:(CGFloat)y;
- (void)mouseRightDragWithX:(CGFloat)x andY:(CGFloat)y;
- (void)mouseScrollWithX:(CGFloat)x andY:(CGFloat)y;

@end

@interface GSInputController : NSObject

+ (GSInputController *)sharedInputController;

- (void)addEventDelegate:(id<GSInputDelegate>)delegate;
- (void)removeEventDelegate:(id<GSInputDelegate>)delegate;

- (void)updateDelegate:(NSTimeInterval)timeInterval;

- (void)keysDown:(NSString *)keys;
- (void)keysUp:(NSString *)keys;
- (BOOL)keyIsPressed:(unichar)key;

- (void)mouseLeftDown:(NSPoint)locationInWindow;
- (void)mouseLeftUp:(NSPoint)locationInWindow;
- (void)mouseRightDown:(NSPoint)locationInWindow;
- (void)mouseRightUp:(NSPoint)locationInWindow;
- (void)mouseMoveWithX:(CGFloat)x andY:(CGFloat)y;
- (void)mouseLeftDragWithX:(CGFloat)x andY:(CGFloat)y;
- (void)mouseRightDragWithX:(CGFloat)x andY:(CGFloat)y;
- (void)mouseScrollWithX:(CGFloat)x andY:(CGFloat)y;

@end
