export interface Law {
  Chapter: string;
  Category: string;
  Title: string;
  Description: string;
  Compound_Fine?: string;
  Second_Compound_Fine?: string;
  Third_Compound_Fine?: string;
  Fourth_Compound_Fine?: string;
  Fifth_Compound_Fine?: string;
}

export type UserRole = 'admin' | 'officer';

export interface AdminUser {
  Username: string;
  role: UserRole;
  isAdmin: number;
}

export interface User {
  id: number;
  Username: string;
  Role: UserRole;
  created_at: string;
}

export interface ApiResponse {
  success: boolean;
  message: string;
}

export interface LawCountResponse {
  success: boolean;
  total_laws: number;
}
