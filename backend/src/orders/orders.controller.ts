import { OrdersService } from './orders.service';

export class OrdersController {
  private service = new OrdersService();

  createOrder(data: {
    customerName: string;
    pickup: string;
    dropoff: string;
    workers: number;
    vehicle: 'small' | 'truck';
  }) {
    return this.service.create(data);
  }

  getOrders() {
    return this.service.list();
  }
}
acceptOrder(orderId: number, driverId: number) {
  return this.service.assignDriver(orderId, driverId);
}

completeOrder(orderId: number) {
  return this.service.complete(orderId);
}
