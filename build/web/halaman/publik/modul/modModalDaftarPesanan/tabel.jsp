<%@page import="java.sql.*"%>
<%@page import="pilar.cls.ClsKonf" %>
<%@page import="pilar.cls.ClsOlahKata"%>
<%@page import="pilar.cls.ClsBasisdata" %>
<%@page import="pilar.cls.ClsOperasiBasisdata"%>
<%@page import="pilar.cls.ClsAdmin" %>
<%@page import="pilar.cls.ClsCatat"%>

<%@include file="konf.jsp" %>

<% 
    /* konf */
    ClsKonf oKonf = new ClsKonf();
    
    /* memeriksa sesi halaman pengguna */
    ClsPelanggan oPelanggan = new ClsPelanggan();
    ClsOperasiBasisdata oOpsBasisdataSesi = new ClsOperasiBasisdata();
    String vKodeOrang = "";
    String vNamaPelanggan = "";
    //System.out.println("Sesi  --> " + session.getAttribute("sesIDPub") + "#" + session.getId().equals(""));
    try{
        if(session.getAttribute("sesIDPub") != ""){
            String vIdSesi = session.getAttribute("sesIDPub").toString();
            String vSandiSesi = session.getAttribute("sesSandiPub").toString();
            
            String vSandiDB = oOpsBasisdataSesi.fAmbilSatuData("", "", "tb_pelanggan", "sandi", "email", vIdSesi);
            
            if(vSandiDB.equals(vSandiSesi)){
                vKodeOrang = oOpsBasisdataSesi.fAmbilSatuData("", "", "tb_pelanggan", "kode_orang", "email", vIdSesi);
                vNamaPelanggan = oOpsBasisdataSesi.fAmbilSatuData("", "", "tb_sipil_orang", "nama_lengkap", "kode", vKodeOrang);
                
            }
            
        }
    }catch(Exception e){
        /* pencatatan sistem */
        if(ClsKonf.vKonfCatatSistem == true){
            String vNamaBerkas = "index.jsp";
            String vNamaModul = vModKonfNamaData;
            String vCatatan = vNamaBerkas + "#" + vNamaModul + "#" + e.toString();
            /* obyek catat */
            ClsCatat oCatat = new ClsCatat();
            oCatat.fCatatSistem(ClsKonf.vKonfCatatKeOutput, 
                    ClsKonf.vKonfCatatKeBD, 
                    ClsKonf.vKonfCatatKeBerkas, 
                    vCatatan);
        }
    }
%>

<% 
    /* obyek olah kata */
    ClsOlahKata oKata = new ClsOlahKata();
    
    String vNamaTabel = vModKonfNamaTabel;
    String vNamaJSON = "data";
    String vGetOffset = request.getParameter("o");
    String vGetJumData = request.getParameter("j");
    
    String vKolomCari = oKata.fHapusSpasi(request.getParameter("dtKolomCari"));
    String vTeksCari = oKata.fSatuSpasi(request.getParameter("dtTeksCari"));
    String vUrutanData = oKata.fHapusSpasi(request.getParameter("dtUrutanData"));
    ClsOperasiBasisdata oOpsBasisdata = new ClsOperasiBasisdata();
     
    /* pemilihan operasi basis data */
    int vJumDataTotal = 0;
    ResultSet vArrHasil = null;
    /* ada teks cari */
    if(vTeksCari.trim().equals("")){
        /* jumlah data total */
        vJumDataTotal = oOpsBasisdata.fJumDataTotalStd("", "", vNamaTabel, new String[]{"kode"});
        /* keluaran pencarian */
        vArrHasil = oOpsBasisdata.fArrAmbilDataDbStd("", "", vNamaTabel, new String[]{"kode","judul","tanggal","jam"}, "nomor", vUrutanData, new String[]{vGetOffset,vGetJumData});
    }
    
    if(!vTeksCari.trim().equals("")){
        /* jumlah data total */
        vJumDataTotal = oOpsBasisdata.fJumDataTotalKondisi("", "", vNamaTabel, new String[]{"kode"}, new String[]{vKolomCari}, new String[]{vTeksCari}, "%LIKE%");
        /* keluaran pencarian */
        vArrHasil = oOpsBasisdata.fArrAmbilDataDbKondisi("", "", vNamaTabel, new String[]{"kode","judul","tanggal","jam"}, new String[]{vKolomCari,vTeksCari},"nomor", vUrutanData, new String[]{vGetOffset,vGetJumData},"%LIKE%");
    }
    
    /*
        "negara": [
        { "kode":"ID", "nama":"Indonesia" },
        { "kode":"AU", "nama":"Australia" }
        ]
    */
    
    StringBuilder vSbJSON = new StringBuilder();
    boolean vBarisPertama = true;
        
    /* pembuka tag data json */
    vSbJSON.append(vJumDataTotal);
    vSbJSON.append("@[");
    /* iterasi */    
    int j = 0;
    while(vArrHasil.next()){
        if(!vArrHasil.getString("kode").trim().equals("")){
            j += 1;
            if(vBarisPertama){
                vSbJSON.append("{\"kode\":\""); 
                vSbJSON.append(vArrHasil.getString("kode"));
                vSbJSON.append("\", "); 
                vSbJSON.append("\"tanggal\":\"");
                vSbJSON.append(vArrHasil.getString("tanggal"));
                vSbJSON.append("\", "); 
                vSbJSON.append("\"tanggal\":\"");
                vSbJSON.append(vArrHasil.getString("tanggal"));
                vSbJSON.append("\", ");
                vSbJSON.append("\"jam\":\"");
                vSbJSON.append(vArrHasil.getString("jam"));
                vSbJSON.append("\"");
                vSbJSON.append("}");
                vBarisPertama = false;
            }else{
                vSbJSON.append(","); 
                vSbJSON.append("{\"kode\":\""); 
                vSbJSON.append(vArrHasil.getString("kode"));
                vSbJSON.append("\", "); 
                vSbJSON.append("\"judul\":\"");
                vSbJSON.append(vArrHasil.getString("judul").replace("\"","\\\""));
                vSbJSON.append("\", "); 
                vSbJSON.append("\"tanggal\":\"");
                vSbJSON.append(vArrHasil.getString("tanggal").replace("\"","\\\""));
                vSbJSON.append("\", ");
                vSbJSON.append("\"jam\":\"");
                vSbJSON.append(vArrHasil.getString("jam").replace("\"","\\\""));
                vSbJSON.append("\"");
                vSbJSON.append("}");
            }
        }

    }
    /* penutup tag data json */    
    vSbJSON.append("]").append("@").append(j);

   // vHasil.last();
    //int vJumlahHasil = vHasil.getRow();        
    //if(vJumlahHasil>0){
    out.println(vSbJSON.toString());
    //}
%>
