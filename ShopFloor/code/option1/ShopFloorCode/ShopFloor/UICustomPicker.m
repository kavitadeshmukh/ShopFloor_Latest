//
//  UICustomPicker.m
//

#import "UICustomPicker.h"

#define Separator @"--------------------"
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_iPHONE_5 ([[UIScreen mainScreen] bounds].size.height == 568)
#define IS_IPHONE_6 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0)
#define IS_IPHONE_6_PLUS (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 736.0)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@implementation UICustomPicker
@synthesize delegate;

-(void)initWithCustomPicker:(CGRect)rect inView:(id)AddView ContentSize:(CGSize)ContentSize pickerSize:(CGRect)pickerRect barStyle:(UIBarStyle)barStyle Recevier:(id)Receiver componentArray:(NSArray *)componentArray  toolBartitle:(NSString*)toolBartitle textColor:(UIColor*)textColor needToSort:(BOOL)needToSort withDictKey:(NSString *) dictKey
{
    
    [self initWithCustomPicker:rect inView:AddView ContentSize:ContentSize pickerSize:pickerRect barStyle:barStyle Recevier:Receiver componentArray:(NSMutableArray*)componentArray toolBartitle:toolBartitle textColor:textColor needToSort:needToSort needMultiSelection:NO withDictKey:dictKey];
}


