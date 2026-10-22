class LeadModel {
  const LeadModel({
    this.id,
    this.name,
    this.phone,
    this.instagram,
    this.monthlyRevenue,
    this.businessDescription,
    this.currentProblems,
    this.consequence,
    this.previousAttempt,
    this.failedAttemptDetails,
    this.currentSystems,
    this.idealSystemSolution,
    this.willingToInvest,
    this.status = 'partial',
    this.currentStep = 0,
  });

  final String? id;
  final String? name;
  final String? phone;
  final String? instagram;
  final String? monthlyRevenue;
  final String? businessDescription;
  final List<String>? currentProblems;
  final String? consequence;
  final String? previousAttempt;
  final String? failedAttemptDetails;
  final String? currentSystems;
  final String? idealSystemSolution;
  final String? willingToInvest;
  final String status;
  final int currentStep;

  Map<String, dynamic> toJson() {
    final m = <String, dynamic>{
      'status': status,
      'current_step': currentStep,
    };
    if (name != null)                m['name']                   = name;
    if (phone != null)               m['phone']                  = phone;
    if (instagram != null)           m['instagram']              = instagram;
    if (monthlyRevenue != null)      m['monthly_revenue']        = monthlyRevenue;
    if (businessDescription != null) m['business_description']   = businessDescription;
    if (currentProblems != null)     m['current_problems']       = currentProblems;
    if (consequence != null)         m['consequence']            = consequence;
    if (previousAttempt != null)     m['previous_attempt']       = previousAttempt;
    if (failedAttemptDetails != null) m['failed_attempt_details'] = failedAttemptDetails;
    if (currentSystems != null)      m['current_systems']        = currentSystems;
    if (idealSystemSolution != null) m['ideal_system_solution']  = idealSystemSolution;
    if (willingToInvest != null)     m['willing_to_invest']      = willingToInvest;
    return m;
  }

  LeadModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? instagram,
    String? monthlyRevenue,
    String? businessDescription,
    List<String>? currentProblems,
    String? consequence,
    String? previousAttempt,
    String? failedAttemptDetails,
    String? currentSystems,
    String? idealSystemSolution,
    String? willingToInvest,
    String? status,
    int? currentStep,
  }) =>
      LeadModel(
        id:                   id                   ?? this.id,
        name:                 name                 ?? this.name,
        phone:                phone                ?? this.phone,
        instagram:            instagram            ?? this.instagram,
        monthlyRevenue:       monthlyRevenue       ?? this.monthlyRevenue,
        businessDescription:  businessDescription  ?? this.businessDescription,
        currentProblems:      currentProblems      ?? this.currentProblems,
        consequence:          consequence          ?? this.consequence,
        previousAttempt:      previousAttempt      ?? this.previousAttempt,
        failedAttemptDetails: failedAttemptDetails ?? this.failedAttemptDetails,
        currentSystems:       currentSystems       ?? this.currentSystems,
        idealSystemSolution:  idealSystemSolution  ?? this.idealSystemSolution,
        willingToInvest:      willingToInvest      ?? this.willingToInvest,
        status:               status               ?? this.status,
        currentStep:          currentStep          ?? this.currentStep,
      );
}
