/* Nama berkas: ClsKonf.java
 * Fungsi: konfigurasi sistem secara umum
 * Pemrogram: I Made Ariana 
 * Hari,tanggal,jam: Rabu, 04 Maret 2015, 18.00 WIB
 * E-mail: i.made43@ui.ac.id / made.ariana@mail.ugm.ac.id
 */


package pilar.cls;

import java.io.File;

public class ClsKonf {
    /* Direktori */
    public static String vKonfDirSistem = "SisPesanMakanan";
    /* ##Tema## */
    public static String vKonfTema = "standar";
    
    /* ##Basisdata## */
    public static String vKonfBerkasBdStd = "basisdataKonf";
    public static String vKonfBdStd = "dbsispesanan";
    
    /* ##URL## */
    public static String vKonfWSPort = "8080";
    public static String vKonfURL = "http://localhost:"+ vKonfWSPort + "/"+ vKonfDirSistem;
    public static String vKonfURLDesainHalamanAdPubGambarTombol = vKonfURL + "/pilar/desain/" + vKonfTema + "/halaman/adpub/gambar/tombol"; 
    
    /* ##Direktori## */
     
    //linux
    /* public static String vKonfDirPilar = File.separator + "home" +
            File.separator + "ariana" +
            File.separator + "Project" +
            File.separator + "Java Web" + 
            File.separator + "SisPesanMakanan" + 
            File.separator + "web" + 
            File.separator + "pilar";
    
        public static String vKonfDirFoto = File.separator + "home" +
            File.separator + "ariana" +
            File.separator + "Project" +
            File.separator + "Java Web" + 
            File.separator + "SisPesanMakanan" + 
            File.separator + "web" + 
            File.separator + "foto";
    */
    
    // windows
    public static String vKonfDirPilar = "D:" + File.separator + "Projects" + 
            File.separator + "Java Web" + 
            File.separator + vKonfDirSistem + 
            File.separator + "web" + 
            File.separator + "pilar"; 
    
    public static String vKonfDirFoto = "D:" + File.separator + "Projects" + 
            File.separator + "Java Web" + 
            File.separator + vKonfDirSistem + 
            File.separator + "web" + 
            File.separator + "foto"; 
    
    public static String vKonf = vKonfDirPilar + File.separator + "konf";
    
    public static String vKonfDirDesain = vKonfDirPilar + File.separator + "desain" + File.separator + "halaman";
    public static String vKonfDirDesainAdPubGambar = vKonfDirDesain + File.separator + 
                "adpub" + File.separator + "gambar";
    public static String vKonfDirDesainAdPubGambarTombol = vKonfDirDesainAdPubGambar + File.separator + "tombol";    
    
    public static String vKonfDirBd = vKonf + File.separator + "basisdata";
    
    public static String vKonfDirCaptcha = vKonfDirPilar + 
            File.separator + "desain" + File.separator + "standar" + File.separator + "halaman" + 
            File.separator + "adpub" + File.separator + "gambar" + File.separator + "captcha"; 
    
    /* catatan sistem */
    public static boolean vKonfCatatSistem = true;
    public static boolean vKonfCatatKeOutput = true;
    public static boolean vKonfCatatKeBD = true;
    public static boolean vKonfCatatKeBerkas = true;
}