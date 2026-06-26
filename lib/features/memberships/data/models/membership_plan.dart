enum MembershipTier {
  dropIn,
  monthly,
  studentMonthly,
  annual,
}

extension MembershipTierDetails on MembershipTier {
  String get displayName {
    switch (this) {
      case MembershipTier.dropIn:
        return 'Drop-In';
      case MembershipTier.monthly:
        return 'Monthly';
      case MembershipTier.studentMonthly:
        return 'Student Monthly';
      case MembershipTier.annual:
        return 'Annual';
    }
  }

  String get price {
    switch (this) {
      case MembershipTier.dropIn:
        return '\$25';
      case MembershipTier.monthly:
        return '\$150/mo';
      case MembershipTier.studentMonthly:
        return '\$100/mo';
      case MembershipTier.annual:
        return '\$1,500/yr';
    }
  }

  String get description {
    switch (this) {
      case MembershipTier.dropIn:
        return 'Single class access. No commitment.';
      case MembershipTier.monthly:
        return 'Unlimited classes. Month-to-month.';
      case MembershipTier.studentMonthly:
        return 'Unlimited classes. Valid student ID required.';
      case MembershipTier.annual:
        return 'Unlimited classes. Best value — save 2 months.';
    }
  }
}
