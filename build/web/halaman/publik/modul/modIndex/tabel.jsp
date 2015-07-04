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
    
    
%>

<% 
    /* obyek olah kata */
    ClsOlahKata oKata = new ClsOlahKata();
    
    String vNamaTabel = vModKonfNamaTabel;
    String vNamaJSON = "data";
    String vGetOffset = request.getParameter("o");
    String vGetJumData = request.getParameter("j");
    
    String vPostJenisProduk = oKata.fHapusSpasi(request.getParameter("dtJenisProduk"));
    String vKolomCari = "nama";
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
    
    /* tidak ada teks cari */
    if(vTeksCari.trim().equals("")){
        /* 1) semua jenis produk */
        if(vPostJenisProduk.equals("menu")){
            /* jumlah data total */
            vJumDataTotal = oOpsBasisdata.fJumDataTotalStd("", 
                    "", 
                    "tb_resto_produk", 
                    new String[]{"kode"}
                    );
            /* keluaran pencarian */
            vArrHasil = oOpsBasisdata.fArrAmbilDataDbStd("", 
                    "", 
                    "tb_resto_produk", 
                    new String[]{"kode","nama","catatan","kode_resto_kategori_produk","kode_resto_jenis_produk","kode_produk_satuan","harga"},
                    "nomor", 
                    vUrutanData, 
                    new String[]{vGetOffset,vGetJumData});
        }else{
            /* jumlah data total */
            vJumDataTotal = oOpsBasisdata.fJumDataTotalKondisi("", 
                    "", 
                    "tb_resto_produk", 
                    new String[]{"kode"},
                    new String[]{"kode_resto_jenis_produk"},
                    new String[]{vPostJenisProduk},
                    "="
                    );
            /* keluaran pencarian */
            vArrHasil = oOpsBasisdata.fArrAmbilDataDbKondisi("", 
                    "", 
                    "tb_resto_produk", 
                    new String[]{"kode","nama","catatan","kode_resto_kategori_produk","kode_resto_jenis_produk","kode_produk_satuan","harga"},
                    new String[]{"kode_resto_jenis_produk",vPostJenisProduk},
                    "nomor", 
                    vUrutanData, 
                    new String[]{vGetOffset,vGetJumData},
                    "=");
            
        }
    }
    
    /* bila ada kata pencarian */
    if(!vTeksCari.trim().equals("")){
        /* 1) semua jenis produk */
        if(vPostJenisProduk.equals("menu")){
            /* jumlah data total */
            vJumDataTotal = oOpsBasisdata.fJumDataTotalKondisiArr("", 
                    "", 
                    "tb_resto_produk", 
                    new String[]{"kode"}, 
                    new String[]{vKolomCari}, 
                    new String[]{vTeksCari}, 
                    new String[]{"%LIKE%"},
                    new String[]{"AND"}
                    );
            /* keluaran pencarian */
            vArrHasil = oOpsBasisdata.fArrAmbilDataDbKondisiArr("", 
                    "", 
                    "tb_resto_produk", 
                    new String[]{"kode","nama","catatan","kode_resto_kategori_produk","kode_resto_jenis_produk","kode_produk_satuan","harga"}, 
                    new String[]{vKolomCari},
                    new String[]{vTeksCari},
                    "nomor", 
                    vUrutanData, 
                    new String[]{vGetOffset,vGetJumData},"%LIKE%");
        }else{
            /* jumlah data total */
            vJumDataTotal = oOpsBasisdata.fJumDataTotalKondisiArr("", 
                    "", 
                    "tb_resto_produk", 
                    new String[]{"kode"}, 
                    new String[]{vKolomCari,"kode_resto_jenis_produk"}, 
                    new String[]{vTeksCari,vPostJenisProduk}, 
                    new String[]{"%LIKE%","="},
                    new String[]{"AND"}
                    );
            /* keluaran pencarian */
            vArrHasil = oOpsBasisdata.fArrAmbilDataDbKondisiArr("", 
                    "", 
                    "tb_resto_produk", 
                    new String[]{"kode","nama","catatan","kode_resto_kategori_produk","kode_resto_jenis_produk","kode_produk_satuan","harga"}, 
                    new String[]{vKolomCari,"kode_resto_jenis_produk"},
                    new String[]{vTeksCari,vPostJenisProduk},
                    "nomor", 
                    vUrutanData, 
                    new String[]{vGetOffset,vGetJumData},"%LIKE%");
        }
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
            
            String vItKodeProduk = vArrHasil.getString("kode");
            String vItHarga =  vArrHasil.getString("harga");
            String vItBerkasFoto = oOpsBasisdata.fAmbilSatuDataKondisiArr("", "", "tb_resto_produk_foto", "nama_berkas", 
                    new String[]{"sampul","kode_resto_produk"},
                    new String[]{"1",vItKodeProduk},
                    new String[]{"=","="},
                    new String[]{"AND"});
            
            String vItEkstensiBerkasFoto = oOpsBasisdata.fAmbilSatuDataKondisiArr("", "", "tb_resto_produk_foto", "ekstensi", 
                    new String[]{"sampul","kode_resto_produk"},
                    new String[]{"1",vItKodeProduk},
                    new String[]{"=","="},
                    new String[]{"AND"});
            
            
            j += 1;
            if(vBarisPertama){
                vSbJSON.append("{\"kode\":\""); 
                vSbJSON.append(vArrHasil.getString("kode"));
                vSbJSON.append("\", "); 
                vSbJSON.append("\"nama\":\"");
                vSbJSON.append(vArrHasil.getString("nama"));
                vSbJSON.append("\", "); 
                vSbJSON.append("\"berkas\":\"");
                vSbJSON.append(vItBerkasFoto);
                vSbJSON.append("\", ");
                vSbJSON.append("\"ekstensi\":\"");
                vSbJSON.append(vItEkstensiBerkasFoto);
                vSbJSON.append("\", ");
                vSbJSON.append("\"harga\":\"");
                vSbJSON.append(vItHarga);
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
                vSbJSON.append(vItBerkasFoto);
                vSbJSON.append("\", ");
                vSbJSON.append("\"ekstensi\":\"");
                vSbJSON.append(vItEkstensiBerkasFoto);
                vSbJSON.append("\", ");
                vSbJSON.append("\"harga\":\"");
                vSbJSON.append(vItHarga);
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
