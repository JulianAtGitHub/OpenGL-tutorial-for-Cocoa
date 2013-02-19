//
//  GSInputController.m
//  OpenGL-Tutorial
//
//  Created by 朱 巍 on 18/2/13.
//  Copyright (c) 2013 Juicer. All rights reserved.
//

#import "GSInputController.h"

@interface GSInputController() {
    NSMutableArray *_objsForKeyEvent;
}

@end

@implementation GSInputController

+ (GSInputController *)sharedInputController
{
    static GSInputController *instance = nil;
    
    if (instance == nil) {
        instance = [[GSInputController alloc] init];
    }
    
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        _objsForKeyEvent = [NSMutableArray array];
    }
    
    return self;
}

- (void)addKeyEventDelegate:(id<GSInputDelegate>)delegate
{
    for (id<GSInputDelegate> obj in _objsForKeyEvent) {
        if ([obj isEqual:delegate]) {
            NSLog(@"%@ is exist in array objsForKeyEvent", delegate);
            return;
        }
    }
    [_objsForKeyEvent addObject:delegate];
}

- (void)removeKeyEventDelegate:(id<GSInputDelegate>)delegate
{
    for (id<GSInputDelegate> obj in _objsForKeyEvent) {
        if ([obj isEqual:delegate]) {
            [_objsForKeyEvent removeObject:delegate];
            return;
        }
    }
}

- (void)keysDown:(NSString *)keys
{
    for (NSUInteger i = 0; i < [keys length]; ++i) {
        unichar character = [keys characterAtIndex:i];
        for (id<GSInputDelegate> obj in _objsForKeyEvent) {
            if ([obj respondsToSelector:@selector(keyDown:)]) {
                [obj keyDown:character];
            }
        }
    }
}

- (void)keysUp:(NSString *)keys
{
    for (NSUInteger i = 0; i < [keys length]; ++i) {
        unichar character = [keys characterAtIndex:i];
        for (id<GSInputDelegate> obj in _objsForKeyEvent) {
            if ([obj respondsToSelector:@selector(keyUp:)]) {
                [obj keyUp:character];
            }
        }
    }
}

- (void)mouseLeftDown:(NSPoint)locationInWindow
{
    for (id<GSInputDelegate> obj in _objsForKeyEvent) {
        if ([obj respondsToSelector:@selector(mouseLeftDown:)]) {
            [obj mouseLeftDown:locationInWindow];
        }
    }
}

- (void)mouseLeftUp:(NSPoint)locationInWindow
{
    for (id<GSInputDelegate> obj in _objsForKeyEvent) {
        if ([obj respondsToSelector:@selector(mouseLeftUp:)]) {
            [obj mouseLeftUp:locationInWindow];
        }
    }
}

- (void)mouseRightDown:(NSPoint)locationInWindow
{
    for (id<GSInputDelegate> obj in _objsForKeyEvent) {
        if ([obj respondsToSelector:@selector(mouseRightDown:)]) {
            [obj mouseRightDown:locationInWindow];
        }
    }
}

- (void)mouseRightUp:(NSPoint)locationInWindow
{
    for (id<GSInputDelegate> obj in _objsForKeyEvent) {
        if ([obj respondsToSelector:@selector(mouseRightUp:)]) {
            [obj mouseRightUp:locationInWindow];
        }
    }
}

- (void)mouseLeftDragWithX:(CGFloat)x andY:(CGFloat)y
{
    for (id<GSInputDelegate> obj in _objsForKeyEvent) {
        if ([obj respondsToSelector:@selector(mouseLeftDragWithX:andY:)]) {
            [obj mouseLeftDragWithX:x andY:y];
        }
    }
}

- (void)mouseRightDragWithX:(CGFloat)x andY:(CGFloat)y
{
    for (id<GSInputDelegate> obj in _objsForKeyEvent) {
        if ([obj respondsToSelector:@selector(mouseRightDragWithX:andY:)]) {
            [obj mouseRightDragWithX:x andY:y];
        }
    }
}

@end
