// FeedbackAgent: 대화 종료 후 문법/표현/자연스러움 종합 피드백 생성
// TODO: Supabase Edge Function 연동 후 구현

import type { Message } from './conversationService';

export type GrammarError = {
  original: string;   // 사용자가 말한 문장
  corrected: string;  // 수정된 문장
  explanation: string;
};

export type Feedback = {
  grammarErrors: GrammarError[];
  expressionSuggestions: string[];  // 더 자연스러운 표현 제안
  naturalnessScore: number;         // 0–100
  overallComment: string;
};

export async function generateFeedback(_messages: Message[]): Promise<Feedback> {
  // TODO: POST /functions/v1/feedback 호출
  throw new Error('아직 구현되지 않은 기능입니다.');
}
