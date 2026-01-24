export interface Order {
  id: number;
  customerName: string;
  pickup: string;
  dropoff: string;
  workers: number;
  vehicle: 'small' | 'truck';
  price: number;
  status: 'pending' | 'accepted' | 'completed';
}

export class OrdersService {
  private orders: Order[] = [];

  create(data: Omit<Order, 'id' | 'price' | 'status'>): Order {
    const price =
      data.workers * 50 +
      (data.vehicle === 'truck' ? 150 : 80);

    const order: Order = {
      id: Date.now(),
      ...data,
      price,
      status: 'pending',
    };

    this.orders.push(order);
    return order;
  }

  list(): Order[] {
    return this.orders;
  }
}
assignDriver(orderId: number, driverId: number) {
  const order = this.orders.find(o => o.id === orderId);
  if (!order) return null;

  order.status = 'accepted';
  return order;
}

complete(orderId: number) {
  const order = this.orders.find(o => o.id === orderId);
  if (!order) return null;

  order.status = 'completed';
  return order;
}
