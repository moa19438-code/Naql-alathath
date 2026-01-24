export type UserRole = 'customer' | 'driver' | 'company';

export interface User {
  id: number;
  name: string;
  phone: string;
  role: UserRole;
}
