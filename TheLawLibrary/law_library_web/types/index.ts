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

export interface AdminUser {
  Username: string;
  isAdmin: number;
}

export interface ApiResponse {
  success: boolean;
  message: string;
}

export interface LawCountResponse {
  success: boolean;
  total_laws: number;
}
