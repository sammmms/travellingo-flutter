List<Map<String, String>> indonesiaAirport = [
  {'kodeBandara': 'BPN', 'kota': 'Balikpapan'},
  {'kodeBandara': 'BTJ', 'kota': 'Banda Aceh'},
  {'kodeBandara': 'TKG', 'kota': 'Bandar Lampung'},
  {'kodeBandara': 'BDO', 'kota': 'Bandung'},
  {'kodeBandara': 'BTH', 'kota': 'Batam'},
  {'kodeBandara': 'BKS', 'kota': 'Bengkulu'},
  {'kodeBandara': 'BMU', 'kota': 'Bima'},
  {'kodeBandara': 'DPS', 'kota': 'Denpasar'},
  {'kodeBandara': 'GTO', 'kota': 'Gorontalo'},
  {'kodeBandara': 'HLP', 'kota': 'Jakarta'},
  {'kodeBandara': 'DJB', 'kota': 'Jambi'},
  {'kodeBandara': 'DJJ', 'kota': 'Jayapura'},
  {'kodeBandara': 'KTG', 'kota': 'Ketapang'},
  {'kodeBandara': 'YIA', 'kota': 'Kulon Progo'},
  {'kodeBandara': 'KOE', 'kota': 'Kupang'},
  {'kodeBandara': 'LBJ', 'kota': 'Labuan Bajo'},
  {'kodeBandara': 'UPG', 'kota': 'Makassar'},
  {'kodeBandara': 'MLG', 'kota': 'Malang'},
  {'kodeBandara': 'MDC', 'kota': 'Manado'},
  {'kodeBandara': 'MKW', 'kota': 'Manokwari'},
  {'kodeBandara': 'AMI', 'kota': 'Mataram'},
  {'kodeBandara': 'MOF', 'kota': 'Maumere'},
  {'kodeBandara': 'KNO', 'kota': 'Medan'},
  {'kodeBandara': 'MWK', 'kota': 'Morowali'},
  {'kodeBandara': 'MEQ', 'kota': 'Nagan Raya'},
  {'kodeBandara': 'NAH', 'kota': 'Naha'},
  {'kodeBandara': 'PDG', 'kota': 'Padang'},
  {'kodeBandara': 'PKY', 'kota': 'Palangkaraya'},
  {'kodeBandara': 'PLM', 'kota': 'Palembang'},
  {'kodeBandara': 'PLW', 'kota': 'Palu'},
  {'kodeBandara': 'PGK', 'kota': 'Pangkal Pinang'},
  {'kodeBandara': 'PKN', 'kota': 'Pangkalan Bun'},
  {'kodeBandara': 'PKU', 'kota': 'Pekanbaru'},
  {'kodeBandara': 'PNK', 'kota': 'Pontianak'},
  {'kodeBandara': 'LOP', 'kota': 'Praya'},
  {'kodeBandara': 'RGT', 'kota': 'Rengat'},
  {'kodeBandara': 'SRI', 'kota': 'Samarinda'},
  {'kodeBandara': 'SRG', 'kota': 'Semarang'},
  {'kodeBandara': 'SOC', 'kota': 'Solo'},
  {'kodeBandara': 'SOQ', 'kota': 'Sorong'},
  {'kodeBandara': 'SUB', 'kota': 'Surabaya'},
  {'kodeBandara': 'CGK', 'kota': 'Tangerang'},
  {'kodeBandara': 'TNJ', 'kota': 'Tanjung Pinang'},
  {'kodeBandara': 'TRK', 'kota': 'Tarakan'},
  {'kodeBandara': 'TTE', 'kota': 'Ternate'},
  {'kodeBandara': 'TIM', 'kota': 'Timika'},
  {'kodeBandara': 'TLC', 'kota': 'Tual'},
  {'kodeBandara': 'WMX', 'kota': 'Wamena'},
  {'kodeBandara': 'JOG', 'kota': 'Yogyakarta'}
];

