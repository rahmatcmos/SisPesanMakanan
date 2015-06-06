/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package pilar.cls;

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.xml.parsers.ParserConfigurationException;
import org.w3c.dom.DOMException;
import org.xml.sax.SAXException;

/**
 *
 * @author PERSEUS
 */
public class ClsOperasiBasisdataOri {
    public Connection vPrvKoneksi;
    
    /* fOperasiBdDasar: operasi INPUT, UPDATE, DELETE */
    public void fOperasiBdDasar( 
            String vFNamaBerkasKonf,
            String vFNamaBd,
            String vFNamaTabel,
            String[] vFArrKolomRef,
            String[] vFArrDataRef,
            String[] vFData, 
            String vFOperasi,
            boolean vFDataUnik) {
        
        try{
            /* variabel fungsi */        
            String vKalimatSQL = "";
            Statement vPernyataanSQL = null;

            /* sambungkan ke basisdata (BD) */
            if(!vFOperasi.equals("")){
                /* pemilihan berkas konfigurasi basisdata */
                vFNamaBerkasKonf = (vFNamaBerkasKonf.equals("")) ?  ClsKonf.vKonfBerkasBdStd : vFNamaBerkasKonf;
                /* pemilihan basisdata*/ 
                vFNamaBd = (vFNamaBd.equals("")) ? ClsKonf.vKonfBdStd : vFNamaBd ;

                /* membuat koneksi ke server basisdata */
                ClsBasisdata oBasisdata = new ClsBasisdata();
                Connection vKoneksiBD = oBasisdata.fSambungkanKeServerBD(vFNamaBerkasKonf, vFNamaBd);
                this.vPrvKoneksi = vKoneksiBD;

                /* vPrvStatusKoneksi -> true ? */
                if(vKoneksiBD != null){   
                    ClsBerkasXML oBerkasXml = new ClsBerkasXML(); /* xml tabel */

                    /* ambil skema tabel */
                    String vTabel[] = oBerkasXml.fKonfBasisdata(vFNamaBerkasKonf, vFNamaBd);
                    String vKolomTabel[] = oBerkasXml.fKolomTabel(vFNamaBd, vFNamaTabel);                        
                    vPernyataanSQL = vKoneksiBD.createStatement();                

                    /* klausa where untuk update dan hapus */
                    /* iterasi */
                    StringBuilder vSbSQL = new StringBuilder();
                    int m = 0;
                    boolean vKondisiPertama = true;
                    for(String vNamaKolom: vFArrKolomRef){
                        if(vKondisiPertama){
                            vSbSQL.append("`").append(vFNamaBd).append("`.`").append(vFNamaTabel).append("`.`"); 
                            vSbSQL.append(vNamaKolom).append("`='").append(vFArrDataRef[m]).append("'");
                            vKondisiPertama = false;
                        }else{
                            vSbSQL.append(" AND `").append(vFNamaBd).append("`.`").append(vFNamaTabel).append("`.`"); 
                            vSbSQL.append(vNamaKolom).append("`='").append(vFArrDataRef[m]).append("'");
                        }
                        /* inc i */
                        m +=1;
                    }

                    /* operasi basisdata */
                    switch(vFOperasi){
                        case "t":                        
                            /* operasi INSERT */
                            /* menyusun kalimat SQL */
                            if(vFData.length > 0){
                                boolean vPertama = true;
                                String vStrNilaiAkhir = "";
                                StringBuilder vSbNilai = new StringBuilder();

                                for (String vStrData : vFData) {

                                    if (vPertama) {
                                        if(vStrData.equals("null") || vStrData.equals(null)){
                                            vSbNilai.append(vStrData);
                                        }else{
                                            vSbNilai.append("'").append(vStrData).append("'");
                                        }
                                        /* tandai urutan pertama sudah lewat */
                                        vPertama = false;
                                    } else {
                                        if(vStrData.equals("null") || vStrData.equals(null)){
                                            vSbNilai.append(",").append(vStrData);
                                        }else{
                                            vSbNilai.append(",'").append(vStrData).append("'");
                                        }
                                    }
                                }

                                vStrNilaiAkhir = vSbNilai.toString();                            

                                /* kalimat SQL akhir */
                                vKalimatSQL = "INSERT INTO `" + 
                                    vFNamaBd + "`.`" + 
                                    vFNamaTabel + "` (" + vKolomTabel[1] + ") " + 
                                    "VALUE ("+ vStrNilaiAkhir + ")";  
                            }

                            break;
                        case "h":
                            /* operasi DELETE */
                            vKalimatSQL = "DELETE FROM `" + vFNamaBd + "`.`" + vFNamaTabel + "` "+
                                    "WHERE "; 
                            vKalimatSQL = vKalimatSQL + vSbSQL.toString();
                            break;

                        case "u":
                            /* operasi UBAH */
                            /* kolom tabel */
                            String[] vArrKolom = null;
                            if(vKolomTabel.length > 0){
                                vArrKolom = vKolomTabel[1].split(",");
                            }

                            /* membuat pra kalimat SQL */
                            if(vFData.length > 0){
                                boolean vPertama = true;
                                String vStrNilaiAkhir = "";
                                StringBuilder vSbNilai = new StringBuilder();

                                int i = 0;
                                for (String vStrData : vFData) {
                                    if(!vStrData.equals("null")){
                                        if (vPertama) {
                                            if(!vStrData.equals("") && !vArrKolom[i].equals(vTabel[0])){
                                                vSbNilai.append(vArrKolom[i]).append("='").append(vStrData).append("'");
                                                vPertama = false;
                                            }                                    
                                        } else {
                                            if(!vStrData.equals("") && !vArrKolom[i].equals(vTabel[0])){
                                                vSbNilai.append(", ").append(vArrKolom[i]).append("='").append(vStrData).append("'");
                                            }
                                        }
                                    }

                                    /* indeks */
                                    i += 1;
                                }

                                vStrNilaiAkhir = vSbNilai.toString();

                                /* kalimat SQL akhir */
                                vKalimatSQL = "UPDATE `" + vFNamaBd + "`.`" + vFNamaTabel + "` SET " + vStrNilaiAkhir +
                                    " WHERE ";

                                vKalimatSQL = vKalimatSQL + vSbSQL.toString();
                            }                      
                            break;
                    }

                    /* eksekusi kalimat SQL */
                    if(!vKalimatSQL.equals("") && vFOperasi.equals("t")){
                        if(vFDataUnik){
                            /* lakukan pemeriksaan keberadaan data */
                            boolean vStatusDataAda = this.fDataAdaArr(vFNamaBerkasKonf, vFNamaBd, vFNamaTabel, vFArrKolomRef, vFArrDataRef);

                            if(!vStatusDataAda){
                                /* data belum ada */
                                vPernyataanSQL.execute(vKalimatSQL);
                            }
                        }else{
                            vPernyataanSQL.execute(vKalimatSQL);
                        }                    
                    }

                    if(!vKalimatSQL.equals("") && vFOperasi.equals("u")){
                        vPernyataanSQL.executeUpdate(vKalimatSQL);
                    }

                    if(!vKalimatSQL.equals("") && vFOperasi.equals("h")){
                        vPernyataanSQL.execute(vKalimatSQL);
                    }
                }            

            }   
        
        }catch(DOMException | SAXException | ClassNotFoundException | ParserConfigurationException | IOException | SQLException e){
            /* pencatatan sistem */
            if(ClsKonf.vKonfCatatSistem == true){
                String vNamaKelas = "ClsOperasiBasisdata.java";
                String vNamaMetode = "fOperasiBdDasar";
                String vCatatan = vNamaKelas + "#" + vNamaMetode + "#" + e.toString();
                /* obyek catat */
                ClsCatat oCatat = new ClsCatat();
                oCatat.fCatatSistem(ClsKonf.vKonfCatatKeOutput, 
                        ClsKonf.vKonfCatatKeBD, 
                        ClsKonf.vKonfCatatKeBerkas, 
                        vCatatan);
            }
        }
    }
    
