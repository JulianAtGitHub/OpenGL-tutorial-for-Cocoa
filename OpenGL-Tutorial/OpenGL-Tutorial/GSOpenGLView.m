//
//  GSOpenGLView.m
//  OpenGL-Tutorial
//
//  Created by wei.zhu on 1/23/13.
//  Copyright (c) 2013 Juicer. All rights reserved.
//

#import "GSOpenGLView.h"
#import "GSInputController.h"
#import <OpenGL/gl3.h>

@implementation GSOpenGLView

- (void)visit:(NSTimer*)theTimer
{
    if ([theTimer isEqual:_timer] == NO) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(update:)]) {
        [self.delegate update:[theTimer timeInterval]];
        [self drawRect:[self bounds]];
    }
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
    [[self openGLContext] makeCurrentContext];
    
    if ([self.delegate respondsToSelector:@selector(render)]) {
        [self.delegate render];
    }
    
    [[self openGLContext] flushBuffer];
}

- (void)update  // moved or resized
{
    [super update];

    [[self openGLContext] makeCurrentContext];
    [[self openGLContext] update];
    
    NSRect rect = [self bounds];
    glViewport(0, 0, (GLint) rect.size.width, (GLint) rect.size.height);
}

- (void)reshape
{
    [super reshape];
    
    [[self openGLContext] makeCurrentContext];
    [[self openGLContext] update];
    
    NSRect rect = [self bounds];
    glViewport(0, 0, rect.size.width, rect.size.height);
}

- (BOOL)acceptsFirstResponder
{
    return YES;
}

- (BOOL)becomeFirstResponder
{
    return YES;
}

#pragma mark - keyboard and mouse event

- (void)keyDown:(NSEvent *)theEvent
{
    [super keyDown:theEvent];
    
    NSString *characters = [theEvent characters];
    [[GSInputController sharedInputController] keysDown:characters];
    
    NSLog(@"keyDown: %@", characters);
}

- (void)keyUp:(NSEvent *)theEvent
{
    [super keyUp:theEvent];
    
    NSString *characters = [theEvent characters];
    [[GSInputController sharedInputController] keysUp:characters];
    
    NSLog(@"keyUp: %@", characters);
}

- (void)mouseDown:(NSEvent *)theEvent
{
    [super mouseDown:theEvent];
    
    NSPoint location = [theEvent locationInWindow];
    [[GSInputController sharedInputController] mouseLeftDown:location];
    
    NSLog(@"mouseDown: location:%f %f", location.x, location.y);
}

- (void)mouseUp:(NSEvent *)theEvent
{
    [super mouseUp:theEvent];
    
    NSPoint location = [theEvent locationInWindow];
    [[GSInputController sharedInputController] mouseLeftUp:location];
    
    NSLog(@"mouseUp: location:%f %f", location.x, location.y);
}

- (void)rightMouseDown:(NSEvent *)theEvent
{
    [super rightMouseDown:theEvent];
    
    NSPoint location = [theEvent locationInWindow];
    [[GSInputController sharedInputController] mouseRightDown:location];
    
    NSLog(@"rightMouseDown: location:%f %f", location.x, location.y);
}

- (void)rightMouseUp:(NSEvent *)theEvent
{
    [super rightMouseUp:theEvent];
    
    NSPoint location = [theEvent locationInWindow];
    [[GSInputController sharedInputController] mouseRightUp:location];
    
    NSLog(@"rightMouseUp: location:%f %f", location.x, location.y);
}

- (void)mouseDragged:(NSEvent *)theEvent
{
    [super mouseDragged:theEvent];
    
    CGFloat x = [theEvent deltaX];
    CGFloat y = [theEvent deltaY];
    [[GSInputController sharedInputController] mouseLeftDragWithX:x andY:y];
    
    NSLog(@"mouseDragged: x:%f y:%f", x, y);
}

- (void)rightMouseDragged:(NSEvent *)theEvent
{
    [super rightMouseDragged:theEvent];
    
    CGFloat x = [theEvent deltaX];
    CGFloat y = [theEvent deltaY];
    [[GSInputController sharedInputController] mouseRightDragWithX:x andY:y];
    
    NSLog(@"rightMouseDragged: x:%f y:%f", x, y);
}

- (void)scrollWheel:(NSEvent *)theEvent
{
    [super scrollWheel:theEvent];
    
    CGFloat x = [theEvent scrollingDeltaX];
    CGFloat y = [theEvent scrollingDeltaY];
    [[GSInputController sharedInputController] mouseScrollWithX:x andY:y];
    
    NSLog(@"scrollWheel: x:%f y:%f", x, y);
}

@end
