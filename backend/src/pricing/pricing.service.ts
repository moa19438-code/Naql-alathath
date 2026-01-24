export class PricingService {
  calculate(distanceKm: number, workers: number, vehicle: string): number {
    let price = distanceKm * 5;
    price += workers * 40;
    if (vehicle === 'truck') price += 100;
    return price;
  }
}
