import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oivan_project/infinite_list/infinite_list_view.dart';
import 'package:oivan_project/view_model/reputation_history_view_model.dart';

class UserReputationHistoryPage extends StatelessWidget {
  final int userId;

  const UserReputationHistoryPage({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) => _UserReputationHistoryPageContent(
        viewModel: ref.watch(userReputationHistoryViewModelProvider(userId)),
      ),
    );
  }
}

class _UserReputationHistoryPageContent extends StatefulWidget {
  const _UserReputationHistoryPageContent({
    super.key,
    required this.viewModel,
  });
  final UserReputationHistoryViewModel viewModel;

  @override
  State<_UserReputationHistoryPageContent> createState() =>
      _UserReputationHistoryPageContentState();
}

class _UserReputationHistoryPageContentState
    extends State<_UserReputationHistoryPageContent> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Reputation History'),
      ),
      body: Center(
        child: InfiniteListView(
          viewModel: widget.viewModel,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final user = widget.viewModel.value.items[index];
            return ListTile(
              key: ValueKey(user.postId),
              title: Text(user.postId.toString()),
              subtitle: Text(user.reputationHistoryType.name),
              trailing: Text(
                user.creationDate.toLocal().toString(),
              ),
              leading: Text(user.reputationChange.toString()),
            );
          },
        ),
      ),
    );
  }
}
