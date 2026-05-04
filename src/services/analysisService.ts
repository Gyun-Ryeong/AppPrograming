// AnalysisAgent: 누적 대화 데이터 기반 약점 패턴 분석 (유료 기능)
// TODO: Supabase Edge Function 연동 후 구현

export type WeaknessPattern = {
  category: string;    // 예: "시제 오류", "관사 누락"
  frequency: number;   // 전체 오류 대비 비율 (0–1)
  examples: string[];  // 실제 오류 예시
};

export type AnalysisReport = {
  totalSessions: number;
  weaknessPatterns: WeaknessPattern[];
  improvementTrend: 'improving' | 'stable' | 'declining';
  recommendedScenario: string;  // 약점 기반 추천 연습 상황
};

export async function getAnalysisReport(_userId: string): Promise<AnalysisReport> {
  // TODO: POST /functions/v1/analysis 호출
  throw new Error('유료 기능입니다. 결제 후 이용 가능합니다.');
}
