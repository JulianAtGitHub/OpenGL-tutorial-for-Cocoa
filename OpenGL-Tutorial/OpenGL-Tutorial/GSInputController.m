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
    NSMutableArray *_keyPressed;
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
        _keyPressed = [NSMutableArray array];
        for (NSUInteger i = 0; i < USHRT_MAX; ++i) {
            [_keyPressed addObject:[NSNumber numberWithBool:NO]];
        }
    }
    
    return self;
}

- (void)addEventDelegate:(id<GSInputDelegate>)delegate
{
    for (id<GSInputDelegate> obj in _objsForKeyEvent) {
        if ([obj isEqual:delegate]) {
            NSLog(@"%@ is exist in array objsForKeyEvent", delegate);
            return;
        }
    }
    [_objsForKeyEvent addObject:delegate];
}

- (void)removeEventDelegate:(id<GSInputDelegate>)delegate
{
    for (id<GSInputDelegate> obj in _objsForKeyEvent) {
        if ([obj isEqual:delegate]) {
            [_objsForKeyEvent removeObject:delegate];
            return;
        }
    }
}

- (void)updateDelegate:(NSTimeInterval)timeInterval
{
    for (id<GSInputDelegate> obj in _objsForKeyEvent) {
        if ([obj respondsToSelector:@selector(updateInput:)]) {
            [obj updateInput:timeInterval];
        }
    }
}

- (void)keysDown:(NSString *)keys
{
    for (NSUInteger i = 0; i < [keys length]; ++i) {
        unichar character = [keys characterAtIndex:i];
        [_keyPressed replaceObjectAtIndex:character withObject:[NSNumber numberWithBool:YES]];
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
        [_keyPressed replaceObjectAtIndex:character withObject:[NSNumber numberWithBool:NO]];
        for (id<GSInputDelegate> obj in _objsForKeyEvent) {
            if ([obj respondsToSelector:@selector(keyUp:)]) {
                [obj keyUp:character];
            }
        }
    }
}

- (BOOL)keyIsPressed:(unichar)key
{
    return [[_keyPressed objectAtIndex:key] boolValue];
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

- (void)mouseMoveWithX:(CGFloat)x andY:(CGFloat)y
{
    for (id<GSInputDelegate> obj in _objsForKeyEvent) {
        if ([obj respondsToSelector:@selector(mouseMoveWithX:andY:)]) {
            [obj mouseMoveWithX:x andY:y];
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

- (void)mouseScrollWithX:(CGFloat)x andY:(CGFloat)y
{
    for (id<GSInputDelegate> obj in _objsForKeyEvent) {
        if ([obj respondsToSelector:@selector(mouseScrollWithX:andY:)]) {
            [obj mouseScrollWithX:x andY:y];
        }
    }
}

@end