-(void)initWithCustomPicker:(CGRect)rect inView:(id)AddView ContentSize:(CGSize)ContentSize pickerSize:(CGRect)pickerRect barStyle:(UIBarStyle)barStyle Recevier:(id)Receiver componentArray:(NSMutableArray *)componentArray toolBartitle:(NSString*)toolBartitle textColor:(UIColor*)textColor needToSort:(BOOL)needToSort needMultiSelection:(BOOL)needMultiSelection withDictKey:(NSString *) dictKey
{


    senders=Receiver;
    self.isPresentedOnView = YES;
    rowDictKey=dictKey;
    
    self.arPreMultiRecords = [NSMutableArray arrayWithArray:self.arMultiRecords];
    self.preSelectionString = self.selectionString;
    self.needMultiSelection = needMultiSelection;
    target=AddView;
    
    if (![componentArray count])
    {
        return;
    }
    
    
	pickerValue=@"";
	if ([senders isKindOfClass:[UILabel class]])
    {
		tempLable=(UILabel *)senders;
        preValue=[[NSString alloc] initWithFormat:@"%@",tempLable.text];
	}
	else if ([senders isKindOfClass:[UITextField class]])
    {
		tempText=(UITextField*)senders;
		preValue=[[NSString alloc] initWithFormat:@"%@",tempText.text];
	}
	else if ([senders isKindOfClass:[UIButton class]])
	{
		button_Temp = (UIButton *)senders;
		preValue = button_Temp.titleLabel.text ;
	}
    if (needToSort)
    {
        keyArray = [[NSMutableArray alloc] initWithArray:[componentArray sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]];
    }
    else
    {
        keyArray = [[NSMutableArray alloc] initWithArray:[componentArray mutableCopy]];
    }
    
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
		UIView *popoverView = [[UIView alloc] init];
		CGRect ToolRect=CGRectMake(0, 0,pickerRect.size.width, 44);
        float osVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
        if (osVersion >= 7.0){
            popoverView.backgroundColor = [UIColor whiteColor];
        }
        else{
            popoverView.backgroundColor = [UIColor whiteColor];
        }
        // [self.objCustomPicker selectRow:self.currentID  inComponent:0 animated:YES];
        
		
		UIViewController* popoverContent = [[UIViewController alloc] init];
		[popoverView addSubview:[self createToolBar:ToolRect BarStyle:barStyle toolBarTitle:toolBartitle textColor:textColor]];
		[popoverView addSubview:[self createPicker:CGRectMake(0, 44, pickerRect.size.width,pickerRect.size.height)]];
		popoverContent.view = popoverView;
        
		popoverView=nil;
		popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
		popoverController.delegate=self;
        
    
		popoverContent=nil;
        UIButton *btnTarget =(UIButton *)Receiver;
		[popoverController setPopoverContentSize:ContentSize animated:NO];
		[popoverController presentPopoverFromRect:rect inView:AddView permittedArrowDirections:(btnTarget.tag==12)?UIPopoverArrowDirectionUp:UIPopoverArrowDirectionAny animated:YES];
	}
    else
    {
        CGRect ToolRect;
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
        {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"IS_PICKER_ON_TOP_OF_WINDOW"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            UIView *masterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 260)];
            
            if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation==UIInterfaceOrientationPortraitUpsideDown)
            {
                masterView.frame = CGRectMake(0, 0, self.view.frame.size.width, 260);
                ToolRect=CGRectMake(rect.origin.x,0,self.view.frame.size.width, 44);

            }else
            {
                ToolRect=CGRectMake(rect.origin.x,0,IS_iPHONE_5?568:480, 32);
                masterView.frame = CGRectMake(0, 0, IS_iPHONE_5?568:480, 190);
                
                if (IS_IPHONE_6) {
                    ToolRect=CGRectMake(rect.origin.x,0,667, 32);
                    masterView.frame = CGRectMake(0, 0, 667, 190);
                }
                else if(IS_IPHONE_6_PLUS){
                    ToolRect=CGRectMake(rect.origin.x,0,736, 32);
                    masterView.frame = CGRectMake(0, 0, 736, 190);
                }
            }
            
            
            self.toolbar=[self createToolBar:ToolRect BarStyle:barStyle toolBarTitle:toolBartitle textColor:textColor];
            [masterView addSubview:self.toolbar];
            
            if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation==UIInterfaceOrientationPortraitUpsideDown)
            {
                [masterView addSubview:[self createPicker:CGRectMake(pickerRect.origin.x, 44, pickerRect.size.width,216)]];
            }else
            {
                
                if (IS_IPHONE_6) {
                    [masterView addSubview:[self createPicker:CGRectMake(pickerRect.origin.x, 32,667,160)]];

                }
                else if(IS_IPHONE_6_PLUS){
                    [masterView addSubview:[self createPicker:CGRectMake(pickerRect.origin.x, 32,736,160)]];

                }
                else{
                    [masterView addSubview:[self createPicker:CGRectMake(pickerRect.origin.x, 32,IS_iPHONE_5?568:480,160)]];

                }
            }
            
            
            self._actionSheetForIOS8 = [[SWActionSheet alloc] initWithView:masterView];
            
            [self._actionSheetForIOS8 showInContainerView];

        }
        else{
            CGRect ToolRect;
            self.actionSheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
            if ([AddView isKindOfClass:[UITabBarController class]])
            {
                UITabBarController *tabbarController=(UITabBarController*)AddView;
                [self.actionSheet showInView:tabbarController.tabBar];
                if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation==UIInterfaceOrientationPortraitUpsideDown)
                {
                    [self.actionSheet setFrame:CGRectMake(rect.origin.x,IS_iPHONE_5?310:222, rect.size.width,260)];
                    ToolRect=CGRectMake(rect.origin.x,0,self.view.frame.size.width, 44);
                }
                else
                {
                    [self.actionSheet setFrame:CGRectMake(rect.origin.x, 130, IS_iPHONE_5?568:480,350)];
                    ToolRect=CGRectMake(rect.origin.x,0,IS_iPHONE_5?568:480, 32);
                }
            }
            else
            {
                if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation==UIInterfaceOrientationPortraitUpsideDown)
                {
                    ToolRect=CGRectMake(rect.origin.x,0,self.view.frame.size.width, 44);
                    [self.actionSheet showInView:AddView];
                    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
                        [self.actionSheet setFrame:CGRectMake(rect.origin.x, [AddView frame].size.height-236, self.view.frame.size.width,240)];
                    else
                        [self.actionSheet setFrame:CGRectMake(rect.origin.x, [AddView frame].size.height-256, self.view.frame.size.width,240)];
                }else
                {
                    ToolRect=CGRectMake(rect.origin.x,0,IS_iPHONE_5?568:480, 32);
                    [self.actionSheet showInView:AddView];
                    [self.actionSheet setFrame:CGRectMake(rect.origin.x, [AddView frame].size.height-190, [AddView frame].size.width,190)];
                }
            }
            self.actionSheet.backgroundColor=[UIColor whiteColor];
            self.toolbar=[self createToolBar:ToolRect BarStyle:barStyle toolBarTitle:toolBartitle textColor:textColor];
            [self.actionSheet addSubview:self.toolbar];
            
            if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation==UIInterfaceOrientationPortraitUpsideDown)
            {
                [self.actionSheet addSubview:[self createPicker:CGRectMake(pickerRect.origin.x, 44, pickerRect.size.width,216)]];
            }else
            {
                [self.actionSheet addSubview:[self createPicker:CGRectMake(pickerRect.origin.x, 32,IS_iPHONE_5?568:480,190)]];
            }
        }
	}
}
-(void)btnViewCustomClicked:(id)sender
{
    if ([(NSObject *)self.delegate respondsToSelector:@selector(btnViewCustomClicked:)])
    {
        [delegate btnViewCustomClicked:nil];
        [self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    }
}

-(UIPickerView*)createPicker:(CGRect)rect
{
	pickerView=[[UIPickerView alloc] initWithFrame:rect];
	pickerView.delegate  = self;
	pickerView.dataSource = self;
	NSInteger x=0;
	pickerView.showsSelectionIndicator = YES;
	if ([preValue length] > 0)
	{
        if ([[keyArray objectAtIndex:0] isKindOfClass:[NSString class]])
        {
            if ([keyArray  containsObject:preValue])
                x = [keyArray  indexOfObject:preValue];
            [pickerView selectRow:x inComponent:0 animated:YES];
        }
        else if([[keyArray objectAtIndex:0] isKindOfClass:[NSDictionary class]]){
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.%@ = %@",rowDictKey,preValue];
            NSMutableArray *predarr = [NSMutableArray arrayWithArray:[keyArray filteredArrayUsingPredicate:predicate]];
            if (predarr!=nil && predarr.count!=0) {
                if ([keyArray  containsObject:[predarr objectAtIndex:0]])
                    x = [keyArray  indexOfObject:[predarr objectAtIndex:0]];
            }
            [pickerView selectRow:x inComponent:0 animated:YES];
        }
	}
	return pickerView;
}
-(UIToolbar*)createToolBar:(CGRect)rect BarStyle:(UIBarStyle)BarStyle toolBarTitle:(NSString*)toolBarTitle textColor:(UIColor*)textColor
{
    if (UIDeviceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation))
    {
        rect=CGRectMake(0, 0, rect.size.width, 44);
    }else
    {
        rect=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, 32);
    }
    UIToolbar *pickerToolbar=[[UIToolbar alloc] initWithFrame:rect];
    pickerToolbar.barStyle = BarStyle;
    pickerToolbar.tintColor = [UIColor grayColor];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        pickerToolbar.barTintColor   = [UIColor colorWithRed:255/255.0 green:102/255.0 blue:0/255.0 alpha:1];
        [pickerToolbar setTintColor:[UIColor whiteColor]];
    }
    else
    {
        pickerToolbar.tintColor   = [UIColor whiteColor];
    }

    pickerToolbar.opaque=YES;
    pickerToolbar.translucent=NO;
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        [pickerToolbar setItems:[self toolbarItem] animated:YES];
    }
    else
    {
//        [pickerToolbar setItems:[self toolbarItems] animated:YES];
    }
    if ([toolBarTitle length]!=0)
    {
        [pickerToolbar addSubview:[self createTitleLabel:toolBarTitle labelTextColor:textColor width:(rect.size.width-200)]];
    }
    return pickerToolbar;
}

