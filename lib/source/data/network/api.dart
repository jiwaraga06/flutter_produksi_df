

class API {
  static String apiToken() {
    return "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7ImlkIjoxLCJuYW1hIjoicm9vdCIsImVtYWlsIjoicm9vdEBsb2NhbGhvc3QifSwiaWF0IjoxNTkyMjM1MzE2fQ.KHYQ0M1vcLGSjJZF-zvTM5V44hM0B8TqlTD0Uwdh9rY";
  }
  static String apiLogin() {
    return "https://api2.sipatex.co.id:2096/imap-auth";
  }
  static String apiHasil_DF(String email) {
    return "http://192.168.50.95/simr/public/api/v1/mobile-app/pes_dy/hasil_df?email=$email";
  }
  static String apiCariMesin(String q) {
    // return "http://192.168.50.95/simr/public/api/v1/mobile-app/mt/cari-mesin?q=$q";
    return "https://satu.sipatex.co.id:2087/api/v1/mobile-app/mt/cari-mesin?q=$q";
  }
}
