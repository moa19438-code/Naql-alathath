import { UsersService } from './users.service';
import { UserRole } from './user.model';

export class UsersController {
  private service = new UsersService();

  createUser(name: string, phone: string, role: UserRole) {
    return this.service.create(name, phone, role);
  }

  getUsers() {
    return this.service.findAll();
  }
}
