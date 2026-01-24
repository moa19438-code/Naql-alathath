import { DriversService } from './drivers.service';

export class DriversController {
  private service = new DriversService();

  registerDriver(name: string, vehicleType: 'small' | 'truck') {
    return this.service.register(name, vehicleType);
  }

  findAvailableDriver(vehicleType: 'small' | 'truck') {
    return this.service.findAvailable(vehicleType);
  }
}
