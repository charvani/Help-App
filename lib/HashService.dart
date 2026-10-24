import 'package:payu_checkoutpro_flutter/PayUConstantKeys.dart';
//Remove this plugin when you implement the salt at your server..
import 'package:crypto/crypto.dart';
import 'dart:convert';

class HashService {
//Find the test credentials from dev guide: https://devguide.payu.in/flutter-sdk-integration/getting-started-flutter-sdk/mobile-sdk-test-environment/
//Keep the hash in backend for Security reasons.
  static const merchantSalt =
      "MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDeajq0GTiuDn8ouBHK/WkO0ErFY7v35bInLj7a6IEjh5hdGtUrCumtRHH0cKG9w+uQDd7GoVnL4THQjqzeAjz1B30kdk+Uo6LvrQmP7mO5yXU79Cylw3IH8D4ETdHZu222zjaLGYofzfFTPispP+L/YQIwX70p1gfVuLGcPRL2AiuwqbxOSd6/b8TAd/fXBkRzNJhpRYD+H+yprsuQldOjl3w+AOilbKuhAlx+H4x8j1ZsmBZkoppDu/7FcKw65F0yV83uxqDD+Yk/CudigbJbQGnajS+VxgvCI7Cv8HgfFGV1XzUvCRUZy3sZWgAcnZgLOoVXqzC/ktS7hrS6iW8DAgMBAAECggEAKCT6ZYlr3pbFQt8+buogbUkRReGDivINnt7M/4wZywTtbliqgzNcDCcffmRZ/TuAqCaowCddYtxJtoAaGZRD1mI8pzknkgebIDGWWUFJBL6lB2ZCLMVDLsWhG/vD1c3rtqQv2hmJAcaVOVYuSiq62Sd0UrDlHsj/7waAIFgxtO9HGpGXWXpSjeoZmvy/b/qBKHpIpk7OAd7CRBW7UoDv1tmHeapqBmGUddjsyjeWcF2yXH4RwcwKebf8DtzkXcN8mfZKe84XwMJFhrnXc3Y2RO9ADgwDPWW0MQ6n4fsAqpRzKHgAh09wOz+PXoUcB6PUBbUqYQnELhipVOzbjvLCmQKBgQD7rx048k2406IVd0N/Aa611JovFSzLgvGPAeDFaf6fmgTY0EnkLP3B6bBTwuZ/jI7TIz/FSNLzc162AJoRezwVQZic1e3DePt0A3eP2qHF7J4qE2Na5Zcaaepv6Z9qnzC9mTU0lkrDBUhcgIojbLwziIVadj6e4qomjd+Y56OIlQKBgQDiOp/tchENp9WSm9jadxJoqQvrZ3S+jlxaAFzfTHrNSX6XU54Mst/dU+lh73q9mZVp8KBQPvCmPBvNHIKQkBeODMZ0KaZ4bI7sw0Lfx8/I3yNMikikdinB9FQnrZqvfzdDbConZL00hjjrFn8rd+V39HPZ0/ArHGi/MprIuUn7NwKBgQDZ72ehgQdWDUPjzJMQrjdH0iH0tSRF0Uw0Zg7pQwAt2aNqzum9AEx3llCOJ02Kkv61y2cUARxRnMwdU2YVzx1W1qc8323z/pXWfo4QbeP5TAwlKQa2leoDAEX1xFm7bL863iiZMa7pMnDXUKLNTAGnqga3L37H/EQUAHPmpmYQBQKBgDN2/LzqryB5Juf0Vk/UuLZghpql7XQQNMgwvu/5mRIsfwTz+8eNxcm29ifWcAjD8K6qE/5NYzeeAwEVVEqIzSL+mwMAGqPYpmcMQKFh9k4PHRujdcUcMIG0EJT6NG9qNGs9JxXRIA3b3wT0GDgOTYCNdvF9+mwESXv9iiLRrBffAoGABziIbtM/KETf756rqGg9rYyPM8tKsEpfRwMACslSfhUFxoN5Hz8PeBbb9FLu3y3+gJvu7TNwa21uxAa7fzWwkdcoMv65QGnMxmQXC/z541OICncsUeFwaqJTlh1muzTQkH1WeiGzVSTRJ1EellOctPDWKdzN3QO0puc5+XrOmQw="; // Add you Salt here.
  static const merchantSecretKey = ""; // Add Merchant Secrete Key - Optional

  static Map generateHash(Map response) {
    var hashName = response[PayUHashConstantsKeys.hashName];
    var hashStringWithoutSalt = response[PayUHashConstantsKeys.hashString];
    var hashType = response[PayUHashConstantsKeys.hashType];
    var postSalt = response[PayUHashConstantsKeys.postSalt];

    var hash = "";

    if (hashType == PayUHashConstantsKeys.hashVersionV2) {
      hash = getHmacSHA256Hash(hashStringWithoutSalt, merchantSalt);
    } else if (hashName == PayUHashConstantsKeys.mcpLookup) {
      hash = getHmacSHA1Hash(hashStringWithoutSalt, merchantSecretKey);
    } else {
      var hashDataWithSalt = hashStringWithoutSalt + merchantSalt;
      if (postSalt != null) {
        hashDataWithSalt = hashDataWithSalt + postSalt;
      }
      hash = getSHA512Hash(hashDataWithSalt);
    }
    //Don't use this method, get the hash from your backend.
    var finalHash = {hashName: hash};
    return finalHash;
  }

  //Don't use this method get the hash from your backend.
  static String getSHA512Hash(String hashData) {
    var bytes = utf8.encode(hashData); // data being hashed
    var hash = sha512.convert(bytes);
    return hash.toString();
  }

  //Don't use this method get the hash from your backend.
  static String getHmacSHA256Hash(String hashData, String salt) {
    var key = utf8.encode(salt);
    var bytes = utf8.encode(hashData);
    final hmacSha256 = Hmac(sha256, key).convert(bytes).bytes;
    final hmacBase64 = base64Encode(hmacSha256);
    return hmacBase64;
  }

  static String getHmacSHA1Hash(String hashData, String salt) {
    var key = utf8.encode(salt);
    var bytes = utf8.encode(hashData);
    var hmacSha1 = Hmac(sha1, key); // HMAC-SHA1
    var hash = hmacSha1.convert(bytes);
    return hash.toString();
  }
}
