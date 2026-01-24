import { Driver } from './driver.model';

export class DriversService {
  private drivers: Driver[] = [];

  register(name: string, vehicleType: 'small' | 'truck'): Driver {
    const driver: Driver = {
      id: Date.now(),
      name,
      vehicleType,
      available: true,
    };
    this.drivers.push(driver);
    return driver;
  }

  findAvailable(vehicleType: 'small' | 'truck'): Driver | null {
    return this.drivers.find(
      d => d.available && d.vehicleType === vehicleType
    ) || null;
  }

  setAvailability(driverId: number, status: boolean) {
    const driver = this.drivers.find(d => d.id === driverId);
    if (driver) driver.available = status;
    return driver;
  }
}
