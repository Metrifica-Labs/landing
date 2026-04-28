class LeadModel {
  const LeadModel({
    required this.name,
    required this.phone,
    required this.email,
    required this.companyName,
    required this.instagram,
    required this.monthlyRevenue,
    required this.businessMoment,
    required this.businessDescription,
    required this.currentProblems,
    required this.consequence12Months,
    required this.previousAttempt,
    required this.failedAttemptDetails,
    required this.currentSystems,
    required this.idealSystemSolution,
    required this.willingToInvest,
    required this.whyMetrifica,
  });

  final String name;
  final String phone;
  final String email;
  final String companyName;
  final String instagram;
  final String monthlyRevenue;
  final List<String> businessMoment;
  final String businessDescription;
  final List<String> currentProblems;
  final String consequence12Months;
  final String previousAttempt;
  final String failedAttemptDetails;
  final String currentSystems;
  final String idealSystemSolution;
  final String willingToInvest;
  final String whyMetrifica;

  Map<String, dynamic> toJson() => {
    'name': name,
    'phone': phone,
    'email': email,
    'company_name': companyName,
    'instagram': instagram,
    'monthly_revenue': monthlyRevenue,
    'business_moment': businessMoment,
    'business_description': businessDescription,
    'current_problems': currentProblems,
    'consequence_12_months': consequence12Months,
    'previous_attempt': previousAttempt,
    'failed_attempt_details': failedAttemptDetails,
    'current_systems': currentSystems,
    'ideal_system_solution': idealSystemSolution,
    'willing_to_invest': willingToInvest,
    'why_metrifica': whyMetrifica,
  };
}
