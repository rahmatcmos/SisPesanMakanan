/* Nama berkas: ClsOperator.java
 * Fungsi: menangani otentifikasi admin
 * Pemrogram: I Made Ariana 
 * Hari,tanggal,jam: Minggu, 01 Maret 2015, 21.56 WIB
 * E-mail: i.made43@ui.ac.id / made.ariana@mail.ugm.ac.id
 */

package pilar.cls;

import javax.servlet.http.HttpSession;
import org.w3c.dom.DOMException;

public class ClsOperator {
    
    /* ################################################
     * fHalamanOperator: validasi halaman admin 
     * Parameter Masukan:
     * 1) vFSesi (HttpSession): data sesi.
     * Keluaran:
     * 1) vKeluaran (boolean): true-> nilai sesi valid, false-> nilai sesi tidak valid.
       ################################################ */
    public boolean fHalamanOperator(HttpSession vFSesi) {
        boolean vKeluaran = false;
        
        try{
            String vID = vFSesi.getAttribute("sesIDOp").toString();
            String vSandi = vFSesi.getAttribute("sesSandiOp").toString();
            String vKodeOperator = vFSesi.getAttribute("sesKodeOp").toString();
            String vJenisOperator = vFSesi.getAttribute("sesJenisOp").toString();
            String vNamaDB = "";
            String vSandiDB = "";

            //String vKeluaran = "fHalamanOperator -> ID: " + vID + " & sandi: " + vSandi;
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
            ClsSHA oSHA = new ClsSHA();
            vNamaDB = oSHA.fSHA256(oOpsBasisdata.fAmbilSatuData("", "", "tb_resto_operator", "kode", "kode", vKodeOperator));
            vSandiDB = oOpsBasisdata.fAmbilSatuData("", "", "tb_resto_operator", "sandi", "kode", vKodeOperator);
            		

             /* mencocokkan data */
            if (vID != null && vNamaDB !=null && vSandi != null && vSandiDB != null) {
                /* sebelum divalidasi */
                /* apabila data POST sesuai dgn data dalam tabel basisdata: lupa password jadi di NOT */
                if(vID.equals(vNamaDB) && vSandi.equals(vSandiDB)){
                    vKeluaran = true;
                }
            }
        }catch(DOMException e){
            /* pencatatan sistem */
            if(ClsKonf.vKonfCatatSistem == true){
                String vNamaKelas = "ClsOperator.java";
                String vNamaMetode = "fHalamanOperator";
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
