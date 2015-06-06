/* Nama berkas: ClsSHA.java
 * Fungsi: menangani hashing string - SHA
 * Pemrogram: I Made Ariana 
 * Hari,tanggal,jam: Kamis, 05 Maret 2015, 06.00 WIB
 * E-mail: i.made43@ui.ac.id / made.ariana@mail.ugm.ac.id
 */

package pilar.cls;

import java.security.MessageDigest;

public class ClsSHA {
    
    /* ################################################
     * fSHA256: membuat hashing 
     * parameter:
     * 1) vFKata (String): kata yang hendak di-hash.
       ################################################ */
    public String fSHA256(String vFKata){        
        String vKeluaran = ""; 
        
        try{
            if(!vFKata.equals("")) {       
                MessageDigest vMd = MessageDigest.getInstance("SHA-256");
                vMd.update(vFKata.getBytes());
                byte vByteData[] = vMd.digest();

                //convert the byte to hex format method 1
                StringBuilder vSb = new StringBuilder();
                for (int i = 0; i < vByteData.length; i++) {
                    vSb.append(Integer.toString((vByteData[i] & 0xff) + 0x100, 16).substring(1));
                }

                /* convert the byte to hex format method 2 */
                StringBuilder vHexString = new StringBuilder();
                for (int i=0;i<vByteData.length;i++) {
                    String vStrHex = Integer.toHexString(0xff & vByteData[i]);
                    if(vStrHex.length()==1) vHexString.append('0');
                    vHexString.append(vStrHex);
                }
                /* keluaran */
            vKeluaran = vHexString.toString();
            }
        }catch(Exception e){
            /* pencatatan sistem */
            if(ClsKonf.vKonfCatatSistem == true){
                String vNamaKelas = "ClsSHA.java";
                String vNamaMetode = "fSHA256";
                String vCatatan = vNamaKelas + "#" + vNamaMetode + "#" + e.toString();
                /* obyek catat */
                ClsCatat oCatat = new ClsCatat();
                oCatat.fCatatSistem(ClsKonf.vKonfCatatKeOutput, 
                        ClsKonf.vKonfCatatKeBD, 
                        ClsKonf.vKonfCatatKeBerkas, 
                        vCatatan);
            }
        }
        
        /* keluaran akhir */
    	return vKeluaran;
    }
    
}
