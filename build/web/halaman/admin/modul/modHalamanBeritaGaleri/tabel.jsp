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
    
    String vPostKodeBerita = oKata.fHapusSpasi(request.getParameter("dtKodeBerita"));
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
        vJumDataTotal = oOpsBasisdata.fJumDataTotalKondisi("", 
                "", 
                vNamaTabel, 
                new String[]{"kode"},
                new String[]{"kode_hlm_berita"},
                new String[]{vPostKodeBerita},
                "="
                );
        /* keluaran pencarian */
        vArrHasil = oOpsBasisdata.fArrAmbilDataDbKondisi("", 
                "", 
                vNamaTabel, 
                new String[]{"kode","nama","nama_berkas","ekstensi"},
                new String[]{"kode_hlm_berita",vPostKodeBerita},
                "nomor", 
                vUrutanData, 
                new String[]{vGetOffset,vGetJumData},
                "=");
    }
    
    if(!vTeksCari.trim().equals("")){
        /* jumlah data total */
        vJumDataTotal = oOpsBasisdata.fJumDataTotalKondisiArr("", 
                "", 
                vNamaTabel, 
                new String[]{"kode"}, 
                new String[]{vKolomCari,"kode_hlm_berita"}, 
                new String[]{vTeksCari,vPostKodeBerita}, 
                new String[]{"%LIKE%","="},
                new String[]{"AND"}
                );
        /* keluaran pencarian */
        vArrHasil = oOpsBasisdata.fArrAmbilDataDbKondisiArr("", 
                "", 
                vNamaTabel, 
                new String[]{"kode","nama","nama_berkas","ekstensi"}, 
                new String[]{vKolomCari,"kode_hlm_berita"},
                new String[]{vTeksCari,vPostKodeBerita},
                "nomor", 
                vUrutanData, 
                new String[]{vGetOffset,vGetJumData},"%LIKE%");
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
                vSbJSON.append("\"nama\":\"");
                vSbJSON.append(vArrHasil.getString("nama"));
                vSbJSON.append("\", "); 
                vSbJSON.append("\"berkas\":\"");
                vSbJSON.append(vArrHasil.getString("nama_berkas"));
                vSbJSON.append("\", ");
                vSbJSON.append("\"ekstensi\":\"");
                vSbJSON.append(vArrHasil.getString("ekstensi"));
                vSbJSON.append("\"");
                vSbJSON.append("}");
                vBarisPertama = false;
            }else{
                vSbJSON.append(","); 
                vSbJSON.append("{\"kode\":\""); 
                vSbJSON.append(vArrHasil.getString("kode"));
                vSbJSON.append("\", "); 
                vSbJSON.append("\"nama\":\"");
                vSbJSON.append(vArrHasil.getString("nama"));
                vSbJSON.append("\", "); 
                vSbJSON.append("\"berkas\":\"");
                vSbJSON.append(vArrHasil.getString("nama_berkas"));
                vSbJSON.append("\", ");
                vSbJSON.append("\"ekstensi\":\"");
                vSbJSON.append(vArrHasil.getString("ekstensi"));
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
