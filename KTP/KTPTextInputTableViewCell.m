//
//  KTPTextInputTableViewCell.m
//  KTP
//
//  Created by Owen Yang on 2/25/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "KTPTextInputTableViewCell.h"
#import "KTPTextView.h"

@interface KTPTextInputTableViewCell() <UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) KTPTextView *textView;

@end

@implementation KTPTextInputTableViewCell

#pragma mark - Initialization

- (instancetype)init {
    return [self initWithText:nil placeholder:nil isTextField:YES];
}

- (instancetype)initWithText:(NSString*)text placeholder:(NSString*)placeholder isTextField:(BOOL)isTextField {
    self = [super init];
    if (self) {
        self.textField = [UITextField new];
        self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.textView = [KTPTextView new];
        self.textView.frame = CGRectMake(0, 0, 1, 1);
        self.textField.font = self.textView.font = [UIFont systemFontOfSize:[UIFont labelFontSize]];
        
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneBarButtonTapped)];
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIToolbar *inputAccessoryBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [[[UIApplication sharedApplication] delegate] window].frame.size.width, 44)];
        inputAccessoryBar.items = @[flexSpace, doneButton];
        inputAccessoryBar.translucent = NO;
        inputAccessoryBar.barTintColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:248/255.0 alpha:1]; // change from hardcoded value
        self.textField.inputAccessoryView = inputAccessoryBar;
        self.textView.inputAccessoryView = inputAccessoryBar;
        
        [self.contentView addSubview:self.textField];
        [self.contentView addSubview:self.textView];
        
        self.inputType = KTPInputTypeString;
        
        self.text = text;
        self.placeholder = placeholder;
        self.isTextField = isTextField;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:self.textField];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:self.textView];
        
        [self autoLayoutSubviews];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Overridden setters/getters

- (void)setIsTextField:(BOOL)isTextField {
    _isTextField = isTextField;
    self.textField.hidden = !isTextField;
    self.textView.hidden = isTextField;
}

- (void)setText:(NSString*)text {
    if (_text != text) {
        _text = text;
        
        self.textField.text = text;
        self.textView.text = text;
    }
}

- (void)setPlaceholder:(NSString*)placeholder {
    if (_placeholder != placeholder) {
        _placeholder = placeholder;
        
        self.textField.placeholder = placeholder;
        self.textView.placeholder = placeholder;
    }
}

- (void)setInputType:(KTPInputType)inputType {
    _inputType = inputType;
    
    self.textField.userInteractionEnabled = YES;
    self.textView.userInteractionEnabled = YES;
    
    switch (inputType) {
        case KTPInputTypeString:
            self.textField.keyboardType = UIKeyboardTypeDefault;
            break;
        case KTPInputTypeInteger:
            self.textField.keyboardType = UIKeyboardTypeNumberPad;
            break;
        case KTPInputTypeDecimal:
            self.textField.keyboardType = UIKeyboardTypeDecimalPad;
            break;
        case KTPInputTypeSelect:
            self.textField.userInteractionEnabled = NO;
            self.textView.userInteractionEnabled = NO;
            break;
    }
}

#pragma mark - Loading subviews

- (void)autoLayoutSubviews {
    self.textField.translatesAutoresizingMaskIntoConstraints = NO;
    self.textView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *views = @{
                            @"textField"    :   self.textField,
                            @"textView"     :   self.textView
                            };
    NSDictionary *metrics = @{
                              @"separatorInsetLeft" : [NSNumber numberWithFloat:self.separatorInset.left]
                              };
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-separatorInsetLeft-[textField]-5-|" options:0 metrics:metrics views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-separatorInsetLeft-[textView]-5-|" options:0 metrics:metrics views:views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[textField]-0-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[textView]-0-|" options:0 metrics:nil views:views]];
}

#pragma mark - UI action selectors

- (void)doneBarButtonTapped {
    [self.textField endEditing:YES];
    [self.textView endEditing:YES];
}

#pragma mark - Notification Handling

- (void)textDidChange:(NSNotification*)notification {
    self.text = [notification.object text];
}

@end
