<%@page import="java.sql.*"%>
<%@page import="pilar.cls.ClsKonf" %>
<%@page import="pilar.cls.ClsOlahKata"%>
<%@page import="pilar.cls.ClsBasisdata" %>
<%@page import="pilar.cls.ClsOperasiBasisdata"%>
<%@page import="pilar.cls.ClsOperator" %>
<%@page import="pilar.cls.ClsCatat"%>

<%@include file="konf.jsp" %>

<% 
    /* memeriksa sesi halaman operator */
    ClsKonf oKonf = new ClsKonf();
    ClsOperator oOperator = new ClsOperator();
    try{
        if(session.getAttribute("sesIDOp") != "" && !session.getId().equals("")){
            boolean vStatusSesi = oOperator.fHalamanOperator(session);
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
        //* jumlah data total */
        vJumDataTotal = oOpsBasisdata.fJumDataTotalKondisiArr("", "", vNamaTabel, 
                new String[]{"kode_faktur"},
                new String[]{"status_proses"},
                new String[]{"0"},
                new String[]{"="},
                new String[]{"AND"});
        /* keluaran pencarian */
        vArrHasil = oOpsBasisdata.fArrAmbilDataDbKondisiArr("",
                "", 
                vNamaTabel, 
                new String[]{"kode_faktur","kode_orang_pelanggan"}, 
                new String[]{"status_proses"},
                new String[]{"0"},
                "nomor", 
                vUrutanData, 
                new String[]{vGetOffset,vGetJumData},"=");
    }
    
    if(!vTeksCari.trim().equals("")){
        /* jumlah data total */
        vJumDataTotal = oOpsBasisdata.fJumDataTotalKondisi("", "", vNamaTabel, new String[]{"kode_faktur"}, new String[]{vKolomCari}, new String[]{vTeksCari}, "%LIKE%");
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
        if(!vArrHasil.getString("kode_faktur").trim().equals("")){
            String vKodeOrang = vArrHasil.getString("kode_orang_pelanggan");
            String vNamaLengkap = oOpsBasisdata.fAmbilSatuData("", "", "tb_sipil_orang", "nama_lengkap", "kode",vKodeOrang);
            j += 1;
            if(vBarisPertama){
                vSbJSON.append("{\"kode\":\""); 
                vSbJSON.append(vArrHasil.getString("kode_faktur"));
                vSbJSON.append("\", "); 
                vSbJSON.append("\"nama\":\"");
                vSbJSON.append(vNamaLengkap);
                vSbJSON.append("\""); 
                vSbJSON.append("}");
                vBarisPertama = false;
            }else{
                vSbJSON.append(","); 
                vSbJSON.append("{\"kode\":\""); 
                vSbJSON.append(vArrHasil.getString("kode_faktur"));
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
