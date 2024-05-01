import 'package:chat_with_me/data_layer/models/user_model.dart';

String gradle='./gradlew signingReport';
String SHA1='SHA1: 67:FA:2A:84:73:C3:E6:C8:46:01:5F:64:1C:E3:D1:58:51:72:C7:8C';
String SHA_256='SHA-256: 0C:F6:D7:95:B1:40:F8:FE:68:3C:CA:F6:51:C4:C5:CA:EA:11:6F:17:44:97:6F:36:BD:84:2E:02:B0:6E:FF:F6';
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
const String editProfilePage = '/editProfilePage';
const String placeholder = '/placeholder';


