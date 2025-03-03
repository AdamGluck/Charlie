//  SpeechConfig.m
//
// Implements customization parameters for this application's use of
// AT&T Speech SDK.
//
// Customize the functions declared here with the parameters of your application.

#import "SpeechConfig.h"


/** The URL of AT&T Speech API. **/
NSURL* SpeechServiceUrl(void)
{
    return [NSURL URLWithString: @"https://api.att.com/speech/v3/speechToText"];
}

/** The URL of AT&T Text to Speech service. **/
NSURL* TTSUrl(void)
{
    return [NSURL URLWithString: @"https://api.att.com/speech/v3/textToSpeech"];
}

/** The URL of AT&T Speech API OAuth service. **/
NSURL* SpeechOAuthUrl(void)
{
    return [NSURL URLWithString: @"https://api.att.com/oauth/token"];
}
/*
NSString* SpeechOAuthKey(void)
{
    #error Add code to unobfuscate your Speech API credentials, then delete this line.
    return MY_UNOBFUSCATE(my_obfuscated_client_id);
}

NSString* SpeechOAuthSecret(void)
{
    #error Add code to unobfuscate your Speech API credentials, then delete this line.
    return MY_UNOBFUSCATE(my_obfuscated_client_secret);
}
*/
/** The OAuth scope for the Speech API requests. **/
NSString* SpeechOAuthScope(void)
{
    return @"TTS,SPEECH";
}
