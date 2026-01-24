export interface Driver {
  id: number;
  name: string;
  vehicleType: 'small' | 'truck';
  available: boolean;
}