#pragma mark - UIPickerView delegate methods
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	if ([keyArray count] > 0)
	{
		if ([[keyArray objectAtIndex:0] isKindOfClass:[NSString class]])
		{
			return [keyArray count];
		}
        else{
            return [keyArray count];
        }
	}
	return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	if ([keyArray count] > 0)
	{
		if ([[keyArray objectAtIndex:0] isKindOfClass:[NSString class]])
		{
			return [keyArray objectAtIndex:row];
		}
        else{
            if ([rowDictKey isEqualToString:@"modetype"]) {
                return [[keyArray  objectAtIndex:row] valueForKey:@"name"];
            }
            else if ([rowDictKey isEqualToString:@"Location"]) {    
                return [[keyArray  objectAtIndex:row] valueForKey:@"addresss"];
            }
            else{
                NSString *str = [[keyArray  objectAtIndex:row] valueForKey:rowDictKey];
                str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                str = [str stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                str = [str stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
                return str;
            }
            
        }
	}
	return @"";
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.text = [keyArray objectAtIndex:row];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        lbl.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:21];
    }
    else
    {
        lbl.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:14];

    }

    return lbl;
}
-(void) pickerView:(UIPickerView *)pickerVies didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	NSString  *pickerLocalValue=@"";
    if ([pickerView numberOfComponents]>1)
    {
        for(int i=0;i<[pickerView numberOfComponents];i++)
        {
            if ([[keyArray objectAtIndex:0] isKindOfClass:[NSString class]])
            {
                pickerLocalValue=[pickerLocalValue stringByAppendingFormat:@"%@",[keyArray objectAtIndex:[pickerView selectedRowInComponent:0]]];
            }
            else{
                if ([rowDictKey isEqualToString:@"modetype"]) {
                    pickerLocalValue=[pickerLocalValue stringByAppendingFormat:@"%@",[[keyArray objectAtIndex:[pickerView selectedRowInComponent:0]] valueForKey:@"name"]];
                }
                else if ([rowDictKey isEqualToString:@"Location"]) {
                    pickerLocalValue=[pickerLocalValue stringByAppendingFormat:@"%@",[[keyArray objectAtIndex:[pickerView selectedRowInComponent:0]] valueForKey:@"addresss"]];
                }
                else{
                    pickerLocalValue=[pickerLocalValue stringByAppendingFormat:@"%@",[[keyArray objectAtIndex:[pickerView selectedRowInComponent:0]] valueForKey:rowDictKey]];
                }
            }
        }
    }
    else {
        if ([[keyArray objectAtIndex:0] isKindOfClass:[NSString class]]) {
            pickerLocalValue=[pickerLocalValue stringByAppendingFormat:@"%@",[keyArray objectAtIndex:[pickerView selectedRowInComponent:0]]];
        }
        else{
            if ([rowDictKey isEqualToString:@"modetype"]) {
                pickerLocalValue=[pickerLocalValue stringByAppendingFormat:@"%@",[[keyArray objectAtIndex:[pickerView selectedRowInComponent:0]] valueForKey:@"name"]];
                
            }
            else if ([rowDictKey isEqualToString:@"Location"]) {
                pickerLocalValue=[pickerLocalValue stringByAppendingFormat:@"%@",[[keyArray objectAtIndex:[pickerView selectedRowInComponent:0]] valueForKey:@"addresss"]];
            }
            else{
                pickerLocalValue=[pickerLocalValue stringByAppendingFormat:@"%@",[[keyArray objectAtIndex:[pickerView selectedRowInComponent:0]] valueForKey:rowDictKey]];
            }
        }
    }
	pickerValue = pickerLocalValue;
	[self callSenders:pickerValue];
}

