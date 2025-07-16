abstract class LawyerManagementEvent {}

class LawyerLoadByCategoryEvent extends LawyerManagementEvent {
  final String category;
  LawyerLoadByCategoryEvent(this.category);
}

class LawyerLoadTopEvent extends LawyerManagementEvent  {}
