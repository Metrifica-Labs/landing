class LeadModel {
  const LeadModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.monthlyRevenue,
  });

  final String name;
  final String email;
  final String phone;
  final String monthlyRevenue;

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'phone': phone,
    'monthly_revenue': monthlyRevenue,
  };
}