// Purchases (Giovanny)
final List<Map<String, dynamic>> purchases = [
  {
    "status": "Payment Success",
    "type": "Flight",
    "date": "01 April 2024",
    "price": 475.22,
    "invoice": "Invoice Number INV567489240UI",
    "brand": "Garuda Indonesia",
    "image":
        "https://i.pinimg.com/originals/2f/88/4b/2f884b66c1a53b93a9e4826e5f4c459d.png", // Replace with your actual image URL
  },
  {
    "status": "Payment Success",
    "type": "Flight",
    "date": "01 April 2024",
    "price": 475.22,
    "invoice": "Invoice Number INV567489240UI",
    "brand": "Lion Air",
    "image":
        "https://download.logo.wine/logo/Lion_Air/Lion_Air-Logo.wine.png", // Replace with your actual image URL
  },
  {
    "status": "Payment Success",
    "type": "Flight",
    "date": "01 April 2024",
    "price": 475.22,
    "invoice": "Invoice Number INV567489240UI",
    "brand": "Lion Air",
    "image":
        "https://download.logo.wine/logo/Lion_Air/Lion_Air-Logo.wine.png", // Replace with your actual image URL
  },
  // Add more purchase maps if necessary
];

// Payment Methods (Giovanny)
List<String> eMoneyPaymentMethods = [
  'Paypal',
  'Gopay',
  'Apple Pay',
  'Amazon Pay'
];

// Basket Data (Giovanny)
List<Map<String, dynamic>> baskets = [
  {
    "castleName": "Himeji Castle",
    "departure": "KOBE",
    "arrival": "HCL",
    "departureTime": "12:00",
    "arrivalTime": "01:15",
    "duration": "1h 15m",
    "price": 301.24,
    "ticketsLeft": "2",
    "passengerCount": 1,
    "transport": "Aircraft"
  },
  {
    "castleName": "Himeji Castle",
    "departure": "KOBE",
    "arrival": "HCL",
    "departureTime": "12:00",
    "arrivalTime": "01:15",
    "duration": "1h 15m",
    "price": 475.22,
    "ticketsLeft": "2",
    "passengerCount": 1,
    "transport": "Aircraft"
  },
  {
    "castleName": "Himeji Castle",
    "departure": "KOBE",
    "arrival": "HCL",
    "departureTime": "04:45",
    "arrivalTime": "05:50",
    "duration": "1h 15m",
    "price": 154.24,
    "ticketsLeft": "2",
    "passengerCount": 1,
    "transport": "Aircraft"
  },
  {
    "castleName": "Himeji Castle",
    "departure": "KOBE",
    "arrival": "HCL",
    "departureTime": "04:45",
    "arrivalTime": "05:50",
    "duration": "1h 15m",
    "price": 154.24,
    "ticketsLeft": "2",
    "passengerCount": 1,
    "transport": "Aircraft"
  },
  {
    "castleName": "Himeji Castle",
    "departure": "KOBE",
    "arrival": "HCL",
    "departureTime": "04:45",
    "arrivalTime": "05:50",
    "duration": "1h 15m",
    "price": 154.24,
    "ticketsLeft": "2",
    "passengerCount": 1,
    "transport": "Aircraft"
  },
  {
    "castleName": "Himeji Castle",
    "departure": "KOBE",
    "arrival": "HCL",
    "departureTime": "04:45",
    "arrivalTime": "05:50",
    "duration": "1h 15m",
    "price": 154.24,
    "ticketsLeft": "2",
    "passengerCount": 1,
    "transport": "Aircraft"
  },
  // Add more basket items here
];

// Seats (Giovanny)
List<String> occupiedSeats = [
  '8D',
  '1C',
  '2A',
  '3D',
  '3E',
  '3F',
  '5C',
  '6A',
  '6F',
  '9A',
  '9C',
  '9F',
  '4B',
  '3B'
];
