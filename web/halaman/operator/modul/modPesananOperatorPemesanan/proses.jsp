<%@page import="java.time.Instant"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="pilar.cls.ClsKonf" %>
<%@page import="pilar.cls.ClsOlahKata"%>
<%@page import="pilar.cls.ClsBasisdata" %>
<%@page import="pilar.cls.ClsOperasiBasisdata"%>
<%@page import="pilar.cls.ClsOperator" %>
<%@page import="pilar.cls.ClsKode"%>
<%@page import="pilar.cls.ClsCatat"%>

<%@include file="konf.jsp" %>

<% 
    /* ################### memeriksa sesi halaman operator */
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
        vKodeOp = session.getAttribute("sesKodeOp").toString(),
        vTanggal = "",
        vJam = "",
        vTimestamp = "",
        vKeluaran="";
    
    
    if(!vOperasi.equals("")){
        /* ################### operasi tambah data */
        if(vOperasi.equals("t")){
            
        }
        
        /* ################### operasi ubah data */
        if(vOperasi.equals("u")){
            /* variabel POST */
            vKode = oKata.fHapusSpasi(request.getParameter("dtKode").toString());
            
             /* tanggal & jam */
            Date oTanggalKini = new Date();
            SimpleDateFormat oFormatTanggal = new SimpleDateFormat("yyyy-MM-dd");
            SimpleDateFormat oFormatWaktu = new SimpleDateFormat("HH:mm");
    
            vTanggal = oFormatTanggal.format(oTanggalKini);
            vJam = oFormatWaktu.format(oTanggalKini);
            
            /* timestamp */
            //long vUnixTimestamp = Instant.now().getEpochSecond();
            vTimestamp = "";
           /* operasi basisdata */
            if(!vKode.equals("")){
                /* tabel operator pemesanan */
                oOpsBasisdata.fOperasiBdDasar("", 
                    vModKonfNamaBd, 
                    vModKonfNamaTabel, 
                    new String[]{"kode_faktur"}, new String[]{vKode}, 
                    new String[]{"null",
                        "null",
                        vKodeOp,
                        "null",
                        "1",
                        vTanggal,
                        vJam,
                        vTimestamp
                    }, 
                    "u",
                    true);
                
                /* tabel operator juru masak */
                String vKodeOrang = oOpsBasisdata.fAmbilSatuData("", "", "tb_operator_pemesanan", "kode_orang_pelanggan", "kode_faktur", vKode);
                 oOpsBasisdata.fOperasiBdDasar("",
                        vModKonfNamaBd, 
                        "tb_operator_dapur",
                        new String[]{"kode_faktur"}, 
                        new String[]{vKode},
                        new String[]{"null",
                            vKode,
                            "",
                            vKodeOrang,
                            "0",
                            vTanggal,
                            vJam,
                            vTimestamp
                        }, "t",true);
                 
                 /* ubah status pemesanan di faktur */
                 oOpsBasisdata.fOperasiBdDasar("", 
                    vModKonfNamaBd, 
                    "tb_faktur_jual", 
                    new String[]{"kode"}, new String[]{vKode}, 
                    new String[]{"null",
                        "null",
                        "null",
                        "null",
                        "null",
                        "null",
                        "null",
                        "null",
                        "1",
                        "null",
                        "null",
                        "null",
                        "null",
                        "null",
                    }, 
                    "u",
                    true);
                
                int vJumDataTotal = oOpsBasisdata.fJumDataTotalStd("", "", vModKonfNamaTabel, new String[]{"kode_faktur"});
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
        
    }
    
    out.println(vKeluaran);
%>