/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package pilar.servlet.publik;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import pilar.cls.ClsCookie;

/**
 *
 * @author PERSEUS
 */
@WebServlet("/ClsSrvKeranjang")
public class ClsSrvKeranjang extends HttpServlet {

   
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try{
            PrintWriter vPw = response.getWriter();
            String vPOSTOperasi = request.getParameter("dtOperasi");
            String vPOSTKode = request.getParameter("dtKode");
            ClsCookie oCookie = new ClsCookie(request.getCookies(),"produk",24);
            int vPOSTKuantitas = 0;
            
            switch(vPOSTOperasi){
                case "+": /* menambah isi cookie */
                    vPOSTKuantitas = Integer.parseInt(request.getParameter("dtKuantitas"));
                    /* bila semua variabel POST memiliki data */
                    if(!vPOSTOperasi.equals("") && !vPOSTKode.equals("") && vPOSTKuantitas > 0){
                        oCookie.fTambahCookie(vPOSTKode, vPOSTKuantitas, "produk", response);
                        response.setContentType("text/html;charset=UTF-8");
                        //vPw.println(Arrays.toString(oCookie.fIsiCookie()));
                        vPw.println(oCookie.fIsiCookie()[0] + "@" +oCookie.fIsiCookie().length);
                    }
                    break;
                    
                case "-": /* mengurangi isi cookie */
                     /* bila semua variabel POST memiliki data */
                    if(!vPOSTOperasi.equals("") && !vPOSTKode.equals("")){
                        oCookie.fHapusCookie(vPOSTKode, "produk", response);
                        response.setContentType("text/html;charset=UTF-8");
                        //vPw.println(Arrays.toString(oCookie.fIsiCookie()));
                        vPw.println(oCookie.fIsiCookie()[0] + "@" +oCookie.fIsiCookie().length);
                    }
                    break;
                case "*": /* mengubah isi cookie */
                    vPOSTKuantitas = Integer.parseInt(request.getParameter("dtKuantitas"));
                     /* bila semua variabel POST memiliki data */
                    if(!vPOSTOperasi.equals("") && !vPOSTKode.equals("") && vPOSTKuantitas >= 0){
                        if(vPOSTKuantitas > 0 && vPOSTKuantitas < 700){
                            /* hapus */
                            oCookie.fHapusCookie(vPOSTKode, "produk", response);
                            /* tambah */
                            oCookie.fTambahCookie(vPOSTKode, vPOSTKuantitas, "produk", response);
                        }else if(vPOSTKuantitas == 0){
                            /* hapus */
                            oCookie.fHapusCookie(vPOSTKode, "produk", response);
                        }
                        
                        /* kiriman respon */
                        response.setContentType("text/html;charset=UTF-8");
                        vPw.println(oCookie.fIsiCookie()[0] + "@" +oCookie.fIsiCookie().length);
                    }
                    break;
                case "h": /* hapus semua cookie */
                    oCookie.fHapusSemuaCookie("produk", response);
                    break;
            }
            
                
                
            //}
        }catch(Exception e){
            
        }
        
    }

    

}