-(IBAction)done_clicked:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"IS_PICKER_ON_TOP_OF_WINDOW"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0") && UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
        [self._actionSheetForIOS8 dismissWithClickedButtonIndex:0 animated:YES];
    }
    
    
    [self.arPreMultiRecords removeAllObjects];
    [self.arPreMultiRecords addObjectsFromArray:self.arMultiRecords];
    //    if ([pickerValue length] == 0)
    //    {
    if ([keyArray count] > 0)
    {
        if ([[keyArray objectAtIndex:0] isKindOfClass:[NSString class]])
        {
            pickerValue = [keyArray objectAtIndex:[pickerView selectedRowInComponent:0]];
        }
        else{
            if([rowDictKey isEqualToString:@"modetype"])
            {
                pickerValue=[[keyArray objectAtIndex:[pickerView selectedRowInComponent:0]] valueForKey:@"name"];
                
            }
            else if([rowDictKey isEqualToString:@"Location"]){
                pickerValue=[[keyArray objectAtIndex:[pickerView selectedRowInComponent:0]] valueForKey:@"addresss"];
            }
            else{
                NSString *str = [[keyArray objectAtIndex:[pickerView selectedRowInComponent:0]] valueForKey:rowDictKey];
                str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                str = [str stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                str = [str stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
                pickerValue=str;
            }
        }
    }
    //    }
    
    if ([(NSObject *)self.delegate respondsToSelector:@selector(pickerDoneClicked: withType:)])
    {
        [delegate pickerDoneClicked:pickerValue withType:rowDictKey];
    }
    if ([(NSObject *)self.delegate respondsToSelector:@selector(picker:andDoneClicked:andIndex:)])
    {
        [self.delegate picker:self andDoneClicked:pickerValue andIndex:[pickerView selectedRowInComponent:0]];
    }
    if(!self.needMultiSelection)
    {
        [self callSenders:pickerValue];
    }
    if ([(NSObject *)self.delegate respondsToSelector:@selector(adjustScrolling)])
    {
        [delegate adjustScrolling];
    }
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
		[popoverController dismissPopoverAnimated:YES];
	}
    else
    {
		[self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
	}
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
	[self callSenders:preValue];
}

-(UILabel*)createTitleLabel:(NSString*)labelTitle labelTextColor:(UIColor*)color width:(NSInteger)width
{
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait ||
        [UIApplication sharedApplication].statusBarOrientation==UIInterfaceOrientationPortraitUpsideDown)
    {
        lheight = 36;
        lWidth = 4;
    }
    else
    {
        lWidth = 2;
        lheight = 28;
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(110,lWidth,width,lheight)];

    }
    else {
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(110,lWidth,width,lheight)];

    }
    self.label.backgroundColor = [UIColor clearColor];
    float osVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        if (osVersion >= 7.0){
            self.label.textColor = color;
            self.label.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:21];
            
        }
        [self.label setAdjustsFontSizeToFitWidth:YES];
    }
    else{
        self.label.textColor = color;
        self.label.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:15];
    }
    
	
	self.label.text = labelTitle;

    if(!self.PickerName)
    {
        self.PickerName = labelTitle;
    }
    self.label.numberOfLines=0;
	self.label.textAlignment = NSTextAlignmentCenter;
	return self.label ;
}

