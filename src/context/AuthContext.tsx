// 전역 인증 상태 관리 — Supabase Auth 연동 후 구현
// TODO: Supabase 설정 완료 후 실제 구현으로 교체

import React, { createContext, useContext, useState } from 'react';

type User = {
  id: string;
  email: string;
};

type AuthContextType = {
  user: User | null;
  isLoading: boolean;
  signIn: (email: string, password: string) => Promise<void>;
  signOut: () => Promise<void>;
};

const AuthContext = createContext<AuthContextType | null>(null);

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [user, setUser] = useState<User | null>(null);
  const [isLoading, setIsLoading] = useState(false);

  const signIn = async (_email: string, _password: string) => {
    // TODO: Supabase signInWithPassword 호출
    setIsLoading(true);
    throw new Error('아직 구현되지 않은 기능입니다.');
  };

  const signOut = async () => {
    // TODO: Supabase signOut 호출
    setUser(null);
  };

  return (
    <AuthContext.Provider value={{ user, isLoading, signIn, signOut }}>
      {children}
    </AuthContext.Provider>
  );
}

// 인증 상태를 사용하는 모든 화면에서 이 훅을 호출한다
export function useAuth() {
  const context = useContext(AuthContext);
  if (!context) throw new Error('useAuth는 AuthProvider 안에서만 사용할 수 있습니다.');
  return context;
}
