import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';


class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BalanceCard(),
                const SizedBox(height: 20),
                SearchBar(
                  hintText: "Search transactions...",
                  leading: const Icon(Icons.search),
                  padding: const MaterialStatePropertyAll(
                    EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Recent Transactions",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Text("This month"),
                      label: const Icon(Icons.keyboard_arrow_down),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Obx(() => Column(
                  children: controller.transactions
                      .map((transaction) => TransactionCard(transaction: transaction))
                      .toList(),
                )),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (index) {},
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.bar_chart),
            label: 'Summary',
          ),
          NavigationDestination(
            icon: Icon(Icons.show_chart),
            label: 'Markets',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Portfolio',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class BalanceCard extends GetView<HomeController> {
  const BalanceCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Your Balance",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Obx(() {
            if (controller.user.value != null) {
              return Text(
                "\$${controller.user.value!.account.balance.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                   color: Colors.white,
                ),
              );
            } else {
              return const Text(
                "Loading...",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              );
            }
          }),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildActionButton(Icons.account_balance_wallet, "Deposit", onTap: controller.onDepositTap),
              _buildActionButton(Icons.payments, "Withdraw", onTap: controller.onWithdrawTap),
              _buildActionButton(
                Icons.swap_horiz,
                "Transfer",
                isHighlighted: true,
                onTap: controller.onTransferTap,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label,
      {bool isHighlighted = false, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isHighlighted ? Colors.green : Colors.grey[800],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isHighlighted ? Colors.black : Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: isHighlighted ? Colors.green : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class TransactionCard extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionCard({Key? key, required this.transaction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[800]!,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              transaction.type == 'RECEIVE' ? Icons.arrow_downward : Icons.arrow_upward,
              color: transaction.type == 'RECEIVE' ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${transaction.sender.firstName} ${transaction.sender.lastName}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  transaction.date,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            "${transaction.type == 'RECEIVE' ? '+' : '-'}\$${transaction.amount.toStringAsFixed(2)}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: transaction.type == 'RECEIVE' ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