-(void)callSenders:(NSString*)pickerString
{
    if ([senders isKindOfClass:[UILabel class]])
    {
		tempLable=(UILabel *)senders;
		tempLable.text=pickerString;
		//senders=(UILabel*)senders;
	}
	else if ([senders isKindOfClass:[UITextField class]])
    {
		tempText=(UITextField *)senders;
        if ([pickerString isEqualToString:@"(null)"])
        {
            tempText.text=@"";
        }else
        {
            NSString *str = pickerString;
            str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            str = [str stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            str = [str stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            tempText.text=str;
        }
        //		tempText.text=pickerString;
		senders=(UITextField*)senders;
	}
	else if ([senders isKindOfClass:[UIButton class]])
	{
		button_Temp = (UIButton *)senders;
		[button_Temp setTitle:pickerString forState:UIControlStateNormal];
        [button_Temp setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

		//senders = (UIButton *)senders;
	}
    if ([(NSObject *)self.delegate respondsToSelector:@selector(CustomPickerValue:)])
    {
        [delegate CustomPickerValue:senders];
    }
    
}
-(IBAction)cancel_clicked:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"IS_PICKER_ON_TOP_OF_WINDOW"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0") && UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
        [self._actionSheetForIOS8 dismissWithClickedButtonIndex:0 animated:YES];
    }
    
    self.selectionString = self.preSelectionString;
    [self.arMultiRecords removeAllObjects];
    [self.arMultiRecords addObjectsFromArray:self.arPreMultiRecords];
	[self callSenders:preValue];
    if ([(NSObject *)self.delegate respondsToSelector:@selector(adjustScrolling)])
    {
        [delegate adjustScrolling];
    }
    if ([(NSObject *)self.delegate respondsToSelector:@selector(pickerCancelClicked: withType:)])
    {
        [self.delegate pickerCancelClicked:preValue withType:rowDictKey];
    }
    if ([(NSObject *)self.delegate respondsToSelector:@selector(picker:andCancelClicked:)])
    {
        [self.delegate picker:self andCancelClicked:preValue];
    }
    
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
		[popoverController dismissPopoverAnimated:YES];
	}
    else
    {
		[self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
	}
}

-(NSMutableArray*)toolbarItem
{
	NSMutableArray *barItems = [[NSMutableArray alloc] init];
//	UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel_clicked:)];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(done_clicked:)];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
//        [cancelBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                           [UIFont fontWithName:@"HelveticaNeue-Medium" size:21.0], NSFontAttributeName,
//                                           [UIColor whiteColor], NSForegroundColorAttributeName,
//                                           nil]  forState:UIControlStateNormal];
        [doneBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                         [UIFont fontWithName:@"HelveticaNeue-Medium" size:21.0], NSFontAttributeName,
                                         [UIColor whiteColor], NSForegroundColorAttributeName,
                                         nil]  forState:UIControlStateNormal];
    }
    else
    {
//        [cancelBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                           [UIFont fontWithName:@"HelveticaNeue-Medium" size:15.0], NSFontAttributeName,
//                                           [UIColor whiteColor], NSForegroundColorAttributeName,
//                                           nil]  forState:UIControlStateNormal];
        [doneBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                         [UIFont fontWithName:@"HelveticaNeue-Medium" size:15.0], NSFontAttributeName,
                                         [UIColor whiteColor], NSForegroundColorAttributeName,
                                         nil]  forState:UIControlStateNormal];
    }
    
    	//[barItems addObject:cancelBtn];
	[barItems addObject:flexSpace];
  

	[barItems addObject:doneBtn];
    
	return barItems ;
}

-(void)picker:(UICustomPicker *)picker andDoneClicked:(NSString*)doneValue andIndex:(NSInteger)index{
    
}
-(void)picker:(UICustomPicker *)picker andCancelClicked:(NSString*)preValue{
    
}
@end
