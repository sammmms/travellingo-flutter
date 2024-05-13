// City (Aswin)
List<Map<String, dynamic>> japanCities = [
  {"country": "Japan", "city": "Tokyo"},
  {"country": "Japan", "city": "Osaka"},
  {"country": "Japan", "city": "Kyoto"},
  {"country": "Japan", "city": "Yokohama"},
  {"country": "Japan", "city": "Nagoya"},
  {"country": "Japan", "city": "Sapporo"},
  {"country": "Japan", "city": "Fukuoka"},
  {"country": "Japan", "city": "Kobe"},
  {"country": "Japan", "city": "Sendai"},
  {"country": "Japan", "city": "Hiroshima"},
  {"country": "Japan", "city": "Nara"},
  {"country": "Japan", "city": "Kanazawa"},
  {"country": "Japan", "city": "Nagasaki"},
  {"country": "Japan", "city": "Okinawa"},
  {"country": "Japan", "city": "Miyazaki"},
  {"country": "Japan", "city": "Kagoshima"},
  {"country": "Japan", "city": "Naha"},
  {"country": "Japan", "city": "Kumamoto"},
  {"country": "Japan", "city": "Niigata"},
  {"country": "Japan", "city": "Matsuyama"},
  {"country": "Japan", "city": "Kochi"},
  {"country": "Japan", "city": "Toyama"},
  {"country": "Japan", "city": "Akita"},
  {"country": "Japan", "city": "Shizuoka"},
  {"country": "Japan", "city": "Iwaki"},
  {"country": "Japan", "city": "Utsunomiya"},
  {"country": "Japan", "city": "Himeji"},
  {"country": "Japan", "city": "Kawasaki"},
  {"country": "Japan", "city": "Yokosuka"},
  {"country": "Japan", "city": "Nagano"}
  // Add more cities here if needed
];

// Transaction (Giovanny)
final List<Map<String, dynamic>> transactions = [
  {
    "name": "Himeji Castle",
    "ticket": 1,
    "date": "18 Oct 22",
    "time": "19:00",
    "price": 25.00,
    "status": false,
    "image": "https://example.com/images/himeji.jpg"
  },
  {
    "name": "Cherry Blossom",
    "ticket": 1,
    "date": "18 Oct 22",
    "time": "19:00",
    "price": 25.00,
    "status": true,
    "image": "https://example.com/images/himeji.jpg"
  },
  {
    "name": "Earthquake Museum",
    "ticket": 1,
    "date": "18 Oct 22",
    "time": "19:00",
    "price": 25.00,
    "status": false,
    "image": "https://example.com/images/himeji.jpg"
  },
];

// Tickets (Giovanny)
final List<Map<String, dynamic>> tickets = [
  {
    "origin": "Kobe",
    "destination": "Himeji Castle",
    "departureTime": "19:00 PM",
    "arrivalTime": "19:10 PM",
    "date": "01 April 2024",
    "duration": "10m",
    "price": 25.00,
    "status": false,
    "image":
        "https://i.pinimg.com/originals/2f/88/4b/2f884b66c1a53b93a9e4826e5f4c459d.png",
    "available": "5 left"
  },
  {
    "origin": "Osaka",
    "destination": "Cherry Blossom Park",
    "departureTime": "10:00 AM",
    "arrivalTime": "10:30 AM",
    "date": "01 April 2024",
    "duration": "30m",
    "price": 15.00,
    "status": true,
    "image": "https://download.logo.wine/logo/Lion_Air/Lion_Air-Logo.wine.png",
    "available": "Available"
  },
  {
    "origin": "Tokyo",
    "destination": "Earthquake Museum",
    "departureTime": "14:00 PM",
    "arrivalTime": "14:45 PM",
    "date": "01 April 2024",
    "duration": "45m",
    "price": 30.00,
    "status": false,
    "image": "https://airhex.com/images/airline-logos/citilink.png",
    "available": "5 left"
  },
];

// Dates (Giovanny)
final List<String> dates = [
  "Mon, 01 Apr",
  "Tue, 02 Apr",
  "Wed, 03 Apr",
  "Thu, 04 Apr",
  "Fri, 05 Apr",
  "Sat, 06 Apr",
  "Sun, 07 Apr",
];

// Purchases (Giovanny)
final List<Map<String, dynamic>> purchases = [
  {
    "status": "Payment Success",
    "type": "Flight",
    "date": "01 April 2024",
    "price": 475.22,
    "invoice": "Invoice Number INV567489240UI",
    "image":
        "https://example.com/path-to-your-image.jpg", // Replace with your actual image URL
  },
  {
    "status": "Payment Success",
    "type": "Flight",
    "date": "01 April 2024",
    "price": 475.22,
    "invoice": "Invoice Number INV567489240UI",
    "image":
        "https://example.com/path-to-your-image.jpg", // Replace with your actual image URL
  },
  {
    "status": "Payment Success",
    "type": "Flight",
    "date": "01 April 2024",
    "price": 475.22,
    "invoice": "Invoice Number INV567489240UI",
    "image":
        "https://example.com/path-to-your-image.jpg", // Replace with your actual image URL
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
