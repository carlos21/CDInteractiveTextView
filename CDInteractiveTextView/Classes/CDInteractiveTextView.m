//
//  CDInteractiveTextView.m
//  Pods
//
//  Created by Carlos Duclos on 7/20/17.
//
//

#import "CDInteractiveTextView.h"
#import "CDInteractiveItem.h"

@interface CDInteractiveTextView()

@property (nonatomic, strong) NSMutableArray *interactiveItems;
@property (nonatomic, strong) CDInteractiveItem *currentItem;
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, strong) NSAttributedString *backupAttributedText;

@end

@implementation CDInteractiveTextView

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])){
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self setup];
    }
    return self;
}

#pragma mark - Custom accessors

- (void)setTextColor:(UIColor *)textColor {
    [super setTextColor:textColor];
    
    NSMutableAttributedString *attributedString = self.attributedText.mutableCopy;
    [attributedString removeAttribute:NSForegroundColorAttributeName range:NSMakeRange(0, self.text.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, self.text.length)];
    
    for (CDInteractiveItem * item in self.interactiveItems){
        [attributedString addAttribute:NSForegroundColorAttributeName value:self.interactiveColor range:item.range];
    }
    
    self.attributedText = attributedString;
}

#pragma mark - Actions

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.currentItem = nil;
    self.backupAttributedText = self.attributedText;
    
    for (UITouch *touch in touches) {
        CGPoint touchPoint = [touch locationInView:self];
        CDInteractiveItem * tapItem = [self getItemForPoint:touchPoint];
        if (tapItem) {
            
            NSRange range = tapItem.range;
            self.currentItem = tapItem;
            [self highliteTappedAreaInRange:range];
            return;
        }
    }
    
    [self.nextResponder touchesBegan:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.currentItem = nil;
    self.attributedText = self.backupAttributedText;
    [self.nextResponder touchesCancelled:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    self.attributedText = self.backupAttributedText;
    
    for (UITouch *touch in touches) {
        CGPoint touchPoint = [touch locationInView:self];
        CDInteractiveItem * tapItem = [self getItemForPoint:touchPoint];
        if ( tapItem && self.currentItem && tapItem == self.currentItem) {
            if (tapItem.tapActionBlock){
                tapItem.tapActionBlock();
            }
        }
    }
    
    [self.nextResponder touchesEnded:touches withEvent:event];
}

#pragma mark - Private

- (void)setup {
    self.editable = NO;
    self.selectable = NO;
    self.scrollEnabled = NO;
    self.multipleTouchEnabled = NO;
    self.textContainerInset = UIEdgeInsetsZero;
    self.textContainer.lineFragmentPadding = 0;
    
    self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:nil];
    self.panRecognizer.cancelsTouchesInView = NO;
    self.panRecognizer.delegate = self;
    [self addGestureRecognizer:self.panRecognizer];
    
    self.interactiveColor = [UIColor blueColor];
}

- (void)highliteTappedAreaInRange:(NSRange)range {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    [attributedString addAttribute:NSForegroundColorAttributeName value:self.interactiveHighlightedColor range:range];
    self.attributedText = attributedString;
}

- (CDInteractiveItem *)getItemForPoint:(CGPoint) point {
    NSLayoutManager *layoutManager = self.layoutManager;
    NSUInteger characterIndex = [layoutManager characterIndexForPoint:point inTextContainer:self.textContainer fractionOfDistanceBetweenInsertionPoints:NULL];
    
    NSUInteger glyphIndex = [layoutManager glyphIndexForCharacterAtIndex:characterIndex];
    CGRect rectOfGlyph = [layoutManager boundingRectForGlyphRange:NSMakeRange(glyphIndex, 1) inTextContainer:layoutManager.textContainers[0]];
    BOOL contains = CGRectContainsPoint(rectOfGlyph, point);
    
    if (characterIndex < self.textStorage.length && contains) {
        for (CDInteractiveItem * item in self.interactiveItems){
            if (NSLocationInRange(characterIndex, item.range)){
                return item;
            }
        }
    }
    
    return nil;
}

#pragma mark - Public

- (void)addTapActionWithText:(NSString *)text withActionBlock:(void (^)())actionBlock {
    NSRange range = [self.text rangeOfString:text];
    [self addTapActionWithRange:range withActionBlock:actionBlock];
}

- (void)addTapActionWithRange:(NSRange)range withActionBlock:(void (^)())actionBlock {
    if (!self.interactiveItems) {
        self.interactiveItems = [NSMutableArray array];
    }
    
    NSMutableAttributedString * attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    [attributedText addAttribute:NSForegroundColorAttributeName value:self.interactiveColor range:range];
    [attributedText addAttribute:NSUnderlineStyleAttributeName value:@(1) range:range];
    self.attributedText = attributedText;
    
    CDInteractiveItem *item = [[CDInteractiveItem alloc] init];
    item.tapActionBlock = actionBlock;
    item.range = range;
    [self.interactiveItems addObject:item];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (gestureRecognizer == self.panRecognizer) {
        CGPoint point = [gestureRecognizer locationInView:self];
        CDInteractiveItem *tapItem = [self getItemForPoint:point];
        
        if (tapItem) {
            return NO;
        }
    }
    return YES;
}

@end
