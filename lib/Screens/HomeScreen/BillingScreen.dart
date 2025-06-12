// Your imports remain the same...

import 'package:ezzybill/DataBase/firebaseDatabase.dart';
import 'package:ezzybill/DataBase/invoicesHistory.dart';
import 'package:ezzybill/Screens/Home.dart';
import 'package:ezzybill/Screens/HomeScreen/InventoryScreen.dart';
import 'package:ezzybill/consts/consts.dart';
import 'package:ezzybill/widgetsCommon/BgWidget.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DynamicBillTabs extends StatefulWidget {
  @override
  _DynamicBillTabsState createState() => _DynamicBillTabsState();
}

class _DynamicBillTabsState extends State<DynamicBillTabs> {
  TextEditingController searchController = TextEditingController();
  ScrollController _scrollController = ScrollController();

  int selectedIndex = 0;
  int billCounter = 1;
  List<Inventoryscreen> billScreens = [];
  List<String> bills = [];
  List<FoodItem_firebase> FooditemList = [];

  @override
  void initState() {
    super.initState();
    fetchFoodItems().then((items) {
      setState(() {
        FooditemList = items;
      });
    });
    initBills();
  }

  Future<int> returnlastBillNo() async {
    int lastBillNo = await fetchLastBillNoFromFirestore();
    return lastBillNo;
  }

  Future<void> initBills() async {
    int lastBillNo = await returnlastBillNo();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? savedIndex = prefs.getInt('lastOpenedBillIndex');

    billCounter = lastBillNo + 1;
    bills = ['Bill $billCounter'];
    billScreens = [Inventoryscreen(billNo: billCounter)];

    setState(() {
      selectedIndex =
          (savedIndex != null && savedIndex < bills.length) ? savedIndex : 0;
    });
  }

  void addBill() async {
    // Extract used numbers from current bills
    Set<int> usedNumbers = bills.map((bill) {
      return int.tryParse(bill.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    }).toSet();

    // Find the smallest missing bill number starting from 1
    int newBillNo = await returnlastBillNo() + 1;
    while (usedNumbers.contains(newBillNo)) {
      newBillNo++;
    }

    setState(() {
      bills.add('Bill $newBillNo');
      billScreens.add(Inventoryscreen(billNo: newBillNo));
      selectedIndex = bills.length - 1;

      // Only update billCounter if newBillNo is greater
      if (newBillNo >= billCounter) {
        billCounter = newBillNo + 1;
      }
    });
  }

  void removeBill(int index) async {
    bool confirm = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Delete ${bills[index]}?"),
        content: Text("Are you sure you want to delete this bill?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text("Cancel")),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text("Delete")),
        ],
      ),
    );

    if (confirm) {
      if (bills.length == 1) {
        Get.off(() => Home());
        return;
      }
      setState(() {
        bills.removeAt(index);
        billScreens.removeAt(index);
        selectedIndex =
            selectedIndex >= bills.length ? bills.length - 1 : selectedIndex;
      });
      saveSelectedIndex(selectedIndex);
    }
  }

  Future<void> saveSelectedIndex(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastOpenedBillIndex', index);
  }

  void selectBill(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void searchAndScroll(String query) {
    if (query.isEmpty) return;

    int index = FooditemList.indexWhere(
        (item) => item.name.toLowerCase().contains(query.toLowerCase()));

    if (index != -1) {
      _scrollController.animateTo(
        index * 150.0,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Item not found!"),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height - 100;
    double screenWidth = MediaQuery.of(context).size.width;

    return BgWidget(
      child: Hero(
        tag: "createBill",
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: primaryColor2,
            actions: [
              // SizedBox(width: screenHeight * 0.08),
              Padding(
                padding: const EdgeInsets.only(right: 10, bottom: 6),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    height: screenHeight * 0.08,
                    width: screenWidth * 0.8,
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      controller: searchController,
                      onFieldSubmitted: (value) => searchAndScroll(value),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        suffixIcon: Icon(Icons.search, color: primaryColor),
                        hintText: "Search item....",
                        hintStyle: TextStyle(color: primaryColor),
                      ),
                    ),
                  ),
                ),
              ),
              // SizedBox(width: screenHeight * 0.02),
            ],
          ),
          body: billScreens.isEmpty
              ? Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    // Bill Tabs
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding:
                          EdgeInsets.symmetric(vertical: 2, horizontal: 12),
                      child: Row(
                        children: [
                          ...List.generate(bills.length, (index) {
                            bool isSelected = selectedIndex == index;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: GestureDetector(
                                onTap: () => selectBill(index),
                                child: Chip(
                                  label: Text(
                                    bills[index],
                                    style: TextStyle(
                                      color: isSelected
                                          ? whiteColor
                                          : primaryColor2,
                                    ),
                                  ),
                                  onDeleted: () => removeBill(index),
                                  backgroundColor:
                                      isSelected ? primaryColor2 : lightopaque,
                                  deleteIconColor: Colors.white,
                                  labelPadding:
                                      EdgeInsets.symmetric(horizontal: 8),
                                ),
                              ),
                            );
                          }),
                          // Add Bill Icon
                          GestureDetector(
                            onTap: addBill,
                            child: Container(
                              decoration: BoxDecoration(
                                color: lightopaque,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.all(4),
                              child: Icon(Icons.add, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Bill Body
                    Expanded(
                      child: IndexedStack(
                        index: selectedIndex,
                        children: billScreens,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
