/* Nama berkas: ClsSrvAdmOtentifikasi.java
 * Fungsi: menangani koneksi aplikasi ke server basisdata
 * Pemrogram: I Made Ariana 
 * Hari,tanggal,jam: Minggu, 01 Maret 2015, 21.56 WIB
 * E-mail: i.made43@ui.ac.id / made.ariana@mail.ugm.ac.id
 */

package pilar.servlet.admin;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Cookie;
import javax.xml.parsers.ParserConfigurationException;
import org.w3c.dom.DOMException;
import org.xml.sax.SAXException;
import pilar.cls.ClsCatat;
import pilar.cls.ClsKonf;
import pilar.cls.ClsOperasiBasisdataOri;
import pilar.cls.ClsSHA;

//@WebServlet(name = "ClsSrvAdmOtentifikasi", urlPatterns = {"/clsOtentifikasi"})
public class ClsSrvAdmOtentifikasi extends HttpServlet {

    /* doGET */
    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException{
            /* jenis dokumen */
            response.setContentType("text/html");		
            //vPw = response.getWriter();		
            //vPw.println("doGet");
    }
	
    /* doPOST */
    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response){
        
        try {                    
            ClsSHA oSHA = new ClsSHA();
            PrintWriter vPw = response.getWriter();

            /* data POST */
            String vNamaDB = null;
            String vSandiDB = null;
            String vSesCaptcha = null;     
            
            /* nilai variabel POST */		
            String vNama = oSHA.fSHA256(request.getParameter("dtNama").trim());
            String vSandi = oSHA.fSHA256(request.getParameter("dtSandi").trim());
            String vKode = request.getParameter("dtKode").trim();	

            /* membuat sesi captcha */
            HttpSession session = request.getSession(true);	
            vSesCaptcha = session.getAttribute("sesCaptcha").toString().trim();	

            /* mengambil data nama dan sandi */
            ClsOperasiBasisdataOri oOpsBasisdata = new ClsOperasiBasisdataOri();

            ResultSet vArrHasil = oOpsBasisdata.fArrAmbilDataDbStd("","", 
                "tb_admin", new String[]{"nama","sandi"}, "nomor", "", new String[]{"0","1"});

            /* keluaran permintaan */
            while(vArrHasil.next()){
                vNamaDB = vArrHasil.getString("nama");
                vSandiDB = vArrHasil.getString("sandi");
            }			

            /* mencocokkan data */
            if (vNama != null && vNamaDB !=null && vSandi != null && vSandiDB != null) {
                /* sebelum divalidasi */
                //vPw.println("Belum divalidasi : " + vNama + " = " + vNamaDB + " & " + vSandi + " = " + vSandiDB);			

                /* apabila data post sesuai dgn data dalam tabel basisdata */
                if(vNama.equals(vNamaDB) && vSandi.equals(vSandiDB) && vKode.equals(vSesCaptcha)){
                    /* memberi nilai pada sesi */
                    request.getSession().setAttribute("sesID", vNamaDB);
                    request.getSession().setAttribute("sesSandi", vSandiDB);

                    /* memberi nilai pada cookie */
                    Cookie ckiNama = new Cookie("ckiNama", vNamaDB);
                    ckiNama.setMaxAge(60*60*24*7); 

                    Cookie ckiSandi = new Cookie("ckiSandi", vSandiDB);
                    ckiSandi.setMaxAge(60*60*24*7);

                    /* kirim cookie ke browser */
                    response.addCookie(ckiNama);
                    response.addCookie(ckiSandi);

                    /* tipe kandungan respon: text/html */
                    response.setContentType("text/html");
                    vPw.println("1");
                    //vPw.println("Id dan sandi Anda benar: " + vNamaDB + " & " + vSandiDB);
                    //response.sendRedirect("halaman/admin/modul/sistem/index.jsp");
                }else if(vNama.equals(vNamaDB) && vSandi.equals(vSandiDB) && !vKode.equals(vSesCaptcha)) {
                    response.setContentType("text/html");
                    //String pathToWeb = getServletContext().getRealPath(File.separator);
                    vPw.println("2");
                    //vPw.println("Maaf, Id dan sandi Anda salah!");
                }else{
                    response.setContentType("text/html");
                    //String pathToWeb = getServletContext().getRealPath(File.separator);
                    vPw.println("0");
                    //vPw.println("Maaf, Id dan sandi Anda salah!");
                    //vPw.println("Id dan sandi Anda benar: " + vNama + " & " + vNamaDB + " # " + vSandi + " & " + vSandiDB);
                }				
            } 			

        }catch(Exception e) {
            /* pencatatan sistem */
            if(ClsKonf.vKonfCatatSistem == true){
                String vNamaKelas = "ClsSrvAdmOtentifikasi.java";
                String vNamaMetode = "doPost";
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
