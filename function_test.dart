import 'package:dart_appwrite/dart_appwrite.dart';

var client = Client();
var collectionId;
var userId;
var fileId;
var functionId;

var user = "${DateTime.now().millisecondsSinceEpoch}@example.com";
var password = "user@123";

var projectid = '60a48cf2c81ff';
var endpoint = 'https://dltest08.appwrite.org/v1';
var secret =
    'caabb7a50fa5e3123137997e9e26eca5cc9eb06c29fe64fddaaa85057ae8ceb9d876f5c4071fee64bbaea8d6b69094d89979b05a28d6938a96a5bc25f1af3ca2e2e6dc97ff780af2235b7be0f96d9f6b6c395f9417d92f792f13f16094655de60134a0d3fef18e27317ff1640c7e29c00d572f833faaaa3e5e806fb1a1958c73';

Future<void> main() async {
  client
      .setEndpoint(
          'https://dltest08.appwrite.org/v1') // Make sure your endpoint is accessible
      .setProject('60a48cf2c81ff') // Your project ID
      .setKey(
          'caabb7a50fa5e3123137997e9e26eca5cc9eb06c29fe64fddaaa85057ae8ceb9d876f5c4071fee64bbaea8d6b69094d89979b05a28d6938a96a5bc25f1af3ca2e2e6dc97ff780af2235b7be0f96d9f6b6c395f9417d92f792f13f16094655de60134a0d3fef18e27317ff1640c7e29c00d572f833faaaa3e5e806fb1a1958c73') // Your appwrite key
      .setSelfSigned(status: true); //Do not use this in production

  //running all apis

  // await createFunctions();
  // await createTagsAndExecute();
  await executeOnly();
  // await deleteFunctions();
}

var envs = [
  "node-14.5",
  "node-15.5",
  "deno-1.5",
  "deno-1.6",
  "deno-1.8",
  "php-7.4",
  "php-8.0",
  "python-3.8",
  "python-3.9",
  "dotnet-3.1",
  "dotnet-5.0",
  "dart-2.10",
  "dart-2.12",
  "ruby-2.7",
  "ruby-3.0",
];

class FunctionCode {
  final String code;
  final String command;

  FunctionCode(this.code, this.command);
}

var codes = {
  "node-14.5": FunctionCode("node.tar.gz", "node index.js"),
  "node-15.5": FunctionCode("node.tar.gz", "node index.js"),
  "deno-1.5": FunctionCode("deno.tar.gz", "deno run --allow-env index.ts"),
  "deno-1.6": FunctionCode("deno.tar.gz", "deno run --allow-env index.ts"),
  "deno-1.8": FunctionCode("deno.tar.gz", "deno run --allow-env index.ts"),
  "php-7.4": FunctionCode("php.tar.gz", "php index.php"),
  "php-8.0": FunctionCode("php.tar.gz", "php index.php"),
  "python-3.8": FunctionCode("python.tar.gz", "python main.py"),
  "python-3.9": FunctionCode("python.tar.gz", "python main.py"),
  "dotnet-3.1": FunctionCode("dotnet-3.1.tar.gz", "dotnet dotnet.dll"),
  "dotnet-5.0": FunctionCode("dotnet-5.0.tar.gz", "dotnet dotnet.dll"),
  "dart-2.10": FunctionCode("dart.tar.gz", "dart main.dart"),
  "dart-2.12": FunctionCode("dart.tar.gz", "dart main.dart"),
  "ruby-2.7": FunctionCode("ruby.tar.gz", "ruby app.rb"),
  "ruby-3.0": FunctionCode("ruby.tar.gz", "ruby app.rb"),
};

Future<void> createFunctions() async {
  final functions = Functions(client);
  print('Running Create Function API');
  try {
    for (var env in envs) {
      await functions.create(
          name: env,
          execute: [],
          env: env,
          vars: {
            "APPWRITE_PROJECT": projectid,
            "APPWRITE_ENDPOINT": endpoint,
            "APPWRITE_SECRET": secret,
          });
      print("function $env created");
    }
  } on AppwriteException catch (e) {
    print(e.message);
  }
}

Future<void> createTagsAndExecute() async {
  final functions = Functions(client);
  print('Running create tags and execute Functions API');
  try {
    final res = await functions.list();
    for (final function in res.data['functions']) {
      final res = await functions.createTag(
          functionId: function['\$id'],
          command: codes[function['env']]!.command,
          code: await MultipartFile.fromFile(
              "./functions/${codes[function['env']]!.code}"));
      print("tag created for ${function['env']}");
      await functions.updateTag(
          functionId: function['\$id'], tag: res.data['\$id']);
      print("tag deployed for ${function['env']}");
      await functions.createExecution(
          functionId: function['\$id'],
          data: "This is custom data for ${function['env']}");
      print("execution created ${function['env']}");
    }
  } on AppwriteException catch (e) {
    print(e.message);
  }
}

Future<void> executeOnly() async {
  final functions = Functions(client);
  print('Running execute only Functions API');
  try {
    final res = await functions.list();
    for (final function in res.data['functions']) {
      await functions.createExecution(
          functionId: function['\$id'],
          data: "This is custom data for ${function['env']}");
      print("execution created ${function['env']}");
    }
  } on AppwriteException catch (e) {
    print(e.message);
  }
}

Future<void> deleteFunctions() async {
  final functions = Functions(client);
  print('Running delete Functions API');
  try {
    final res = await functions.list();
    for (final function in res.data['functions']) {
      await functions.delete(functionId: function['\$id']);
      print("deleted ${function['env']}");
    }
  } on AppwriteException catch (e) {
    print(e.message);
  }
}