    /* fArrAmbilDataBdStd: */
    public ResultSet fArrAmbilDataDbStd(
            String vFNamaBerkasKonf,
            String vFNamaBd,
            String vFNamaTabel,
            String[] vFArrNamaKolom,
            String vFKolomUrut,
            String vFJenisUrut,
            String[] vFOffset){
            
            ResultSet vArrHasil = null;
         
            try{
                vFNamaBd = (vFNamaBd.equals(""))? ClsKonf.vKonfBdStd : vFNamaBd;
                vFJenisUrut = (vFJenisUrut.equals("")) ? "ASC" : vFJenisUrut;

                /* membuat koneksi ke server basisdata */
                ClsBasisdata oBasisdata = new ClsBasisdata();
                Connection vKoneksiBD = oBasisdata.fSambungkanKeServerBD(vFNamaBerkasKonf, vFNamaBd);
                this.vPrvKoneksi = vKoneksiBD;

                /* membuat kalimat SQL */
                StringBuilder vSbDbTb = new StringBuilder();
                StringBuilder vSbSQL = new StringBuilder();

                if(vFArrNamaKolom.length > 0){

                    boolean vKolomPertama = true;

                    /* nama basisdata & tabel */
                    vSbDbTb.append("`");
                    vSbDbTb.append(vFNamaBd);
                    vSbDbTb.append("`.`");
                    vSbDbTb.append(vFNamaTabel);
                    vSbDbTb.append("`");
                    String vDbTabel = vSbDbTb.toString();

                    /* kalimat SQL */
                    vSbSQL.append("SELECT ");

                    /* iterasi nama kolom */
                    for(String vNamaKolom: vFArrNamaKolom){                  

                        if(vKolomPertama){
                            vSbSQL.append(vDbTabel);
                            vSbSQL.append(".`");
                            vSbSQL.append(vNamaKolom);
                            vSbSQL.append("`");
                            /* menandai kolom pertama sudah lewat */
                            vKolomPertama = false;
                        }else{
                            vSbSQL.append(",");
                            vSbSQL.append(vDbTabel);
                            vSbSQL.append(".`");
                            vSbSQL.append(vNamaKolom);
                            vSbSQL.append("`");
                        }
                    }

                    /* lanjutan SQL */
                    vSbSQL.append(" FROM ");
                    vSbSQL.append(vDbTabel);
                    vSbSQL.append(" WHERE ");
                    vSbSQL.append(vDbTabel);
                    vSbSQL.append(".`");
                    vSbSQL.append(vFArrNamaKolom[0]);
                    vSbSQL.append("`");
                    vSbSQL.append("!=''");

                    /* urutan data */
                    if(!vFKolomUrut.equals("")){
                        vSbSQL.append(" ORDER BY ");
                        vSbSQL.append(vDbTabel);
                        vSbSQL.append(".`");
                        vSbSQL.append(vFKolomUrut);
                        vSbSQL.append("` ");
                        vSbSQL.append(vFJenisUrut);
                    }

                    /* apabila ada offset */
                    if(vFOffset.length > 1){
                        vSbSQL.append(" LIMIT ");
                        vSbSQL.append(vFOffset[0]);
                        vSbSQL.append(",");
                        vSbSQL.append(vFOffset[1]);
                    }

                }

                /* eksekusi kalimat SQL */
                if(vKoneksiBD != null){
                    Statement vPernyataanSQL = vKoneksiBD.createStatement();
                    vArrHasil = vPernyataanSQL.executeQuery(vSbSQL.toString());

                }
            }catch(Exception e){
                /* pencatatan sistem */
                if(ClsKonf.vKonfCatatSistem == true){
                    String vNamaKelas = "ClsOperasiBasisdata.java";
                    String vNamaMetode = "fArrAmbilDataDbStd";
                    String vCatatan = vNamaKelas + "#" + vNamaMetode + "#" + e.toString();
                    /* obyek catat */
                    ClsCatat oCatat = new ClsCatat();
                    oCatat.fCatatSistem(ClsKonf.vKonfCatatKeOutput, 
                            ClsKonf.vKonfCatatKeBD, 
                            ClsKonf.vKonfCatatKeBerkas, 
                            vCatatan);
                }
            }
            
            //System.out.println(vSbSQL);
            /* keluaran akhir */
            return vArrHasil;
    }
    
