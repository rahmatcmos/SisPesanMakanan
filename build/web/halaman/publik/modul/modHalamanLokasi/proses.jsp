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
    
%>

<%
    /* obyek olah kata */
    ClsOlahKata oKata = new ClsOlahKata();
    
    /* obyek basisdata */
    ClsOperasiBasisdata oOpsBasisdata = new ClsOperasiBasisdata();
    
    /* variabel POST */
    String vOperasi = oKata.fHapusSpasi(request.getParameter("dtOperasi").toString()),
        vLintang = "",
        vBujur = "",
        vKodeNegara = "",
        vKodeProvinsi = "",
        vKodeKabupaten = "",
        vKodeOrang = "",
        vCatatan = "",
        vKeluaran="";
    
    if(!vOperasi.equals("")){
        
        /* ################### operasi ubah data */
        if(vOperasi.equals("u")){
            /* variabel POST */
            vKodeOrang = oKata.fHapusSpasi(request.getParameter("dtKodeOrang").toString());
            vLintang = oKata.fHapusSpasi(request.getParameter("dtLintang").toString());
            vBujur = oKata.fHapusSpasi(request.getParameter("dtBujur").toString());
            vCatatan = oKata.fSatuSpasi(request.getParameter("dtCatatan").toString());
            vKodeNegara = oKata.fSatuSpasi(request.getParameter("dtKodeNegara").toString()).substring(0,8); /* kode: 0-8 */
            vKodeProvinsi = oKata.fSatuSpasi(request.getParameter("dtKodeProvinsi").toString()).substring(0,8); /* kode: 0-8 */
            vKodeKabupaten = oKata.fSatuSpasi(request.getParameter("dtKodeKabupaten").toString()).substring(0,8);
            
            /* operasi basisdata */
            if(!vLintang.equals("") && !vBujur.equals("")){
                
                /* periksa apakah data orang tsb sudah ada di basisdata */
                boolean vAdaData = oOpsBasisdata.fDataAda("", "", vModKonfNamaTabel, "kode_orang", vKodeOrang);
                
                if(vAdaData){
                    /* ubah data */
                    oOpsBasisdata.fOperasiBdDasar("", 
                        vModKonfNamaBd, 
                        vModKonfNamaTabel, 
                        new String[]{"kode_orang"}, new String[]{vKodeOrang}, 
                        new String[]{"null","null",vLintang,vBujur,vCatatan,vKodeNegara,vKodeProvinsi,vKodeKabupaten}, 
                        "u",
                        true);

                    int vJumDataTotal = oOpsBasisdata.fJumDataTotalStd("", "", vModKonfNamaTabel, new String[]{"kode_orang"});
                    vKeluaran = Integer.toString(vJumDataTotal);
                    oOpsBasisdata.fTutupKoneksi();
                }else{
                    /* tambah data */
                     oOpsBasisdata.fOperasiBdDasar("", 
                        vModKonfNamaBd, 
                        vModKonfNamaTabel, 
                        new String[]{"kode_orang"}, new String[]{vKodeOrang}, 
                        new String[]{"null",vKodeOrang,vLintang,vBujur,vCatatan,vKodeNegara,vKodeProvinsi,vKodeKabupaten}, 
                        "t",
                        true);

                    int vJumDataTotal = oOpsBasisdata.fJumDataTotalStd("", "", vModKonfNamaTabel, new String[]{"kode_orang"});
                    vKeluaran = Integer.toString(vJumDataTotal);
                    oOpsBasisdata.fTutupKoneksi();
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
        
    }
    
    out.println(vKeluaran);
%>