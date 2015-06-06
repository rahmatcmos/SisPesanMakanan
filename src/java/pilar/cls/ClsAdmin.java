/* Nama berkas: ClsAdmin.java
 * Fungsi: menangani otentifikasi admin
 * Pemrogram: I Made Ariana 
 * Hari,tanggal,jam: Minggu, 01 Maret 2015, 21.56 WIB
 * E-mail: i.made43@ui.ac.id / made.ariana@mail.ugm.ac.id
 */

package pilar.cls;

import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.http.HttpSession;
import org.w3c.dom.DOMException;

public class ClsAdmin {
    
    /* ################################################
     * fHalamanAdmin: validasi halaman admin 
     * Parameter Masukan:
     * 1) vFSesi (HttpSession): data sesi.
     * Keluaran:
     * 1) vKeluaran (boolean): true-> nilai sesi valid, false-> nilai sesi tidak valid.
       ################################################ */
    public boolean fHalamanAdmin(HttpSession vFSesi) {
        boolean vKeluaran = false;
        
        try{
            String vID = vFSesi.getAttribute("sesID").toString();
            String vSandi = vFSesi.getAttribute("sesSandi").toString();
            String vNamaDB = "";
            String vSandiDB = "";

            //String vKeluaran = "fHalamanAdmin -> ID: " + vID + " & sandi: " + vSandi;
            /* mencocokkan data session dengan basisdata */
            /* mengambil data nama dan sandi */
            ClsOperasiBasisdataOri oOpsBasisdata = new ClsOperasiBasisdataOri();

            /* 
                String vFNamaBerkasKonf,
                String vFNamaBd,
                String vFNamaTabel,
                String[] vFArrNamaKolom,
                String vFKolomUrut,
                String vFJenisUrut,
                String[] vFOffset
            */

            ResultSet vHasil = oOpsBasisdata.fArrAmbilDataDbStd("","", 
                    "tb_admin", new String[]{"nama","sandi"}, "nomor", "", new String[]{"0","1"});

            /* keluaran permintaan */
            while(vHasil.next()){
                vNamaDB = vHasil.getString("nama");
                vSandiDB = vHasil.getString("sandi");
            }			

             /* mencocokkan data */
            if (vID != null && vNamaDB !=null && vSandi != null && vSandiDB != null) {
                /* sebelum divalidasi */
                /* apabila data POST sesuai dgn data dalam tabel basisdata: lupa password jadi di NOT */
                if(vID.equals(vNamaDB) && vSandi.equals(vSandiDB)){
                    vKeluaran = true;
                }
            }
        }catch(SQLException | DOMException e){
            /* pencatatan sistem */
            if(ClsKonf.vKonfCatatSistem == true){
                String vNamaKelas = "ClsAdmin.java";
                String vNamaMetode = "fHalamanAdmin";
                String vCatatan = vNamaKelas + "#" + vNamaMetode + "#" + e.toString();
                /* obyek catat */
                ClsCatat oCatat = new ClsCatat();
                oCatat.fCatatSistem(ClsKonf.vKonfCatatKeOutput, 
                        ClsKonf.vKonfCatatKeBD, 
                        ClsKonf.vKonfCatatKeBerkas, 
                        vCatatan);
            }
        }
        
        /* debug nilai id dan password */
        //System.out.println("Belum divalidasi : " + vID + " = " + vNamaDB + " & " + vSandi + " = " + vSandiDB);
        /* nilai keluaran */
        return vKeluaran;
    }
    
}
