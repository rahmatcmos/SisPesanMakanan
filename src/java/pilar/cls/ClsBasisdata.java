/* Nama berkas: ClsBasisdata.java
 * Fungsi: menangani koneksi aplikasi ke server basisdata
 * Pemrogram: I Made Ariana 
 * Hari,tanggal,jam: Senin, 02 Maret 2015, 16.00 WIB
 * E-mail: i.made43@ui.ac.id / made.ariana@mail.ugm.ac.id
 */

package pilar.cls;

import java.io.IOException;
import java.sql.*;
import javax.xml.parsers.ParserConfigurationException;
import org.w3c.dom.DOMException;
import org.xml.sax.SAXException;

public class ClsBasisdata {
    /* variabel class */
    public Connection vPrvKoneksi = null;
    boolean vPrvStatusKoneksi;
    
    /* fSambungkanKeServerBD: */
    public Connection fSambungkanKeServerBD(            
        String vFNamaBerkasKonf, 
        String vFNamaBd){     
        
        try{
            /* berkas konfigurasi basisdata */
            vFNamaBerkasKonf = (vFNamaBerkasKonf.equals("")) ? ClsKonf.vKonfBerkasBdStd : vFNamaBerkasKonf;
            /* basisdata */
            vFNamaBd = (vFNamaBd.equals("")) ? ClsKonf.vKonfBdStd : vFNamaBd;

            /* baca berkas konfigurasi */
            ClsBerkasXML myClass = new ClsBerkasXML();
            String[] vDataKonfBD = myClass.fKonfBasisdata(vFNamaBerkasKonf, vFNamaBd);

            Class.forName("com.mysql.jdbc.Driver"); /* */

            if(this.vPrvStatusKoneksi == false){                
                vPrvKoneksi = DriverManager.getConnection("jdbc:mysql://" + vDataKonfBD[0] 
                        + ":" 
                        + vDataKonfBD[1] 
                        + "/" 
                        + vDataKonfBD[2], 
                        vDataKonfBD[3], vDataKonfBD[4]);
            }

            /*System.out.println("jdbc:mysql://" + vDataKonfBD[0] 
                        + ":" 
                        + vDataKonfBD[1] 
                        + "/" 
                        + vDataKonfBD[2]+" " + 
                        vDataKonfBD[3]+ " " + vDataKonfBD[4]);*/

            /* keluaran akhir */
            vPrvStatusKoneksi = !vPrvKoneksi.isClosed();
        }catch(DOMException | SAXException | ClassNotFoundException | ParserConfigurationException | IOException | SQLException e){
            /* pencatatan sistem */
            if(ClsKonf.vKonfCatatSistem == true){
                String vNamaKelas = "ClsBasisdata.java";
                String vNamaMetode = "fSambungkanKeServerBD";
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
        return (vPrvStatusKoneksi) ? vPrvKoneksi : null;
    }
    
   
    
}
