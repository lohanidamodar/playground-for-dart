import 'package:dart_appwrite/dart_appwrite.dart';

var client = Client();
var collectionId;
var userId;
var fileId;
var functionId;

var user = "${DateTime.now().millisecondsSinceEpoch}@example.com";
var password = "user@123";

Future<void> main() async {
  client
      .setEndpoint(
          'https://dltest08.appwrite.org/v1') // Make sure your endpoint is accessible
      .setProject('60a48cf2c81ff') // Your project ID
      .setKey(
          'caabb7a50fa5e3123137997e9e26eca5cc9eb06c29fe64fddaaa85057ae8ceb9d876f5c4071fee64bbaea8d6b69094d89979b05a28d6938a96a5bc25f1af3ca2e2e6dc97ff780af2235b7be0f96d9f6b6c395f9417d92f792f13f16094655de60134a0d3fef18e27317ff1640c7e29c00d572f833faaaa3e5e806fb1a1958c73') // Your appwrite key
      .setSelfSigned(status: true); //Do not use this in production

  //running all apis
  await createCollection();
  await listCollection();
  await addDoc();
  await listDoc();
  await deleteCollection();

  await uploadFile();
  await deleteFile();

  await createUser(user, password, 'Some user');
  await listUser();
  await deleteUser();

  await createFunction();
  await listFunctions();
  await deleteFunction();
}

Future<void> createCollection() async {
  final database = Database(client);
  print('Running create collection API');
  try {
    final res = await database.createCollection(name: 'Movies', read: [
      '*'
    ], write: [
      '*'
    ], rules: [
      {
        'label': 'Name',
        'key': 'name',
        'type': 'text',
        'default': 'Empty Name',
        'required': true,
        'array': false
      },
      {
        'label': 'release_year',
        'key': 'release_year',
        'type': 'numeric',
        'default': 1970,
        'required': true,
        'array': false
      }
    ]);
    collectionId = res.data['\$id'];
    print(res.data);
  } on AppwriteException catch (e) {
    print(e.message);
  }
}

Future<void> listCollection() async {
  final database = Database(client);
  print("Running list collection API");
  try {
    final res = await database.listCollections();
    final collection = res.data["collections"][0];
    print(collection);
  } on AppwriteException catch (e) {
    print(e.message);
  }
}

Future<void> deleteCollection() async {
  final database = Database(client);
  print("Running delete collection API");
  try {
    await database.deleteCollection(collectionId: collectionId);
    print("collection deleted");
  } on AppwriteException catch (e) {
    print(e.message);
  }
}

Future<void> addDoc() async {
  final database = Database(client);
  print('Running Add Document API');
  try {
    final res = await database.createDocument(
        collectionId: collectionId,
        data: {'name': 'Spider Man', 'release_year': 1920},
        read: ['*'],
        write: ['*']);
    print(res.data);
  } on AppwriteException catch (e) {
    print(e.message);
  }
}

Future<void> listDoc() async {
  final database = Database(client);
  print('Running List Document API');
  try {
    final response = await database.listDocuments(collectionId: collectionId);
    print(response.data);
  } on AppwriteException catch (e) {
    print(e.message);
  }
}

Future<void> uploadFile() async {
  final storage = Storage(client);
  print('Running Upload File API');
  final file =
      await MultipartFile.fromFile('./nature.jpg', filename: 'nature.jpg');
  try {
    final response = await storage.createFile(
      file: file, //multipart file
      read: ['*'],
      write: ['*'],
    );
    fileId = response.data['\$id'];
    print(response.data);
  } on AppwriteException catch (e) {
    print(e.message);
  }
}

Future<void> deleteFile() async {
  final storage = Storage(client);
  print('Running Delete File API');
  try {
    await storage.deleteFile(fileId: fileId);
    print("File deleted");
  } on AppwriteException catch (e) {
    print(e.message);
  }
}

Future<void> createUser(email, password, name) async {
  final users = Users(client);
  print('Running Create User API');
  try {
    final response = await users.create(
      email: email,
      password: password,
      name: name,
    );
    userId = response.data['\$id'];
    print(response.data);
  } on AppwriteException catch (e) {
    print(e.message);
  }
}

Future<void> listUser() async {
  final users = Users(client);
  print('Running List User API');
  try {
    final response = await users.list();
    print(response.data);
  } on AppwriteException catch (e) {
    print(e.message);
  }
}

Future<void> deleteUser() async {
  final users = Users(client);
  print("Running delete user");
  try {
    await users.delete(userId: userId); // deleteUsers was changed to delete
    print("user deleted");
  } on AppwriteException catch (e) {
    print(e.message);
  }
}

Future<void> createFunction() async {
  final functions = Functions(client);
  print('Running Create Function API');
  try {
    final res = await functions.create(
        name: 'test function', execute: [], env: 'dart-2.12');
    print(res.data);
    functionId = res.data['\$id'];
  } on AppwriteException catch (e) {
    print(e.message);
  }
}

Future<void> listFunctions() async {
  final functions = Functions(client);
  print('Running List Functions API');
  try {
    final res = await functions.list();
    print(res.data);
  } on AppwriteException catch (e) {
    print(e.message);
  }
}

Future<void> deleteFunction() async {
  final functions = Functions(client);
  print('Running Delete Function API');
  try {
    await functions.delete(functionId: functionId);
    print('Function deleted');
  } on AppwriteException catch (e) {
    print(e.message);
  }
}
