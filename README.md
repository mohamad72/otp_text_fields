# Fancy OTP text fields

a highly customizable OTP text fields.


# Screen Shots
 | Success Mode                                                                                 | Normal Mode                                                                                  | Customizable                                                                                 | Error Mode                                                                                   |
|----------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------|
| ![Screen1](https://github.com/mohamad72/otp_text_fields/blob/master/screenShots/screen1.jpg) | ![Screen2](https://github.com/mohamad72/otp_text_fields/blob/master/screenShots/screen2.jpg) | ![Screen3](https://github.com/mohamad72/otp_text_fields/blob/master/screenShots/screen3.jpg) | ![Screen4](https://github.com/mohamad72/otp_text_fields/blob/master/screenShots/screen4.jpg) |

| Loading Mode                                                                               | Customizable Loading Mode                                                                  | normal use                                                                                 |
|--------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------|
| ![Video2](https://github.com/mohamad72/otp_text_fields/blob/master/screenShots/Video2.gif) | ![Video1](https://github.com/mohamad72/otp_text_fields/blob/master/screenShots/Video1.gif) | ![Video4](https://github.com/mohamad72/otp_text_fields/blob/master/screenShots/Video4.gif) |

## Code Snippets

simple use:
```
class SimpleUse extends StatefulWidget {  
  const SimpleUse({Key? key}) : super(key: key);  
  
  @override  
 _SimpleUseState createState() => _SimpleUseState();  
}  
  
class _SimpleUseState extends State<SimpleUse> {  
  OtpTextFieldsController otpTextFieldsController = OtpTextFieldsController();  
  
  void changeMode(OtpState otpState) {  
    // changing mode for changing design   
    // modes=> {success,loading,error,normal}  
  otpTextFieldsController.currentState.value = otpState;  
  }  
    
  void changeOtpValues(String otpValue) {  
    // if you have auto fill sms you should use this  
  otpTextFieldsController.otpValue.value = otpValue;  
  }  
  
  @override  
 Widget build(BuildContext context) {  
    return OtpTextFields(  
      otpLength: 5,  
      otpTextFieldsController: otpTextFieldsController,  
      defaultTextStyle: const TextStyle(fontSize: 18, color: Colors.black),  
    );  
  }  
}
```

for use all customizable params:
```
class SimpleUse extends StatefulWidget {  
  const SimpleUse({Key? key}) : super(key: key);  
  
  @override  
 _SimpleUseState createState() => _SimpleUseState();  
}  
  
class _SimpleUseState extends State<SimpleUse> {  
  OtpTextFieldsController otpTextFieldsController = OtpTextFieldsController();  
  
  void changeMode(OtpState otpState) {  
    // changing mode for changing design  
 // modes=> {success,loading,error,normal}  otpTextFieldsController.currentState.value = otpState;  
  }  
  
  void changeOtpValues(String otpValue) {  
    // if you have auto fill sms you should use this  
  otpTextFieldsController.otpValue.value = otpValue;  
  }  
  
  @override  
 Widget build(BuildContext context) {  
    return OtpTextFields(  
      otpLength: 5,  
      otpTextFieldsController: otpTextFieldsController,  
      defaultTextStyle: const TextStyle(fontSize: 18, color: Colors.black),  
      textStyleLoading: defaultTextStyle(context, StyleText.blwd2).s(18),  
      //text style when mode is loading  
  textStyleSuccess: defaultTextStyle(context, StyleText.blwd2).s(18),  
      //text style when mode is loading  
  textStyleError: defaultTextStyle(context, StyleText.blwd2).s(18),  
      //text style when mode is loading  
  textStyleActive: defaultTextStyle(context, StyleText.blwd2).s(18),  
      //text style when mode is Normal and focus is in the box  
  textStyleFilled: defaultTextStyle(context, StyleText.blwd2).s(18),  
      //text style when mode is Normal and focus is in not the box  
  decorationSuccessBox: BoxDecoration(),  
      // container box decoration when mode is success  
  decorationErrorBox: BoxDecoration(),  
      // container box decoration when mode is Error  
  decorationLoadingBox: BoxDecoration(),  
      // container box decoration when mode is Loading  
  decorationActiveBox: BoxDecoration(),  
      // container box decoration when mode is Normal and focus is in not the box  
  decorationFilledBox: BoxDecoration(),  
      // container box decoration when mode is Normal and text is filled  
  decorationEmptyBox: BoxDecoration(), // container box decoration when mode is Normal and text is empty  
  );  
  }  
}
```
and all BoxDecoration params is here:
```
BoxDecoration(  
    color: Colors.white,  //color of box(you can use gradiant instead of simple color)
    shape: BoxShape.rectangle,  //shape of box(rectangle or circle)
    border: Border.all(color: Colors.black, width: 3),//border of box(nullable)
    borderRadius: BorderRadius.all(Radius.circular(5)),  //borderRadiusof box
    boxShadow: [  //shadow of box
         BoxShadow(  
            color: Colors.grey.withOpacity(0.5),  
            spreadRadius: 5,  
            blurRadius: 7,  
            offset: Offset(3, 3),  
         )  
    ],   
  ),
```

when you fill otp with code in here one animate will be shown like that:
```
otpTextFieldsController.otpValue.value = otpValue;  
```

![Video3](https://github.com/mohamad72/otp_text_fields/blob/master/screenShots/video3.gif)
