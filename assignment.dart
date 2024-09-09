import 'dart:io';
import 'dart:math';

// Class to hold committee details and manage members
class Committee {
  String id;
  String password;
  String name;
  double price;
  int requiredMembers;
  List<Member> members;
  DateTime scheduleDate;

  Committee(this.id, this.password, this.name, this.price, this.requiredMembers, this.scheduleDate) : members = [];

  @override
  String toString() {
    return 'Committee ID: $id\nCommittee Password: $password\nCommittee Name: $name\nPrice: \$$price\nRequired Members: $requiredMembers\nSchedule Date: $scheduleDate';
  }

  void addMember(Member member) {
    if (members.length < requiredMembers) {
      members.add(member);
      print('${member.name} added to $name committee.');
    } else {
      print('Cannot add more members. Committee is full.');
    }
  }

  void removeMember(String memberName) {
    members.removeWhere((member) => member.name == memberName);
    print('$memberName removed from $name committee.');
  }

  void updateMember(String oldName, {String? newName, String? newPhoneNumber, String? newEmail}) {
    final member = members.firstWhere((member) => member.name == oldName, orElse: () => throw Exception('Member not found'));
    if (newName != null) member.name = newName;
    if (newPhoneNumber != null) member.phoneNumber = newPhoneNumber;
    if (newEmail != null) member.email = newEmail;
    print('$oldName updated in $name committee.');
  }

  void viewMembers() {
    if (members.isEmpty) {
      print('No members in $name committee.');
    } else {
      print('Members of $name committee:');
      for (var member in members) {
        print(member);
      }
    }
  }

  void drawMember() {
    if (members.isEmpty) {
      print('No members to draw from.');
    } else {
      final random = Random();
      final selectedMember = members[random.nextInt(members.length)];
      print('Selected Member: $selectedMember');
    }
  }

  int get membersLeftToJoin => requiredMembers - members.length;
  int get membersJoined => members.length;
}

// Class to hold member details
class Member {
  String name;
  String phoneNumber;
  String email;

  Member(this.name, this.phoneNumber, this.email);

  @override
  String toString() => 'Name: $name, Phone: $phoneNumber, Email: $email';
}

// Class to manage users
class User {
  String id;
  String password;
  User(this.id, this.password);
}

// Global list to hold users and committees
List<User> users = [];
List<Committee> committees = [];

// Function to generate a unique ID for the committee
String generateUniqueId() {
  final random = Random();
  return 'ID${random.nextInt(10000).toString().padLeft(4, '0')}';
}

// Function to generate a unique password for the committee
String generatePassword() {
  final random = Random();
  const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  return List.generate(8, (index) => chars[random.nextInt(chars.length)]).join();
}

// Function to create a new committee
void createCommittee() {
  stdout.write('Enter Committee Name: ');
  String? committeeName = stdin.readLineSync();

  stdout.write('Enter Committee Price: ');
  double? committeePrice = double.tryParse(stdin.readLineSync()!);

  stdout.write('Enter Required Number of Members: ');
  int? requiredMembers = int.tryParse(stdin.readLineSync()!);

  stdout.write('Enter Schedule Date (yyyy-mm-dd): ');
  DateTime? scheduleDate = DateTime.tryParse(stdin.readLineSync()!);

  if (committeeName != null && committeePrice != null && requiredMembers != null && scheduleDate != null) {
    String uniqueId = generateUniqueId();
    String password = generatePassword();

    Committee committee = Committee(uniqueId, password, committeeName, committeePrice, requiredMembers, scheduleDate);
    committees.add(committee);
    print('\nCommittee Created Successfully!');
    print(committee);  // Print the committee details

    // Example of how to use the committee object
    manageMembers(committee);
  } else {
    print('Invalid input. Please try again.');
  }
}

// Function to manage members of a committee
void manageMembers(Committee committee) {
  while (true) {
    stdout.write('\nOptions:\n1. Add Member\n2. Remove Member\n3. Update Member\n4. View Members\n5. Draw/Select a Member\n6. Exit\nChoose an option: ');
    String? choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        stdout.write('Enter Member Name: ');
        String? name = stdin.readLineSync();
        stdout.write('Enter Member Phone Number: ');
        String? phoneNumber = stdin.readLineSync();
        stdout.write('Enter Member Email: ');
        String? email = stdin.readLineSync();

        if (name != null && phoneNumber != null && email != null) {
          var member = Member(name, phoneNumber, email);
          committee.addMember(member);
        } else {
          print('Invalid input. Please try again.');
        }
        break;

      case '2':
        stdout.write('Enter Member Name to Remove: ');
        String? removeName = stdin.readLineSync();
        if (removeName != null) {
          committee.removeMember(removeName);
        } else {
          print('Invalid input. Please try again.');
        }
        break;

      case '3':
        stdout.write('Enter Member Name to Update: ');
        String? oldName = stdin.readLineSync();

        stdout.write('Enter New Member Name (leave empty to keep current): ');
        String? newName = stdin.readLineSync();

        stdout.write('Enter New Member Phone Number (leave empty to keep current): ');
        String? newPhoneNumber = stdin.readLineSync();

        stdout.write('Enter New Member Email (leave empty to keep current): ');
        String? newEmail = stdin.readLineSync();

        if (oldName != null) {
          committee.updateMember(oldName, newName: newName?.isNotEmpty == true ? newName : null, newPhoneNumber: newPhoneNumber?.isNotEmpty == true ? newPhoneNumber : null, newEmail: newEmail?.isNotEmpty == true ? newEmail : null);
        } else {
          print('Invalid input. Please try again.');
        }
        break;

      case '4':
        committee.viewMembers();
        break;

      case '5':
        committee.drawMember();
        break;

      case '6':
        print('Exiting...');
        return;

      default:
        print('Invalid option. Please try again.');
    }
  }
}

// Function to authenticate user
void authenticateUser() {
  stdout.write('Enter User ID: ');
  String? userId = stdin.readLineSync();

  stdout.write('Enter Password: ');
  String? password = stdin.readLineSync();

  final user = users.firstWhere(
    (user) => user.id == userId && user.password == password,
    orElse: () => throw Exception('Invalid ID or Password'),
  );

  print('User authenticated successfully!');
  showCommitteeInfo();
}

// Function to show committee information
void showCommitteeInfo() {
  DateTime now = DateTime.now();
  stdout.write('Committee Information:\n');
  
  for (var committee in committees) {
    if (committee.scheduleDate.year == now.year && committee.scheduleDate.month == now.month) {
      print('Current Committee for This Month:\n$committee');
    } else if (committee.scheduleDate.isAfter(now)) {
      print('Future Committee:\n$committee');
    }
  }
  
  stdout.write('\nMember Status:\n');
  for (var committee in committees) {
    print('${committee.name}: ${committee.membersLeftToJoin} members left to join, ${committee.membersJoined} members have joined.');
  }
}

void main() {
  // Example users
  users.add(User('admin', 'adminpass'));

  // Create a sample committee for demonstration
  createCommittee();

  // Authenticate user and show committee information
  authenticateUser();
}
