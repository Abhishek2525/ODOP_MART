//package com.bs.bharatmata;
//
//public class Encrypter {
//    //new
//    private final static int IV_LENGTH = 16; // Default length with Default 128
//    private final static String ALGO_RANDOM_NUM_GENERATOR = "SHA1PRNG";
//    private final static String ALGO_SECRET_KEY_GENERATOR = "AES";
//
//    private final static int DEFAULT_READ_WRITE_BLOCK_BUFFER_SIZE = 1024;
//    private final static String ALGORITHM_VIDEO_ENCRYPTOR = "AES/CBC/PKCS5Padding";
//
//    //new
//    AlgorithmParameterSpec paramSpec;
//    public Encrypter() throws NoSuchAlgorithmException {
//        byte[] iv = new byte[IV_LENGTH];
//        SecureRandom.getInstance(ALGO_RANDOM_NUM_GENERATOR).nextBytes(iv);
//        paramSpec = new IvParameterSpec(iv);
//    }
//
//    @SuppressWarnings("resource")
//    public static void encrypt(SecretKey key, AlgorithmParameterSpec paramSpec, InputStream in, OutputStream out)
//            throws NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException,
//            InvalidAlgorithmParameterException, IOException {
//        try {
//            Cipher c = Cipher.getInstance(ALGORITHM_VIDEO_ENCRYPTOR);
//            c.init(Cipher.ENCRYPT_MODE, key, paramSpec);
//            out = new CipherOutputStream(out, c);
//            int count; // new te count = 0;
//            byte[] buffer = new byte[DEFAULT_READ_WRITE_BLOCK_BUFFER_SIZE];
//            while ((count = in.read(buffer)) >= 0) {
//                out.write(buffer, 0, count);
//            }
//        } finally {
//            out.close();
//        }
//    }                                                                                          //String encrypted_path
//    @SuppressWarnings("resource")
//    public static void decrypt(SecretKey key, AlgorithmParameterSpec paramSpec, InputStream in, OutputStream out)
//            throws NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException,       //old e OutputStream out er jaygay String encrypted_path clo
//            InvalidAlgorithmParameterException, IOException {
//
//        try {
//            Cipher c = Cipher.getInstance(ALGORITHM_VIDEO_ENCRYPTOR);
//            c.init(Cipher.DECRYPT_MODE, key, paramSpec);
//            out = new CipherOutputStream(out, c);
//            int count = 0; //new te 0 init
//
//
//            byte[] buffer = new byte[DEFAULT_READ_WRITE_BLOCK_BUFFER_SIZE];
//            while ((count = in.read(buffer)) >= 0) {
//                out.write(buffer, 0, count);
//            }
//        }
//        finally {
//            out.close();
//        }
//    }
//
//    //new
//    public String encryptFile(String path, Uri encrypted) {
//
//        File inFile = new File(path);
//        String sKey = "";
//        File outFile = new File(encrypted.getPath());
//
//        try {
//            SecretKey key = KeyGenerator.getInstance(ALGO_SECRET_KEY_GENERATOR).generateKey();
//            byte[] keyData = key.getEncoded();
//            SecretKey key2 = new SecretKeySpec(keyData, 0, keyData.length, ALGO_SECRET_KEY_GENERATOR);
//
//            sKey = Base64.encodeToString(key2.getEncoded(), Base64.DEFAULT);
//            encrypt(key, paramSpec, new FileInputStream(inFile), new FileOutputStream(outFile));
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//
//        return sKey;
//
//    }
//    public void decryptFile(Uri uri, String uriOut, String secretKey) {
//
//        File inFile = new File(uri.getPath());
//        File outFile = new File(uriOut);
//
//        byte[] encodedKey = Base64.decode(secretKey, Base64.DEFAULT);
//        SecretKey key2 = new SecretKeySpec(encodedKey, 0, encodedKey.length, "AES");
//
//        try {
//            decrypt(key2, paramSpec, new FileInputStream(inFile), new FileOutputStream(outFile));
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//
//
//    }
//
//
//}
