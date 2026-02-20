enum StudentExamStatus { upcoming, active, pending, verified, missed }

extension StudentExamStatusX on StudentExamStatus {
  static StudentExamStatus fromString(String status) {
    switch (status.toUpperCase()) {
      case 'UPCOMING':
        return StudentExamStatus.upcoming;
      case 'ACTIVE':
        return StudentExamStatus.active;
      case 'PENDING':
        return StudentExamStatus.pending;
      case 'VERIFIED':
        return StudentExamStatus.verified;
      case 'MISSED':
        return StudentExamStatus.missed;
      default:
        return StudentExamStatus.upcoming;
    }
  }
}
