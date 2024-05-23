class ReputationHistory {
  final ReputationHistoryType reputationHistoryType;
  final int reputationChange;
  final int postId;
  final DateTime creationDate;
  final int userId;

  const ReputationHistory({
    required this.reputationHistoryType,
    required this.reputationChange,
    required this.postId,
    required this.creationDate,
    required this.userId,
  });

  ReputationHistory copyWith({
    ReputationHistoryType? reputationHistoryType,
    int? reputationChange,
    int? postId,
    DateTime? creationDate,
    int? userId,
  }) {
    return ReputationHistory(
      reputationHistoryType:
          reputationHistoryType ?? this.reputationHistoryType,
      reputationChange: reputationChange ?? this.reputationChange,
      postId: postId ?? this.postId,
      creationDate: creationDate ?? this.creationDate,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toMap() => {
        'reputation_history_type': reputationHistoryType.toJsonString(),
        'reputation_change': reputationChange,
        'post_id': postId,
        'creation_date': creationDate.millisecondsSinceEpoch ~/ 1000,
        'user_id': userId,
      };

  factory ReputationHistory.fromMap(Map<String, dynamic> map) {
    return ReputationHistory(
      reputationHistoryType:
          ReputationHistoryType.fromJsonString(map['reputation_history_type']),
      reputationChange: map['reputation_change']?.toInt() ?? 0,
      postId: map['post_id']?.toInt() ?? 0,
      creationDate: DateTime.fromMillisecondsSinceEpoch(
        (map['creation_date']?.toInt() ?? 0) * 1000,
      ),
      userId: map['user_id']?.toInt() ?? 0,
    );
  }
}

enum ReputationHistoryType {
  askerAcceptsAnswer,
  askerUnacceptAnswer,
  answerAccepted,
  answerUnaccepted,
  voterDownvotes,
  voterUndownvotes,
  postDownvoted,
  postUndownvoted,
  postUpvoted,
  postUnupvoted,
  suggestedEditApprovalReceived,
  postFlaggedAsSpam,
  postFlaggedAsOffensive,
  bountyGiven,
  bountyEarned,
  bountyCancelled,
  postDeleted,
  postUndeleted,
  associationBonus,
  arbitraryReputationChange,
  voteFraudReversal,
  postMigrated,
  userDeleted,
  exampleUpvoted,
  exampleUnupvoted,
  proposedChangeApproved,
  docLinkUpvoted,
  docLinkUnupvoted,
  docSourceRemoved,
  suggestedEditApprovalOverridden;

  String toJsonString() {
    return switch (this) {
      askerAcceptsAnswer => 'asker_accepts_answer',
      askerUnacceptAnswer => 'asker_unaccept_answer',
      answerAccepted => 'answer_accepted',
      answerUnaccepted => 'answer_unaccepted',
      voterDownvotes => 'voter_downvotes',
      voterUndownvotes => 'voter_undownvotes',
      postDownvoted => 'post_downvoted',
      postUndownvoted => 'post_undownvoted',
      postUpvoted => 'post_upvoted',
      postUnupvoted => 'post_unupvoted',
      suggestedEditApprovalReceived => 'suggested_edit_approval_received',
      postFlaggedAsSpam => 'post_flagged_as_spam',
      postFlaggedAsOffensive => 'post_flagged_as_offensive',
      bountyGiven => 'bounty_given',
      bountyEarned => 'bounty_earned',
      bountyCancelled => 'bounty_cancelled',
      postDeleted => 'post_deleted',
      postUndeleted => 'post_undeleted',
      associationBonus => 'association_bonus',
      arbitraryReputationChange => 'arbitrary_reputation_change',
      voteFraudReversal => 'vote_fraud_reversal',
      postMigrated => 'post_migrated',
      userDeleted => 'user_deleted',
      exampleUpvoted => 'example_upvoted',
      exampleUnupvoted => 'example_unupvoted',
      proposedChangeApproved => 'proposed_change_approved',
      docLinkUpvoted => 'doc_link_upvoted',
      docLinkUnupvoted => 'doc_link_unupvoted',
      docSourceRemoved => 'doc_source_removed',
      suggestedEditApprovalOverridden => 'suggested_edit_approval_overridden',
    };
  }

  static ReputationHistoryType fromJsonString(String value) {
    return switch (value) {
      'asker_accepts_answer' => ReputationHistoryType.askerAcceptsAnswer,
      'asker_unaccept_answer' => ReputationHistoryType.askerUnacceptAnswer,
      'answer_accepted' => ReputationHistoryType.answerAccepted,
      'answer_unaccepted' => ReputationHistoryType.answerUnaccepted,
      'voter_downvotes' => ReputationHistoryType.voterDownvotes,
      'voter_undownvotes' => ReputationHistoryType.voterUndownvotes,
      'post_downvoted' => ReputationHistoryType.postDownvoted,
      'post_undownvoted' => ReputationHistoryType.postUndownvoted,
      'post_upvoted' => ReputationHistoryType.postUpvoted,
      'post_unupvoted' => ReputationHistoryType.postUnupvoted,
      'suggested_edit_approval_received' =>
        ReputationHistoryType.suggestedEditApprovalReceived,
      'post_flagged_as_spam' => ReputationHistoryType.postFlaggedAsSpam,
      'post_flagged_as_offensive' =>
        ReputationHistoryType.postFlaggedAsOffensive,
      'bounty_given' => ReputationHistoryType.bountyGiven,
      'bounty_earned' => ReputationHistoryType.bountyEarned,
      'bounty_cancelled' => ReputationHistoryType.bountyCancelled,
      'post_deleted' => ReputationHistoryType.postDeleted,
      'post_undeleted' => ReputationHistoryType.postUndeleted,
      'association_bonus' => ReputationHistoryType.associationBonus,
      'arbitrary_reputation_change' =>
        ReputationHistoryType.arbitraryReputationChange,
      'vote_fraud_reversal' => ReputationHistoryType.voteFraudReversal,
      'post_migrated' => ReputationHistoryType.postMigrated,
      'user_deleted' => ReputationHistoryType.userDeleted,
      'example_upvoted' => ReputationHistoryType.exampleUpvoted,
      'example_unupvoted' => ReputationHistoryType.exampleUnupvoted,
      'proposed_change_approved' =>
        ReputationHistoryType.proposedChangeApproved,
      'doc_link_upvoted' => ReputationHistoryType.docLinkUpvoted,
      'doc_link_unupvoted' => ReputationHistoryType.docLinkUnupvoted,
      'doc_source_removed' => ReputationHistoryType.docSourceRemoved,
      'suggested_edit_approval_overridden' =>
        ReputationHistoryType.suggestedEditApprovalOverridden,
      _ => throw UnsupportedError('Unsupported type $value'),
    };
  }
}
