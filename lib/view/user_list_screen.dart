import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view/add_user_screen.dart';
import '../view_model/user_view_model.dart';

class UserListScreen extends StatelessWidget {
  const UserListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<UserViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("User List"),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await viewModel.loadUsers();
        },
        child: viewModel.users.isEmpty
            ? const Center(child: Text("No users found"))
            : ListView.builder(
                itemCount: viewModel.users.length,
                itemBuilder: (context, index) {
                  final user = viewModel.users[index];
                  return ListTile(
                    title: Text(user.firstName),
                    subtitle: Text(
                      "DOB: ${user.dob.split('T')[0]}\nMobile: ${user.mobile}",
                    ),
                    isThreeLine: true,
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddUserScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
