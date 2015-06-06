/* Nama berkas: ClsKode.java
 * Fungsi: menangani pembuatan kode acak
 * Pemrogram: I Made Ariana 
 * Hari,tanggal,jam: Rabu, 04 Maret 2015, 09.00 WIB
 * E-mail: i.made43@ui.ac.id / made.ariana@mail.ugm.ac.id
 */


package pilar.cls;

import java.security.SecureRandom;
import java.util.Random;

/**
 *
 * @author PERSEUS
 */
public class ClsKode {
    public String fBuatKodeAcak(int vFBanyakKarakter){
        String vNilaiKeluaran = "";
        
        try{
            Random vNilaiAcak = new SecureRandom();
            String vAbjadNum = "abcdefghjkmnpqrstuvwxyzABCDEFGHJKMNPQRSTUVWXYZ0123456789";

            for (int i=0; i<vFBanyakKarakter; i++){
                int index = (int)(vNilaiAcak.nextDouble()*vAbjadNum.length());
                vNilaiKeluaran += vAbjadNum.substring(index, index+1);
            }
        }catch(Exception e){
            /* pencatatan sistem */
            if(ClsKonf.vKonfCatatSistem == true){
                String vNamaKelas = "ClsKode.java";
                String vNamaMetode = "fBuatKodeAcak";
                String vCatatan = vNamaKelas + "#" + vNamaMetode + "#" + e.toString();
                /* obyek catat */
                ClsCatat oCatat = new ClsCatat();
                oCatat.fCatatSistem(ClsKonf.vKonfCatatKeOutput, 
                        ClsKonf.vKonfCatatKeBD, 
                        ClsKonf.vKonfCatatKeBerkas, 
                        vCatatan);
            }
        }
        return vNilaiKeluaran;
    }
}
