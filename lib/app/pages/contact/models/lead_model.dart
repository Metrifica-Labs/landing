class LeadModel {
  const LeadModel({
    this.id,
    this.name,
    this.phone,
    this.email,
    this.companyName,
    this.instagram,
    this.monthlyRevenue,
    this.businessMoment,
    this.businessDescription,
    this.currentProblems,
    this.consequence12Months,
    this.previousAttempt,
    this.failedAttemptDetails,
    this.currentSystems,
    this.idealSystemSolution,
    this.willingToInvest,
    this.whyMetrifica,
    this.status = 'partial',
    this.currentStep = 0,
  });

  final String? id;
  final String? name;
  final String? phone;
  final String? email;
  final String? companyName;
  final String? instagram;
  final String? monthlyRevenue;
  final List<String>? businessMoment;
  final String? businessDescription;
  final List<String>? currentProblems;
  final String? consequence12Months;
  final String? previousAttempt;
  final String? failedAttemptDetails;
  final String? currentSystems;
  final String? idealSystemSolution;
  final String? willingToInvest;
  final String? whyMetrifica;
  final String status;
  final int currentStep;

  Map<String, dynamic> toJson() {
    final m = <String, dynamic>{
      'status': status,
      'current_step': currentStep,
    };
    if (name != null)                m['name']                   = name;
    if (phone != null)               m['phone']                  = phone;
    if (email != null)               m['email']                  = email;
    if (companyName != null)         m['company_name']           = companyName;
    if (instagram != null)           m['instagram']              = instagram;
    if (monthlyRevenue != null)      m['monthly_revenue']        = monthlyRevenue;
    if (businessMoment != null)      m['business_moment']        = businessMoment;
    if (businessDescription != null) m['business_description']   = businessDescription;
    if (currentProblems != null)     m['current_problems']       = currentProblems;
    if (consequence12Months != null) m['consequence_12_months']  = consequence12Months;
    if (previousAttempt != null)     m['previous_attempt']       = previousAttempt;
    if (failedAttemptDetails != null) m['failed_attempt_details'] = failedAttemptDetails;
    if (currentSystems != null)      m['current_systems']        = currentSystems;
    if (idealSystemSolution != null) m['ideal_system_solution']  = idealSystemSolution;
    if (willingToInvest != null)     m['willing_to_invest']      = willingToInvest;
    if (whyMetrifica != null)        m['why_metrifica']          = whyMetrifica;
    return m;
  }

  LeadModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? companyName,
    String? instagram,
    String? monthlyRevenue,
    List<String>? businessMoment,
    String? businessDescription,
    List<String>? currentProblems,
    String? consequence12Months,
    String? previousAttempt,
    String? failedAttemptDetails,
    String? currentSystems,
    String? idealSystemSolution,
    String? willingToInvest,
    String? whyMetrifica,
    String? status,
    int? currentStep,
  }) =>
      LeadModel(
        id:                   id                   ?? this.id,
        name:                 name                 ?? this.name,
        phone:                phone                ?? this.phone,
        email:                email                ?? this.email,
        companyName:          companyName          ?? this.companyName,
        instagram:            instagram            ?? this.instagram,
        monthlyRevenue:       monthlyRevenue       ?? this.monthlyRevenue,
        businessMoment:       businessMoment       ?? this.businessMoment,
        businessDescription:  businessDescription  ?? this.businessDescription,
        currentProblems:      currentProblems      ?? this.currentProblems,
        consequence12Months:  consequence12Months  ?? this.consequence12Months,
        previousAttempt:      previousAttempt      ?? this.previousAttempt,
        failedAttemptDetails: failedAttemptDetails ?? this.failedAttemptDetails,
        currentSystems:       currentSystems       ?? this.currentSystems,
        idealSystemSolution:  idealSystemSolution  ?? this.idealSystemSolution,
        willingToInvest:      willingToInvest      ?? this.willingToInvest,
        whyMetrifica:         whyMetrifica         ?? this.whyMetrifica,
        status:               status               ?? this.status,
        currentStep:          currentStep          ?? this.currentStep,
      );
}
