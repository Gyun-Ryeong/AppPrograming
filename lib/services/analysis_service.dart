// AnalysisAgent: 누적 대화 데이터 기반 약점 패턴 분석 (유료 기능)
// TODO: Supabase Edge Function 연동 후 구현

import '../models/analysis_report.dart';

class AnalysisService {
  static const String _functionUrl = 'https://<project>.supabase.co/functions/v1/analysis';

  /// 사용자의 누적 피드백 데이터를 분석해 약점 리포트를 반환한다
  Future<AnalysisReport> getAnalysisReport({
    required String userId,
  }) async {
    // TODO: POST _functionUrl 호출 구현
    throw UnimplementedError('유료 기능입니다. 결제 후 이용 가능합니다.');
  }
}
