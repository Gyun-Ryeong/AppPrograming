// ConversationAgent: 시나리오 맥락을 유지하며 실시간 대화 진행
// TODO: Supabase Edge Function 연동 후 구현

import type { Scenario } from './scenarioService';

export type Message = {
  role: 'user' | 'assistant';
  content: string;
};

export type ConversationInput = {
  scenario: Scenario;
  history: Message[];  // 이전 대화 히스토리
  userMessage: string;
};

export async function sendMessage(_input: ConversationInput): Promise<string> {
  // TODO: POST /functions/v1/conversation 호출
  throw new Error('아직 구현되지 않은 기능입니다.');
}
