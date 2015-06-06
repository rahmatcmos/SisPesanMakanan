<%@page import="java.sql.ResultSet"%>
<%@page import="pilar.cls.ClsKonf" %>
<%@page import="pilar.cls.ClsOlahKata"%>
<%@page import="pilar.cls.ClsBasisdata" %>
<%@page import="pilar.cls.ClsOperasiBasisdata"%>
<%@page import="pilar.cls.ClsAdmin" %>
<%@page import="pilar.cls.ClsKode"%>
<%@page import="pilar.cls.ClsCatat"%>

<%@include file="konf.jsp" %>

<% 
    /* ################### memeriksa sesi halaman admin */
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
        response.sendRedirect(ClsKonf.vKonfURL);
    }
%>

<%
    /* obyek olah kata */
    ClsOlahKata oKata = new ClsOlahKata();
    
    /* obyek basisdata */
    ClsOperasiBasisdata oOpsBasisdata = new ClsOperasiBasisdata();
    
    /* variabel POST */
    String vOperasi = oKata.fHapusSpasi(request.getParameter("dtOperasi").toString()),
        vKode = "",
        vKodeSebutan = "",
        vNamaLengkap = "",
        vNamaDepan = "",
        vNamaBelakang = "",
        vJenisKelamin = "",
        vKodeNegaraLahir = "",
        vKodeProvinsiLahir = "",
        vKodeKabupatenLahir = "",
        vKodeKecamatanLahir = "",
        vTanggalLahir = "",
        vCatatan = "",
        vKeluaran="";
    
    /* 
    
    if(!vOperasi.equals("")){
        /* operasi membuat kode baru */
        if(vOperasi.equals("k")){
            ClsKode oKode = new ClsKode();
            String vKodeAcak = vModKonfKodeAwal + oKode.fBuatKodeAcak(14).toUpperCase();
            vKeluaran = vKodeAcak;
        }
        
        /* ################### operasi tambah data */
        if(vOperasi.equals("t")){
            /* variabel POST */
            vKode = oKata.fHapusSpasi(request.getParameter("dtKode").toString());
            vKodeSebutan = oKata.fSatuSpasi(request.getParameter("dtKodeSebutan").toString());
            vNamaDepan = oKata.fSatuSpasi(request.getParameter("dtNamaDepan").toString());
            vNamaBelakang = oKata.fSatuSpasi(request.getParameter("dtNamaBelakang").toString());
            vNamaLengkap = vNamaDepan + " " + vNamaBelakang; 
            vJenisKelamin = oKata.fHapusSpasi(request.getParameter("dtJenisKelamin").toString());
            vKodeNegaraLahir = oKata.fHapusSpasi(request.getParameter("dtKodeNegaraLahir").toString()).substring(0,8);
            vKodeProvinsiLahir = oKata.fHapusSpasi(request.getParameter("dtKodeProvinsiLahir").toString()).substring(0,8);
            vKodeKabupatenLahir = oKata.fHapusSpasi(request.getParameter("dtKodeKabupatenLahir").toString()).substring(0,8);
            vKodeKecamatanLahir = oKata.fHapusSpasi(request.getParameter("dtKodeKecamatanLahir").toString()).substring(0,8);
            vTanggalLahir = oKata.fHapusSpasi(request.getParameter("dtTanggalLahir").toString());;
            vCatatan = oKata.fSatuSpasi(request.getParameter("dtCatatan").toString());
            /* operasi basisdata */
            if(!vKode.equals("") && !vNamaDepan.equals("")){
                oOpsBasisdata.fOperasiBdDasar("",
                        vModKonfNamaBd, 
                        vModKonfNamaTabel,
                        new String[]{"kode"}, 
                        new String[]{vKode},
                        new String[]{"null",
                            vKode,
                            vKodeSebutan,
                            vNamaDepan,
                            vNamaBelakang,
                            vNamaLengkap.trim(),
                            vJenisKelamin,
                            vKodeNegaraLahir,
                            vKodeProvinsiLahir,
                            vKodeKabupatenLahir,
                            vKodeKecamatanLahir,
                            vTanggalLahir,
                            vCatatan}, "t",true);
                /* jumlah data total menyesuaikan dengan */
                int vJumDataTotal = oOpsBasisdata.fJumDataTotalStd("", "", vModKonfNamaTabel, new String[]{"kode"});
                vKeluaran = Integer.toString(vJumDataTotal);
                oOpsBasisdata.fTutupKoneksi();
            }
        }
        
        /* ################### operasi ubah data */
        if(vOperasi.equals("u")){
            /* variabel POST */
            vKode = oKata.fHapusSpasi(request.getParameter("dtKode").toString());
            vKodeSebutan = oKata.fSatuSpasi(request.getParameter("dtKodeSebutan").toString());
            vNamaDepan = oKata.fSatuSpasi(request.getParameter("dtNamaDepan").toString());
            vNamaBelakang = oKata.fSatuSpasi(request.getParameter("dtNamaBelakang").toString());
            vNamaLengkap = vNamaDepan + " " + vNamaBelakang; 
            vJenisKelamin = oKata.fHapusSpasi(request.getParameter("dtJenisKelamin").toString());
            vKodeNegaraLahir = oKata.fHapusSpasi(request.getParameter("dtKodeNegaraLahir").toString()).substring(0,8);
            vKodeProvinsiLahir = oKata.fHapusSpasi(request.getParameter("dtKodeProvinsiLahir").toString()).substring(0,8);
            vKodeKabupatenLahir = oKata.fHapusSpasi(request.getParameter("dtKodeKabupatenLahir").toString()).substring(0,8);
            vKodeKecamatanLahir = oKata.fHapusSpasi(request.getParameter("dtKodeKecamatanLahir").toString()).substring(0,8);
            vTanggalLahir = oKata.fHapusSpasi(request.getParameter("dtTanggalLahir").toString());;
            vCatatan = oKata.fSatuSpasi(request.getParameter("dtCatatan").toString());
           /* operasi basisdata */
            if(!vKode.equals("") && !vNamaDepan.equals("")){
                oOpsBasisdata.fOperasiBdDasar("", 
                    vModKonfNamaBd, 
                    vModKonfNamaTabel, 
                    new String[]{"kode"}, new String[]{vKode}, 
                    new String[]{"null",
                        vKode,
                        vKodeSebutan,
                        vNamaDepan,
                        vNamaBelakang,
                        vNamaLengkap.trim(),
                        vJenisKelamin,
                        vKodeNegaraLahir,
                        vKodeProvinsiLahir,
                        vKodeKabupatenLahir,
                        vKodeKecamatanLahir,
                        vTanggalLahir,
                        vCatatan}, 
                    "u",
                    true);
                
                int vJumDataTotal = oOpsBasisdata.fJumDataTotalStd("", "", vModKonfNamaTabel, new String[]{"kode"});
                vKeluaran = Integer.toString(vJumDataTotal);
                oOpsBasisdata.fTutupKoneksi();
            }
        }
        
        /* ################### operasi hapus data */
        if(vOperasi.equals("h")){
            /* variabel POST */
            vKode = oKata.fHapusSpasi(request.getParameter("dtKode").toString());
            out.println(vKode);
            /* hapus banyak data */
            if(vKode.contains("#")){
                out.println("Ya mengandung #.");
                String[] vArrKode = vKode.split("#");
                for(String vKodeHapus:vArrKode){
                    out.println("Hapus --> " + vKodeHapus);
                    oOpsBasisdata.fOperasiBdDasar("", vModKonfNamaBd, vModKonfNamaTabel,new String[]{"kode"}, new String[]{vKodeHapus}, new String[]{""}, "h", true);
                    int vJumDataTotal = oOpsBasisdata.fJumDataTotalStd("", "", vModKonfNamaTabel, new String[]{"kode"});
                    oOpsBasisdata.fTutupKoneksi();
                    vKeluaran = Integer.toString(vJumDataTotal);
                }
            }
            
            /* hapus data tunggal */
            if(!vKode.contains("#")){
                /* operasi basisdata */
                if(!vKode.equals("")){
                    oOpsBasisdata.fOperasiBdDasar("", vModKonfNamaBd, vModKonfNamaTabel,new String[]{"kode"}, new String[]{vKode}, new String[]{""}, "h", true);
                    int vJumDataTotal = oOpsBasisdata.fJumDataTotalStd("", "", vModKonfNamaTabel, new String[]{"kode"});
                    oOpsBasisdata.fTutupKoneksi();
                    vKeluaran = Integer.toString(vJumDataTotal);
                }
            }
        }
        
        /* operasi select */
        if(vOperasi.equals("s")){
        
            /* kode data */
            String vPostKodeData = oKata.fHapusSpasi(request.getParameter("dtKodeData").toString());
            String vPostKodeRef = oKata.fHapusSpasi(request.getParameter("dtKodeRef").toString());
            
            /* 1) data provinsi -------------------------------------------------------- */
            if(vPostKodeData.equals("provinsi")){
                String vKodeNegaraRef = vPostKodeRef.substring(0,8);
                ResultSet vArrDataProvinsi = oOpsBasisdata.fArrAmbilDataDbKondisi("", "", 
                        "tb_geo_provinsi", new String[]{"kode","nama"}, 
                        new String[]{"kode_geo_negara",vKodeNegaraRef}, "nomor", "ASC", new String[]{""}, "=");
                
                if(vArrDataProvinsi != null){
                    /* iterasi */
                    StringBuilder vSbJSON = new StringBuilder();
                    /* pembuka tag data json */
                    vSbJSON.append("[");
                    int j = 0;
                    boolean vBarisPertama = true;
                    while(vArrDataProvinsi.next()){
                        j += 1;
                        if(vBarisPertama){
                            vSbJSON.append("{\"kode\":\""); 
                            vSbJSON.append(vArrDataProvinsi.getString("kode"));
                            vSbJSON.append("\", "); 
                            vSbJSON.append("\"nama\":\"");
                            vSbJSON.append(vArrDataProvinsi.getString("nama"));
                            vSbJSON.append("\""); 
                            vSbJSON.append("}");
                            vBarisPertama = false;
                        }else{
                            vSbJSON.append(","); 
                            vSbJSON.append("{\"kode\":\""); 
                            vSbJSON.append(vArrDataProvinsi.getString("kode"));
                            vSbJSON.append("\", "); 
                            vSbJSON.append("\"nama\":\"");
                            vSbJSON.append(vArrDataProvinsi.getString("nama"));
                            vSbJSON.append("\""); 
                            vSbJSON.append("}");
                        }
                    }
                    vSbJSON.append("]");
                    /* keluaran */
                    vKeluaran = j + "@" + vSbJSON.toString();
                }
            }
            
            /* 2) Kabupaten -------------------------------------------------------- */
            if(vPostKodeData.equals("kabupaten")){
                
                String vKodeNegaraRef = "";
                String vKodeProvinsiRef = "";
                
                if(vPostKodeRef.contains("#")){
                    String[] vArrKodeRef = vPostKodeRef.split("#");
                    if(vArrKodeRef.length == 2){    
                        vKodeNegaraRef = vArrKodeRef[0].substring(0,8);
                        vKodeProvinsiRef = vArrKodeRef[1].substring(0,8);
                    }
                }
                
                ResultSet vArrDataKabupaten = oOpsBasisdata.fArrAmbilDataDbKondisiArr("", "", 
                        "tb_geo_kabupaten", 
                        new String[]{"kode","nama"}, 
                        new String[]{"kode_geo_negara","kode_geo_provinsi"},
                        new String[]{vKodeNegaraRef,vKodeProvinsiRef},
                        "nomor", 
                        "ASC", new String[]{""}, "=");
                
                if(vArrDataKabupaten != null){
                    /* iterasi */
                    StringBuilder vSbJSON = new StringBuilder();
                    /* pembuka tag data json */
                    vSbJSON.append("[");
                    int j = 0;
                    boolean vBarisPertama = true;
                    while(vArrDataKabupaten.next()){
                        j += 1;
                        if(vBarisPertama){
                            vSbJSON.append("{\"kode\":\""); 
                            vSbJSON.append(vArrDataKabupaten.getString("kode"));
                            vSbJSON.append("\", "); 
                            vSbJSON.append("\"nama\":\"");
                            vSbJSON.append(vArrDataKabupaten.getString("nama"));
                            vSbJSON.append("\""); 
                            vSbJSON.append("}");
                            vBarisPertama = false;
                        }else{
                            vSbJSON.append(","); 
                            vSbJSON.append("{\"kode\":\""); 
                            vSbJSON.append(vArrDataKabupaten.getString("kode"));
                            vSbJSON.append("\", "); 
                            vSbJSON.append("\"nama\":\"");
                            vSbJSON.append(vArrDataKabupaten.getString("nama"));
                            vSbJSON.append("\""); 
                            vSbJSON.append("}");
                        }
                    }
                    vSbJSON.append("]");
                    /* keluaran */
                    vKeluaran = j + "@" + vSbJSON.toString();
                }
            }
            
            /* 3) Kecamatan -------------------------------------------------------- */
            if(vPostKodeData.equals("kecamatan")){
                
                String vKodeNegaraRef = "";
                String vKodeProvinsiRef = "";
                String vKodeKabupatenRef = "";
                
                if(vPostKodeRef.contains("#")){
                    String[] vArrKodeRef = vPostKodeRef.split("#");
                    if(vArrKodeRef.length == 3){    
                        vKodeNegaraRef = vArrKodeRef[0].substring(0,8);
                        vKodeProvinsiRef = vArrKodeRef[1].substring(0,8);
                        vKodeKabupatenRef = vArrKodeRef[2].substring(0,8);
                    }
                }
                
                ResultSet vArrDataKecamatan = oOpsBasisdata.fArrAmbilDataDbKondisiArr("", "", 
                        "tb_geo_kecamatan", 
                        new String[]{"kode","nama"}, 
                        new String[]{"kode_geo_negara","kode_geo_provinsi","kode_geo_kabupaten"},
                        new String[]{vKodeNegaraRef,vKodeProvinsiRef,vKodeKabupatenRef},
                        "nomor", 
                        "ASC", new String[]{""}, "=");
                
                if(vArrDataKecamatan != null){
                    /* iterasi */
                    StringBuilder vSbJSON = new StringBuilder();
                    /* pembuka tag data json */
                    vSbJSON.append("[");
                    int j = 0;
                    boolean vBarisPertama = true;
                    while(vArrDataKecamatan.next()){
                        j += 1;
                        if(vBarisPertama){
                            vSbJSON.append("{\"kode\":\""); 
                            vSbJSON.append(vArrDataKecamatan.getString("kode"));
                            vSbJSON.append("\", "); 
                            vSbJSON.append("\"nama\":\"");
                            vSbJSON.append(vArrDataKecamatan.getString("nama"));
                            vSbJSON.append("\""); 
                            vSbJSON.append("}");
                            vBarisPertama = false;
                        }else{
                            vSbJSON.append(","); 
                            vSbJSON.append("{\"kode\":\""); 
                            vSbJSON.append(vArrDataKecamatan.getString("kode"));
                            vSbJSON.append("\", "); 
                            vSbJSON.append("\"nama\":\"");
                            vSbJSON.append(vArrDataKecamatan.getString("nama"));
                            vSbJSON.append("\""); 
                            vSbJSON.append("}");
                        }
                    }
                    vSbJSON.append("]");
                    /* keluaran */
                    vKeluaran = j + "@" + vSbJSON.toString();
                }
            }
        }
        
    
    
    out.println(vKeluaran);
%>