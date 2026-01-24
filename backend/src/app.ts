// Naql Alathath Backend (API Core)

import { OrdersController } from './orders/orders.controller';

const ordersController = new OrdersController();

console.log("Naql Alathath Backend Ready");

// مثال اختبار
console.log(
  ordersController.createOrder({
    customerName: "Mohammed",
    pickup: "Riyadh",
    dropoff: "Jeddah",
    workers: 3,
    vehicle: "truck"
  })
);
