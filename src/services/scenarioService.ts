// ScenarioAgent: 사용자 상황 입력 → 대화 시나리오 생성
// TODO: Supabase Edge Function 연동 후 구현

export type ScenarioInput = {
  situation: string; // 사용자가 입력한 상황 (예: "카페에서 음료 주문하기")
  difficulty: 'beginner' | 'intermediate' | 'advanced';
  category: 'daily' | 'business' | 'travel' | 'academic';
};

export type Scenario = {
  id: string;
  background: string;  // 배경 설명
  userRole: string;    // 사용자 역할
  aiRole: string;      // AI 파트너 역할
  goal: string;        // 대화 목표
};

export async function generateScenario(_input: ScenarioInput): Promise<Scenario> {
  // TODO: POST /functions/v1/scenario 호출
  throw new Error('아직 구현되지 않은 기능입니다.');
}
