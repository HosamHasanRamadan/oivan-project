import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oivan_project/infinite_list/infinite_list_view.dart';
import 'package:oivan_project/presentation/user_reputation_history_page.dart';
import 'package:oivan_project/view_model/users_book_marks_view_model.dart';

class UserBookMarksPage extends StatelessWidget {
  const UserBookMarksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final viewModel = ref.watch(userBookMarksViewModelProvider);
        return UserBookMarksPageContent(
          viewModel: viewModel,
        );
      },
    );
  }
}

class UserBookMarksPageContent extends StatefulWidget {
  final UserBookMarksViewModel viewModel;
  const UserBookMarksPageContent({
    super.key,
    required this.viewModel,
  });

  @override
  State<UserBookMarksPageContent> createState() =>
      _UserBookMarksPageContentState();
}

class _UserBookMarksPageContentState extends State<UserBookMarksPageContent> {
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
        title: const Text('BookMarks'),
      ),
      body: InfiniteListView(
        viewModel: widget.viewModel,
        itemBuilder: (context, index) {
          final user = widget.viewModel.value.items[index];
          return Row(
            children: [
              IconButton(
                icon: const Icon(Icons.bookmark_remove),
                onPressed: () {
                  widget.viewModel.deleteBookMark(
                    user.userId,
                  );
                },
              ),
              Expanded(
                child: ListTile(
                  key: ValueKey(user.userId),
                  title: Text(user.displayName),
                  subtitle: user.location != null ? Text(user.location!) : null,
                  trailing: Text(user.reputation.toString()),
                  leading: CachedNetworkImage(
                    width: 50,
                    height: 50,
                    imageUrl: user.profileImage,
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return UserReputationHistoryPage(
                            userId: user.userId,
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
