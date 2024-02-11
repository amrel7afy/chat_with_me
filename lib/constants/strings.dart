import 'package:chat_app/data_layer/models/user_model.dart';

String gradle='./gradlew signingReport';
String SHA1='SHA1: A2:02:06:52:CE:D2:00:EB:6A:45:7F:62:37:65:DC:C2:14:7A:C0:EC';
String SHA_256='SHA-256: 42:F9:76:4E:26:BC:BB:2C:00:C4:1F:91:C7:CA:98:D6:CE:A4:FD:17:BA:61:D6:D3:55:41:1C:57:E8:D7:E1:1C';
String fakeModel = '{"name":"fake name","uid":"fake id","email":"fake email","phoneNumber":"fake phone","bio":"fake bio","profilePic":""}';
String isOnBoardingKey='isOnBoarding';
String isSignedInKey='is_signedIn';
String isRecieverChatDataIsAddedKey='isRecieverChatDataIsAddedKey';
String userModelKey='userModelKey';
String matchedContactsUsersKey='matchedContactsUsersKey';
String kUserCollection='users';
String kChatsCollection='chats';
String kMessagesCollection='messages';
String uId='';

UserModel userModel=UserModel(email: 'email', userId: '', name: 'default name', bio: 'bio', phoneNumber: 'phoneNumber', profilePic: 'profilePic');




//--------------- Routing -----------------
const String splash = '/splash';
const String onBoardingPage = '/onBoarding';
const String logInPage = '/logInPage';
const String otpPage = '/otpPage';
const String contactsPage = '/contactsPage';
const String informationPage = '/informationPage';
const String messagingPage = '/messagingPage';
const String allChatsPage = '/allChatsPage';


