//
//  GSCameraController.m
//  OpenGL-Tutorial
//
//  Created by 朱 巍 on 21/2/13.
//  Copyright (c) 2013 Juicer. All rights reserved.
//

#import "GSCameraController.h"

@implementation GSCameraController

- (id)initWithEye:(kmVec3)eye Center:(kmVec3)center Up:(kmVec3)up
{
    self = [super init];
    if (self) {
        kmVec3Fill(&_eye, eye.x, eye.y, eye.z);
        kmVec3Fill(&_center, center.x, center.y, center.z);
        kmVec3Fill(&_up, up.x, up.y, up.z);
        _moveSpeed = 3.0;
        _rotateSpeed = 0.01;
        _fov = 45.0;
        _aspect = 4.0/3.0;
        _near = 0.1;
        _far = 1000.0;
        
        [[GSInputController sharedInputController] addEventDelegate:self];
    }
    
    return self;
}

- (kmMat4)viewMatrix
{
    kmMat4 view;
    kmMat4LookAt(&view, &_eye, &_center, &_up);
    return view;
}

- (kmMat4)perspectiveMatrix
{
    kmMat4 projection;
    kmMat4PerspectiveProjection(&projection, _fov, _aspect, _near, _far);
    return projection;
}
- (void)updateInput:(NSTimeInterval)timeInterval
{
    kmVec3 f, s, u;
    
    kmVec3Subtract(&f, &_center, &_eye);
    kmVec3Normalize(&f, &f);
    
    kmVec3Normalize(&_up, &_up);
    
    kmVec3Cross(&s, &f, &_up);
    kmVec3Normalize(&s, &s);
    
    kmVec3Cross(&u, &s, &f);
    kmVec3Normalize(&s, &s);
    
    GSInputController *inputController = [GSInputController sharedInputController];
    float delta = _moveSpeed * timeInterval;
    if ([inputController keyIsPressed:NSLeftArrowFunctionKey]) {
        kmVec3Scale(&s, &s, -delta);
        kmVec3Add(&_eye, &_eye, &s);
        kmVec3Add(&_center, &_center, &s);
    } else if ([inputController keyIsPressed:NSRightArrowFunctionKey]) {
        kmVec3Scale(&s, &s, delta);
        kmVec3Add(&_eye, &_eye, &s);
        kmVec3Add(&_center, &_center, &s);
    } else if ([inputController keyIsPressed:NSUpArrowFunctionKey]) {
        kmVec3Scale(&f, &f, delta);
        kmVec3Add(&_eye, &_eye, &f);
        kmVec3Add(&_center, &_center, &f);
    } else if ([inputController keyIsPressed:NSDownArrowFunctionKey]) {
        kmVec3Scale(&f, &f, -delta);
        kmVec3Add(&_eye, &_eye, &f);
        kmVec3Add(&_center, &_center, &f);
    }
}

- (void)mouseLeftDragWithX:(CGFloat)x andY:(CGFloat)y
{
    float thetaX = -x * _rotateSpeed;
    float thetaY = -y * _rotateSpeed;
    
    kmVec3 f, s, u, dist;
    
    kmVec3Subtract(&f, &_center, &_eye);
    kmScalar distance = kmVec3Length(&f);
    kmVec3Normalize(&f, &f);
    
    kmVec3Normalize(&_up, &_up);
    
    kmVec3Cross(&s, &f, &_up);
    kmVec3Normalize(&s, &s);
    
    kmVec3Cross(&u, &s, &f);
    kmVec3Normalize(&s, &s);
    
    dist = f;
    
    kmQuaternion yaw, pitch;
    kmQuaternionRotationAxis(&yaw, &u, thetaX);
    kmQuaternionRotationAxis(&pitch, &s, thetaY);
    kmQuaternionMultiplyVec3(&dist, &pitch, &dist);
    kmQuaternionMultiplyVec3(&dist, &yaw, &dist);
    
    kmVec3Scale(&dist, &dist, distance);
    kmVec3Add(&_center, &_eye, &dist);
}

@end
