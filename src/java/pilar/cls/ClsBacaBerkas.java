/* Nama berkas: ClsBacaBerkas.java
 * Fungsi: membaca berkas
 * Pemrogram: I Made Ariana 
 * Hari,tanggal,jam: Senin, 02 Maret 2015, 09.10 WIB
 * E-mail: i.made43@ui.ac.id / made.ariana@mail.ugm.ac.id
 */

package pilar.cls;

import java.io.File;
import java.util.regex.Pattern;

public class ClsBacaBerkas {
    
    /* ################################################
     * fDirektori: membaca letak direktori 
     * Parameter masukan: -
     * Keluaran: -
       ################################################ */
    public String fDirektori(){
        String vKeluaran = "";
        try{
            String currentDir = new File(".").getAbsolutePath();
            String pattern = Pattern.quote(System.getProperty("file.separator"));
            String[] arrCd = currentDir.split(pattern);
            
            vKeluaran = arrCd[0] + File.separator + 
                arrCd[1] + File.separator + 
                arrCd[2] + File.separator +
                "webapps" + File.separator +
                "SRHotel" + File.separator;
        }catch(Exception e){
            /* pencatatan sistem */
            if(ClsKonf.vKonfCatatSistem == true){
                String vNamaKelas = "ClsBacaBerkas.java";
                String vNamaMetode = "fDirektori";
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
