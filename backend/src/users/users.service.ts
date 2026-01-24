import { User, UserRole } from './user.model';

export class UsersService {
  private users: User[] = [];

  create(name: string, phone: string, role: UserRole): User {
    const user: User = {
      id: Date.now(),
      name,
      phone,
      role,
    };
    this.users.push(user);
    return user;
  }

  findAll(): User[] {
    return this.users;
  }
}
