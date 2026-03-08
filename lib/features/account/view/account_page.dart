import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_super_aslan_app/features/account/cubit/account_cubit.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AccountCubit(),
      child: AccountView(),
    );
  }
}

class AccountView extends StatelessWidget {
  final String rak = "assets/images/rakrak.png";
  AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Color(0xFF3B82F6),
          ),
        ),
        title: const Text(
          "Profile Settings",
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView(
          children: [
            CircleAvatar(
              radius: 70,
              child: Image.asset(rak),
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(),
              onPressed: () {},
              child: const Text("Edit Profile"),
            ),
            const Text(
              "Registered phone number",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const ListTile(
                leading: Icon(Icons.phone),
                title: Text("phone number"),
                trailing: Text("+855(0) 97 6868 568"),
              ),
            ),
            const Text(
              "Personal Infomation",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            Container(
              child: Column(
                children: [],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
