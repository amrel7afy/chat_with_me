

//check if contact is a user.
/*
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Function to check if any contact is a user in your app
Future<void> checkContactsForAppUsers() async {
  // Fetch authenticated user's phone number
  User? user = FirebaseAuth.instance.currentUser;
  String? userPhoneNumber = user?.phoneNumber;

  // Fetch user's contacts
  Iterable<Contact> contacts = await ContactsService.getContacts();

  // Compare contact phone numbers with registered users in Firebase
  for (var contact in contacts) {
    // Access phone numbers from the contact
    for (var phoneNumber in contact.phones) {
      String contactNumber = phoneNumber.value ?? '';

      // Compare with user phone numbers in Firebase
      QuerySnapshot query = await FirebaseFirestore.instance
          .collection('users')
          .where('phoneNumber', isEqualTo: contactNumber)
          .get();

      if (query.docs.isNotEmpty) {
        // Contact is a user of your app
        print('${contact.displayName} is a user of your app.');
        // Perform actions accordingly
      }
    }
  }
}
*/