    /* fAmbilDataDbKondisi */
    public ResultSet fArrAmbilDataDbKondisi(
            String vFNamaBerkasKonf,
            String vFNamaBd,
            String vFNamaTabel,
            String[] vFArrNamaKolom,
            String[] vFArrKolomDataRef,
            String vFKolomUrut,
            String vFJenisUrut,
            String[] vFOffset,
            String vFKondisi){
            
            ResultSet vArrHasil = null;
         
            try{
                vFNamaBd = (vFNamaBd.equals(""))? ClsKonf.vKonfBdStd : vFNamaBd;
                vFJenisUrut = (vFJenisUrut.equals("")) ? "ASC" : vFJenisUrut;

                /* membuat koneksi ke server basisdata */
                ClsBasisdata oBasisdata = new ClsBasisdata();
                Connection vKoneksiBD = oBasisdata.fSambungkanKeServerBD(vFNamaBerkasKonf, vFNamaBd);
                this.vPrvKoneksi = vKoneksiBD;

                /* membuat kalimat SQL */
                StringBuilder vSbDbTb = new StringBuilder();
                StringBuilder vSbSQL = new StringBuilder();

                if(vFArrNamaKolom.length > 0){

                    boolean vKolomPertama = true;

                    /* nama basisdata & tabel */
                    vSbDbTb.append("`");
                    vSbDbTb.append(vFNamaBd);
                    vSbDbTb.append("`.`");
                    vSbDbTb.append(vFNamaTabel);
                    vSbDbTb.append("`");
                    String vDbTabel = vSbDbTb.toString();

                    /* kalimat SQL */
                    vSbSQL.append("SELECT ");

                    /* iterasi nama kolom */
                    for(String vNamaKolom: vFArrNamaKolom){                  

                        if(vKolomPertama){
                            vSbSQL.append(vDbTabel);
                            vSbSQL.append(".`");
                            vSbSQL.append(vNamaKolom);
                            vSbSQL.append("`");
                            /* menandai kolom pertama sudah lewat */
                            vKolomPertama = false;
                        }else{
                            vSbSQL.append(",");
                            vSbSQL.append(vDbTabel);
                            vSbSQL.append(".`");
                            vSbSQL.append(vNamaKolom);
                            vSbSQL.append("`");
                        }
                    }

                    /* lanjutan SQL */
                    vSbSQL.append(" FROM ");
                    vSbSQL.append(vDbTabel);
                    vSbSQL.append(" WHERE ");
                    vSbSQL.append(vDbTabel);
                    vSbSQL.append(".`");
                    vSbSQL.append(vFArrKolomDataRef[0]);
                    vSbSQL.append("`");

                    /* kondisi: %LIKE% */
                    if(vFKondisi.equals("%LIKE%")){
                        vSbSQL.append("LIKE '%");
                        vSbSQL.append(vFArrKolomDataRef[1]);
                        vSbSQL.append("%'");
                    }

                    /* kondisi: = */
                    if(vFKondisi.equals("=")){
                        vSbSQL.append("= '");
                        vSbSQL.append(vFArrKolomDataRef[1]);
                        vSbSQL.append("'");
                    }
                    /* urutan data */
                    if(!vFKolomUrut.equals("")){
                        vSbSQL.append(" ORDER BY ");
                        vSbSQL.append(vDbTabel);
                        vSbSQL.append(".`");
                        vSbSQL.append(vFKolomUrut);
                        vSbSQL.append("` ");
                        vSbSQL.append(vFJenisUrut);
                    }

                    /* apabila ada offset */
                    if(vFOffset.length > 0){
                        vSbSQL.append(" LIMIT ");
                        vSbSQL.append(vFOffset[0]);
                        vSbSQL.append(",");
                        vSbSQL.append(vFOffset[1]);
                    }

                }

                /* eksekusi kalimat SQL */
                if(vKoneksiBD != null){
                    Statement vPernyataanSQL = vKoneksiBD.createStatement();
                    vArrHasil = vPernyataanSQL.executeQuery(vSbSQL.toString());
                }            
                
                System.out.println(vSbSQL.toString());
            }catch(Exception e){
                /* pencatatan sistem */
                if(ClsKonf.vKonfCatatSistem == true){
                    String vNamaKelas = "ClsOperasiBasisdata.java";
                    String vNamaMetode = "fArrAmbilDataDbKondisi";
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
            return vArrHasil;
    }
    
     /* fAmbilDataDbKondisi */
    public ResultSet fArrAmbilDataDbKondisiArr(
            String vFNamaBerkasKonf,
            String vFNamaBd,
            String vFNamaTabel,
            String[] vFArrNamaKolom,
            String[] vFArrKolomRef,
            String[] vFArrDataRef,
            String vFKolomUrut,
            String vFJenisUrut,
            String[] vFOffset,
            String vFKondisi){
            
            ResultSet vArrHasil = null;
            
            try{
                vFNamaBd = (vFNamaBd.equals(""))? ClsKonf.vKonfBdStd : vFNamaBd;
                vFJenisUrut = (vFJenisUrut.equals("")) ? "ASC" : vFJenisUrut;

                /* membuat koneksi ke server basisdata */
                ClsBasisdata oBasisdata = new ClsBasisdata();
                Connection vKoneksiBD = oBasisdata.fSambungkanKeServerBD(vFNamaBerkasKonf, vFNamaBd);
                this.vPrvKoneksi = vKoneksiBD;

                /* membuat kalimat SQL */
                StringBuilder vSbDbTb = new StringBuilder();
                StringBuilder vSbSQL = new StringBuilder();

                if(vFArrNamaKolom.length > 0){

                    boolean vKolomPertama = true;

                    /* nama basisdata & tabel */
                    vSbDbTb.append("`");
                    vSbDbTb.append(vFNamaBd);
                    vSbDbTb.append("`.`");
                    vSbDbTb.append(vFNamaTabel);
                    vSbDbTb.append("`");
                    String vDbTabel = vSbDbTb.toString();

                    /* kalimat SQL */
                    vSbSQL.append("SELECT ");

                    /* iterasi nama kolom */
                    for(String vNamaKolom: vFArrNamaKolom){                  

                        if(vKolomPertama){
                            vSbSQL.append(vDbTabel);
                            vSbSQL.append(".`");
                            vSbSQL.append(vNamaKolom);
                            vSbSQL.append("`");
                            /* menandai kolom pertama sudah lewat */
                            vKolomPertama = false;
                        }else{
                            vSbSQL.append(",");
                            vSbSQL.append(vDbTabel);
                            vSbSQL.append(".`");
                            vSbSQL.append(vNamaKolom);
                            vSbSQL.append("`");
                        }
                    }

                    /* lanjutan SQL */
                    vSbSQL.append(" FROM ");
                    vSbSQL.append(vDbTabel);
                    vSbSQL.append(" WHERE ");

                    int n = 0;
                    boolean vKolomRefPertama = true;
                    for(String vKolomRef: vFArrKolomRef){
                        if(vKolomRefPertama){
                            /* klausa kondisi */
                            vSbSQL.append(vDbTabel);
                            vSbSQL.append(".`");
                            vSbSQL.append(vKolomRef);
                            vSbSQL.append("` ");

                            if(vFKondisi.equals("%LIKE%")){
                                vSbSQL.append("LIKE '%");
                                vSbSQL.append(vFArrDataRef[n]);
                                vSbSQL.append("%'");
                            }

                            if(vFKondisi.equals("=")){
                                vSbSQL.append("= '");
                                vSbSQL.append(vFArrDataRef[n]);
                                vSbSQL.append("'");
                            }
                            /* tandai kolom pertama sudah lewat */
                            vKolomRefPertama = false;
                        }else{
                            /* klausa kondisi */
                            vSbSQL.append(" AND ");
                            vSbSQL.append(vDbTabel);
                            vSbSQL.append(".`");
                            vSbSQL.append(vKolomRef);
                            vSbSQL.append("` ");

                            if(vFKondisi.equals("%LIKE%")){
                                vSbSQL.append("LIKE '%");
                                vSbSQL.append(vFArrDataRef[n]);
                                vSbSQL.append("%'");
                            }

                            if(vFKondisi.equals("=")){
                                vSbSQL.append("= '");
                                vSbSQL.append(vFArrDataRef[n]);
                                vSbSQL.append("'");
                            }
                        }


                        /* inc i */
                        n += 1;
                    }


                    /* urutan data */
                    if(!vFKolomUrut.equals("")){
                        vSbSQL.append(" ORDER BY ");
                        vSbSQL.append(vDbTabel);
                        vSbSQL.append(".`");
                        vSbSQL.append(vFKolomUrut);
                        vSbSQL.append("` ");
                        vSbSQL.append(vFJenisUrut);
                    }

                    /* apabila ada offset */
                    if(vFOffset.length > 0){
                        vSbSQL.append(" LIMIT ");
                        vSbSQL.append(vFOffset[0]);
                        vSbSQL.append(",");
                        vSbSQL.append(vFOffset[1]);
                    }

                }

                /* eksekusi kalimat SQL */
                if(vKoneksiBD != null){
                    Statement vPernyataanSQL = vKoneksiBD.createStatement();
                    vArrHasil = vPernyataanSQL.executeQuery(vSbSQL.toString());
                }
            }catch(Exception e){
                /* pencatatan sistem */
                if(ClsKonf.vKonfCatatSistem == true){
                    String vNamaKelas = "ClsOperasiBasisdata.java";
                    String vNamaMetode = "fArrAmbilDataDbKondisiArr";
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
            return vArrHasil;
    }
    
     /* fJumDataTotalStd */
    public Integer fJumDataTotalStd(
            String vFNamaBerkasKonf,
            String vFNamaBd,
            String vFNamaTabel,
            String[] vFArrNamaKolom){
            
            int i = 0;
            
            try{
                vFNamaBd = (vFNamaBd.equals(""))? ClsKonf.vKonfBdStd : vFNamaBd;

                /* membuat koneksi ke server basisdata */
                ClsBasisdata oBasisdata = new ClsBasisdata();
                Connection vKoneksiBD = oBasisdata.fSambungkanKeServerBD(vFNamaBerkasKonf, vFNamaBd);
                this.vPrvKoneksi = vKoneksiBD;

                /* membuat kalimat SQL */
                StringBuilder vSbDbTb = new StringBuilder();
                StringBuilder vSbSQL = new StringBuilder();

                if(vFArrNamaKolom.length > 0){

                    boolean vKolomPertama = true;

                    /* nama basisdata & tabel */
                    vSbDbTb.append("`");
                    vSbDbTb.append(vFNamaBd);
                    vSbDbTb.append("`.`");
                    vSbDbTb.append(vFNamaTabel);
                    vSbDbTb.append("`");
                    String vDbTabel = vSbDbTb.toString();

                    /* kalimat SQL */
                    vSbSQL.append("SELECT ");

                    /* iterasi nama kolom */
                    for(String vNamaKolom: vFArrNamaKolom){                  

                        if(vKolomPertama){
                            vSbSQL.append(vDbTabel);
                            vSbSQL.append(".`");
                            vSbSQL.append(vNamaKolom);
                            vSbSQL.append("`");
                            /* menandai kolom pertama sudah lewat */
                            vKolomPertama = false;
                        }else{
                            vSbSQL.append(",");
                            vSbSQL.append(vDbTabel);
                            vSbSQL.append(".`");
                            vSbSQL.append(vNamaKolom);
                            vSbSQL.append("`");
                        }
                    }

                    /* lanjutan SQL */
                    vSbSQL.append(" FROM ");
                    vSbSQL.append(vDbTabel);
                    vSbSQL.append(" WHERE ");
                    vSbSQL.append(vDbTabel);
                    vSbSQL.append(".`");
                    vSbSQL.append(vFArrNamaKolom[0]);
                    vSbSQL.append("`");
                    vSbSQL.append("!=''");

                }

                /* eksekusi kalimat SQL */
                ResultSet vArrHasil = null;
                if(vKoneksiBD != null){
                    Statement vPernyataanSQL = vKoneksiBD.createStatement();
                    vArrHasil = vPernyataanSQL.executeQuery(vSbSQL.toString());

                    vArrHasil.last();
                    i = vArrHasil.getRow();
                }
            }catch(Exception e){
                /* pencatatan sistem */
                if(ClsKonf.vKonfCatatSistem == true){
                    String vNamaKelas = "ClsOperasiBasisdata.java";
                    String vNamaMetode = "fJumDataTotalStd";
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
            return i;
    }
    
    public Integer fJumDataTotalKondisi(
            String vFNamaBerkasKonf,
            String vFNamaBd,
            String vFNamaTabel,
            String[] vFArrNamaKolom,
            String[] vFArrKolomRef,
            String[] vFArrKolomDataRef,
            String vFKondisi){
            
            int i = 0;
            
            try{
                vFNamaBd = (vFNamaBd.equals(""))? ClsKonf.vKonfBdStd : vFNamaBd;

                /* membuat koneksi ke server basisdata */
                ClsBasisdata oBasisdata = new ClsBasisdata();
                Connection vKoneksiBD = oBasisdata.fSambungkanKeServerBD(vFNamaBerkasKonf, vFNamaBd);
                this.vPrvKoneksi = vKoneksiBD;

                /* membuat kalimat SQL */
                StringBuilder vSbDbTb = new StringBuilder();
                StringBuilder vSbSQL = new StringBuilder();

                if(vFArrNamaKolom.length > 0){

                    boolean vKolomPertama = true;

                    /* nama basisdata & tabel */
                    vSbDbTb.append("`");
                    vSbDbTb.append(vFNamaBd);
                    vSbDbTb.append("`.`");
                    vSbDbTb.append(vFNamaTabel);
                    vSbDbTb.append("`");
                    String vDbTabel = vSbDbTb.toString();

                    /* kalimat SQL */
                    vSbSQL.append("SELECT ");

                    /* iterasi nama kolom */
                    for(String vNamaKolom: vFArrNamaKolom){                  

                        if(vKolomPertama){
                            vSbSQL.append(vDbTabel);
                            vSbSQL.append(".`");
                            vSbSQL.append(vNamaKolom);
                            vSbSQL.append("`");
                            /* menandai kolom pertama sudah lewat */
                            vKolomPertama = false;
                        }else{
                            vSbSQL.append(",");
                            vSbSQL.append(vDbTabel);
                            vSbSQL.append(".`");
                            vSbSQL.append(vNamaKolom);
                            vSbSQL.append("`");
                        }
                    }

                    /* lanjutan SQL */
                    vSbSQL.append(" FROM ");
                    vSbSQL.append(vDbTabel);
                    vSbSQL.append(" WHERE ");

                    /* iterasi ref */
                    int m = 0;
                    for(String vKolomRef: vFArrKolomRef){
                        vSbSQL.append(vDbTabel);
                        vSbSQL.append(".`");
                        vSbSQL.append(vKolomRef);
                        vSbSQL.append("` ");

                        /* kondisi */
                        if(vFKondisi.equals("=")){
                            vSbSQL.append("LIKE '%");
                            vSbSQL.append(vFArrKolomDataRef[m]);
                            vSbSQL.append("%'");
                        }

                        if(vFKondisi.equals("%LIKE%")){
                            vSbSQL.append("LIKE '%");
                            vSbSQL.append(vFArrKolomDataRef[m]);
                            vSbSQL.append("%'");
                        }

                        /* inc m */
                        m += 1;
                    }

                }

                /* eksekusi kalimat SQL */
                ResultSet vArrHasil = null;
                if(vKoneksiBD != null){
                    Statement vPernyataanSQL = vKoneksiBD.createStatement();
                    vArrHasil = vPernyataanSQL.executeQuery(vSbSQL.toString());

                    vArrHasil.last();
                    i = vArrHasil.getRow();
                }
            }catch(Exception e){
                /* pencatatan sistem */
                if(ClsKonf.vKonfCatatSistem == true){
                    String vNamaKelas = "ClsOperasiBasisdata.java";
                    String vNamaMetode = "fJumDataTotalKondisi";
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
            return i;
    }
    
    /* fDataAda: memeriksa keberadaan sebuah data sebelum dimasukkan ke basisdata,
     menghindari duplikasi data
    */
    public String fAmbilSatuData(String vFNamaBerkasKonf, 
            String vFNamaBd, 
            String vFNamaTabel, 
            String vFNamaKolomKeluaran,
            String vFNamaKolomRef, 
            String vFDataRef){
        
        String vKeluaranAkhir = "";
        
        try{
            /* alternatif masukan */
            vFNamaBerkasKonf = (vFNamaBerkasKonf.equals("")) ? ClsKonf.vKonfBerkasBdStd : vFNamaBerkasKonf;
            vFNamaBd = (vFNamaBd.equals("")) ? ClsKonf.vKonfBdStd : vFNamaBd;
            /* kalimat SQL */
            String vKalimatSQL = "SELECT `" + vFNamaBd + "`.`" + vFNamaTabel + "`.`" + vFNamaKolomKeluaran + "` " +
                    "FROM `" + vFNamaBd + "`.`" + vFNamaTabel + "` " + 
                    "WHERE `"+ vFNamaBd + "`.`" + vFNamaTabel + "`.`" + 
                    vFNamaKolomRef + "`='" + vFDataRef + "'";

            /* membuat koneksi ke server basisdata */
            ClsBasisdata oBasisdata = new ClsBasisdata();
            Connection vKoneksiBD = oBasisdata.fSambungkanKeServerBD(vFNamaBerkasKonf, vFNamaBd);
            this.vPrvKoneksi = vKoneksiBD;
            
             ResultSet vArrHasil = null;
            if(vKoneksiBD != null){
                Statement vPernyataanSQL = vKoneksiBD.createStatement();
                vArrHasil = vPernyataanSQL.executeQuery(vKalimatSQL);

                while(vArrHasil.next()){
                    vKeluaranAkhir = vArrHasil.getString(vFNamaKolomKeluaran);
                }
            }
        }catch(Exception e){
            /* pencatatan sistem */
            if(ClsKonf.vKonfCatatSistem == true){
                String vNamaKelas = "ClsOperasiBasisdata.java";
                String vNamaMetode = "fAmbilSatuData";
                String vCatatan = vNamaKelas + "#" + vNamaMetode + "#" + e.toString();
                /* obyek catat */
                ClsCatat oCatat = new ClsCatat();
                oCatat.fCatatSistem(ClsKonf.vKonfCatatKeOutput, 
                        ClsKonf.vKonfCatatKeBD, 
                        ClsKonf.vKonfCatatKeBerkas, 
                        vCatatan);
            }
        }
        /* nilai keluaran akhir */
        return vKeluaranAkhir;
    }
    /* fDataAda: memeriksa keberadaan data */
    public boolean fDataAda(String vFNamaBerkasKonf, 
            String vFNamaBd, 
            String vFNamaTabel, 
            String vFNamaKolom, 
            String vFData){
        
        boolean vKeluaranAkhir = false;
        
        try{
            /* alternatif masukan */
            vFNamaBerkasKonf = (vFNamaBerkasKonf.equals("")) ? ClsKonf.vKonfBerkasBdStd : vFNamaBerkasKonf;
            vFNamaBd = (vFNamaBd.equals("")) ? ClsKonf.vKonfBdStd : vFNamaBd;
            
            /* kalimat SQL */
            String vKalimatSQL = "SELECT COUNT(*) " +
                    "FROM `" + vFNamaBd + "`.`" + vFNamaTabel + "` " + 
                    "WHERE `"+ vFNamaBd + "`.`" + vFNamaTabel + "`.`" + 
                    vFNamaKolom + "`='" + vFData + "'";

            /* membuat koneksi ke server basisdata */
            ClsBasisdata oBasisdata = new ClsBasisdata();
            Connection vKoneksiBD = oBasisdata.fSambungkanKeServerBD(vFNamaBerkasKonf, vFNamaBd);            
            this.vPrvKoneksi = vKoneksiBD;
            
            ResultSet vArrHasil = null;
            if(vKoneksiBD != null){
                Statement vPernyataanSQL = vKoneksiBD.createStatement();
                vArrHasil = vPernyataanSQL.executeQuery(vKalimatSQL);
                vArrHasil.next();

                if(vArrHasil.getInt(1) > 0){
                    vKeluaranAkhir = true;
                }
            }
        }catch(Exception e){
            /* pencatatan sistem */
            if(ClsKonf.vKonfCatatSistem == true){
                String vNamaKelas = "ClsOperasiBasisdata.java";
                String vNamaMetode = "fDataAda";
                String vCatatan = vNamaKelas + "#" + vNamaMetode + "#" + e.toString();
                /* obyek catat */
                ClsCatat oCatat = new ClsCatat();
                oCatat.fCatatSistem(ClsKonf.vKonfCatatKeOutput, 
                        ClsKonf.vKonfCatatKeBD, 
                        ClsKonf.vKonfCatatKeBerkas, 
                        vCatatan);
            }
        }
        /* nilai keluaran akhir */
        return vKeluaranAkhir;
    }
    
    /*  fDataAdaArr: memeriksa keberadaan sebuah data sebelum dimasukkan ke basisdata,
        menghindari duplikasi data
    */
    private boolean fDataAdaArr(String vFNamaBerkasKonf, 
            String vFNamaBd, 
            String vFNamaTabel, 
            String[] vFArrNamaKolom, 
            String[] vFArrData){
        
        boolean vKeluaranAkhir = false;
        
        try{
            /* alternatif masukan */
            vFNamaBerkasKonf = (vFNamaBerkasKonf.equals("")) ? ClsKonf.vKonfBerkasBdStd : vFNamaBerkasKonf;
            vFNamaBd = (vFNamaBd.equals("")) ? ClsKonf.vKonfBdStd : vFNamaBd;



            /* kalimat SQL */
            StringBuilder vSbSQL = new StringBuilder();

            vSbSQL.append("SELECT COUNT(*) ");
            vSbSQL.append("FROM ");
            vSbSQL.append("`").append(vFNamaBd).append("`.`").append(vFNamaTabel).append("` "); 
            vSbSQL.append("WHERE ");

            /* iterasi */
            int i = 0;
            boolean vKondisiPertama = true;
            for(String vNamaKolom: vFArrNamaKolom){
                if(vKondisiPertama){
                    vSbSQL.append("`").append(vFNamaBd).append("`.`").append(vFNamaTabel).append("`.`"); 
                    vSbSQL.append(vNamaKolom).append("`='").append(vFArrData[i]).append("'");
                    vKondisiPertama = false;
                }else{
                    vSbSQL.append(" AND `").append(vFNamaBd).append("`.`").append(vFNamaTabel).append("`.`"); 
                    vSbSQL.append(vNamaKolom).append("`='").append(vFArrData[i]).append("'");
                }
                /* inc i */
                i +=1;
            }

            String vKalimatSQL = vSbSQL.toString();
            
            /* membuat koneksi ke server basisdata */
            ClsBasisdata oBasisdata = new ClsBasisdata();
            Connection vKoneksiBD = oBasisdata.fSambungkanKeServerBD(vFNamaBerkasKonf, vFNamaBd);
            this.vPrvKoneksi = vKoneksiBD;
            
            ResultSet vArrHasil = null;
            if(vKoneksiBD != null){
                Statement vPernyataanSQL = vKoneksiBD.createStatement();
                vArrHasil = vPernyataanSQL.executeQuery(vKalimatSQL);
                vArrHasil.next();

                if(vArrHasil.getInt(1) > 0){
                    vKeluaranAkhir = true;
                }
            }
        }catch(Exception e){
            /* pencatatan sistem */
            if(ClsKonf.vKonfCatatSistem == true){
                String vNamaKelas = "ClsOperasiBasisdata.java";
                String vNamaMetode = "fDataAdaArr";
                String vCatatan = vNamaKelas + "#" + vNamaMetode + "#" + e.toString();
                /* obyek catat */
                ClsCatat oCatat = new ClsCatat();
                oCatat.fCatatSistem(ClsKonf.vKonfCatatKeOutput, 
                        ClsKonf.vKonfCatatKeBD, 
                        ClsKonf.vKonfCatatKeBerkas, 
                        vCatatan);
            }
        }
        
        /* nilai keluaran akhir */
        return vKeluaranAkhir;
    }
    
    /* fTutupKoneksi: menutup koneksi */
    public void fTutupKoneksi() throws SQLException{
        this.vPrvKoneksi.close();
    }
    
    /* fAmbilDataSelectHTML: membuat tampilan select pada HTML */
    public String fAmbilDataSelectHTML(String vFNamaBerkasKonf,
            String vFNamaBd,
            String vFNamaTabel, String vKodeDataTerpilih){
        
        /* keluaran akhir */
        String vKeluaran = "";
        
        try {
            //clsBasisdata oBd = new ClsBasisdata();
            ResultSet vArrHasil = null;
            
            String vNamaBerkasKonf = (vFNamaBerkasKonf.equals("")) ? "" : vFNamaBerkasKonf;
            String vNamaBd = (vFNamaBd.equals("")) ? "" : vFNamaBd;
            
            vArrHasil = this.fArrAmbilDataDbStd(vNamaBerkasKonf, vNamaBd, vFNamaTabel, new String[]{"kode","nama"}, "kode", "ASC", new String[]{""});
            String vTerpilih = "";
            
            StringBuilder vSbData = new StringBuilder();
            boolean vDataPertama = true;
            while(vArrHasil.next()){
                vTerpilih = (vArrHasil.getString("kode").equals(vKodeDataTerpilih)) ? "#":"";
                
                if(vDataPertama){
                    vSbData.append(vTerpilih);
                    vSbData.append(vArrHasil.getString("kode")).append(">");
                    vSbData.append(vArrHasil.getString("kode")).append(" ").append(vArrHasil.getString("nama"));
                    vDataPertama = false;
                }else{
                    vSbData.append("%");
                    vSbData.append(vTerpilih);
                    vSbData.append(vArrHasil.getString("kode")).append(">");
                    vSbData.append(vArrHasil.getString("kode")).append(" ").append(vArrHasil.getString("nama"));
                }
            }
            
            vKeluaran = vSbData.toString();
            
        } catch (Exception e) {
            /* pencatatan sistem */
            if(ClsKonf.vKonfCatatSistem == true){
                String vNamaKelas = "ClsOperasiBasisdata.java";
                String vNamaMetode = "fAmbilDataSelectHTML";
                String vCatatan = vNamaKelas + "#" + vNamaMetode + "#" + e.toString();
                /* obyek catat */
                ClsCatat oCatat = new ClsCatat();
                oCatat.fCatatSistem(ClsKonf.vKonfCatatKeOutput, 
                        ClsKonf.vKonfCatatKeBD, 
                        ClsKonf.vKonfCatatKeBerkas, 
                        vCatatan);
            }
        }
        return vKeluaran;
       
    }
}