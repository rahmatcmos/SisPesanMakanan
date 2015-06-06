<%@page import="java.sql.*"%>
<%@page import="pilar.cls.ClsKonf" %>
<%@page import="pilar.cls.ClsOlahKata"%>
<%@page import="pilar.cls.ClsBasisdata" %>
<%@page import="pilar.cls.ClsOperasiBasisdata"%>
<%@page import="pilar.cls.ClsAdmin" %>
<%@page import="pilar.cls.ClsCatat"%>

<%@include file="konf.jsp" %>

<% 
    /* memeriksa sesi halaman admin */
    ClsKonf oKonf = new ClsKonf();
    ClsAdmin oAdmin = new ClsAdmin();
    try{
        if(session.getAttribute("sesID") != "" && !session.getId().equals("")){
            boolean vStatusSesi = oAdmin.fHalamanAdmin(session);
            if(!vStatusSesi){
                response.sendRedirect(ClsKonf.vKonfURL);
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
    
    /* 
        String vFNamaBerkasKonf,
        String vFNamaBd,
        String vFNamaTabel,
        String[] vFArrNamaKolom,
        String vFKolomUrut,
        String vFJenisUrut,
        String[] vFOffset
    
    */
   
    /* pemilihan operasi basis data */
    int vJumDataTotal = 0;
    ResultSet vArrHasil = null;
    /* ada teks cari */
    if(vTeksCari.trim().equals("")){
        /* jumlah data total */
        vJumDataTotal = oOpsBasisdata.fJumDataTotalStd("", "", vNamaTabel, new String[]{"kode"});
        /* keluaran pencarian */
        vArrHasil = oOpsBasisdata.fArrAmbilDataDbStd("", "", vNamaTabel, new String[]{"kode","kode_orang"}, "nomor", vUrutanData, new String[]{vGetOffset,vGetJumData});
    }
    
    if(!vTeksCari.trim().equals("")){
        /* jumlah data total */
        vJumDataTotal = oOpsBasisdata.fJumDataTotalKondisi("", "", vNamaTabel, new String[]{"kode"}, new String[]{vKolomCari}, new String[]{vTeksCari}, "%LIKE%");
        /* keluaran pencarian */
        vArrHasil = oOpsBasisdata.fArrAmbilDataDbKondisi("", "", vNamaTabel, new String[]{"kode","kode_orang"}, new String[]{vKolomCari,vTeksCari},"nomor", vUrutanData, new String[]{vGetOffset,vGetJumData},"%LIKE%");
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
            String vKodeOrang = vArrHasil.getString("kode_orang");
            String vNamaLengkap = oOpsBasisdata.fAmbilSatuData("", "", "tb_sipil_orang", "nama_lengkap", "kode",vKodeOrang);
            j += 1;
            if(vBarisPertama){
                vSbJSON.append("{\"kode\":\""); 
                vSbJSON.append(vArrHasil.getString("kode"));
                vSbJSON.append("\", "); 
                vSbJSON.append("\"nama\":\"");
                vSbJSON.append(vNamaLengkap);
                vSbJSON.append("\""); 
                vSbJSON.append("}");
                vBarisPertama = false;
            }else{
                vSbJSON.append(","); 
                vSbJSON.append("{\"kode\":\""); 
                vSbJSON.append(vArrHasil.getString("kode"));
                vSbJSON.append("\", "); 
                vSbJSON.append("\"nama\":\"");
                vSbJSON.append(vNamaLengkap);
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
