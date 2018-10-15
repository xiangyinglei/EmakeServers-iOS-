#import "UIView+PSAutoLayout.h"
#import "Header.h"

@implementation UIView (PSAutoLayout)

-(void) PSSetConstraint: (CGFloat) left Right:(CGFloat) right Top:(CGFloat) top Bottom:(CGFloat) bottom
{
    NSLayoutConstraint *cn = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:top];

    cn.active = YES;
    cn = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeLeading multiplier:1.0 constant:left];

    cn.active = YES;
    cn = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-right];
    cn.active = YES;

    cn = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-bottom];
    cn.active = YES;
}

-(void) PSSetWidth: (CGFloat) width
{
    NSLayoutConstraint *cn = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:width];
    cn.active = YES;
}

-(void) PSSetHeight: (CGFloat) height
{
    NSLayoutConstraint *cn = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:height];
    cn.active = YES;
}

-(void) PSSetSize: (CGFloat) width Height:(CGFloat) height
{
    [self PSSetWidth:width];
    [self PSSetHeight:height];
}

-(void) PSSetLeft: (CGFloat) length
{
    NSLayoutConstraint *cn = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeLeft multiplier:1.0 constant:length];
    cn.active = YES;
}

-(void) PSSetRight:(CGFloat) length
{
    NSLayoutConstraint *cn = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeRight multiplier:1.0 constant:-length];
    cn.active = YES;
}

-(void) PSSetTop:(CGFloat) length
{
    NSLayoutConstraint *cn = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:length];
    cn.active = YES;
}

-(void) PSSetBottom: (CGFloat) length
{
    NSLayoutConstraint *cn = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-length];
    cn.active = YES;
}

-(void) PSSetBottomAtItem:(id) item Length:(CGFloat) length
{
    /*
      NSLayoutConstraint *cn = [NSLayoutConstraint constraintWithItem:item1 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:item2 attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
         [self addConstraint:cn];
         */
    NSLayoutConstraint *cn = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:item attribute:NSLayoutAttributeBottom multiplier:1.0 constant:length];
    cn.active = YES;

}

-(void) PSSetRightAtItem: (id) item Length:(CGFloat) length
{
    NSLayoutConstraint *cn = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:item attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
    cn.active = YES;
    
    cn = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:item attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:length];
    cn.active = YES;
}
-(void) PSSetLeftAtItem: (id) item Length:(CGFloat) length
{
    NSLayoutConstraint *cn = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:item attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
    cn.active = YES;
    
    cn = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:item attribute:NSLayoutAttributeLeading multiplier:1.0 constant:length];
    cn.active = YES;
}
-(void) PSSetRightAtItemCenter: (id) item1 Lenght:(CGFloat) lenght
{
    /*
    NSLayoutConstraint *cn = [NSLayoutConstraint constraintWithItem:item1 attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:item2 attribute:NSLayoutAttributeRight multiplier:1.0 constant:lenght];
    cn.active = YES;
     */
}

-(void) PSSetCenterHorizontalAtItem: (id) item
{
    NSLayoutConstraint *cn = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:item attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
    cn.active = YES;
}

-(void) PSSetCenterVerticalAtItem: (id) item
{
    NSLayoutConstraint *cn = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:item attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
    cn.active = YES;
}

-(void) PSSetCenterXPercent: (CGFloat) offset
{
    NSLayoutConstraint *cn = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeLeft multiplier:1.0 constant:offset*ScreenWidth];
    cn.active = YES;
}

-(void) PSSetCenterX
{
    NSLayoutConstraint *cn = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
    cn.active = YES;
}









-(void) PSSetCenterXWithItem: (id) item
{
    NSLayoutConstraint *cn = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
    cn.active = YES;
}

-(void) PSSetCenterXWithItem: (id) item Offset:(CGFloat) offset
{
    NSLayoutConstraint *cn = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:offset constant:0.0];
    cn.active = YES;
}

-(void) PSSetCenterXOnItem: (id) item1 OnItem: (id) item2
{
    NSLayoutConstraint *cn = [NSLayoutConstraint constraintWithItem:item1 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:item2 attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
    cn.active = YES;
}



-(void) PSSetCenterYWithItem: (id) item Offset:(CGFloat) offset
{
    NSLayoutConstraint *cn = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:offset constant:0.0];
    cn.active = YES;
}

-(void) PSSetCenterYOnItem: (id) item1 OnItem: (id) item2
{
    NSLayoutConstraint *cn = [NSLayoutConstraint constraintWithItem:item1 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:item2 attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
    cn.active = YES;
}



#pragma TOP

-(void) PSSetTopWithItemCenter: (id) item Lenght:(CGFloat) lenght
{
    NSLayoutConstraint *cn = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:lenght];
    cn.active = YES;
}






-(void) PSSetLeftOnItem: (id) item1 OnItem:(id) item2 Lenght:(CGFloat) lenght
{
   
    NSLayoutConstraint *cn = [NSLayoutConstraint constraintWithItem:item1 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:item2 attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
    cn.active = YES;
    
    cn = [NSLayoutConstraint constraintWithItem:item1 attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:item2 attribute:NSLayoutAttributeLeading multiplier:1.0 constant:-lenght];
    cn.active = YES;
}

-(void) PSSetLeftByItem: (id) item1 ByItem:(id) item2 Lenght:(CGFloat) lenght
{
    NSLayoutConstraint *cn = [NSLayoutConstraint constraintWithItem:item1 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:item2 attribute:NSLayoutAttributeLeft multiplier:1.0 constant:lenght];
    cn.active = YES;
}

-(void)PSUpdateConstraintsHeight:(CGFloat)height
{
    NSArray *constrains = self.constraints;
    for (NSLayoutConstraint* constraint in constrains) {
        if (constraint.firstAttribute == NSLayoutAttributeHeight) {
            constraint.constant = height;
        }
    }

}
-(void)PSUpdateConstraintsWidth:(CGFloat)Width
{
    NSArray *constrains = self.constraints;
    for (NSLayoutConstraint* constraint in constrains) {
        if (constraint.firstAttribute == NSLayoutAttributeWidth) {
            constraint.constant = Width;
        }
    }
    
}





@end
