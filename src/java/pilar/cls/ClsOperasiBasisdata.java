/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package pilar.cls;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import javax.xml.parsers.ParserConfigurationException;
import org.w3c.dom.DOMException;
import org.xml.sax.SAXException;

/**
 *
 * @author PERSEUS
 */
public class ClsOperasiBasisdata {
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
                    String vArrTabel[] = oBerkasXml.fKonfBasisdata(vFNamaBerkasKonf, vFNamaBd);
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
                            vSbSQL.append(vNamaKolom).append("`=?");
                            vKondisiPertama = false;
                        }else{
                            vSbSQL.append(" AND `").append(vFNamaBd).append("`.`").append(vFNamaTabel).append("`.`"); 
                            vSbSQL.append(vNamaKolom).append("`=?");
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
                                            vSbNilai.append("?");
                                        }
                                        /* tandai urutan pertama sudah lewat */
                                        vPertama = false;
                                    } else {
                                        if(vStrData.equals("null") || vStrData.equals(null)){
                                            vSbNilai.append(",").append("?");
                                        }else{
                                            vSbNilai.append(",?");
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
                            System.out.println(vKalimatSQL);
                            break;
                        case "h":
                            /* operasi DELETE */
                            vKalimatSQL = "DELETE FROM `" + vFNamaBd + "`.`" + vFNamaTabel + "` "+
                                    "WHERE "; 
                            vKalimatSQL = vKalimatSQL + vSbSQL.toString();
                            System.out.println(vKalimatSQL);
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
                                            if(!vArrKolom[i].equals(vArrTabel[0])){
                                                vSbNilai.append(vArrKolom[i]).append("=?");
                                                vPertama = false;
                                            }                                    
                                        } else {
                                            if(!vArrKolom[i].equals(vArrTabel[0])){
                                                vSbNilai.append(", ").append(vArrKolom[i]).append("=?");
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
                    /* ## TAMBAH DATA */
                    if(!vKalimatSQL.equals("") && vFOperasi.equals("t")){
                        PreparedStatement oPSt = vKoneksiBD.prepareStatement(vKalimatSQL + ";");
                        //System.out.println(vKalimatSQL);
                        
                        if(vFDataUnik){
                            /* lakukan pemeriksaan keberadaan data */
                            boolean vStatusDataAda = this.fDataAdaArr(vFNamaBerkasKonf, vFNamaBd, vFNamaTabel, vFArrKolomRef, vFArrDataRef);

                            if(!vStatusDataAda){
                                /* data belum ada */
                                int a = 0;
                                for(String vData : vFData){
                                    if(!vData.equals("null")){
                                        a+=1;
                                        if(a < vFData.length){
                                            oPSt.setString(a, vData);
                                        }
                                    }
                                }
                                oPSt.execute();
                            }
                        }else{
                            int b = 0;
                            for(String vData : vFData){
                                if(!vData.equals("null")){
                                    b+=1;
                                    if(b < vFData.length){
                                        oPSt.setString(b, vData);
                                    }
                                }
                            }
                            oPSt.execute();
                        }          
                        
                    }
                    
                    /* ## UBAH DATA */
                    if(!vKalimatSQL.equals("") && vFOperasi.equals("u")){
                        System.out.println(vKalimatSQL);
                        PreparedStatement oPSt = vKoneksiBD.prepareStatement(vKalimatSQL + ";");
                        int c = 0;
                        for(String vData : vFData){
                            if(!vData.equals("null")){
                                System.out.println("Kode Update -> " + vData);
                                c+=1;
                                if(c < vFData.length){
                                    oPSt.setString(c, vData);
                                }
                            }
                        }
                        
                        for(String vDataRef : vFArrDataRef){
                            System.out.println("Kode Update -> " + vDataRef);
                            c+=1;
                            oPSt.setString(c, vDataRef);
                        }
                        oPSt.executeUpdate();
                    }

                    /* ## HAPUS DATA */
                    if(!vKalimatSQL.equals("") && vFOperasi.equals("h")){
                        PreparedStatement oPSt = vKoneksiBD.prepareStatement(vKalimatSQL + ";");
                        int e = 0;
                        for(String vData : vFArrDataRef){
                            System.out.println("Kode Hapus -> " + vData);
                            e+=1;
                            oPSt.setString(e, vData);
                        }
                        oPSt.execute();
                    }
                }            

            }   
        
            System.out.println("Kalimat SQL fOperasiBdDasar: " + vKalimatSQL);
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
            String[] vFArrKolomDataRef, /* new String{"kode_geo_negara",vKodeNegara}*/
            String vFKolomUrut,
            String vFJenisUrut,
            String[] vFArrOffset,
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
                    if(vFArrOffset.length > 1){
                        vSbSQL.append(" LIMIT ");
                        vSbSQL.append(vFArrOffset[0]);
                        vSbSQL.append(",");
                        vSbSQL.append(vFArrOffset[1]);
                    }

                }

                /* eksekusi kalimat SQL */
                if(vKoneksiBD != null){
                    Statement vPernyataanSQL = vKoneksiBD.createStatement();
                    vArrHasil = vPernyataanSQL.executeQuery(vSbSQL.toString());
                }     
                
                System.out.println("fArrAmbilDataDbKondisi -> vSbSQL: " + vSbSQL.toString());
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
                                vSbSQL.append("LIKE ?");
                            }

                            if(vFKondisi.equals("=")){
                                vSbSQL.append("= ?");
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
                                vSbSQL.append("LIKE ?");
                            }

                            if(vFKondisi.equals("=")){
                                vSbSQL.append("= ?");
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
                    if(vFOffset.length > 1){
                        vSbSQL.append(" LIMIT ");
                        vSbSQL.append(vFOffset[0]);
                        vSbSQL.append(",");
                        vSbSQL.append(vFOffset[1]);
                    }

                }
                System.out.println("fArrAmbilDataDbKondisiArr: " + vSbSQL.toString());
                /* eksekusi kalimat SQL */
                if(vKoneksiBD != null){
                    //Statement vPernyataanSQL = vKoneksiBD.createStatement();
                    System.out.println(vSbSQL.toString());
                    PreparedStatement oPSt = vKoneksiBD.prepareStatement(vSbSQL.toString() + ";");
                    
                    int a = 0;
                    for(String vDataRef : vFArrDataRef){
                        a+=1;
                        if(vFKondisi.equals("%LIKE%")){
                            oPSt.setString(a, "%"+vDataRef+"%");
                        }else{
                            oPSt.setString(a, vDataRef);
                        }
                    }
                    
                    vArrHasil = oPSt.executeQuery();
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
    
    public Integer fJumDataTotalKondisiArr(
            String vFNamaBerkasKonf,
            String vFNamaBd,
            String vFNamaTabel,
            String[] vFArrNamaKolom,
            String[] vFArrKolomRef,
            String[] vFArrKolomDataRef,
            String[] vFArrKondisi,
            String[] vFArrTipeBoolean){
            
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
                    boolean vIterasiPertama = true;
                    for(String vKolomRef: vFArrKolomRef){
                        
                        if(vIterasiPertama){
                            vSbSQL.append(vDbTabel);
                            vSbSQL.append(".`");
                            vSbSQL.append(vKolomRef);
                            vSbSQL.append("` ");

                            /* kondisi */
                            if(vFArrKondisi[m].equals("=")){
                                vSbSQL.append("LIKE '%");
                                vSbSQL.append(vFArrKolomDataRef[m]);
                                vSbSQL.append("%'");
                            }

                            if(vFArrKondisi[m].equals("%LIKE%")){
                                vSbSQL.append("LIKE '%");
                                vSbSQL.append(vFArrKolomDataRef[m]);
                                vSbSQL.append("%'");
                            }
                            vIterasiPertama = false;
                        }else{
                            vSbSQL.append(" ");
                            vSbSQL.append(vFArrTipeBoolean[m-1]);
                            vSbSQL.append(" ");
                            
                            vSbSQL.append(vDbTabel);
                            vSbSQL.append(".`");
                            vSbSQL.append(vKolomRef);
                            vSbSQL.append("` ");

                            /* kondisi */
                            if(vFArrKondisi[m].equals("=")){
                                vSbSQL.append("LIKE '%");
                                vSbSQL.append(vFArrKolomDataRef[m]);
                                vSbSQL.append("%'");
                            }

                            if(vFArrKondisi[m].equals("%LIKE%")){
                                vSbSQL.append("LIKE '%");
                                vSbSQL.append(vFArrKolomDataRef[m]);
                                vSbSQL.append("%'");
                            }
                        }
                        

                        /* inc m */
                        m += 1;
                    }

                }
                
                System.out.println("#### ->" + vSbSQL.toString());

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
                    String vNamaMetode = "fJumDataTotalKondisiArr";
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
    
    /* fAmbilSatuData: mengambil satu data  */
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
            
            System.out.println("fAmbilSatuData: " + vKalimatSQL);
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
    
    /* fAmbilSatuDataKondisiArr: mengambil satu data untuk banyak kondisi */
    public String fAmbilSatuDataKondisiArr(String vFNamaBerkasKonf, 
            String vFNamaBd, 
            String vFNamaTabel, 
            String vFNamaKolomKeluaran,
            String[] vFArrNamaKolomRef, 
            String[] vFArrDataRef,
            String[] vFArrHubNamaKolomData,
            String[] vFArrKondisiBool){
        
        String vKeluaranAkhir = "";
        
        try{
            /* alternatif masukan */
            vFNamaBerkasKonf = (vFNamaBerkasKonf.equals("")) ? ClsKonf.vKonfBerkasBdStd : vFNamaBerkasKonf;
            vFNamaBd = (vFNamaBd.equals("")) ? ClsKonf.vKonfBdStd : vFNamaBd;
            /* kalimat SQL */
            String vKalimatSQL = "SELECT `" + vFNamaBd + "`.`" + vFNamaTabel + "`.`" + vFNamaKolomKeluaran + "` " +
                    "FROM `" + vFNamaBd + "`.`" + vFNamaTabel + "` " + 
                    "WHERE ";
            
            StringBuilder oSb = new StringBuilder();
            boolean vPertama = true;
            
            int i = 0;
            for(String vNamaKolomRef: vFArrNamaKolomRef){
                
                if(vPertama){
                    oSb.append("`").append(vFNamaBd).append("`.");
                    oSb.append("`").append(vFNamaTabel).append("`.");
                    oSb.append("`").append(vFArrNamaKolomRef[i]).append("` ");
                    oSb.append(vFArrHubNamaKolomData[i]);
                    oSb.append(" '").append(vFArrDataRef[i]).append("' ");
                    vPertama = false;
                }else{
                    oSb.append(vFArrKondisiBool[i-1]);
                    oSb.append(" `").append(vFNamaBd).append("`.");
                    oSb.append("`").append(vFNamaTabel).append("`.");
                    oSb.append("`").append(vFArrNamaKolomRef[i]).append("` ");
                    oSb.append(vFArrHubNamaKolomData[i]);
                    oSb.append(" '").append(vFArrDataRef[i]).append("'");
                }
                i+=1;
            }
            
            String vKalimatSQLAkhir = vKalimatSQL + oSb.toString() + " LIMIT 0,1";

            /* membuat koneksi ke server basisdata */
            ClsBasisdata oBasisdata = new ClsBasisdata();
            Connection vKoneksiBD = oBasisdata.fSambungkanKeServerBD(vFNamaBerkasKonf, vFNamaBd);
            this.vPrvKoneksi = vKoneksiBD;
            
             ResultSet vArrHasil = null;
            if(vKoneksiBD != null){
                Statement vPernyataanSQL = vKoneksiBD.createStatement();
                vArrHasil = vPernyataanSQL.executeQuery(vKalimatSQLAkhir);

                while(vArrHasil.next()){
                    vKeluaranAkhir = vArrHasil.getString(vFNamaKolomKeluaran);
                }
            }
            
            System.out.println("fAmbilSatuDataKondisiArr: " + vKalimatSQL);
        }catch(Exception e){
            /* pencatatan sistem */
            if(ClsKonf.vKonfCatatSistem == true){
                String vNamaKelas = "ClsOperasiBasisdata.java";
                String vNamaMetode = "fAmbilSatuDataKondisiArr";
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
    public boolean fDataAdaArr(String vFNamaBerkasKonf, 
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
                    vSbSQL.append(vNamaKolom).append("`=").append("?").append("");
                    vKondisiPertama = false;
                }else{
                    vSbSQL.append(" AND `").append(vFNamaBd).append("`.`").append(vFNamaTabel).append("`.`"); 
                    vSbSQL.append(vNamaKolom).append("`=").append("?").append("");
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
                //System.out.println(vKalimatSQL);
                //Statement vPernyataanSQL = vKoneksiBD.createStatement();
                PreparedStatement oPSt = vKoneksiBD.prepareStatement(vKalimatSQL + ";");
                
                int j = 0;
                for(String vData : vFArrData){ 
                    j += 1;
                    //System.out.println(vData);
                    oPSt.setString(j,vData);
                    
                }
                vArrHasil = oPSt.executeQuery();
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
    
    /* fAmbilDataSelectHTML: membuat tampilan select pada HTML */
    public void fBeriNilaiSamaSemuaBarisPadaKolomX(String vFNamaBerkasKonf,
            String vFNamaBd,
            String vFNamaTabel,
            String vFNamaKolomUpdate,
            String vFKolomRef,
            String vFDataRef,
            String vFNilaiDataUpdate){
        
        try {
            
            /* alternatif masukan */
            vFNamaBerkasKonf = (vFNamaBerkasKonf.equals("")) ? ClsKonf.vKonfBerkasBdStd : vFNamaBerkasKonf;
            vFNamaBd = (vFNamaBd.equals("")) ? ClsKonf.vKonfBdStd : vFNamaBd;
            
            /* membuat koneksi ke server basisdata */
            ClsBasisdata oBasisdata = new ClsBasisdata();
            Connection vKoneksiBD = oBasisdata.fSambungkanKeServerBD(vFNamaBerkasKonf, vFNamaBd);
            this.vPrvKoneksi = vKoneksiBD;

            /* vPrvStatusKoneksi -> true ? */
            if(vKoneksiBD != null){              
                String vKalimatSQL = "UPDATE `" + vFNamaBd + "`.`" + vFNamaTabel + "` " + 
                        "SET `" + vFNamaBd + "`.`" + vFNamaTabel + "`.`" + vFNamaKolomUpdate + "`=? " +
                        "WHERE `" + vFNamaBd + "`.`" + vFNamaTabel + "`.`" + vFKolomRef + "`=? ";

                PreparedStatement oPSt = vKoneksiBD.prepareStatement(vKalimatSQL + ";");
                oPSt.setString(1, vFNilaiDataUpdate);
                oPSt.setString(2, vFDataRef);
                oPSt.executeUpdate();
                
                System.out.println("fBeriNilaiSamaSemuaBarisPadaKolomX: " + vKalimatSQL);
            }
            
        } catch (Exception e) {
            /* pencatatan sistem */
            if(ClsKonf.vKonfCatatSistem == true){
                String vNamaKelas = "ClsOperasiBasisdata.java";
                String vNamaMetode = "fBeriNilaiSamaSemuaBarisPadaKolomX";
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
    
    /* fHapusSemuaBarisBerIDX: menghapus semua baris ber-id tertentu */
    public void fHapusSemuaBarisBerIDX(String vFNamaBerkasKonf,
            String vFNamaBd,
            String vFNamaTabel,
            String vFKolomData,
            String vFNilaiData){
        
        try {
            
            /* alternatif masukan */
            vFNamaBerkasKonf = (vFNamaBerkasKonf.equals("")) ? ClsKonf.vKonfBerkasBdStd : vFNamaBerkasKonf;
            vFNamaBd = (vFNamaBd.equals("")) ? ClsKonf.vKonfBdStd : vFNamaBd;
            
            /* membuat koneksi ke server basisdata */
            ClsBasisdata oBasisdata = new ClsBasisdata();
            Connection vKoneksiBD = oBasisdata.fSambungkanKeServerBD(vFNamaBerkasKonf, vFNamaBd);
            this.vPrvKoneksi = vKoneksiBD;

            /* vPrvStatusKoneksi -> true ? */
            if(vKoneksiBD != null){              
                String vKalimatSQL = "DELETE FROM `" + vFNamaBd + "`.`" + vFNamaTabel + "` " + 
                        "WHERE `" + vFNamaBd + "`.`" + vFNamaTabel + "`.`" + vFKolomData + "`=? ";

                PreparedStatement oPSt = vKoneksiBD.prepareStatement(vKalimatSQL + ";");
                oPSt.setString(1, vFNilaiData);
                oPSt.executeUpdate();
                
                System.out.println("fHapusSemuaBarisBerIDX: " + vKalimatSQL);
            }
            
        } catch (Exception e) {
            /* pencatatan sistem */
            if(ClsKonf.vKonfCatatSistem == true){
                String vNamaKelas = "ClsOperasiBasisdata.java";
                String vNamaMetode = "fHapusSemuaBarisBerIDX";
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
}