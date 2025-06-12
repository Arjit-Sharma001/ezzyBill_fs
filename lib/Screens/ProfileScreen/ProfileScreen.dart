import 'package:ezzybill/Controller/AuthController.dart';
import 'package:ezzybill/DataBase/firebaseDatabase.dart';
import 'package:ezzybill/Screens/AutyhScreen/LoginScreen.dart';
import 'package:ezzybill/Screens/InvoiceScreen/Invoiceeditscreen.dart';
import 'package:ezzybill/Screens/InvoiceScreen/PaymentScreen.dart';
import 'package:ezzybill/Screens/Itemeditscreen.dart';
import 'package:ezzybill/Screens/ProfileScreen/ChangePasswordScreen.dart';
import 'package:ezzybill/consts/consts.dart';
import 'package:ezzybill/widgetsCommon/BgWidget.dart';
import 'package:ezzybill/widgetsCommon/ProfileScreenCard.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = "Dummy user";
  String email = "user@example.com";
  String profileUrl = icProfile;

  @override
  void initState() {
    super.initState();
    fetchUserData().then((data) {
      setState(() {
        name = data["name"]!;
        email = data["email"]!;
        profileUrl = data["profileUrl"]!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BgWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Get.to(() => const ChangePasswordScreen()),
                    child: ClipOval(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.network(
                          profileUrl,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset(
                            icProfile,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontFamily: semibold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          email,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: whiteColor),
                    ),
                    onPressed: () async {
                      await Get.put(AuthController()).signOutMethod(context);
                      Get.offAll(() => LoginScreen());
                    },
                    child: Text(
                      "Logout",
                      style: TextStyle(
                        fontFamily: semibold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

// ItemEditScreen Card
            InkWell(
              onTap: () => Get.to(() => InvoiceEditScreen()),
              borderRadius: BorderRadius.circular(12),
              child: ProfilescreenCard(
                  icon: icInvoice,
                  title: "Customize Invoice",
                  description: "Edit and personalize billing details"),
            ),
            SizedBox(height: 10),
// InventoryEditScreen Card
            InkWell(
              onTap: () => Get.to(() => ItemEditScreen()),
              borderRadius: BorderRadius.circular(12),
              child: ProfilescreenCard(
                  icon: icOrders,
                  title: "Customize Inventory",
                  description: "Add Items in Inventory"),
            ),
            SizedBox(height: 10),
// PaymentScreen Card
            InkWell(
              onTap: () => Get.to(() => PaymentScreen()),
              borderRadius: BorderRadius.circular(12),
              child: ProfilescreenCard(
                  icon: icPayment,
                  title: "Customize Payment Method",
                  description: "Add UPI Id's"),
            ),
          ],
        ),
      ),
    );
  }
}
